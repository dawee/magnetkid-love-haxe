package magnetkid;

import love.JoystickEventListener;
import love.LifecycleListener;
import love.Love;

import magnetkid.physics.World;

class Game implements LifecycleListener implements JoystickEventListener {
  private var world: World;


  static public function main():Void {
    var game = new Game();

    Love.bridge.addLifecycleListener(game);
    Love.bridge.addJoystickEventListener(game);
  }

  public function new() {
    world = new World();
  }

  public function load() {}

  public function draw() {}

  public function update(dt: Float) {}

  public function gamepadaxis(axis: String, value: Float) {}

  public function gamepadpressed(button: String) {}

  public function gamepadreleased(button: String) {}

  public function joystickaxis(axis: Int, value: Float) {}

}
