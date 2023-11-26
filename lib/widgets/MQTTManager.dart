import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqttfluttermsg/widgets/mqttModelView.dart';

class MQTTManager {
  // Private instance of client
  final MqttAppState _currentState;
  MqttServerClient? _client;
  final String _identifier;
  final String _host;
  final String _topic;
//"mqtt://localhost:1883"
  // Constructor
  // ignore: sort_constructors_first
  MQTTManager(
      {required String host,
      required String topic,
      required String identifier,
      required MqttAppState state})
      : _identifier = identifier,
        _host = host,
        _topic = topic,
        _currentState = state;

  // Public getter and setter for client
  MqttServerClient? get client => _client;
  set client(MqttServerClient? value) => _client = value;

  void initializeMQTTClient() {
    _client = MqttServerClient(_host, _identifier);
    _client!.port = 1883;
    _client!.keepAlivePeriod = 20;
    _client!.onDisconnected = onDisconnected;
    _client!.secure = false;
    _client!.logging(on: false);

    /// Add the successful connection callback
    _client!.onConnected = onConnected;
    _client!.onSubscribed = onSubscribed;
    _client!.onUnsubscribed = onUnsubscribed;

    final MqttConnectMessage connMess =
        MqttConnectMessage() //initiate a connection to a message broker
            .withClientIdentifier(_identifier)
            .withWillTopic(
                'willtopic') // If you set this you must set a will message
            .withWillMessage('My Will message')
            .startClean() // Non persistent session for testing
            .withWillQos(MqttQos.atLeastOnce);
    _client!.connectionMessage = connMess;
  }

  // Connect to the host
  // ignore: avoid_void_async
  void connect() async {
    assert(_client != null);
    try {
      _currentState.setAppConnectionState(MQTTAppConnectionState.connecting);
      await _client!.connect();
    } on SocketException catch (e) {
      print('Failed to connect: $e');
      _currentState.setAppConnectionState(MQTTAppConnectionState.disconnected);
      disconnect();
    } on Exception catch (e) {
      print('EXAMPLE::client exception - $e');
      _currentState.setAppConnectionState(MQTTAppConnectionState.disconnected);
      disconnect();
    }
  }

  void disconnect() {
    print('Disconnected');
    _client!.disconnect();
  }

  void publish(String message, String topicName) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client!.publishMessage(topicName, MqttQos.exactlyOnce, builder.payload!);
  }

  void subScribe(String atopic) {
    try {
      print("atopicatopicatopic==> $atopic");
      _currentState.setAppConnectionState(MQTTAppConnectionState.subsribed);
      _client!.subscribe(atopic, MqttQos.atLeastOnce);
    } on Exception catch (e) {
      unSubscribe(atopic);
      _currentState.setAppConnectionState(MQTTAppConnectionState.disconnected);
    }
  }

  void unSubscribe(String topicName) {
    print('unSubScribed ${topicName}');
    _client!.unsubscribe(topicName);
  }

  /// The subscribed callback
  void onUnsubscribed(dynamic topic) {
    _currentState.setAppConnectionState(MQTTAppConnectionState.connected);
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    if (_client!.connectionStatus!.returnCode ==
        MqttConnectReturnCode.noneSpecified) {
      _currentState.setAppConnectionState(MQTTAppConnectionState.disconnected);
    }
  }

  /// The successful connect callback
  void onConnected() {
    _currentState.setAppConnectionState(MQTTAppConnectionState.connected);
  }

  /// The subscribed callback
  void onSubscribed(String topic) {
    _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      // ignore: avoid_as
      final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;

      // final MqttPublishMessage recMess = c![0].payload;
      final String pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message!);
      _currentState.setReceivedText(pt);
    });
  }
}
