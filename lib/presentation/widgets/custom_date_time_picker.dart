import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

class CustomDateTimePicker extends StatelessWidget {
  const CustomDateTimePicker({
    super.key,
    required this.selectedDate,
  });

  final String selectedDate;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color shadowColor = isDarkMode ? Colors.black54 : Colors.white;
    Color lightShadow = isDarkMode ? Colors.black38 : Colors.grey.shade400;

    final bool hasValidDate = selectedDate.trim() != 'Select Start Date' && selectedDate.trim() != 'Select End Date';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      decoration: BoxDecoration(
        color: isDarkMode ? Theme.of(context).cardColor : const Color(0xFFE7EBF0),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: lightShadow,
            offset: const Offset(2.5, 2.5),
            blurRadius: 5,
            inset: hasValidDate,
          ),
          BoxShadow(
            color: shadowColor,
            offset: const Offset(-2.5, -2.5),
            blurRadius: 5,
            inset: hasValidDate,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          selectedDate,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
