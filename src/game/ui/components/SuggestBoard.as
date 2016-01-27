package game.ui.components 
{
	import core.event.EventEx;
	import core.util.Enum;
	import core.util.FontUtil;
	import core.util.MovieClipUtils;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import game.data.vo.suggestion.SuggestionInfo;
	import game.data.xml.DataType;
	import game.data.xml.FeatureXML;
	import game.data.xml.SuggestionXML;
	import game.enum.Font;
	import game.Game;
	import game.utility.GameUtil;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class SuggestBoard extends MovieClip
	{
		private var _suggestXML:SuggestionXML;
		
		public var titleTf:TextField;
		private var _container:MovieClip;
		
		private static const CONTAINER_START_FROM_X:int = 0;
		private static const CONTAINER_START_FROM_Y:int = 52;
		private static const SUGGEST_DISTANCE_Y:int	= 5;
		
		public function SuggestBoard() 
		{
			FontUtil.setFont(titleTf, Font.ARIAL);
			
			_container = new MovieClip();
			_container.x = CONTAINER_START_FROM_X;
			_container.y = CONTAINER_START_FROM_Y;
			addChild(_container);
			
			addEventListener(SuggestMov.MOVE_TO_SUGGESTION, onRequestMoveToHdl);
		}
		
		private function onRequestMoveToHdl(e:EventEx):void 
		{
			var info:SuggestionInfo = e.data as SuggestionInfo;
			GameUtil.moveToSuggestion(info);			
		}
		
		public function initUI(suggestID:int):void {
			_suggestXML = Game.database.gamedata.getData(DataType.SUGGESTION, suggestID) as SuggestionXML;
			
			//clear container
			titleTf.text = "";
			MovieClipUtils.removeAllChildren(_container);
			if (_suggestXML) {
				
				titleTf.text = _suggestXML.name;
				var numFilter:int = 0;
				for (var i:int = 0; i < _suggestXML.listSuggestion.length; i++) {
					var suggest:SuggestionInfo = _suggestXML.listSuggestion[i] as SuggestionInfo;
					if(checkSuggestValid(suggest)) {
						var suggestMov:SuggestMov = new SuggestMov();
						suggestMov.updateInfo(suggest);
						suggestMov.y = suggestMov.height * (i - numFilter) + SUGGEST_DISTANCE_Y;
						_container.addChild(suggestMov);
					}else {
						numFilter++;
					}					
				}
			}
		}
		
		private function checkSuggestValid(suggest:SuggestionInfo):Boolean 
		{
			var result:Boolean = false;
			if (suggest) {
				var currentLevel:int = Game.database.userdata.level;
				var featureXML:FeatureXML = Game.database.gamedata.getData(DataType.FEATURE, suggest.featureID) as FeatureXML;
				result = featureXML && currentLevel >= featureXML.levelRequirement;
			}
			return result;
		}
	}

}