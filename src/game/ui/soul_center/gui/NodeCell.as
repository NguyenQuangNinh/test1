package game.ui.soul_center.gui 
{
	import core.display.BitmapEx;
	import core.display.animation.Animator;
	import core.event.EventEx;
	import core.util.Utility;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.data.model.item.SoulItem;
	import game.enum.DragDropEvent;
	import game.enum.ItemType;
	//import game.ui.components.ItemSlot;
	import game.ui.components.ToggleMov;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;

	/**
	 * ...
	 * @author anhtinh
	 */
	public class NodeCell extends ToggleMov
	{
		public static const NODE_CELL_DRAG : String = "nodeSlotDrap";
		public static const NODE_CELL_CLICK	:String = "nodeSlotClick";
		public static const NODE_CELL_DCLICK:String = "nodeSlotDClick";
		
		public var soulItem : SoulItem;
		private var _slot:Animator;
		
		private var _isAttachSoul : Boolean;
		private var _isMouseDown:Boolean = false;
		private var _clickStarted:int = -1;
		private var _mouseTimeOut:int;
		
		private var _nodeIndex:int;
		
		public function NodeCell() 
		{
			isAttachSoul = false;
			this.buttonMode = true;
		}
		
		public function setData(soulItem : SoulItem) : void {
			
			var isEmptyItem : Boolean = (soulItem.soulXML.ID == 0 && soulItem.soulXML.type == ItemType.EMPTY_SLOT);
			isAttachSoul = ! isEmptyItem;
			
			this.soulItem = soulItem;
			
			if (_slot == null) {
				_slot = new Animator();
				_slot.x = 16;
				_slot.y = 16;
				this.addChild(_slot);
			}
			
			_slot.setCacheEnabled(false);
			if(! _slot.hasEventListener(Animator.LOADED)) _slot.addEventListener(Animator.LOADED, onAnimLoaded);
			_slot.load(soulItem.soulXML.animURL);
			
			if (isAttachSoul) {
				this.addEventListener(MouseEvent.ROLL_OVER, onRollOverHdl);
				this.addEventListener(MouseEvent.ROLL_OUT, onRollOutHdl);
			}else {
				if (hasEventListener(MouseEvent.ROLL_OVER))
					removeEventListener(MouseEvent.ROLL_OVER, onRollOverHdl);
				if (hasEventListener(MouseEvent.ROLL_OUT)) 
					removeEventListener(MouseEvent.ROLL_OUT, onRollOutHdl);
			}
		}
		
		private function onAnimLoaded(e:Event):void 
		{
			var index : int = Math.min(_slot.getAnimationCount() - 1, soulItem.level - 1)
			_slot.play(index);
		}
		
		private function onRollOutHdl(e:MouseEvent):void {
			dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));	
		}
		
		private function onRollOverHdl(e:MouseEvent):void {
			dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type:TooltipID.SOUL, value: this.soulItem}, true));
		}
		
		
		public function get isAttachSoul():Boolean 
		{
			return _isAttachSoul;
		}
		
		public function set isAttachSoul(value:Boolean):void 
		{
			_isAttachSoul = value;
			
			if (_isAttachSoul) {
				
				if (_slot != null) _slot.visible = true;
				addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHdl);
				addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHdl);
				addEventListener(MouseEvent.CLICK, onMouseClickHdl);
			}else {
				
				if (_slot != null) _slot.visible = false;
				if (hasEventListener(MouseEvent.MOUSE_DOWN)) 
					removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHdl);
				if (hasEventListener(MouseEvent.CLICK)) 
					removeEventListener(MouseEvent.CLICK, onMouseClickHdl);
			}
		}
		
		private function onMouseClickHdl(e:MouseEvent):void 
		{
			var delay:int = getTimer() - _clickStarted;
			//Utility.log("click event:" + delay);
			//if (_clickStarted && (getTimer() - _clickStarted < DragDropEvent.MAX_TIME_FOR_CLICK)) {
			if (_clickStarted && (delay < DragDropEvent.MAX_TIME_FOR_CLICK)) {
				//this is a double click
				clearTimeout(_mouseTimeOut);
				Utility.log("node slot double click event fired");
				_clickStarted = -1;				
				dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
				dispatchEvent(new EventEx(NODE_CELL_DCLICK, { index: _nodeIndex, info: soulItem }, true));				
			}else {
				_clickStarted = getTimer();
				_mouseTimeOut = setTimeout(clickHdl, DragDropEvent.MAX_TIME_FOR_CLICK);	
			}
		}
		
		private function clickHdl():void 
		{
			Utility.log("node slot click event fired");
			_clickStarted = -1;
			dispatchEvent(new EventEx(NODE_CELL_CLICK, { index: _nodeIndex, info: soulItem }, true));			
		}
		
		private function onMouseDownHdl(e:MouseEvent):void 
		{						
			if (soulItem != null) {
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
			if (_isMouseDown) {
				//reset flag
				_isMouseDown = false;
				
				//this is a drag
				//var objDrag:BitmapEx = new BitmapEx();
				var objDrag:Animator = new Animator();
				//var objDrag:Animator = itemSlot;
				objDrag.setCacheEnabled(false);
				objDrag.load(soulItem.soulXML.animURL);
				var index : int = Math.min(_slot.getAnimationCount() - 1, soulItem.level - 1)
				objDrag.play(index);
				objDrag.name = "mov_drag";
				dispatchEvent(new EventEx(NODE_CELL_DRAG, {target: objDrag, data: soulItem, x:e.stageX, y:e.stageY, coordinate : "center",
							from: DragDropEvent.FROM_NODE_OF_CHARACTER }, true));
			}
		}
		
		public function get nodeIndex():int {
			return _nodeIndex;
		}
		
		public function set nodeIndex(index:int):void {
			_nodeIndex = index;
		}
	}

}