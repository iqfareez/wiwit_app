import 'package:flutter_test/flutter_test.dart';
import 'package:wiwit_app/shared/utils/format_utils.dart';

void main() {
  group('money format', () {
    test('formats cents with two decimals', () {
      expect(formatAmount(0), '0.00');
      expect(formatAmount(5), '0.05');
      expect(formatAmount(50), '0.50');
      expect(formatAmount(300), '3.00');
      expect(formatAmount(11324), '113.24');
    });

    test('groups thousands', () {
      expect(formatAmount(123456), '1,234.56');
      expect(formatAmount(100000000), '1,000,000.00');
      expect(formatAmount(999999999), '9,999,999.99');
    });

    test('reads the amounts the API sends as cents', () {
      expect(parseAmountInCents('3'), 300);
      expect(parseAmountInCents('3.5'), 350);
      expect(parseAmountInCents('3.00'), 300);
      expect(parseAmountInCents('113.24'), 11324);
    });

    test('rounds past binary floating point drift', () {
      // 19.99 * 100 lands just under 1999 in doubles.
      expect(parseAmountInCents('19.99'), 1999);
      expect(parseAmountInCents('0.29'), 29);
    });

    test('falls back to zero for amounts it cannot read', () {
      expect(parseAmountInCents(''), 0);
      expect(parseAmountInCents('RM 3.00'), 0);
    });

    test('survives a round trip', () {
      expect(formatAmount(parseAmountInCents('113.24')), '113.24');
      expect(formatAmount(parseAmountInCents('1234.5')), '1,234.50');
    });
  });

  group('long date format', () {
    test('spells out weekday and month', () {
      expect(formatLongDate(DateTime(2026, 7, 29)), 'Wed, 29 Jul 2026');
      expect(formatLongDate(DateTime(2026, 12, 25)), 'Fri, 25 Dec 2026');
    });
  });

  group('date format', () {
    test('pads day and month', () {
      expect(formatDate(DateTime(2026, 7, 9)), '09/07/2026');
      expect(formatDate(DateTime(2026, 12, 25)), '25/12/2026');
    });

    test('ignores the time of day', () {
      expect(formatDate(DateTime(2026, 7, 9, 23, 59)), '09/07/2026');
    });

    test('names today and yesterday', () {
      final now = DateTime.now();

      expect(formatRelativeDate(now), 'Today');
      expect(
        formatRelativeDate(now.subtract(const Duration(days: 1))),
        'Yesterday',
      );
    });

    test('falls back to the plain date for anything further out', () {
      final twoDaysAgo = DateTime.now().subtract(const Duration(days: 2));

      expect(formatRelativeDate(twoDaysAgo), formatDate(twoDaysAgo));
      expect(formatRelativeDate(DateTime(2020, 1, 5)), '05/01/2020');
    });
  });
}
