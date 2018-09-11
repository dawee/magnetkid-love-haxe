package magnetkid.physics;

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

typedef PlatformState = Rect;

typedef Force = {
  minVelocity: Vec2,
  acceleration: Vec2,
};

typedef Condition = Option<() -> Bool>;

typedef Intent = {
  > Force,
  condition: Condition,
  validated: Bool
};

enum IntentName {
  Gravity;
  Jump;
  WalkLeft;
  WalkRight;
  SeekAttractionUp;
}

typedef KidState = {
  position: Vec2,
  velocity: Vec2,
  boundingBox: Rect,
  intents: Map<IntentName, Intent>,
  touchesPlatformTop: Bool,
  touchesPlatformRight: Bool,
  touchesPlatformLeft: Bool
};

class World {
  public static inline var KID_HEIGHT:Float = 1.5;

  private static var ZeroVec2:Vec2 = { x: 0, y: 0 };
  private static var ZeroForce:Force = {
    acceleration: ZeroVec2,
    minVelocity: ZeroVec2
  };

  private var GRAVITY:Force = {
    acceleration: { x: 0, y: -20 },
    minVelocity: { x: 0, y: 0 }
  };

  private var WALK_LEFT:Force = {
    acceleration: { x: 0, y: 0 },
    minVelocity: { x: -15.0 * (1000 / 3600.0), y: 0 },
  };

  private var WALK_RIGHT:Force = {
    acceleration: { x: 0, y: 0 },
    minVelocity: { x: 15.0 * (1000 / 3600.0), y: 0 },
  };

  private var JUMP:Force = {
    acceleration: { x: 0, y: 500 },
    minVelocity: { x: 0, y: 0 },
  };

  private var intentListeners: List<IntentListener>;

  public var platforms(default, null): List<PlatformState>;
  public var kid(default, null): KidState;

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
      intents: [
        Gravity => {
          acceleration: GRAVITY.acceleration,
          minVelocity: GRAVITY.minVelocity,
          condition: None,
          validated: false
        }
      ]
    };

    intentListeners = new List<IntentListener>();
    platforms = new List<Rect>();
    platforms.add({left: -5, top: -3, width: 5, height: 0.5});
    platforms.add({left: 0, top: -3.5, width: 5, height: 0.5});
    platforms.add({left: 5, top: -4, width: 5, height: 0.5});
    platforms.add({left: 10, top: -3.5, width: 5, height: 0.5});
  }

  private function addIntent(intentName: IntentName, force: Force, condition: Condition) {
    kid.intents[intentName] = {
      acceleration: force.acceleration,
      minVelocity: force.minVelocity,
      condition: condition,
      validated: false
    };

    intentListeners.map(listener -> listener.addedIntent(intentName));
  }

  private function removeIntent(intentName: IntentName) {
    kid.intents.remove(intentName);
    intentListeners.map(listener -> listener.removedIntent(intentName));
  }

  private function hasMetallicElementUp():Bool {
    return false;
  }

  public function addIntentListener(listener: IntentListener) {
    intentListeners.add(listener);
  }

  public function startWalkingLeft() {
    addIntent(WalkLeft, WALK_LEFT, Some(() -> kid.touchesPlatformTop));
  }

  public function startWalkingRight() {
    addIntent(WalkRight, WALK_RIGHT, Some(() -> kid.touchesPlatformTop));
  }

  public function stopWalkingLeft() {
    removeIntent(WalkLeft);
  }

  public function stopWalkingRight() {
    removeIntent(WalkRight);
  }

  public function kidJump() {
    addIntent(Jump, JUMP, Some(() -> kid.touchesPlatformTop));
  }

  private function validateCondition(condition: Condition) {
    return switch (condition) {
      case None: true;
      case Some(predicate): predicate();
    };
  }

  private function updateIntentValidations() {
    for (intentName in kid.intents.keys()) {
      var intent = kid.intents[intentName];
      var validated = validateCondition(intent.condition);

      if (validated && !intent.validated) {
        for (listener in intentListeners) {
          listener.validatedIntent(intentName);
        }
      }

      intent.validated = validated;
    }
  }

  public function seekAttractionUp() {
    addIntent(SeekAttractionUp, ZeroForce, None);
  }

  public function stopSeekingAttractionUp() {
    removeIntent(SeekAttractionUp);
  }

  private function computeForce(intents: Iterable<Intent>): Force {
    return Lambda.fold(
      kid.intents,
      (intent: Intent, computed: Force) -> {
        if (!intent.validated) {
          return computed;
        }

        return {
          acceleration: {
            x: intent.acceleration.x + computed.acceleration.x,
            y: intent.acceleration.y + computed.acceleration.y
          },
          minVelocity: {
            x: Math.abs(intent.minVelocity.x) > Math.abs(computed.minVelocity.x)
              ? intent.minVelocity.x
              : computed.minVelocity.x,
            y: Math.abs(intent.minVelocity.y) > Math.abs(computed.minVelocity.y)
              ? intent.minVelocity.y
              : computed.minVelocity.y,
          }
        };
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
    updateIntentValidations();

    var force = computeForce(kid.intents);
    var nextVelocity = computeVelocity(kid.velocity, force, dt);
    var nextPosition = computePosition(kid.position, kid.velocity, dt);

    kid.touchesPlatformTop = false;
    kid.touchesPlatformRight = false;
    kid.touchesPlatformLeft = false;

    for (platform in platforms) {
      if (!kid.touchesPlatformTop && nextVelocity.y < 0) {
        kid.touchesPlatformTop = kid.position.y + kid.boundingBox.top - kid.boundingBox.height >= platform.top
          && nextPosition.y + kid.boundingBox.top - kid.boundingBox.height <= platform.top
          && kid.position.x + kid.boundingBox.left + kid.boundingBox.width >= platform.left
          && kid.position.x + kid.boundingBox.left <= platform.left + platform.width;

        if (kid.touchesPlatformTop) {
          kid.position.y = platform.top + kid.boundingBox.height - kid.boundingBox.top;
          kid.velocity.y = 0;
        }
      }

      if (!kid.touchesPlatformRight && nextVelocity.x < 0) {
        kid.touchesPlatformRight = kid.position.x + kid.boundingBox.left >= platform.left + platform.width
          && nextPosition.x + kid.boundingBox.left <= platform.left + platform.width
          && kid.position.y + kid.boundingBox.top - kid.boundingBox.height <= platform.top
          && kid.position.y + kid.boundingBox.top >= platform.top + platform.height;

        if (kid.touchesPlatformRight) {
          kid.position.x = platform.left + platform.width - kid.boundingBox.left;
          kid.velocity.x = 0;
        }
      }

      if (!kid.touchesPlatformLeft && nextVelocity.x > 0) {
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

    kid.intents.remove(Jump);
  }
}
