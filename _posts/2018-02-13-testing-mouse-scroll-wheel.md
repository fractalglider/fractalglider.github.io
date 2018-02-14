---
layout: post
title: Testing the mouse scroll wheel
date:   2018-02-13 13:37:00 +0200
categories: fun
---

<div class="home">

  <script type="text/javascript" src="/scripts/processing-1.4.8.min.js"></script>

<div markdown="1">
A few days ago I noticed that the [scroll wheel][scroll_wheel] of my mouse stopped working properly. While being rotated in one direction, it sometimes generates events as if it were scrolled in the opposite one. This results in a jerking motion which makes it very inconvenient to browse any lengthy text, not to mention playing games.

Trying to investigate the issue, I looked for a tool to inspect the scroll events as they are spawned and spot any anomalies. In fact, since I wasn't going to install random apps into my system, I was looking for web pages only. For some reason, I couldn't find one, so I decided to write my own. 

The programming language [Processing][processing] ([Wikipedia][processing_wikipedia]) proved to be the right tool  for the job. Its standard library, designed for interactive 2D graphics, allowed me to create a very simple (55 lines long) [program][sketch_github].

[scroll_wheel]:https://en.wikipedia.org/wiki/Scroll_wheel
[processing]:https://processing.org
[processing_wikipedia]:https://en.wikipedia.org/wiki/Processing_(programming_language)
[sketch_github]:https://github.com/fractalglider/fractalglider.github.io/blob/master/scripts/mouseScrollTest/mouseScrollTest.pde
</div>

  <div id="sketch-float" style="float: left; margin-right: 10px">
    <canvas id="sketch" data-processing-sources="/scripts/mouseScrollTest/mouseScrollTest.pde"></canvas>
    <script type="text/javascript" src="/scripts/mouseScrollTest/scrollEventHandler.js"></script>
  </div>

<div markdown="1">
Try it yourself. Hover your mouse pointer over the canvas and scroll in one direction as fast as you can. The program will draw a colored streamer moving to the right and also in the direction you're scrolling. As long as you don't change scrolling direction, the streamer should stay the same color. If you see spots of a different color, it means that your mouse wheel is glitchy too.

Having written the program to run in the Processing sketchbook, I decided to share it by publishing it here. I was spared the need to port my code to Javascript, thanks to an awesome library called [Processing.js][processingjs] ([Wikipedia][processingjs_wikipedia]). It is an implementation of Processing in Javascript, which can draw a sketch inside a HTML canvas. So I created a basic HTML page and linked my code along with the library. But not everything worked right away --- hardly a surprise when it comes to web page development.

It turns out that Processing.js version 1.4.8 does not handle mouse scroll events. I guess this is caused by the sad fact that every browser [handles them in a different way][browser_problems]. Fortunately, Processing.js allows [calling Processing functions from the Javascript code][processing_js_binding]. This means that a custom event handler can solve the issue.

I came across an [implementation][js_scroll_handler] which is claimed to work in most new browsers. After some [tweaks][event_handling_tweak], I managed to fit it to my needs. The scroll event handler [turned out to be][event_handler_github] more complex than the original program itself, mostly due to quirks of different browsers. Good thing I don't have to program webpages for a living!

[processingjs]:http://processingjs.org/
[processingjs_wikipedia]:https://en.wikipedia.org/wiki/Processing.js
[processing_js_binding]:http://processingjs.org/articles/jsQuickStart.html#accessingprocessingfromjs
[browser_problems]:https://stackoverflow.com/questions/25204282/mousewheel-wheel-and-dommousescroll-in-javascript
[js_scroll_handler]:http://www.emanueleferonato.com/2006/07/29/mouse-wheel-handler-in-javascript
[event_handling_tweak]:https://stackoverflow.com/questions/10313142/javascript-capture-mouse-wheel-event-and-do-not-scroll-the-page
[event_handler_github]:https://github.com/fractalglider/fractalglider.github.io/blob/master/scripts/mouseScrollTest/scrollEventHandler.js
</div>

</div>
