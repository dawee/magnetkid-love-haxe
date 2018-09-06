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
  position: Vec2,
  velocity: Vec2,
  boundingBox: Rect,
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
      boundingBox: {
        left: -0.3,
        top: KID_HEIGHT / 2,
        width: 0.6,
        height: KID_HEIGHT
      },
      position: { x: 0, y: 0 },
      velocity: { x: 0, y: 0 },
      walkingLeft: false,
      walkingRight: false,
    };

    platforms = new List<Rect>();
    platforms.add({left: -5, top: -3, width: 5, height: 0.5});
    platforms.add({left: 0, top: -3.5, width: 5, height: 0.5});
    platforms.add({left: 5, top: -4, width: 5, height: 0.5});
    platforms.add({left: 10, top: -3.5, width: 5, height: 0.5});
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

    var touchesPlatformTop = false;
    var touchesPlatformRight = false;
    var touchesPlatformLeft = false;

    for (platform in platforms) {
      if (!touchesPlatformTop) {
        touchesPlatformTop = kid.position.y + kid.boundingBox.top - kid.boundingBox.height >= platform.top
          && nextPosition.y + kid.boundingBox.top - kid.boundingBox.height <= platform.top
          && kid.position.x + kid.boundingBox.left + kid.boundingBox.width >= platform.left
          && kid.position.x + kid.boundingBox.left <= platform.left + platform.width;

        if (touchesPlatformTop) {
          kid.position.y = platform.top + kid.boundingBox.height - kid.boundingBox.top;
          kid.velocity.y = 0;
        }
      }

      if (!touchesPlatformRight) {
        touchesPlatformRight = kid.position.x + kid.boundingBox.left >= platform.left + platform.width
          && nextPosition.x + kid.boundingBox.left <= platform.left + platform.width
          && kid.position.y + kid.boundingBox.top - kid.boundingBox.height <= platform.top
          && kid.position.y + kid.boundingBox.top >= platform.top + platform.height;

        if (touchesPlatformRight) {
          kid.position.x = platform.left + platform.width - kid.boundingBox.left;
          kid.velocity.x = 0;
        }
      }

      if (!touchesPlatformLeft) {
        touchesPlatformLeft = kid.position.x + kid.boundingBox.left + kid.boundingBox.width <= platform.left
          && nextPosition.x + kid.boundingBox.left + kid.boundingBox.width >= platform.left
          && kid.position.y + kid.boundingBox.top - kid.boundingBox.height <= platform.top
          && kid.position.y + kid.boundingBox.top >= platform.top + platform.height;


        if (touchesPlatformLeft) {
          kid.position.x = platform.left - kid.boundingBox.width - kid.boundingBox.left;
          kid.velocity.x = 0;
        }
      }
    }

    if (!touchesPlatformTop) {
      kid.velocity.y = nextVelocity.y;
      kid.position.y = nextPosition.y;
    }

    if (!touchesPlatformRight && !touchesPlatformLeft) {
      kid.velocity.x = nextVelocity.x;
      kid.position.x = nextPosition.x;
    }
  }
}
