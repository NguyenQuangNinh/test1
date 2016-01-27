package game.ui.components 
{
	import com.greensock.TweenMax;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import core.display.BitmapEx;
	import core.display.animation.Animator;
	import core.event.EventEx;
	import core.util.FontUtil;
	
	import game.Game;
	import game.data.model.Character;
	import game.data.xml.DataType;
	import game.data.xml.ElementData;
	import game.enum.DragDropEvent;
	import game.enum.Font;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;
	import game.utility.UtilityUI;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class CharacterSlot extends MovieClip 
	{
		static public const CHARACTER_SLOT_CLICK	:String = "character_slot_click";
		static public const CHARACTER_SLOT_DCLICK	:String = "character_slot_double_click";	
		static public const CHARACTER_SLOT_DRAG		:String = "character_slot_drag";
		static public const EVOLUTION				:String = "evolution";
		static public const SHOW_INFO				:String = "showInfo";
		static public const LOCK				:String = "lock";
		static public const UNLOCK				:String = "unlock";
		static public const REMOVE					:String = "remove";
		
		static public const LOCKED:int = 0;
		static public const EMPTY:int = 1;
		static public const OCCUPIED:int = 2;
		
		public var movAvatar		:MovieClip;
		public var txtName			:TextField;
		public var usedMov			:MovieClip;
		public var movElementContainer	:MovieClip;
		public var movEffectSelect		:MovieClip;
		public var btnEvolution			:MovieClip;
		public var btnInfo				:MovieClip;
		public var btnRemove			:MovieClip;
		public var btnLock			 :MovieClip;
		public var movExpired			:MovieClip;
		
		private var avatarBitmap	:BitmapEx;
		private var elementBitmap	:BitmapEx;
		private var levelIcon		:LevelIcon;
		private var _data			:Character;
		//private var _enableDragDrop	:Boolean;
		private var _glow			:GlowFilter;
		//private var _type		:String;
		private var animator:Animator;
		private var useAnimOrAvatar:Boolean;
		
		private var _isMouseDown:Boolean = false;
		private var _clickStarted:int = -1;
		private var _mouseTimeOut:int;
		private var _enabled:Boolean;
		private var expireTimer:Timer;
		private var _toolTipEnable:Boolean = true;
		private var status:int;
		private var _isLock:Boolean;
		
		public function CharacterSlot() {
			FontUtil.setFont(txtName, Font.ARIAL);					
			
			this.buttonMode = true;
			expireTimer = new Timer(0, 1);
			expireTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onExpired);
			setStatus(OCCUPIED);
			initUI();
			initHandlers();
		}
		
		public function setUseAnimOrAvatar(value:Boolean):void
		{
			useAnimOrAvatar = value;
			avatarBitmap.visible = !useAnimOrAvatar;
			animator.visible = useAnimOrAvatar;
		}
		
		protected function onExpired(event:TimerEvent):void
		{
			movExpired.visible = true;
			setEnabled(false);
		}
		
		public function reset():void
		{
			_isLock = false;
			btnLock.visible = false;
			clearTimeout(_mouseTimeOut);
		}
		
		public function isEmpty():Boolean { return _data == null; }
		public function isInQuestTransport():Boolean { return _data.isInQuestTransport; }

		public function getStatus():int { return status; }
		public function setStatus(status:int):void
		{
			this.status = status;
			switch(status)
			{
				case LOCKED:
					gotoAndStop("locked");
					levelIcon.visible = false;
					break;
				case EMPTY:
					gotoAndStop("empty");
					levelIcon.visible = false;
					break;
				case OCCUPIED:
					gotoAndStop("occupied");
					break;
			}
		}
		
		public function isEnabled():Boolean { return _enabled; }
		public function setEnabled(value:Boolean):void
		{
			_enabled = value;
			if(_enabled)
			{
				TweenMax.to(this, 0, {alpha:1, colorMatrixFilter: { saturation: 1} } );
			}
			else
			{
				TweenMax.to(this, 0, {alpha:0.5, colorMatrixFilter: { saturation: 0} } );
			}
		}
		
		private function initHandlers():void {
			addEventListener(MouseEvent.ROLL_OVER, onRollOverHdl);
			addEventListener(MouseEvent.ROLL_OUT, onRollOutHdl);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHdl);
			addEventListener(MouseEvent.CLICK, onMouseClickHdl);
			
			btnEvolution.addEventListener(MouseEvent.CLICK, btn_onClicked);
			btnInfo.addEventListener(MouseEvent.CLICK, btn_onClicked);
			btnLock.addEventListener(MouseEvent.CLICK, btn_onClicked);
			btnRemove.addEventListener(MouseEvent.CLICK, btn_onClicked);
		}
		
		private function btn_onClicked(e:MouseEvent):void {
			switch(e.target)
			{
				case btnEvolution:
					dispatchEvent(new Event(EVOLUTION, true));
					break;
				case btnRemove:
					dispatchEvent(new Event(REMOVE, true));
					break;
				case btnInfo:
					dispatchEvent(new Event(SHOW_INFO, true));
					break;
				case btnLock:
					_isLock ? dispatchEvent(new Event(UNLOCK, true)): dispatchEvent(new Event(LOCK, true));;
					break;
			}
			e.stopPropagation();
		}
		
		private function onMouseDownHdl(e:MouseEvent):void 
		{
			if (_data) {
				addEventListener(MouseEvent.MOUSE_UP, onMouseUpHdl);
				addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHdl);
				_isMouseDown = true;
			}
		}
		
		private function onMouseOutHdl(e:MouseEvent):void 
		{
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOutHdl);
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHdl);
			if (_isMouseDown) {				
				//reset flag
				_isMouseDown = false;
				
				//this is a drag
				//just can drag when slot is valid
				if (getStatus() == OCCUPIED && isEnabled()) {					
					var objDrag:BitmapEx = new BitmapEx();
					objDrag.load(_data.xmlData.largeAvatarURLs[_data.sex]);
					objDrag.name = "mov_drag";
					dispatchEvent(new EventEx(CHARACTER_SLOT_DRAG, {target: objDrag, data: _data, x:e.stageX, y:e.stageY,
								from: DragDropEvent.FROM_INVENTORY_UNIT }, true));				
				}
			}
		}
		
		private function onMouseUpHdl(e:MouseEvent):void 
		{			
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOutHdl);
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHdl);
			_isMouseDown = false;			
		}
		
		private function onMouseClickHdl(e:MouseEvent):void {	
			if (_clickStarted && (getTimer() - _clickStarted < DragDropEvent.MAX_TIME_FOR_CLICK)) {
				//this is a double click
				clearTimeout(_mouseTimeOut);
				_clickStarted = -1;				
				dispatchEvent(new EventEx(CHARACTER_SLOT_DCLICK, _data, true));
			}else {
				_clickStarted = getTimer();
				_mouseTimeOut = setTimeout(function mouseClick():void {
					_clickStarted = -1;
					dispatchEvent(new EventEx(CHARACTER_SLOT_CLICK, _data, true));
				}, DragDropEvent.MAX_TIME_FOR_CLICK);	
			}
		}
		
		private function initUI():void {
			usedMov.gotoAndStop("normal");
			btnEvolution.visible = false;
			btnInfo.visible = false;
			btnRemove.visible= false;
			btnLock.visible= false;

			avatarBitmap = new BitmapEx();
			avatarBitmap.addEventListener(BitmapEx.LOADED, onAvatarLoadedHdl);
			movAvatar.addChild(avatarBitmap);
			
			animator = new Animator();
			animator.y = 40;
			movAvatar.addChild(animator);
			
			elementBitmap = new BitmapEx();
			elementBitmap.addEventListener(BitmapEx.LOADED, onElementLoadedHdl);
			movElementContainer.addChild(elementBitmap);
			
			levelIcon = new LevelIcon();
			levelIcon.x = 34;
			levelIcon.y = 103;
			addChild(levelIcon);
			
			_glow = new GlowFilter();
			movEffectSelect.mouseChildren = false;
			movEffectSelect.mouseEnabled = false;
			isSelected = false;
		}
		
		private function onElementLoadedHdl(e:Event):void {
			if (elementBitmap) {
				elementBitmap.x = - elementBitmap.width / 2;
				elementBitmap.y = - elementBitmap.width / 2;
			}
		}
		
		private function onRollOutHdl(e:MouseEvent):void {
			dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
			if(_data != null)
			{
				movAvatar.filters = [];
			}
			btnInfo.visible = false;
			btnRemove.visible = false;
			btnLock.visible = _isLock;
		}
		
		private function onRollOverHdl(e:MouseEvent):void {
			if (_data && _toolTipEnable)
			{
				btnInfo.visible = true;
				btnRemove.visible = true;
				btnLock.visible = true;

				if (!movEffectSelect.visible) {
					_glow.color = 0xffff00;
					_glow.strength = 3;
					_glow.blurX = _glow.blurY = 15;
					movAvatar.filters = [_glow];	
				}
				dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type:TooltipID.CHARACTER_SLOT, value:_data }, true));
			}
		}
		
		private function onMouseMoveHdl(e:MouseEvent):void {
			if (_data && _toolTipEnable) {
				dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type:TooltipID.CHARACTER_SLOT, value:_data }, true));
			}
		}
		
		private function onAvatarLoadedHdl(e:Event):void {
			if (avatarBitmap) {
				avatarBitmap.x = - avatarBitmap.width / 2;
				avatarBitmap.y = - avatarBitmap.width / 2;
			}
		}
		
		public function set isSelected(value:Boolean):void {
			if(_data != null) movEffectSelect.visible = value;
		}
		
		public function clearData():void {
			dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, true));
		}
		
		public function setData(_value:Character):void {
			if(_data == _value) return;
			if(_data != null) _data.removeEventListener(Character.UPDATED, onDataUpdated);
			_data = _value;
			if(_data != null) _data.addEventListener(Character.UPDATED, onDataUpdated);
			expireTimer.stop();
			if(this.status != OCCUPIED) return;
			onDataUpdated(null);
		}
		
		protected function onDataUpdated(event:Event):void
		{
			if (_data && _data.ID != -1 && _data.xmlData) {
				if (!_glow) {
					_glow = new GlowFilter();
				}
				
				if(useAnimOrAvatar)
				{
					animator.load(_data.xmlData.animURLs[_data.sex]);
				}
				else
				{
					avatarBitmap.load(_data.xmlData.largeAvatarURLs[_data.sex]);
				}
				movAvatar.addChild(avatarBitmap);
				var elementData:ElementData = Game.database.gamedata.getData(DataType.ELEMENT, _data.element) as ElementData;
				if (elementData) {
					elementBitmap.visible = true;
					elementBitmap.load(elementData.characterSlotImgURL);
					movElementContainer.addChild(elementBitmap);
				}
				
				if(_data.isExpired())
				{
					movExpired.visible = true;
					usedMov.gotoAndStop("normal");
				}
				else
				{
					movExpired.visible = false;
					if (_data.expiredTime > 0)
					{
						expireTimer.delay = _data.expiredTime * 1000;
						expireTimer.start();
					}
					
					//check status
					usedMov.gotoAndStop(_data.isInMainFormation ? "formation" :
						(Game.database.userdata.checkIsInFormationChallengeTemp(_data.ID) ? "challenge" :
							(_data.isInQuestTransport ? "transport" : "normal")));					
				}
				
				var htmlText:String;
				htmlText = "<font color = '" + UtilityUI.getTxtColor(_data.rarity, _data.isMainCharacter, _data.isLegendary() ) + "'>" + _data.name + "</font>";
				_glow.strength = 10;
				_glow.blurX = _glow.blurY = 4;
				_glow.color = UtilityUI.getTxtGlowColor(_data.rarity, _data.isMainCharacter, _data.isLegendary());
				txtName.filters = [_glow];
				txtName.htmlText = htmlText;
				FontUtil.setFont(txtName, Font.ARIAL);
				
				levelIcon.visible = true;
				levelIcon.level = _data.level;
				btnEvolution.visible = _data.isEvolvable();
				isLock = _data.isLock;
			} 
			else
			{
				levelIcon.visible = false;
			}
		}

		public function get isLock():Boolean
		{
			return _isLock;
		}

		public function set isLock(isLock:Boolean):void
		{
//			trace("setLock: " + isLock);
			_isLock = isLock;
			if(_data) _data.isLock = isLock;
			btnLock.visible = _isLock;
		}
		
		public function getData():Character {
			return _data;
		}
		
		public function enableToolTip(enable:Boolean):void {
			_toolTipEnable = enable;
		}
	}

}