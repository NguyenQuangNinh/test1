package game.flow 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	
	import core.Manager;
	import core.display.ModuleBase;
	import core.event.EventEx;
	import core.util.Utility;
	
	import game.Game;
	import game.data.model.Character;
	import game.data.model.UIData;
	import game.enum.DragDropEvent;
	import game.enum.FormationType;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.request.RequestFormation;
	import game.net.lobby.request.RequestSaveFormation;
	import game.net.lobby.response.ResponseSaveFormation;
	import game.ui.ModuleID;
	import game.ui.formation.FormationModule;
	import game.ui.message.MessageID;

	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ChangeFormation extends EventDispatcher
	{
		private var _objInfo:Object;
		private var _formationChange: Array = [];
		private var lastSwapFormationIndex:int = -1;
		
		public static const CHANGE_BY_DRAG:String = "changeByDrag";
		public static const INSERT_BY_DCLICK:String = "insertByDoubleClick";
		public static const REMOVE_BY_DCLICK:String = "removeByDoubleClick";
		
		public function ChangeFormation() 
		{
			
		}
		
		/*public function start(data: Object = null):void {
			var actionType:String = data.actionType;			
			switch(actionType) {
				case CHANGE_BY_DRAG:
					changeByDrag(data.info);
					break;
				case INSERT_BY_DCLICK:
					insertByDClick(data.info);
					break;
				case REMOVE_BY_DCLICK:
					removeByDClick(data.info);
					break;
			}
		}*/
		
		public function changeByDrag(data: Object): void {
			//here check hit collision to update inventory or formation			
			_objInfo = data.info;
			var bound:Rectangle = data.bound;
			switch (_objInfo.from) {
				case DragDropEvent.FROM_INVENTORY_UNIT:
						checkHitFormation(bound, false);
					break;
				case DragDropEvent.FROM_FORMATION:
						checkHitFormation(bound, true);
					break;
			}
		}
		
		public function insertByDClick(data: Object): void {
			//check valid insert and position to insert if valided
			Utility.log(" insert to formation by double click ");
			_objInfo = data;
			var info:Character = _objInfo.data as Character;
			switch(_objInfo.type) {
				case DragDropEvent.TYPE_CHANGE_FORMATION:
				case DragDropEvent.HEROIC_CHANGE_FORMATION:
					_formationChange = Game.database.userdata.formation.slice();
					break;
				case DragDropEvent.TYPE_CHANGE_FORMATION_CHALLENGE:
					_formationChange = Game.database.userdata.formationChallengeTemp.slice();
					break;
			}
			if (_objInfo.type == DragDropEvent.HEROIC_CHANGE_FORMATION) {
				var i:int = 0;
				for each (var character:Character in _formationChange) {
					if (character && (character.ID == info.ID)) {
						swapFormationByIndex(1, i);
						return;
					}
					i++;
				}
				updateAtIndex(1, info);
				return;
			}
			if (_objInfo.type == DragDropEvent.TYPE_CHANGE_FORMATION_CHALLENGE || !info.isInMainFormation) {
				var firstIndex: int = _formationChange.indexOf(null);
				if (firstIndex != -1) {
					//auto insert character to index					
					updateAtIndex(firstIndex, info);
				}else {
					Utility.log(" can not insert character by full formation ");
					Manager.display.showMessageID(MessageID.CHANGE_FORMATION_ERROR_FULL);
				}
			}else {
				Utility.log(" can not insert character used before ");
				Manager.display.showMessageID(MessageID.CHANGE_FORMATION_ERROR_DUP);
			}	
		}
		
		public function removeByDClick(data: Object):void {
			Utility.log(" remove to formation by double click ");
			_objInfo = data;
			var info:Character = _objInfo.data as Character;
			if (info) {
				var index: int = -1;
				var count: int;
				switch(_objInfo.type) {
					case DragDropEvent.TYPE_CHANGE_FORMATION:
					case DragDropEvent.HEROIC_CHANGE_FORMATION:
						//index = Game.database.userdata.formation.indexOf(info);
						count = 0;
						for each(var characterData:Character in Game.database.userdata.formation) {				
							if (characterData && info.ID == characterData.ID) {
								index = count;
								break;
							}
							count++;
						}
						break;
					case DragDropEvent.TYPE_CHANGE_FORMATION_CHALLENGE:
						//index = Game.database.userdata.formationChallengeTemp.indexOf(info);
						count = 0;
						for each(characterData in Game.database.userdata.formationChallengeTemp) {				
							if (characterData && info.ID == characterData.ID) {
								index = count;
								break;
							}
							count++;
						}
						break;
				}
				if (index != -1) {
					//auto remove character from index
					updateAtIndex(index, null);
				}else {
					Utility.error(" can not remove character by error index ");
				}			
			}else {
				Utility.log(" can not remove empty character ");
			}
		}
		
		public function destroy():void { 
			
		}
		
		private function checkHitFormation(bound:Rectangle, isSwapping:Boolean = false):void 
		{
			var formation:FormationModule = Manager.module.getModuleByID(ModuleID.FORMATION) as FormationModule;
			var slotIndexHit: int;
			var info:Character;
			if (!isSwapping) {
				if (Manager.display.checkVisible(ModuleID.FORMATION)) {
					slotIndexHit = formation.checkHit(bound);				
					if (slotIndexHit != -1) {
						//info = Game.database.userdata.getCharacterInfoByID(_objInfo.data.ID);
						info = Game.database.userdata.getCharacter(_objInfo.data.ID);
						Utility.log("update slot " + slotIndexHit + " with id " + info.ID);								
						updateAtIndex(slotIndexHit, info);
					}
				}else {
					Utility.log("can not check drag on formation by error display");
				}				
			}else {
				slotIndexHit = formation.checkHit(bound);
				var currentIndex: int = formation.getIndexByInfo(_objInfo.data);
				if (slotIndexHit != -1) {
					if (slotIndexHit != currentIndex) {
						swapFormationByIndex(currentIndex, slotIndexHit);
					}
				}else if(slotIndexHit == -1){
					Utility.log("update slot " + currentIndex + " by remove ");								
					updateAtIndex(currentIndex, null);
				}
			}						
		}
		
		private function swapFormationByIndex(index1:int, index2:int):void {
			Utility.log("swap formation from " + index1 + " to " + index2);
			switch(_objInfo.type) {
				case DragDropEvent.TYPE_CHANGE_FORMATION:
				case DragDropEvent.HEROIC_CHANGE_FORMATION:
					_formationChange = Game.database.userdata.formation.slice();
					break;
				case DragDropEvent.TYPE_CHANGE_FORMATION_CHALLENGE:
					//_formationChange = Game.database.userdata.formationChallenge.slice();
					_formationChange = Game.database.userdata.formationChallengeTemp.slice();
					break;
			}
			
			if (index1 < 0 || index1 > _formationChange.length && index2 < 0 || index2 > _formationChange.length) {
				Utility.error("error swap formation by index " + index1 + " // " + index2);
			}else {
				var temp:Character = _formationChange[index1];
				_formationChange[index1] = _formationChange[index2];				
				_formationChange[index2] = temp;
				
				saveFormation();
			}
		}
		
		private function updateAtIndex(index: int, info:Character): void {
			switch(_objInfo.type) {
				case DragDropEvent.TYPE_CHANGE_FORMATION:
				case DragDropEvent.HEROIC_CHANGE_FORMATION:
					_formationChange = Game.database.userdata.formation.slice();
					break;
				case DragDropEvent.TYPE_CHANGE_FORMATION_CHALLENGE:
					_formationChange = Game.database.userdata.formationChallengeTemp.slice();
					break;
			}
			var characterUpdate:Character = Manager.pool.pop(Character) as Character;
			if (info) {
				characterUpdate.cloneInfo(info);
			}else {
				characterUpdate = null;
			}
			_formationChange[index] = characterUpdate;
				
			saveFormation();							
		}
		
		private function saveFormation():void {
			//send packet to server change formation
			var packet:RequestSaveFormation;
			switch(_objInfo.type) {
				case DragDropEvent.TYPE_CHANGE_FORMATION:
					//packet = new RequestSaveFormation(FormationTypeEnum.FORMATION_MAIN, _formationChange, Game.database.userdata.formationStat.ID);
					//break;
				case DragDropEvent.HEROIC_CHANGE_FORMATION:
					packet = new RequestSaveFormation(FormationType.FORMATION_MAIN.ID, _formationChange);
					break;
				case DragDropEvent.TYPE_CHANGE_FORMATION_CHALLENGE:
					packet = new RequestSaveFormation(FormationType.FORMATION_TEMP.ID, _formationChange);
					break;
			}
			Utility.log("save formation: " + packet.characterIDs);
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerRespone);
			Game.network.lobby.sendPacket(packet);	
			//Manager.display.showLoadingSync("waiting respone from server ", false);		
			
		}
		
		private function onLobbyServerRespone(e:EventEx):void 
		{
			var packet:ResponsePacket = e.data as ResponsePacket;
			switch(packet.type)
			{
				case LobbyResponseType.SAVE_FORMATION:
					onSaveFormationErrorCode(packet as ResponseSaveFormation);
					break;
			}
			//Manager.display.hideLoadingSync();	
		}
		
		private function onSaveFormationErrorCode(respone:ResponseSaveFormation):void 
		{
			switch(respone.value) {
				case 0:
					Utility.log("save formation success ");					
					switch(respone.saveType) {
						case FormationType.FORMATION_MAIN.ID:
							Game.database.userdata.formation = _formationChange.slice();
							Game.database.userdata.dispatchEvent(new Event(UIData.DATA_CHANGED, true));
							Game.network.lobby.sendPacket(new RequestFormation(FormationType.FORMATION_MAIN.ID, Game.database.userdata.userID));
							break;
						case FormationType.FORMATION_CHALLENGE.ID:
							//Game.database.userdata.formationChallenge = Game.database.userdata.formationChallengeTemp.slice();		
							Game.database.userdata.formationChallenge = Game.database.userdata.formationChallengeTemp;
							Game.database.userdata.dispatchEvent(new Event(UIData.DATA_CHANGED, true));
							Game.network.lobby.sendPacket(new RequestFormation(FormationType.FORMATION_CHALLENGE.ID, Game.database.userdata.userID));
							break;
						case FormationType.FORMATION_TEMP.ID:
							Game.database.userdata.formationChallengeTemp = _formationChange.slice();
							Game.database.userdata.dispatchEvent(new Event(UIData.DATA_CHANGED, true));
							Game.network.lobby.sendPacket(new RequestFormation(FormationType.FORMATION_TEMP.ID, Game.database.userdata.userID));
							break;
					}
					//_formationChange;
					//Game.database.userdata.formation;
					//Game.database.userdata.formationChallenge;
					
					//request update inventory and character info
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_CHARACTERS));	
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_PLAYER_INFO));
					break;
				case 1:
					Utility.log("save formation normal error ");					
					break;
				case 2:
					Utility.log("save formation fail by: can not use in formation ");															
					Manager.display.showMessageID(MessageID.CHANGE_FORMATION_ERROR_ID);
					break;
				case 3:
					Utility.log("save formation fail by: had been used before ");	
					Manager.display.showMessageID(MessageID.CHANGE_FORMATION_ERROR_DUP);					
					break;
				case 4:
					Utility.log("save formation fail by: can not use over limit slot formation for this type of character");										
					Manager.display.showMessageID(MessageID.CHANGE_FORMATION_ERROR_FULL);					
					break;
				case 5:
					//error by invalid formation id
					Utility.log("save formation fail by: invalid formation id ");
					Manager.display.showMessageID(MessageID.CHANGE_FORMATION_ERROR_ID);
					break;
				case 6:
					//error by do not have main player	
					Utility.log("save formation fail by: do not have main player ");
					Manager.display.showMessageID(MessageID.CHANGE_FORMATION_ERROR_MAIN_PLAYER);
					break;					
			}
			_formationChange = [];
		}
	}

}