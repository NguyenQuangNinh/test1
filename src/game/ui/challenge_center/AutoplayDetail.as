package game.ui.challenge_center
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import core.Manager;
	import core.util.FontUtil;
	
	import game.Game;
	import game.data.xml.DataType;
	import game.data.xml.ModeConfigXML;
	import game.data.xml.config.ChallengeCenterConfig;
	import game.data.xml.config.XMLConfig;
	import game.enum.Font;
	import game.ui.components.Reward1;
	
	public class AutoplayDetail extends MovieClip
	{
		public static const TIMER_COMPLETE:String = "timer_complete";
		
		public var txtFloor:TextField;
		public var txtTime:TextField;
		public var containerRewards:MovieClip;
		
		private var timer:Timer;
		private var currentTick:int;
		private var currentFloor:int;
		
		public function AutoplayDetail()
		{
			FontUtil.setFont(txtFloor, Font.TAHOMA, true);
			FontUtil.setFont(txtTime, Font.TAHOMA, true);
			
			timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, onTimerTick);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
		}
		
		protected function onTimerComplete(event:TimerEvent):void
		{
			dispatchEvent(new Event(TIMER_COMPLETE, true));
		}
		
		protected function onTimerTick(event:TimerEvent):void
		{
			txtTime.text = "(" + --currentTick + " giây)";
		}
		
		public function complete(rewardList:Array):void
		{
			txtFloor.text = "Tầng " + (currentFloor) + ": Hoàn thành";
			txtTime.text = "";
			var currentX:int = 0;
			for(var i:int = 0; i < rewardList.length; ++i)
			{
				var reward:Reward1 = Manager.pool.pop(Reward1) as Reward1;
				reward.setData(rewardList[i]);
				reward.x = currentX;
				currentX += reward.txtQuantity.textWidth + 40;
				containerRewards.addChild(reward);
			}
			cancel();
		}
		
		public function cancel():void
		{
			timer.stop();
		}
		
		public function reset():void
		{
			while(containerRewards.numChildren > 0)
			{
				var reward:Reward1 = containerRewards.removeChildAt(0) as Reward1;
				Manager.pool.push(reward, Reward1);
			}
			timer.reset();
		}
		
		public function setData(floor:int):void
		{
			currentFloor = floor;
			txtFloor.text = "Tầng " + (floor) + ": Đang chinh phạt...";
			var modeData:ModeConfigXML = Game.database.gamedata.getData(DataType.MODE_CONFIG, XMLConfig.CHALLENGE_CENTER) as ModeConfigXML;
			if(modeData != null)
			{
				var config:ChallengeCenterConfig = modeData.xmlConfig as ChallengeCenterConfig;
				if(config != null) currentTick = config.autoTime;
			}
			txtTime.text = "(" + currentTick + " giây)";
			timer.repeatCount = currentTick;
			timer.start();
		}
	}
}