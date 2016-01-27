package game.ui.formation 
{
	import core.display.ModuleBase;
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.Utility;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import game.data.model.Character;
	import game.data.model.UserData;
	import game.data.vo.formation.FormationStat;
	import game.data.xml.DataType;
	import game.data.xml.LevelCommonXML;
	import game.enum.DragDropEvent;
	import game.enum.FlowActionEnum;
	import game.enum.FormationType;
	import game.net.lobby.request.RequestFormation;
	import game.net.lobby.request.RequestSaveFormation;
	import game.utility.GameUtil;
	//import game.enum.FlowActionID;
	import game.enum.InventoryMode;
	import game.Game;
	import game.net.IntResponsePacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.ui.components.FormationSlot;
	import game.ui.ModuleID;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class FormationModule extends ModuleBase
	{
		private var _formationInfo: Array = [];		
		
		private var _type:int = FormationType.FORMATION_MAIN.ID;
		
		private var _mode:int = 0;
		
		public function FormationModule() 
		{		
		}
		
		override protected function createView():void {
			super.createView();
			
			baseView = new FormationView();
			//updateFormationView();
			baseView.addEventListener(FormationSlot.FORMATION_SLOT_CLICK, onClickHdl);
			baseView.addEventListener(FormationSlot.FORMATION_SLOT_DCLICK, onDClickHdl);
			baseView.addEventListener(FormationSlot.FORMATION_SLOT_DRAG, onDragHdl);
			baseView.addEventListener(FormationView.WRONG_FORMATION_INDEX, onCheckWrongFormationIndexHdl);
		}
		
		private function onCheckWrongFormationIndexHdl(e:Event):void 
		{
			//request to save default formation
			Utility.log("here check wrong formation index by " + _formationInfo + " --> need save to default formation ");
			var formationDefault:Array = [0];
			for (var i:int = 1; i < FormationView.MAX_SLOT_FORMATION; i++) {
				formationDefault.push( -1);
			}
			Game.network.lobby.sendPacket(new RequestSaveFormation(_type, formationDefault));
			Game.network.lobby.sendPacket(new RequestFormation(_type, Game.database.userdata.userID));
		}
		
		private function onClickHdl(e:EventEx):void 
		{
			
		}
		
		private function onDClickHdl(e:EventEx):void 
		{
			//request to auto remove from formation
			var character: Character = e.data as Character;
			var actionType:int;
			switch(_mode) {
				case InventoryMode.CHANGE_FORMATION_MODE:
					actionType = DragDropEvent.TYPE_CHANGE_FORMATION;
					break;
				case InventoryMode.CHANGE_FORMATION_CHALLENGE:
					actionType = DragDropEvent.TYPE_CHANGE_FORMATION_CHALLENGE;
					break;
			}
			Game.flow.doAction(FlowActionEnum.REMOVE_FROM_FORMATION, {data: character, from: DragDropEvent.FROM_FORMATION, type: actionType});
		}
		
		private function onDragHdl(e:EventEx):void 
		{
			//start drag and drog
			var obj:Object = e.data;
			
			if (!obj) {
				Utility.error("onSlotDragHdl error by NULL info refernce");
				return;
			}
			var objDrag:DisplayObject = obj.target as DisplayObject;
			switch(_mode) {
				case InventoryMode.LEVEL_UP_ENHANCEMENT:
					objDrag = obj.target as DisplayObject;
					obj.type = DragDropEvent.CHARACTER_LEVEL_UP;
					Game.drag.start(objDrag, obj);
					break;
				case InventoryMode.CHANGE_FORMATION_MODE:
					objDrag = obj.target as DisplayObject;
					obj.type = DragDropEvent.TYPE_CHANGE_FORMATION;
					Game.drag.start(objDrag, obj);
					break;
				case InventoryMode.CHANGE_FORMATION_CHALLENGE:
					objDrag = obj.target as DisplayObject;
					obj.type = DragDropEvent.TYPE_CHANGE_FORMATION_CHALLENGE;
					Game.drag.start(objDrag, obj);
					break;
			}
		}	
		
		override protected function onTransitionOutComplete():void {
			super.onTransitionOutComplete();
			//Game.database.userdata.removeEventListener(UserData.UPDATE_PLAYER_INFO, onUpdateFormation);
			//Game.database.userdata.removeEventListener(UserData.UPDATE_CHARACTER_LIST, onUpdateFormation);
			Game.database.userdata.removeEventListener(UserData.UPDATE_FORMATION, onUpdateFormation);
			//Game.database.userdata.removeEventListener(UserData.UPDATE_CHARACTER_INFO, onUpdateFormation);
		}
		
		private function onUpdateFormation(e:EventEx):void 
		{
			var fType:FormationType = e.data.formationType as FormationType;
			_type = fType.ID;
			updateFormation(fType.ID);			
		}		
		
		override protected function preTransitionIn():void 
		{
			super.preTransitionIn();
			
			//Game.database.userdata.addEventListener(UserData.UPDATE_PLAYER_INFO, onUpdateFormation);
			//Game.database.userdata.addEventListener(UserData.UPDATE_FORMATION, onUpdateFormation);
			//Game.database.userdata.addEventListener(UserData.UPDATE_CHARACTER_INFO, onUpdateFormation);
			Game.database.userdata.addEventListener(UserData.UPDATE_FORMATION, onUpdateFormation);
			//here prepare formation info
			FormationView(baseView).updateFormationView();
			Game.database.userdata.formationChallengeTemp = Game.database.userdata.formationChallenge.slice();
			updateFormation(_mode == InventoryMode.CHANGE_FORMATION_MODE ? FormationType.FORMATION_MAIN.ID : FormationType.FORMATION_TEMP.ID);
			
			/*if (extraInfo) {
				Utility.log( "extraInfo : " + extraInfo );
				_mode = extraInfo as int;				
			}*/
			
			switch(_mode) {
				case InventoryMode.FORMATION_CHALLENGE:
					FormationView(baseView).enableAddCharacter = true;
					break;
				default:
					FormationView(baseView).enableAddCharacter = false;
					break;
			}
		}
		
		public function checkHit(bound:Rectangle):int {
			return (baseView as FormationView).checkHit(bound);
		}
		
		public function updateFormation(type:int): void {
			_type = type;
			switch(type) {
				case FormationType.FORMATION_MAIN.ID:
					_formationInfo = Game.database.userdata.formation;
					break;
				case FormationType.FORMATION_CHALLENGE.ID:
					_formationInfo = Game.database.userdata.formationChallenge;
					break;
				case FormationType.FORMATION_TEMP.ID:					
					_formationInfo = Game.database.userdata.formationChallengeTemp;
					break;
			}
			
			(baseView as FormationView).updateFormation(_formationInfo);
		}
		
		public function getIndexByInfo(info: Object): int {
			//return _formationInfo.indexOf(info);
			var index:int = -1;
			for each(var data:Character in _formationInfo) {				
				if (data && info.ID == data.ID)
					return index + 1;
				index++;
			}
			return index;
		}
		
		public function set mode(value:int):void {
			Utility.log( "FormationModule.mode : " + _mode );
			_mode = value;
		}
		
		public function set enableChange(change: Boolean):void {
			Utility.log( "FormationModule.enableChange : " + change );
			FormationView(baseView).enableChange = change;
		}
		
		/*public function set enableAddCharacter(enable:Boolean):void {
			Utility.log( "FormationModule.enableAddCharacter : " + enable );
			FormationView(view).enableAddCharacter = enable;
		}*/
	}
}