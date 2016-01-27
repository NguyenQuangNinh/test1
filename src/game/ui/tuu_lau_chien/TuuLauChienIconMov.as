package game.ui.tuu_lau_chien 
{
	import core.event.EventEx;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.engine.ElementFormat;
	import flash.text.TextField;
	import game.data.vo.tuu_lau_chien.ResourceInfo;
	import game.data.xml.MissionXML;
	import game.enum.Element;
	import game.enum.Font;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class TuuLauChienIconMov extends MovieClip
	{
		
		public static const ON_REQUEST_RESOURCE_INFO:String = "requestResourceInfo";
		
		public var stateMov: TuuLauChienStateMov;
		
		//dynamic info
		private var _info:ResourceInfo;
		private var _index:int = -1;
		
		//static info
		private var _xmlData:MissionXML;
		
		public function TuuLauChienIconMov() 
		{
			initUI();
		}
		
		private function initUI():void 
		{
			this.gotoAndStop(1);
			stateMov.visible = false;
			this.buttonMode = true;
			
			//add events
			addEventListener(MouseEvent.CLICK, onIconClickHdl);
		}
		
		private function onIconClickHdl(e:MouseEvent):void 
		{
			dispatchEvent(new EventEx(ON_REQUEST_RESOURCE_INFO, _xmlData.ID, true));
		}
		
		public function updateState(enable: Boolean, type:Element, name:String):void 
		{
			stateMov.visible = enable;
			stateMov.updateState(type, name);			
		}
		
		public function get index():int 
		{
			return _index;
		}
		
		public function set index(idx:int):void 
		{
			_index = idx;
		}
		
		public function get infoData():ResourceInfo
		{
			return _info;
		}
		
		public function set infoData(data:ResourceInfo):void 
		{
			_info = data;	
		}
		
		public function set xmlData(missionXML:MissionXML):void 
		{
			_xmlData = missionXML;
			if (_xmlData && _xmlData.ID > 0)
			{
				gotoAndStop(_xmlData.quality + 1);
			}
			else 
			{
				gotoAndStop(1);
			}
		}
		
		public function get xmlData():MissionXML
		{
			return _xmlData;
		}
	}

}