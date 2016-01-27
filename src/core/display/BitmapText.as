package core.display 
{
	import core.Manager;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author bangnd2
	 */
	public class BitmapText extends Sprite
	{
		private var bitmap:Bitmap;
		private var bitmapData:BitmapData;
		private var characterWidth:Number;
		private var characterHeight:Number
		private var text:String;
		
		public function BitmapText() 
		{
			bitmap = new Bitmap();
			addChild(bitmap);
			
			reset();
		}
		
		public function setFont(bitmapData:BitmapData, characterWidth:Number, characterHeight:Number):void
		{
			this.bitmapData = bitmapData;
			this.characterWidth = characterWidth;
			this.characterHeight = characterHeight;
		}
		
		public function reset():void
		{
			
		}
		
		public function getFontBitmap():Bitmap {
			return bitmap;
		}
		
		public function setText(text:String):void
		{
			if (text != null && bitmapData != null)
			{
				if (bitmap.bitmapData != null)
				{
					bitmap.bitmapData.dispose();
					bitmap.bitmapData = null;
				}
				if (text.length > 0)
				{
					bitmap.bitmapData = new BitmapData(text.length * characterWidth, characterHeight, true, 0);
					var i:int;
					var length:int;
					var charCode:int;
					var charIndex:int;
					var rect:Rectangle = Manager.pool.pop(Rectangle) as Rectangle;
					var point:Point = Manager.pool.pop(Point) as Point;
					for (i = 0, length = text.length; i < length; ++i)
					{
						charCode = text.charCodeAt(i);
						charIndex = charCode - Keyboard.NUMBER_0;
						rect.x = charIndex * characterWidth;
						rect.y = 0;
						rect.width = characterWidth;
						rect.height = characterHeight;
						point.x = i * characterWidth;
						point.y = 0;
						bitmap.bitmapData.copyPixels(bitmapData, rect, point);
					}
					Manager.pool.push(rect);
					Manager.pool.push(point);
				}
			}
		}
		
		public function getWidth():int
		{
			var textWidth:int = 0;
			if (text != null)
			{
				textWidth = text.length * characterWidth;
			}
			return textWidth;
		}
		
		public function destroy():void
		{
			removeChild(bitmap);
			bitmap = null;
			bitmapData = null;
		}
	}
}