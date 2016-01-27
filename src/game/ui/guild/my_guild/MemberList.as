package game.ui.guild.my_guild 
{
	import components.BaseList;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import game.enum.LeaderBoardTypeEnum;
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.request.RequestGetListFromTo;
	import game.net.lobby.request.RequestGetListFromToType;
	import game.net.lobby.response.data.GuMemberInfo;
	import game.net.lobby.response.ResponseGuTopLadder;
	import game.enum.Font;
	/**
	 * ...
	 * @author vu anh
	 */
	public class MemberList extends MovieClip
	{
		public var pageTf:TextField;
		public var backBtn:SimpleButton;
		public var nextBtn:SimpleButton;
		
		private var pageIndex:int;
		private var pageSize:int = 9;
		
		private var itemList:Array;
		
		public var item0:MovieClip;
		public var activeItem:MemberItem;
		
		public function MemberList() 
		{
			FontUtil.setFont(pageTf, Font.ARIAL, true);
			item0.visible = false;
			itemList = [];
			var item:MemberItem;
			var pos:Point = new Point(item0.x, item0.y);
			for (var i:int = 0; i < pageSize; i++) 
			{
				item = new MemberItem();
				item.x = pos.x;
				item.y = pos.y;
				pos.y += 29;
				item.reset();
				itemList.push(item);
				addChild(item);
				
				item.addEventListener(MouseEvent.CLICK, itemHdl);
			}
			pageIndex = 0;
			nextBtn.addEventListener(MouseEvent.CLICK, nextBtnHdl);
			backBtn.addEventListener(MouseEvent.CLICK, backBtnHdl);
			nextBtn.mouseEnabled = false;
			backBtn.mouseEnabled = false;
		}
		
		public function setActive(item:MemberItem):void
		{
			if (activeItem) activeItem.deactive();
			activeItem = item;
			activeItem.active();
		}
		
		public function lock():void
		{
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		public function unlock():void
		{
			this.mouseEnabled = true;
			this.mouseChildren = true;
		}
		
		private function itemHdl(e:MouseEvent):void 
		{
			if (!(e.currentTarget as MemberItem).info) return;
			setActive(e.currentTarget as MemberItem);
		}
		
		private function backBtnHdl(e:MouseEvent):void 
		{
			backBtn.mouseEnabled = false;
			nextBtn.mouseEnabled = true;
			if (pageIndex == 0) return;
			pageIndex--;
			pageTf.text = (pageIndex + 1).toString();
			getMemberList();
		}
		
		private function nextBtnHdl(e:MouseEvent):void 
		{
			nextBtn.mouseEnabled = false;
			backBtn.mouseEnabled = true;
			pageIndex++;
			pageTf.text = (pageIndex + 1).toString();
			getMemberList();
		}
		
		public function getMemberList():void
		{
			Game.network.lobby.sendPacket(new RequestGetListFromTo(LobbyRequestType.GU_GET_MEMBER_LIST, pageIndex * pageSize, (pageIndex + 1) * pageSize));
		}
		
		public function clearList():void
		{
			var item:MemberItem;
			for (var i:int = 0; i < pageSize; i++) 
			{
				item = itemList[i];
				item.reset();
			}
		}
		
		public function updateMemberList(infoList:Array):void
		{
			var item:MemberItem;
			var info:GuMemberInfo;
			if (infoList.length == 0) 
			{
				// incase page reach end position, server return empty list => reserve page index to previous value
				pageIndex--;
				if (pageIndex < 0) pageIndex = 0;
				pageTf.text = (pageIndex + 1).toString();
				return;
			}
			// only show next back btn if the list has item - the current user has a guild
			nextBtn.mouseEnabled = true;
			backBtn.mouseEnabled = true;
			for (var i:int = 0; i < pageSize; i++) 
			{
				item = itemList[i];
				if (i < infoList.length)
				{
					info = infoList[i];
					// update index
					info.index = pageIndex * pageSize + i + 1;
					item.update(info);
				}
				else 
				{
					item.reset();
				}
			}
		}
		
		public function unselectItem():void
		{
			if (activeItem) activeItem.deactive();
		}
		
	}

}