package game.ui.friend.gui
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import game.ui.components.ScrollbarEx;
	import game.ui.friend.FriendView;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class FriendContainer extends Sprite
	{
		public var contentMask:MovieClip;
		public var track:MovieClip;
		public var slider:MovieClip;
		
		
		private var _contentScrollBar:MovieClip = new MovieClip();
		private var _arrFriend:Array;
		private var scrollbar:ScrollbarEx;
		
		public function FriendContainer()
		{
			contentMask.visible = false;
			scrollbar = new ScrollbarEx();
			_contentScrollBar.x = 30;
			_contentScrollBar.y = contentMask.y;
			
			this.addChild(_contentScrollBar);
		}
		
		public function showFriendList(arrFriend:Array):void
		{
			while (_contentScrollBar.numChildren > 0)
			{
				_contentScrollBar.removeChildAt(0);
			}
			
			_arrFriend = [];
			
			arrFriend.sortOn("online", Array.DESCENDING);
			
			
			for (var i:int = 0; i < arrFriend.length; i++)
			{
				var obj:Object = arrFriend[i];
				var friend:FriendItem = new FriendItem();
				friend.init(obj);
				friend.x = 0;
				friend.y = i * 40;
				_contentScrollBar.addChild(friend);
				_arrFriend.push(friend);
				
			}
			scrollbar.init(_contentScrollBar, contentMask, track, slider);
			scrollbar.verifyHeight();
		
		}

		public function getFriendItem(id:int):FriendItem
		{
			for each (var item:FriendItem in _arrFriend)
			{
				if(item.playerID == id) return item;
			}
			return null;
		}

		public function checkOutFriend():Boolean
		{
			return _arrFriend.length == FriendView.PAGE_NUM;
		}
	}

}