package game.ui.home.gui 
{
	import core.display.BitmapEx;
	import core.util.FontUtil;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import game.enum.Font;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class PlayerInfoUI extends Sprite
	{
		//
		public var playerNameTf : TextField;
		public var levelTf : TextField;
		
		private var playerName : String;
		private var level : int;
		private var avatarBmp : BitmapEx;
		
		public function PlayerInfoUI() 
		{
			avatarBmp = new BitmapEx();
			avatarBmp.x = 38;
			avatarBmp.y = -51;
			this.addChild(avatarBmp);
			
			FontUtil.setFont(playerNameTf, Font.ARIAL);
			FontUtil.setFont(levelTf, Font.ARIAL);
			//test
			//avatarBmp.load("resource/image/character_avatar/caibang1.png");
		}
		
		public function setName(name : String) : void {
			this.name = name;
			
		}
		
		public function setLevel(level : int) : void {
			this.level = level;
			
		}
		
		public function loadAvatar(url : String) : void {
			avatarBmp.addEventListener(BitmapEx.LOADED, onBitmapLoaded);
			avatarBmp.load(url);
			
		}
		
		private function onBitmapLoaded(e:Event):void 
		{
			
		}
	}

}