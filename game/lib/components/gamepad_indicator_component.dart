import 'package:flame/text_config.dart';
import 'package:flame/components/text_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';

import 'dart:ui';

import '../game.dart';
import '../web_gamepad_controller.dart';

class GamepadIndicatorComponent extends TextComponent with HasGameRef<SpaceShooterGame> {
  GamepadIndicatorComponent() : super(
      "",
      config: TextConfig(color: Color(0xffffffff))
  );

  @override
  void onMount() {
    x = gameRef.size.width - 200;
  }

  @override
  void update(double dt) {
    super.update(dt);
    final gamepad = connectedGamepad();
    text =  '''
    Gamepad: ${gamepad != null}
    Button1: ${gamepad != null ? gamepad.buttons[0].pressed : '-'}
    Button2: ${gamepad != null ? gamepad.buttons[1].pressed : '-'}
    Button3: ${gamepad != null ? gamepad.buttons[2].pressed : '-'}
    Button4: ${gamepad != null ? gamepad.buttons[3].pressed : '-'}
    Axes1: ${gamepad != null ? gamepad.axes[0].toString() : '-'}
    Axes2: ${gamepad != null ? gamepad.axes[1].toString() : '-'}
    Status: ${gamepadStrStatus()}
    ''';
  }
}
