package magnetkid.physics.intent;

import magnetkid.physics.World.State in WorldState;


class AlwaysActiveIntent implements Intent {
  private var initialForce: Force;

  public function new(force: Force) {
    this.initialForce = force;
  }

  public function active(): Bool {
    return true;
  }

  public function update(state: WorldState, dt: Float) {}

  public function force(): Force {
    return initialForce;
  }
}
