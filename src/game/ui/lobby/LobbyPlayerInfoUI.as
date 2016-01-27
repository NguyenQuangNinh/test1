package game.ui.lobby 
{
	import core.Manager;
	import core.display.BitmapEx;
	import core.display.animation.Animator;
	import core.util.FontUtil;
	import core.util.Utility;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	
	import game.Game;
	import game.data.model.Character;
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.data.xml.CharacterXML;
	import game.data.xml.XMLData;
	import game.enum.Font;
	import game.enum.LobbyEvent;
	import game.ui.components.FormationSlot;
	import game.ui.components.InteractiveAnim;
	//import game.ui.home.CharacterOutGame;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class LobbyPlayerInfoUI extends MovieClip
	{								
		//private static const DISTANCE_X_PER_MINI_SLOT:int = 0;
		//private static const DISTANCE_Y_PER_MINI_SLOT:int = -9;
		
		private static const AVATAR_START_FROM_X:int = 10;
		private static const AVATAR_START_FROM_Y:int = 95;
		
		private static const DISTANCE_PER_CHARACTER:int = 45;
		private static const TXT_NAME_PLAYER_START_FROM_X:int = 120;
		
		//private var _mainSlot: FormationSlot;
		private var _slots: Array = [];
		private var _data: Array = [];
		
		public var viewBtn:SimpleButton;
		public var swapBtn:SimpleButton;
		public var kickBtn:SimpleButton;
		public var nameTf:TextField;
		public var percentTf:TextField;
		public var stateMov:MovieClip;
		
		public var okMov:MovieClip;
		
		private var _slotContainer:MovieClip;
		private var _enableKick:Boolean = false;
		
		public static const TYPE_FREE:String = "free";
		public static const TYPE_MATCHING:String = "matching";
		public static const TYPE_LOADING:String = "loading";
		
		private var _type:String = "";
		
		public function LobbyPlayerInfoUI() 
		{
			initUI()
		}
		
		private function initUI():void 
		{
			//removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//set default bg
			//setType(TYPE_FREE);
			
			//init UI
			FontUtil.setFont(nameTf, Font.ARIAL, true);
			FontUtil.setFont(percentTf, Font.ARIAL, true);
				
			_slotContainer = new MovieClip();
			_slotContainer.x = AVATAR_START_FROM_X;
			_slotContainer.y = AVATAR_START_FROM_Y;
			addChild(_slotContainer);
			//var avatar:BitmapEx;
			for (var i:int = Game.MAX_CHARACTER - 1; i >= 0; i--) {
				var characterObj: InteractiveAnim = Manager.pool.pop(InteractiveAnim) as InteractiveAnim;				
				characterObj.enableInteractive = false;
				characterObj.enableMoving(false);
				characterObj.visible = false;				
				_slots.push(characterObj);
				_slotContainer.addChild(characterObj);
			}
				
			//add events
			stateMov.buttonMode = true;
			stateMov.addEventListener(MouseEvent.CLICK, onClickBtnHdl);
			viewBtn.addEventListener(MouseEvent.CLICK, onClickBtnHdl);
			swapBtn.addEventListener(MouseEvent.CLICK, onClickBtnHdl);
			kickBtn.addEventListener(MouseEvent.CLICK, onClickBtnHdl);			
		}
		
		private function onClickBtnHdl(e:MouseEvent):void 
		{
			switch(e.target) {
				case viewBtn:
					dispatchEvent(new Event(LobbyEvent.VIEW_PLAYER, true));					
					break;
				case swapBtn:
					dispatchEvent(new Event(LobbyEvent.SWAP_PLAYER, true));
					break;
				case kickBtn:
					dispatchEvent(new Event(LobbyEvent.KICK_PLAYER, true));
					break;
				case stateMov:
					
					break;
			}
		}
		
		public function updateInfo(data:LobbyPlayerInfo, showFromRight:Boolean = false):void {
			_data = data ? data.characters : null;
			FontUtil.setFont(nameTf, Font.ARIAL, true);
			//Utility.log("showFromRight=" + showFromRight);
			//nameTf.text = findMainCharacterName(data);
			nameTf.text = data ? data.name : "";
			var character:Character;
			var characterObj: InteractiveAnim;
			var numVisible:int = 0;
			//if(data)
				//data.characters = data.characters.concat(data.characters);
			var startIndex:int = showFromRight ? Game.MAX_CHARACTER - 1 : 0;
			var endIndex:int = showFromRight ? -1 : Game.MAX_CHARACTER;
			//for (var i:int = 0; i < Game.MAX_CHARACTER; i++) {
			for (var i:int = startIndex; i != endIndex; showFromRight ? i-- : i++) {
				characterObj = _slots[i] as InteractiveAnim;
				characterObj.visible = _data && _data[i] && !(_data[i] as Character).isExpired();
				characterObj.y = 0;
				//characterObj.x = characterObj.visible ? (Game.MAX_CHARACTER - numVisible) * DISTANCE_PER_CHARACTER : 0;
				characterObj.x = characterObj.visible ? 
									//(showFromRight ? (Game.MAX_CHARACTER - numVisible) * DISTANCE_PER_CHARACTER - DISTANCE_PER_CHARACTER / 2
									//: numVisible * DISTANCE_PER_CHARACTER + DISTANCE_PER_CHARACTER / 2) : 
									numVisible * DISTANCE_PER_CHARACTER + DISTANCE_PER_CHARACTER / 2 : 0;
									//(showFromRight ? Game.MAX_CHARACTER * DISTANCE_PER_CHARACTER : 0)	;
				numVisible = characterObj.visible ? numVisible + 1 : numVisible;
				character = _data && _data[i] ? (_data[i] as Character) : null;
				characterObj.loadAnim(character ? character.xmlData.animURLs[character.sex] : "");
				characterObj.direction = showFromRight ? InteractiveAnim.LEFT : InteractiveAnim.RIGHT;
				//if (_data && _data.length > 0)
					//Utility.log("player pos is " + characterObj.x + " by ID " + (character ? character.ID.toString() : ""));				
			}
			//Utility.log("num visible is: " + numVisible);
			if(_type != TYPE_LOADING) {
				viewBtn.x = showFromRight ? -3/2 * viewBtn.width : viewBtn.x;
				kickBtn.x = showFromRight ? -kickBtn.width : kickBtn.x;
				swapBtn.x = showFromRight ? -swapBtn.width : swapBtn.x;
					
				viewBtn.visible =  (_data && _data.length > 0) ? true : false;
				swapBtn.visible = (_data && (_data.length == 0 || (_data.length > 0 && data.name != Game.database.userdata.playerName))) ? true : false;			
				kickBtn.visible =  _enableKick ? (_data && _data.length > 0 && data.name != Game.database.userdata.playerName) : false;	
			}else {
				viewBtn.visible = false;
				kickBtn.visible = false;
				swapBtn.visible = false;
				percentTf.x = showFromRight ? 0 : 400;
				okMov.x = showFromRight ? 0 : 400;
			}
			
			changeState(_data && _data.length > 0 ? 1 : 0);
			
			alignFormation(numVisible, showFromRight);
		}
		
		private function findMainCharacterName(data:LobbyPlayerInfo):String 
		{
			var result:String = "";
			if (data && data.characters) {
				var info:Character;
				for (var i:int = 0; i < data.characters.length; i++) {
					info = data.characters[i] as Character;
					if (info && info.isMainCharacter) {
						result = info.name;
						break;
					}
				}
			}
			
			return result
		}
		
		private function alignFormation(numVisible:int, showFromRight:Boolean):void 
		{
			var totalWidth:int = numVisible * DISTANCE_PER_CHARACTER;
			//Utility.log("the exactly width is " + Game.MAX_CHARACTER * DISTANCE_PER_CHARACTER);
			//Utility.log("the total width is " + totalWidth);
			var deltaX:int = totalWidth > 0 ? (Game.MAX_CHARACTER * DISTANCE_PER_CHARACTER - totalWidth) / 2: 0;
			//_slotContainer.x = AVATAR_START_FROM_X;
			_slotContainer.x = deltaX /** (showFromRight ? -1 : 1)*/ + DISTANCE_PER_CHARACTER / 2 /** (showFromRight ? -1 : 1)*/;
			
			/*var rectangle:Shape = new Shape(); // initializing the variable named rectangle
			rectangle.graphics.beginFill(0xFF0000); // choosing the colour for the fill, here it is red
			rectangle.graphics.drawRect(0, 0, _slotContainer.width, _slotContainer.height); // (x spacing, y spacing, width, height)
			rectangle.graphics.endFill(); // not always needed but I like to put it in to end the fill
			rectangle.alpha = 0.3;
			_slotContainer.addChild(rectangle);			*/
			//update name position
			//nameTf.x = _slotContainer.x + (_slotContainer.width - nameTf.width) / 2 /** (showFromRight ? 1 : -1)*/;
			//Utility.log("name position is set at: " + nameTf.x + " by width " + nameTf.width);
			//Utility.log("slot container align from " + (showFromRight ? "right"  : "left") + " is " + _slotContainer.x + " width " + _slotContainer.width);			
		}
		
		private function changeState(state:int):void {
			switch(state) {
				case 0:
					//available
					stateMov.gotoAndStop("available");
					break;
				case 1:
					//occupy
					stateMov.gotoAndStop("occupy");
					break;
				case 2:
					//lock
					stateMov.gotoAndStop("lock");
					break;
			}			
		}
		
		public function setLock(isLock:Boolean): void {
			changeState(isLock ? 2 : 0);
		}
		
		public function enableKick(enable:Boolean):void {
			_enableKick = enable;
		}
		
		public function setType(type:String):void {
			//Utility.log("lobby player UI init with mode: " + type);
			_type = type;
			gotoAndStop(type);
			nameTf.x = type == TYPE_FREE ? TXT_NAME_PLAYER_START_FROM_X : TXT_NAME_PLAYER_START_FROM_X + 30;
			switch (type)
			{
				case TYPE_MATCHING:
					swapBtn.y = -59;
					viewBtn.y = -35;
					kickBtn.y = -12;
					break;
				default :
					swapBtn.y = 30;
					viewBtn.y = 54;
					kickBtn.y = 77;
			}
		}
		
		public function updatePercent(percent:int): void {
			percentTf.text = (percent > 0 && percent < 99) ? percent.toString() + "%" : "";
			okMov.visible = percent == 100;			
		}
	}

}