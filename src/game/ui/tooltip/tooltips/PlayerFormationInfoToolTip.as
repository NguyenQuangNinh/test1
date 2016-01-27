package game.ui.tooltip.tooltips 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import game.data.vo.formation.FormationStat;
	import game.ui.components.FormationSlot;
	import game.ui.formation.FormationStatUI;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class PlayerFormationInfoToolTip extends MovieClip
	{
		
		public var formationStatMov:FormationStatUI;
		
		private static const MAX_SLOT_FORMATION:int = 8;		
		private static const DISTANCE_PER_SLOT:int = 80;		
		private var _formationInfo: Array = [];
		private var _slotContainer:MovieClip;
		
		public function PlayerFormationInfoToolTip() 
		{
			if (stage)
				init();
			else addEventListener(Event.ADDED_TO_STAGE, init);	
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			initUI();
		}
		
		private function initUI():void 
		{
			_slotContainer = new MovieClip();
			addChild(_slotContainer);
			
			//init UI
			var slot:FormationSlot;
			for (var i:int = 0; i < MAX_SLOT_FORMATION; i++) {
				slot = new FormationSlot();
				slot.x = i * DISTANCE_PER_SLOT;
				_slotContainer.addChild(slot);
				//_formationInfo.push(slot);
			}
		}
		
		public function updateFormation(info:Array):void {
			if (info != null) {
				_formationInfo = info;
				for (var i:int = 0; i < MAX_SLOT_FORMATION; i++) { 
					FormationSlot(_slotContainer.getChildAt(i)).visible = false;
				}	
				for (i = 0; i < info.length; i++ ) {
					FormationSlot(_slotContainer.getChildAt(i)).setData(info[i]);					
					FormationSlot(_slotContainer.getChildAt(i)).visible = true;					
				}
			}			
		}
		
		public function displayStat(data:FormationStat):void {
			formationStatMov.update(data);
			formationStatMov.visible = data != null;
			formationStatMov.x = Math.abs((DISTANCE_PER_SLOT * _formationInfo.length - formationStatMov.width) / 2);
		}
	}

}