package game.ui.components 
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import game.enum.ElementRelationship;
	import game.utility.UtilityUI;
	
	import core.display.BitmapEx;
	import core.event.EventEx;
	import core.util.FontUtil;
	import core.util.Utility;
	
	import game.Game;
	//import game.data.enum.ElementRelationship;
	import game.data.model.Character;
	import game.data.vo.skill.Skill;
	import game.data.xml.DataType;
	import game.data.xml.ElementData;
	import game.enum.DragDropEvent;
	import game.enum.Font;
	import game.enum.GameConfigID;
	import game.enum.SkillType;
	import game.main.SkillSlot;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;

	/**
	 * ...
	 * @author TrungLNM
	 */
	public class FormationSlot extends MovieClip
	{
		static public const FORMATION_SLOT_CLICK	:String = "formation_slot_click";
		static public const FORMATION_SLOT_DCLICK	:String = "formation_slot_double_click";	
		static public const FORMATION_SLOT_DRAG		:String = "formation_slot_drag";
		public static const ADD_CHARACTER_CLICK		:String = "add_character_click";
		
		public static const ICON_WIDTH:int = 77;
		public static const ICON_HEIGHT:int = 63;
		
		private static const SKILL_START_FROM_X:int = 0;
		private static const SKILL_START_FROM_Y:int = -38;
		
		public var levelUpTf	:TextField;
		public var levelTf		:TextField;
		public var nameTf		:TextField;
		private var glowFilter:GlowFilter;
		public var nextLevelTf	:TextField;
		public var levelBgMov	:MovieClip;
		
		public var avatarMov		:MovieClip;
		public var addCharacterMov			:MovieClip;
		public var typeMov			:MovieClip;
		public var bgSlotMov		:MovieClip;
		public var lockMov			:MovieClip;
		public var movExpired		:MovieClip;
		public var skillSlot		:SkillSlot;
		
		private var _data			:Character;
		private var _avatarBitmap	:BitmapEx;
		private var _elementBitmap	:BitmapEx;
		private var _isAvatarMoveUp		:Boolean = false;
		private var _isShowOnlyAvatar	:Boolean = false;
		private var _glow				:GlowFilter;
		
		private var _isMouseDown:Boolean = false;
		private var _clickStarted:int = -1;
		private var _mouseTimeOut:int;
		
		private var _toolTipEnable:Boolean = true;
		private var _showSkillSlot:Boolean = true;
		private var _isInLevelUpModule:Boolean;
		
		public function FormationSlot() {
			init();
		}
		
		private function init():void {
			FontUtil.setFont(nameTf, Font.ARIAL);
			FontUtil.setFont(levelTf, Font.ARIAL, true);
			FontUtil.setFont(levelUpTf, Font.ARIAL, true);
			levelUpTf.autoSize = TextFieldAutoSize.CENTER;
			FontUtil.setFont(nextLevelTf, Font.ARIAL, true);
			nextLevelTf.autoSize = TextFieldAutoSize.CENTER;
			glowFilter = new GlowFilter(0, 1, 3, 3, 10);
			
			_avatarBitmap = new BitmapEx();
			avatarMov.addChild(_avatarBitmap);
			_avatarBitmap.addEventListener(BitmapEx.LOADED, onAvatarLoadedHdl);
			
			_elementBitmap = new BitmapEx();
			typeMov.addChild(_elementBitmap);
			_elementBitmap.x = -2;
			
			_glow = new GlowFilter();
			_glow.strength = 10;
			_glow.blurX = _glow.blurY = 4;
			
			buttonMode = true;
			
			bgSlotMov.mouseChildren = false;
			bgSlotMov.mouseEnabled = false;
			
			lockMov.visible = false;
			lockMov.mouseEnabled = false;
			lockMov.mouseChildren = false;
			
			movExpired.visible = false;
			movExpired.mouseChildren = false;
			movExpired.mouseEnabled = false;
			
			avatarMov.addEventListener(MouseEvent.ROLL_OVER, onRollOverHdl);
			avatarMov.addEventListener(MouseEvent.ROLL_OUT, onRollOutHdl);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHdl);
			addEventListener(MouseEvent.CLICK, onMouseClickHdl);
			
			addCharacterMov.visible = false;
			addCharacterMov.buttonMode = false;
			addCharacterMov.mouseEnabled = false;
			addCharacterMov.addEventListener(MouseEvent.CLICK, onAddCharacterHdl);
			
			isInLevelUpModule = false;
		}
		
		private function onAddCharacterHdl(e:MouseEvent):void 
		{
			dispatchEvent(new Event(ADD_CHARACTER_CLICK, true));
		}
		
		private function onRollOutHdl(e:MouseEvent):void 
		{
			dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));	
		}
		
		private function onRollOverHdl(e:MouseEvent):void 
		{
			if (_data && _toolTipEnable) {
				dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type:TooltipID.CHARACTER_SLOT, value:_data}, true));
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
				Utility.log("formation slot double click event fired");
				_clickStarted = -1;				
				dispatchEvent(new EventEx(FORMATION_SLOT_DCLICK, _data, true));
			}else {
				_clickStarted = getTimer();
				_mouseTimeOut = setTimeout(clickHdl, DragDropEvent.MAX_TIME_FOR_CLICK);	
			}
		}
		
		private function clickHdl():void 
		{
			Utility.log("formation slot click event fired");
			_clickStarted = -1;
			dispatchEvent(new EventEx(FORMATION_SLOT_CLICK, _data, true));
		}
		
		private function onMouseDownHdl(e:MouseEvent):void 
		{						
			if (_data != null) {
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
				var objDrag:BitmapEx = new BitmapEx();
				objDrag.load(_avatarBitmap.url);
				objDrag.name = "mov_drag";
				dispatchEvent(new EventEx(FORMATION_SLOT_DRAG, {target: objDrag, data: _data, x:e.stageX, y:e.stageY,
							from: DragDropEvent.FROM_FORMATION }, true));
			}
		}
		
		private function onAvatarLoadedHdl(e:Event):void 
		{
			if (_avatarBitmap) {
				_avatarBitmap.x = - _avatarBitmap.width / 2;
				_avatarBitmap.y = - _avatarBitmap.width / 2;
			}
		}
		
		public function set transmissionExpPercent(_percent:Number):void {
			var percent:Number = _percent + 1;
			if (0 <= percent <= 2) {
				if (_data) {
					var htmlText:String;
					var transmissionExp:int = percent * _data.transmissionExp;
					if (transmissionExp >= 0) {
						htmlText = "+" + transmissionExp;
						if (_percent < 0) {
							htmlText += "\n <font color = '#ff0000'>(+" + Math.abs(percent * 100) + "%)</font>";
							levelUpTf.htmlText = htmlText;
						} else if (_percent == 0){
							levelUpTf.htmlText = htmlText;
						} else {
							htmlText += "\n <font color = '#00ff00'>(+" + Math.abs(percent * 100) + "%)</font>";
							levelUpTf.htmlText = htmlText;
						}
					}
				}
			} else {
				levelUpTf.text = "";
			}
			
			FontUtil.setFont(levelUpTf, Font.ARIAL, true);
		}
		
		public function setPowerTransfer(exp:int, elementRelationship:int):void
		{
			if(exp > 0)
			{
				var penalty:int;
				var color:String;
				var glowColor:int;
				switch(elementRelationship)
				{
					case ElementRelationship.NORMAL:
					case ElementRelationship.GENERATED:
						penalty = 100;
						color = "#ffffff";
						glowColor = 0x000000;
						break;
					case ElementRelationship.GENERATING:
						penalty = 100 + Game.database.gamedata.getConfigData(GameConfigID.TRANMISSION_GENERATING_PERCENT);
						color = "#00ff00";
						glowColor = 0x003300;
						break;
					case ElementRelationship.DESTROY:
						penalty = 100 - Game.database.gamedata.getConfigData(GameConfigID.TRANMISSION_OVERCOMING_PERCENT);
						color = "#999999";
						glowColor = 0x333333;
						break;
					case ElementRelationship.RESIST:
						penalty = 0;
						color = "#ff0000";
						glowColor = 0x330000;
						break;
				}
				if(penalty > 0)
				{
					var value:int = exp * (penalty/100);
					levelUpTf.htmlText = "<font color = \'" + color + "\'>+" + value + " (" + penalty + "%)</font>";
				}
				else
				{
					levelUpTf.htmlText = "<font color = \'" + color + "\'>xung khắc</font>";
				}
				glowFilter.color = glowColor;
				levelUpTf.filters = [glowFilter];
				FontUtil.setFont(levelUpTf, Font.ARIAL, true);
			}
			else levelUpTf.text = "";
		}
		
		public function set isInLevelUpModule(value:Boolean):void {
			_isInLevelUpModule = value;
			skillSlot.visible = !value;
			bgSlotMov.visible = !value;
			/*if (value) {
				bgSlotMov.gotoAndStop(2);
			} else {
				bgSlotMov.gotoAndStop(1);
			}*/
		}
		
		public function setData(data:Character):void {
			_data = data;
			showSkillSlot(false, false);
			bgSlotMov.visible = !(_data && _data.ID != -1 && _data.xmlData);
			if (_data && _data.ID != -1 && _data.xmlData) {
				_avatarBitmap.visible = true;
				//_avatarBitmap.load(_data.xmlData.smallAvatarURLs[_data.sex]);
				_avatarBitmap.load(_data.xmlData.largeAvatarURLs[_data.sex]);
				
				nameTf.htmlText = "<font color = '" + UtilityUI.getTxtColor(data.rarity, data.isMainCharacter, data.isLegendary() ) + "'>" + data.name + "</font>";
				var glowFilter:GlowFilter = nameTf.filters[0];
				if(glowFilter != null)
				{
					glowFilter.strength = 10;
					glowFilter.blurX = glowFilter.blurY = 2;
					glowFilter.color = UtilityUI.getTxtGlowColor(data.rarity, data.isMainCharacter, data.isLegendary());
					nameTf.filters = [glowFilter];
				}
				FontUtil.setFont(nameTf, Font.ARIAL);
				levelTf.text = data.level + " tầng";
				levelBgMov.visible = true;
				
				//var elementData:ElementData = Game.database.gamedata.getData(DataType.ELEMENT, _data.element) as ElementData;
				var elementData:ElementData = Game.database.gamedata.getData(DataType.ELEMENT, _data.unitClassXML.element) as ElementData;
				if (elementData) {
					_elementBitmap.visible = true;
					if (!_isInLevelUpModule) {
						//_elementBitmap.load(elementData.formationSlotImgURL);		
						_elementBitmap.load(elementData.tooltipImgURL);		
					} else {
						_elementBitmap.load(elementData.levelUpImgURL);
					}
				}				
					
				if (data.skills) {					
					for each (var skill:Skill in data.skills) {
						if (skill && skill.xmlData && skill.xmlData.type == SkillType.ACTIVE && skill.isEquipped) {
							showSkillSlot(true, false);
							skillSlot.setData(skill);
							break;
						}
					}	
				}
				
				movExpired.visible = _data.isExpired();
			}
			else 
			{
				_avatarBitmap.load("");
				_elementBitmap.visible = false;
				levelUpTf.text = "";
				skillSlot.setData(null);
				movExpired.visible = false;
				nameTf.htmlText = "";
				levelTf.text = "";
				levelBgMov.visible = false;
			}
			
			/*var rectangle:Shape = new Shape(); // initializing the variable named rectangle
			rectangle.graphics.beginFill(0x0000FF); // choosing the colour for the fill, here it is red
			rectangle.graphics.drawRect(0, 0, this.width, this.height); // (x spacing, y spacing, width, height)
			rectangle.graphics.endFill(); // not always needed but I like to put it in to end the fill
			rectangle.alpha = 0.3;
			addChild(rectangle); // adds the rectangle to the stage*/
		}
		
		public function getData():Character {
			return _data;
		}
		
		public function getIconDimesion():Point {
			return new Point(ICON_WIDTH, ICON_HEIGHT);
		}
		
		public function enableToolTip(enable:Boolean):void {
			_toolTipEnable = enable;
		}
		
		public function showSkillSlot(show:Boolean, showHotKey:Boolean):void {
			_showSkillSlot = show;
			skillSlot.visible = show;
			skillSlot.showHotKey(showHotKey);
		}
		
		public function setLock(lock:Boolean, nextUnlock:String = ""):void {
			lockMov.visible = lock;
			nextLevelTf.text = lock && nextUnlock != "" ? "Cấp " + nextUnlock.toString() : "";
		}
		
		public function enableAddCharacter(enable:Boolean):void {
			addCharacterMov.visible = enable;
			addCharacterMov.mouseEnabled = enable;
			addCharacterMov.buttonMode = enable;
		}
		
		public function changeType(showBg:Boolean, showElement:Boolean): void {
			//change bg type -->  0 :normal // 1 :legend // 2 :empty
			/*switch(type) {
				case 0:
					bgSlotMov.gotoAndStop("normal");
					//typeMov.visible = true;
					break;
				case 1:
					bgSlotMov.gotoAndStop("legend");					
					//typeMov.visible = true;
					break;
				case 2:
					bgSlotMov.gotoAndStop("empty");					
					//typeMov.visible = false;
					break;
			}*/
			bgSlotMov.visible = showBg;
			typeMov.visible = showElement;
		}
		
		public function checkLock():Boolean {
			return lockMov.visible;
		}
	}

}