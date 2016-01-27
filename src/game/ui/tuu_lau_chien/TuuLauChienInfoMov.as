package game.ui.tuu_lau_chien 
{
	import core.event.EventEx;
	import core.util.Enum;
	import core.util.FontUtil;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import game.data.vo.tuu_lau_chien.ResourceInfo;
	import game.data.xml.DataType;
	import game.data.xml.MissionXML;
	import game.enum.Element;
	import game.enum.Font;
	import game.enum.GameConfigID;
	import game.Game;
	import core.util.MathUtil;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class TuuLauChienInfoMov extends MovieClip
	{
		
		public static const OCCUPY_RESOURCE_COMPLETED:String = "occupyResourceCompleted";
		
		public var countTf: TextField;
		public var timeTf: TextField;
		public var timeAttackTf:TextField;
		
		public var protectMov: MovieClip;
		public var buffMov: MovieClip;
		
		public var iconMov: TuuLauChienIconMov;
		private var _maxOccupyPerDay:int;
		
		private var _timerAttack:Timer;
		private var _remainAttack:int;
		
		private var _timerOccupied:Timer;
		private var _remainOccupied:int;		
		
		private var _maxTimeOccupiedPerResource:int;
		
		public function TuuLauChienInfoMov() 
		{
			initUI();
			
			_maxOccupyPerDay = Game.database.gamedata.getConfigData(GameConfigID.MAX_NUM_OCCUPY_IN_DAY_PER_PLAYER) as int;
			_maxTimeOccupiedPerResource = Game.database.gamedata.getConfigData(GameConfigID.MAX_TIME_OCCUPY_PER_RESOURCE) as int;	//base count in hour ---> need convert to second before use
		}
		
		private function initUI():void 
		{
			//set fonts 
			FontUtil.setFont(countTf, Font.ARIAL, false);
			FontUtil.setFont(timeTf, Font.ARIAL, false);
			FontUtil.setFont(timeAttackTf, Font.ARIAL, false);
			
			//add events
			//protectMov.addEventListener(MouseEvent.CLICK, onProtectClickHdl);
			//buffMov.addEventListener(MouseEvent.CLICK, onBuffClickHdl);
			
			//init timer
			_timerOccupied = new Timer(1000);
			_timerOccupied.addEventListener(TimerEvent.TIMER, onTimerOccupiedUpdateHdl);		
			
			_timerAttack = new Timer(1000);
			_timerAttack.addEventListener(TimerEvent.TIMER, onTimerAttackUpdateHdl);
			timeAttackTf.text = "00:00";
		}
		
		/*private function onProtectClickHdl(e:MouseEvent):void 
		{
			
		}
		
		private function onBuffClickHdl(e:MouseEvent):void 
		{
			
		}*/
		
		public function updateInfo(info:ResourceInfo):void 
		{			
			//update display
			if (info)
			{				
				countTf.text = Math.abs(_maxOccupyPerDay - info.numAttackPerDay/*Game.database.userdata.numAttackResourcePerDay*/) + "/" + _maxOccupyPerDay;
				
				buffMov.gotoAndStop(info.activeBuffed ? "actived" : "un_active");
				protectMov.gotoAndStop(info.activeProtected ? "actived" : "un_active");
				
				if (info.id > 0)
				{
					if (info.timeOccupied > 0)
					{
						_remainOccupied = /*_maxTimeOccupiedPerResource * 3600 -*/ info.timeOccupied;
						startCountOccupied();
					}
					
					iconMov.visible = true;
					iconMov.infoData = info;					
					iconMov.xmlData = Game.database.gamedata.getData(DataType.MISSION, info.id) as MissionXML;
					var mainCharacterElement:Element = Enum.getEnum(Element, Game.database.userdata.mainCharacter.element) as Element;
					iconMov.updateState(true, mainCharacterElement, Game.database.userdata.playerName);
				}
				else 
				{
					iconMov.visible = false;
					stopCountOccupied();
					timeTf.text = "";
				}
			}		
		}
			
		public function stopCountOccupied():void {
			_timerOccupied.stop();
		}
		
		public function startCountOccupied():void {
			Utility.log( "TuuLauChienInfoMov.startCountDown " + _remainOccupied);
			_timerOccupied.start();
		}
		
		private function onTimerOccupiedUpdateHdl(e:TimerEvent):void 
		{
			_remainOccupied = _remainOccupied > 0 ? _remainOccupied + 1 : 0;
			timeTf.text = Utility.math.formatTime("H-M", _remainOccupied) + " phút";
			//Utility.log("mission on update timer from missionInfoUI: " + timeTf.text);
			
			if (_remainOccupied >= _maxTimeOccupiedPerResource * 3600) {
				_timerOccupied.stop();
				dispatchEvent(new EventEx(OCCUPY_RESOURCE_COMPLETED, iconMov.infoData, true));
			}
		}
		
		public function checkTimeAttack():void 
		{
			var time:int = Game.database.userdata.timeRemainAttackResourceInfo;
			if (time > 0 && !_timerAttack.running)
			{
				_remainAttack = time;
				startCountAttack();
			}							
		}
		
		private function onTimerAttackUpdateHdl(e:TimerEvent):void 
		{
			_remainAttack = _remainAttack > 0 ? _remainAttack - 1 : 0;
			Game.database.userdata.timeRemainAttackResourceInfo = _remainAttack;
			timeAttackTf.text = Utility.math.formatTime("M-S", _remainAttack);
			
			if (_remainAttack == 0) {
				_timerAttack.stop();
				timeAttackTf.text = "00:00";
			}
		}	
		
		public function stopCountAttack():void 
		{
			_timerAttack.stop();
		}
		
		public function startCountAttack():void 
		{
			Utility.log( "TuuLauChienInfoMov.startCountDown " + _remainAttack);
			_timerAttack.start();
		}
		
	}

}