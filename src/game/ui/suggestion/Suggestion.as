/**
 * Created by NinhNQ on 11/26/2014.
 */
package game.ui.suggestion
{

	import core.Manager;
	import core.display.DisplayManager;
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;

	import flash.geom.Point;

	import game.enum.SuggestionEnum;
	import game.ui.ModuleID;

	public class Suggestion
	{
		public function Suggestion()
		{
		}

		public function show(type:SuggestionEnum):void
		{
			switch (type)
			{
				case SuggestionEnum.SUGGEST_LEVEL_UP:
					Manager.display.showModule(ModuleID.SUGGESTION, new Point(0,0), LayerManager.LAYER_POPUP, "top_left",Layer.NONE, type);
					break;
			}
		}
	}
}
