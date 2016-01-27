package game.ui.change_formation_challenge 
{
	import core.display.ViewBase;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.ui.formation.FormationView;
	import game.ui.inventory.InventoryView;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ChangeFormationChallengeView extends ViewBase
	{
		public static const CLOSE_FORMATION_CHALLENGE:String = "closeFormationChallenge";
		public static const REGISTER_FORMATION_CHALLENGE:String = "registerFormationChallenge";
		public static const SHOW_INFO_FORMATION_CHALLENGE:String = "showInfoFormationChallenge";		
		
		public var closeBtn:SimpleButton;
		public var registerBtn:SimpleButton;
		public var infoBtn:SimpleButton;
		
		//public var requireTf:TextField;
		
		private var _formationUI:FormationView;
		private var _inventoryUI:InventoryView;
		
		public function ChangeFormationChallengeView() 
		{
			initUI();
		}
		
		private function initUI():void 
		{
			//set font
			
			//add events
			closeBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			registerBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			infoBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
		}
		
		private function onBtnClickHdl(e:MouseEvent):void 
		{
			switch(e.target) {
				case closeBtn:
					dispatchEvent(new Event(CLOSE_FORMATION_CHALLENGE));
					break;
				case registerBtn:
					dispatchEvent(new Event(REGISTER_FORMATION_CHALLENGE));
					break;
				case infoBtn:
					dispatchEvent(new Event(SHOW_INFO_FORMATION_CHALLENGE));
					break;
			}
		}
		
		public function addFormationView(view:FormationView):void {
			_formationUI = view;
			addChild(_formationUI);
		}
		
		public function addInventoryView(view:InventoryView):void {
			_inventoryUI = view;
			addChild(_inventoryUI);
		}
	}

}