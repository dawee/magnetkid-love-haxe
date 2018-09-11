package magnetkid.physics;

using World.IntentName;

interface IntentListener {
  public function validatedIntent(name: IntentName):Void;
  public function addedIntent(name: IntentName):Void;
  public function removedIntent(name: IntentName):Void;
}
