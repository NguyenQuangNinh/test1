package game.ui.components 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class StarChain extends Sprite

	{
		private var starArray : Array = [];
		private var _total : int;
		private var _totalVisible : int;
		private var starClass : Class;
		private var padding : Number;
		
		public function StarChain() 
		{
			
		}
		
		public function init(starClass : Class, padding : Number, initTotal : int) : void {
			this._total = initTotal;
			this._totalVisible = initTotal;
			this.starClass = starClass;
			this.padding = padding;
			
			for (var i:int = 0; i < initTotal; i++) 
			{
				var star : StarBase = new starClass();
				star.x = i * padding;
				this.addChildAt(star, 0);
				starArray.push(star);
			}
		}
		
		public function setTotalVisibleStar(totalVisible : int) : void {
			
			if (totalVisible == this._totalVisible) {
				return;
				
			}else if (totalVisible > this._total) {
				
				for (var i:int = this._total; i < totalVisible; i++) 
				{
					var star : StarBase = new this.starClass();
					star.x = i * padding;
					this.addChildAt(star, 0);
					starArray.push(star);
				}
				
				this._total = totalVisible;
				
			}
			
			this._totalVisible = totalVisible;
			
			for (var j:int = 0; j < this._total ; j++) 
			{
				StarBase(starArray[j]).visible = (j < totalVisible);
			}
			
			
		}
		
		public function setProgress(amount : int) : void {
			for (var i:int = 0; i < this._totalVisible; i++) 
			{
				StarBase(starArray[i]).isActive = (i < amount);
			}
		}
		
		public function getArrStars():Array {
			return starArray;
		}
	}

}