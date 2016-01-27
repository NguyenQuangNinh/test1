package game.ui.soul_center.gui 
{
	import core.util.FontUtil;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import game.data.xml.DataType;
	import game.data.xml.VIPConfigXML;
	import game.enum.Font;
	import game.Game;
	import game.net.lobby.response.ResponseSoulInfo;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class DivineInfoPanel extends Sprite
	{
		public var normalAmountTf : TextField;
		public var goldAmountTf : TextField;
		public var vipAmountTf : TextField;
		
		
		public var freeTitleTf : TextField;
		public var goldTitleTf : TextField;
		public var vipTitleTf : TextField;
		public var nextVipAddTf : TextField;
		private var responseSoulInfo : ResponseSoulInfo;
		
		public function DivineInfoPanel() 
		{
			FontUtil.setFont(normalAmountTf, Font.ARIAL, true);
			FontUtil.setFont(goldAmountTf, Font.ARIAL, true);
			FontUtil.setFont(vipAmountTf, Font.ARIAL, true);
			FontUtil.setFont(freeTitleTf, Font.ARIAL, true);
			FontUtil.setFont(goldTitleTf, Font.ARIAL, true);
			FontUtil.setFont(vipTitleTf, Font.ARIAL, true);
			FontUtil.setFont(nextVipAddTf, Font.ARIAL, true);
		}
		
		public function setData(responseSoulInfo : ResponseSoulInfo):void 
		{
			this.responseSoulInfo = responseSoulInfo;
			
			if (responseSoulInfo == null) return ;
			
			if (responseSoulInfo.freeDivineTotal == -1) {
				normalAmountTf.visible = false;
				freeTitleTf.visible = false;
			}else {
				normalAmountTf.text = responseSoulInfo.freeDivineRemain + "/" + responseSoulInfo.freeDivineTotal;
				normalAmountTf.visible = true;
				freeTitleTf.visible = true;
			}
			
			if (responseSoulInfo.goldDivineTotal == -1) {
				goldAmountTf.visible = false;
				goldTitleTf.visible = false;
			}else {
				goldAmountTf.text = responseSoulInfo.goldDivineRemain + "/" + responseSoulInfo.goldDivineTotal;
				goldAmountTf.visible = true;
				goldTitleTf.visible = true;
			}
			
			if (responseSoulInfo.vipDivineTotal == -1) {
				vipAmountTf.visible = false;
				vipTitleTf.visible = false;
			}else {
				vipAmountTf.text = responseSoulInfo.vipDivineRemain + "/" + responseSoulInfo.vipDivineTotal;
				vipAmountTf.visible = true;
				vipTitleTf.visible = true;
			}
			
			//update vip info to display
			var currentVip:int = Game.database.userdata.vip;
			var currentVipInfo:VIPConfigXML = Game.database.gamedata.getData(DataType.VIP, currentVip) as VIPConfigXML;
			var numCraftAdd:int = currentVipInfo ? currentVipInfo.soulCraftAddCount : 0;
			
			var vipInfoDic:Dictionary = Game.database.gamedata.getTable(DataType.VIP);
			var numCraftAccumulate:int = 0;
			for each(var vipXML:VIPConfigXML in vipInfoDic) {				
				numCraftAccumulate = vipXML.soulCraftAddCount;
				if (vipXML.ID > currentVip && numCraftAccumulate > numCraftAdd)
					break;				
			}
			
			nextVipAddTf.text = "Vip " + vipXML.ID.toString() + " nhận thêm " + (vipXML.soulCraftAddCount - numCraftAdd).toString() + " lần";
			//moreTf.text = (vipXML.transporterQuestAddCount - numCraftAdd).toString();
		}
		
		public function onAutoCraftStep() : void {
			if (this.responseSoulInfo != null) {
				if (responseSoulInfo.freeDivineTotal == -1) return;
				else if (responseSoulInfo.freeDivineRemain > 0) {
					responseSoulInfo.freeDivineRemain --;
					setData(this.responseSoulInfo);
					return;
				}
				
				if (responseSoulInfo.goldDivineTotal == -1) return;
				else if (responseSoulInfo.goldDivineRemain > 0) {
					responseSoulInfo.goldDivineRemain --;
					setData(this.responseSoulInfo);
					return;
				}
				
				if (responseSoulInfo.vipDivineTotal == -1) return;
				else if (responseSoulInfo.vipDivineRemain > 0) {
					responseSoulInfo.vipDivineRemain --;
					setData(this.responseSoulInfo);
					return;
				}
				
			}
		}
	}

}