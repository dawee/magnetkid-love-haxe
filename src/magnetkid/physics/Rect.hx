package magnetkid.physics;


class Rect {
  private var x: Float;
  private var y: Float;
  private var width: Float;
  private var height: Float;

  private var yAxisDirection: Int;

  public function new(
    x: Float,
    y: Float,
    width: Float,
    height: Float,
    yAxisDirection: Int = 1
  ) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.yAxisDirection = yAxisDirection;
  }

  public static function fromPoint(
    point: Point,
    width: Float,
    height: Float,
    yAxisDirection: Int = 1
  ): Rect {
    return new Rect(point.x, point.y, width, height, yAxisDirection);
  }

  public function top(): Float {
    return y + yAxisDirection * height / 2;
  }

  public function right(): Float {
    return x + width / 2;
  }

  public function bottom(): Float {
    return y - yAxisDirection * height / 2;
  }

  public function left(): Float {
    return x - width / 2;
  }

  public function center(): Point {
    return new Point(x, y);
  }

  public function topRightCorner(): Point {
    return new Point(right(), top());
  }

  public function bottomRightCorner(): Point {
    return new Point(right(), bottom());
  }

  public function bottomLeftCorner(): Point {
    return new Point(left(), bottom());
  }

  public function topLeftCorner(): Point {
    return new Point(left(), top());
  }
}
