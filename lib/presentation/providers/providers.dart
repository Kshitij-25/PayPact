// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:paypact/data/core/expense_form_state.dart';
// import 'package:paypact/data/models/user.dart';
// import 'package:paypact/presentation/providers/expense_form_notifier.dart';

// final expenseFormProvider =
//     StateNotifierProvider.autoDispose<ExpenseFormNotifier, ExpenseFormState>((ref) {
//       return ExpenseFormNotifier();
//     });

// final groupMembersProvider = StreamProvider.autoDispose.family<List<User>, String>((
//   ref,
//   groupId,
// ) {
//   return FirebaseFirestore.instance
//       .collection('groups')
//       .doc(groupId)
//       .collection('members')
//       .snapshots()
//       .map((snapshot) => snapshot.docs.map((doc) => User.fromMap(doc.data())).toList());
// });
