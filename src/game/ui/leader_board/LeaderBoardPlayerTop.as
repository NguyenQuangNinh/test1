package game.ui.leader_board 
{
	import core.display.BitmapEx;
	import core.event.EventEx;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import game.data.model.Character;
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.enum.Font;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class LeaderBoardPlayerTop extends MovieClip
	{
		
		public var nameTf:TextField;
		public var rankMov:MovieClip;
		public var levelTf:TextField
		
		private var _avatar:BitmapEx;
		private static const AVATAR_START_FROM_X:int = 15;
		private static const AVATAR_START_FROM_Y:int = -15;
		
		private var _info:LobbyPlayerInfo;
		
		public function LeaderBoardPlayerTop() 
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
			gotoAndStop("top");
			
			//set fonts
			FontUtil.setFont(nameTf, Font.ARIAL, false);
			FontUtil.setFont(levelTf, Font.ARIAL, false);
			
			//avatar 
			_avatar = new BitmapEx();
			_avatar.x = AVATAR_START_FROM_X;
			_avatar.y = AVATAR_START_FROM_Y;
			addChildAt(_avatar, 0);
			
			_avatar.addEventListener(BitmapEx.LOADED, onLoadCompleteHdl);
		}
		
		private function onLoadCompleteHdl(e:Event):void 
		{
			
		}
		
		public function updateInfo(index:int, info:LobbyPlayerInfo): void {
			_info = info;
			if (_info) {				
				nameTf.text = _info ? _info.name : "";
				//update rank
				rankMov.gotoAndStop(_info ? index + 2 : 0);
				//update level
				levelTf.text = _info ? "Cấp: " + _info.level.toString() : "";
				//update avatar
				var character:Character = _info && _info.characters && _info.characters[0] ? (_info.characters[0] as Character) : null;
				_avatar.load(character ? character.xmlData.largeAvatarURLs[character.sex]: "");	
				this.visible = true;
			}else {
				this.visible = false;
			}
		}
		
	}

}