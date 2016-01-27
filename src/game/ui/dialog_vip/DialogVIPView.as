package game.ui.dialog_vip 
{
	import core.display.ViewBase;
	import core.Manager;
	import core.util.FontUtil;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;

	import game.data.model.UserData;
	import game.data.xml.CharacterXML;
	import game.data.xml.DataType;
	import game.data.xml.ShopXML;
	import game.data.xml.VIPConfigXML;
	import game.enum.Font;
	import game.enum.GameConfigType;
	import game.Game;
	import game.ui.ModuleID;
	import game.utility.UtilityUI;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class DialogVIPView extends ViewBase 
	{
		public var btnClose			:SimpleButton;
		public var btnChargeXU		:SimpleButton;
		public var btnNextLevel		:SimpleButton;
		public var btnPrevLevel		:SimpleButton;
		public var txtLevel			:TextField;
		public var txtStatus		:TextField;
		public var txtStatusDesc	:TextField;
		public var txtTitle			:TextField;
		public var txtDescription	:TextField;
		
		private var currentVIPLevel	:int;
		
		
		public function DialogVIPView() {
			btnClose = UtilityUI.getComponent(UtilityUI.CLOSE_BTN) as SimpleButton;
			btnClose.x = 840;
			btnClose.y = 153;
			addChild(btnClose);
			
			btnClose.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			btnPrevLevel.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			btnNextLevel.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			btnChargeXU.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			
			FontUtil.setFont(txtDescription, Font.ARIAL);
			FontUtil.setFont(txtStatus, Font.ARIAL);
			FontUtil.setFont(txtStatusDesc, Font.ARIAL);
			FontUtil.setFont(txtTitle, Font.ARIAL);
			FontUtil.setFont(txtLevel, Font.ARIAL, true);
		}
		
		override public function transitionIn():void {
			super.transitionIn();
			txtLevel.text = Game.database.userdata.vip > 0 ? "VIP " + Game.database.userdata.vip : "VIP";
			if (Game.database.userdata.vip == 0) {
				setCurrentVIPLevel(1);	
			} else {
				setCurrentVIPLevel(Game.database.userdata.vip);
			}
			
			var nextVIPLevel:int;
			if (Game.database.userdata.vip < Game.database.gamedata.maxVIP) {
				nextVIPLevel = Game.database.userdata.vip + 1;
			} else {
				nextVIPLevel = Game.database.userdata.vip;
			}

			Game.database.userdata.addEventListener(UserData.UPDATE_PLAYER_INFO, updatePlayerInfoHdl)
		}


		override public function transitionOut():void
		{
			super.transitionOut();
			Game.database.userdata.removeEventListener(UserData.UPDATE_PLAYER_INFO, updatePlayerInfoHdl);
		}

		private function updatePlayerInfoHdl(event:Event):void
		{
			currentVIPLevel =  Game.database.userdata.vip;
			var vipXML:VIPConfigXML = Game.database.gamedata.getData(DataType.VIP, currentVIPLevel) as VIPConfigXML;
			if (vipXML)
			{
				txtStatus.text = Game.database.userdata.consumeXuInMonth + "/" + vipXML.xuRequirement;
			}
		}
		
		private function setCurrentVIPLevel(value:int):void {
			currentVIPLevel = value;
			txtTitle.text = "QUYỀN LỢI VIP " + currentVIPLevel;
			var desc:String = "";
			var vipXML:VIPConfigXML = Game.database.gamedata.getData(DataType.VIP, currentVIPLevel) as VIPConfigXML;
			if (vipXML) {
				txtStatus.text = Game.database.userdata.consumeXuInMonth + "/" + vipXML.xuRequirement;
				var deltaXuConsume:int = vipXML.xuRequirement - Game.database.userdata.consumeXuInMonth;
				if (deltaXuConsume > 0) {
					txtStatusDesc.text = "Nạp thêm " + deltaXuConsume + " vàng để lên VIP cấp " + currentVIPLevel;
				} else {
					txtStatusDesc.text = "";
				}
				
				if (vipXML.dailyQuestAddCount > 0)
					desc += "Dã Tẩu - Số Nhiệm vụ nhận thêm: " + "<font color = '#ffff00'>" + vipXML.dailyQuestAddCount + "</font>\n";
					
//				desc += vipXML.dailyQuestGotoPlay == true
//								? "Dã Tẩu - <font color = '#ffff00'>Tự động </font> chuyển đến nơi làm nhiệm vụ \n"
//								: "";
								
				if (vipXML.dailyQuestCloseFree > 0 )
					desc += "Dã Tẩu - Miễn phí hoàn thành nhanh: <font color = '#ffff00'>" + vipXML.dailyQuestCloseFree + "</font>\n";
					
				if (vipXML.transporterQuestAddCount > 0)
					desc += "Đưa Thư - Nhiệm vụ nhận thêm: <font color = '#ffff00'>" + vipXML.transporterQuestAddCount + "</font>\n";
					
//				desc += vipXML.transporterQuestGotoPlay == true ? "Đưa Thư - <font color = '#ffff00'>Tự động </font>chuyển đến nơi làm nhiệm vụ \n"
//									: "";
								
				desc += vipXML.towerModeAutoPlay == true ? "Tháp Cao Thủ - <font color = '#ffff00'>Tự động </font>chơi \n"
								: "";
								
				if (vipXML.soulCraftAddCount > 0)
					desc += "Mệnh Khí - Được bói thêm: <font color = '#ffff00'>" + vipXML.soulCraftAddCount + "</font>\n";
					
				desc += vipXML.soulCraftAuto == true ? "Mệnh Khí - <font color = '#ffff00'>Tự động </font>bói" + "\n"
								: "";
								
				if (vipXML.additionAPFillingInDay > 0)
					desc += "Hồi Phục Thể Lực - Số thể lực được hồi thêm trong ngày: <font color = '#ffff00'>" + vipXML.additionAPFillingInDay + "</font>\n";
				if (vipXML.additionAlchemyInDay > 0)
					desc += "Luyện Kim - Số lần luyện kim cộng thêm trong ngày: <font color = '#ffff00'>" + vipXML.additionAlchemyInDay + "</font>\n";

				if(vipXML.ID >= 3)
					desc += "Càn Quét - Có thể hoàn thành nhanh\n";

//				if (vipXML.arrItemShopVip.length) {
//					if (vipXML.ID == 1)
//					{
//						desc += "Đặc biệt - nhận được 1 trong các nhân vật: "
//					}
//					else
//					{
//						desc += "Đặc biệt - Có thể mua được 1 trong các nhân vật: "
//					}
//					var characterXML:CharacterXML;
//					for each (var id:int in vipXML.arrItemShopVip) {
//						var shopXML:ShopXML = Game.database.gamedata.getData(DataType.SHOP, id) as ShopXML;
//						if (shopXML != null)
//						{
//							characterXML = Game.database.gamedata.getData(DataType.CHARACTER, shopXML.itemID) as CharacterXML;
//							if (characterXML) {
//								desc += "<font color = '" + UtilityUI.getTxtColor(characterXML.quality[0], false, false) + "'>" + characterXML.name + "</font>, ";
//							}
//						}
//					}
//					desc = desc.substr(0, desc.length - 2); //bo hai ky tu ", " o character cuoi cung
//				}
			}
			
			txtDescription.htmlText = desc;
			FontUtil.setFont(txtDescription, Font.ARIAL);
			
			if (currentVIPLevel == 1) {
				UtilityUI.enableDisplayObj(false, btnPrevLevel, MouseEvent.CLICK, onBtnClickHdl);
				UtilityUI.enableDisplayObj(true, btnNextLevel, MouseEvent.CLICK, onBtnClickHdl);
			} else if (currentVIPLevel > 1 && currentVIPLevel < (Game.database.gamedata.maxVIP)) {
				UtilityUI.enableDisplayObj(true, btnPrevLevel, MouseEvent.CLICK, onBtnClickHdl);
				UtilityUI.enableDisplayObj(true, btnNextLevel, MouseEvent.CLICK, onBtnClickHdl);
			} else {
				UtilityUI.enableDisplayObj(true, btnPrevLevel, MouseEvent.CLICK, onBtnClickHdl);
				UtilityUI.enableDisplayObj(false, btnNextLevel, MouseEvent.CLICK, onBtnClickHdl);
			}
		}
		
		private function onBtnClickHdl(e:MouseEvent):void {
			switch(e.target) {
				case btnClose:
					Manager.display.hideModule(ModuleID.DIALOG_VIP);
					break;
					
				case btnPrevLevel:
					if (currentVIPLevel > 1) {
						setCurrentVIPLevel(currentVIPLevel - 1);
					} 
					break;
					
				case btnNextLevel:
					if (currentVIPLevel < (Game.database.gamedata.maxVIP)) {
						setCurrentVIPLevel(currentVIPLevel + 1);
					} 
					break;
				case btnChargeXU:
//					Manager.display.showPopup(ModuleID.PAYMENT);
					Game.database.gamedata.loadPaymentHTML();
					break;
			}
		}
		
	}

}