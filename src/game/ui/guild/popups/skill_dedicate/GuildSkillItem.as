package game.ui.guild.popups.skill_dedicate 
{
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import game.enum.Font;
	import game.enum.GameConfigID;
	import game.Game;
	/**
	 * ...
	 * @author vu anh
	 */
	public class GuildSkillItem extends MovieClip
	{
		public var bg:MovieClip;
		
		public var icon:MovieClip;
		public var titleTf:TextField;
		public var levelTf:TextField;
		public var pointTf:TextField;
		
		public var skillLevel:int;
		public var currentDPPoint:int;
		
		public var type:int;
		
		public function GuildSkillItem() 
		{
			this.buttonMode = true;
			deactive();
			FontUtil.setFont(titleTf, Font.ARIAL, true);
			FontUtil.setFont(levelTf, Font.ARIAL, true);
			FontUtil.setFont(pointTf, Font.ARIAL, true);
			titleTf.mouseEnabled = false;
			levelTf.mouseEnabled = false;
			pointTf.mouseEnabled = false;
		}
		
		public function copy(item:GuildSkillItem):void
		{
			this.type = item.type;
			this.icon.gotoAndStop(item.icon.currentFrame);
			titleTf.text = item.titleTf.text;
			levelTf.text = item.levelTf.text;
			pointTf.text = item.pointTf.text;
		}
		
		public function update(level:int, dpPoint:int):void
		{
			skillLevel = level;
			currentDPPoint = dpPoint;
			
			levelTf.text = "Cấp " + level;
			pointTf.text = currentDPPoint + "/" + Game.database.gamedata.getConfigData(GameConfigID.GUILD_SKILL_DP_LEVEL_REQUIRES)[skillLevel + 1];
		}
		
		public function active():void
		{
			bg.alpha = 1;
		}
		
		public function deactive():void
		{
			bg.alpha = 0;
		}
	}

}