package game.ui.challenge_center
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	import core.Manager;
	import core.display.BitmapEx;
	import core.display.ViewBase;
	import core.display.layer.Layer;
	import core.event.EventEx;
	import core.util.FontUtil;
	import core.util.Utility;
	
	import game.Game;
	import game.data.gamemode.ModeDataHeroicTower;
	import game.data.xml.DataType;
	import game.data.xml.ModeConfigXML;
	import game.data.xml.VIPConfigXML;
	import game.data.xml.config.ChallengeCenterConfig;
	import game.data.xml.config.XMLConfig;
	import game.data.xml.item.ItemXML;
	import game.enum.Direction;
	import game.enum.ErrorCode;
	import game.enum.Font;
	import game.enum.GameMode;
	import game.enum.ItemType;
	import game.enum.LeaderBoardTypeEnum;
	import game.enum.PlayerAttributeID;
	import game.net.IntRequestPacket;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.request.RequestLeaderBoard;
	import game.net.lobby.response.ResponseErrorCode;
	import game.net.lobby.response.ResponseHeroicTowerList;
	import game.net.lobby.response.ResponseLeaderBoard;
	import game.ui.ModuleID;
	import game.ui.components.ButtonClose;
	import game.ui.components.ButtonHelp;
	import game.ui.components.CheckBox;
	import game.ui.components.PagingMov;
	import game.ui.dialog.DialogID;
	import game.ui.dialog.TowerAuto;
	import game.ui.dialog.dialogs.YesNo;
	
	public class ChallengeCenterView extends ViewBase
	{
		private static const MAX_RANKING_RECORD:int = 9;
		
		private static const MODE_NORMAL:int = 0;
		private static const MODE_AUTO:int = 1;
		
		public var btnCloseContainer:MovieClip;
		public var btnHelpContainer:MovieClip;
		public var btnShowRewards:SimpleButton;
		public var txtItemQuantity:TextField;
		public var towerInfoContainer:MovieClip;
		public var rankingContainer:MovieClip;
		public var rewardList:RewardList;
		public var pagingContainer:MovieClip;
		public var checkbox:CheckBox;
		public var itemIconContainer:MovieClip;
		
		private var btnClose:ButtonClose;
		private var btnHelp:ButtonHelp;
		private var towerList:Array = [];
		private var rankingRecords:Array = [];
		private var pagingController:PagingMov = new PagingMov();
		private var itemIcon:BitmapEx = new BitmapEx();
		private var mode:int;
		
		public function ChallengeCenterView()
		{
			btnClose = new ButtonClose();
			btnCloseContainer.addChild(btnClose);
			
			btnHelp = new ButtonHelp();
			btnHelp.addEventListener(MouseEvent.CLICK, btnHelp_onClicked);
			btnHelpContainer.addChild(btnHelp);
			
			itemIcon.scaleX = itemIcon.scaleY = 0.5;
			itemIconContainer.addChild(itemIcon);
			
			pagingController.setMaxIndex(MAX_RANKING_RECORD);
			pagingController.addEventListener(PagingMov.INDEX_CHANGED, onPagingIndexChanged);
			
			FontUtil.setFont(txtItemQuantity, Font.TAHOMA, true);
			
			var record:RankingRecordUI;
			for(var i:int = 0; i < MAX_RANKING_RECORD; ++i)
			{
				record = new RankingRecordUI();
				record.y = i * 34;
				rankingRecords.push(record);
				rankingContainer.addChild(record);
			}
			addChild(pagingContainer);
			pagingContainer.addChild(pagingController);
			rewardList.visible = false;
			
			addEventListener(TowerInfo.ENTER_TOWER, onEnterTower);
			addEventListener(TowerInfo.AUTOPLAY, onAutoplay);
			addEventListener(MouseEvent.CLICK, onClicked);
		}
		
		protected function btnHelp_onClicked(event:MouseEvent):void
		{
			Manager.display.showDialog(DialogID.HELP);
		}
		
		protected function onPagingIndexChanged(event:Event):void
		{
			var pageIndex:int = pagingController.getCurrentIndex();
			var startIndex:int = (pageIndex - 1) * MAX_RANKING_RECORD;
			Game.network.lobby.sendPacket(new RequestLeaderBoard(LeaderBoardTypeEnum.HEROIC_TOWER.type, startIndex, startIndex + MAX_RANKING_RECORD - 1));
		}
		
		protected function onAutoplay(event:EventEx):void
		{
			var vipConfigXML:VIPConfigXML = Game.database.gamedata.getData(DataType.VIP, Game.database.userdata.vip) as VIPConfigXML;
			if (vipConfigXML == null || vipConfigXML.towerModeAutoPlay == false)
			{
				var arrVip:Dictionary = Game.database.gamedata.getTable(DataType.VIP);
				for each (var value:VIPConfigXML in arrVip) {
					if (value && (value.towerModeAutoPlay == true)) {
						var dialogData:Object = {};
						dialogData.message = "Chỉ có VIP " + value.ID + " mới được sử dụng tính năng này. Các hạ có muốn xem thông tin VIP không?";
						dialogData.option = YesNo.CLOSE | YesNo.NO | YesNo.YES;
						Manager.display.showDialog(DialogID.YES_NO, onShowVipDialog, null, dialogData);
						break;
					}
				}
			}
			else
			{
				var towerID:int = event.data as int;
				var modeData:ModeDataHeroicTower = Game.database.userdata.getModeData(GameMode.HEROIC_TOWER) as ModeDataHeroicTower;
				modeData.currentTower = towerID;
				mode = MODE_AUTO;
				var towerData:HeroicTowerData = modeData.getCurrentTowerData();
				if(towerData.getCurrentFloor() < towerData.getMaxFloor())
				{
					checkItem();
				}
				else
				{
					Manager.display.showMessage("Đã đến tầng cao nhất hiện tại");
				}
			}
		}
		
		private function onShowVipDialog(data:Object):void
		{
			Manager.display.showPopup(ModuleID.DIALOG_VIP, Layer.BLOCK_BLACK);
		}
		
		protected function onClicked(event:MouseEvent):void
		{
			switch(event.target)
			{
				case btnClose:
					Manager.display.hideModule(ModuleID.CHALLENGE_CENTER);
					break;
				case btnShowRewards:
					rewardList.parseRewards();
					rewardList.visible = true;
					break;
			}
		}
		
		protected function onEnterTower(event:EventEx):void
		{
			var modeData:ModeDataHeroicTower = Game.database.userdata.getModeData(GameMode.HEROIC_TOWER) as ModeDataHeroicTower;
			modeData.currentTower = event.data as int;
			mode = MODE_NORMAL;
			checkItem();
		}
		
		private function checkItem():void
		{
			var modeData:ModeDataHeroicTower = Game.database.userdata.getModeData(GameMode.HEROIC_TOWER) as ModeDataHeroicTower;
			if(modeData.itemActivated == false)
			{
				var dialogData:Object = {};
				if(getItemQuantity() == 0)
				{
					dialogData.quantity = getItemPrice();
					Manager.display.showDialog(DialogID.HEROIC_TOWER_ITEM, onUseItem, onNotUseItem, dialogData, Layer.BLOCK_BLACK);
				}
				else
				{
					if(checkbox.isChecked() == false)
					{
						dialogData.message = "Sử dụng túi bảo vật để nhân đôi phần thưởng?";
						dialogData.option = YesNo.NO | YesNo.YES;
						Manager.display.showDialog(DialogID.YES_NO, onUseItem, onNotUseItem, dialogData, Layer.BLOCK_BLACK);
					}
					else
					{
						useItem();
					}
				}
			}
			else
			{
				start();
			}
		}
		
		private function start():void
		{
			switch(mode)
			{
				case MODE_NORMAL:
					Manager.display.to(ModuleID.HEROIC_TOWER);
					break;
				case MODE_AUTO:
					Manager.display.showDialog(DialogID.TOWER_AUTO, null, null, null, Layer.BLOCK_BLACK);
					break;
			}
		}
		
		private function onUseItem(data:Object):void
		{
			useItem();
		}
		
		private function onNotUseItem(data:Object):void
		{
			start();
		}
		
		private function useItem():void
		{
			var modeData:ModeDataHeroicTower = Game.database.userdata.getModeData(GameMode.HEROIC_TOWER) as ModeDataHeroicTower;
			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.HEROIC_TOWER_USE_ITEM, modeData.currentTower));
		}
		
		override public function transitionIn():void
		{
			super.transitionIn();
			
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);
			
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_HEROIC_TOWER_LIST));
			
			pagingController.setCurrentIndex(1);
			txtItemQuantity.text = getItemQuantity().toString();
			var modeConfig:ModeConfigXML = Game.database.gamedata.getData(DataType.MODE_CONFIG, XMLConfig.CHALLENGE_CENTER) as ModeConfigXML;
			var challengeCenterConfig:ChallengeCenterConfig = modeConfig.xmlConfig as ChallengeCenterConfig;
			var itemXML:ItemXML = Game.database.gamedata.getData(ItemType.BONUS_TOWER_MODE.dataType, challengeCenterConfig.itemID) as ItemXML;
			if(itemXML != null) itemIcon.load(itemXML.iconURL);
		}
		
		private function getItemQuantity():int
		{
			var modeConfig:ModeConfigXML = Game.database.gamedata.getData(DataType.MODE_CONFIG, XMLConfig.CHALLENGE_CENTER) as ModeConfigXML;
			var challengeCenterConfig:ChallengeCenterConfig = modeConfig.xmlConfig as ChallengeCenterConfig;
			return Game.database.inventory.getItemQuantity(ItemType.BONUS_TOWER_MODE, challengeCenterConfig.itemID);
		}
		
		private function getItemPrice():int
		{
			var modeConfig:ModeConfigXML = Game.database.gamedata.getData(DataType.MODE_CONFIG, XMLConfig.CHALLENGE_CENTER) as ModeConfigXML;
			var challengeCenterConfig:ChallengeCenterConfig = modeConfig.xmlConfig as ChallengeCenterConfig;
			return challengeCenterConfig.itemPrice;
		}
		
		protected function onLobbyServerData(event:EventEx):void
		{
			var packet:ResponsePacket = event.data as ResponsePacket;
			switch(packet.type)
			{
				case LobbyResponseType.HEROIC_TOWER_LIST:
					onReceiveTowerList(packet as ResponseHeroicTowerList);
					break;
				case LobbyResponseType.LEADER_BOARD:
					onReceiveRankings(packet as ResponseLeaderBoard);
					break;
				case LobbyResponseType.ERROR_CODE:
					onErrorCode(packet as ResponseErrorCode);
					break;
			}
		}
		
		private function onErrorCode(packet:ResponseErrorCode):void
		{
			switch(packet.requestType)
			{
				case LobbyRequestType.HEROIC_TOWER_USE_ITEM:
					onUseItemResult(packet.errorCode);
					break;
			}
		}
		
		private function onUseItemResult(errorCode:int):void
		{
			Utility.log("heroic tower use item, errorCode=" + errorCode);
			switch(errorCode)
			{
				case ErrorCode.SUCCESS:
					Game.network.lobby.getPlayerAttribute(PlayerAttributeID.XU);
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_ITEM_INVENTORY));
					var modeData:ModeDataHeroicTower = Game.database.userdata.getModeData(GameMode.HEROIC_TOWER) as ModeDataHeroicTower;
					modeData.itemActivated = true;
					start();
					break;
				case ErrorCode.HEROIC_TOWER_USE_ITEM_NOT_ENOUGH_XU:
					Manager.display.showMessage("Không đủ vàng");
					break;
			}
		}
		
		private function onReceiveRankings(packet:ResponseLeaderBoard):void
		{
			var record:RankingRecordUI;
			for(var i:int = 0; i < MAX_RANKING_RECORD; ++i)
			{
				record = rankingRecords[i];
				if (i < packet.rankingRecords.length) packet.rankingRecords[i].index = (pagingController.getCurrentIndex() - 1) * MAX_RANKING_RECORD + i + 1;
				record.setData(packet.rankingRecords[i]);
			}
		}
		
		private function onReceiveTowerList(packet:ResponseHeroicTowerList):void
		{
			if(packet == null) return;
			var modeData:ModeDataHeroicTower = Game.database.userdata.getModeData(GameMode.HEROIC_TOWER) as ModeDataHeroicTower;
			modeData.heroicTowers = packet.towers;
			modeData.isDead = packet.isDead;
			modeData.itemActivated = packet.itemActivated;
			var towerInfo:TowerInfo;
			for each(towerInfo in towerList)
			{
				towerInfoContainer.removeChild(towerInfo);
				Manager.pool.push(towerInfo, TowerInfo);
			}
			towerList.splice(0);
			var towerData:HeroicTowerData;
			for(var i:int = 0, length:int = packet.towers.length; i < length; ++i)
			{
				towerData = packet.towers[i];
				if(towerData == null) continue;
				modeData.currentTower = towerData.getXMLData().ID;
				towerInfo = Manager.pool.pop(TowerInfo) as TowerInfo;
				towerInfo.setData(packet.towers[i]);
				towerInfo.y = towerList.length * 103;
				towerInfoContainer.addChild(towerInfo);
				towerList.push(towerInfo);
			}
		}

		//TUTORIAL

		public function showHintButton(content:String = ""):void
		{
			var towerInfo:TowerInfo = towerList[0];
			if(towerInfo)
			{
				var btn:SimpleButton = towerInfo.btnEnter;
				Game.hint.showHint(btn, Direction.UP, btn.x + btn.width / 2, btn.y + btn.height, content);
			}
		}
	}
}