package game.ui.arena 
{
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.data.xml.DataType;
	import game.enum.GameMode;
	import game.Game;
	//import game.ui.components.ScrollbarEx;
	//import game.data.enum.pvp.ModePVPEnum;
	import game.data.xml.ModeConfigXML;
	import game.enum.Font;
	import game.ui.components.ScrollBar;
	import game.utility.GameUtil;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ModeInfoGuide extends MovieClip
	{
		public var closeBtn:SimpleButton;
		//public var scrollBarMov:ScrollBar;
		//public var track:MovieClip;
		//public var slider:MovieClip;
		//private var _containerMov:MovieClip;
		//public var contentTf:TextField;
		public var maskMov:MovieClip;
		public var titleTf:TextField;
		public var containerMov:MovieClip;
		public var scrollMov:ScrollBar;
		
		public function ModeInfoGuide() 
		{
			initUI();
		}
		
		private function initUI():void 
		{
			//set fonts
			FontUtil.setFont(titleTf, Font.ARIAL, true);
			
			//add events
			closeBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			scrollMov = new ScrollBar();
			scrollMov.x = maskMov.x + maskMov.width + 5;
			scrollMov.y = maskMov.y;
			addChild(scrollMov);
			//scrollMov.visible = true;
		}
		
		public function initGuide(mode:int):void {			
			//init content
			titleTf.text = "HƯỚNG DẪN";
			//var modeXML:ModeConfigXML = GameUtil.getModeConfigXMLByType(mode) as ModeConfigXML;
			var modeXML:ModeConfigXML = Game.database.gamedata.getData(DataType.MODE_CONFIG, GameMode.PVP_3vs3_FREE.ID) as ModeConfigXML;
			var contentTf:TextField = containerMov["contentTf"] as TextField;
			if (contentTf) {
				FontUtil.setFont(contentTf, Font.ARIAL, true);
				//contentTf.text = modeXML.desc + modeXML.desc + modeXML.desc + modeXML.desc + modeXML.desc + modeXML.desc; 
				contentTf.text = modeXML.desc; 
				containerMov.height = contentTf.height;
			}
			scrollMov.init(containerMov, maskMov, "vertical", true, false, true);
			//scrollMov.reInit();
			//scrollMov.visible = true;
		}
		
		private function onBtnClickHdl(e:MouseEvent):void 
		{
			this.visible = false;
			dispatchEvent(new Event(Event.CLOSE));
		}
		
	}

}