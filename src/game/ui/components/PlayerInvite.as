package game.ui.components 
{
	import core.display.BitmapEx;
	import core.event.EventEx;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.data.model.Character;
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.enum.Font;
	import game.enum.LobbyEvent;
	import game.Game;
	import game.ui.arena.ArenaEventName;
	import game.ui.components.FormationSlot;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class PlayerInvite extends MovieClip
	{		
		private static const PLAYER_START_FROM_X:int = 11;
		private static const PLAYER_START_FROM_Y:int = 13;
		
		public var inviteBtn:SimpleButton;
		public var challengeBtn:SimpleButton;
		public var checkMov:MovieClip;
		public var nameTf:TextField;
		public var rankTf:TextField;
		public var rankNumTf:TextField;
		public var bgMov:MovieClip;
		
		//private var _player:FormationSlot;
		private var _playerAvatar:BitmapEx;
		
		private var _data:LobbyPlayerInfo;
		
		public function PlayerInvite() 
		{
			/*if (stage)
				init();
			else addEventListener(Event.ADDED_TO_STAGE, init);	*/
			initUI();
		}
		
		/*private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			initUI();			
		}*/
		
		private function initUI():void 
		{
			//set font
			FontUtil.setFont(nameTf, Font.ARIAL, false);
			FontUtil.setFont(rankTf, Font.ARIAL, false);
			FontUtil.setFont(rankNumTf, Font.ARIAL, false);
			
			//player slot
			//init UI
			/*_player = new FormationSlot();
			_player.enableToolTip(false);
			_player.showSkillSlot(false,false);
			_player.x = PLAYER_START_FROM_X;
			_player.y = PLAYER_START_FROM_Y;
			_player.scaleX = _player.scaleY = 0.9;
			_player.typeMov.x += 3;
			_player.typeMov.y -= 5;
			_player.typeMov.scaleX = 0.87;
			_player.typeMov.scaleY = 1.15;
			_player.changeType(false, true);
			addChildAt(_player, 0);*/
			//Utility.log("main _player pos is " + _player.x + " // " + _player.y);
			_playerAvatar = new BitmapEx();
			_playerAvatar.x = PLAYER_START_FROM_X;
			_playerAvatar.y = PLAYER_START_FROM_Y;
			addChild(_playerAvatar);
			
			//add events
			inviteBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			challengeBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			
			gotoAndStop("normal");
		}
		
		private function onBtnClickHdl(e:MouseEvent):void 
		{
			switch(e.target) {
				case inviteBtn:
					dispatchEvent(new EventEx(LobbyEvent.PLAYER_INVITE_CLICK, _data, true));					
					break;
				case challengeBtn:
					dispatchEvent(new EventEx(ArenaEventName.PLAYER_CHALLENGE_CLICK, _data, true));
					break;
			}
		}
		
		public function update(data:LobbyPlayerInfo, isChallenge:Boolean): void {
			_data = data;
			if (_data) {
				nameTf.text = data.name;
				if (data.rank > 0)
				{
					rankNumTf.text = data.rank > 0 ? data.rank.toString() : "";
					rankTf.text = data.rank > 0 ? "Hạng:" : "";
				} else {
					rankNumTf.text = data.level.toString();
					rankTf.text = "Cấp:";
				}
				if(_data.characters) {
					var mainPlayer:Character;
					for (var i:int = 0; i < _data.characters.length; i++) {
						var player:Character = _data.characters[i] as Character;
						if (player && player.isMainCharacter) {
							mainPlayer = player;
							break;
						}							
					}
					//_player.setData(mainPlayer ? mainPlayer : null);
					_playerAvatar.load(mainPlayer && mainPlayer.xmlData ? mainPlayer.xmlData.smallAvatarURLs[mainPlayer.sex] : "");
				}
				inviteBtn.visible = !isChallenge;
				challengeBtn.visible = isChallenge &&  data.name != Game.database.userdata.playerName;
				
				if (data.name == Game.database.userdata.playerName)
					gotoAndStop("self");
				else 
					gotoAndStop("normal");
			}
		}
		
		public function enableCheck(enable:Boolean): void {
			checkMov.visible = enable;
		}
		
		public function enableChallenge(enable:Boolean): void {
			challengeBtn.visible = enable; 
		}
		
	}

}