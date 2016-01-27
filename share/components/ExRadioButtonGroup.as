package components 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author 
	 */
	public class ExRadioButtonGroup extends MovieClip
	{
		public static const RADIO_BUTTON_CHANGE:String = "RADIO_BUTTON_CHANGE";
		protected var itemList:Array;
		public var baseItem:MovieClip;
		public var activeItem:ExButtonCheckBox;
		private var posY:Number;
		
		public function ExRadioButtonGroup() 
		{
			itemList = new Array();
			posY = 0;
			//baseItem.visible = false;
		}
		
		public function initList(arr:Array):void
		{
			removeAllItems();
			posY = 0;
			
			for ( var i:int = 0; i < arr.length; i++ )
			{
				var info:Object = arr[i];
				addItem(info);
			}
		}
		
		private function itemClickHdl(e:MouseEvent):void 
		{
			var item:ExButtonCheckBox = ExButtonCheckBox(e.currentTarget);
			if (item != activeItem)
			{
				if (activeItem) activeItem.setSelected(false);
				item.setSelected(true);
				activeItem = item;
				dispatchEvent(new Event(RADIO_BUTTON_CHANGE, true));
			}
		}
		
		public function addItem(info:Object, pItem:ExButtonCheckBox = null):void
		{
			var item:ExButtonCheckBox;
			if (!pItem)
			{
				var className:Class = getDefinitionByName("ButtonCheckBox") as Class;
				item = new className();
				item.y = posY;
				item.labelTf.text = info.label;
				posY += item.height + 5;
				addChild(item);
			}
			else item = pItem;
			item.unlock();
			item.info = info;
			itemList.push(item);
			item.addEventListener(MouseEvent.CLICK, itemClickHdl);
		}
		
		public function setActiveItem(ind:int):void
		{
			if (ind == -1)
			{
				if (activeItem) activeItem.setSelected(false);
				activeItem = null;
				return;
			}
			if (itemList[ind] == activeItem) return;
			if (activeItem) activeItem.setSelected(false);
			itemList[ind].setSelected(true);
			activeItem = itemList[ind];
		}

		public function removeAllItems():void
		{
			var item:ExButtonCheckBox;
			for ( var i:int = 0; i < itemList.length; i++ ) 
			{
				item = itemList[i] as ExButtonCheckBox;
				item.setSelected(false);
				if (item.parent == this) removeChild(itemList[i]);
			}
			itemList = new Array();
		}	
		
		public function reset():void
		{
			removeAllItems();
			activeItem = null;
		}
		
		public function getLength():uint
		{
			return itemList.length;
		}
	}

}