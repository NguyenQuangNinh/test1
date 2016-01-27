package game.ui.master_invitation
{
	import core.display.BitmapEx;
	
	import flash.display.MovieClip;
	
	import game.data.xml.CharacterXML;
	import game.enum.Sex;
	
	public class AvatarMaster extends MovieClip
	{
		public var containerAvatar:MovieClip;
		public var highlight:MovieClip;
		
		private var avatar:BitmapEx;

		private var oX:int = 0;
		private var oY:int = 0;
		private var oScale:int = 1;

		public function AvatarMaster()
		{
			avatar = new BitmapEx();
			containerAvatar.addChild(avatar);
			
			highlight.visible = false;
		}
		
		public function setData(xmlData:CharacterXML):void
		{
			if(xmlData != null)
			{
				avatar.load(xmlData.largeAvatarURLs[Sex.FEMALE]);
			}
			else
			{
				avatar.reset();
			}
		}

		public function save():void
		{
			oX = this.x;
			oY = this.y;
			oScale = this.scaleX;
		}

		public function reset():void
		{
			this.x = oX;
			this.y = oY;
			scaleX = oScale;
			scaleY = oScale;
			filters = [];
		}

		public function setSelected(value:Boolean):void { highlight.visible = value; }
		
		public function getSelected():Boolean {
			return highlight.visible;
		}
	}
}