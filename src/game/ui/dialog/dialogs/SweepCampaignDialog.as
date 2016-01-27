/**
 * Created by NinhNQ on 8/25/2014.
 */
package game.ui.dialog.dialogs {
import core.Manager;
import core.display.layer.Layer;
import core.display.layer.LayerManager;
import core.event.EventEx;
import core.util.FontUtil;
import core.util.Utility;

import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.events.TextEvent;
import flash.geom.Point;
import flash.text.TextField;

import game.Game;
import game.data.vo.campaign_sweep.SweepInfo;
import game.data.xml.MissionXML;
import game.enum.DialogEventType;
import game.enum.FlowActionEnum;
import game.enum.Font;
import game.enum.GameConfigID;
import game.enum.PaymentType;
import game.net.IntResponsePacket;
import game.net.RequestPacket;
import game.net.ResponsePacket;
import game.net.Server;
import game.net.lobby.LobbyRequestType;
import game.net.lobby.LobbyResponseType;
import game.net.lobby.request.RequestSweepCampaign;
import game.net.lobby.response.ResponseGetSweepingCampaignReward;
import game.ui.ModuleID;
import game.ui.dialog.DialogID;
import game.ui.worldmap.gui.MissionUI;
import game.utility.TimerEx;

public class SweepCampaignDialog extends Dialog {
    public static const SWEEPING:int = 0; //dang can quet
    public static const INIT:int = 1; // chua bat dau can quet
    public static const FINISHED:int = 2; // da hoan thanh dot can quet hien tai

    public var numOfSweepTf:TextField;
    public var timeTf:TextField;
    public var stopCountDownTf:TextField;
    public var startBtn:SimpleButton;
    public var stopBtn:SimpleButton;
    public var quickFinishBtn:SimpleButton;
    public var missionUI:MissionUI;
    public var rewardList:SweepRewardList;

    private var totalTime:int = 0; // Tong thoi gian can quet
    private var sweepTime:int = 0; // Thoi gian 1 lan can quet
    private var pauseTime:int = 0; // Thoi gian giua 2 lan dung can quet (giay)
    private var timerID:int = -1;
    private var pauseTimerID:int = -1;

    public function SweepCampaignDialog()
    {
        addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
        FontUtil.setFont(numOfSweepTf, Font.ARIAL);
        FontUtil.setFont(timeTf, Font.ARIAL);
        FontUtil.setFont(stopCountDownTf, Font.ARIAL);
        numOfSweepTf.restrict = "0-9";
        timeTf.text = Utility.math.formatTime("M-S", totalTime);
	    stopCountDownTf.visible = false;

        numOfSweepTf.addEventListener(Event.CHANGE, numOfSweepTf_textInputHandler);
        numOfSweepTf.addEventListener(FocusEvent.FOCUS_OUT, numOfSweepTf_focusOutHandler);
        numOfSweepTf.addEventListener(MouseEvent.CLICK, numOfSweepTf_clickHandler);

        stopBtn.addEventListener(MouseEvent.CLICK, stopBtn_clickHandler);
        stopBtn.visible = false;
    }

    override public function onShow():void {
        switch (info.state) {
            case INIT:
                Utility.setGrayscale(quickFinishBtn, true);
                startBtn.addEventListener(MouseEvent.CLICK, startBtn_clickHandler);
                break;
            case FINISHED:
                stopCountDown();
                Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_CAMPAIGN_SWEEP_REWARD));
                break;
            case SWEEPING:
                startCountDown();
                Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_CAMPAIGN_SWEEP_REWARD));
                break;
        }

        missionUI = new MissionUI(info.missionXML);
        missionUI.x = (this.width - 69 - rewardList.width) / 2;
        missionUI.y = 50;
        missionUI.status = MissionUI.UNLOCK;

        if (Game.database.userdata.finishedMissions[info.missionXML.ID] != null) {
            missionUI.setAchiveStar(Game.database.userdata.finishedMissions[info.missionXML.ID]);
        }

        missionUI.enableQuickFinish = false;

        addChild(missionUI);
    }

    //Event handlers

    private function addedToStageHandler(event:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

        addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
        Game.network.lobby.addEventListener(Server.SERVER_DATA, server_dataHandler);
    }

    private function removedFromStageHandler(event:Event):void {

        removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);

        addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
        Game.network.lobby.removeEventListener(Server.SERVER_DATA, server_dataHandler);

        removeChild(missionUI);
    }

    private function numOfSweepTf_textInputHandler(event:Event):void {
        var maxSweep:int = Game.database.gamedata.getConfigData(GameConfigID.CAMPAIGN_MAX_SWEEP) as int;
        numOfSweepTf.text = (parseInt(numOfSweepTf.text) <= maxSweep) ? numOfSweepTf.text : maxSweep.toString();
        numOfSweepTf.text = (parseInt(numOfSweepTf.text) != 0) ? numOfSweepTf.text : "1";

        var sweepTime:int = Game.database.gamedata.getConfigData(GameConfigID.CAMPAIGN_SWEEP_TIME) as int;
        var totalTime:int = sweepTime * parseInt(numOfSweepTf.text);

        timeTf.text = Utility.math.formatTime("M-S", totalTime);
    }

    private function numOfSweepTf_focusOutHandler(event:FocusEvent):void {
        numOfSweepTf.text = (numOfSweepTf.text == "") ? "1" : numOfSweepTf.text;
    }

    private function numOfSweepTf_clickHandler(event:MouseEvent):void {
        numOfSweepTf.setSelection(0, numOfSweepTf.length);
    }

    private function startBtn_clickHandler(event:MouseEvent):void {
        var numOfSweep:int = parseInt(numOfSweepTf.text);
        var missionID:int = getMissionID();

	    stopCountDownTf.visible = pauseTime > 0;

        rewardList.reset();

        Game.database.userdata.maxSweepTimes = numOfSweep;
        Game.network.lobby.sendPacket(new RequestSweepCampaign(missionID, numOfSweep));
    }


    private function quickFinishBtn_clickHandler(event:MouseEvent):void {
	    if(Game.database.userdata.vip >= 3)
	    {
		    var costPerSweep:int = Game.database.gamedata.getConfigData(GameConfigID.CAMPAIGN_SWEEP_QUICK_FINISH_COST) as int;

		    if(costPerSweep > Game.database.userdata.xu)
		    {
			    Game.flow.doAction(FlowActionEnum.PURCHASE_RESOURCE, PaymentType.XU_NORMAL.ID);
		    }
		    else
		    {
			    var timePerSweep:int = Game.database.gamedata.getConfigData(GameConfigID.CAMPAIGN_SWEEP_TIME) as int;
			    var remainSweeps:int = Math.ceil(totalTime/timePerSweep);

			    var data:Object = { type:DialogEventType.CONFIRM_REFRESH_TIME_DAILY_QUEST, cost: costPerSweep * remainSweeps };
			    Manager.display.showDialog(DialogID.YES_NO,
					    function(data:Object):void
					    {
						    Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.CAMPAIGN_QUICK_SWEEP)); // response se nhan tai onReceiveQuickSweepInfo()
					    }
					    , null,data );
		    }
	    }
	    else
	    {
		    Manager.display.showMessage("Cần đạt VIP 3 trở lên để Hoàn Thành Nhanh");
	    }
    }

    private function stopBtn_clickHandler(event:MouseEvent):void {
	    pauseTime = 10;

	    TimerEx.stopTimer(pauseTimerID);
	    pauseTimerID = TimerEx.startTimer(1000,pauseTime,function():void
		{
			stopCountDownTf.text = Utility.math.formatTime("M-S", pauseTime--);
	    }
		,function():void
		{
			stopCountDownTf.visible = false;
			stopBtn.mouseEnabled = true;
		    Utility.setGrayscale(stopBtn, false);
	    });

	    stopBtn.mouseEnabled = false;
	    Utility.setGrayscale(stopBtn, true);
        Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.CAMPAIGN_CANCEL_SWEEP ));
    }

    // Data Server

    private function server_dataHandler(event:EventEx):void {
        var packet:ResponsePacket = ResponsePacket(event.data);
        switch (packet.type) {
            case LobbyResponseType.CAMPAIGN_SWEEP:
                onReceiveSweepInfo(packet as IntResponsePacket);
                break;
            case LobbyResponseType.CAMPAIGN_CANCEL_SWEEP:
                onReceiveCancelSweepInfo(packet as IntResponsePacket);
                break;
            case LobbyResponseType.CAMPAIGN_QUICK_SWEEP:
                onReceiveQuickSweepInfo(packet as ResponseGetSweepingCampaignReward);
                break;
            case LobbyResponseType.GET_SWEEP_CAMPAIGN_REWARD:
                onReceiveRewardInfo(packet as ResponseGetSweepingCampaignReward);
                break;
        }
    }

    private function onReceiveRewardInfo(responseGetSweepingCampaignReward:ResponseGetSweepingCampaignReward):void {

        Utility.log("onReceiveRewardInfo : " + responseGetSweepingCampaignReward.result);
        switch (responseGetSweepingCampaignReward.result) {
            case 0://success
                rewardList.setData(responseGetSweepingCampaignReward);
                break;
            case 1://fail

                break;
        }
    }

    private function onReceiveQuickSweepInfo(responseQuickSweepingCampaign:ResponseGetSweepingCampaignReward):void {

        Utility.log("onReceiveQuickSweepInfo : " + responseQuickSweepingCampaign.result);
        switch (responseQuickSweepingCampaign.result) {
            case 0://success
                stopCountDown();
                rewardList.setData(responseQuickSweepingCampaign);
                break;
            case 1://fail

                break;
            case 2://not enough xu
                Game.flow.doAction(FlowActionEnum.PURCHASE_RESOURCE, PaymentType.XU_NORMAL.ID);
                break;
            case 3://not enough AP
                purchaseAP();
                break;
        }
    }

    private function onReceiveCancelSweepInfo(intResponsePacket:IntResponsePacket):void {

        Utility.log("onReceiveCancelSweepInfo : " + intResponsePacket.value);
        switch (intResponsePacket.value) {
            case 0://success
                stopCountDown();
                break;
            case 1://fail

                break;
        }
    }

    private function onReceiveSweepInfo(intResponsePacket:IntResponsePacket):void {

        Utility.log("onReceiveSweepInfo : " + intResponsePacket.value);
        switch (intResponsePacket.value) {
            case 0://success
                startCountDown();
                rewardList.setData(new ResponseGetSweepingCampaignReward());
                Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_PLAYER_INFO));
                break;
            case 1://fail

                break;
            case 2://wrong mission id

                break;
            case 3://not complete misson yet

                break;
            case 4://not enough ap
                purchaseAP();
                break;
        }
    }

    private function purchaseAP():void
    {
        var obj:Object = {};
        obj.title = "Thông Báo";
        obj.message = "Không đủ điểm Hoạt Động. Đại hiệp mua thêm nhé ?";
        obj.option = YesNo.YES | YesNo.CLOSE;

        Manager.display.showDialog(DialogID.YES_NO, agreeToBuyAP, null, obj, Layer.BLOCK_BLACK);
    }

    private function agreeToBuyAP(data:Object):void {
        Manager.display.showModule(ModuleID.HEAL_AP, new Point(0, 0), LayerManager.LAYER_TOP, "top_left", Layer.BLOCK_BLACK);
    }

    private function startCountDown():void {
        sweepTime = Game.database.gamedata.getConfigData(GameConfigID.CAMPAIGN_SWEEP_TIME) as int;
        totalTime = sweepTime * Game.database.userdata.maxSweepTimes - Game.database.userdata.elapsedSweepingTime;

        sweepTime -= Game.database.userdata.elapsedSweepingTime % sweepTime; // cap nhat lai thoi gian con lai cua lan can quet hien tai

        TimerEx.stopTimer(timerID);
        timerID = TimerEx.startTimer(1000, totalTime, updateTime, finishSweep);

        Utility.setGrayscale(startBtn, true);
        Utility.setGrayscale(quickFinishBtn, false);

        startBtn.removeEventListener(MouseEvent.CLICK, startBtn_clickHandler);
        startBtn.visible = false;
        stopBtn.visible = true;
        cancelBtn.visible = false;
        quickFinishBtn.addEventListener(MouseEvent.CLICK, quickFinishBtn_clickHandler);
    }

    private function stopCountDown():void {
        TimerEx.stopTimer(timerID);

        Utility.setGrayscale(quickFinishBtn, true);
        Utility.setGrayscale(startBtn, false);

        startBtn.addEventListener(MouseEvent.CLICK, startBtn_clickHandler);
        startBtn.visible = true;
        stopBtn.visible = false;
        cancelBtn.visible = true;
        quickFinishBtn.removeEventListener(MouseEvent.CLICK, quickFinishBtn_clickHandler);
    }

    private function finishSweep():void {
        Utility.setGrayscale(quickFinishBtn, true);
        Utility.setGrayscale(startBtn, false);

        quickFinishBtn.removeEventListener(MouseEvent.CLICK, quickFinishBtn_clickHandler);
        startBtn.visible = true;
        stopBtn.visible = false;
        cancelBtn.visible = true;
        startBtn.addEventListener(MouseEvent.CLICK, startBtn_clickHandler);
    }

    private function updateTime():void {
        timeTf.text = Utility.math.formatTime("M-S", --totalTime);

        if(--sweepTime <= 0)
        {
            //Hoan tat 1 lan can quet -> lay phan thuong tu server
            sweepTime = Game.database.gamedata.getConfigData(GameConfigID.CAMPAIGN_SWEEP_TIME) as int;

            Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_CAMPAIGN_SWEEP_REWARD));
            Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_PLAYER_INFO));
        }

        rewardList.setTime(Utility.math.formatTime("M-S", sweepTime));
    }

    private function getMissionID():int {
        var missonXML:MissionXML = info.missionXML as MissionXML;
        return missonXML.ID;
    }

    private function get info():SweepInfo
    {
        return data as SweepInfo;
    }
}
}
