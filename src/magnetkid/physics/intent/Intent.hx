package magnetkid.physics.intent;

import magnetkid.physics.World.State in WorldState;

interface Intent {
  public function active(): Bool;
  public function update(state: WorldState, dt: Float): Void;
  public function force(): Force;
}
