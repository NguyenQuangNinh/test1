package game.ui.ingame.pvp 
{
	import com.greensock.TweenMax;
	
	import core.util.Utility;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import game.ui.ingame.CharacterObject;

	/**
	 * ...
	 * @author bangnd2
	 */
	public class Team 
	{
		public var teamID:int;
		public var characters:Array;
		public var hpBar:MovieClip;
		
		public function Team() 
		{
			characters = [];
			reset();
		}
		
		public function reset():void
		{
			var i:int = 0;
			var length:int = characters.length;
			var character:CharacterObject;
			for (i = 0; i < length; ++i)
			{
				character = characters[i];
				if (character != null) character.removeEventListener(CharacterObject.HP_CHANGED, onHPChanged);
			}
			characters.splice(0);
			if (hpBar != null) hpBar.scaleX = 0;
		}
		
		public function addCharacter(character:CharacterObject):void
		{
			if (character != null && character.teamID == teamID)
			{
				characters.push(character);
				character.addEventListener(CharacterObject.HP_CHANGED, onHPChanged);
			}
		}
		
		private function onHPChanged(e:Event):void 
		{
			updateHPBar();
		}
		
		public function updateHPBar():void 
		{
			var i:int = 0;
			var length:int = characters.length;
			var character:CharacterObject;
			var currentHP:int = 0;
			var maxHP:int = 0;
			for (i = 0; i < length; ++i)
			{
				character = characters[i];
				if (character != null)
				{
					currentHP += character.getCurrentHP();
					maxHP += character.getMaxHP();
				}
			}
			var scale:Number = 0;
			if (maxHP > 0) scale = currentHP / maxHP;
			if (hpBar != null) TweenMax.to(hpBar, 0.2, { scaleX:scale } );
		}
	}

}