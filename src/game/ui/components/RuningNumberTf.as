package game.ui.components 
{
	import core.util.Utility;
	import flash.text.TextField;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class RuningNumberTf 
	{
		public var tf : TextField;
		private var extraText : String = "";
		private var _value : int;
		
		public function RuningNumberTf(tf : TextField) 
		{
			this.tf = tf;
			this.extraText = extraText;
		}
		
		public function set value(num : int) : void {
			this._value = num;
			
			this.tf.text = Utility.math.formatInteger(num) + extraText;
		}
		
		public function get value() : int {
			return this._value;
		}
		
		public function setExtraText(extraText : String) : void {
			this.extraText = extraText;
		}
	}

}