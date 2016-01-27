package game.ui.arena 
{
	//import components.ExComboBox;
	import core.display.BitmapEx;
	import core.event.EventEx;
	import core.util.FontUtil;
	import core.util.MovieClipUtils;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	//import game.data.enum.pvp.ModePVPEnum;
	import game.data.xml.DataType;
	import game.enum.GameMode;
	//import game.data.xml.ModePvPXML;
	import game.Game;
	//import fl.controls.ComboBox; 
	//import fl.data.DataProvider; 
	
	import game.enum.Font;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class CreateRoom extends MovieClip
	{
		private static const MODE_ITEM_START_FROM_X:int = 2;	
		private static const MODE_ITEM_START_FROM_Y:int = 5;	
			
		public var nameTf:TextField;
		public var modeTf:TextField;
		public var checkMov:MovieClip;
		//public var modeNameTf:TextField;
		//public var passTf:TextField;
		//public var titleModeMov:MovieClip;
		
		public var hitModeMov:MovieClip;
		public var hitPrivateMov:MovieClip;
		
		public var filterBG:MovieClip;
		
		//private var _filterModeMovs:Array = [];
		
		private var _modeSelect:GameMode = null;
		private var _mode:GameMode;
		
		public function CreateRoom() 
		{
			/*if (stage)
				init();
			else addEventListener(Event.ADDED_TO_STAGE, init);	*/
			initUI();
		}
		
		/*private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			initUI();
		}*/
		
		private function initUI():void 
		{
			//set fonts
			//FontUtil.setFont(modeNameTf, Font.ARIAL, true);
			//FontUtil.setFont(passTf, Font.ARIAL, true);
			//passTf.restrict = "0-9";
			
			//init combobox
			filterBG.visible = false;
			modeTf.mouseEnabled = false;
			filterBG.addEventListener(ModeItemMov.MODE_ITEM_SELECTED, onModeSelectedHdl);
			
			hitModeMov.buttonMode = true;
			hitModeMov.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			
			hitPrivateMov.buttonMode = true;
			hitPrivateMov.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			
			gotoAndStop("mode");
		}
		
		private function onModeSelectedHdl(e:EventEx):void 
		{
			var data:Object = e.data;
			if (data) {				
				filterBG.visible = false;
				modeTf.text = data.name;
				_modeSelect = data.mode;
			}
		}
		
		private function onBtnClickHdl(e:MouseEvent):void 
		{
			switch(e.target) {
				case hitModeMov:
					filterBG.visible = !filterBG.visible;					
					break;
				case hitPrivateMov:
					checkMov.visible = !checkMov.visible;
					break;
			}
		}
		
		private function updateFilterMode(mode:GameMode):void {
			if(filterBG.numChildren > 1)
				filterBG.removeChildren(1, filterBG.numChildren - 1);									
				
			var modeItem:ModeItemMov;
			switch(mode) {
				//case ModePVPEnum.PVP_FREE:
				case GameMode.PVP_FREE:
					gotoAndStop("mode");
					hitModeMov.mouseEnabled = true;
					modeItem = new ModeItemMov();
					modeItem.updateInfo("1 vs 1", GameMode.PVP_1vs1_FREE);
					modeItem.x = MODE_ITEM_START_FROM_X;
					modeItem.y = MODE_ITEM_START_FROM_Y;				
					_modeSelect = GameMode.PVP_1vs1_FREE;					
					filterBG.addChild(modeItem);
					
					modeItem.setActive();
					
					modeItem = new ModeItemMov();
					modeItem.updateInfo("3 vs 3", GameMode.PVP_3vs3_FREE);
					modeItem.x = MODE_ITEM_START_FROM_X;
					modeItem.y += modeItem.height + MODE_ITEM_START_FROM_Y;
					filterBG.addChild(modeItem);
					
					break;
				//case ModePVPEnum.PvP_3vs3_MM:
				case GameMode.PVP_3vs3_MM:
					gotoAndStop("no_mode");
					/*modeItem = new ModeItemMov();
					modeItem.updateInfo("3 vs 3", ModePVPEnum.PvP_3vs3_MM);
					modeItem.x = MODE_ITEM_START_FROM_X;
					modeItem.y = MODE_ITEM_START_FROM_Y;
					_modeSelect = ModePVPEnum.PvP_3vs3_MM;
					filterBG.addChild(modeItem);
					
					modeItem.setActive();*/
					hitModeMov.mouseEnabled = false;
					_modeSelect = GameMode.PVP_3vs3_MM;
					modeTf.text = "3 vs 3";
					break;
				//case ModePVPEnum.PvP_1vs1_MM:
				case GameMode.PVP_1vs1_MM:
					/*modeItem = new ModeItemMov();
					modeItem.updateInfo("1 vs 1", ModePVPEnum.PvP_1vs1_MM);
					modeItem.x = MODE_ITEM_START_FROM_X;
					modeItem.y = MODE_ITEM_START_FROM_Y;
					_modeSelect = ModePVPEnum.PvP_3vs3_MM;
					filterBG.addChild(modeItem);
					
					modeItem.setActive();*/
					
					/*hitModeMov.mouseEnabled = false;
					_modeSelect = ModePVPEnum.PvP_1vs1_MM;
					modeTf.text = "1 vs 1";*/
					this.visible = false;
					break;
			}
			
			FontUtil.setFont(nameTf, Font.ARIAL, true);
			FontUtil.setFont(modeTf, Font.ARIAL, true);
		}
		
		public function getName():String {
			return nameTf.text;
		}
		
		public function checkPrivate():Boolean {
			//return parseInt(passTf.text) > 0 ? parseInt(passTf.text) : -1;
			return checkMov.visible;
		}
		
		public function setMode(mode:GameMode):void {
			_mode = mode;
			updateFilterMode(_mode);
		}
		
		public function getMode():GameMode {
			return _mode;
		}
		
		public function getModeSelect():GameMode {
			//return parseInt(modeTf.text, 10);
			return _modeSelect;
		}
	}

}