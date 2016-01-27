package game.ui.guild.popups.guild_log 
{
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import game.enum.Font;
	import game.net.lobby.response.data.GuLogItemInfo;
	import game.net.lobby.response.ResponseGuActionLog;
	/**
	 * ...
	 * @author vu anh
	 */
	public class LogList extends MovieClip
	{
		
		public var pageTf:TextField;
		public var backBtn:SimpleButton;
		public var nextBtn:SimpleButton;
		
		private var pageIndex:int;
		private var pageSize:int = 7;
		
		private var itemList:Array;
		public var infoList:Array;
		
		public var baseItem:MovieClip;
		
		public function LogList() 
		{
			FontUtil.setFont(pageTf, Font.ARIAL, true);
						   
			baseItem.visible = false;
			itemList = [];
			var item:LogItem;
			var pos:Point = new Point(baseItem.x, baseItem.y);
			for (var i:int = 0; i < pageSize; i++) 
			{
				item = new LogItem();
				item.x = pos.x;
				item.y = pos.y;
				pos.y += 31;
				item.reset();
				itemList.push(item);
				addChild(item);
			}
			
			pageIndex = 0;
			lock();
			nextBtn.addEventListener(MouseEvent.CLICK, nextBtnHdl);
			backBtn.addEventListener(MouseEvent.CLICK, backBtnHdl);
		}
		
		public function lock():void
		{
			nextBtn.mouseEnabled = false;
			backBtn.mouseEnabled = false;
		}
		
		public function unlock():void
		{
			nextBtn.mouseEnabled = true;
			backBtn.mouseEnabled = true;
		}
		
		private function backBtnHdl(e:MouseEvent):void 
		{
			if (pageIndex == 0) return;
			pageIndex--;
			pageTf.text = (pageIndex + 1).toString() + " / " + int(infoList.length / pageSize + 1);
			if (pageIndex == 0) backBtn.mouseEnabled = false; else backBtn.mouseEnabled = true;
			if (pageIndex == int(infoList.length / pageSize)) nextBtn.mouseEnabled = false; else nextBtn.mouseEnabled = true;
			updateLogListView();
		}
		
		private function nextBtnHdl(e:MouseEvent):void 
		{
			pageIndex++;
			pageTf.text = (pageIndex + 1).toString() + " / " + int(infoList.length / pageSize + 1);
			if (pageIndex == 0) backBtn.mouseEnabled = false; else backBtn.mouseEnabled = true;
			if (pageIndex == int(infoList.length / pageSize)) nextBtn.mouseEnabled = false; else nextBtn.mouseEnabled = true;
			updateLogListView();
		}
		
		public function clearList():void
		{
			var item:LogItem;
			for (var i:int = 0; i < pageSize; i++) 
			{
				item = itemList[i];
				item.reset();
			}
		}
		
		public function updateLogList(arr:Array):void
		{
			this.infoList = arr;
			pageTf.text = (pageIndex + 1).toString() + " / " + int(infoList.length / pageSize + 1);
			if (infoList.length > 0) unlock();
			if (pageIndex == 0) backBtn.mouseEnabled = false; else backBtn.mouseEnabled = true;
			if (pageIndex == int (infoList.length / pageSize)) nextBtn.mouseEnabled = false; else nextBtn.mouseEnabled = true;
			updateLogListView();
		}
		
		public function updateLogListView():void
		{
			clearList();
			var item:LogItem;
			var info:GuLogItemInfo;
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