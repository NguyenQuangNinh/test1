package game.ui.components 
{
	import flash.display.MovieClip;
	import game.data.model.Character;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class CharacterStarsChain extends MovieClip 
	{
		private var starChain	:StarChain;
		
		public function CharacterStarsChain() {
			starChain = new StarChain();
			starChain.init(CharacterStar, 17, 15);
			addChild(starChain);
		}
		
		public function setCharacter(value:Character):void {
			if (value) {
				starChain.setTotalVisibleStar(value.maxStar);
				starChain.setProgress(value.currentStar);
				var arrStars:Array = starChain.getArrStars();
				var i:int = 0;
				for each (var star:CharacterStar in arrStars) {
					star.enable = false;
					star.setID(i);
					
					i++;
				}
				var evolutionStars:Array = value.getEvolutionStars() as Array;
				if (evolutionStars) {
					for each (i in evolutionStars) {
						if (i > value.currentStar && arrStars[i - 1]) {
							star = arrStars[i - 1];
							star.enable = true;
						}
					}
				}
			} else {
				starChain.setTotalVisibleStar(0);
				starChain.setProgress(0);
			}
		}
	}

}