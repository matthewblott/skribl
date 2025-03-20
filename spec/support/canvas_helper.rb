module CanvasHelper
  
  # Use JavaScript to draw on the canvas
  def draw_on_canvas_using_js(page)
    page.execute_script(<<~JS
      const canvas = document.getElementsByTagName('canvas')[0];
      const ctx = canvas.getContext('2d');
      
      // Draw a simple line
      ctx.beginPath();
      ctx.moveTo(20, 20);
      ctx.lineTo(100, 100);
      ctx.strokeStyle = 'black';
      ctx.lineWidth = 2;
      ctx.stroke();
    JS
    )

  end

  def draw_on_canvas(page)
    rect = page.evaluate_script(<<~JS
      (() => {
        const canvas = document.getElementsByTagName('canvas')[0];
        const rect = canvas.getBoundingClientRect();
        return {
          left: rect.left,
          top: rect.top,
          width: rect.width,
          height: rect.height
        };
      })()
    JS
    )
    
    # Calculate start coordinates
    start_x = rect['left'] + 10
    start_y = rect['top'] + 10
    
    # Use Cuprite's browser mouse methods
    page.driver.browser.mouse.move(x: start_x, y: start_y)
    page.driver.browser.mouse.down(button: :left)
    page.driver.browser.mouse.move(x: start_x + 50, y: start_y + 50)
    page.driver.browser.mouse.move(x: start_x + 80, y: start_y + 30)
    page.driver.browser.mouse.move(x: start_x + 120, y: start_y + 70)
    page.driver.browser.mouse.up(button: :left)
  end

  def draw_on_canvas_using_touch(page)
    # Inject the touch events via JavaScript
    page.execute_script(<<~JS
      (function() {
        const canvas = document.getElementsByTagName('canvas')[0];
        const rect = canvas.getBoundingClientRect();
        
        // Function to create a synthetic touch
        function createTouch(x, y) {
          return {
            identifier: 0,
            target: canvas,
            clientX: rect.left + x,
            clientY: rect.top + y,
            screenX: rect.left + x,
            screenY: rect.top + y,
            pageX: rect.left + x,
            pageY: rect.top + y,
            radiusX: 2.5,
            radiusY: 2.5,
            rotationAngle: 0,
            force: 1
          };
        }
        
        // Function to dispatch touch event
        function dispatchTouchEvent(type, touches) {
          const touchEvent = new CustomEvent(type, {
            bubbles: true,
            cancelable: true
          });
          
          touchEvent.touches = touches;
          touchEvent.targetTouches = touches;
          touchEvent.changedTouches = touches;
          
          canvas.dispatchEvent(touchEvent);
        }
        
        // Start touch
        dispatchTouchEvent('touchstart', [createTouch(10, 10)]);
        
        // Move touch to draw
        dispatchTouchEvent('touchmove', [createTouch(50, 50)]);
        dispatchTouchEvent('touchmove', [createTouch(80, 30)]);
        dispatchTouchEvent('touchmove', [createTouch(120, 70)]);
        
        // End touch
        dispatchTouchEvent('touchend', []);
      })();
    JS
    )
    

  end

end

RSpec.configure do |config|
  config.include CanvasHelper, type: :request
  config.include CanvasHelper, type: :system
end
