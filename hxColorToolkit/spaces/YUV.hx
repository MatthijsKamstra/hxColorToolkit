 /*
Author: Andy Li (andy@onthewings.net)
Based on colortoolkit (http://code.google.com/p/colortoolkit/)
 
The MIT License

Copyright (c) 2009 P.J. Onori (pj@somerandomdude.com)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

//http://en.wikipedia.org/wiki/YUV
//http://www.fourcc.org/fccyvrgb.php

package hxColorToolkit.spaces;

class YUV implements Color<YUV> {

	public var numOfChannels(default,null):Int;

	public function getValue(channel:Int):Float {
		return data[channel];
	}
	public function setValue(channel:Int,val:Float):Float {
		if (channel < 0 || channel >= numOfChannels) return Math.NaN;
		data[channel] = Math.min(maxValue(channel), Math.max(val, minValue(channel)));
		return val;
	}

	inline public function minValue(channel:Int):Float {
		return 0;
	}
	inline public function maxValue(channel:Int):Float {
		return 255;
	}
	
	public var u(getU, setU) : Float;
	public var v(getV, setV) : Float;
	public var y(getY, setY) : Float;

	private function getY():Float{
		return getValue(0);
	}

	private function setY(value:Float):Float{
		return setValue(0,value);
	}
	
	private function getU():Float{
		return getValue(1);
	}
	
	private function setU(value:Float):Float{
		return setValue(1,value);
	}
	
	private function getV():Float{
		return getValue(2);
	}
	
	private function setV(value:Float):Float{
		return setValue(2,value);
	}
	
	public function getColor():Int{
		var r = Math.max(0, Math.min(y+1.402*(v-128), 255));
		var g = Math.max(0, Math.min(y-0.344*(u-128)-0.714*(v-128), 255));
		var b = Math.max(0, Math.min(y+1.772*(u-128), 255));
		
		return Math.round(r) << 16 | Math.round(g) << 8 | Math.round(b);
	}
	
	public function setColor(color:Int):Int{
		var r:Float = (color >> 16 & 0xFF);
		var g:Float = (color >> 8 & 0xFF);
		var b:Float = (color & 0xFF);
		this.y = 0.299*r + 0.587*g + 0.114*b;
		this.u = r*-0.169 + g*-0.331 + b*0.499 + 128;
		this.v = r*0.499 + g*-0.418 + b*-0.0813 + 128;
		
		return getColor();
	}
	
	
	public function new(?y:Float=0, ?u:Float=0, ?v:Float=0)
	{
		numOfChannels = 3;
		data = [];
		this.y=y;
		this.u=u;
		this.v=v;
	}
	
	public function clone() { return new YUV(y, u, v); }

	private var data:Array<Float>;

}
