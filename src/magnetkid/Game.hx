package magnetkid;

import love.JoystickEventListener;
import love.LifecycleListener;
import love.Love;

import magnetkid.Camera;
import magnetkid.component.Kid;
import magnetkid.component.Platform;

class Game implements LifecycleListener implements JoystickEventListener {
  private var world:World;
  private var camera:Camera;

  static public function main():Void {
    var game = new Game();

    Love.bridge.addLifecycleListener(game);
    Love.bridge.addJoystickEventListener(game);
  }

  public function new() {
    world = new World();
    camera = new Camera(Kid.HEIGHT / World.KID_HEIGHT);
  }

  public function load() {
    Kid.load();
    Love.graphics.setBackgroundColor(0.23, 0.03, 0.32, 1.0);
  }

  public function draw() {
    Kid.draw(camera, world.kid);
    world.platforms.map(platform -> Platform.draw(camera, platform));
  }

  public function update(dt: Float) {
    world.step(dt);
    camera.lookAt(world.kid.position);
  }

  public function gamepadaxis(axis: String, value: Float) {
    switch (axis) {
      case 'leftx': {
        if (value < -0.25) {
          world.startWalkingLeft();
        } else if (value > 0.25) {
          world.startWalkingRight();
        } else {
          world.stopWalkingLeft();
          world.stopWalkingRight();
        }
      }
    }
  }

  public function gamepadpressed(button: String) {
  }

  public function gamepadreleased(button: String) {
  }

  public function joystickaxis(axis: Int, value: Float) {
  }

}
