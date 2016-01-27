package game.ui.metal_furnace
{
import core.Manager;
import core.display.ModuleBase;
import core.event.EventEx;
import core.util.Utility;

import flash.events.Event;

import game.Game;
import game.data.model.UserData;
import game.enum.FlowActionEnum;
import game.enum.GameConfigID;
import game.enum.PaymentType;
import game.net.BoolRequestPacket;
import game.net.IntResponsePacket;
import game.net.RequestPacket;
import game.net.ResponsePacket;
import game.net.Server;
import game.net.lobby.LobbyRequestType;
import game.net.lobby.LobbyResponseType;
import game.net.lobby.response.ResponseMetalFurnaceResult;
import game.ui.ModuleID;
import game.ui.home.scene.CharacterManager;
import game.ui.hud.HUDButtonID;
import game.ui.hud.HUDModule;
import game.ui.message.MessageID;

/**
	 * ...
	 * @author anhtinh
	 */
	public class MetalFurnaceModule extends ModuleBase
	{
		
		public function MetalFurnaceModule()
		{
		
		}
		
		override protected function createView():void
		{
			super.createView();
			baseView = new MetalFurnaceView();
			baseView.addEventListener(MetalFurnaceView.REQUEST_METAL_FURNACE, metalFurnaceHandler);
			baseView.addEventListener(MetalFurnaceView.SKIP_COOLDOWN_EVENT, skipCooldownHandler);
			baseView.addEventListener("closeMetalFurnace", closeMetalFurnaceHandler);
		
		}

        private function skipCooldownHandler(event:Event):void {
            var cost:int = Game.database.gamedata.getConfigData(GameConfigID.COST_SKIP_TIME_WAIT_ALCHEMY) as int;

            if (Game.database.userdata.xu >= cost)
            {
                Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.ALCHEMY_SKIP_TIMEWAIT));
            }
            else
            {
                Game.flow.doAction(FlowActionEnum.PURCHASE_RESOURCE, PaymentType.XU_NORMAL.ID);
            }

        }
		
		private function closeMetalFurnaceHandler(e:Event):void
		{
			var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
			if (hudModule != null)
			{
				hudModule.updateHUDButtonStatus(ModuleID.METAL_FURNACE, false);
				var checkVisible:Boolean = !Manager.module.moduleIsVisible(ModuleID.WORLD_MAP);
				hudModule.setVisibleButtonHUD([HUDButtonID.WORLD_MAP.name], checkVisible);
			}
			//Manager.display.hideModule(ModuleID.METAL_FURNACE);
		}
		
		private function metalFurnaceHandler(e:EventEx):void
		{
			Game.network.lobby.sendPacket(new BoolRequestPacket(LobbyRequestType.METAL_FURNACE, e.data.autoSkip));
		}
		
		private function onLobbyServerData(e:EventEx):void
		{
			var packet:ResponsePacket = ResponsePacket(e.data);
			switch (packet.type)
			{
				
				case LobbyResponseType.METAL_FURNACE: 
					onReceiveMetalFurnaceInfo(packet as ResponseMetalFurnaceResult);
					break;
                case LobbyResponseType.ALCHEMY_SKIP_TIMEWAIT:
					onReceiveSkipTimeWaitInfo(packet as IntResponsePacket);
					break;
			
			}
		}

        private function onReceiveSkipTimeWaitInfo(intResponsePacket:IntResponsePacket):void {
            Utility.log("onReceiveSkipTimeWaitInfo : " + intResponsePacket.value);
            switch (intResponsePacket.value)
            {
                case 0: //thanh cong
                    MetalFurnaceView(baseView).metalFurnaceInfo.finishedCountDown();
                    Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_PLAYER_INFO));
                    break;
                case 1: //fail

                    break;
                case 2: //khong du xu
                    Game.flow.doAction(FlowActionEnum.PURCHASE_RESOURCE, PaymentType.XU_NORMAL.ID);
                    break;
                default:
                    Utility.error("Lo Luyen Kim - Unknown error code : " + intResponsePacket.value);
            }
        }
		
		private function onReceiveMetalFurnaceInfo(packet:ResponseMetalFurnaceResult):void
		{
			Utility.log("onReceiveMetalFurnaceInfo : " + packet.result + ", bonus Gold: " + packet.bonusGold);
			switch (packet.result)
			{
				case 0: //thanh cong
                    var timeWait:int = Game.database.gamedata.getConfigData(GameConfigID.TIME_WAIT_ALCHEMY) as int;
					MetalFurnaceView(baseView).playCollectGoldEffect();
					MetalFurnaceView(baseView).metalFurnaceInfo.showCountDown(timeWait);
					MetalFurnaceView(baseView).metalFurnaceInfo.setBonusGold(packet.bonusGold);
					break;
				case 1: //fail
					
					break;
				case 2: //khong du xu
					Game.flow.doAction(FlowActionEnum.PURCHASE_RESOURCE, PaymentType.XU_NORMAL.ID);
					break;
				case 3: //het luot quay trong ngay
                    Manager.display.showMessageID(MessageID.METAL_FURNACE_OUT_OF_TURN);
					break;
                case 4: //chua het thoi gian cooldown
                    Manager.display.showMessageID(MessageID.METAL_FURNACE_WAITNG);
                    break;
				default: 
					Utility.error("Lo Luyen Kim - Unknown error code : " + packet.result);
			}
		}
		
		override protected function onTransitionInComplete():void
		{
			super.onTransitionInComplete();
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);
			Game.database.userdata.addEventListener(UserData.UPDATE_PLAYER_INFO, onUpdatePlayerInfo);
			CharacterManager.instance.hideCharacters();
		}
		
		private function onUpdatePlayerInfo(e:Event):void
		{
			MetalFurnaceView(baseView).setInfo();
			MetalFurnaceView(baseView).updateNumAlchemy();
		}
		
		override protected function onTransitionOutComplete():void
		{
			super.onTransitionOutComplete();
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerData);
			Game.database.userdata.removeEventListener(UserData.UPDATE_PLAYER_INFO, onUpdatePlayerInfo);
			CharacterManager.instance.displayCharacters();
		}
		
		override protected function preTransitionIn():void
		{
			super.preTransitionIn();
			MetalFurnaceView(baseView).setInfo();
			MetalFurnaceView(baseView).updateNumAlchemy();
		}
	
	}

}