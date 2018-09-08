package magnetkid;

import haxe.ds.Option;

typedef Vec2 = {
  x: Float,
  y: Float
};

typedef Rect = {
  left: Float,
  top: Float,
  width: Float,
  height: Float
};

typedef Platform = Rect;

typedef Force = {
  minVelocity: Vec2,
  acceleration: Vec2,
};

enum ForceName {
  Gravity;
  WalkLeft;
  WalkRight;
}

typedef Kid = {
  position: Vec2,
  velocity: Vec2,
  boundingBox: Rect,
  forces: Map<ForceName, Force>,
  touchesPlatformTop: Bool,
  touchesPlatformRight: Bool,
  touchesPlatformLeft: Bool,
};

class World {
  public static inline var KID_HEIGHT:Float = 1.5;

  private static var WALK_LEFT:Force = {
    acceleration: { x: 0, y: 0 },
    minVelocity: { x: -10.0 * (1000 / 3600.0), y: 0 }
  };

  private static var WALK_RIGHT:Force = {
    acceleration: { x: 0, y: 0 },
    minVelocity: { x: 10.0 * (1000 / 3600.0), y: 0 }
  };

  private static var GRAVITY:Force = {
    acceleration: { x: 0, y: -20 },
    minVelocity: { x: 0, y: 0 }
  };

  public var platforms(default, null): List<Platform>;
  public var kid(default, null): Kid;

  public function new() {
    kid = {
      boundingBox: {
        left: -0.3,
        top: KID_HEIGHT / 2,
        width: 0.6,
        height: KID_HEIGHT
      },
      position: { x: 0, y: 0 },
      velocity: { x: 0, y: 0 },
      touchesPlatformTop: false,
      touchesPlatformRight: false,
      touchesPlatformLeft: false,
      forces: [
        Gravity => GRAVITY
      ]
    };

    platforms = new List<Rect>();
    platforms.add({left: -5, top: -3, width: 5, height: 0.5});
    platforms.add({left: 0, top: -3.5, width: 5, height: 0.5});
    platforms.add({left: 5, top: -4, width: 5, height: 0.5});
    platforms.add({left: 10, top: -3.5, width: 5, height: 0.5});
  }

  public function startWalkingLeft() {
    kid.forces[WalkLeft] = WALK_LEFT;
  }

  public function startWalkingRight() {
    kid.forces[WalkLeft] = WALK_RIGHT;
  }

  public function stopWalkingLeft() {
    kid.forces.remove(WalkLeft);
  }

  public function stopWalkingRight() {
    kid.forces.remove(WalkRight);
  }

  private function mergeForces(forces: Iterable<Force>): Force {
    return Lambda.fold(
      kid.forces,
      (force: Force, computed: Force) -> {
        acceleration: {
          x: force.acceleration.x + computed.acceleration.x,
          y: force.acceleration.y + computed.acceleration.y
        },
        minVelocity: {
          x: Math.abs(force.minVelocity.x) > Math.abs(computed.minVelocity.x)
            ? force.minVelocity.x
            : computed.minVelocity.x,
          y: Math.abs(force.minVelocity.y) > Math.abs(computed.minVelocity.y)
            ? force.minVelocity.y
            : computed.minVelocity.y,
        }
      },
      {
        acceleration: { x: 0, y: 0 },
        minVelocity: { x: 0, y: 0 }
      }
    );
  }

  private function integrateAcceleration(velocity: Vec2, acceleration: Vec2, dt: Float): Vec2 {
    return {
      x: kid.touchesPlatformTop && acceleration.x == 0 ? 0 : velocity.x + acceleration.x * dt,
      y: velocity.y + acceleration.y * dt,
    };
  }

  private function computeVelocity(velocity: Vec2, force: Force, dt: Float): Vec2 {
    var integration = integrateAcceleration(velocity, force.acceleration, dt);

    trace(force.minVelocity.x);
    return {
      x: Math.abs(integration.x) < Math.abs(force.minVelocity.x) ? force.minVelocity.x : integration.x,
      y: Math.abs(integration.y) < Math.abs(force.minVelocity.y) ? force.minVelocity.y : integration.y,
    };
  }

  private function computePosition(position: Vec2, velocity: Vec2, dt: Float): Vec2 {
    return {
      x: position.x + velocity.x * dt,
      y: position.y + velocity.y * dt,
    };
  }

  public function step(dt: Float) {
    var force = mergeForces(kid.forces);
    var nextVelocity = computeVelocity(kid.velocity, force, dt);
    var nextPosition = computePosition(kid.position, kid.velocity, dt);

    kid.touchesPlatformTop = false;
    kid.touchesPlatformRight = false;
    kid.touchesPlatformLeft = false;

    for (platform in platforms) {
      if (!kid.touchesPlatformTop) {
        kid.touchesPlatformTop = kid.position.y + kid.boundingBox.top - kid.boundingBox.height >= platform.top
          && nextPosition.y + kid.boundingBox.top - kid.boundingBox.height <= platform.top
          && kid.position.x + kid.boundingBox.left + kid.boundingBox.width >= platform.left
          && kid.position.x + kid.boundingBox.left <= platform.left + platform.width;

        if (kid.touchesPlatformTop) {
          kid.position.y = platform.top + kid.boundingBox.height - kid.boundingBox.top;
          kid.velocity.y = 0;
        }
      }

      if (!kid.touchesPlatformRight) {
        kid.touchesPlatformRight = kid.position.x + kid.boundingBox.left >= platform.left + platform.width
          && nextPosition.x + kid.boundingBox.left <= platform.left + platform.width
          && kid.position.y + kid.boundingBox.top - kid.boundingBox.height <= platform.top
          && kid.position.y + kid.boundingBox.top >= platform.top + platform.height;

        if (kid.touchesPlatformRight) {
          kid.position.x = platform.left + platform.width - kid.boundingBox.left;
          kid.velocity.x = 0;
        }
      }

      if (!kid.touchesPlatformLeft) {
        kid.touchesPlatformLeft = kid.position.x + kid.boundingBox.left + kid.boundingBox.width <= platform.left
          && nextPosition.x + kid.boundingBox.left + kid.boundingBox.width >= platform.left
          && kid.position.y + kid.boundingBox.top - kid.boundingBox.height <= platform.top
          && kid.position.y + kid.boundingBox.top >= platform.top + platform.height;


        if (kid.touchesPlatformLeft) {
          kid.position.x = platform.left - kid.boundingBox.width - kid.boundingBox.left;
          kid.velocity.x = 0;
        }
      }
    }

    if (!kid.touchesPlatformTop) {
      kid.velocity.y = nextVelocity.y;
      kid.position.y = nextPosition.y;
    }

    if (!kid.touchesPlatformRight && !kid.touchesPlatformLeft) {
      kid.velocity.x = nextVelocity.x;
      kid.position.x = nextPosition.x;
    }
  }
}
