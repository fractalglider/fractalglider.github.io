---
layout: post
title:  "How to generate the Fractal glider logo"
date:   2016-06-20 13:43:26 +0200
categories: fun
---
This blog's logo is based on the [glider][glider], a pattern that appears in Conway's game of Life. 
Consisting only five cells, this pattern is noteworthy for its interesting behavior. The logo displays the image of a glider, in which individual cells are replaced with scaled images of the same glider, creating a [fractal-like][fractal] structure.

This image is easy to reproduce with a simple script. It requires Bash and [ImageMagick][imagemagick], which are both available for any modern Linux distro. The full script is available [on GitHub][script].

First of all, create basic tiles for composing the image:
{% highlight bash %}
convert -size 1x1 xc:none background.0.gif
convert -size 1x1 xc:black glider.0.gif
{% endhighlight %}
These are just 1x1 white and black pixels.

Create a function that composes these tiles into the glider shape:
{% highlight bash %}
# $1 --- background tile
# $2 --- glider tile
# $3 --- output
function make_glider {
	montage $1 $1 $1 $1 \
		$1 $1 $2 $1 \
		$1 $1 $1 $2 \
		$1 $2 $2 $2 \
	-background none -tile 4x4 -geometry +0+0 $3
}
{% endhighlight %}
It calls the [`montage`][montage] command of ImageMagick to compose a 4x4 glider pattern of the tile images supplied as inputs. If you call this function like this:
{% highlight bash %}
make_glider background.0.gif glider.0.gif glider.1.gif
{% endhighlight %}
a new file `glider.1.gif` will be generated with a 4x4 pixels glider pattern.

The empty top row and left column have been added to preserve visual space between the 'cells' on each nesting level.

Note that Bash doesn't actually have any internal representations of the images; it handles only _filesystem paths_ to the images and passes them to `montage` command. As a result, if `glider.1.gif` already exists before the function is called, it will be silently overwritten.

Now, if we invoke `make_glider` using `glider.1.gif` as the input tile, the result will be a 16x16 glider pattern with each 4x4 cell replaced by a 4x4 glider pattern. Apply it several times on the results of the previous iteration to get a structure fith multiple nesting levels.
{% highlight bash %}
for i in {0..3}
do
	next=$((i+1))
	make_glider "background.$i.gif" "glider.$i.gif" "glider.$next.gif"
	convert "background.$i.gif" -scale 400% "background.$next.gif"
done
{% endhighlight %}
The next line after the call of `make_glider` uses the very generalist `convert` command to [scale][scale] the background tile 4x --- the same amount that the size of pattern tile increases.

Finally [trim][trim] the excessive white space from the top and left sides and add a 10px [border][border]:
{% highlight bash %}
convert glider.*.gif -trim +repage -bordercolor none -border 10x10 glider.%d.gif
{% endhighlight %}

Remove the now redundant background tiles:
{% highlight bash %}
rm background.*.gif
{% endhighlight %}

That's it! Now you have a set of fractal glider logos with sifferent levels of nesting. Change the number of iterations in the `for` loop to get more or fewer levels.

{: style="text-align: center;"}
![A fractal glider logo with 4 nesting levels](/images/glider.4.gif)


[glider]:https://en.wikipedia.org/wiki/Glider_%28Conway%27s_Life%29
[fractal]:https://en.wikipedia.org/wiki/Fractal
[imagemagick]:http://imagemagick.org/script/index.php
[script]:https://gist.github.com/fractalglider/4f5d0357447bd0acc69ba15e6e6ba6fb
[montage]:http://www.imagemagick.org/Usage/montage
[scale]:http://www.imagemagick.org/Usage/resize/#scale
[trim]:http://www.imagemagick.org/Usage/crop/#trim
[border]:http://www.imagemagick.org/Usage/crop/#border

