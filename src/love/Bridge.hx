package love;

import love.Love.API;
import love.LifecycleListener;
import love.KeyEventListener;
import love.JoystickEventListener;

class Bridge {
  private var lifecycleListeners:List<LifecycleListener>;
  private var keyEventListeners:List<KeyEventListener>;
  private var joystickEventListeners:List<JoystickEventListener>;

  public function new() {
    lifecycleListeners = new List<LifecycleListener>();
    keyEventListeners = new List<KeyEventListener>();
    joystickEventListeners = new List<JoystickEventListener>();
  }

  public function addLifecycleListener(listener:LifecycleListener) {
    lifecycleListeners.add(listener);
  }

  public function addKeyEventListener(listener:KeyEventListener) {
    keyEventListeners.add(listener);
  }

  public function addJoystickEventListener(listener:JoystickEventListener) {
    joystickEventListeners.add(listener);
  }

  public function load() {
    lifecycleListeners.map(listener -> listener.load());
  }

  public function draw() {
    lifecycleListeners.map(listener -> listener.draw());
  }

  public function update(dt: Float) {
    lifecycleListeners.map(listener -> listener.update(dt));
  }

  public function keypressed(key: String) {
    keyEventListeners.map(listener -> listener.keypressed(key));
  }

  public function keyreleased(key: String) {
    keyEventListeners.map(listener -> listener.keyreleased(key));
  }

  public function gamepadaxis(joystick, axis: String, value: Float) {
    joystickEventListeners.map(listener -> listener.gamepadaxis(axis, value));
  }

  public function gamepadpressed(joystick, button: String) {
    joystickEventListeners.map(listener -> listener.gamepadpressed(button));
  }

  public function gamepadreleased(joystick, button: String) {
    joystickEventListeners.map(listener -> listener.gamepadreleased(button));

  }

  public function joystickaxis(joystick, axis: Int, value: Float) {
    joystickEventListeners.map(listener -> listener.joystickaxis(axis, value));
  }

}
