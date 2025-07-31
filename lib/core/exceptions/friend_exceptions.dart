class FriendException implements Exception {
  final String message;
  const FriendException(this.message);
}

class FriendAlreadyExistsException extends FriendException {
  const FriendAlreadyExistsException() : super('This user is already your friend');
}

class FriendRequestException extends FriendException {
  const FriendRequestException() : super('Failed to send friend request');
}

class FriendNotFoundException extends FriendException {
  const FriendNotFoundException() : super('Friend not found');
}

class SelfFriendException extends FriendException {
  const SelfFriendException() : super('Cannot add yourself as friend');
}
