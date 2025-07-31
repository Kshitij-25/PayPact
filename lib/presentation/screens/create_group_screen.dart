import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:paypact/core/constants/firebase_helper.dart';

import '../../data/datasources/remote/group_remote_source.dart';

class CreateGroupScreen extends HookConsumerWidget {
  const CreateGroupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupNameController = useTextEditingController();
    final selectedType = useState('');
    final tripDatesEnabled = useState(selectedType.value == 'Trip');
    final startDate = useState<DateTime?>(null);
    final endDate = useState<DateTime?>(null);
    final isLoading = useState(false);

    Future<void> createGroup() async {
      // Get current user
      final user = FirebaseHelper.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must be logged in to create a group')),
        );
        return;
      }

      // Validate inputs
      final groupName = groupNameController.text.trim();
      if (groupName.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please enter a group name')));
        return;
      }

      if (selectedType.value.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please select a group type')));
        return;
      }

      if (tripDatesEnabled.value) {
        if (startDate.value == null || endDate.value == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select both start and end dates')),
          );
          return;
        }

        if (endDate.value!.isBefore(startDate.value!)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('End date must be after start date')),
          );
          return;
        }
      }

      try {
        isLoading.value = true;

        await ref
            .read(groupRemoteSourceProvider)
            .createGroup(
              name: groupName,
              type: selectedType.value,
              creatorId: user.uid,
              tripDatesEnabled: tripDatesEnabled.value,
              startDate: startDate.value,
              endDate: endDate.value,
            );

        ref.invalidate(groupsProvider);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Group $groupName created successfully!')),
          );
          context.pop();
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error creating group: ${e.toString()}')),
          );
        }
      } finally {
        isLoading.value = false;
      }
    }

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text('Create a group'),
            actions: [
              TextButton(
                onPressed: isLoading.value ? null : createGroup,
                child: const Text('Done'),
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: groupNameController,
                  decoration: InputDecoration(labelText: 'Group name'),
                ),
                Text(
                  'Type',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: ['Trip', 'Home', 'Couple', 'Other'].map((type) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: ChoiceChip(
                        showCheckmark: false,
                        avatar: Icon(
                          type == 'Trip'
                              ? CupertinoIcons.airplane
                              : type == 'Home'
                              ? CupertinoIcons.house_fill
                              : type == 'Couple'
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.doc_text_fill,
                        ),
                        label: Text(type),
                        selected: selectedType.value == type,
                        onSelected: (selected) => selectedType.value = type,
                      ),
                    );
                  }).toList(),
                ),
                if (selectedType.value == 'Trip')
                  SwitchListTile(
                    contentPadding: EdgeInsets.all(0),
                    title: Text(
                      'Add trip dates',
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Set start and end dates for the trip'),
                    value: tripDatesEnabled.value,
                    onChanged: (value) => tripDatesEnabled.value = value,
                  ),
                if (selectedType.value == 'Trip' && tripDatesEnabled.value) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Start: ${startDate.value?.toLocal().toString().split(' ')[0] ?? 'Select'}',
                      ),
                      IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (date != null) startDate.value = date;
                        },
                      ),
                      Text(
                        'End: ${endDate.value?.toLocal().toString().split(' ')[0] ?? 'Select'}',
                      ),
                      IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (date != null) endDate.value = date;
                        },
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
        if (isLoading.value)
          Container(
            color: Colors.black87,
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
      ],
    );
  }
}
