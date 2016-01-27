package game.ui.components.characterslot
{
	import core.display.BitmapEx;
	
	import flash.events.Event;
	
	import game.data.model.Character;

	public class CharacterSlotAvatar extends CharacterSlotSimple
	{
		private var avatar:BitmapEx = new BitmapEx();
		
		public function CharacterSlotAvatar()
		{
			characterContainer.addChild(avatar);
			avatar.addEventListener(BitmapEx.LOADED, onAvatarLoaded);
		}
		
		protected function onAvatarLoaded(event:Event):void
		{
			avatar.x = -(avatar.width >> 1);
			avatar.y = -100;
		}
		
		override protected function update():void
		{
			super.update();
			if(data != null)
			{
				avatar.load(data.xmlData.largeAvatarURLs[data.sex]);
			}
			else
			{
				avatar.reset();
			}
		}
	}
}