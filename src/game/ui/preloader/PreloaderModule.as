package game.ui.preloader 
{
	import flash.events.Event;
	import flash.geom.Point;
	
	import core.Manager;
	import core.display.ModuleBase;
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;
	import core.event.EventEx;
	import core.util.Utility;
	
	import game.Game;
	import game.data.model.Character;
	import game.data.model.UserData;
	import game.enum.FormationType;
	import game.net.IntRequestPacket;
	import game.net.RequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.request.RequestFormation;
	import game.net.lobby.request.RequestLogLoadingAction;
	import game.ui.ModuleID;
	import game.utility.GameUtil;
	import game.utility.PathManager;

	/**
	 * ...
	 * @author TrungLNM
	 */
	public class PreloaderModule extends ModuleBase
	{
		private var numLoadedChar:int = 0;
		private var numLoadedAnim:int = 0;
		private var anims:Array;
		private var currentStep:int = 0;
		private var totalStep:int = 0;
		
		public function PreloaderModule() {
		}
		
		public function load():void 
		{
			anims = [];
			
			if(Game.database.flashVar.debug) {
				anims.push("resource/anim/font/font_item_name_yellow.banim");
				//urls.push("resource/anim/font/font_item_name_cyan.banim");
				//urls.push("resource/anim/font/font_item_name.banim");
				anims.push("resource/anim/font/font_skill_name.banim");
			
				anims.push("resource/anim/character/nv_bian.banim"); // anim nhan vat nguyen nguoi
				anims.push("resource/tutorial/moon.banim");
				anims.push("resource/tutorial/quach_tinh_tut.banim"); // mieng noi
				anims.push("resource/tutorial/tieulongnu.banim"); // mieng noi
				anims.push("resource/tutorial/tay_doc_tut.banim");
				anims.push("resource/tutorial/nvbian.banim");
				anims.push("resource/anim/ui/ui_tancong.banim");
				anims.push("resource/anim/ui/skill_text.banim");
			} 
			else 
			{
				anims.push("resource/tutorial.dat");
				anims.push("resource/tutorial1.dat");
				anims.push("resource/ingame_fx.dat");
			}
			
			currentStep = 0;
			totalStep = anims.length + 5;
			
			Manager.resource.load([anims[0]], onLoadAnimComplete, updateProgress);
		}
		
		private function onLoadCharComplete():void 
		{
			numLoadedChar++;
			currentStep++;
			var urls:Array = [];
			switch(numLoadedChar) {
				case 1:
					GameUtil.preloadCharacter(urls, 51, 0, true);
					Manager.resource.load(urls,	onLoadCharComplete, updateProgress);
					break;
				case 2:
					GameUtil.preloadCharacter(urls, 247, 0, true);
						urls.splice(urls.indexOf("resource/anim/character/unique_auduongphong_minion_do.banim"), 1);
						urls.splice(urls.indexOf("resource/anim/character/unique_auduongphong_minion_luc.banim"), 1);
						urls.splice(urls.indexOf("resource/anim/character/unique_auduongphong_minion_vang.banim"), 1);
						urls.splice(urls.indexOf("resource/anim/character/unique_auduongphong_minion_xanh.banim"), 1);
					Manager.resource.load(urls,	onLoadCharComplete, updateProgress);
					break;
				default:
					GameUtil.preloadBackground(urls, 13);
                    urls.push(PathManager.getUiModulePath(ModuleID.TUTORIAL.name));
                    urls.push(PathManager.getUiModulePath(ModuleID.INGAME_PVP.name));
					Manager.resource.load(urls,	onLoadingTutorialResourceComplete, updateProgress);
					break;
			}
		}
		
		private function loadAnim():void 
		{
			currentStep++;
			Manager.resource.load([anims[0]], onLoadAnimComplete, updateProgress);
		}
		
		private function onLoadAnimComplete():void 
		{
			numLoadedAnim++;
			currentStep++;
			if (numLoadedAnim == anims.length) {
				var urls:Array = [];
				GameUtil.preloadCharacter(urls, 50, 0, true);
				Manager.resource.load(urls,	onLoadCharComplete, updateProgress);
			} else {
				Manager.resource.load([anims[numLoadedAnim]], onLoadAnimComplete, updateProgress);
			}
		}
		
		private function updateProgress(progress:Number):void {
			PreloaderView(baseView).setStep(currentStep + "/" + totalStep);
			PreloaderView(baseView).setProgress(progress, true);
		}
		
		private function onLoadingTutorialResourceComplete():void {
			Manager.display.to(ModuleID.TUTORIAL);
			Manager.tutorial.setCurrentTutorialID(1);
			Game.so6Tracker.track(12, "complete load anims...", 1);
		}
		
		override protected function createView():void 
		{
			baseView = new PreloaderView();
			PreloaderView(baseView).setProgress(0, true);
		}
		
		override protected function onTransitionInComplete():void 
		{
			super.onTransitionInComplete();
			
			if (Game.database.userdata.isFirstTutorial)
			{
				Game.so6Tracker.track(11, "load anims...", 1);
				load();
			}
			else
			{
				Game.so6Tracker.track(11, "load anims...");
				Game.database.userdata.addEventListener(UserData.UPDATE_CHARACTER_LIST, onReceivedCharacterList);
				Game.database.userdata.addEventListener(UserData.UPDATE_FORMATION, onReceivedFormation);
				
				Utility.log("request player info: characters ");
				Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_CHARACTERS));
				Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.SECRET_MERCHANT_EVENT_ID));
			}
		}
		
		override protected function onTransitionOutComplete():void
		{
			super.onTransitionOutComplete();
			
			if (Game.database.userdata.isFirstTutorial) return;
			Game.database.userdata.removeEventListener(UserData.UPDATE_CHARACTER_LIST, onReceivedCharacterList);
			Game.database.userdata.removeEventListener(UserData.UPDATE_FORMATION, onReceivedFormation);
		}
		
		private function onReceivedCharacterList(e:Event):void 
		{
			Utility.log("request player info: formation from user " + Game.database.userdata.userID);
			//Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_FORMATION, Game.database.userdata.userID));
			Game.network.lobby.sendPacket(new RequestFormation(FormationType.FORMATION_MAIN.ID, Game.database.userdata.userID));
			//Game.network.lobby.sendPacket(new RequestFormation(FormationTypeEnum.FORMATION_TEMP, Game.database.userdata.userID));
			//loadHomeResource();
		}
			
		private function onReceivedFormation(e:EventEx):void 
		{
			switch(e.data.formationType) {
				case FormationType.FORMATION_MAIN:
					Game.network.lobby.sendPacket(new RequestFormation(FormationType.FORMATION_CHALLENGE.ID, Game.database.userdata.userID));
					break;
				case FormationType.FORMATION_CHALLENGE:
					Game.network.lobby.sendPacket(new RequestFormation(FormationType.HEROIC.ID, Game.database.userdata.userID));
					break;
				case FormationType.HEROIC:
					loadHomeResource();
					break;
			}
		}
		
		private function loadHomeResource():void {
			//send request to log load action start for outgame
			Game.network.lobby.sendPacket(new RequestLogLoadingAction(1, 1));
			
			var urls:Array = [];
			var url:String = null;
			var i:int = 0;
			var userdata:UserData = Game.database.userdata;
			var character:Character = null;

			if(Game.database.flashVar.debug) {
			//preload home UI anim
				urls.push("resource/anim/ui/level_up.banim");
				urls.push("resource/anim/font/font_item_name_cyan.banim");
				urls.push("resource/anim/font/font_item_name.banim");
				urls.push("resource/anim/font/font_item_name_yellow.banim");
				urls.push("resource/anim/ui/ingame_rewards.banim");
				//urls.push("resource/anim/ui/alchemy.banim");
				urls.push("resource/anim/font/font_text.banim");
				urls.push("resource/anim/ui/hoanthanhnv.banim");
				urls.push("resource/anim/ui/fx_truyencong_main.banim");
				urls.push("resource/anim/ui/fx_truyencong_material.banim");
			} 
			else 
			{
				urls.push("resource/ui_fx.dat");
				urls.push("resource/ingame_fx.dat");
			}
			
			urls.push("resource/ui/hud.swf");
			urls.push("resource/ui/world_map.swf");
			Utility.log("load home anim resource...");
			currentStep = 0;
			totalStep = 3;
			Manager.resource.load(urls, onHomeResourceLoaded, updateProgress);
		}
		
		private function onHomeResourceLoaded():void 
		{
			Utility.log("load home resource complete");
			currentStep++;
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_SERVER_TIME));
			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_CAMPAIGN_INFO, 1)); //tutorial
			Manager.module.load(ModuleID.TOP_BAR, onTopBarModuleLoaded, updateProgress);
		}
		
		private function onTopBarModuleLoaded():void {
			currentStep++;
			Manager.module.load(ModuleID.HOME, onHomeModuleLoaded, updateProgress);
		}
		
		private function onHomeModuleLoaded():void 
		{
			currentStep++;
			Game.so6Tracker.track(12, "complete load anims...");
			PreloaderView(baseView).setProgress(1, true);
			Manager.display.showModule(ModuleID.DIALOG, new Point(0, 0), LayerManager.LAYER_DIALOG, "top_left");
			Manager.display.showModule(ModuleID.TOOLTIP, new Point(0, 0), LayerManager.LAYER_TOOLTIP, "top_left");
			Manager.display.showModule(ModuleID.MESSAGE, new Point(0, 0), LayerManager.LAYER_MESSAGE, "top_left");
			Manager.display.showModule(ModuleID.CHAT, new Point(0, 0), LayerManager.LAYER_SCREEN_TOP, "top_left", Layer.NONE);	
			//Manager.display.showModule(ModuleID.TUTORIAL, new Point(0, 0), LayerManager.LAYER_MESSAGE, "top_left");
			
			//send request to log load action completed for outgame
			Game.network.lobby.sendPacket(new RequestLogLoadingAction(2, 1));
			
			Manager.display.to(ModuleID.HOME);
		}
	}

}