import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../shared/components/confirm_dialog.dart';
import '../../../shared/models/wiwit_api/categories/category_response.dart';
import '../../../shared/models/wiwit_api/enums.dart';
import '../../../shared/models/wiwit_api/transactions/add_transaction_request.dart';
import '../../../shared/models/wiwit_api/transactions/transaction_response.dart';
import '../../../shared/providers/chopper_provider.dart';
import '../../../shared/utils/format_utils.dart';
import 'section_label.dart';

/// The UI for adding or editing a [transaction] record
class TransactionFormSheet extends ConsumerStatefulWidget {
  const TransactionFormSheet({
    super.key,
    required this.onSaved,
    this.transaction,
  });

  final VoidCallback onSaved;

  /// The record being edited, or null when adding a new one.
  final TransactionResponse? transaction;

  @override
  ConsumerState<TransactionFormSheet> createState() =>
      _TransactionFormSheetState();
}

class _TransactionFormSheetState extends ConsumerState<TransactionFormSheet> {
  /// How many category chips stay in front of the "Show all" chip.
  static const _topCategoryCount = 4;

  /// How far back we look to work out which categories are used the most.
  static const _usageSampleSize = 100;

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  late final Future<List<CategoryResponse>> _categories;
  late final DateTime _today;
  late final int _initialAmountInCents;
  late final DateTime _initialDate;
  late DateTime _date;
  var _type = TransactionType.expense;
  int? _categoryId;
  var _showAllCategories = false;
  var _showNotes = false;
  var _isSaving = false;

  bool get _isEditing => widget.transaction != null;

