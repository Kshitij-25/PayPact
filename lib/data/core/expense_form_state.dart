// class ExpenseFormState {
//   final double amount;
//   final String description;
//   final String payerId;
//   final SplitMethod splitMethod;
//   final Map<String, double> selectedParticipants;
//   final Map<String, double> individualShares;

//   ExpenseFormState({
//     this.amount = 0.0,
//     this.description = '',
//     required this.payerId,
//     this.splitMethod = SplitMethod.equal,
//     Map<String, double>? selectedParticipants,
//     Map<String, double>? individualShares,
//   }) : selectedParticipants = selectedParticipants ?? {},
//        individualShares = individualShares ?? {};

//   ExpenseFormState copyWith({
//     double? amount,
//     String? description,
//     String? payerId,
//     SplitMethod? splitMethod,
//     Map<String, double>? selectedParticipants,
//     Map<String, double>? individualShares,
//   }) {
//     return ExpenseFormState(
//       amount: amount ?? this.amount,
//       description: description ?? this.description,
//       payerId: payerId ?? this.payerId,
//       splitMethod: splitMethod ?? this.splitMethod,
//       selectedParticipants: selectedParticipants ?? this.selectedParticipants,
//       individualShares: individualShares ?? this.individualShares,
//     );
//   }
// }

// enum SplitMethod { equal, percentage, exact }
