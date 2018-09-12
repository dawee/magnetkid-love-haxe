package magnetkid.physics;

class Force {
  public var acceleration(default, null): Acceleration;
  public var minVelocity(default, null): Velocity;
  public var maxVelocity(default, null): Velocity;

  public static var Null(default, null): Force =
    Force.fromAcceleration(Acceleration.Null);

  public function new(
    acceleration: Acceleration,
    minVelocity: Velocity,
    maxVelocity: Velocity
  ) {
    this.acceleration = acceleration;
    this.minVelocity = minVelocity;
    this.maxVelocity = maxVelocity;
  }

  public static function fromAcceleration(acceleration: Acceleration): Force {
    return new Force(acceleration, Velocity.Null, Velocity.Null);
  }

  public static function fromMinVelocity(minVelocity: Velocity): Force {
    return new Force(Acceleration.Null, minVelocity, Velocity.Null);
  }

  public static function fromMaxVelocity(maxVelocity: Velocity): Force {
    return new Force(Acceleration.Null, Velocity.Null, maxVelocity);
  }
}
