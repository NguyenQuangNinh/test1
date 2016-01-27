package game.ui.suggestion
{

	import core.Manager;
	import core.display.ModuleBase;

	import flash.events.Event;

	import game.Game;
	import game.data.vo.suggestion.SuggestionInfo;
	import game.data.xml.DataType;
	import game.data.xml.FeatureXML;

	import game.data.xml.SuggestionXML;

	import game.enum.SuggestionEnum;
	import game.ui.ModuleID;

	/**
	 * ...
	 * @author
	 */
	public class SuggestionModule extends ModuleBase
	{

		public function SuggestionModule()
		{

		}

		private function get view():SuggestionView
		{
			return baseView as SuggestionView;
		}

		override protected function createView():void
		{
			baseView = new SuggestionView();
			baseView.addEventListener("close", closeHandler);
		}

		override protected function preTransitionIn():void
		{
			super.preTransitionIn();
		}

		override protected function onTransitionInComplete():void
		{
			super.onTransitionInComplete();

			var infoArr:Array = [];
			var level:int = Game.database.userdata.level;
			var suggestionXML:SuggestionXML = Game.database.gamedata.getData(DataType.SUGGESTION, suggestType.ID) as SuggestionXML;
			if (suggestionXML) {
				for (var i:int = 0; i < suggestionXML.listSuggestion.length; i++)
				{
					var info:SuggestionInfo = suggestionXML.listSuggestion[i] as SuggestionInfo;
					var featureXML:FeatureXML = Game.database.gamedata.getData(DataType.FEATURE, info.featureID) as FeatureXML;

					if(featureXML && level >= featureXML.levelRequirement)
					{
						infoArr.push(info);
					}
				}

				view.update(infoArr, suggestType);
			}
		}

		override protected function preTransitionOut():void
		{
			super.preTransitionOut();

		}

		private function closeHandler(e:Event):void
		{
			Manager.display.hideModule(ModuleID.SUGGESTION);
		}

		private function get suggestType():SuggestionEnum
		{
			return extraInfo as SuggestionEnum;
		}
	}

}