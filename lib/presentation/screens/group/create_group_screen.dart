import 'package:flutter/cupertino.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:paypact/core/extensions/context_extensions.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../core/constants/theme_constants.dart';
import '../../../domain/entities/group_entity.dart';
import '../../state/group_notifier.dart';
import '../../widgets/custom_date_time_picker.dart';
import '../../widgets/custom_textfield.dart';

class CreateGroupScreen extends HookConsumerWidget {
  const CreateGroupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupNameController = useTextEditingController();
    final selectedType = useState<GroupType>(GroupType.none);
    final tripDatesEnabled = useState(false);
    final startDate = useState<DateTime?>(null);
    final endDate = useState<DateTime?>(null);
    final isLoading = useState(false);
    final formKey = GlobalKey<FormState>();
    final themeConstants = ThemeConstants(context);

    Future<void> submit() async {
      if (!formKey.currentState!.validate()) {
        context.showSnackBar('Please enter a valid group name');
        return;
      }

      if (selectedType.value == GroupType.trip &&
          tripDatesEnabled.value &&
          (startDate.value == null || endDate.value == null)) {
        context.showSnackBar('Please select both start and end dates for the trip');
        return;
      }

      final currentUser = FirebaseConstants.currentUser;
      if (currentUser == null) return;

      isLoading.value = true;

      await ref
          .read(groupNotifierProvider.notifier)
          .createGroup(
            name: groupNameController.text,
            type: selectedType.value,
            createdBy: currentUser.uid,
            startDate: tripDatesEnabled.value ? startDate.value : null,
            endDate: tripDatesEnabled.value ? endDate.value : null,
          );

      // Clear values
      groupNameController.clear();
      selectedType.value = GroupType.none;
      tripDatesEnabled.value = false;
      startDate.value = null;
      endDate.value = null;
      isLoading.value = false;

      if (context.mounted) {
        context.showSnackBar('Group created successfully!');
        context.pop();
      }
    }

    final state = ref.watch(groupNotifierProvider);

    return Stack(
      children: [
        Form(
          key: formKey,
          child: Scaffold(
            appBar: AppBar(
              actions: [
                TextButton(
                  onPressed: isLoading.value ? null : submit,
                  child: const Text('Done'),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      hintText: 'Group name',
                      controller: groupNameController,
                      validator: (value) => (value == null || value.isEmpty) ? 'Group name cannot be empty' : null,
                    ),
                    Text(
                      'Type',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Wrap(
                      spacing: 8,
                      children: GroupType.values
                          .where((type) => type != GroupType.none)
                          .map(
                            (type) => GestureDetector(
                              onTap: () => selectedType.value = type,
                              child: CustomTypeButtons(
                                selectedType: selectedType,
                                type: type,
                                themeConstants: themeConstants,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    if (selectedType.value == GroupType.trip) ...[
                      SwitchListTile.adaptive(
                        activeColor: Theme.of(context).colorScheme.primary,
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Add trip dates',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text('Set start and end dates for the trip'),
                        value: tripDatesEnabled.value,
                        onChanged: (value) => tripDatesEnabled.value = value,
                      ),
                      if (tripDatesEnabled.value) ...[
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: startDate.value ?? DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2100),
                                  );
                                  if (date != null) startDate.value = date;
                                },
                                child: CustomDateTimePicker(
                                  selectedDate: startDate.value != null
                                      ? 'Start: ${DateFormat('dd MMM, yyyy').format(startDate.value!)}'
                                      : 'Select Start Date',
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        endDate.value ??
                                        startDate.value?.add(const Duration(days: 1)) ??
                                        DateTime.now(),
                                    firstDate: startDate.value ?? DateTime.now(),
                                    lastDate: DateTime(2100),
                                  );
                                  if (date != null) endDate.value = date;
                                },
                                child: CustomDateTimePicker(
                                  selectedDate: endDate.value != null
                                      ? 'End: ${DateFormat('dd MMM, yyyy').format(endDate.value!)}'
                                      : 'Select End Date',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (isLoading.value || state.isLoading)
          Container(
            color: Colors.black54,
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}

class CustomTypeButtons extends StatelessWidget {
  const CustomTypeButtons({
    super.key,
    required this.selectedType,
    required this.type,
    required this.themeConstants,
  });

  final ValueNotifier<GroupType> selectedType;
  final GroupType type;
  final ThemeConstants themeConstants;

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedType.value == type;
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: themeConstants.isDarkMode ? Theme.of(context).cardColor : const Color(0xFFE7EBF0),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: isSelected ? themeConstants.lightShadow : themeConstants.shadowColor,
            blurRadius: 5,
            offset: Offset(isSelected ? 2.5 : -2.5, isSelected ? 2.5 : -2.5),
            inset: isSelected,
          ),
          BoxShadow(
            color: isSelected ? themeConstants.shadowColor : themeConstants.lightShadow,
            blurRadius: 5,
            offset: Offset(isSelected ? -2.5 : 2.5, isSelected ? -2.5 : 2.5),
            inset: isSelected,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            type == GroupType.trip
                ? CupertinoIcons.airplane
                : type == GroupType.home
                ? CupertinoIcons.house_fill
                : type == GroupType.couple
                ? CupertinoIcons.heart_fill
                : CupertinoIcons.doc_text_fill,
            size: 16,
            color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Text(
            type.name.toUpperCase(),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