  @override
  void initState() {
    super.initState();
    _today = DateUtils.dateOnly(DateTime.now());
    _categories = _loadCategories();

    final transaction = widget.transaction;
    _initialAmountInCents = transaction == null
        ? 0
        : parseAmountInCents(transaction.amount);
    _initialDate = transaction == null
        ? _today
        : DateUtils.dateOnly(transaction.transactionDate);
    _date = _initialDate;

    if (transaction == null) return;

    // Editing starts from what is already there, so the sheet reads as the
    // record itself rather than a blank form.
    _titleController.text = transaction.title;
    _amountController.text = formatAmount(_initialAmountInCents);
    _notesController.text = transaction.notes ?? '';
    _type = transaction.type;
    _categoryId = transaction.category?.id;
    _showNotes = _notesController.text.trim().isNotEmpty;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  /// Amount is typed right to left, so the field only ever holds whole cents.
  int get _amountInCents {
    final digits = _amountController.text.replaceAll(RegExp(r'\D'), '');
    return digits.isEmpty ? 0 : int.parse(digits);
  }

  /// Whether there is anything worth warning about before closing.
  bool get _hasUnsavedChanges {
    final transaction = widget.transaction;

    if (transaction == null) {
      return _amountInCents > 0 ||
          _titleController.text.trim().isNotEmpty ||
          _notesController.text.trim().isNotEmpty ||
          _categoryId != null ||
          _date != _today ||
          _type != TransactionType.expense;
    }

    return _amountInCents != _initialAmountInCents ||
        _titleController.text.trim() != transaction.title ||
        _notesController.text.trim() != (transaction.notes ?? '').trim() ||
        _categoryId != transaction.category?.id ||
        _date != _initialDate ||
        _type != transaction.type;
  }

  /// Loads the categories, most used first, so the chips in front of
  /// "Show all" are the ones the user actually reaches for.
  /// TODO: improvement oppurtunity for the api provide the amount
  Future<List<CategoryResponse>> _loadCategories() async {
    final (categoryResponse, transactionResponse) = await (
      ref.read(categoryServiceProvider).getCategories(perPage: 100),
      ref
          .read(transactionServiceProvider)
          .getTransactions(perPage: _usageSampleSize),
    ).wait;

    if (!categoryResponse.isSuccessful) {
      // TODO: Add toast says fetch categories failed
      return [];
    }

    final categories = [...?categoryResponse.body?.data];
    final usageCount = <int, int>{};

    // A failed lookup only costs us the ordering, so the chips still show.
    if (transactionResponse.isSuccessful) {
      final transactions =
          transactionResponse.body?.data ?? const <TransactionResponse>[];
      for (final transaction in transactions) {
        final categoryId = transaction.category?.id;
        if (categoryId == null) continue;

        usageCount[categoryId] = (usageCount[categoryId] ?? 0) + 1;
      }
    }

    categories.sort((first, second) {
      final byUsage = (usageCount[second.id] ?? 0).compareTo(
        usageCount[first.id] ?? 0,
      );

      return byUsage != 0 ? byUsage : first.name.compareTo(second.name);
    });

    return categories;
  }

  /// The chips to render while collapsed, keeping any selection made from the
  /// full list in view.
  List<CategoryResponse> _visibleCategories(List<CategoryResponse> categories) {
    if (_showAllCategories || categories.length <= _topCategoryCount) {
      return categories;
    }

    final visible = categories.take(_topCategoryCount).toList();
    final selectedIndex = categories.indexWhere(
      (category) => category.id == _categoryId,
    );
    if (selectedIndex >= _topCategoryCount) {
      visible
        ..removeLast()
        ..add(categories[selectedIndex]);
    }

    return visible;
  }

  Future<void> _pickDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: _today,
    );
    if (selectedDate != null) {
      setState(() => _date = DateUtils.dateOnly(selectedDate));
    }
  }

  /// Closing is the cancel action now, so anything typed gets a confirmation.
  Future<void> _confirmClose() async {
    if (_isSaving) return;

    if (!_hasUnsavedChanges) {
      Navigator.pop(context);
      return;
    }

    final discarded = await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmDialog(
        title: _isEditing ? 'Discard changes?' : 'Discard transaction?',
        message: 'What you entered will not be saved.',
        confirmLabel: 'Discard',
        action: () async {},
      ),
    );

    if (!mounted || discarded != true) return;

    Navigator.pop(context);
  }

  /// Creates or updates, depending on how the sheet was opened, and reports
  /// back only what the sheet needs to know.
  Future<({bool isSuccessful, int statusCode})> _submit(
    AddTransactionRequest request,
  ) async {
    final service = ref.read(transactionServiceProvider);
    final transaction = widget.transaction;

    if (transaction == null) {
      final response = await service.createTransaction(request);

      return (
        isSuccessful: response.isSuccessful,
        statusCode: response.statusCode,
      );
    }

    // Sending the create payload keeps the field names in one place, and it
    // clears whatever the user emptied out.
    final response = await service.updateTransaction(
      transaction.id,
      request.toJson(),
    );

    return (
      isSuccessful: response.isSuccessful,
      statusCode: response.statusCode,
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final notes = _notesController.text.trim();
    final result = await _submit(
      AddTransactionRequest(
        title: _titleController.text.trim(),
        amount: _amountInCents / 100,
        type: _type,
        categoryId: _categoryId,
        notes: notes.isEmpty ? null : notes,
        transactionDate: _date,
      ),
    );

    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _isSaving = false);

    if (result.isSuccessful) {
      widget.onSaved();
      Navigator.pop(context);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            _isEditing ? 'Transaction updated.' : 'Transaction added.',
          ),
        ),
      );
      return;
    }

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          'Could not ${_isEditing ? 'update' : 'add'} transaction '
          '(${result.statusCode}).',
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return FutureBuilder<List<CategoryResponse>>(
      future: _categories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(
            'Loading categories...',
            style: TextStyle(color: Theme.of(context).colorScheme.outline),
          );
        }

        final categories = snapshot.data ?? [];
        if (categories.isEmpty) {
          return Text(
            'No categories yet.',
            style: TextStyle(color: Theme.of(context).colorScheme.outline),
          );
        }

        return AnimatedSize(
          alignment: Alignment.topCenter,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: Wrap(
            spacing: 8,
            children: [
              for (final category in _visibleCategories(categories))
                ChoiceChip(
                  label: Text(category.name),
                  selected: _categoryId == category.id,
                  onSelected: _isSaving
                      ? null
                      : (selected) => setState(
                          () => _categoryId = selected ? category.id : null,
                        ),
                ),
              if (categories.length > _topCategoryCount)
                ActionChip(
                  avatar: Icon(
                    _showAllCategories ? Icons.expand_less : Icons.expand_more,
                  ),
                  label: Text(_showAllCategories ? 'Show less' : 'Show all'),
                  onPressed: _isSaving
                      ? null
                      : () => setState(
                          () => _showAllCategories = !_showAllCategories,
                        ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDateChips() {
    final yesterday = _today.subtract(const Duration(days: 1));
    final isToday = _date == _today;
    final isYesterday = _date == yesterday;
    final isPickedDate = !isToday && !isYesterday;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ChoiceChip(
          label: const Text('Today'),
          selected: isToday,
          onSelected: _isSaving ? null : (_) => setState(() => _date = _today),
        ),
        ChoiceChip(
          label: const Text('Yesterday'),
          selected: isYesterday,
          onSelected: _isSaving
              ? null
              : (_) => setState(() => _date = yesterday),
        ),
        ChoiceChip(
          // Icon only until a date is picked, then it doubles as the readout.
          label: isPickedDate
              ? Text(formatDate(_date))
              : const Icon(Icons.calendar_today_outlined, size: 18),
          selected: isPickedDate,
          showCheckmark: false,
          tooltip: 'Pick another date',
          onSelected: _isSaving ? null : (_) => _pickDate(),
        ),
      ],
    );
  }

  Widget _buildNotesField(InputDecoration inputDecoration) {
    if (!_showNotes) {
      return Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: _isSaving ? null : () => setState(() => _showNotes = true),
          icon: const Icon(Icons.notes_outlined),
          label: const Text('Add notes'),
        ),
      );
    }

    return TextFormField(
      controller: _notesController,
      enabled: !_isSaving,
      // Editing opens with notes already filled in, so stealing focus there
      // would just cover the sheet with the keyboard.
      autofocus: !_isEditing,
      textCapitalization: TextCapitalization.sentences,
      maxLines: 2,
      decoration: inputDecoration.copyWith(
        labelText: 'Notes (optional)',
        suffixIcon: IconButton(
          onPressed: _isSaving
              ? null
              : () => setState(() {
                  _notesController.clear();
                  _showNotes = false;
                }),
          icon: const Icon(Icons.close),
          tooltip: 'Remove notes',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isIncome = _type == TransactionType.income;
    final inputDecoration = InputDecoration(
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 0),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(28)),
      fillColor: colorScheme.secondaryContainer,
      filled: true,
    );

    return PopScope(
      // Tapping outside and the back gesture both route through the
      // confirmation instead of dropping what was typed.
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;

        _confirmClose();
      },
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            12,
            24,
            24 + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  const Gap(20),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _isEditing ? 'Edit transaction' : 'Add transaction',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      FilledButton(
                        onPressed: _isSaving ? null : _save,
                        style: FilledButton.styleFrom(
                          backgroundColor: isIncome
                              ? colorScheme.primary
                              : colorScheme.secondary,
                        ),
                        child: _isSaving
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colorScheme.onPrimary,
                                ),
                              )
                            : const Text('Save'),
                      ),
                    ],
                  ),
                  const Gap(16),
                  SegmentedButton<TransactionType>(
                    segments: const [
                      ButtonSegment(
                        value: TransactionType.expense,
                        label: Text('Expense'),
                        icon: Icon(Icons.arrow_upward),
                      ),
                      ButtonSegment(
                        value: TransactionType.income,
                        label: Text('Income'),
                        icon: Icon(Icons.arrow_downward),
                      ),
                    ],
                    selected: {_type},
                    onSelectionChanged: _isSaving
                        ? null
                        : (value) => setState(() => _type = value.first),
                  ),
                  const Gap(16),
                  Text(
                    'Amount',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'RM',
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Gap(8),
                      SizedBox(
                        width: 180,
                        child: TextFormField(
                          controller: _amountController,
                          enabled: !_isSaving,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                          ),
                          keyboardType: TextInputType.number,
                          // Digits land in the cents column first, so "300"
                          // reads as 3.00.
                          inputFormatters: const [_AmountInputFormatter()],
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '0.00',
                            hintStyle: TextStyle(
                              color: colorScheme.outlineVariant,
                              fontSize: 36,
                              fontWeight: FontWeight.w700,
                            ),
                            errorStyle: const TextStyle(height: 1.2),
                          ),
                          validator: (_) => _amountInCents <= 0
                              ? 'Enter an amount greater than zero.'
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const Gap(12),
                  TextFormField(
                    controller: _titleController,
                    enabled: !_isSaving,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: inputDecoration.copyWith(
                      labelText: 'Title',
                      hintText: 'e.g. Lunch, Coffee, etc',
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Enter a title.'
                        : null,
                  ),
                  const Gap(16),
                  SectionLabel(label: 'Category (optional)'),
                  _buildCategoryChips(),
                  const Gap(16),
                  SectionLabel(label: 'Date'),
                  _buildDateChips(),
                  const Gap(8),
                  _buildNotesField(inputDecoration),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Fills the amount from the right, so every keystroke pushes the digits up a
/// column: `3` is 0.03, `30` is 0.30, `300` is 3.00.
class _AmountInputFormatter extends TextInputFormatter {
  const _AmountInputFormatter();

  static const _maxDigits = 9;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text
        .replaceAll(RegExp(r'\D'), '')
        .replaceFirst(RegExp('^0+'), '');

    if (digits.isEmpty) return const TextEditingValue();
    if (digits.length > _maxDigits) return oldValue;

    final text = formatAmount(int.parse(digits));

    // The caret belongs at the end, since typing only ever appends.
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
