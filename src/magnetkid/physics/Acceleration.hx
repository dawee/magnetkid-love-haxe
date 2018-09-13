package magnetkid.physics;

abstract Acceleration(Array<Float>) {
  public var x(get, set): Float;
  public var y(get, set): Float;

  public static var Null(default, null): Acceleration = Acceleration.fromX(0);

  inline public function new(x: Float, y: Float) {
    this = new Array<Float>();
    this.push(x);
    this.push(y);
  }

  public function get_x() {
    return this[0];
  }

  public function set_x(x: Float) {
    return this[0] = x;
  }

  public function get_y() {
    return this[1];
  }

  public function set_y(y: Float) {
    return this[1] = y;
  }

  public function integrate(dt: Float): Velocity {
    return new Velocity(x * dt, y * dt);
  }

  public static function fromArray(array: Array<Float>): Acceleration {
    return new Acceleration(array[0], array[1]);
  }

  public static function fromX(x: Float) {
    return new Acceleration(x, 0);
  }

  public static function fromY(y: Float) {
    return new Acceleration(0, y);
  }

  public function toForce(): Force {
    var acceleration = Acceleration.fromArray(this);

    return Force.fromAcceleration(acceleration);
  }

  @:op(A + B)
  public static function add(accA: Acceleration, accB: Acceleration) {
    return new Acceleration(accA.x + accB.x, accA.y + accB.y);
  }
}
