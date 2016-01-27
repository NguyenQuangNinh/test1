package game.ui.charge_event
{
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.data.xml.ChargeEventXML;
	import game.data.xml.ConsumeEventXML;
	import game.data.xml.DataType;
	import game.data.xml.PaymentEventRewardXML;
	import game.data.xml.ServerEventXML;
	import game.enum.Font;
	import game.Game;
	import game.net.lobby.response.ResponseGetConsumeEventInfo;
	import game.net.lobby.response.ResponseGetPaymentEventInfo;
	import game.ui.charge_event.gui.ChargeEventItem;
	import game.ui.charge_event.gui.ChargeEventPos;
	import game.ui.consume_event.gui.ConsumeEventContainer;
	import game.utility.UtilityUI;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class ChargeEventView extends ViewBase
	{
		private var closeBtn:SimpleButton;
		
		public var desciptionTf:TextField;
		public var dateTf:TextField;
		public var dateRemainTf:TextField;
		
		public var posLeft:MovieClip;
		public var posRight:MovieClip;
		public var progressBar:MovieClip;
		
		public var posMovie:ChargeEventPos;
		
		private var arrChargeEventItem:Array = [];
		
		public function ChargeEventView()
		{
			closeBtn = UtilityUI.getComponent(UtilityUI.CLOSE_BTN) as SimpleButton;
			
			if (closeBtn != null)
			{
				closeBtn.x = Game.WIDTH - 2 * closeBtn.width - 120;
				closeBtn.y = 2 * closeBtn.height + 50;
				addChild(closeBtn);
				closeBtn.addEventListener(MouseEvent.CLICK, closeHandler);
			}
			
			FontUtil.setFont(desciptionTf, Font.ARIAL);
			FontUtil.setFont(dateTf, Font.ARIAL);
			FontUtil.setFont(dateRemainTf, Font.ARIAL);
			
			desciptionTf.text = "";
			dateTf.text = "";
			desciptionTf.text = "Nạp xu tích lũy nhận phần thưởng khủng";
		}
		
		private function closeHandler(e:Event):void
		{
			this.dispatchEvent(new EventEx(ChargeEventModule.CLOSE_CHARGE_EVENT_VIEW));
		}
		
		public function update(responseGetPaymentEventInfo:ResponseGetPaymentEventInfo):void
		{
			if (responseGetPaymentEventInfo == null)
				return;
				
			//reset
			this.reset();
			//update
			var chargeEventXML:ChargeEventXML = Game.database.gamedata.getData(DataType.CHARGE_EVENT, responseGetPaymentEventInfo.eventID) as ChargeEventXML;
			if (chargeEventXML)
			{
				var nServerID:int = parseInt(Game.database.flashVar.server);
				for each (var obj:ServerEventXML in chargeEventXML.arrServerEvent)
				{
					if (obj && obj.nServerID == nServerID && obj.nEnable)
					{
						dateTf.text = "Từ " + obj.strBegin.substr(0, 10) + " - " + obj.strEnd.substr(0, 10);
						dateRemainTf.text = "Còn " + responseGetPaymentEventInfo.dayRemain + " ngày";
						
						posMovie.init(calculaPosX(responseGetPaymentEventInfo.currentXuCharged, chargeEventXML.nMaxRequirementXu), responseGetPaymentEventInfo.currentXuCharged);
						progressBar.width = (posMovie.x - posLeft.x) + posMovie.width / 2 - 5;
						
						for (var i:int = 0; i < responseGetPaymentEventInfo.paymentRewardSize && responseGetPaymentEventInfo.arrRewardStatus.length && chargeEventXML.arrPaymentReward.length; i++)
						{
							var chargeEventItem:ChargeEventItem = new ChargeEventItem();
							var paymentEventXML:PaymentEventRewardXML = chargeEventXML.arrPaymentReward[i];
							chargeEventItem.y = 320;
							chargeEventItem.x = calculaPosX(paymentEventXML.nRequirementXu, chargeEventXML.nMaxRequirementXu);
							chargeEventItem.init(i, paymentEventXML, responseGetPaymentEventInfo.arrRewardStatus[i]);
							arrChargeEventItem.push(chargeEventItem);
							this.addChild(chargeEventItem);
						}
						break;
					}
				}
			}
		}
		
		private function calculaPosX(quantity:int, max:int):int
		{
			return posLeft.x + (quantity * 1.0 / max) * (posRight.x - posLeft.x);
		}
		
		private function reset():void
		{
			for each (var obj:ChargeEventItem in arrChargeEventItem)
			{
				obj.reset();
				this.removeChild(obj);
			}
			arrChargeEventItem = [];
		}
	}
}