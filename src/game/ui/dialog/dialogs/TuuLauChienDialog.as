package game.ui.dialog.dialogs 
{
	import core.event.EventEx;
	import core.util.Enum;
	import core.util.FontUtil;
	import core.util.TextFieldUtil;
	import core.util.Utility;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	import game.data.vo.challenge.HistoryInfo;
	import game.data.vo.tuu_lau_chien.ResourceInfo;
	import game.data.xml.DataType;
	import game.data.xml.GameConfig;
	import game.data.xml.MissionXML;
	import game.enum.Font;
	import game.enum.GameConfigID;
	import game.enum.ResourceInfoType;
	import game.enum.TuuLauType;
	import game.Game;
	import game.utility.GameUtil;
	
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class TuuLauChienDialog extends Dialog
	{		
		public static const ON_REQUEST_ACTIVE_PROTECT_RESOURCE:String = "requestActiveProtectResource";
		public static const ON_REQUEST_ACTIVE_BUFF_RESOURCE:String = "requestActiveBuffResource";
		public static const ON_REQUEST_CANCEL_OCCUPY_RESOURCE:String = "requestCancelOccupyResource";
		public static const ON_REQUEST_ATTACK_RESOURCE:String = "requestAttackResource";
		public static const ON_REQUEST_OCCUPY_RESOURCE:String = "requestOccupyResource";
		
		public static const OCCUPY_RESOURCE_COMPLETED_DIALOG:String = "occupyResourceCompletedDialog";
		
		private static const PLAYER_DIALOG_TYPE:String = "player_dialog_type";
		private static const NPC_DIALOG_TYPE:String = "npc_dialog_type";
		private static const OWNER_DIALOG_TYPE:String = "owner_dialog";
		
		private static const HISTORY_START_FROM_X:int = 6;
		private static const HISTORY_START_FROM_Y:int = 50;
		private static const HISTORY_DISTANCE_FROM_Y:int = 100;
		
		public var closeBtn: SimpleButton;
		public var resourceNameTf: TextField;
		public var ownerTf: TextField;
		public var timeTf: TextField;
		public var numOccupyTf: TextField;
		public var numReceiveTf: TextField;
		
		public var protectMov: MovieClip;
		public var buffMov: MovieClip;
		
		public var leftActionMov: MovieClip;
		public var centerActionMov: MovieClip;
		public var rightActionMov: MovieClip;
		
		//public var historyMov: MovieClip;
		
		private var _dialogType:String = OWNER_DIALOG_TYPE;
		private var _info:ResourceInfo;
		
		private var _maxTimeOccupiedPerResource:int;
		private var _timerOccupied:Timer;
		private var _timeOccupied:int;	
		private var _timerAvailable:Timer;
		private var _remainAvailable:int;
		
		public function TuuLauChienDialog() 
		{
			initUI();
			
			_maxTimeOccupiedPerResource = Game.database.gamedata.getConfigData(GameConfigID.MAX_TIME_OCCUPY_PER_RESOURCE) as int;	//base count in hour ---> need convert to second before use
		}
		
		private function initUI():void 
		{
			//set font
			FontUtil.setFont(resourceNameTf, Font.ARIAL, false);
			FontUtil.setFont(ownerTf, Font.ARIAL, false);
			FontUtil.setFont(timeTf, Font.ARIAL, false);
			FontUtil.setFont(numOccupyTf, Font.ARIAL, false);
			FontUtil.setFont(numReceiveTf, Font.ARIAL, false);
			
			leftActionMov.buttonMode = true;
			centerActionMov.buttonMode = true;
			rightActionMov.buttonMode = true;
			
			//add events
			leftActionMov.addEventListener(MouseEvent.CLICK, onActionClickHdl);
			centerActionMov.addEventListener(MouseEvent.CLICK, onActionClickHdl);
			rightActionMov.addEventListener(MouseEvent.CLICK, onActionClickHdl);		
			
			//protectMov.addEventListener(MouseEvent.CLICK, onProtectClickHdl);			
			//buffMov.addEventListener(MouseEvent.CLICK, onBuffClickHdl);			
			closeBtn.addEventListener(MouseEvent.CLICK, onCloseClickHdl);		
			
			//init timer
			_timerOccupied = new Timer(1000);
			_timerOccupied.addEventListener(TimerEvent.TIMER, onTimerOccupiedUpdateHdl);
			
			_timerAvailable = new Timer(1000);
			_timerAvailable.addEventListener(TimerEvent.TIMER, onTimerAvailableUpdateHdl);
		}
		
		private function onCloseClickHdl(e:MouseEvent):void 
		{
			this.close();
			this.stopOccupiedCountDown();
			this.stopAvailableCountDown();
		}
		
		/*private function onBuffClickHdl():void 
		{
			//check if active or not --> request server to active
		}
		
		private function onProtectClickHdl():void 
		{			
			//check if active or not --> request server to active
		}*/
		
		private function onActionClickHdl(e:MouseEvent):void 
		{
			var target:MovieClip = e.target as MovieClip;
			
			switch(target.currentFrameLabel)
			{
				case "protect":
					if (_info)
					{						
						dispatchEvent(new EventEx(ON_REQUEST_ACTIVE_PROTECT_RESOURCE, _info, true));
					}
					break;
				case "buff":
					if (_info)
					{
						dispatchEvent(new EventEx(ON_REQUEST_ACTIVE_BUFF_RESOURCE, _info, true));
					}
					break;
				case "exit":
					if (_info)
					{
						dispatchEvent(new EventEx(ON_REQUEST_CANCEL_OCCUPY_RESOURCE, _info, true));
					}
					break;
				case "attack":
					if (_info)
					{
						dispatchEvent(new EventEx(ON_REQUEST_ATTACK_RESOURCE, _info, true));
					}
					break;
				case "occupy":
					if (_info)
					{
						dispatchEvent(new EventEx(ON_REQUEST_OCCUPY_RESOURCE, _info, true));
					}
					break;
				case "cancel":
					//hide this dialog
					this.close();
					break;
			}
		}
		
		private function changeDialogType(type:String):void 
		{
			if (type == OWNER_DIALOG_TYPE || type == PLAYER_DIALOG_TYPE || type == NPC_DIALOG_TYPE)
			{
				_dialogType = type;
				
				//init UI
				Utility.setGrayscale(leftActionMov, false);
				leftActionMov.mouseEnabled = true;
				Utility.setGrayscale(centerActionMov, false);
				centerActionMov.mouseEnabled = true;
				Utility.setGrayscale(rightActionMov, false);
				rightActionMov.mouseEnabled = true;
				
				timeTf.text = "";
				stopOccupiedCountDown();
				numOccupyTf.text = "";
				stopAvailableCountDown();
				numReceiveTf.text = "";
				
				switch(_dialogType)
				{
					case OWNER_DIALOG_TYPE:
						leftActionMov.gotoAndStop("protect");						
						centerActionMov.gotoAndStop("buff");					
						rightActionMov.gotoAndStop("exit");
						//historyMov.visible = true;
						break;
					case PLAYER_DIALOG_TYPE:
						leftActionMov.gotoAndStop("attack");						
						centerActionMov.gotoAndStop("occupy");						
						rightActionMov.gotoAndStop("cancel");
						//historyMov.visible = false;
						
						break;
					case NPC_DIALOG_TYPE:					
						leftActionMov.gotoAndStop("attack");
						Utility.setGrayscale(leftActionMov, true);
						leftActionMov.mouseEnabled = false;
						
						centerActionMov.gotoAndStop("occupy");
						rightActionMov.gotoAndStop("cancel");
						//historyMov.visible = false;	
						break;
				}
			}
			else {
				Utility.log("unknow dialog type for this");
			}
			
		}
		
		override public function set data(value:Object):void 
		{			
			_info = value.data as ResourceInfo;
			if (_info)
			{
				if (_info.ownerID == Game.database.userdata.userID)
				{
					changeDialogType(OWNER_DIALOG_TYPE);
					//disable button if action had done before
					if (_info.activeProtected)
					{						
						Utility.setGrayscale(leftActionMov, true);
						leftActionMov.mouseEnabled = false;
					}
					else 
					{
						Utility.setGrayscale(leftActionMov, false);
						leftActionMov.mouseEnabled = true;
					}
					
					if (_info.activeBuffed)
					{
						Utility.setGrayscale(centerActionMov, true);
						centerActionMov.mouseEnabled = false;						
					}
					else 
					{
						Utility.setGrayscale(centerActionMov, false);
						centerActionMov.mouseEnabled = true;
					}
					
				}
				else if(_info.ownerID > 0)
				{
					changeDialogType(PLAYER_DIALOG_TYPE);
				}
				else 
				{
					changeDialogType(NPC_DIALOG_TYPE);
				}
				
				//update display
				var missionData:MissionXML = Game.database.gamedata.getData(DataType.MISSION, _info.id) as MissionXML;
				//var maxOccupyPerDay:int = Game.database.gamedata.getConfigData(GameConfigID.MAX_NUM_OCCUPY_IN_DAY_PER_RESOURCE);
				var temp:String = Enum.getEnum(ResourceInfoType, missionData.quality).name;
				var timeReceive:int = Game.database.gamedata.getConfigData(GameConfigID.TIME_RECEIVE_REWARD_OCCUPIED_RESOURCE) as int;
				var arrPercentReward:Array = Game.database.gamedata.getConfigData(GameConfigID.ARRAY_PERCENT_REWARD_PER_RESOURCE_TYPE) as Array;
				var arrRewardPerCampaign:Array = Game.database.gamedata.getConfigData(GameConfigID.ARRAY_REWARD_PER_CAMPAIGN_TYPE) as Array;
				var tuuLau:TuuLauType = GameUtil.getTuuLauFit();
				
				var receiveValue:int = 0;
				var rewardStr:String = "";
				
				if (_info.timeOccupied > 0)
				{
					_timeOccupied = /*_maxTimeOccupiedPerResource * 3600 -*/ _info.timeOccupied;
					startTimerOccupiedCountDown();					
				}
				
				if (_info.nextTimeCanOccupied > 0)
				{
					_remainAvailable = _info.nextTimeCanOccupied;
					startTimerAvailableCountDown();
				}
				
				if (arrPercentReward && arrPercentReward.length >= missionData.quality)
				{
					var baseIndex:int = tuuLau ? Enum.getEnumIndexByID(TuuLauType, tuuLau.ID) : -1;
					var baseValue:int = baseIndex > 0 && arrPercentReward && baseIndex < arrPercentReward.length ? arrRewardPerCampaign[baseIndex] : 0;
					rewardStr = " (" + (arrPercentReward[missionData.quality] * baseValue / 100) + " bạc/" + timeReceive + " phút)";
					//convert time occupied to num resource receive
					//receiveValue = Math.floor(_timeOccupied / (timeReceive * 60)) * (arrPercentReward[missionData.quality] * baseValue / 100) * (_info.activeBuffed ? 2 : 1);
					receiveValue = _info.resAccumulate;
				}
				resourceNameTf.text = temp + rewardStr;
				ownerTf.text = _info.ownerName != "" ? _info.ownerName : missionData.name;
				numReceiveTf.text = receiveValue > 0 ? receiveValue + " bạc" : "";
				if (_info.ownerID != 0)				
				{
					numOccupyTf.text = "Còn " + (/*maxOccupyPerDay - */_info.numOccupied) + " lần";
				}							
				
				buffMov.gotoAndStop(_info.activeBuffed ? "actived" : "un_active");
				protectMov.gotoAndStop(_info.activeProtected ? "actived" : "un_active");							
			}
		}		
		
		public function stopOccupiedCountDown():void {
			_timerOccupied.stop();
		}
		
		public function stopAvailableCountDown():void {
			_timerAvailable.stop();
		}
		
		public function startTimerOccupiedCountDown():void {
			Utility.log( "TuuLauChienDialog.startTimerOccupiedCountDown " + _timeOccupied);
			_timerOccupied.start();
		}
		
		public function startTimerAvailableCountDown():void {
			Utility.log( "TuuLauChienDialog.startTimerAvailableCountDown " + _remainAvailable);
			_timerAvailable.start();
		}
		
		private function onTimerOccupiedUpdateHdl(e:TimerEvent):void 
		{
			_timeOccupied = _timeOccupied > 0 ? _timeOccupied + 1 : 0;
			timeTf.text = Utility.math.formatTime("H-M", _timeOccupied) + " phút";
			//Utility.log("mission on update timer from missionInfoUI: " + timeTf.text);
			var missionData:MissionXML = Game.database.gamedata.getData(DataType.MISSION, _info.id) as MissionXML;
			var timeReceive:int = Game.database.gamedata.getConfigData(GameConfigID.TIME_RECEIVE_REWARD_OCCUPIED_RESOURCE) as int;			
			var arrPercentReward:Array = Game.database.gamedata.getConfigData(GameConfigID.ARRAY_PERCENT_REWARD_PER_RESOURCE_TYPE) as Array;
			var arrRewardPerCampaign:Array = Game.database.gamedata.getConfigData(GameConfigID.ARRAY_REWARD_PER_CAMPAIGN_TYPE) as Array;
			var tuuLau:TuuLauType = GameUtil.getTuuLauFit();
			var baseIndex:int = tuuLau ? Enum.getEnumIndexByID(TuuLauType, tuuLau.ID) : -1;
			var baseValue:int = baseIndex > 0 && arrPercentReward && baseIndex < arrPercentReward.length ? arrRewardPerCampaign[baseIndex] : 0;
			//var receiveValue:int = Math.floor(_timeOccupied / (timeReceive * 60)) * (arrPercentReward[missionData.quality] * baseValue / 100) * (_info.activeBuffed ? 2 : 1);
			var receiveValue:int = _info.resAccumulate;
			numReceiveTf.text = receiveValue > 0 ? receiveValue + " bạc" : "";
			if (_timeOccupied >= _maxTimeOccupiedPerResource * 3600) {
				_timerOccupied.stop();
				dispatchEvent(new EventEx(OCCUPY_RESOURCE_COMPLETED_DIALOG, _info, true));
			}
		}
		
		private function onTimerAvailableUpdateHdl(e:TimerEvent):void 
		{
			_remainAvailable = _remainAvailable > 0 ? _remainAvailable - 1 : 0;
			numOccupyTf.text = Utility.math.formatTime("M-S", _remainAvailable) + " giây";
			//Utility.log("mission on update timer from missionInfoUI: " + timeTf.text);
			
			if (_remainAvailable <= 0) {
				_timerAvailable.stop();
				//dispatchEvent(new EventEx(OCCUPY_RESOURCE_COMPLETED_DIALOG, _info, true));
				numOccupyTf.text = "Còn " + (/*maxOccupyPerDay - */_info.numOccupied) + " lần";
			}
		}
		
		private function parseTime(time:String):String {
			//var index:int = time.indexOf("T");
			//return time.substr(index,time.length);
			var split:Array = time.split("T");
			var temp:String = split[1];
			
			//var milliseconds:int = parseInt(temp);			
			//var hours:int = minutes / 60;
			//var minutes:int = seconds / 60;
			//var seconds:int = milliseconds / 1000;
			var hours:String = temp.substr(0, 2);
			var minutes:String = temp.substr(2, 2);
			var seconds:String = temp.substr(4, 2);
			
			//seconds %= 60;
			//minutes %= 60;
			
			return hours + "h:" + minutes + "m";
		}
		
		override public function get data():Object
		{
			return _info;
		}
		
		public function lock():void
		{
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		public function unlock():void
		{
			this.mouseEnabled = true;
			this.mouseChildren = true;
		}
	}

}