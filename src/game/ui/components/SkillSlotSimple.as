package game.ui.components
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import core.display.BitmapEx;
	import core.event.EventEx;
	
	import game.data.vo.skill.Skill;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;
	
	public class SkillSlotSimple extends MovieClip
	{
		public var iconContainer:MovieClip;
		
		private var icon:BitmapEx;
		private var data:Skill;
		
		public function SkillSlotSimple()
		{
			icon = new BitmapEx();
			iconContainer.addChild(icon);
			
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			if(data != null)
			{
				dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type:TooltipID.SKILL_SLOT, value:data}, true));
			}
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
		}
		
		public function setData(skill:Skill):void
		{
			data = skill;
			if(skill == null || skill.xmlData == null) return;
			icon.load(skill.xmlData.iconURL);
		}
	}
}