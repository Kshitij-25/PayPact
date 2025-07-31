// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:paypact/data/core/expense_form_state.dart';
// import 'package:paypact/services/expense_service.dart';

// class ExpenseFormNotifier extends StateNotifier<ExpenseFormState> {
//   ExpenseFormNotifier() : super(ExpenseFormState(payerId: '1'));

//   void updateAmount(double value) {
//     state = state.copyWith(amount: value);
//     _calculateShares();
//   }

//   void updateDescription(String value) {
//     state = state.copyWith(description: value);
//   }

//   void setPayer(String userId) {
//     state = state.copyWith(payerId: userId);
//   }

//   void setSplitMethod(SplitMethod method) {
//     state = state.copyWith(splitMethod: method);
//     _calculateShares();
//   }

//   void toggleParticipant(String userId, bool selected) {
//     final newParticipants = Map<String, double>.from(state.selectedParticipants);

//     if (selected) {
//       newParticipants[userId] = 0.0;
//     } else {
//       newParticipants.remove(userId);
//     }

//     state = state.copyWith(selectedParticipants: newParticipants);
//     _calculateShares();
//   }

//   void updateIndividualShare(String userId, double value) {
//     final newShares = Map<String, double>.from(state.individualShares);
//     newShares[userId] = value;
//     state = state.copyWith(individualShares: newShares);
//     _validateShares();
//   }

//   void _calculateShares() {
//     if (state.amount <= 0 || state.selectedParticipants.isEmpty) return;

//     final total = state.amount;
//     final participants = state.selectedParticipants.keys.toList();
//     final shares = <String, double>{};

//     switch (state.splitMethod) {
//       case SplitMethod.equal:
//         final share = total / participants.length;
//         for (final userId in participants) {
//           shares[userId] = share;
//         }
//         break;

//       case SplitMethod.percentage:
//         final equalPercentage = 100.0 / participants.length;
//         for (final userId in participants) {
//           shares[userId] = total * (equalPercentage / 100);
//         }
//         break;

//       case SplitMethod.exact:
//         // Initial exact split with equal amounts
//         final share = total / participants.length;
//         for (final userId in participants) {
//           shares[userId] = share;
//         }
//         break;
//     }

//     state = state.copyWith(individualShares: shares);
//   }

//   void _validateShares() {
//     if (state.splitMethod == SplitMethod.percentage) {
//       final totalPercentage = state.individualShares.values.fold(
//         0.0,
//         (sum, value) => sum + value,
//       );
//       if (totalPercentage != 100.0) {
//         // Handle percentage validation error
//       }
//     } else if (state.splitMethod == SplitMethod.exact) {
//       final totalAmount = state.individualShares.values.fold(
//         0.0,
//         (sum, value) => sum + value,
//       );
//       if (totalAmount != state.amount) {
//         // Handle exact amount validation error
//       }
//     }
//   }

//   Future<void> submitExpense(String groupId) async {
//     if (state.amount <= 0 || state.selectedParticipants.isEmpty) return;

//     final expenseData = {
//       'amount': state.amount,
//       'description': state.description,
//       'payerId': state.payerId,
//       'splitMethod': state.splitMethod.toString(),
//       'participants': state.individualShares,
//       'createdAt': Timestamp.now(),
//     };

//     await FirebaseFirestore.instance
//         .collection('groups')
//         .doc(groupId)
//         .collection('expenses')
//         .add(expenseData);

//     // Update balances
//     await ExpenseService().updateBalances(
//       groupId: groupId,
//       payerId: state.payerId,
//       shares: state.individualShares,
//     );
//   }
// }
