package game.ui.ingame.pvp
{
	import core.display.BitmapEx;
	import core.util.FontUtil;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import game.data.model.Character;
	import game.enum.Font;
	
	public class PlayerAvatar extends Sprite
	{
		public var movAvatar:MovieClip;
		public var txtName:TextField;
		
		private var avatar:BitmapEx;
		
		public function PlayerAvatar()
		{
			avatar = new BitmapEx();
			movAvatar.addChild(avatar);
			
			FontUtil.setFont(txtName, Font.TAHOMA, true);
			txtName.text = "";
		}
		
		public function setData(character:Character, name:String):void
		{
			if(character != null)
			{
				avatar.visible = true;
				avatar.load(character.xmlData.smallAvatarURLs[character.sex]);
				txtName.text = name;
			}
			else
			{
				avatar.visible = false;
			}
		}
	}
}