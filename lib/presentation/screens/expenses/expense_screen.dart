// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:paypact/data/core/expense_form_state.dart';
// import 'package:paypact/data/models/user.dart';
// import 'package:paypact/presentation/providers/expense_form_notifier.dart';
// import 'package:paypact/presentation/providers/providers.dart';

// class ExpenseScreen extends ConsumerWidget {
//   final String groupId;

//   const ExpenseScreen({super.key, required this.groupId});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final membersAsync = ref.watch(groupMembersProvider(groupId));
//     final formState = ref.watch(expenseFormProvider);
//     final formNotifier = ref.read(expenseFormProvider.notifier);

//     return Scaffold(
//       appBar: AppBar(title: const Text('New Expense')),
//       body: membersAsync.when(
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (error, stack) => Center(child: Text('Error: $error')),
//         data: (members) => _buildForm(members, formState, formNotifier),
//       ),
//     );
//   }

//   Widget _buildForm(
//     List<User> members,
//     ExpenseFormState state,
//     ExpenseFormNotifier notifier,
//   ) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           TextFormField(
//             keyboardType: TextInputType.number,
//             decoration: const InputDecoration(labelText: 'Amount'),
//             onChanged: (value) => notifier.updateAmount(double.tryParse(value) ?? 0.0),
//           ),
//           TextFormField(
//             decoration: const InputDecoration(labelText: 'Description'),
//             onChanged: notifier.updateDescription,
//           ),
//           _buildPayerDropdown(members, state, notifier),
//           _buildSplitMethodDropdown(state, notifier),
//           const SizedBox(height: 20),
//           _buildParticipantsList(members, state, notifier),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () => notifier.submitExpense(groupId),
//             child: const Text('Save Expense'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPayerDropdown(
//     List<User> members,
//     ExpenseFormState state,
//     ExpenseFormNotifier notifier,
//   ) {
//     return DropdownButtonFormField<String>(
//       value: state.payerId,
//       items:
//           members
//               .map((user) => DropdownMenuItem(value: user.id, child: Text(user.name)))
//               .toList(),
//       onChanged: (value) => notifier.setPayer(value!),
//       decoration: const InputDecoration(labelText: 'Paid by'),
//     );
//   }

//   Widget _buildSplitMethodDropdown(ExpenseFormState state, ExpenseFormNotifier notifier) {
//     return DropdownButtonFormField<SplitMethod>(
//       value: state.splitMethod,
//       items:
//           SplitMethod.values
//               .map(
//                 (method) => DropdownMenuItem(
//                   value: method,
//                   child: Text(method.toString().split('.').last),
//                 ),
//               )
//               .toList(),
//       onChanged: (value) => notifier.setSplitMethod(value!),
//       decoration: const InputDecoration(labelText: 'Split by'),
//     );
//   }

//   Widget _buildParticipantsList(
//     List<User> members,
//     ExpenseFormState state,
//     ExpenseFormNotifier notifier,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Participants',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         ...members.map((user) => _buildParticipantRow(user, state, notifier)),
//       ],
//     );
//   }

//   Widget _buildParticipantRow(
//     User user,
//     ExpenseFormState state,
//     ExpenseFormNotifier notifier,
//   ) {
//     final isSelected = state.selectedParticipants.containsKey(user.id);
//     final share = state.individualShares[user.id] ?? 0.0;

//     return ListTile(
//       leading: Checkbox(
//         value: isSelected,
//         onChanged: (value) => notifier.toggleParticipant(user.id, value ?? false),
//       ),
//       title: Text(user.name),
//       trailing: isSelected ? _buildShareInput(state, user.id, share, notifier) : null,
//     );
//   }

//   Widget _buildShareInput(
//     ExpenseFormState state,
//     String userId,
//     double share,
//     ExpenseFormNotifier notifier,
//   ) {
//     switch (state.splitMethod) {
//       case SplitMethod.equal:
//         return Text('\$${share.toStringAsFixed(2)}');
//       case SplitMethod.percentage:
//         return SizedBox(
//           width: 100,
//           child: TextFormField(
//             initialValue: (share / state.amount * 100).toStringAsFixed(0),
//             keyboardType: TextInputType.number,
//             decoration: const InputDecoration(suffixText: '%'),
//             onChanged: (value) {
//               final percentage = double.tryParse(value) ?? 0.0;
//               notifier.updateIndividualShare(userId, state.amount * (percentage / 100));
//             },
//           ),
//         );
//       case SplitMethod.exact:
//         return SizedBox(
//           width: 100,
//           child: TextFormField(
//             initialValue: share.toStringAsFixed(2),
//             keyboardType: TextInputType.number,
//             decoration: const InputDecoration(prefixText: '\$'),
//             onChanged:
//                 (value) =>
//                     notifier.updateIndividualShare(userId, double.tryParse(value) ?? 0.0),
//           ),
//         );
//     }
//   }
// }
