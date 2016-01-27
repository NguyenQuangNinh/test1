package game.ui.charge_event.gui
{
	import core.Manager;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	import game.data.model.item.ItemFactory;
	import game.data.xml.DataType;
	import game.data.xml.PaymentEventRewardXML;
	import game.data.xml.RewardXML;
	import game.enum.Font;
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.ui.components.ItemSlot;
	import game.ui.tooltip.TooltipID;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class ChargeEventItem extends MovieClip
	{
		
		public static var STATUS_CANT_RECEIVE:int = 0;
		public static var STATUS_CAN_RECEIVE:int = 1;
		public static var STATUS_ALREADY_RECEIVE:int = 2;
		
		public var receiveBtn:ChargeEventReceiveBtn;
		public var quantityTf:TextField;
		public var status:int = STATUS_CANT_RECEIVE;
		
		private var rewardIndex:int = -1;
		private var arrItemSlot:Array = [];
		
		public function ChargeEventItem()
		{
			FontUtil.setFont(quantityTf, Font.ARIAL);
			receiveBtn.addEventListener(MouseEvent.CLICK, onReceiveClick);
		}
		
		private function onReceiveClick(e:Event):void
		{
			if (rewardIndex > -1 && status == STATUS_CAN_RECEIVE)
			{
				Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.RECEIVE_PAYMENT_EVENT_REWARD, rewardIndex));
			}
		}
		
		public function init(index:int, paymentEventXML:PaymentEventRewardXML, status:int):void
		{
			if (paymentEventXML == null)
				return;
			this.status = status;
			rewardIndex = index;
			quantityTf.text = paymentEventXML.nRequirementXu.toString();
			
			for (var i:int = 0; i < paymentEventXML.arrRewardID.length; i++)
			{
				var nRewardID:int = paymentEventXML.arrRewardID[i];
				if (nRewardID > 0)
				{
					var rewardXml:RewardXML = Game.database.gamedata.getData(DataType.REWARD, nRewardID) as RewardXML;
					if (rewardXml != null)
					{
						var itemSlot:ItemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
						itemSlot.setConfigInfo(ItemFactory.buildItemConfig(rewardXml.type, rewardXml.itemID), TooltipID.ITEM_COMMON);
						itemSlot.setScaleItemSlot(0.5);
						itemSlot.setQuantity(rewardXml.quantity);
						itemSlot.x = -25;
						itemSlot.y = 22 + i * 40;
						this.addChild(itemSlot);
						
						arrItemSlot.push(itemSlot);
					}
				}
			}
			
			if (status == STATUS_CANT_RECEIVE)
			{
				receiveBtn.setStatus(ChargeEventReceiveBtn.LOCK);
			}
			else if (status == STATUS_CAN_RECEIVE)
			{
				receiveBtn.setStatus(ChargeEventReceiveBtn.RECEIVE);
			}
			else if (status == STATUS_ALREADY_RECEIVE)
			{
				receiveBtn.setStatus(ChargeEventReceiveBtn.RECEIVED);
				
			}
		}
		
		public function reset():void
		{
			rewardIndex = -1;
			for each (var obj:ItemSlot in arrItemSlot)
			{
				if (obj)
				{
					obj.reset();
					Manager.pool.push(obj, ItemSlot);
				}
			}
			arrItemSlot = [];
		}
	}

}