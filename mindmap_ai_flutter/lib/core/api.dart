import 'package:mindmap_ai_client/mindmap_ai_client.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

/// Backend address. Override per build:
///   flutter run --dart-define=SERVER_URL=http://10.0.2.2:8080/   (Android emulator)
const String serverUrl = String.fromEnvironment(
  'SERVER_URL',
  defaultValue: 'http://localhost:8080/',
);

/// The generated Serverpod client: client.notes, client.tasks, client.ai, client.preferences
final Client client = Client(serverUrl)
  ..connectivityMonitor = FlutterConnectivityMonitor();
