package game.ui.global_boss_top 
{
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.net.lobby.response.ResponseGlobalBossTopDmg;
	import game.enum.Font;
	import game.ui.global_boss.GlobalBossEvent;
	import game.utility.UtilityUI;
	/**
	 * ...
	 * @author vu anh
	 */
	public class GlobalBossTopView extends ViewBase
	{
		public var myCurrentDmgTf:TextField;
		public var movTopListContainer:MovieClip;
		public var bg:MovieClip;
		private var topList			:Array;
		public var closeBtn:SimpleButton;
		
		public function GlobalBossTopView() 
		{
			FontUtil.setFont(myCurrentDmgTf, Font.ARIAL);
			topList = [];
			var item:TopListItem;
			for (var i:int = 0; i < 8; i++) {
				item = new TopListItem();
				topList.push(item);
				item.setXY(0, i * 35);
				movTopListContainer.addChild(item);
			}
			
			closeBtn.addEventListener(MouseEvent.CLICK, closeHandler);
		}
		
		private function closeHandler(e:MouseEvent):void 
		{
			dispatchEvent(new EventEx(GlobalBossTopEvent.EVENT, { type:GlobalBossTopEvent.CLOSE_BTN_CLICK}, true));
		}
		
		public function updateInfo(packet:ResponseGlobalBossTopDmg):void 
		{
			var damage:int = packet.currentDmg;
			if (damage < 0) damage = 0;
			myCurrentDmgTf.text = "Thứ hạng hiện tại: " + (packet.currentRank + 1).toString() + 
			". Sát thương hiện tại: " + damage.toString();
			
			var arr:Array = packet.players;
			if (arr) 
			{
				var length:int = Math.min(arr.length, topList.length);
				var item:TopListItem;
				for (var i:int = 0; i < length; i++) {
					item = topList[i];
					item.setNum(i + 1);
					item.setName(arr[i].name);
					item.setPoint(arr[i].currentDmg);
					item.id = arr[i].playerID;
				}
				
				for (i = length; i < topList.length; i++) {
					item = topList[i];
					item.reset();
				}
			}
		}
		
	}

}