// Probably isolate the whole http client into a new isolate
// this would bring a significant performance boost because even the json parsing
// can be done in this isolate!
// this was already done with these two packages but they feel a little bit 
// overkill!
// worker_manger - create workers to run every static func in isolates
//https://pub.dev/packages/worker_manager

// isolated_http_client - basically what I want here
//https://pub.dev/packages/isolated_http_client/example

// import 'dart:isolate';
// import 'dart:async';
// import 'package:async/async.dart';


// class IsolatedHttpClient {
//   late Isolate _isolate;
//   late ReceivePort _receivePort;
//   late SendPort _sendPort;
//   late StreamSubscription _portSub;

//   @override
//   Future<void> initialize() async {
//     _receivePort = ReceivePort();
//     _isolate = await Isolate.spawn<SendPort>(_anotherIsolate, _receivePort.sendPort);
//     _portSub = _receivePort.listen((message) {
//       if (message is ValueResult) {
//         _result.complete(message.value);
//       } else if (message is ErrorResult) {
//         _result.completeError(message.error);
//       } else if (message is SendPort) {
//         _sendPort = message;
//         initCompleter.complete(true);
//       } else {
//         throw ArgumentError("Unrecognized message");
//       }
//     });
//     await initCompleter.future;
//   }

//   @override
//   Future<O> work<A, B, C, D, O>(Task<A, B, C, D, O> task) async{
//     _runnableNumber = task.number;
//     _result = Completer<Object>();
//     _sendPort.send(Message(_execute, task.runnable));
//     final resultValue = await (_result.future as Future<O>);
//     _runnableNumber = null;
//     return resultValue;
//   }

//   static FutureOr _execute(runnable) => runnable();

//   static void _anotherIsolate(SendPort sendPort) {
//     final receivePort = ReceivePort();
//     sendPort.send(receivePort.sendPort);
//     receivePort.listen((message) async {
//       try {
//         final currentMessage = message as Message;
//         final function = currentMessage.function;
//         final argument = currentMessage.argument;
//         final result = await function(argument);
//         sendPort.send(Result.value(result));
//       } catch (error) {
//         try {
//           sendPort.send(Result.error(error));
//         } catch (error) {
//           sendPort.send(Result.error('cant send error with too big stackTrace, error is : ${error.toString()}'));
//         }
//       }
//     });
//   }

//   @override
//   Future<void> kill() async {
//     await _portSub.cancel();
//     _isolate.kill(priority: Isolate.immediate);
//   }

// }

// class Message {
//   final Function function;
//   final Object argument;

//   Message(this.function, this.argument);

//   FutureOr call() async => await function(argument);
// }