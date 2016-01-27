package game.ui.worldmap {
import core.Manager;
import core.display.ModuleBase;
import core.display.layer.Layer;
import core.display.layer.LayerManager;
import core.event.EventEx;
import core.util.Utility;

import flash.events.Event;
import flash.geom.Point;
import flash.utils.Dictionary;

import game.Game;
import game.data.model.UserData;
import game.data.vo.campaign_sweep.SweepInfo;
import game.data.vo.lobby.LobbyInfo;
import game.data.xml.CampaignXML;
import game.data.xml.DataType;
import game.data.xml.MissionXML;
import game.enum.FlowActionEnum;
import game.enum.GameMode;
import game.net.IntRequestPacket;
import game.net.IntResponsePacket;
import game.net.ResponsePacket;
import game.net.Server;
import game.net.lobby.LobbyRequestType;
import game.net.lobby.LobbyResponseType;
import game.net.lobby.request.RequestGetCampaignReward;
import game.net.lobby.response.ResponseCampaignInfo;
import game.ui.ModuleID;
import game.ui.dialog.DialogID;
import game.ui.dialog.dialogs.SweepCampaignDialog;
import game.ui.hud.HUDModule;
import game.ui.worldmap.event.EventWorldMap;
import game.ui.worldmap.gui.CampaignRewardSlot;

/**
 * ...
 * @author anhtinh
 */
public class WorldMapModule extends ModuleBase {
    private var currentCampaignData:CampaignXML;
    private var _highlightNewestMission:Boolean;
    private var lastCampaignID:int = 1;

    //private var _playMissionFlow:Boolean = false;

    public function WorldMapModule() {

    }

    override protected function createView():void {
        super.createView();
        baseView = new WorldMapView();

        baseView.addEventListener(EventWorldMap.ENTER_CAMPAIGN, onEnterCampaign);
        baseView.addEventListener(EventWorldMap.HIDE_WORLD_MAP, onHideWorldMap);
        baseView.addEventListener(EventWorldMap.PLAY_MISSION, onPlayMission);
        baseView.addEventListener(EventWorldMap.GET_CAMPAIGN_REWARD, onGetCampaignReward);
        baseView.addEventListener(EventWorldMap.QUICK_FINISH, onQuickFinish);
    }

    override protected function onTransitionInComplete():void {
        super.onTransitionInComplete();

        //_highlightNewestMission = extraInfo ;
        //_playMissionFlow = false;

        /*var campaignDataTable:Dictionary = Game.database.gamedata.getTable(DataType.CAMPAIGN);
         WorldMapView(view).globalMap.reset();
         WorldMapView(view).globalMap.initData(campaignDataTable);

         Manager.display.showModule(ModuleID.TOP_BAR, new Point(0, 0), LayerManager.LAYER_TOP,
         "top_left", Layer.NONE);

         Manager.display.showModule(ModuleID.HUD, new Point(0, 0), LayerManager.LAYER_HUD, "top_left", Layer.NONE);*/

        Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);
        Game.database.userdata.addEventListener(UserData.GAME_LEVEL_UP, onUpdatePlayerInfo);
        //Game.flow.addEventListener(FlowManager.ACTION_COMPLETED, onFlowActionCompletedHdl);
        if (_highlightNewestMission) {
            Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_CAMPAIGN_INFO, lastCampaignID));
        }

        if (Game.database.userdata.isWaitingLevelUpEffect) {
            Game.database.userdata.isWaitingLevelUpEffect = false;
            Manager.display.showModule(ModuleID.GAME_LEVEL_UP, new Point(0, 0), LayerManager.LAYER_TOP);
        }
    }

    /*private function onFlowActionCompletedHdl(e:EventEx):void
     {
     //if (_playMissionFlow) {
     //just listen for flow play mission normal
     switch(e.data.type) {
     case FlowActionEnum.CREATE_LOBBY_SUCCESS:
     Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.NOTIFY_JOIN_ROOM_READY));
     break;
     case FlowActionEnum.CREATE_LOBBY_FAIL:
     onCreateLobbyFail(e.data.error as int);
     break;
     case FlowActionEnum.UPDATE_LOBBY_INFO_SUCCESS:
     Game.flow.doAction(FlowActionEnum.START_LOBBY);
     break;
     case FlowActionEnum.START_LOBBY_SUCCESS:
     Game.flow.doAction(FlowActionEnum.START_LOADING_RESOURCE);
     break;
     }
     //}
     }*/

    override protected function onTransitionOutComplete():void {
        super.onTransitionOutComplete();
        Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerData);
        //Game.flow.removeEventListener(FlowManager.ACTION_COMPLETED, onFlowActionCompletedHdl);
        Game.database.userdata.removeEventListener(UserData.GAME_LEVEL_UP, onUpdatePlayerInfo);
        //HUDModule(modulesManager.getModuleByID(ModuleID.HUD)).setVisiableButtonHUD(["worldMapBtn"], true);
    }

    private function onCreateLobbyFail(errorCode:int):void {
        switch (errorCode) {
            case 14:
                Manager.display.showMessage("Bạn chưa hoàn thành ải trước");
                break;
        }
    }

    private function onUpdatePlayerInfo(e:Event):void {
        var campaignDataTable:Dictionary = Game.database.gamedata.getTable(DataType.CAMPAIGN);
        WorldMapView(baseView).globalMap.showPlacesIcon();
    }

    private function onGetCampaignReward(e:EventWorldMap):void {
        var packet:RequestGetCampaignReward = new RequestGetCampaignReward();
        packet.campaignID = e.data["campaignID"];
        packet.rewardIndex = e.data["rewardIndex"];

        Game.network.lobby.sendPacket(packet);

    }

    private function onLobbyServerData(e:EventEx):void {
        var packet:ResponsePacket = ResponsePacket(e.data);
        switch (packet.type) {
            case LobbyResponseType.CAMPAIGN_INFO:
                onReceiveCampaignInfo(packet as ResponseCampaignInfo);
                break;
            case LobbyResponseType.CAMPAIGN_REWARD:
                onReceiveGetCampaignReward(packet as IntResponsePacket);
                break;
        }
    }

    private function onReceiveGetCampaignReward(intResponsePacket:IntResponsePacket):void {
        Utility.log("onReceiveGetCampaignReward : " + intResponsePacket.value);
        switch (intResponsePacket.value) {
            case 0:

                Manager.display.showMessageID(12);
                WorldMapView(baseView).localMap.rewardPanel.setGiftedForSlot(CampaignRewardSlot.currentRewardIndex);
                break;
            case 1:
                Manager.display.showMessageID(13);
                Utility.error("Error : server can not process campaign reward");
                break;
            case 2:
                Manager.display.showMessageID(13);
                Utility.error("Error : campaign reward id is not exit");
                break;
            case 3:
                Manager.display.showMessageID(13);
                Utility.error("Error : campaign id is not exit");
                break;
            case 4:
                Manager.display.showMessageID(13);
                Utility.error("Error : not enough star to receive reward");
                break;
            case 5:
                Manager.display.showMessageID(16);
                Utility.error("Error : reward has received");
                WorldMapView(baseView).localMap.rewardPanel.setGiftedForSlot(CampaignRewardSlot.currentRewardIndex);
                break;
            case 6:
                Manager.display.showMessageID(15);
                Utility.error("Error : can not receive reward because inventory is full");
                break;

            default:
                Utility.error("Error : unknow error code");
                Manager.display.showMessageID(13);
        }

    }

    private function onReceiveCampaignInfo(responseCampaignInfo:ResponseCampaignInfo):void {

        if (this.currentCampaignData != null) {

            WorldMapView(baseView).showMissionsOfCampaign(this.currentCampaignData, responseCampaignInfo, _highlightNewestMission);
        }

    }

    private function onPlayMission(e:EventWorldMap):void {
        //(WorldMapView)(view).localMap.visible = false;
        var missionXML:MissionXML = e.data as MissionXML;
        if (missionXML != null && canPlayMission(missionXML)) {
            if (Game.database.userdata.level < missionXML.levelRequired) {
                Manager.display.showMessage("Chưa đủ cấp độ yêu cầu");
                return;
            }
            Utility.log("Play mission ID: " + missionXML.ID);
            //_playMissionFlow = true;
            var lobbyInfo:LobbyInfo = new LobbyInfo();
            lobbyInfo.mode = GameMode.PVE_WORLD_CAMPAIGN;
            lobbyInfo.missionID = missionXML.ID;
            lobbyInfo.backModule = ModuleID.WORLD_MAP;
            Game.flow.doAction(FlowActionEnum.CREATE_BASIC_LOBBY, lobbyInfo);
        } else {
            Manager.display.showDialog(DialogID.HEAL_AP);
        }
    }

    private function onQuickFinish(event:EventWorldMap):void {
        var sweepInfo:SweepInfo = new SweepInfo();
        sweepInfo.missionXML = event.data as MissionXML;
        sweepInfo.state = SweepCampaignDialog.INIT;

        Manager.display.showDialog(DialogID.QUICK_FINISH_CAMPAIGN, null, null, sweepInfo, Layer.BLOCK_BLACK);
    }

    private function canPlayMission(missionXML:MissionXML):Boolean {
        return (Game.database.userdata.actionPoint >= missionXML.aPRequirement);
    }

    private function onHideWorldMap(e:EventWorldMap):void {

        var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
        if (hudModule != null) {
            hudModule.updateHUDButtonStatus(ModuleID.WORLD_MAP, false);
        }

        Manager.display.to(ModuleID.HOME);
    }

    private function onEnterCampaign(e:EventWorldMap):void {
        var campaignData:CampaignXML = CampaignXML(e.data);
        this.currentCampaignData = campaignData

        lastCampaignID = campaignData.ID;

        Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_CAMPAIGN_INFO, lastCampaignID));
    }

    override protected function preTransitionIn():void {

        super.preTransitionIn();
        _highlightNewestMission = extraInfo;
        //_playMissionFlow = false;

        var campaignDataTable:Dictionary = Game.database.gamedata.getTable(DataType.CAMPAIGN);
        WorldMapView(baseView).globalMap.initData(campaignDataTable);

        Manager.display.showModule(ModuleID.TOP_BAR, new Point(0, 0), LayerManager.LAYER_TOP,
                "top_left", Layer.NONE);
        //HUDModule(modulesManager.getModuleByID(ModuleID.HUD)).setVisiableButtonHUD([HUDButtonID.WORLD_MAP.name], false);

    }

    //TUTORIAL
    public function showHintBtn():void
    {
        if(baseView)
            WorldMapView(baseView).showHintBtn();
    }

    public function getRewardStatus(index:int = 0):int
    {
        if(baseView)
            return  WorldMapView(baseView).getRewardStatus(index);

        return 0;
    }
}

}