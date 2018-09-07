package love;

import love.Love;

interface JoystickEventListener {
  public function gamepadaxis(axis: String, value: Float):Void;
  public function gamepadpressed(button: String):Void;
  public function gamepadreleased(button: String):Void;
  public function joystickaxis(axis: Int, value: Float):Void;
}
