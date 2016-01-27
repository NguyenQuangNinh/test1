package core.util 
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author ...
	 */
	public class FontUtil 
	{
		public static function setFont(tf:TextField, fontName:String, bold:Boolean = false):void {
			if(tf)
			{
				tf.embedFonts = true;

				var format:TextFormat = tf.getTextFormat();
				format.font = fontName;
				format.bold = bold;

				tf.defaultTextFormat = format;
				tf.setTextFormat(format);
			}
		}
	}

}