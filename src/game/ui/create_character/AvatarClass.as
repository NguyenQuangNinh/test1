package game.ui.create_character
{
	import com.greensock.TweenMax;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import game.enum.Element;
	import game.enum.Sex;
	
	public class AvatarClass extends MovieClip
	{
		public static const GENDER_CHANGED:String = "genderChanged";
		
		public var selectionGender:SelectionGender;
		public var avatar:MovieClip;
		public var highlight:MovieClip;
		
		private var selected:Boolean;
		private var element:Element;
		
		public function AvatarClass()
		{
			selectionGender.addEventListener(SelectionGender.SELECTION_CHANGED, selectionGender_onSeletionChanged);
			highlight.visible = false;
		}
		
		protected function selectionGender_onSeletionChanged(event:Event):void
		{
			dispatchEvent(new Event(GENDER_CHANGED));
		}
		
		public function getElement():Element { return this.element; }
		public function setElement(element:Element):void 
		{ 
			this.element = element; 
			gotoAndStop(element.ID);
			selectionGender.enableGender(element.avatarURLs[Sex.FEMALE] != null, element.avatarURLs[Sex.MALE] != null);
		}
		
		public function isSelected():Boolean { return selected; }
		public function setSelected(value:Boolean):void
		{
			if(selected != value)
			{
				selected = value;
				highlight.visible = value;
				TweenMax.to(selectionGender, 0.5, {x:selectionGender.x + (value?86:-86)});
			}
		}
		
		public function getGender():int { return selectionGender.getGender(); }
	}
}