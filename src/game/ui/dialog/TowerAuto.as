package game.ui.dialog
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import core.Manager;
	import core.display.layer.Layer;
	import core.event.EventEx;
	import core.util.Utility;
	
	import game.Game;
	import game.data.gamemode.ModeDataHeroicTower;
	import game.data.model.item.IItemConfig;
	import game.data.model.item.Item;
	import game.data.model.item.ItemFactory;
	import game.data.vo.item.ItemInfo;
	import game.data.xml.DataType;
	import game.data.xml.ModeConfigXML;
	import game.data.xml.config.ChallengeCenterConfig;
	import game.data.xml.config.XMLConfig;
	import game.enum.ErrorCode;
	import game.enum.GameMode;
	import game.net.IntRequestPacket;
	import game.net.IntResponsePacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.response.ResponseRewardPacket;
	import game.ui.challenge_center.AutoplayDetail;
	import game.ui.challenge_center.HeroicTowerData;
	import game.ui.components.ButtonClose;
	import game.ui.components.ScrollBar;
	import game.ui.dialog.dialogs.Dialog;
	import game.ui.dialog.dialogs.YesNo;
	
	public class TowerAuto extends Dialog
	{
		public var btnCloseContainer:MovieClip;
		public var btnFinish:SimpleButton;
		public var detailContainer:MovieClip;
		public var scrollbarMask:MovieClip;
		public var scrollbar:ScrollBar;
		
		private var btnClose:ButtonClose;
		private var details:Array = [];
		private var modeData:ModeDataHeroicTower;
		
		public function TowerAuto()
		{
			btnClose = new ButtonClose();
			btnClose.addEventListener(MouseEvent.CLICK, btnClose_onClicked);
			btnCloseContainer.addChild(btnClose);
			
			btnFinish.addEventListener(MouseEvent.CLICK, btnFinish_onClicked);
			
			scrollbar.init(detailContainer, scrollbarMask);
			
			addEventListener(AutoplayDetail.TIMER_COMPLETE, onTimerComplete);
		}
		
		protected function btnFinish_onClicked(event:MouseEvent):void
		{
			var towerData:HeroicTowerData = modeData.getCurrentTowerData();
			var numFloor:int = towerData.getMaxFloor() - towerData.getCurrentFloor();
			var modeConfig:ModeConfigXML = Game.database.gamedata.getData(DataType.MODE_CONFIG, XMLConfig.CHALLENGE_CENTER) as ModeConfigXML;
			var cost:int = 0;
			if(modeConfig != null)
			{
				var config:ChallengeCenterConfig = modeConfig.xmlConfig as ChallengeCenterConfig;
			}
			else
			{
				Utility.error("ERROR: challenge center xml config not found");
			}
			cost = numFloor * config.instantFinishCost;
			if(cost > 0)
			{
				var dialogData:Object = {};
				dialogData.title = "Xác nhận";
				dialogData.message = "Lập tức đến tầng cao nhất với " + cost + " vàng?";
				dialogData.option = YesNo.CLOSE | YesNo.YES;
				Manager.display.showDialog(DialogID.YES_NO, onConfirmFinish, null, dialogData, Layer.BLOCK_BLACK);
			}
		}
		
		private function onConfirmFinish(data:Object):void
		{
			Utility.log("instant finish, towerID=" + modeData.currentTower);
			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.HEROIC_TOWER_INSTANT_FINISH, modeData.currentTower));
		}
		
		protected function onTimerComplete(event:Event):void
		{
			Utility.log("complete heroic tower auto, towerID=" + modeData.currentTower);
			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.HEROIC_TOWER_GET_AUTOPLAY_REWARD, modeData.currentTower));
		}
		
		override public function onShow():void
		{
			while(detailContainer.numChildren > 0)
			{
				var detail:AutoplayDetail = detailContainer.removeChildAt(0) as AutoplayDetail;
				Manager.pool.push(detail, AutoplayDetail);
			}
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);
			modeData = Game.database.userdata.getModeData(GameMode.HEROIC_TOWER) as ModeDataHeroicTower;
			Utility.log("start heroic tower auto, towerID=" + modeData.currentTower);
			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.HEROIC_TOWER_START_AUTOPLAY, modeData.currentTower));
		}
		
		override public function onHide():void
		{
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerData);
		}
		
		protected function onLobbyServerData(event:EventEx):void
		{
			var packet:ResponsePacket = event.data as ResponsePacket;
			switch(packet.type)
			{
				case LobbyResponseType.HEROIC_TOWER_START_AUTOPLAY:
					onStartAutoplay(packet as IntResponsePacket);
					break;
				case LobbyResponseType.HEROIC_TOWER_AUTOPLAY_REWARD:
					onReceiveReward(packet as ResponseRewardPacket);
					break;
				case LobbyResponseType.HEROIC_TOWER_INSTANT_FINISH:
					onInstantFinish(packet as IntResponsePacket);
					break;
			}
		}
		
		private function onReceiveReward(packet:ResponseRewardPacket):void
		{
			Utility.log("receive reward");
			var rewardList:Array = [];
			var length:int;
			var i:int;
			var itemInfo:ItemInfo;
			var item:Item;
			var itemData:IItemConfig;
			for each(itemInfo in packet.fixedItems)
			{
				item = ItemFactory.createItem(itemInfo.type, itemInfo.id) as Item;
				item.quantity = itemInfo.quantity;
				rewardList.push(item);
			}
			for each(item in packet.randomItems)
			{
				item = ItemFactory.createItem(itemInfo.type, itemInfo.id) as Item;
				item.quantity = itemInfo.quantity;
				rewardList.push(item);
			}
			
			var detail:AutoplayDetail;
			detail = details[details.length - 1];
			detail.complete(rewardList);
			var towerData:HeroicTowerData = modeData.getCurrentTowerData();
			towerData.nextFloor();
			nextFloor();
		}
		
		private function onInstantFinish(packet:IntResponsePacket):void
		{
			Utility.log("errorCode=" + packet.value);
			switch(packet.value)
			{
				case ErrorCode.SUCCESS:
					var towerData:HeroicTowerData = modeData.getCurrentTowerData();
					towerData.topFloor();
					break;
			}
		}
		
		private function onStartAutoplay(packet:IntResponsePacket):void
		{
			Utility.log("errorCode=" + packet.value);
			switch(packet.value)
			{
				case ErrorCode.SUCCESS:
					nextFloor();
					break;
			}
		}
		
		protected function btnClose_onClicked(event:MouseEvent):void
		{
			Utility.log("stop heroic tower auto, towerID=" + modeData.currentTower);
			var detail:AutoplayDetail = details[details.length - 1];
			if(detail != null)
			{
				detail.cancel();
			}
			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.HEROIC_TOWER_STOP_AUTOPLAY, modeData.currentTower));
			close();
		}
		
		public function nextFloor():void
		{
			var towerData:HeroicTowerData = modeData.getCurrentTowerData();
			var detail:AutoplayDetail;
			if(towerData.getCurrentFloor() < towerData.getMaxFloor())
			{
				detail = Manager.pool.pop(AutoplayDetail) as AutoplayDetail;
				detail.reset();
				detail.setData(towerData.getCurrentFloor());
				detail.y = detailContainer.height + 5;
				detailContainer.addChild(detail);
				details.push(detail);
				scrollbar.update();
				if(scrollbar.visible) {
					scrollbar.percent = 1;
				}
			}
			else
			{
				Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.HEROIC_TOWER_STOP_AUTOPLAY, modeData.currentTower));
			}
		}
	}
}