package game.ui.consume_event.gui
{
	import com.greensock.TweenMax;
	import core.event.EventEx;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.enum.Font;
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class ConsumeEventItem extends MovieClip
	{
		public static const RECEIVE_BTN_CLICK:String = "receive_btn_click";
		
		public static const STATUS_CANT_RECEIVE:int = 0;
		public static const STATUS_CAN_RECEIVE:int = 1;
		public static const STATUS_ALREADY_RECEIVE:int = 2;
		
		public var dateTf:TextField;
		public var rewardIcon:MovieClip;
		public var btnReceive:ConsumeEventReceiveBtn;
		
		public var paybackGold:int = 0;
		public var paybackXu:int = 0;
		public var consumeXu:int = 0;
		public var consumeGold:int = 0;
		private var index:int = -1;
		private var status:int = STATUS_CANT_RECEIVE;
		
		public function ConsumeEventItem()
		{
			FontUtil.setFont(dateTf, Font.ARIAL, true);
			btnReceive.addEventListener(MouseEvent.CLICK, onReceiveBtnClick);
			
			rewardIcon.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverHdl);
			rewardIcon.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHdl);
		}
		
		private function onMouseOutHdl(e:Event):void
		{
			this.dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
		}
		
		private function onMouseOverHdl(e:Event):void
		{
			var obj:Object = {};
			obj.payGold = paybackGold;
			obj.payXu = paybackXu;
			obj.consumeGold = consumeGold;
			obj.consumeXu = consumeXu;
			this.dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type: TooltipID.CONSUME_EVENT, value: obj}, true));
		}
		
		private function onReceiveBtnClick(e:Event):void
		{
			if (this.index > -1 && status == STATUS_CAN_RECEIVE)
			{
				Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.RECEIVE_CONSUME_EVENT_REWARD, index));
			}
		}
		
		public function init(index:int, obj:Object, strBeign:String):void
		{
			this.index = index;
			paybackGold = obj.totalGoldPayback;
			paybackXu = obj.totalXuPayback;
			consumeXu = obj.totalXuConsume;
			consumeGold = obj.totalGoldConsume;
			status = obj.status;
			
			var tempDate:Date = new Date(Date.parse(strBeign.split("-").join("/")));
			tempDate.date = tempDate.date + index;
			
			var nDate:int = tempDate.getDate();
			var nMonth:int = tempDate.getMonth() + 1;
			
			dateTf.text = "" + nDate.toString() + "/" + nMonth.toString();
			if (obj.status == STATUS_ALREADY_RECEIVE)
			{
				btnReceive.setStatus(ConsumeEventReceiveBtn.RECEIVED);
			}
			else if (obj.status == STATUS_CAN_RECEIVE)
			{
				btnReceive.setStatus(ConsumeEventReceiveBtn.RECEIVE);
			}
			else if (obj.status == STATUS_CANT_RECEIVE)
			{
				btnReceive.setStatus(ConsumeEventReceiveBtn.LOCK);
				TweenMax.to(this, 0, {alpha: 1, colorMatrixFilter: {saturation: 0}});
			}
		}
	
	}

}