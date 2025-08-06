import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:paypact/presentation/widgets/custom_container.dart';

import '../../widgets/custom_date_time_picker.dart';
import '../../widgets/custom_textfield.dart';

class AddExpenseScreen extends HookConsumerWidget {
  const AddExpenseScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseDescriptionController = useTextEditingController();
    final amountController = useTextEditingController();
    final paidByController = useTextEditingController();
    final splitController = useTextEditingController();
    final expenseDate = useState<DateTime?>(null);

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomContainer(
              radius: 30,
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  spacing: 15,
                  children: [
                    Text(
                      'Add an Expense',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: CustomTextField(
                        hintText: '₹ 0.00',
                        controller: amountController,
                      ),
                    ),
                    CustomTextField(
                      hintText: 'Enter a Description',
                      controller: expenseDescriptionController,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.creditcard_fill,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Paid by',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomTextField(
                controller: paidByController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.person_2_fill,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Split',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomTextField(
                controller: splitController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.calendar,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Details',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: expenseDate.value ?? DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) expenseDate.value = date;
                    },
                    child: SizedBox(
                      width: 160,
                      child: CustomDateTimePicker(
                        selectedDate: expenseDate.value != null
                            ? DateFormat('dd MMM, yyyy').format(expenseDate.value!)
                            : DateFormat('dd MMM, yyyy').format(DateTime.now()),
                      ),
                    ),
                  ),
                  CustomContainer(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Column(
                        children: [
                          Icon(
                            CupertinoIcons.doc_fill,
                            size: 20,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Add Note',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomContainer(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Column(
                        children: [
                          Icon(
                            CupertinoIcons.photo_fill,
                            size: 20,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Add image',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
