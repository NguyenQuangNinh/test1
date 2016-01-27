package components 
{
	import com.adobe.utils.ArrayUtil;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author 
	 */
	public class BaseList extends Sprite
	{
		public var list:Array;
		
		public function BaseList() 
		{
			list = new Array();
		}
		
		public function removeAllItems():void
		{
			for ( var i:int = 0; i < list.length; i++ ) removeChild(list[i]);
			list = new Array();
		}	
		
		public function getLength():uint
		{
			return list.length;
		}
		
		public function addItem(item:Object):void
		{
			list.push(item);
		}
		
		public function removeItem(item:Object):void
		{
			ArrayUtil.removeValueFromArray(list, item);
		}
	}

}