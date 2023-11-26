import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:provider/provider.dart';

import 'MQTTManager.dart';
import 'mqttModelView.dart';

class MQTTView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MQTTViewState();
  }
}

class _MQTTViewState extends State<MQTTView> {
  final TextEditingController _hostTextController = TextEditingController();
  final TextEditingController _messageTextController = TextEditingController();
  final TextEditingController _topicTextController = TextEditingController();
  late MqttAppState currentAppState;
  late MQTTManager manager;

  @override
  void initState() {
    super.initState();

    /*
    _hostTextController.addListener(_printLatestValue);
    _messageTextController.addListener(_printLatestValue);
    _topicTextController.addListener(_printLatestValue);

     */
  }

  @override
  void dispose() {
    _hostTextController.dispose();
    _messageTextController.dispose();
    _topicTextController.dispose();
    super.dispose();
  }

  /*
  _printLatestValue() {
    print("Second text field: ${_hostTextController.text}");
    print("Second text field: ${_messageTextController.text}");
    print("Second text field: ${_topicTextController.text}");
  }

   */

  @override
  Widget build(BuildContext context) {
    final MqttAppState appState = Provider.of<MqttAppState>(context);
    // Keep a reference to the app state.
    currentAppState = appState;
    final Scaffold scaffold = Scaffold(
        appBar: AppBar(
          title: const Text('MQTT'),
          backgroundColor: Colors.greenAccent,
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back)),
        ),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(child: _buildColumn()));
    return scaffold;
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('MQTT'),
      backgroundColor: Colors.greenAccent,
      leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back)),
    );
  }

  Widget _buildColumn() {
    return Column(
      children: <Widget>[
        _buildConnectionStateText(
            _prepareStateMessageFrom(currentAppState.getAppConnectionState)),
        _buildEditableColumn(),
        _buildScrollableTextWith(currentAppState.getHistoryText)
      ],
    );
  }

  Widget _buildEditableColumn() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          _buildTextFieldWith(_hostTextController, 'Enter broker address',
              currentAppState.getAppConnectionState),
          const SizedBox(height: 10),
          _buildConnecteButtonFrom(
              currentAppState.getAppConnectionState, 'Connect', 'Disconnect'),
          const SizedBox(height: 15),
          _buildTextFieldWith(
              _topicTextController,
              'Enter a topic to subscribe or listen',
              currentAppState.getAppConnectionState),
          const SizedBox(height: 10),
          _buildConnecteButtonFrom(currentAppState.getAppConnectionState,
              'Subscribe', 'Unsubscribe'),
          const SizedBox(height: 15),
          _buildPublishMessageRow(),
        ],
      ),
    );
  }

  Widget _buildPublishMessageRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: _buildTextFieldWith(_messageTextController, 'Enter a message',
              currentAppState.getAppConnectionState),
        ),
        _buildSendButtonFrom(currentAppState.getAppConnectionState)
      ],
    );
  }

  Widget _buildConnectionStateText(String status) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
              color: status == 'Connected'
                  ? Colors.green
                  : status == 'Connecting'
                      ? Colors.deepOrangeAccent
                      : status == 'Subscribed'
                          ? Colors.green
                          : Colors.red,
              child: Text(
                status,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              )),
        ),
      ],
    );
  }

  Widget _buildTextFieldWith(TextEditingController controller, String hintText,
      MQTTAppConnectionState state) {
    bool shouldEnable = false;
    if (controller == _messageTextController &&
        state == MQTTAppConnectionState.subsribed) {
      shouldEnable = true;
    } else if ((controller == _hostTextController &&
        state == MQTTAppConnectionState.disconnected)) {
      shouldEnable = true;
    } else if ((controller == _topicTextController &&
        state == MQTTAppConnectionState.connected)) {
      shouldEnable = true;
    }
    return TextField(
        enabled: shouldEnable,
        controller: controller,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 0),
          labelText: hintText,
        ));
  }

  Widget _buildScrollableTextWith(String text) {
    print("texttexttexttexttext $text");
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: 400,
        height: 250,
        child: SingleChildScrollView(
          child: Text(text),
        ),
      ),
    );
  }

  Widget _buildConnecteButtonFrom(MQTTAppConnectionState state,
      String FirstButtonName, String SecondButtonName) {
    return Row(
      children: <Widget>[
        Expanded(
          // ignore: deprecated_member_use
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.lightBlueAccent, // foreground
            ),

            child: Text(FirstButtonName),
            onPressed: state == MQTTAppConnectionState.disconnected &&
                    FirstButtonName == 'Connect'
                ? _configureAndConnect
                : state == MQTTAppConnectionState.connected &&
                        FirstButtonName == 'Subscribe'
                    ? _subScribe
                    : null, //
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          // ignore: deprecated_member_use
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red, // foreground
            ),
            child: Text(SecondButtonName),
            onPressed: state == MQTTAppConnectionState.connected &&
                    SecondButtonName == 'Disconnect'
                ? _disconnect
                : state == MQTTAppConnectionState.subsribed &&
                        SecondButtonName == 'Unsubscribe'
                    ? _unsubscribe
                    : null, //
          ),
        ),
      ],
    );
  }

  Widget _buildSendButtonFrom(MQTTAppConnectionState state) {
    // ignore: deprecated_member_use
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green, // foreground
      ),
      child: const Text('Send'),
      onPressed: state == MQTTAppConnectionState.subsribed
          ? () {
              _publishMessage(_messageTextController.text);
            }
          : null, //
    );
  }

  // Utility functions
  String _prepareStateMessageFrom(MQTTAppConnectionState state) {
    switch (state) {
      case MQTTAppConnectionState.connected:
        return 'Connected';
      case MQTTAppConnectionState.connecting:
        return 'Connecting';
      case MQTTAppConnectionState.disconnected:
        return 'Disconnected';
      case MQTTAppConnectionState.subsribed:
        return 'Subscribed';
      case MQTTAppConnectionState.unsubscribed:
        return 'Unsubscribed';
    }
  }

  void _configureAndConnect() {
    // ignore: flutter_style_todos
    // TODO: Use UUID
    String osPrefix = 'Flutter_iOS';
    if (Platform.isAndroid) {
      osPrefix = 'Flutter_Android';
    } else if (Platform.isWindows) {
      osPrefix = 'Flutter_Windows';
    }
    manager = MQTTManager(
        host: _hostTextController.text,
        topic: _topicTextController.text,
        identifier: osPrefix,
        state: currentAppState);
    manager.initializeMQTTClient();
    manager.connect();
  }

  void _subScribe() {
    manager.subScribe(_topicTextController.text);
  }

  void _disconnect() {
    manager.disconnect();
  }

  void _unsubscribe() {
    manager.unSubscribe(_topicTextController.text);
  }

  void _publishMessage(String text) {
    String osPrefix = 'Flutter_iOS';
    if (Platform.isAndroid) {
      osPrefix = 'Flutter_Android';
    } else if (Platform.isWindows) {
      osPrefix = 'Flutter_Windows';
    }
    final String message = osPrefix + ' says: ' + text;
    manager.publish(message, _topicTextController.text);
    _messageTextController.clear();
  }
}
