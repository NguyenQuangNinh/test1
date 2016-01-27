package game.ui.activity_point {
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import game.enum.GameConfigID;
	import game.Game;
	import game.enum.Font;
	/**
	 * ...
	 * @author vu anh
	 */
	public class ActivityList extends MovieClip
	{
		
		public var pageTf:TextField;
		public var backBtn:SimpleButton;
		public var nextBtn:SimpleButton;
		
		private var pageIndex:int;
		private var pageSize:int = 8;
		
		private var itemList:Array;
		public var infoList:Array;
		
		public var item0:MovieClip;
		
		public var itemTextArr:Array;
		
		public function ActivityList() 
		{
			FontUtil.setFont(pageTf, Font.ARIAL, true);
			itemTextArr = ["Hoàn thành 1 nhiệm vụ Dã Tẩu",
						   "Hoàn thành 1 lần Đưa Thư",
						   "Hoàn thành 1 lần chiến dịch",
						   "Tham gia Hoa Sơn 1 lần",
						   "Tham gia Tam Hùng Kỳ Hiệp 1 lần",
						   "Tham gia Võ Lâm Minh Chủ 1 lần",
						   "Hoàn thành 1 lần Anh Hùng Ải",
						   "Tham gia Mật Đạo 1 lần",
						   "Tham gia Tháp Cao Thủ",
						   "Luyện Kim 1 lần",
						   "Bói Mệnh Khí 1 lần",
						   "Truyền công 1 lần",
						   "Thăng cấp kỹ năng 1 lần"];
						   
			item0.visible = false;
			itemList = [];
			var item:ActivityItem;
			var pos:Point = new Point(item0.x, item0.y);
			for (var i:int = 0; i < pageSize; i++) 
			{
				item = new ActivityItem();
				item.x = pos.x;
				item.y = pos.y;
				pos.y += 29;
				item.reset();
				itemList.push(item);
				addChild(item);
			}
			pageIndex = 0;
			
			infoList = [];
			var itemInfo:ActivityItemInfo;
			for (var j:int = 0; j < itemTextArr.length; j++) 
			{
				itemInfo = new ActivityItemInfo();
				itemInfo.taskName = itemTextArr[j];
				itemInfo.receivePoint = Game.database.gamedata.getConfigData(GameConfigID.GUILD_ACTIVITY_DAILY_QUEST_ARR + j)[0];
				itemInfo.maxTime = Game.database.gamedata.getConfigData(GameConfigID.GUILD_ACTIVITY_DAILY_QUEST_ARR + j)[1];
				infoList.push(itemInfo);
			}
			pageTf.text = (pageIndex + 1).toString() + " / " + int(infoList.length / pageSize + 1);
			if (pageIndex == 0) backBtn.mouseEnabled = false; else backBtn.mouseEnabled = true;
			if (pageIndex == infoList.length / pageSize) nextBtn.mouseEnabled = false; else nextBtn.mouseEnabled = true;
			
			nextBtn.addEventListener(MouseEvent.CLICK, nextBtnHdl);
			backBtn.addEventListener(MouseEvent.CLICK, backBtnHdl);
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
		
		private function backBtnHdl(e:MouseEvent):void 
		{
			if (pageIndex == 0) return;
			pageIndex--;
			pageTf.text = (pageIndex + 1).toString() + " / " + int(infoList.length / pageSize + 1);
			if (pageIndex == 0) backBtn.mouseEnabled = false; else backBtn.mouseEnabled = true;
			if (pageIndex == int(infoList.length / pageSize)) nextBtn.mouseEnabled = false; else nextBtn.mouseEnabled = true;
			updateActionList();
		}
		
		private function nextBtnHdl(e:MouseEvent):void 
		{
			pageIndex++;
			pageTf.text = (pageIndex + 1).toString() + " / " + int(infoList.length / pageSize + 1);
			if (pageIndex == 0) backBtn.mouseEnabled = false; else backBtn.mouseEnabled = true;
			if (pageIndex == int(infoList.length / pageSize)) nextBtn.mouseEnabled = false; else nextBtn.mouseEnabled = true;
			updateActionList();
		}
		
		public function clearList():void
		{
			var item:ActivityItem;
			for (var i:int = 0; i < pageSize; i++) 
			{
				item = itemList[i];
				item.reset();
			}
		}
		
		public function updateActionList():void
		{
			clearList();
			var item:ActivityItem;
			var info:ActivityItemInfo;
			for (var i:int = pageIndex * pageSize; i < (pageIndex + 1) * pageSize; i++) 
			{
				item = itemList[i % pageSize];
				if (i < infoList.length)
				{
					info = infoList[i];
					item.update(info);
				}
				else break;
			}
		}
		
	}

}