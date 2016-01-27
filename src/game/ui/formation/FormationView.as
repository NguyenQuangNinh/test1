package game.ui.formation 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import game.data.model.Character;
	import game.data.vo.formation.FormationStat;
	
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.util.Utility;
	
	import game.Game;
	import game.data.xml.LevelCommonXML;
	import game.ui.components.FormationSlot;
	import game.ui.tutorial.TutorialEvent;
	import game.utility.GameUtil;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class FormationView extends ViewBase
	{
		public static const MAX_SLOT_FORMATION:int = 8;
		
		private static const SLOT_DISTANCE:int = -10;
		
		private static const FORMATION_SLOT_START_FROM_X:int = 20;
		private static const FORMATION_SLOT_START_FROM_Y:int = 0;
		private static const FORMATION_SLOT_WIDTH:int = 80;
		
		private var _slotFormation: Array = [];
		private var _circleLine:Array = [];
		private var _slotContainer:Sprite = new Sprite();
		
		//private var _legend:int;
		//private var _nextLegend:int;
		//private var _levelNextLegend:int;
		private var _normal:int;
		private var _nextNormal:int;
		private var _levelNextNormal:int;
		
		public static const WRONG_FORMATION_INDEX:String = "wrong_formation_index";
		
		public function FormationView() {		
			addChild(_slotContainer);
		}
		
		public function initUI(normal:int, nextNormal:int, levelNextNormal:int):void 
		{
			//_legend = legend;
			//_nextLegend = nextLegend;
			//_levelNextLegend = levelNextLegend;
			_normal = normal;
			_nextNormal = nextNormal;
			_levelNextNormal = levelNextNormal;
			
			var slot:FormationSlot;
			//var circle:MovieClip;
			var nextCount:int;
			var lastPos:int;
			//reset UI			
			for each(slot in _slotFormation) {
				_slotContainer.removeChild(slot);
			}
			_slotFormation = [];
			
			//init formation slot
			//main player slot
			slot = new FormationSlot();
			slot.x = FORMATION_SLOT_START_FROM_X;
			slot.y = FORMATION_SLOT_START_FROM_Y;
			slot.changeType(true, true);
			//addChild(slot);			
			_slotContainer.addChild(slot);			
			_slotFormation.push(slot);
			
			lastPos = slot.x;
			
			/*var rectangle:Shape = new Shape(); // initializing the variable named rectangle
			rectangle.graphics.beginFill(0x0000FF); // choosing the colour for the fill, here it is red
			rectangle.graphics.drawRect(0, 0, this.width, this.height); // (x spacing, y spacing, width, height)
			rectangle.graphics.endFill(); // not always needed but I like to put it in to end the fill
			rectangle.alpha = 0.3;
			slot.addChild(rectangle); // adds the rectangle to the stage*/
			
			//normal slot
			//nextCount = _levelNextNormal <= _levelNextLegend ? _nextNormal : _normal;
			//nextCount = _levelNextNormal < 0 || _levelNextNormal >= _levelNextLegend ? _normal : _nextNormal;
			//for (var i:int = 0; i < nextCount; i++ ) {
			//Utility.log("total slot visible is " + nextNormal);
			for (var i:int = 0; i < nextNormal; i++ ) {
			//for (var i:int = 0; i < MAX_SLOT_FORMATION; i++ ) {
				slot = new FormationSlot();
				//slot.x = circle.x + circle.width + 5 + i * 80;
				slot.x = lastPos + FORMATION_SLOT_WIDTH + i * 80;
				slot.y = FORMATION_SLOT_START_FROM_Y;
				//Utility.log("formation slot pos is " + slot.x + " // " + slot.y);
				//slot.changeType(0, true);
				slot.setLock(!(_normal > i), _levelNextNormal > 0 ? _levelNextNormal.toString() : "");
				slot.showSkillSlot(false, false);
				//addChild(slot);
				_slotContainer.addChild(slot);
				_slotFormation.push(slot);
			}		
			lastPos = slot.x;
			
			/*var rectangle:Shape = new Shape(); // initializing the variable named rectangle
			rectangle.graphics.beginFill(0xFF0000); // choosing the colour for the fill, here it is red
			rectangle.graphics.drawRect(0, 0, this.width, this.height); // (x spacing, y spacing, width, height)
			rectangle.graphics.endFill(); // not always needed but I like to put it in to end the fill
			//rectangle.alpha = 0.3;
			addChild(rectangle); // adds the rectangle to the stage*/
		}
		
		public function updateFormation(info:Array):void {
			var numOfCharacters:int = 0;
			if (info != null) {											
				for (var j:int = 0; j < _slotFormation.length; j++ ) {
					var slot:FormationSlot = FormationSlot(_slotFormation[j]);
					if (!slot.checkLock()) {
						slot.setData(info[j]);	
						if (info[j] != null) numOfCharacters ++;
					}
				}
				
				//check if exist character out of current num slot opened
				if (info.length > _nextNormal + 1) {
					var character:Character;
					for (var i:int = _nextNormal + 1; i < info.length; i++) {
						character = info[i] as Character;
						if (character && character.ID > -1) {
							dispatchEvent(new Event(WRONG_FORMATION_INDEX, true));
							break;
						}
					}
				}							
			}	
			dispatchEvent(new EventEx(TutorialEvent.EVENT, { type: TutorialEvent.UPDATE_FORMATION
																, length: numOfCharacters}, true));
		}
		
		public function checkHit(bound:Rectangle):int {						
			//Utility.log("bound to check hit is :" + bound.x + " // " + bound.y + " // " + bound.width + " // " + bound.height);
			var slot:FormationSlot;		
			for (var i:int = 0; i < _slotFormation.length; i++ ) {
				slot = _slotFormation[i] as FormationSlot;
				var slotPoint:Point = localToGlobal(new Point(slot.x, slot.y));
				var dimension:Point = slot.getIconDimesion();
				var boundHit:Rectangle = new Rectangle(slotPoint.x, slotPoint.y, dimension.x, dimension.y);
				//Utility.log("bound checked is :" + boundHit.x + " // " + boundHit.y + " // " + boundHit.width + " // " + boundHit.height);
				if (Utility.math.checkOverlap(bound, boundHit) && !slot.checkLock()) {
					return i;
				}				
			}
			return -1; 
		}
		
		public function updateFormationView(): void {
			//create formation view with num normal/legend + next num normal/legend
			var numNormal:int = Game.database.userdata.numNormalFormationSlot;
			//var numLegend:int = Game.database.userdata.numLegendFormationSlot;
			
			//var currentLevelXML:LevelXML = Utility.getCurrentLevelConfig(Game.database.userdata.level) as LevelXML;
			//var nextLevelXML:LevelXML = currentLevelXML ? Game.database.gamedata.getData(DataType.LEVEL, currentLevelXML.ID + 1) as LevelXML : null;
			var nextNormalXML:LevelCommonXML = GameUtil.getNextLevelNormalFormationSlotConfig(numNormal) as LevelCommonXML;
			//var nextLegendXML:LevelCommonXML = GameUtil.getNextLevelLegendFormationSlotConfig(numLegend) as LevelCommonXML;
			
			var nextNormal:int = nextNormalXML ? nextNormalXML.normalUnitCount : numNormal;
			//var nextLegend:int = nextLegendXML ? nextLegendXML.legendUnitCount : numLegend;
			//(view as FormationView).initUI(numNormal, numLegend, nextNormal, nextLegend,
							//nextNormalXML ? nextNormalXML.levelFrom : -1, nextLegendXML ? nextLegendXML.levelFrom : -1);
			this.initUI(numNormal, nextNormal, 
											nextNormalXML ? nextNormalXML.levelFrom : -1);																				
		}
		
		public function set enableChange(enable:Boolean):void {
			_slotContainer.mouseEnabled = enable;
			_slotContainer.mouseChildren = enable;
		}
		
		public function set enableAddCharacter(enable:Boolean):void {
			for (var i:int = 0; i < _slotContainer.numChildren; i++) {
				var slot:FormationSlot = _slotContainer.getChildAt(i) as FormationSlot
				slot.enableAddCharacter(enable && !slot.getData() && !slot.checkLock());
			}
		}
	}

}