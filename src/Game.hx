import love.LifecycleListener;
import love.Love;
import component.Kid;
import component.Platform;

class Game implements LifecycleListener {
  private var world:World;
  private var kid:Kid;
  private var platform:Platform;

  static public function main():Void {
    var game = new Game();

    Love.bridge.addLifecycleListener(game);
  }

  public function new() {
    world = new World();
    kid = new Kid();
    platform = new Platform();
  }

  public function load() {
    kid.load();

    Love.graphics.setBackgroundColor(0.23, 0.03, 0.32, 1.0);
  }

  public function draw() {
    kid.draw(world.kidState);

    for (platformState in world.platforms) {
      platform.draw(platformState);
    }
  }

  public function update(dt: Float) {
    world.step(dt);
  }
}
