abstract class GroupException implements Exception {
  final String message;
  const GroupException(this.message);
}

class GroupNotFoundException extends GroupException {
  const GroupNotFoundException() : super('Group not found');
}

class GroupPermissionException extends GroupException {
  const GroupPermissionException() : super('You don\'t have permission for this action');
}

class EmptyGroupException extends GroupException {
  const EmptyGroupException() : super('Group must have at least one member');
}

class DuplicateGroupException extends GroupException {
  const DuplicateGroupException() : super('Group with this name already exists');
}

class MemberNotFoundException extends GroupException {
  const MemberNotFoundException() : super('Member not found in group');
}

class MemberAlreadyExistsException extends GroupException {
  const MemberAlreadyExistsException() : super('Member already in group');
}
