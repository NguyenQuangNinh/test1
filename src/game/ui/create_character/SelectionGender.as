package game.ui.create_character
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.enum.Sex;
	
	public class SelectionGender extends MovieClip
	{
		public static const SELECTION_CHANGED:String = "selectionChanged";
		
		public var male:MovieClip;
		public var female:MovieClip;
		
		private var gender:int = -1;
		
		public function SelectionGender()
		{
			addEventListener(MouseEvent.CLICK, gender_onClicked);
			select(female);
		}
		
		protected function gender_onClicked(event:MouseEvent):void
		{
			select(event.target as MovieClip);
		}
		
		private function select(button:MovieClip):void
		{
			var genderChanged:Boolean = false;
			switch(button)
			{
				case male:
					if(gender != Sex.MALE)
					{
						male.gotoAndStop(1);
						female.gotoAndStop(2);
						gender = Sex.MALE;
						genderChanged = true;
					}
					break;
				case female:
					if(gender != Sex.FEMALE)
					{
						male.gotoAndStop(2);
						female.gotoAndStop(1);
						gender = Sex.FEMALE;
						genderChanged = true;
					}
					break;
			}
			if(genderChanged) dispatchEvent(new Event(SELECTION_CHANGED));
		}
		
		public function getGender():int { return gender; } 
		public function enableGender(female:Boolean, male:Boolean):void
		{
			this.male.visible = male;
			this.female.visible = female;
			select(female ? this.female : this.male);
		}
	}
}