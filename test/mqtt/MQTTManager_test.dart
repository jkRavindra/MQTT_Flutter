import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqttfluttermsg/mqtt/MQTTManager.dart';
import 'package:mqttfluttermsg/mqtt/state/MQTTAppState.dart';

void main() {
  group('MQTTManager', () {
    late MqttServerClient _client;
    late MQTTManager mqttManager;
    late MQTTAppState appState;
    MQTTAppConnectionState ConnectionState;

    setUp(() {
      _client = MqttServerClient('test.mosquitto.org', 'android');
      appState = MQTTAppState();
      mqttManager = MQTTManager(
        host: 'test.mosquitto.org',
        topic: 'flutter/sample',
        identifier: 'android',
        state: appState,
      );
    });

    test(
        'initially MQTTAppConnectionState should be disconnected',
        () async => {
              // Act
              ConnectionState = appState.getAppConnectionState,

              //Assert
              expect(ConnectionState, MQTTAppConnectionState.disconnected)
            });

    test('initializeMQTTClient sets up the MQTT client correctly', () {
      // Act
      mqttManager.initializeMQTTClient();

      // Assert
      expect(_client, isNotNull);
      expect(_client.server, 'test.mosquitto.org');
      expect(_client.clientIdentifier, 'android');
      expect(_client.port, 1883);
      expect(_client.secure, false);
    });

    test('connect() should set the app connection state to "connecting"',
        () async {
      // Act
      mqttManager.initializeMQTTClient();
      mqttManager.connect();

      // Assert
      expect(appState.getAppConnectionState, MQTTAppConnectionState.connecting);
    });

    test('AppState should be Subscribed when subscribe subscribes to a topic',
        () {
      // Act
      mqttManager.initializeMQTTClient();
      mqttManager.connect();
      mqttManager.subScribe('flutter/sample');

      // Assert
      expect(appState.getAppConnectionState, MQTTAppConnectionState.subsribed);
    });

    test('disconnect disconnects from the MQTT host', () {
      // Act
      mqttManager.initializeMQTTClient();
      mqttManager.disconnect();

      // Assert
      expect(
          appState.getAppConnectionState, MQTTAppConnectionState.disconnected);
    });

    test(
        'AppState should be DisConnected when disconnect disconnects from the MQTT host',
        () {
      // Act
      mqttManager.initializeMQTTClient();
      mqttManager.disconnect();

      // Assert
      expect(
          appState.getAppConnectionState, MQTTAppConnectionState.disconnected);
    });

    test('publish should push a message successfully', () {
      // Arrange
      mqttManager.initializeMQTTClient();
      mqttManager.connect();
      mqttManager.subScribe('flutter/sample');
      final message = 'Test message';
      final topic = 'flutter/sample';

      // Assert
      Future.delayed(Duration(seconds: 1), () {
        mqttManager.publish(message, topic);
        expect(() => mqttManager.publish(message, topic), returnsNormally);
      });
    });

    test('connect should handle client connection exception', () {
      // Arrange
      _client.server = 'invalid server';

      // Act
      mqttManager.initializeMQTTClient();
      mqttManager.connect();

      // Assert
      Future.delayed(Duration(seconds: 1), () {
        expect(appState.getAppConnectionState,
            MQTTAppConnectionState.disconnected);
      });
    });

    test('onDisconnected should handle null connection status', () {
      // Act
      mqttManager.initializeMQTTClient();
      mqttManager.client!.connectionStatus!.returnCode = null;
      mqttManager.onDisconnected();

      // Assert
      Future.delayed(Duration(seconds: 1), () {
        expect(appState.getAppConnectionState,
            MQTTAppConnectionState.disconnected);
      });
    });

    test('subScribe should handle null or empty topic', () {
      // Arrange
      mqttManager.initializeMQTTClient();
      mqttManager.connect();
      // Act and Assert
      Future.delayed(Duration(seconds: 1), () {
        expect(() => mqttManager.subScribe(''), throwsArgumentError);
      });
    });

    test('publish should handle null or empty topic', () {
      // Arrange
      mqttManager.initializeMQTTClient();
      mqttManager.connect();
      final message = 'Test message';

      // Act and Assert
      Future.delayed(Duration(seconds: 1), () {
        expect(() => mqttManager.publish(message, ''), throwsArgumentError);
      });
    });
  });
}
