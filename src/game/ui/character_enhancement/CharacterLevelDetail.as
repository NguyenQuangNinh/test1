package game.ui.character_enhancement
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import core.util.FontUtil;
	
	import game.Game;
	import game.data.model.Character;
	import game.enum.Font;
	import game.enum.GameConfigID;
	import game.ui.components.CharacterStarsChain;
	import game.ui.components.LevelBarMov;
	
	public class CharacterLevelDetail extends MovieClip
	{
		public var starChainContainer:MovieClip;
		public var levelBar:LevelBarMov;
		public var txtEXP:TextField;
		public var txtCurrentLevel:TextField;
		
		private var starChain:CharacterStarsChain;
		
		public function CharacterLevelDetail()
		{
			starChain = new CharacterStarsChain();
			starChainContainer.addChild(starChain);
			
			FontUtil.setFont(txtEXP, Font.ARIAL);
			FontUtil.setFont(txtCurrentLevel, Font.ARIAL);
		}
		
		public function setData(character:Character):void
		{
			if(character != null)
			{
				starChain.setCharacter(character);
				var config:Array = Game.database.gamedata.getConfigData(GameConfigID.EXP_TABLE);
				var maxEXP:int = config[character.level + 1];
				txtEXP.text = character.exp + "/" + maxEXP;
				levelBar.setPercent(character.exp / maxEXP, true);
				var currentLevel:int = character.level % 12;
				if(currentLevel == 0) currentLevel = 12;
				txtCurrentLevel.text = currentLevel + "/12 tầng";
			}
		}
	}
}