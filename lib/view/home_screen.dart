import 'package:event_management/global/app_color.dart';
import 'package:event_management/global/custome_button.dart';
import 'package:event_management/global/day_cell_widget.dart';
import 'package:event_management/view/create_event_screen.dart';
import 'package:event_management/view_model/date_view_model.dart';
import 'package:event_management/view_model/event_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<EventProvider>(context, listen: false).loadEventData();
  }

  @override
  Widget build(BuildContext context) {
    final dateProvider = Provider.of<DateViewModel>(context);
    final isDateSelected = dateProvider.selectedYear.isNotEmpty &&
        dateProvider.selectedMonth.isNotEmpty;
    final eventProvider = Provider.of<EventProvider>(context);
    final isEventAvailable = eventProvider.events.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Date',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColor.whiteColor),
        ),
        centerTitle: true,
        backgroundColor: AppColor.tealColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  title: dateProvider.selectedYear.isEmpty
                      ? 'Select Year'
                      : dateProvider.selectedYear,
                  onPressed: () => _showYearSelector(context),
                ),
                CustomButton(
                  title: dateProvider.selectedMonth.isEmpty
                      ? 'Select Month'
                      : dateProvider.selectedMonth,
                  onPressed: () => _showMonthSelector(context),
                ),
              ],
            ),
          ),
          if (!isDateSelected)
            const Center(
              child: Icon(Icons.calendar_today,
                  size: 100, color: AppColor.tealColor),
            ),
          if (isDateSelected)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildCalendar(dateProvider.selectedYear,
                    dateProvider.selectedMonth, dateProvider),
              ),
            ),
          if (!isEventAvailable)
            const Center(
              child: Text('No Event Available', style: TextStyle(fontSize: 18)),
            ),
          if (isEventAvailable)
            Expanded(
              child: ListView.builder(
                itemCount: eventProvider.events.length,
                itemBuilder: (BuildContext context, int index) {
                  final event = eventProvider.events[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 4.0,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text(
                        event['eventName'] ?? '',
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${event['selectedDate'] ?? ''} ${event['selectedMonth'] ?? ''} ${event['selectedYear'] ?? ''} ',
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  void _showYearSelector(BuildContext context) {
    final dateProvider = Provider.of<DateViewModel>(context, listen: false);

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              final year = 2016 + index;
              return ListTile(
                title: Text(
                  year.toString(),
                  style: const TextStyle(fontSize: 16),
                ),
                onTap: () {
                  dateProvider.updateYear(year.toString());
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }

  void _showMonthSelector(BuildContext context) {
    final months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];

    final dateProvider = Provider.of<DateViewModel>(context, listen: false);

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: ListView.builder(
            itemCount: months.length,
            itemBuilder: (context, index) {
              final month = months[index];
              return ListTile(
                title: Text(
                  month,
                  style: const TextStyle(fontSize: 16),
                ),
                onTap: () {
                  dateProvider.updateMonth(month);
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }

  int _getMonthIndex(String month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return months.indexOf(month) + 1;
  }

  Widget _buildCalendar(String year, String month, DateViewModel dateProvider) {
    final int monthIndex = _getMonthIndex(month);

    try {
      final firstDayOfMonth = DateTime(int.parse(year), monthIndex, 1);
      final lastDayOfMonth = DateTime(int.parse(year), monthIndex + 1, 0);

      final List<int> daysInMonth =
          List.generate(lastDayOfMonth.day, (index) => index + 1);

      final startDayOfWeek = firstDayOfMonth.weekday;

      final List<int?> calendarDays =
          List<int?>.filled(startDayOfWeek - 1, null) +
              daysInMonth.map((e) => e as int?).toList();

      return Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DayOfWeekCell("Mon"),
              DayOfWeekCell("Tue"),
              DayOfWeekCell("Wed"),
              DayOfWeekCell("Thu"),
              DayOfWeekCell("Fri"),
              DayOfWeekCell("Sat"),
              DayOfWeekCell("Sun"),
            ],
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: calendarDays.length,
              itemBuilder: (context, index) {
                final day = calendarDays[index];
                if (day == null) {
                  return const SizedBox.shrink();
                }
                return GestureDetector(
                  onTap: () {
                    if (dateProvider.selectedMonth.toString() ==
                        "Select Month") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select month'),
                          backgroundColor: AppColor.redColor,
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateEventScreen(
                            selectedYear: dateProvider.selectedYear,
                            selectedMonth: dateProvider.selectedMonth,
                            selectedDate: day.toString(),
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.tealColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        day.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColor.whiteColor,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    } catch (e) {
      return const Center(child: Text('Please Select Year and month'));
    }
  }
}
