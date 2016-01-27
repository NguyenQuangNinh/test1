package game.ui.components 
{
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import game.enum.Font;
	import game.utility.ElementUtil;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ElementIcon extends MovieClip 
	{
		public var amountTf:TextField;
		
		public function ElementIcon(){
			FontUtil.setFont(amountTf, Font.ARIAL);
		}
		
		public function setAmount(current:int, require:int):void {
			amountTf.text = current + "/" + require;
		}
		
		public function setType(type:int):void {
			switch (type){
				case ElementUtil.METAL: 
					this.gotoAndStop("kim");
					break;
				case ElementUtil.WOOD: 
					this.gotoAndStop("moc");
					break;
				case ElementUtil.WATER: 
					this.gotoAndStop("thuy");
					break;
				case ElementUtil.FIRE: 
					this.gotoAndStop("hoa");
					break;
				case ElementUtil.EARTH: 
					this.gotoAndStop("tho");
					break;
				
				default: 
					break;
			}
		}
	}

}