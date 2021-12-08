abstract class Failure {}

// --HttpFailures--
abstract class HttpFailure extends Failure {}
class AuthFailure extends HttpFailure {}
class ConnectionFailure extends HttpFailure {}
class InvalidRequest extends HttpFailure {}
class PairingTokenExpired extends HttpFailure {}
class UserNotFound extends HttpFailure {}

// --RfidFailures--
abstract class RfidFailure extends Failure {}
class InitFailure extends RfidFailure {}
class RfidReadFunctionNotInitYet extends RfidFailure {}
class RfidReaderClosed extends RfidFailure {}
class NothingRead extends RfidFailure {}

