package game.ui.soul_center.gui 
{
	import core.display.animation.Animator;
	import core.event.EventEx;
	import core.util.Utility;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import game.data.model.item.SoulItem;
	import game.enum.DragDropEvent;
	import game.enum.ItemType;
	import game.ui.components.ToggleMov;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class SoulNode extends ToggleMov	
	{
		public static const SOUL_NODE_DRAG : String = "soulNodeDrap";
		public static const SOUL_NODE_CLICK	:String = "soulNodeClick";
		public static const SOUL_NODE_DCLICK:String = "soulNodeDClick";
		
		public var soulItem : SoulItem;
		private var _slot:Animator;
		
		private var _isMergeSoul: Boolean;
		private var _isMouseDown:Boolean = false;
		private var _clickStarted:int = -1;
		private var _mouseTimeOut:int;
		
		private var _isRecipe:Boolean = true;
		private var _nodeIndex:int;		
		
		public function SoulNode() 
		{
			isMergeSoul = false;
			this.buttonMode = true;
		}
		
		override public function set isActive(value:Boolean):void {
			_isActive = value;
			if (_isActive) this.gotoAndStop("active");
			else {
				this.gotoAndStop(_isRecipe ? "recipe_ready" : "item_ready");
			}
		}
		
		public function setData(soulItem : SoulItem) : void {
			
			var isEmptyItem : Boolean = soulItem == null || (soulItem.soulXML.ID == 0 && soulItem.soulXML.type == ItemType.EMPTY_SLOT);
			isMergeSoul = !isEmptyItem;
			
			this.soulItem = soulItem;			
			this.isActive = !isEmptyItem;
			
			if (_slot == null) {
				_slot = new Animator();
				_slot.x = 20;
				_slot.y = 20;
				_slot.setCacheEnabled(false);
				this.addChild(_slot);
			}
			
			if (! _slot.hasEventListener(Animator.LOADED))
				_slot.addEventListener(Animator.LOADED, onAnimLoaded);
				
			if(!isEmptyItem)	
				_slot.load(soulItem.soulXML.animURL);
			else {
				_slot.setData(null);
			}
			
			if (isMergeSoul) {
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
		
		public function get isMergeSoul():Boolean 
		{
			return _isMergeSoul;
		}
		
		public function set isMergeSoul(value:Boolean):void 
		{
			_isMergeSoul = value;
			
			if (_isMergeSoul) {
				
				if (_slot != null) _slot.visible = true;
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
				Utility.log("soul node double click event fired");
				_clickStarted = -1;				
				dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
				dispatchEvent(new EventEx(SOUL_NODE_DCLICK, { index: _nodeIndex, info: soulItem }, true));				
			}else {
				_clickStarted = getTimer();
				_mouseTimeOut = setTimeout(clickHdl, DragDropEvent.MAX_TIME_FOR_CLICK);	
			}
		}
		
		private function clickHdl():void 
		{
			Utility.log("soul node click event fired");
			_clickStarted = -1;
			dispatchEvent(new EventEx(SOUL_NODE_CLICK, { index: _nodeIndex, info: soulItem }, true));			
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
				/*var objDrag:Animator = new Animator();
				objDrag.setCacheEnabled(false);
				objDrag.load(soulItem.soulXML.animURL);
				var index : int = Math.min(_slot.getAnimationCount() - 1, soulItem.level - 1)
				objDrag.play(index);
				objDrag.name = "mov_drag";
				dispatchEvent(new EventEx(SOUL_NODE_DRAG, { target: objDrag, data: soulItem, nodeIndex: _nodeIndex, x:e.stageX, y:e.stageY,
						coordinate : "center" }, true));*/
			}
		}
		
		public function set isRecipe(value:Boolean):void {
			_isRecipe = value;
		}
		
		public function get isRecipe():Boolean {
			return _isRecipe;
		}
		
		public function set nodeIndex(index:int):void {
			_nodeIndex = index;
		}
		
		public function get nodeIndex():int {
			return _nodeIndex;
		}
		
	}

}