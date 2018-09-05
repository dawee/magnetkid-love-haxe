import component.Kid;
import Love;

@:expose
class Game {
  private var world:World;
  private var api:LoveAPI;

  public function new(api: LoveAPI) {
    Love.initInstance(api);
    this.world = new World();
  }

  public function load() {
    var quad = Love.graphics.newQuad(0, 0, 300, 300, 300, 300);
  }

  public function draw() {
    this.api.graphics.rectangle('fill', 0, 0, 300, 300);
  }

  public function update(dt: Float) {
    world.step(dt);
  }
}
