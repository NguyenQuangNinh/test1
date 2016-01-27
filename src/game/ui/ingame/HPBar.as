package game.ui.ingame
{
	import flash.display.Sprite;
	
	import core.display.BitmapEx;
	import core.util.Utility;
	
	public class HPBar extends Sprite
	{
		private var maxHP:int;
		private var currentHP:int;
		
		private var bmpBackground:BitmapEx;
		private var bmpContent:BitmapEx;
		
		public function HPBar()
		{
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, 90, 11);
			
			bmpBackground = new BitmapEx();
			bmpBackground.load("resource/image/thanhmau_nen.png");
			addChild(bmpBackground);
			
			bmpContent = new BitmapEx();
			bmpContent.load("resource/image/thanhmau_xanh.png");
			bmpContent.y = 1;
			addChild(bmpContent);
		}
		
		public function setCurrentHP(value:int):void
		{
			currentHP = value;
			update();
		}
		
		public function addCurrentHP(value:int):void
		{
			currentHP += value;
			update();
		}
		
		public function setMaxHP(value:int):void { maxHP = value; }
		
		private function update():void
		{
			currentHP = Utility.math.clamp(currentHP, 0, maxHP);
			if(maxHP > 0) bmpContent.scaleX = currentHP/maxHP;
			else bmpContent.scaleX = 0;
		}
	}
}