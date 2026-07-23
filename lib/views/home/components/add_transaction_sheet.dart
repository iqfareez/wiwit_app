import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../shared/models/wiwit_api/categories/category_response.dart';
import '../../../shared/models/wiwit_api/enums.dart';
import '../../../shared/models/wiwit_api/transactions/add_transaction_request.dart';
import '../../../shared/providers/chopper_provider.dart';

/// The UI for adding transaction record
class AddTransactionSheet extends ConsumerStatefulWidget {
  const AddTransactionSheet({super.key, required this.onSaved});

  final VoidCallback onSaved;

  @override
  ConsumerState<AddTransactionSheet> createState() =>
      _AddTransactionSheetState();
}

class _AddTransactionSheetState extends ConsumerState<AddTransactionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  late final Future<List<CategoryResponse>> _categories;
  var _type = TransactionType.expense;
  int? _categoryId;
  var _date = DateTime.now();
  var _isSaving = false;

  @override
  void initState() {
    super.initState();
    _categories = _loadCategories();
  }

  Future<List<CategoryResponse>> _loadCategories() async {
    final response = await ref
        .read(categoryServiceProvider)
        .getCategories(perPage: 100);
    if (!response.isSuccessful) {
      // TODO: Add toast says fetch categories failed
      return [];
    }
    return response.body?.data ?? [];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      setState(() => _date = selectedDate);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final response = await ref
        .read(transactionServiceProvider)
        .createTransaction(
          AddTransactionRequest(
            title: _titleController.text.trim(),
            amount: double.parse(_amountController.text.trim()),
            type: _type,
            categoryId: _categoryId,
            notes: _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim(),
            transactionDate: _date,
          ),
        );

    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _isSaving = false);

    if (response.isSuccessful) {
      widget.onSaved();
      Navigator.pop(context);
      messenger.showSnackBar(
        const SnackBar(content: Text('Transaction added.')),
      );
      return;
    }

    messenger.showSnackBar(
      SnackBar(
        content: Text('Could not add transaction (${response.statusCode}).'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isIncome = _type == TransactionType.income;
    final isToday = DateUtils.isSameDay(_date, DateTime.now());
    final inputDecoration = InputDecoration(
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 0),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(28)),
      fillColor: colorScheme.secondaryContainer,
      filled: true,
    );

    return SafeArea(
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
                    const Expanded(
                      child: Text(
                        'Add transaction',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _isSaving
                          ? null
                          : () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
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
                      width: 160,
                      child: TextFormField(
                        controller: _amountController,
                        enabled: !_isSaving,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '0.00',
                          hintStyle: TextStyle(
                            color: colorScheme.outlineVariant,
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        validator: (value) {
                          final amount = double.tryParse(value?.trim() ?? '');
                          return amount == null || amount <= 0
                              ? 'Enter an amount greater than zero.'
                              : null;
                        },
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
                const Gap(12),
                FutureBuilder<List<CategoryResponse>>(
                  future: _categories,
                  builder: (context, snapshot) {
                    final categories = snapshot.data ?? [];
                    return DropdownButtonFormField<int>(
                      key: ValueKey(_categoryId),
                      initialValue: _categoryId,
                      isExpanded: true,
                      decoration: inputDecoration.copyWith(
                        labelText: 'Category (optional)',
                        hintText:
                            snapshot.connectionState == ConnectionState.waiting
                            ? 'Loading categories...'
                            : 'Select a category',
                        suffixIcon: _categoryId == null
                            ? null
                            : IconButton(
                                onPressed: _isSaving
                                    ? null
                                    : () => setState(() => _categoryId = null),
                                icon: const Icon(Icons.clear),
                                tooltip: 'Clear category',
                              ),
                      ),
                      items: categories
                          .map(
                            (category) => DropdownMenuItem(
                              value: category.id,
                              child: Text(category.name),
                            ),
                          )
                          .toList(),
                      onChanged: _isSaving || categories.isEmpty
                          ? null
                          : (value) => setState(() => _categoryId = value),
                    );
                  },
                ),
                const Gap(12),
                TextFormField(
                  controller: _notesController,
                  enabled: !_isSaving,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 2,
                  decoration: inputDecoration.copyWith(
                    labelText: 'Notes (optional)',
                  ),
                ),
                const Gap(12),
                OutlinedButton.icon(
                  onPressed: _isSaving ? null : _pickDate,
                  icon: const Icon(Icons.calendar_today_outlined),
                  label: Text(
                    isToday
                        ? 'Today'
                        : '${_date.day.toString().padLeft(2, '0')}/${_date.month.toString().padLeft(2, '0')}/${_date.year}',
                  ),
                ),
                const Gap(24),
                FilledButton(
                  onPressed: _isSaving ? null : _save,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
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
                      : Text('Add ${isIncome ? 'income' : 'expense'}'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
