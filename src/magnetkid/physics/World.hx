package magnetkid.physics;

import magnetkid.physics.intent.Intent;
import magnetkid.physics.intent.AlwaysActiveIntent;

enum IntentName {
  Gravity;
  Jump;
  MoveLeft;
  MoveRight;
  SeekAttractionUp;
}

typedef State = {
  kid: {
    position: Point,
    velocity: Velocity,
    boundingBox: Rect,
    intents: Map<IntentName, Intent>
  },
  platforms: List<Rect>
}

class World {
  private static inline var KID_WIDTH: Float = 0.5;
  private static inline var KID_HEIGHT: Float = 1.5;

  private static var GRAVITY: Force = Acceleration.fromY(-20).toForce();

  public var state(default, null): State;

  public function new() {
    state = {
      kid: {
        position: Point.Null,
        velocity: Velocity.Null,
        boundingBox: Rect.fromPoint(Point.Null, KID_HEIGHT, KID_HEIGHT),
        intents: [ Gravity => new AlwaysActiveIntent(GRAVITY) ]
      },
      platforms: {
        var platforms = new List<Rect>();

        platforms.add(new Rect(0, -KID_HEIGHT / 2 - 0.25, 2, 0.5));
        platforms;
      }
    }
  }

  public function update(dt: Float) {
    var activeForces = Lambda
      .filter(state.kid.intents, intent -> intent.active())
      .map(intent -> intent.force());

    var force = Lambda.fold(activeForces, Force.merge, Force.Null);
    var nextVelocity = state.kid.velocity + force.acceleration.integrate(dt);
  }

}
