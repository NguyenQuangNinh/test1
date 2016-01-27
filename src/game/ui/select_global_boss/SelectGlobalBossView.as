package game.ui.select_global_boss 
{
	import core.display.layer.Layer;
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.Utility;

	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import game.data.model.ModeConfigGlobalBoss;
	import game.Game;
	import game.enum.GameConfigID;
	import game.net.IntRequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.request.RequestBossMissionInfo;
	import game.ui.dialog.DialogID;
	import game.ui.dialog.dialogs.YesNo;
	import game.ui.home.scene.CharacterManager;
	import game.ui.ModuleID;
	import game.utility.UtilityUI;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class SelectGlobalBossView extends ViewBase 
	{
		public var btnClose		:SimpleButton;
		public var btnHelp		:SimpleButton;
		private var items		:Array;
		
		public var giftInfoPopup:GlobalBossGiftPopup;
		
		public function SelectGlobalBossView() {
			initUI();
			initHandlers();
		}
		
		private function initUI():void 
		{
			giftInfoPopup.visible = false;
			btnClose = UtilityUI.getComponent(UtilityUI.CLOSE_BTN) as SimpleButton;
			btnClose.x = 1075;
			btnClose.y = 110;
			addChild(btnClose);
			
			btnHelp = UtilityUI.getComponent(UtilityUI.HELP_BTN) as SimpleButton;
			btnHelp.x = btnClose.x - btnHelp.width;
			btnHelp.y = 110;
			addChild(btnHelp);
			
			items = [];
			var item:SelectGlobalBossItem;
			for (var i:int = 0; i < 3; i++) {
				item = new SelectGlobalBossItem();
				item.x = 200 + 310 * i;
				item.y = 155;
				item.bossType = i;
				item.addEventListener(SelectGlobalBossItem.SHOW_ERR_DIALOG, onShowDialogErrHandler);
				addChild(item);
				items.push(item);
			}
			addChild(giftInfoPopup);
		}
		
		public function updateItems(arr:Array, arrStatus:Array):void {
			var modeConfig:ModeConfigGlobalBoss = Game.database.gamedata.getGlobalBossConfig();
			var length:int = Math.min(arr.length, items.length, arrStatus.length);
			var item:SelectGlobalBossItem;
			
			for (var i:int = 0; i < length; i++) 
			{
				item = items[i];
				item.setData(arr[i], i);
				item.setStatus(arrStatus[i]);
				if (items[i - 1] != null) {
					item.setDamageRequired(modeConfig.damageRequired[i], SelectGlobalBossItem(items[i - 1]).getBossName());
				} else {
					item.setDamageRequired( -1, "");
				}
			}
		}
				
		private function onShowDialogErrHandler(e:EventEx):void {
			var itemIndex:int = e.data.index;
			var modeConfig:ModeConfigGlobalBoss = Game.database.gamedata.getGlobalBossConfig();
			if (items[itemIndex - 1] && modeConfig && (modeConfig.damageRequired[itemIndex] != null)) {
				var item:SelectGlobalBossItem = items[itemIndex - 1];
				if (item) {
					var damageRequired:int = modeConfig.damageRequired[itemIndex];
					var obj:Object = { };
					if (damageRequired <= 0) {
						
					} else {
						Game.database.userdata.globalBossData.currentMissionID = e.data.missionID;
						Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.CHECK_BOSS_PAYMENT, e.data.missionID));
					}
				}
			}
		}

		public function paymentHandler(rs:Boolean):void
		{
			var missionID:int = Game.database.userdata.globalBossData.currentMissionID;
			if(!rs)
			{
				var priceList:Array = Game.database.gamedata.getConfigData(231);
				var index:int = Game.database.userdata.globalBossData.missionIDs.indexOf(missionID);
				if(index != -1 && index < priceList.length)
				{
					var price:int = priceList[index];
					var msg:String = "Dùng " + price + " Vàng để tham gia nhanh.";
					Manager.display.showDialog(DialogID.YES_NO, onAcceptPayment, null, {title: "THÔNG BÁO", message: msg, missionID: missionID, option: YesNo.YES | YesNo.NO});
				}
				else
				{
					Utility.log("Global boss > paymentHandler() > invalid index: " + index + " ,priceList: " + priceList);
				}
			}
			else
			{
				Game.database.userdata.globalBossData.currentMissionID = missionID;
				Game.network.lobby.sendPacket(new RequestBossMissionInfo(LobbyRequestType.GLOBAL_BOSS_MISSION_INFO, missionID));
			}
		}

		private function onAcceptPayment(data:Object):void
		{
			Game.database.userdata.globalBossData.currentMissionID = data.missionID;
			Game.network.lobby.sendPacket(new RequestBossMissionInfo(LobbyRequestType.GLOBAL_BOSS_MISSION_INFO, data.missionID, true));
		}
		
		private function initHandlers():void 
		{
			btnClose.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			btnHelp.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
		}
		
		private function onBtnClickHdl(e:MouseEvent):void {
			switch(e.target) {
				case btnClose:
					Manager.display.hideModule(ModuleID.SELECT_GLOBAL_BOSS);
					CharacterManager.instance.displayCharacters();
					break;
					
				case btnHelp:
					break;
			}
		}
	}

}