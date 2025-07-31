class FirestoreConstants {
  // Collections
  static const String usersCollection = 'users';
  static const String groupsCollection = 'groups';
  static const String expensesCollection = 'expenses';
  static const String settlementsCollection = 'settlements';
  static const String activitiesCollection = 'activities';

  // Subcollections
  static const String friendsSubcollection = 'friends';
  static const String userGroupsSubcollection = 'userGroups';

  // Field Names
  static const String createdAtField = 'createdAt';
  static const String updatedAtField = 'updatedAt';
  static const String emailField = 'email';
  static const String nameField = 'name';
  static const String photoUrlField = 'photoUrl';

  // Expense Types
  static const String equalSplit = 'EQUAL';
  static const String percentageSplit = 'PERCENTAGE';
  static const String exactSplit = 'EXACT';

  // Document Paths
  static String userDocument(String userId) => '$usersCollection/$userId';
  static String friendDocument(String userId, String friendId) =>
      '$usersCollection/$userId/$friendsSubcollection/$friendId';
}
