package game.ui.friend.gui
{
	import core.display.BitmapEx;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	import game.data.model.Character;
	import game.data.model.UserData;
	import game.data.xml.DataType;
	import game.data.xml.ElementData;
	import game.enum.Font;
	import game.Game;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class AvatarInfo extends MovieClip
	{
		public var levelTf:TextField;
		public var roleNameTf:TextField;
		public var numOfGiveTf:TextField;
		public var numOfReceiveTf:TextField;

		public var totalFriendTf:TextField;
		public var maskAvatar:MovieClip;
		
		private var _avatarBitmap:BitmapEx;
		private var _elementBitmap:BitmapEx;
		
		public function AvatarInfo()
		{
			FontUtil.setFont(levelTf, Font.ARIAL, true);
			FontUtil.setFont(totalFriendTf, Font.ARIAL, true);
			FontUtil.setFont(roleNameTf, Font.ARIAL, true);
			FontUtil.setFont(numOfGiveTf, Font.ARIAL, true);
			FontUtil.setFont(numOfReceiveTf, Font.ARIAL, true);

			numOfGiveTf.autoSize = TextFieldAutoSize.LEFT;
			numOfReceiveTf.autoSize = TextFieldAutoSize.LEFT;

			_elementBitmap = new BitmapEx();
			this.addChild(_elementBitmap);
			_elementBitmap.x = 11;
			_elementBitmap.y = 12;
			
			_avatarBitmap = new BitmapEx();
			this.addChild(_avatarBitmap);
			_avatarBitmap.x =   15;
			_avatarBitmap.y =   10;
			_avatarBitmap.addEventListener(BitmapEx.LOADED, onAvatarLoadedHdl);
			
			this.swapChildren(maskAvatar, _elementBitmap);
			
			totalFriendTf.text = "Bạn: 0/100";
		}
		
		private function onAvatarLoadedHdl(e:Event):void 
		{
			
		}
		
		public function init():void
		{
			roleNameTf.text = Game.database.userdata.playerName;
			levelTf.text = "Lv:" + Game.database.userdata.level;
			var mainCharacter:Character = Game.database.userdata.mainCharacter;
			if (mainCharacter != null)
			{
				_avatarBitmap.visible = true;
				_avatarBitmap.load(mainCharacter.xmlData.smallAvatarURLs[mainCharacter.sex]);
				var elementData:ElementData = Game.database.gamedata.getData(DataType.ELEMENT, mainCharacter.element) as ElementData;
				if (elementData)
				{
					_elementBitmap.visible = true;
					_elementBitmap.load(elementData.formationSlotImgURL);
				}
			}
		
		}
	
	}

}