package game
{
	import core.service.ServiceVLCBBase;
	import flash.display.Stage;
	import game.data.vo.lobby.LobbyInfo;
	import game.ui.suggestion.Suggestion;
	import game.ui.tutorial.Hint;
	import game.utility.Tracker;
	
	import game.data.Database;
	import game.data.model.UIData;
	import game.dragdrop.DragDropManager;
	import game.flow.FlowManager;
	import game.net.Network;

	public class Game
	{
		public static const MAX_CHARACTER:int = 8;
		public static const WIDTH:int = 1260;
		public static const HEIGHT:int = 650;
		
		public static var stage : Stage;
		public static var network:Network;
		public static var database:Database;
		public static var flow:FlowManager;
		public static var drag:DragDropManager;
		public static var uiData:UIData;
		public static var friend:FriendManager;	
		public static var logService:ServiceVLCBBase;	
		public static var so6Tracker:Tracker;	
		public static var suggestion:Suggestion;
		public static var hint:Hint;

		private static var _mouseEnable : Boolean = true;
		
		public static function initialize(gStage : Stage, extraInfo:Object):void
		{			
			stage = gStage;
			network = new Network();
			database = new Database();
			flow = new FlowManager();			
			drag = new DragDropManager();
			uiData = new UIData();
			friend = new FriendManager();
			suggestion = new Suggestion();
			hint = new Hint();
			so6Tracker = new Tracker(extraInfo["user"], extraInfo["processID"], extraInfo["so6TrackingURL"], extraInfo["timestamp"]);
			
			mouseEnable = true;
		}
		
		static public function get mouseEnable():Boolean 
		{
			return _mouseEnable;
		}
		
		static public function set mouseEnable(value:Boolean):void 
		{
			_mouseEnable = value;
			stage.mouseChildren = _mouseEnable;
			//stage.mouseEnabled = _mouseEnable;
		}
		
		static public function checkAndSaveLobbyInfo(info:LobbyInfo):void {
			
		}
	}
}