package game.ui.components
{
	import flash.events.Event;

	public class OptionGroup
	{
		private var options:Array = [];
		private var selected:int = -1;
		
		public function addOption(checkbox:CheckBox):void
		{
			if(checkbox != null)
			{
				options.push(checkbox);
				checkbox.addEventListener(CheckBox.CHANGED, checkbox_onChanged);
			}
		}
		
		protected function checkbox_onChanged(event:Event):void
		{
			var checkbox:CheckBox = event.target as CheckBox;
			if(checkbox.isChecked())
			{
				for(var i:int = 0; i < options.length; ++i)
				{
					checkbox = options[i];
					if(checkbox != event.target) checkbox.setChecked(false);
					else selected = i;
				}
			} 
		}
		
		public function getSelected():int { return selected; }
		public function setSelected(value:int):void
		{
			if(options[value] != null)
			{
				CheckBox(options[value]).setChecked(true);
			}
		}
	}
}