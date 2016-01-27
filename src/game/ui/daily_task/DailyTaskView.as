package game.ui.daily_task 
{
	import core.display.ViewBase;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import game.data.model.UserData;
	import game.data.vo.suggestion.SuggestionInfo;
	import game.data.xml.DataType;
	import game.data.xml.FeatureXML;
	import game.data.xml.ModeConfigXML;
	import game.data.xml.SuggestionXML;
	import game.enum.Direction;
	import game.enum.GameMode;
	import game.enum.SuggestionEnum;
	import game.Game;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class DailyTaskView extends ViewBase 
	{
		public var movContainer	:MovieClip;
		public var movBg		:MovieClip;
		private var xmlData		:SuggestionXML;
		private var items		:Array;
		
		public function DailyTaskView() {
			items = [];
		}
		
		override public function transitionOut():void {
			super.transitionOut();
			Game.database.userdata.removeEventListener(UserData.UPDATE_DAILY_TASK, onUpdateDailyTask);
		}
		
		override public function transitionIn():void {
			super.transitionIn();
			Game.database.userdata.addEventListener(UserData.UPDATE_DAILY_TASK, onUpdateDailyTask);
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.DAILY_TASK_INFO));
			onUpdateDailyTask(null);
		}
		
		private function onUpdateDailyTask(e:Event):void {
			for each (var item:DailyTaskItem in items) {
				if (item && item.parent) {
					item.parent.removeChild(item);
					item = null;
				}
			}
			
			items.splice(0);
			
			var suggestionXML:SuggestionXML = Game.database.gamedata.getData(DataType.SUGGESTION, SuggestionEnum.DAILY_TASK.ID) as SuggestionXML;
			if (suggestionXML) {
				var posY:int = 35;
				var featureXML:FeatureXML;
				var suggestionID:int = 0;
				var suggestionInfo:SuggestionInfo;
				var rs:Boolean;
				for each (var info:Object in Game.database.userdata.dailyTasks) {
					suggestionInfo = suggestionXML.listSuggestion[suggestionID];
					rs = false;
					if (suggestionInfo) {
						featureXML = Game.database.gamedata.getData(DataType.FEATURE, suggestionInfo.featureID) as FeatureXML;
						if (featureXML)
						{
							rs = checkVisibleTask(suggestionID, featureXML);
						}
						else
						{
							var modeConfigXML:ModeConfigXML;
							switch(suggestionID) {
								case 9:
									rs = true;
									break;
									
								case 10: //tam hung ky hiep
									modeConfigXML = Game.database.gamedata.getData(DataType.MODE_CONFIG, GameMode.PVP_3vs3_MM.ID) as ModeConfigXML;
									if (modeConfigXML) {
										if (Game.database.userdata.level >= modeConfigXML.nLevelRequirement) {
											rs = true;
										}
									}
									break;
									
								case 11: //minh chu vo lam
									modeConfigXML = Game.database.gamedata.getData(DataType.MODE_CONFIG, GameMode.PVP_1vs1_MM.ID) as ModeConfigXML;
									if (modeConfigXML) {
										if (Game.database.userdata.level >= modeConfigXML.nLevelRequirement) {
											rs = true;
										}
									}
									break;
							}
						}
					}
					if (rs) {
						item = new DailyTaskItem();
						item.setData(suggestionInfo, info.type, info.value1, info.value2);
						item.y = posY;
						posY += item.height;
						movContainer.addChild(item);
						items.push(item);
					}
					suggestionID ++;
				}
				
				movBg.height = posY + 15;
			}
		}
		
		private function checkVisibleTask(suggestionID:int, featureXML:FeatureXML):Boolean 
		{
			switch(suggestionID) {
				
				case 12:
					if (Game.database.userdata.level >= featureXML.levelRequirement && Game.database.userdata.nAttendanceState == 1) return true;
					break;
				default:
					if (Game.database.userdata.level >= featureXML.levelRequirement) return true;
					break;
			}
			return false;
		}

		//TUTORIAL

		public function showHint(ID:int, content:String = ""):void
		{
			for (var i:int = 0; i < items.length; i++)
			{
				var info:DailyTaskItem = items[i];
				if(info.ID == ID)
				{
					Game.hint.showHint(info, Direction.RIGHT, info.x, info.y + info.height / 2, content);
				}
			}
		}
	}

}