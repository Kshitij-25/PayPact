enum SplitType { equal, custom }

Map<String, double> calculateSplits(
  SplitType type,
  double amount,
  List<String> participants,
  Map<String, double>? customSplits,
) {
  switch (type) {
    case SplitType.equal:
      final share = amount / participants.length;
      return {for (var p in participants) p: share};

    case SplitType.custom:
      return customSplits!;
  }
}
