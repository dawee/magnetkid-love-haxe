package love;

import love.Love.API;
import love.LifecycleListener;
import love.KeyEventListener;

class Bridge {
  private var lifecycleListeners:List<LifecycleListener>;
  private var keyEventListeners:List<KeyEventListener>;

  public function new() {
    lifecycleListeners = new List<LifecycleListener>();
    keyEventListeners = new List<KeyEventListener>();
  }

  public function addLifecycleListener(listener:LifecycleListener) {
    lifecycleListeners.add(listener);
  }

  public function addKeyEventListener(listener:KeyEventListener) {
    keyEventListeners.add(listener);
  }

  public function load() {
    lifecycleListeners.map(listener -> listener.load());
  }

  public function draw() {
    lifecycleListeners.map(listener -> listener.draw());
  }

  public function update(dt: Float) {
    lifecycleListeners.map(listener -> listener.update(dt));
  }

  public function keypressed(key: String) {
    keyEventListeners.map(listener -> listener.keypressed(key));
  }

  public function keyreleased(key: String) {
    keyEventListeners.map(listener -> listener.keyreleased(key));
  }
}
