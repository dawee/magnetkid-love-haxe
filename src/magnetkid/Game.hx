package magnetkid;

import love.LifecycleListener;
import love.Love;

import magnetkid.Camera;
import magnetkid.component.Kid;
import magnetkid.component.Platform;

class Game implements LifecycleListener {
  private var world:World;
  private var camera:Camera;

  static public function main():Void {
    var game = new Game();

    Love.bridge.addLifecycleListener(game);
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

    for (platform in world.platforms) {
      Platform.draw(camera, platform);
    }
  }

  public function update(dt: Float) {
    world.step(dt);
    camera.lookAt(world.kid.position);
  }
}
