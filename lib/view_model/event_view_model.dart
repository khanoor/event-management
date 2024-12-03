import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventProvider with ChangeNotifier {
  List<Map<String, String>> _events = [];

  List<Map<String, String>> get events => _events;

  Future<void> loadEventData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? eventNames = prefs.getStringList('eventNames');
    List<String>? eventDescriptions = prefs.getStringList('eventDescriptions');
    List<String>? eventYears = prefs.getStringList('eventYears');
    List<String>? eventMonths = prefs.getStringList('eventMonths');
    List<String>? eventDates = prefs.getStringList('eventDates');

    if (eventNames != null &&
        eventDescriptions != null &&
        eventYears != null &&
        eventMonths != null &&
        eventDates != null) {
      _events = List.generate(eventNames.length, (index) {
        return {
          'eventName': eventNames[index],
          'eventDescription': eventDescriptions[index],
          'selectedYear': eventYears[index],
          'selectedMonth': eventMonths[index],
          'selectedDate': eventDates[index],
        };
      });
    }

    notifyListeners();
  }

  Future<void> saveEventData(String name, String description, String year,
      String month, String date) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> eventNames = prefs.getStringList('eventNames') ?? [];
    List<String> eventDescriptions =
        prefs.getStringList('eventDescriptions') ?? [];
    List<String> eventYears = prefs.getStringList('eventYears') ?? [];
    List<String> eventMonths = prefs.getStringList('eventMonths') ?? [];
    List<String> eventDates = prefs.getStringList('eventDates') ?? [];

    eventNames.add(name);
    eventDescriptions.add(description);
    eventYears.add(year);
    eventMonths.add(month);
    eventDates.add(date);

    await prefs.setStringList('eventNames', eventNames);
    await prefs.setStringList('eventDescriptions', eventDescriptions);
    await prefs.setStringList('eventYears', eventYears);
    await prefs.setStringList('eventMonths', eventMonths);
    await prefs.setStringList('eventDates', eventDates);

    _events.add({
      'eventName': name,
      'eventDescription': description,
      'selectedYear': year,
      'selectedMonth': month,
      'selectedDate': date,
    });

    notifyListeners();
  }
}
