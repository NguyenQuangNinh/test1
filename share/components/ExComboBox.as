package components 
{
	import components.listbox.ExList;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import gs.TweenMax;
	/**
	 * ...
	 * @author 
	 */
	public class ExComboBox extends MovieClip
	{
		public var baseItemBg:MovieClip;
		public var masker:MovieClip;
		
		public var titleTf:TextField;
		public var list:ExList;
		
		public function ExComboBox() 
		{	
			list.addEventListener(Event.CHANGE, listChangeHdl);
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			list.y = - list.getHeight();
			titleTf.mouseEnabled = false;
			baseItemBg.addEventListener(MouseEvent.MOUSE_DOWN, baseItemBgHdl);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, stageMouseDownHdl);
		}
		
		private function listChangeHdl(e:Event):void 
		{
			titleTf.text = list.selectedItem.label;
			hideList();
		}
		
		private function stageMouseDownHdl(e:MouseEvent):void 
		{
			if (this.mouseX < 0 || this.mouseY < 0 || this.mouseX > baseItemBg.width || this.mouseY > baseItemBg.height + list.getHeight())
			{
				hideList();
			}
		}
		
		private function baseItemBgHdl(e:MouseEvent):void 
		{
			TweenMax.to( list, 0.5, { y: masker.y } );
		}
		
		public function initData(arr:Array):void
		{
			for ( var i:int = 0; i < arr.length; i++ )
			{
				list.addItem(arr[i]);
			}
			list.selectedIndex = 0;
		}
		
		public function hideList():void
		{
			TweenMax.to( list, 0.5, { y: - list.getHeight() } );
		}
	}

}