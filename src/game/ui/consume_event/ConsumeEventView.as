package game.ui.consume_event
{
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.util.FontUtil;
	import core.util.Utility;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.data.xml.ConsumeEventXML;
	import game.data.xml.DataType;
	import game.data.xml.ServerEventXML;
	import game.enum.Font;
	import game.Game;
	import game.net.lobby.response.ResponseGetConsumeEventInfo;
	import game.ui.consume_event.gui.ConsumeEventContainer;
	import game.utility.UtilityUI;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class ConsumeEventView extends ViewBase
	{
		private var closeBtn:SimpleButton;
		
		public var desciptionTf:TextField;
		public var receiveRewardTimeTf:TextField;
		public var dateTf:TextField;
		public var dateRemainTf:TextField;
		public var container:ConsumeEventContainer;
		
		public function ConsumeEventView()
		{
			closeBtn = UtilityUI.getComponent(UtilityUI.CLOSE_BTN) as SimpleButton;
			
			if (closeBtn != null)
			{
				closeBtn.x = this.width - closeBtn.width + 280;
				closeBtn.y = 110;
				addChild(closeBtn);
				closeBtn.addEventListener(MouseEvent.CLICK, closeHandler);
			}
			
			FontUtil.setFont(desciptionTf, Font.ARIAL);
			FontUtil.setFont(dateTf, Font.ARIAL);
			FontUtil.setFont(receiveRewardTimeTf, Font.ARIAL);
			FontUtil.setFont(dateRemainTf, Font.ARIAL);
			
			desciptionTf.text = "";
			dateTf.text = "";
			dateRemainTf.text = "";
			receiveRewardTimeTf.text = "";
		}
		
		private function closeHandler(e:Event):void
		{
			this.dispatchEvent(new EventEx(ConsumeEventModule.CLOSE_CONSUME_EVENT_VIEW));
		}
		
		public function update(responseGetConsumeEventInfo:ResponseGetConsumeEventInfo):void
		{
			if (responseGetConsumeEventInfo)
			{
				var consumeEventXML:ConsumeEventXML = Game.database.gamedata.getData(DataType.CONSUME_EVENT, responseGetConsumeEventInfo.eventID) as ConsumeEventXML;
				if (consumeEventXML)
				{
					var nServerID:int = parseInt(Game.database.flashVar.server);
					
					for each (var obj:ServerEventXML in consumeEventXML.arrServerEvent)
					{
						if (obj && obj.nServerID == nServerID && obj.nEnable)
						{
							dateTf.text = "Từ " + obj.strBegin.substr(0, 10) + " - " + obj.strEnd.substr(0, 10);
							dateRemainTf.text = "Còn " + responseGetConsumeEventInfo.remainDay + " ngày";
							desciptionTf.text = "Tiêu vàng và bạc trong thời gian sự kiện, kết thúc sự kiện nhận lại " + consumeEventXML.nPaybackPercent + "% vàng và bạc đã tiêu";
							container.update(obj.strBegin, responseGetConsumeEventInfo);
							calcReceiveRewardTime(obj.strEnd, obj.strEndReceive);
							break;
						}
					}
				}
			}
		}
		
		private function calcReceiveRewardTime(strEnd:String, strEndReceive:String):void 
		{
			var end:Number = Utility.parseToDate(strEnd).getTime();
			var endReceive:Number = Utility.parseToDate(strEndReceive).getTime();
			var timeNow:Number = Game.database.userdata.timeNow;
			
			var strTxt:String;
			
			receiveRewardTimeTf.visible = timeNow > end;
			if (receiveRewardTimeTf.visible)
			{
				var space:Number = endReceive - timeNow;
				if (space > 86400000)
				{
					strTxt = int(space/86400000) + " ngày";
				} else
				{
					strTxt = Utility.math.formatTime("H-M-S", space);
				}
				receiveRewardTimeTf.text = 'Thời gian nhận thưởng còn "'+strTxt+'", hết thời gian này giao diện sự kiện sẽ mất';
			}
		}
	}
}