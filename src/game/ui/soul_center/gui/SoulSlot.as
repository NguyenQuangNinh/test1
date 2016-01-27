package game.ui.soul_center.gui
{
	import core.display.animation.Animator;
	import core.display.BitmapEx;
	import core.display.layer.Layer;
	import core.event.EventEx;
	import core.Manager;
	import core.util.MovieClipUtils;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import game.data.model.item.SoulItem;
	import game.enum.DialogEventType;
	import game.enum.DragDropEvent;
	import game.enum.GameConfigID;
	import game.enum.ItemType;
	import game.Game;
	//import game.ui.components.ItemSlot;
	import game.ui.dialog.DialogID;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;
	
	/**
	 * ...
	 * @author anhtinh
	 */
	public class SoulSlot extends MovieClip
	{
		//string event
		public static const SOUL_SLOT_DRAG : String = "soulSlotDrap";
		public static const SOUL_SLOT_CLICK : String = "soulSlotClick";
		public static const SOUL_SLOT_DCLICK : String = "soulSlotDClick";		
		public static const UNLOCK_SLOT : String = "unlockSlot";
		
		//string status label
		public static const LOCK : String = "lock";
		public static const UNLOCK : String = "unlock";
		public static const LOCK_MERGE:String = "lock_merge";		
		public static const UNLOCK_GUILD : String = "unlock_guild";
		
		public var soulItem:SoulItem;
		private var _itemSlot:Animator;
		
		private var _status:String;
		
		private var _isMouseDown:Boolean = false;
		private var _clickStarted:int = -1;
		private var _mouseTimeOut:int;
		
		//private var _glowFilter:GlowFilter;
		
		public function SoulSlot() 
		{
			status = LOCK;
			//this.addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(MouseEvent.CLICK, onMouseClickHdl);
			this.buttonMode = true;
			
			/*_glowFilter = new GlowFilter();
			_glowFilter.color = 0xFFFF00;
			_glowFilter.strength = 5;
			_glowFilter.inner = true;
			_glowFilter.blurX = _glowFilter.blurY = 5;*/
		}
		
		public function get status():String
		{
			return _status;
		}
		
		public function set status(value:String):void
		{
			switch (value)
			{
				case LOCK:					
				case UNLOCK:					
				case UNLOCK_GUILD:					
				case LOCK_MERGE:					
					this.gotoAndStop(value);
					if (soulItem) 
						addChildAt(_itemSlot, 1);
					break;
				default:
					break;
			}
			
			_status = value;
		}
		
		public function get isEmpty() : Boolean {
			return soulItem != null && (soulItem.soulXML.ID == 0 && soulItem.soulXML.type == ItemType.EMPTY_SLOT);
		}
		
		public function setData(soulItem:SoulItem = null):void
		{
			this.soulItem = soulItem;
			_itemSlot = new Animator();
			_itemSlot.x = 31 - 2;
			_itemSlot.y = 28;
			_itemSlot.setCacheEnabled(false);
			if (!_itemSlot.hasEventListener(Animator.LOADED))
				_itemSlot.addEventListener(Animator.LOADED, onAnimLoaded);
			_itemSlot.load(soulItem.soulXML.animURL);
			this.addChildAt(_itemSlot, 1);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHdl);
			
			if (!isEmpty)
			{
				this.addEventListener(MouseEvent.ROLL_OVER, onRollOverHdl);
				this.addEventListener(MouseEvent.ROLL_OUT, onRollOutHdl);
			}				
		}
		
		private function onAnimLoaded(e:Event):void 
		{
			var index:int = Math.min(_itemSlot.getAnimationCount() - 1, soulItem.level - 1)
			_itemSlot.play(index);
		}
		
		private function onRollOutHdl(e:MouseEvent):void
		{
			dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
		}
		
		private function onRollOverHdl(e:MouseEvent):void
		{
			dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type: TooltipID.SOUL, value: this.soulItem}, true));
		}
		
		private function onMouseDownHdl(e:MouseEvent):void
		{
			if (soulItem != null)
			{
				addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHdl);
				addEventListener(MouseEvent.MOUSE_UP, onMouseUpHdl);
				_isMouseDown = true;
			}
		}
		
		private function onMouseUpHdl(e:MouseEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHdl);
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOutHdl);
			_isMouseDown = false;
		}
		
		private function onMouseOutHdl(e:MouseEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHdl);
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOutHdl);
			if (_isMouseDown)
			{
				//reset flag
				_isMouseDown = false;
				
				//this is a drag
				//var objDrag:BitmapEx = new BitmapEx();
				var objDrag:Animator = new Animator();
				//var objDrag:Animator = itemSlot;
				objDrag.setCacheEnabled(false);
				objDrag.load(soulItem.soulXML.animURL);
				var index:int = Math.min(_itemSlot.getAnimationCount() - 1, soulItem.level - 1)
				objDrag.play(index);
				objDrag.name = "mov_drag";
				dispatchEvent(new EventEx(SOUL_SLOT_DRAG, {target: objDrag, data: soulItem, x: e.stageX, y: e.stageY, coordinate: "center", from: DragDropEvent.FROM_SOUL_INVENTORY}, true));
			}
		}
		
		private function onMouseClickHdl(e:MouseEvent):void 
		{
			if (_clickStarted && (getTimer() - _clickStarted < DragDropEvent.MAX_TIME_FOR_CLICK)) {
				//this is a double click
				clearTimeout(_mouseTimeOut);
				Utility.log("soul slot double click event fired");
				_clickStarted = -1;				
				dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
				dispatchEvent(new EventEx(SOUL_SLOT_DCLICK, soulItem , true));				
			}else {
				_clickStarted = getTimer();
				_mouseTimeOut = setTimeout(clickHdl, DragDropEvent.MAX_TIME_FOR_CLICK);	
			}
		}
		
		private function clickHdl():void 
		{
			Utility.log("soul slot click event fired");
			_clickStarted = -1;
			if (status == LOCK || status == UNLOCK_GUILD) {
				//confirmUnlockSlot();
				dispatchEvent(new EventEx(UNLOCK_SLOT, null, true));	
			}else {
				//dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
				dispatchEvent(new EventEx(SOUL_SLOT_CLICK, soulItem , true));				
			}
			//Utility.log("@@@ onClick");
			//dispatchEvent(new EventEx(FORMATION_SLOT_CLICK, _data, true));
		}
		
		/*public function setSelected(selected:Boolean):void {			
			this.filters = selected ? [_glowFilter] : [];			
		}*/
		
		public function setSlotMerge():void {
			if (soulItem.usedInMerge) {
				MovieClipUtils.applyGrayScale(_itemSlot);				
			}else {
				MovieClipUtils.removeAllFilters(_itemSlot);
			}
		}
	}

}