import love.Bridge;
import love.LifecycleListener;
import love.Love;
import love.Love.API;
import component.Kid;

class Game implements LifecycleListener {
  private var world:World;

  static public function main():Void {
    var game = new Game();

    Bridge.addLifecycleListener(game);
  }

  public function new() {
    world = new World();
  }

  public function load() {
    Kid.load();
  }

  public function draw() {
    Kid.draw(world.kidState);
  }

  public function update(dt: Float) {
    world.step(dt);
  }
}
