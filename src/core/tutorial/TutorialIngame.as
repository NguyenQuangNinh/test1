package core.tutorial
{
	import com.greensock.events.LoaderEvent;
	import core.Manager;
	import flash.display.Stage;
	import game.enum.GameMode;
	import game.Game;
	import game.net.game.ingame.IngamePacket;
	import game.net.game.ingame.ResponseCreateObject;
	import game.net.game.ingame.ResponseObjectStatus;
	import game.net.game.ingame.ResponseUpdateObject;
	import game.net.game.response.ResponseIngame;
	import game.ui.ingame.pvp.IngamePVPView;
	import game.ui.ModuleID;
	import game.utility.Ticker;
	
	/**
	 * ...
	 * @author ...
	 */
	public class TutorialIngame
	{
		private var stage:Stage;
		
		public function TutorialIngame(stage:Stage)
		{
			this.stage = stage;
		}
		
		public function start():void
		{
			Game.database.userdata.setGameMode(GameMode.PVE_TUTORIAL);
			Manager.display.to(ModuleID.INGAME_PVP);
		}
	}

}