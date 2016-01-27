package game.ui.formation_type.gui
{
	import com.greensock.TweenMax;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import game.data.vo.formation.FormationStat;
	import game.data.vo.formation_type.FormationEffectInfo;
	import game.enum.Font;
	import game.Game;
	import game.ui.components.ElementIcon;
	import game.utility.ElementUtil;
	import game.utility.GameUtil;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class FormationTypeEffect extends MovieClip
	{
		public var numEffectTf:TextField;
		public var requireTf:TextField;
		public var statusTf:TextField;
		public var nameTf:TextField;
		public var iconLock:MovieClip;
		public var bgMovie:MovieClip;
		
		private var _bLock:Boolean;
		
		public function FormationTypeEffect()
		{
			FontUtil.setFont(numEffectTf, Font.ARIAL, true);
			FontUtil.setFont(requireTf, Font.ARIAL, true);
			FontUtil.setFont(statusTf, Font.ARIAL, true);
			FontUtil.setFont(nameTf, Font.ARIAL, true);
			statusTf.visible = false;
		}
		
		public function init(formationEffectInfo:FormationEffectInfo, index:int, levelFormationType:int, level:int, bUsing:Boolean):void
		{
			//element
			bgMovie.height = formationEffectInfo.bonusAttributes.length >= 1 ? bgMovie.height + formationEffectInfo.bonusAttributes.length * 20 : bgMovie.height;
			
			var posElement:int = 0;
			for (var i:int = 1; i < formationEffectInfo.requiredElements.length; i++)
			{
				var elementRequire:int = formationEffectInfo.requiredElements[i];
				if (elementRequire > 0)
				{
					var elementIcon:ElementIcon = new ElementIcon();
					elementIcon.setType(i);
					elementIcon.setAmount(ElementUtil.getNumElementByType(i), elementRequire); //???
					elementIcon.x = 170 + 50 * posElement++;
					elementIcon.y = 5;
					this.addChild(elementIcon);
				}
			}
			
			//var pos:int = 0;
			for (var j:int = 0; j < formationEffectInfo.bonusAttributes.length; j++)
			{
				var textEffectTf:TextField = makeEffectTF(GameUtil.getBonusText(formationEffectInfo.bonusAttributes[j], levelFormationType, formationEffectInfo.targetType, formationEffectInfo.arrTargets), isActiveEffect(formationEffectInfo));
				textEffectTf.x = 170;
				textEffectTf.y = j * 25 + 30;
				this.addChild(textEffectTf);
			}
			
			if (!formationEffectInfo)
				return;
			
			numEffectTf.text = "" + (index + 1);
			if (levelFormationType >= formationEffectInfo.levelUnlockEffect)
			{
				requireTf.visible = false;
				
				statusTf.visible = bUsing;
				
				if (isActiveEffect(formationEffectInfo))
					statusTf.text = "(Đang kích hoạt)";
				else
					statusTf.text = "(Chưa kích hoạt)";
				
				bLock = false;
			}
			else
			{
				requireTf.visible = true;
				statusTf.visible = false;
				requireTf.text = "(Trận hình cấp " + formationEffectInfo.levelUnlockEffect + " mở)";
				bLock = true;
			}
		}
		
		public function set bLock(value:Boolean):void
		{
			_bLock = value;
			iconLock.visible = value;
			
			/*TweenMax.to(this, 0, {alpha: 1, colorMatrixFilter: {saturation: 1}});
			if (value)
			{
				iconLock.x = bgMovie.width - iconLock.width - 5;
				iconLock.y = bgMovie.height - iconLock.height - 5;
				//gray
				TweenMax.to(this, 0, {alpha: 1, colorMatrixFilter: {saturation: 0}});
			}*/
		}
		
		private function isActiveEffect(formationEffectInfo:FormationEffectInfo):Boolean
		{
			var requiredElements:Array = formationEffectInfo.requiredElements;
			var arrElementTemp:Array = [0, 0, 0, 0, 0, 0]; //hoa,tho,kim,thuy,moc
			for (var i:int = 1; i <= 5; i++)
			{
				arrElementTemp[i] = ElementUtil.getNumElementByType(i);
			}
			var flag:Boolean = true;
			for (var j:int = 0; j < requiredElements.length; j++)
			{
				if (requiredElements[j] > 0 && requiredElements[j] > arrElementTemp[j])
					flag = false;
			}
			return flag;
		}
		
		private function makeEffectTF(text:String, active:Boolean):TextField
		{
			var effectTf:TextField = new TextField();
			effectTf.multiline = true;
			effectTf.wordWrap = true;
			effectTf.autoSize = TextFieldAutoSize.LEFT;
			effectTf.text = text;
			effectTf.width = 250;
			effectTf.height = 80;
			effectTf.mouseEnabled = false;
			var textFormat:TextFormat = effectTf.defaultTextFormat;
			textFormat.size = 13;
			textFormat.color = active ? 0xFFFF00 : 0xFFFFFF;
			textFormat.align = TextFormatAlign.LEFT;
			effectTf.setTextFormat(textFormat);
			
			var glow:GlowFilter = new GlowFilter();
			glow.color = 0x000000;
			glow.strength = 2;
			glow.blurX = glow.blurY = 2;
			
			effectTf.filters = [glow];
			
			FontUtil.setFont(effectTf, Font.ARIAL, true);
			
			return effectTf;
		}
		
		public function reUpdate(bUsing:Boolean):void
		{
			if (!_bLock)
				statusTf.visible = bUsing;
		}
	}

}