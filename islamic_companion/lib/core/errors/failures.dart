// ============================================================
// failures.dart
// Sealed failure classes used across all use cases.
// Use cases return Either<Failure, Result> patterns.
// ============================================================

abstract class Failure {
  final String message;
  const Failure(this.message);
}

/// Location permission denied or service disabled
class LocationFailure extends Failure {
  const LocationFailure([super.message = 'Could not retrieve location.']);
}

/// Hive read/write error
class StorageFailure extends Failure {
  const StorageFailure([super.message = 'Storage operation failed.']);
}

/// Input validation error
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Generic unexpected error
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'An unexpected error occurred.']);
}

/// Notification scheduling error
class NotificationFailure extends Failure {
  const NotificationFailure([super.message = 'Notification could not be scheduled.']);
}
