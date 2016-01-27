package game.ui.guild.home 
{
	import components.BaseList;
	import core.Manager;
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
	import game.net.lobby.response.data.GuLadderInfo;
	import game.net.lobby.response.ResponseGuTopLadder;
	import game.enum.Font;
	/**
	 * ...
	 * @author vu anh
	 */
	public class GuildInfoList extends MovieClip
	{
		public var pageTf:TextField;
		public var backBtn:SimpleButton;
		public var nextBtn:SimpleButton;
		
		private var pageIndex:int;
		private var pageSize:int = 9;
		
		private var itemList:Array;
		
		public var item0:MovieClip;
		public var activeItem:GuildItem;
		
		public function GuildInfoList() 
		{
			FontUtil.setFont(pageTf, Font.ARIAL, true);
			item0.visible = false;
			itemList = [];
			var item:GuildItem;
			var pos:Point = new Point(item0.x, item0.y);
			for (var i:int = 0; i < pageSize; i++) 
			{
				item = new GuildItem();
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
		}
		
		public function setActive(item:GuildItem):void
		{
			if (activeItem) activeItem.deactive();
			activeItem = item;
			activeItem.active();
			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GU_GET_GUILD_INFO, item.info.nGuildID));
			// unlock guild list until get guild detail
			lock();
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
			if (!(e.currentTarget as GuildItem).info) return;
			setActive(e.currentTarget as GuildItem);
		}
		
		private function backBtnHdl(e:MouseEvent):void 
		{
			backBtn.mouseEnabled = false;
			nextBtn.mouseEnabled = true;
			if (pageIndex == 0) return;
			pageIndex--;
			pageTf.text = (pageIndex + 1).toString();
			getGuildList();
		}
		
		private function nextBtnHdl(e:MouseEvent):void 
		{
			nextBtn.mouseEnabled = false;
			backBtn.mouseEnabled = true;
			pageIndex++;
			pageTf.text = (pageIndex + 1).toString();
			getGuildList();
		}
		
		public function getGuildList():void
		{
			Game.network.lobby.sendPacket(new RequestGetListFromTo(LobbyRequestType.GU_GET_LEADER_BOARD, pageIndex * pageSize, (pageIndex + 1) * pageSize));
		}
		
		public function clearList():void
		{
			var item:GuildItem;
			for (var i:int = 0; i < pageSize; i++) 
			{
				item = itemList[i];
				item.reset();
			}
		}
		
		public function updateGuildList(infoList:Array):void
		{
			var item:GuildItem;
			var info:GuLadderInfo;
			if (infoList.length == 0) 
			{
				// incase page reach end position, server return empty list => reserve page index to previous value
				pageIndex--;
				if (pageIndex < 0) pageIndex = 0;
				pageTf.text = (pageIndex + 1).toString();
				return;
			}
			for (var i:int = 0; i < pageSize; i++) 
			{
				item = itemList[i];
				if (i < infoList.length)
				{
					info = infoList[i];
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