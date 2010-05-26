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

package hxColorToolkit.schemes;

	import hxColorToolkit.ColorUtil;
	import hxColorToolkit.spaces.IColor;
	import hxColorToolkit.spaces.HSB;
	
	class Analogous<C:IColor> extends ColorWheelScheme<C> {
		
		public var angle(getAngle, setAngle) : Float;
		
		public var contrast(getContrast, setContrast) : Float;
		
		var _angle:Float;
		var _contrast:Float;
		
		private function getAngle():Float{ return _angle; }
		private function setAngle(value:Float):Float{
			_colors = new ColorList<C>();
			_angle=value;
			generate();	
			return value;
		}
		
		private function getContrast():Float{ return _contrast; }
		private function setContrast(value:Float):Float{
			_colors = new ColorList<C>();
			_contrast=value;
			generate();	
			return value;
		}
		
		public function new(primaryColor:C, ?angle:Float=10, ?contrast:Float=25)
		{
			_angle=angle;
			_contrast=contrast;
			super(primaryColor);
		}
		
		override function generate():Void
		{
			var _primaryHSB:HSB = new HSB();
			_primaryHSB.color=_primaryColor.color;
			var newHSB:HSB = new HSB();
			var array: Array<Array<Float>> = [[1.0, 2.2], [2.0, 1.0], [-1.0, -0.5], [-2.0, 1.0]];
			for (i in 0...array.length) {
				var one = array[i][0];
				var two = array[i][1];
				
				newHSB.color = ColorUtil.rybRotate(_primaryHSB.color, _angle * one);
				var t: Float = 0.44 - two * 0.1;
				if(_primaryHSB.brightness - _contrast * two < t) {
					newHSB.brightness=t * 100;
				} else {
					newHSB.brightness=_primaryHSB.brightness - _contrast * two;
				}
				newHSB.saturation= newHSB.saturation - 5;
				_colors.addColor(mutateFromPrimary(newHSB.color));
			}
		}
	}
