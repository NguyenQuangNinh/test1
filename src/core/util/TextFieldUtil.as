package core.util
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 * ...
	 * @author anhtinh
	 */
	public class TextFieldUtil
	{
		/**
		 * example :
		 * var glow : GlowFilter = new GlowFilter();
		 *    glow.color = 0x000000;
		 *    glow.strength = 4;
		 *    glow.blurX = glow.blurY = 5;
		 * TextFieldUtil.createTextfield(Font.ARIAL, 15, 60, 20, 0xFFFFFF, true, TextFormatAlign.CENTER, [glow])
		 *
		 */
		public static function createTextfield(fontName:String, size:int = 12, width:Number = 100, height:Number = 50, color:uint = 0xCCCCCC, bold:Boolean = false, align:String = TextFormatAlign.LEFT, filters:Array = null, linespacing:int = 0):TextField
		{

			if (height < size)
			{
				height = size
			}

			var tf:TextField = new TextField();

			var textFormat:TextFormat = tf.getTextFormat();
			textFormat.size = size;
			textFormat.color = color;
			textFormat.align = align;
			textFormat.leading = linespacing;
			tf.defaultTextFormat = textFormat;
			tf.setTextFormat(textFormat);

			FontUtil.setFont(tf, fontName, bold);

			tf.width = width;
			tf.height = height;
			tf.mouseEnabled = false;


			tf.filters = filters;

			return tf;
		}

		public static function setColor(tf:TextField, beginIndex:int, endIndex:int, color:uint):void
		{

			beginIndex = Utility.math.clamp(beginIndex, 0, tf.length - 1);
			endIndex = Utility.math.clamp(endIndex, 1, tf.length);

			var textformat:TextFormat = tf.getTextFormat();
			textformat.color = color;
			tf.setTextFormat(textformat, beginIndex, endIndex);
		}

	}

}