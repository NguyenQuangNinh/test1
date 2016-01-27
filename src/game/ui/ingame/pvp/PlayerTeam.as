package game.ui.ingame.pvp
{
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	
	import game.data.model.Character;
	
	public class PlayerTeam extends Sprite
	{
		public static const NUM_PLAYERS:int = 3;
		
		private var playerAvatars:Array;
		
		public function PlayerTeam()
		{
			playerAvatars = [];
			for(var i:int = 0; i < NUM_PLAYERS; ++i)
			{
				var playerAvatar:PlayerAvatar = new PlayerAvatar();
				playerAvatar.x = i * 80;
				addChild(playerAvatar);
				playerAvatars.push(playerAvatar);
			}
			reset();
		}
		
		public function reset():void
		{
			for each(var avatar:PlayerAvatar in playerAvatars)
			{
				TweenMax.to(avatar, 0, {colorMatrixFilter: { saturation: 1}});
			}
		}
		
		public function setPlayerLeader(index:int, character:Character, name:String):void
		{
			var playerAvatar:PlayerAvatar = playerAvatars[index];
			if(playerAvatar != null)
			{
				playerAvatar.setData(character, name);
			}
		}
		
		public function disable(index:int):void
		{
			var playerAvatar:PlayerAvatar = playerAvatars[index];
			if(playerAvatar == null) return;
			TweenMax.to(playerAvatar, 0, {colorMatrixFilter: { saturation: 0}});
		}
	}
}