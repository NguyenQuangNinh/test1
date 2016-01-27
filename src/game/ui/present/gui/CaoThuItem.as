package game.ui.present.gui
{
	import core.display.animation.Animator;
	import core.display.BitmapEx;
	import core.event.EventEx;
	import core.Manager;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import game.data.model.Character;
	import game.data.xml.CharacterXML;
	import game.data.xml.DataType;
	import game.data.xml.ElementData;
	import game.data.xml.ShopXML;
	import game.enum.CharacterAnimation;
	import game.enum.Font;
	import game.enum.UnitType;
	import game.Game;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;
	import game.utility.UtilityUI;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class CaoThuItem extends MovieClip
	{
		public var nameTf		:TextField;
		public var txtCurrentStars	:TextField;
		public var txtMaxStars	:TextField;
		public var animator		:Animator;
		public var movElement	:MovieClip;
		
		private var characterInfo:Character;
		public var shopXML:ShopXML;
		private var _glow:GlowFilter;
		private var elementBitmap:BitmapEx;
		
		public function CaoThuItem()
		{
			FontUtil.setFont(nameTf, Font.ARIAL, true);
			FontUtil.setFont(txtCurrentStars, Font.ARIAL, true);
			FontUtil.setFont(txtMaxStars, Font.ARIAL, true);
			
			animator = Manager.pool.pop(Animator) as Animator;
			animator.setCacheEnabled(false);
			animator.addEventListener(Animator.LOADED, onAnimLoadedHdl);
			//animator.addEventListener(MouseEvent.ROLL_OVER, onRollOverHdl);
			//animator.addEventListener(MouseEvent.ROLL_OUT, onRollOutHdl);
			
			this.addChild(animator);
			
			_glow = new GlowFilter();
			_glow.strength = 5;
			_glow.blurX = _glow.blurY = 4;
			
			elementBitmap = new BitmapEx();
			movElement.addChild(elementBitmap);
		}
		
		private function onAnimLoadedHdl(e:Event):void
		{
			animator.scaleX = animator.scaleY = 1.2;
			animator.play(CharacterAnimation.STAND);
			animator.x = 70;
			animator.y = 25;
		}
		
		private function onRollOutHdl(e:MouseEvent):void
		{
			dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
		}
		
		private function onRollOverHdl(e:MouseEvent):void
		{
			if (characterInfo)
			{
				dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type: TooltipID.CHARACTER_SLOT, value: characterInfo}, true));
			}
		}
		
		public function init(shopXML:ShopXML):void
		{
			this.shopXML = shopXML;
			var xmlData:CharacterXML = Game.database.gamedata.getData(DataType.CHARACTER, this.shopXML.itemID) as CharacterXML;
			if (xmlData)
			{
				characterInfo = new Character(shopXML.itemID);
				characterInfo.name = xmlData.name;
				animator.load(xmlData.animURLs[0]);
				
				if (xmlData && xmlData.quality.length >= 1 && xmlData.type != UnitType.MONSTER)
				{
					var nCharacterQuality:int = xmlData.quality[0] as int;
					nameTf.htmlText = "<font color = '" + UtilityUI.getTxtColor(nCharacterQuality, false, false) + "'>" + xmlData.name + "</font>";
					_glow.color = UtilityUI.getTxtGlowColor(nCharacterQuality, false, false);
					nameTf.filters = [_glow];
					FontUtil.setFont(nameTf, Font.ARIAL, true);
					txtCurrentStars.text = xmlData.beginStar.toString();
					var quantity:int = xmlData.quality[0];
					var arrQuantity:Array = Game.database.gamedata.getConfigData(1) as Array;
					var arrMinStars:Array = Game.database.gamedata.getConfigData(2) as Array;
					var arrMaxStars:Array = Game.database.gamedata.getConfigData(3) as Array;
					if (arrQuantity && arrMinStars && arrMaxStars) {
						var quantityIndex:int = Utilities.getElementIndex(arrQuantity, quantity);
						if (quantityIndex != -1) {
							var minStars:int = arrMinStars[quantityIndex];
							var maxStars:int = arrMaxStars[quantityIndex];
						}
					}
					if (minStars < maxStars) {
						txtMaxStars.text = minStars + " - " + maxStars;	
					} else if (minStars == maxStars) {
						txtMaxStars.text = maxStars.toString();
					}
					
					if (characterInfo && characterInfo.unitClassXML) {
						var elementData:ElementData = Game.database.gamedata.getData(DataType.ELEMENT, characterInfo.unitClassXML.element) as ElementData;
						if (elementData) {
							elementBitmap.load(elementData.tooltipImgURL);
						}
					}
				}
			}
		
		}
		
		public function reset():void
		{
			if (characterInfo)
			{
				characterInfo.reset();
				characterInfo = null;
			}
			if (animator)
			{
				animator.reset();
				animator.removeEventListener(Animator.LOADED, onAnimLoadedHdl);
				Manager.pool.push(animator);
			}
			
			shopXML = null;
		}
	}
}