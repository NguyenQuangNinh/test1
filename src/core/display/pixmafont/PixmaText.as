package core.display.pixmafont
{
	import core.memory.MemoryPool;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Transform;
	
	import core.Manager;
	import core.resource.ResourceManager;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class PixmaText extends Sprite
	{
		public static const YELLOW:int = 1;
		public static const GREEN:int = 2;
		public static const BLUE:int = 3;
		
		public static const LOADED:String = "pixma_font_loaded";
		private static const DEFAULT_CHARS_SPACING:int = -5;
		
		private var data:PixmaFont;
		private var url:String;
		private var loaded:Boolean;
		private var displayChars:Sprite;
		private var chars:Array;
		private var chars_spacing:int;
		private var textHeight:Number;
		private var textWidth:Number;
		private var _text:String = "";
		
		public function PixmaText(strFont:String = '', x:int = 0, y:int = 0)
		{
			url = "";
			loaded = false;
			chars = [];
			displayChars = new Sprite();
			addChild(displayChars);
			textWidth = 0;
			textHeight = 0;
			this.loadFont(strFont);
			this.x = x;
			this.y = y;
		}
		
		public function loadFont(url:String):void
		{
			if (!url || !url.length)
				return;
			
			if (Manager.resource.getResourceByURL(url) is PixmaFont)
			{
				data = Manager.resource.getResourceByURL(url);
				loaded = true;
				dispatchEvent(new Event(LOADED));
			}
			else
			{
				this.url = url;
				Manager.resource.load([url], onFontPixmaLoaded);
			}
		}
		
		public function setText(text:String):void
		{
			this._text = text;
			
			removeDisplayChars();
			
			if (!text || !data)
				return;
			
			var charCode:int = -1;
			var charIndex:int = -1;
			var bitmap:Bitmap;
			var fontModule:FontModule;
			var char_x:int = 0;
			
			textHeight = 0;
			textWidth = 0;
			for (var i:int = 0; i < text.length; i++)
			{
				charCode = text.charCodeAt(i);
				charIndex = getFontFrameIndex(charCode);
				
				fontModule = data.fontModules[charIndex];
				if (fontModule)
				{
					bitmap = Manager.pool.pop(Bitmap) as Bitmap;
					bitmap.transform.matrix.identity();
					bitmap.bitmapData = fontModule.bitmapData;
					if (fontModule.colorTransform)
					{
						var colorTransform:ColorTransform = Manager.pool.pop(ColorTransform) as ColorTransform;
						colorTransform.alphaMultiplier = fontModule.colorTransform.alphaMultiplier;
						colorTransform.alphaOffset = fontModule.colorTransform.alphaOffset;
						colorTransform.redMultiplier = fontModule.colorTransform.redMultiplier;
						colorTransform.redOffset = fontModule.colorTransform.redOffset;
						colorTransform.greenMultiplier = fontModule.colorTransform.greenMultiplier;
						colorTransform.greenOffset = fontModule.colorTransform.greenOffset;
						colorTransform.blueMultiplier = fontModule.colorTransform.blueMultiplier;
						colorTransform.blueOffset = fontModule.colorTransform.blueOffset;
						
						var transform:Transform = Manager.pool.pop(Transform) as Transform;
						
						if (!transform)
							transform = bitmap.transform;
						transform.colorTransform = colorTransform;
						
						var mx:Matrix = Manager.pool.pop(Matrix) as Matrix;
						mx.identity();
						Manager.pool.push(transform.matrix);
						transform.matrix = mx;
						
						bitmap.transform = transform;
						Manager.pool.push(colorTransform, ColorTransform);
						Manager.pool.push(transform, Transform);
						bitmap.smoothing = true;
					}
					bitmap.scaleX = bitmap.scaleY = 1.0;
					bitmap.x = char_x;
					bitmap.y = fontModule.deltaY;
					char_x += (bitmap.width + chars_spacing);
					displayChars.addChild(bitmap);
					chars.push(bitmap);
					textHeight = Math.max(textHeight, fontModule.deltaY + fontModule.bitmapData.height);
					textWidth += bitmap.width + chars_spacing;
				}
				
				textWidth = textWidth - chars_spacing;
			}
		}
		
		public function getWidth():Number
		{
			return textWidth;
		}
		
		public function getHeight():Number
		{
			return textHeight;
		}
		
		public function setChartersSpacing(value:int):void
		{
			chars_spacing = value;
		}
		
		public function isLoaded():Boolean {
			return loaded;
		}
		
		private function removeDisplayChars():void
		{
			for each (var bitmap:Bitmap in chars)
			{
				displayChars.removeChild(bitmap);
				bitmap.rotation = 0;
				Manager.pool.push(bitmap, Bitmap);
			}
			chars.splice(0);
		}
		
		private function onFontPixmaLoaded():void
		{
			data = Manager.resource.getResourceByURL(url);
			loaded = true;
			dispatchEvent(new Event(LOADED));
			
			this.setText(_text);
		}
		
		private function getFontFrameIndex(charCode:int):int
		{
			switch (charCode)
			{
				case 32: 
					return 0; // Space
				case 33: 
					return 1; // !
				case 34: 
					return 2; // "
				case 35: 
					return 3; // #
				case 36: 
					return 4; // $
				case 37: 
					return 5; // %
				case 38: 
					return 6; // &
				case 39: 
					return 7; // '
				case 40: 
					return 8; // (
				case 41: 
					return 9; // )
				case 42: 
					return 10; // *
				case 43: 
					return 11; // +
				case 44: 
					return 12; // ,
				case 45: 
					return 13; // -
				case 46: 
					return 14; // .
				case 47: 
					return 15; // /
				case 48: 
					return 16; // 0
				case 49: 
					return 17; // 1
				case 50: 
					return 18; // 2
				case 51: 
					return 19; // 3
				case 52: 
					return 20; // 4
				case 53: 
					return 21; // 5
				case 54: 
					return 22; // 6
				case 55: 
					return 23; // 7
				case 56: 
					return 24; // 8
				case 57: 
					return 25; // 9
				case 58: 
					return 26; // :
				case 59: 
					return 27; // ;
				case 60: 
					return 28; // <
				case 61: 
					return 29; // =
				case 62: 
					return 30; // >
				case 63: 
					return 31; // ?
				case 64: 
					return 32; // @
				case 65: 
					return 33; // A
				case 66: 
					return 34; // B
				case 67: 
					return 35; // C
				case 68: 
					return 36; // D
				case 69: 
					return 37; // E
				case 70: 
					return 38; // F
				case 71: 
					return 39; // G
				case 72: 
					return 40; // H
				case 73: 
					return 41; // I
				case 74: 
					return 42; // J
				case 75: 
					return 43; // K
				case 76: 
					return 44; // L
				case 77: 
					return 45; // M
				case 78: 
					return 46; // N
				case 79: 
					return 47; // O
				case 80: 
					return 48; // P
				case 81: 
					return 49; // Q
				case 82: 
					return 50; // R
				case 83: 
					return 51; // S
				case 84: 
					return 52; // T
				case 85: 
					return 53; // U
				case 86: 
					return 54; // V
				case 87: 
					return 55; // W
				case 88: 
					return 56; // X
				case 89: 
					return 57; // Y
				case 90: 
					return 58; // Z
				case 91: 
					return 59; // [
				case 92: 
					return 60; // \
				case 93: 
					return 61; // ]
				case 94: 
					return 62; // ^
				case 95: 
					return 63; // _
				case 96: 
					return 64; // `
				case 97: 
					return 65; // a
				case 98: 
					return 66; // b
				case 99: 
					return 67; // c
				case 100: 
					return 68; // d
				case 101: 
					return 69; // e
				case 102: 
					return 70; // f
				case 103: 
					return 71; // g
				case 104: 
					return 72; // h
				case 105: 
					return 73; // i
				case 106: 
					return 74; // j
				case 107: 
					return 75; // k
				case 108: 
					return 76; // l
				case 109: 
					return 77; // m
				case 110: 
					return 78; // n
				case 111: 
					return 79; // o
				case 112: 
					return 80; // p
				case 113: 
					return 81; // q
				case 114: 
					return 82; // r
				case 115: 
					return 83; // s
				case 116: 
					return 84; // t
				case 117: 
					return 85; // u
				case 118: 
					return 86; // v
				case 119: 
					return 87; // w
				case 120: 
					return 88; // x
				case 121: 
					return 89; // y
				case 122: 
					return 90; // z
				case 123: 
					return 91; // {
				case 124: 
					return 92; // |
				case 125: 
					return 93; // }
				case 126: 
					return 94; // ~
				case 169: 
					return 95; // ©
				case 174: 
					return 96; // ®
				case 192: 
					return 97; // À
				case 193: 
					return 98; // Á
				case 194: 
					return 99; // Â
				case 195: 
					return 100; // Ã
				case 200: 
					return 101; // È
				case 201: 
					return 102; // É
				case 202: 
					return 103; // Ê
				case 204: 
					return 104; // Ì
				case 205: 
					return 105; // Í
				case 210: 
					return 106; // Ò
				case 211: 
					return 107; // Ó
				case 212: 
					return 108; // Ô
				case 213: 
					return 109; // Õ
				case 217: 
					return 110; // Ù
				case 218: 
					return 111; // Ú
				case 221: 
					return 112; // Ý
				case 224: 
					return 113; // à
				case 225: 
					return 114; // á
				case 226: 
					return 115; // â
				case 227: 
					return 116; // ã
				case 232: 
					return 117; // è
				case 233: 
					return 118; // é
				case 234: 
					return 119; // ê
				case 236: 
					return 120; // ì
				case 237: 
					return 121; // í
				case 242: 
					return 122; // ò
				case 243: 
					return 123; // ó
				case 244: 
					return 124; // ô
				case 245: 
					return 125; // õ
				case 249: 
					return 126; // ù
				case 250: 
					return 127; // ú
				case 253: 
					return 128; // ý
				case 258: 
					return 129; // Ă
				case 259: 
					return 130; // ă
				case 272: 
					return 131; // Đ
				case 273: 
					return 132; // đ
				case 296: 
					return 133; // Ĩ
				case 297: 
					return 134; // ĩ
				case 360: 
					return 135; // Ũ
				case 361: 
					return 136; // ũ
				case 416: 
					return 137; // Ơ
				case 417: 
					return 138; // ơ
				case 431: 
					return 139; // Ư
				case 432: 
					return 140; // ư
				case 7840: 
					return 141; // Ạ
				case 7841: 
					return 142; // ạ
				case 7842: 
					return 143; // Ả
				case 7843: 
					return 144; // ả
				case 7844: 
					return 145; // Ấ
				case 7845: 
					return 146; // ấ
				case 7846: 
					return 147; // Ầ
				case 7847: 
					return 148; // ầ
				case 7848: 
					return 149; // Ẩ
				case 7849: 
					return 150; // ẩ
				case 7850: 
					return 151; // Ẫ
				case 7851: 
					return 152; // ẫ
				case 7852: 
					return 153; // Ậ
				case 7853: 
					return 154; // ậ
				case 7854: 
					return 155; // Ắ
				case 7855: 
					return 156; // ắ
				case 7856: 
					return 157; // Ằ
				case 7857: 
					return 158; // ằ
				case 7858: 
					return 159; // Ẳ
				case 7859: 
					return 160; // ẳ
				case 7860: 
					return 161; // Ẵ
				case 7861: 
					return 162; // ẵ
				case 7862: 
					return 163; // Ặ
				case 7863: 
					return 164; // ặ
				case 7864: 
					return 165; // Ẹ
				case 7865: 
					return 166; // ẹ
				case 7866: 
					return 167; // Ẻ
				case 7867: 
					return 168; // ẻ
				case 7868: 
					return 169; // Ẽ
				case 7869: 
					return 170; // ẽ
				case 7870: 
					return 171; // Ế
				case 7871: 
					return 172; // ế
				case 7872: 
					return 173; // Ế
				case 7873: 
					return 174; // ề
				case 7874: 
					return 175; // Ể
				case 7875: 
					return 176; // ể
				case 7876: 
					return 177; // Ễ
				case 7877: 
					return 178; // ễ
				case 7878: 
					return 179; // Ệ
				case 7879: 
					return 180; // ệ
				case 7880: 
					return 181; // Ỉ
				case 7881: 
					return 182; // ỉ
				case 7882: 
					return 183; // Ị
				case 7883: 
					return 184; // ị
				case 7884: 
					return 185; // Ọ
				case 7885: 
					return 186; // ọ
				case 7886: 
					return 187; // Ỏ
				case 7887: 
					return 188; // ỏ
				case 7888: 
					return 189; // Ố
				case 7889: 
					return 190; // ố
				case 7890: 
					return 191; // Ồ
				case 7891: 
					return 192; // ồ
				case 7892: 
					return 193; // Ổ
				case 7893: 
					return 194; // ổ
				case 7894: 
					return 195; // Ỗ
				case 7895: 
					return 196; // ỗ
				case 7896: 
					return 197; // Ộ
				case 7897: 
					return 198; // ộ
				case 7898: 
					return 199; // Ớ
				case 7899: 
					return 200; // ớ
				case 7900: 
					return 201; // Ờ
				case 7901: 
					return 202; // ờ
				case 7902: 
					return 203; // Ở
				case 7903: 
					return 204; // ở
				case 7904: 
					return 205; // Ỡ
				case 7905: 
					return 206; // ỡ
				case 7906: 
					return 207; // Ợ
				case 7907: 
					return 208; // ợ
				case 7908: 
					return 209; // Ụ
				case 7909: 
					return 210; // ụ
				case 7910: 
					return 211; // Ủ
				case 7911: 
					return 212; // ủ
				case 7912: 
					return 213; // Ứ
				case 7913: 
					return 214; // ứ
				case 7914: 
					return 215; // Ừ
				case 7915: 
					return 216; // ừ
				case 7916: 
					return 217; // Ử
				case 7917: 
					return 218; // ử
				case 7918: 
					return 219; // Ữ
				case 7919: 
					return 220; // ữ
				case 7920: 
					return 221; // Ự
				case 7921: 
					return 222; // ự
				case 7922: 
					return 223; // Ỳ
				case 7923: 
					return 224; // ỳ
				case 7924: 
					return 225; // Ỵ
				case 7925: 
					return 226; // ỵ
				case 7926: 
					return 227; // Ỷ
				case 7927: 
					return 228; // ỷ
				case 7928: 
					return 229; // Ỹ
				case 7929: 
					return 230; // ỹ
				default: 
					return 31; // ?
			}
		}
	}

}