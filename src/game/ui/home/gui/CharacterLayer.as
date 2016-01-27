package game.ui.home.gui 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import game.ui.home.CharacterOutGame;
	import game.ui.home.scene.CharacterManager;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class CharacterLayer extends Sprite
	{
		
		private static const CHARACTER_HEIGHT : uint = 90;
		private static const CHARACTER_WIDTH : uint = 60;
		
		//private static const CHARACTER_CONTAINER_X : uint = 130;
		//private static const CHARACTER_CONTAINER_Y : uint = 420;
		
		private static const MAX_LAYER_SLOT : uint = 13;
		private static const DEPTH_UNIT_HEIGHT : uint = 10;
		
		private var characterContainer : Sprite = new Sprite();
		
		public function CharacterLayer() 
		{
			this.mouseEnabled = false;
			
			init();
		}
		
		private function init():void 
		{
			
			characterContainer.mouseEnabled = false;
			
			this.addChild(characterContainer);
			
			for (var i:int = 0; i < MAX_LAYER_SLOT; i++) 
			{
				var spriteLayer : Sprite = new Sprite();
				spriteLayer.mouseEnabled = false;
				characterContainer.addChild(spriteLayer);
			}
		}
		
		public function updateCharacterDepth(character : CharacterOutGame) : void {
			var depth : uint = Math.round((character.y - CharacterManager.CHARACTER_AREA.y) / DEPTH_UNIT_HEIGHT);
			if (depth < 0) depth = 0;
			if (depth >=  MAX_LAYER_SLOT) depth = MAX_LAYER_SLOT - 1;
			Sprite(this.characterContainer.getChildAt(depth)).addChild(character);
		}
		
		public function addCharacter(characterObj : CharacterOutGame, posX : Number, posY : Number) : void {
			
			characterObj.x = posX;
			characterObj.y = posY;
			
			updateCharacterDepth(characterObj);
			
		}
		
		public function globalCharacterContainerLocal(pos : Point) : Point {
			return this.characterContainer.globalToLocal(pos);
		}
		
	}

}