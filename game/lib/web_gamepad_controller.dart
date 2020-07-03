import 'dart:html';

Gamepad _connectedGamepad;

void initGamepad() {
  //window.addEventListener('gamepadconnected', (Event event) {
  //  if (event is GamepadEvent) {
  //    _connectedGamepad = event.gamepad;
  //  }
  //});
}

Gamepad connectedGamepad() {
  final gamepads = window.navigator.getGamepads();
  if (gamepads != null && gamepads.isNotEmpty) {
    final gamepad = gamepads.first;
    if (gamepad != null) {
      return gamepad;
    }
  }
  return null;
  //return _connectedGamepad;
}

bool hasGamepadConnected() {
  return connectedGamepad() != null;
}

String gamepadStrStatus() {
  final gamepads = window.navigator.getGamepads();
  var status = '';
  if (gamepads != null && gamepads.isNotEmpty) {
    final gamepad = gamepads.first;
    status += gamepad == null ? 'no' : 'on';
    status += ',';
  }
  return status;
}
