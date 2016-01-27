package game.ui.components.characterslot
{
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	
	import game.data.model.Character;
	import game.utility.UtilityUI;
	
	public class CharacterSlotSimple extends MovieClip
	{
		public var elementBackground:MovieClip;
		public var characterContainer:MovieClip;
		public var txtName:TextField;
		public var txtLevel:TextField;
		public var levelBackground:MovieClip;
		
		protected var data:Character;
		
		public function CharacterSlotSimple()
		{
			elementBackground.gotoAndStop(1);
		}
		
		public function setData(data:Character):void
		{
			if(this.data != null)
			{
				
			}
			this.data = data;
			if(this.data != null)
			{
				
			}
			update();
		}
		
		protected function update():void
		{
			if(data != null)
			{
				elementBackground.gotoAndStop(data.element + 1);
				txtName.text = data.name;
				txtName.textColor = UtilityUI.getTxtColorUINT(data.rarity, data.isMainCharacter, data.isLegendary());
				var glowFilter:GlowFilter = txtName.filters[0];
				if(glowFilter != null)
				{
					glowFilter.strength = 10;
					glowFilter.blurX = glowFilter.blurY = 4;
					glowFilter.color = UtilityUI.getTxtGlowColor(data.rarity, data.isMainCharacter, data.isLegendary());
					txtName.filters = [glowFilter];
				}
				txtLevel.text = data.level + " tầng";
				levelBackground.visible = true;
			}
			else
			{
				elementBackground.gotoAndStop(1);
				txtName.text = "";
				txtLevel.text = "";
				levelBackground.visible = false;
			}
		}
	}
}