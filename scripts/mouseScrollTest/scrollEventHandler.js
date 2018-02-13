function handle(delta) {
  var event = {
    getCount: function() { return delta; }
  };
    Processing.getInstanceById('sketch').mouseWheel(event);
}
 
function wheel(event){
  event.preventDefault();
  var delta = 0;
  if (!event) {
    event = window.event;
  }
  if (event.wheelDelta) {
    delta = event.wheelDelta/120; 
    if (window.opera) {
      delta = -delta;
    }
  } else if (event.detail) {
    delta = -event.detail/3;
  }
  if (delta) {
    handle(delta);
  }
  return false;
}

function bind(obj){
  if (obj.addEventListener){
    obj.addEventListener('DOMMouseScroll', wheel, false);
  }
  obj.onmousewheel = wheel;
}

bind(document.getElementById('sketch'));
