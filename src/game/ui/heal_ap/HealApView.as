package game.ui.heal_ap 
{
	import core.display.animation.Animator;
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.FontUtil;
	import core.util.TextFieldUtil;
	import core.util.Utility;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import game.data.xml.DataType;
	import game.data.xml.VIPConfigXML;
	import game.enum.Font;
	import game.enum.GameConfigID;
	import game.Game;
	import game.ui.heal_ap.gui.HealApProgressBar;
	import game.utility.UtilityUI;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class HealApView extends ViewBase
	{
		private static const BUY_INFO_STR1 :String = "Hôm nay bạn đã mua ";
		private static const BUY_INFO_STR2 :String = " thể lực";
		
		private static const VIP_INFO_STR1 :String = "VIP ";
		private static const VIP_INFO_STR2 :String = " bạn sẽ mua được ";
		private static const VIP_INFO_STR3 :String = " thể lực mỗi ngày";
		
		
		public var healBtn:SimpleButton;
		public var healApProgressBar:HealApProgressBar;
		public var xuTf:TextField;
		public var buyApInfoTf:TextField;
		public var vipInfoTf:TextField;
		
		private var closeBtn:SimpleButton;
		private var apDefault :int;
		private var xuBuy:int;
		private var healApQuantityList:Array;
		private var healApDiscountList:Array;
		
		public function HealApView() 
		{
			FontUtil.setFont(xuTf, Font.ARIAL, false);
			FontUtil.setFont(buyApInfoTf, Font.ARIAL, false);
			FontUtil.setFont(vipInfoTf, Font.ARIAL, false);
			
			closeBtn = UtilityUI.getComponent(UtilityUI.CLOSE_BTN) as SimpleButton;
			if (closeBtn != null) {
				closeBtn.x = 710;
				closeBtn.y = 145;
				addChild(closeBtn);
				closeBtn.addEventListener(MouseEvent.CLICK, closeHandler);
			}
			healBtn.addEventListener(MouseEvent.CLICK, onHealAp);
			this.addEventListener(HealApEvent.HEAL_AMOUNT, onHealAmountChange);
			
			apDefault = Game.database.gamedata.getConfigData(GameConfigID.AP_LIST_BY_VIP) as int;
			healApQuantityList = Game.database.gamedata.getConfigData(GameConfigID.HEAL_AP_QUANTITY_LIST) as Array;
			healApDiscountList = Game.database.gamedata.getConfigData(GameConfigID.HEAL_AP_DISCOUNT_LIST) as Array;
			
		}
		
		private function onHealAmountChange(e:EventEx):void 
		{
			var apBuy : int = e.data as int;
			
			xuBuy = calculateXuPrice(apBuy);
			xuTf.text = Utility.math.formatInteger(xuBuy);
			
		}
		
		private function calculateXuPrice(apAmount : int) : int {
			
			for (var i:int = healApQuantityList.length - 1; i >= 0; i--) 
			{
				if (apAmount >= healApQuantityList[i]) {
					
					return Math.floor(apAmount - healApDiscountList[i] * 0.01 * apAmount - (healApDiscountList[i] > 0 ? 0.5 : 0));
				}
			}
			
			return apAmount;
		}
		
		private function onHealAp(e:MouseEvent):void 
		{
			
			if (Game.database.userdata.xu >= xuBuy) {
				if (healApProgressBar.getApBuy() > 0)
					this.dispatchEvent(new EventEx(HealApEvent.HEAL_AP, healApProgressBar.getApBuy(), true));
			}else {
				Manager.display.showMessageID(46);
			}
		}
		
		private function closeHandler(e:MouseEvent):void 
		{
			this.dispatchEvent(new EventEx(HealApEvent.CLOSE));
		}
		
		public function update() : void {
			
			var vip : int = Game.database.userdata.vip;
			var apVip:int = 0;
			var vipXML:VIPConfigXML = Game.database.gamedata.getData(DataType.VIP, vip) as VIPConfigXML;
			if (vipXML)
			{
				apVip = vipXML.additionAPFillingInDay;
			}
			
			var totalAp : int = apDefault + apVip;
			var healedStr : String = Game.database.userdata.healedAP + "/" + totalAp;
			buyApInfoTf.text = BUY_INFO_STR1 + healedStr + BUY_INFO_STR2;
			TextFieldUtil.setColor(buyApInfoTf, BUY_INFO_STR1.length, BUY_INFO_STR1.length + healedStr.length, 0x00CCFF);
			
			var nextVipXML:VIPConfigXML = Game.database.gamedata.getData(DataType.VIP, vip + 1) as VIPConfigXML;
			if (nextVipXML)
			{
				var apNextVip:int = nextVipXML.additionAPFillingInDay;
				var totalApNextVip : int = apDefault + apNextVip;
				vipInfoTf.text = VIP_INFO_STR1 + (vip + 1) + VIP_INFO_STR2 + totalApNextVip + VIP_INFO_STR3;
				
				var vipBegin : int = VIP_INFO_STR1.length;
				var vipEnd : int = (VIP_INFO_STR1+ (vip + 1)).length;
				TextFieldUtil.setColor(vipInfoTf, vipBegin, vipEnd, 0xFF00FF);
				
				var healBegin : int =(VIP_INFO_STR1 + (vip + 1) + VIP_INFO_STR2).length;
				var healEnd : int = (VIP_INFO_STR1 + (vip + 1) + VIP_INFO_STR2 + totalApNextVip).length;
				TextFieldUtil.setColor(vipInfoTf, healBegin, healEnd, 0x00FF00);
			
				vipInfoTf.visible = true;
			}else {
				vipInfoTf.visible = false;
			}
			
			healApProgressBar.setInfo(Game.database.userdata.actionPoint, Game.database.userdata.maxActionPoint, Math.max(0, totalAp - Game.database.userdata.healedAP));
			
		}
	}

}