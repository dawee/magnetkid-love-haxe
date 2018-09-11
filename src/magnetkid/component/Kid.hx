package magnetkid.component;

import love.Love;
import love.Love.Image;
import love.Love.Quad;

using magnetkid.physics.World.KidState;
using magnetkid.physics.World.IntentName;
using magnetkid.physics.IntentListener;

enum Posture {
  StandLeft;
  StandRight;
  SeekAttractionUpLookingLeft;
  SeekAttractionUpLookingRight;
}

class Kid implements IntentListener {
  public static inline var WIDTH:Float = 72;
  public static inline var HEIGHT:Float = 112;

  private var image:Image;
  private var quadsMap:Map<Posture, Quad>;
  private var posture:Posture;

  public function new() {
    posture = StandRight;
  }

  private function createQuad(row:Float, col:Float) {
    var dimensions = image.getDimensions();

    return Love.graphics.newQuad(
      col * WIDTH,
      row * HEIGHT,
      WIDTH,
      HEIGHT,
      dimensions.width,
      dimensions.height
    );
  }

  public function validatedIntent(intentName: IntentName) {
    posture = switch (intentName) {
      case WalkLeft: StandLeft;
      case WalkRight: StandRight;
      default: posture;
    }
  }

  public function addedIntent(intentName: IntentName) {
    trace(intentName);
    posture = switch (intentName) {
      case SeekAttractionUp: switch (posture) {
        case StandLeft: SeekAttractionUpLookingLeft;
        case StandRight: SeekAttractionUpLookingRight;
        default: posture;
      };
      default: posture;
    }
  }

  public function removedIntent(intentName: IntentName) {
    posture = switch (intentName) {
      case SeekAttractionUp: switch (posture) {
        case SeekAttractionUpLookingLeft: StandLeft;
        case SeekAttractionUpLookingRight: StandRight;
        default: posture;
      };
      default: posture;
    }
  }

  public function load() {
    image = Love.graphics.newImage('assets/kid.png');
    quadsMap = [
      StandLeft => createQuad(1, 3),
      StandRight => createQuad(1, 0),
      SeekAttractionUpLookingRight => createQuad(1, 1),
      SeekAttractionUpLookingLeft => createQuad(1, 2),
    ];
  }

  public function draw(camera: Camera, state: KidState) {
    var screenPosition = camera.getScreenPosition(state.position);
    var quad = quadsMap[posture];

    Love.graphics.setColor(1.0, 1.0, 1.0, 1.0);
    Love.graphics.draw(
      image,
      quad,
      screenPosition.x - WIDTH / 2,
      screenPosition.y - HEIGHT / 2
    );
  }
}
