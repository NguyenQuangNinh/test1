package game.ui.arena
{
	import core.display.BitmapEx;
	import core.event.EventEx;
	import core.Manager;
	import core.util.Enum;
	import core.util.MovieClipUtils;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.utils.Dictionary;
	import game.data.xml.DataType;
	import game.data.xml.ModeConfigXML;
	import game.enum.GameMode;
	import game.Game;
	
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ModeSelect extends MovieClip
	{
		
		/*public var btnMode_1:SimpleButton;
		   public var btnMode_2:SimpleButton;
		   public var btnMode_3:SimpleButton;
		   public var btnMode_4:SimpleButton;
		
		   public var timeInfo_1:TimeInfo;
		   public var timeInfo_2:TimeInfo;
		   public var timeInfo_3:TimeInfo;
		 public var timeInfo_4:TimeInfo;*/
		
		private static const MODE_START_FROM_X:int = 0;
		private static const MODE_START_FROM_Y:int = 0;
		private static const TIME_INFO_START_FROM_X:int = 230;
		private static const DISTANCE_PER_MODE_BTN:int = 87;
		
		private var _modeContainer:MovieClip;
		private var _modesArray:Array = [];
		private var _timesArray:Array = []
		private var _modesInfo:Array = [];
		private var _modeSelected:GameMode;
		private var _glow:GlowFilter;
		
		//private var _modesInvalid:Array = [];
		//private var _modeSelected:int = -1;
		
		//private var _isInited:Boolean = false;
		
		public function ModeSelect()
		{
			/*if (stage)
			   init();
			 else */
			//addEventListener(Event.ADDED_TO_STAGE, init);	
			initUI();
		}
		
		private function init(e:Event):void
		{
			//removeEventListener(Event.ADDED_TO_STAGE, init);
			//initUI();			
		}
		
		private function initUI():void
		{
			//if (!_isInited) {
			//effect
			_glow = new GlowFilter();
			_glow.strength = 3;
			_glow.blurX = _glow.blurY = 10;
			_glow.color = 0xFFFF00;
			
			//create mode should consider about time open / close --> not show all
			//Utility.log("mode select is inited");
			_modeContainer = new MovieClip();
			_modeContainer.x = MODE_START_FROM_X;
			_modeContainer.y = MODE_START_FROM_Y;
			addChild(_modeContainer);
			
			var modeXMLs:Dictionary = Game.database.gamedata.getTable(DataType.MODE_CONFIG);
			//filter all mode duplicate type
			var filters:Array = [];
			for each (var modeXML:ModeConfigXML in modeXMLs)
			{
				if (modeXML.display)
					filters.push(modeXML);
			}
			if (modeXMLs)
			{
				var count:int = 0;
				for each (modeXML in filters)
				{
					var modeMov:MovieClip = new MovieClip();
					var container:MovieClip = new MovieClip();
					var timeMov:TimeInfo = new TimeInfo();
					timeMov.mouseEnabled = false;
					timeMov.mouseChildren = false;
					var bitmap:BitmapEx = new BitmapEx();
					//bitmap.scaleX = bitmap.scaleY = 0.86;
					modeMov.y = count * DISTANCE_PER_MODE_BTN;
					timeMov.x = TIME_INFO_START_FROM_X;
					timeMov.y = modeMov.y + 5;
					container.addChild(modeMov);
					container.addChild(timeMov);
					_modeContainer.addChild(container);
					modeMov.addChild(bitmap);
					timeMov.update(modeXML.timeOpen, modeXML.timeClose);
					bitmap.load(modeXML.shortImage);
					modeMov.buttonMode = true;
					modeMov.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
					_modesArray.push(modeMov);
					_modesInfo.push(modeXML);
					_timesArray.push(timeMov);
					count++;
				}
			}
			//_isInited = true;
			//}
		}
		
		private function onBtnClickHdl(e:MouseEvent):void
		{
			var index:int = _modesArray.indexOf(e.target);
			if (index >=0 && index < _modesInfo.length)
			{
				var modeConfigXML:ModeConfigXML = _modesInfo[index] as ModeConfigXML;		
				if (modeConfigXML)
				{
					var mode:int = index > -1 ? modeConfigXML.type : -1;
					setModeSelected(Enum.getEnum(GameMode, mode) as GameMode);
				}
			}
		}
		
		public function getModeSelected():GameMode
		{
			return _modeSelected;
		}
		
		public function setModeSelected(mode:GameMode):void
		{
			_modeSelected = mode;
			var modeMov:MovieClip;
			var indexBtn:int = -1;
			
			for each (var modeInfo:ModeConfigXML in _modesInfo)
			{
				if (modeInfo.type == mode.ID)
				{
					indexBtn = _modesInfo.indexOf(modeInfo);
					break;
				}
			}
			
			if (indexBtn > -1 && indexBtn < _modesArray.length)
			{
				//reset filter
				for (var i:int = 0; i < _modesArray.length; i++)
				{
					modeMov = _modesArray[i] as MovieClip;
					var containerMode:MovieClip = _modeContainer.getChildAt(indexBtn) as MovieClip;
					if (containerMode.mouseEnabled == true && containerMode.mouseChildren == true)
						modeMov.filters = [];
				}
				//set filter for mode selected
				modeMov = _modesArray[indexBtn];
				if (containerMode.mouseEnabled == true && containerMode.mouseChildren == true)
					modeMov.filters = [_glow];
				
				dispatchEvent(new EventEx(ArenaEventName.MODE_SELECTED, _modeSelected, true));
			}
		}
		
		/*public function checkModeValid():void
		{
			var timeNow:Number = new Date().getTime() + Game.database.userdata.serverTimeDifference;
			var currentDate:Date = new Date();
			currentDate.setTime(timeNow);
			
			for each (var modeXMl:ModeConfigXML in _modesInfo)
			{
				var valid:Boolean = modeXMl.checkValidTimeRequire(currentDate);
				var index:int = _modesInfo.indexOf(modeXMl);
				var modeMov:MovieClip = _modeContainer.getChildAt(index) as MovieClip;
				if (!valid)
				{
					MovieClipUtils.applyGrayScale(modeMov);
				}
				else
				{
					MovieClipUtils.removeAllFilters(modeMov);
				}
				modeMov.mouseEnabled = valid;
				modeMov.mouseChildren = valid;
			}
		}*/
	}

}