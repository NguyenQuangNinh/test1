package game.ui.ingame.pvp 
{
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;
	import core.display.ModuleBase;
	import core.Manager;
	import flash.geom.Point;
	import game.data.xml.DataType;
	import game.data.xml.SoundXML;
	import game.enum.SoundID;
	import game.Game;
	import game.ui.ModuleID;
	/**
	 * ...
	 * @author bangnd2
	 */
	public class IngamePVPModule extends ModuleBase
	{
		
		override protected function createView():void 
		{
			baseView = new IngamePVPView();
		}
	}
}