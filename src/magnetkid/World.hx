package magnetkid;

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

typedef Kid = {
  walkingLeft: Bool,
  walkingRight: Bool,
  height: Float,
  feetWidth: Float,
  position: Vec2,
  velocity: Vec2
};

class World {
  public static inline var KID_HEIGHT:Float = 1.5;
  public static inline var WALK_VELOCITY:Float = 10.0 * 1000 / 3600.0;

  private var gravity: Float;

  public var platforms(default, null): List<Platform>;
  public var kid(default, null): Kid;

  public function new() {
    gravity = -20;
    kid = {
      height: KID_HEIGHT,
      feetWidth: 0.6,
      position: { x: 0, y: 0 },
      velocity: { x: 0, y: 0 },
      walkingLeft: false,
      walkingRight: false,
    };

    platforms = new List<Rect>();
    platforms.add({left: -5, top: -3, width: 10, height: 0.5});
    platforms.add({left: 0, top: -3.5, width: 10, height: 0.5});
    platforms.add({left: 5, top: -4, width: 10, height: 0.5});
  }

  public function startWalkingLeft() {
    kid.walkingLeft = true;
  }

  public function startWalkingRight() {
    kid.walkingRight = true;
  }

  public function stopWalkingLeft() {
    kid.walkingLeft = false;
  }

  public function stopWalkingRight() {
    kid.walkingRight = false;
  }

  public function step(dt: Float) {
    var nextVelocity: Vec2 = {
      x: kid.velocity.x,
      y: kid.velocity.y + gravity * dt
    };

    if (kid.walkingLeft && !kid.walkingRight) {
      nextVelocity.x = -WALK_VELOCITY;
    } else if (kid.walkingRight && !kid.walkingLeft) {
      nextVelocity.x = WALK_VELOCITY;
    } else {
      nextVelocity.x = 0;
    }

    var nextPosition: Vec2 = {
      x: kid.position.x + nextVelocity.x * dt,
      y: kid.position.y + nextVelocity.y * dt
    };

    var touchesPlatform = false;

    for (platform in platforms) {
      touchesPlatform = kid.position.y - kid.height / 2 >= platform.top
        && nextPosition.y - kid.height / 2 <= platform.top
        && kid.position.x + kid.feetWidth / 2 > platform.left
        && kid.position.x - kid.feetWidth / 2 < platform.left + platform.width;

      if (touchesPlatform) {
        kid.position.y = platform.top + kid.height / 2;
        kid.velocity.y = 0;
        break;
      }
    }

    if (!touchesPlatform) {
      kid.velocity.y = nextVelocity.y;
      kid.position.y = nextPosition.y;
    }

    kid.velocity.x = nextVelocity.x;
    kid.position.x = nextPosition.x;
  }
}
