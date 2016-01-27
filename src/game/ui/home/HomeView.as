package game.ui.home
{
	import flash.utils.getTimer;
	
	import core.Manager;
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.util.Utility;
	
	import game.ui.ModuleID;
	import game.ui.home.scene.CharacterManager;
	import game.ui.tutorial.TutorialEvent;
	
	
	
	/**
	 * ...
	 * @author anhtinh
	 */
	public class HomeView extends ViewBase
	{
		public var sceneLayer:SceneLayer;
		
		//public var overlayLayer : OverlayLayer;
		
		public function HomeView()
		{
			init();
		}
		
		public function init():void
		{
			initLayout();
			initEvent();
			
			CharacterManager.instance.init(this.sceneLayer);
		}
		
		private function reorganizeLayout():void
		{
		
		}
		
		private function initLayout():void
		{
		
		}
		
		private function initEvent():void
		{
		
		}
		
		override public function transitionIn():void
		{
			super.transitionIn();
			sceneLayer.onTransitionIn();
		}
		
		override public function transitionOut():void
		{
			super.transitionOut();
		}
		
		override protected function transitionInComplete():void
		{
			super.transitionInComplete();
			dispatchEvent(new EventEx(TutorialEvent.EVENT, { type:TutorialEvent.HOME_MODULE_TRANS_IN }, true));
			CharacterManager.instance.showAllCharacter();
		}
		
		override protected function transitionOutComplete():void
		{
			//Utility.log( "HomeView.transitionOutComplete" );
			super.transitionOutComplete();
			sceneLayer.onTransitionOutComplete();
			CharacterManager.instance.removeAllCharacter();
		}
		
		public function update():void
		{
			CharacterManager.instance.updateCharatersOnHome();
		}
		
		public function updateNPCDisplay():void {
			sceneLayer.updateDisplayNPC();
		}
		
		//public function updateQuestDailyState(state:int):void {
			//sceneLayer.updateQuestDailyState(state);
		//}
		
		public function updateChallengeState(state:int):void {
			sceneLayer.updateChallengeState(state);
		}
	}

}