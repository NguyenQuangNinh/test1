package game.ui.train.home 
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
	import game.data.vo.lobby.LobbyInfo;
	import game.enum.GameMode;
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.enum.Font;
	import game.net.lobby.request.RequestRoomListPvP;
	import game.ui.train.data.RoomInfo;
	/**
	 * ...
	 * @author vu anh
	 */
	public class RoomList extends MovieClip
	{
		public var pageTf:TextField;
		public var backBtn:SimpleButton;
		public var nextBtn:SimpleButton;
		
		private var pageIndex:int;
		private var pageSize:int = 6;
		
		private var itemList:Array;
		
		public var item0:MovieClip;
		public var activeItem:RoomItem;
		
		public function RoomList() 
		{
			FontUtil.setFont(pageTf, Font.ARIAL, true);
			item0.visible = false;
			itemList = [];
			var item:RoomItem;
			var pos:Point = new Point(item0.x, item0.y);
			
			for (var i:int = 0; i < pageSize; i++) 
			{
				item = new RoomItem();
				item.x = pos.x;
				item.y = pos.y;
				pos.y += 29;
				item.reset();
				itemList.push(item);
				addChild(item);
				
				//item.addEventListener(MouseEvent.CLICK, itemHdl);
			}
			
			pageIndex = 0;
			nextBtn.addEventListener(MouseEvent.CLICK, nextBtnHdl);
			backBtn.addEventListener(MouseEvent.CLICK, backBtnHdl);
			nextBtn.mouseEnabled = false;
			backBtn.mouseEnabled = false;
		}
		
		public function setActive(item:RoomItem):void
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
			if (!(e.currentTarget as RoomItem).info) return;
			setActive(e.currentTarget as RoomItem);
		}
		
		private function backBtnHdl(e:MouseEvent):void 
		{
			backBtn.mouseEnabled = false;
			nextBtn.mouseEnabled = true;
			if (pageIndex == 0) return;
			pageIndex--;
			pageTf.text = (pageIndex + 1).toString();
			getRoomList();
		}
		
		private function nextBtnHdl(e:MouseEvent):void 
		{
			nextBtn.mouseEnabled = false;
			backBtn.mouseEnabled = true;
			pageIndex++;
			pageTf.text = (pageIndex + 1).toString();
			getRoomList();
		}
		
		public function getRoomList():void
		{
			Game.network.lobby.sendPacket(new RequestRoomListPvP(pageIndex * pageSize, (pageIndex + 1) * pageSize, GameMode.PVP_TRAINING.ID));
		}
		
		public function clearList():void
		{
			var item:RoomItem;
			for (var i:int = 0; i < pageSize; i++) 
			{
				item = itemList[i];
				item.reset();
			}
		}
		
		public function updateRoomList(infoList:Array):void
		{
			var infoArr:Array = new Array();
			for (var i:int = 0; i < infoList.length; i++) 
			{
				var rInfo:LobbyInfo = infoList[i];
				
				var roomInfo:RoomInfo = new RoomInfo();
				roomInfo.index = i;
				roomInfo.strRoleName = rInfo.strNameHostRoom;
				roomInfo.nLevel = rInfo.nLevelHostRoom;
				roomInfo.roomId = rInfo.id;
				roomInfo.playerNum = rInfo.count;
				infoArr.push(roomInfo);
			}
			
			if (infoList.length < pageSize) nextBtn.mouseEnabled = false;
			else nextBtn.mouseEnabled = true;
			if (infoList.length == 0) 
			{
				// incase page reach end position, server return empty list => reserve page index to previous value
				pageIndex--;
				if (pageIndex < 0) 
				{
					pageIndex = 0;
					backBtn.mouseEnabled = false;
				} else backBtn.mouseEnabled = true;
				pageTf.text = (pageIndex + 1).toString();
				return;
			}

			var item:RoomItem;
			var info:RoomInfo;
			
			for (i = 0; i < pageSize; i++) 
			{
				item = itemList[i];
				if (i < infoArr.length)
				{
					info = infoArr[i];
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