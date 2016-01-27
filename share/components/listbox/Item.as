package components.listbox {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class Item extends MovieClip {
		
		public var bg:MovieClip;
		public var labelTf:TextField;
		public var index:int;
		public var info:Object;
		
		public function Item() {
			labelTf.mouseEnabled = false;
		}
		
		public function setLabel(label:String):void {
			this.labelTf.text = label;
		}
		
		public function setWidth(width:Number):void {
			this.labelTf.width = width;
			this.bg.width = width;
		}
		
		public function setInfo(pInfo:Object):void {
			info = pInfo;
			setLabel(info.label);
		}
	}
}