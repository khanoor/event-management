import 'package:flutter/foundation.dart';

class DateViewModel with ChangeNotifier {
  String _selectedYear = "Select Year";
  String _selectedMonth = "Select Month";
  DateTime? _selectedDate;

  String get selectedYear => _selectedYear;
  String get selectedMonth => _selectedMonth;
  DateTime? get selectedDate => _selectedDate;

  void updateYear(String year) {
    _selectedYear = year;
    notifyListeners();
  }

  void updateMonth(String month) {
    _selectedMonth = month;
    notifyListeners();
  }

  void updateDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }
}
