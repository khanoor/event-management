import 'package:event_management/global/app_color.dart';
import 'package:flutter/material.dart';

class DayOfWeekCell extends StatelessWidget {
  final String dayName;
  const DayOfWeekCell(this.dayName);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          dayName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColor.blackColor,
          ),
        ),
      ),
    );
  }
}
