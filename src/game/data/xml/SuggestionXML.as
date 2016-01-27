package game.data.xml 
{
	import core.util.Enum;
	import game.data.vo.suggestion.SuggestionInfo;
	import game.ui.ModuleID;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class SuggestionXML extends XMLData
	{
		
		public var name:String = "";
		public var listSuggestion:Array = [];
		
		public function SuggestionXML() 
		{
			
		}
		
		override public function parseXML(xml:XML):void 
		{
			super.parseXML(xml);
			
			name = xml.Name.toString();
			var xmlList:XMLList = xml.Suggestions.Suggestion as XMLList;
			for each (var suggestion:XML in xmlList) {
				var info:SuggestionInfo = new SuggestionInfo();
				info.ID = parseInt(suggestion.ID.toString());
				info.desc = suggestion.Desc.toString();				
				info.moduleID = Enum.getEnum(ModuleID, suggestion.ModuleID.toString()) as ModuleID;
				info.featureType = parseInt(suggestion.FeatureType.toString());
				info.featureID = parseInt(suggestion.FeatureID.toString());
				listSuggestion.push(info);
			}
		}
	}

}