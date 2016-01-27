package game.ui.tooltip.tooltips
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import game.enum.GameConfigID;
	import game.enum.SoulType;
	import game.Game;
	
	import core.util.FontUtil;
	import core.util.TextFieldUtil;
	import core.util.Utility;
	
	import game.data.model.item.SoulItem;
	import game.enum.Font;
	import game.enum.ItemType;
	import game.ui.soul_center.gui.SoulProgressBar;
	import game.utility.GameUtil;
	import game.utility.UtilityUI;
	
	/**
	 * ...
	 * @author anhtinh
	 */
	public class SoulTooltip extends Sprite
	{
		
		private static const X_ALIGN:int = 15;
		private static const Y_ALIGN:int = 190 - 6;
		private static const BG_NORMAL_HEIGHT:int = 320;
		
		public var backgroundMov:MovieClip;
		public var nameTf:TextField;
		public var descriptionTf:TextField;
		public var priceTitleTf:TextField;
		public var limitTf:TextField;
		public var sellPricelTf:TextField;
		public var totalExpTf:TextField;
		
		public var progressBar:SoulProgressBar;
		public var levelTf:TextField;
		public var levelTitleTf:TextField;
		public var effectTitleTf:TextField;
		public var nextEffectTitleTf:TextField;
		
		private var currEffectTfs:Array = [];
		private var nextEffectTfs:Array = [];
		
		public var goldMov:MovieClip;
		
		public function SoulTooltip()
		{
			backgroundMov.scale9Grid = new Rectangle(100, 100, 30, 80);
			FontUtil.setFont(nameTf, Font.ARIAL, true);
			FontUtil.setFont(descriptionTf, Font.ARIAL);
			FontUtil.setFont(levelTf, Font.ARIAL, true);
			FontUtil.setFont(limitTf, Font.ARIAL, false);
			FontUtil.setFont(sellPricelTf, Font.ARIAL);
			FontUtil.setFont(levelTitleTf, Font.ARIAL, true);
			FontUtil.setFont(effectTitleTf, Font.ARIAL, false );
			FontUtil.setFont(nextEffectTitleTf, Font.ARIAL, false);
			FontUtil.setFont(priceTitleTf, Font.ARIAL, false);
			FontUtil.setFont(totalExpTf, Font.ARIAL, false);
		}
		
		public function setData(soulItem:SoulItem):void
		{
			if (soulItem.soulXML.type == ItemType.ITEM_BAD_SOUL) // bad soul
			{
				setBadSoulTooltip(soulItem);
			}
			else if (soulItem.soulXML.type == ItemType.ITEM_SOUL)
			{
				if (soulItem.soulXML.soulType == SoulType.SOUL_RECIPE) 
				{
					setRecipeSoulTooltip(soulItem);
				}
				else 
				{
					setSoulTooltip(soulItem);
				}
			}
			else
			{
				Utility.error("Hien tooltip cho item ko phai la menh khi hay phe menh!");
			}		
		}		
		
		private function setRecipeSoulTooltip(soulItem:SoulItem):void 
		{
			progressBar.visible = false;
			levelTf.visible = false;
			effectTitleTf.visible = false;
			nextEffectTitleTf.visible = false;
			levelTitleTf.visible = false;
			// an tat ca tf
			for (var j:int = 0; j < currEffectTfs.length; j++)
			{
				TextField(currEffectTfs[j]).visible = false;
				TextField(nextEffectTfs[j]).visible = false;
			}
			
			nameTf.text = soulItem.soulXML.name;
			descriptionTf.text = soulItem.soulXML.description;
			descriptionTf.y = 112 - 60;
			
			sellPricelTf.text = Utility.math.formatInteger(soulItem.soulXML.goldPriceSell);
			priceTitleTf.y = 146;
			goldMov.y = 140;
			sellPricelTf.y = priceTitleTf.y - 4;			
			
			limitTf.text = "";
			totalExpTf.text = "Tổng kinh nghiệm \t\t" + soulItem.getSoulExp();
			totalExpTf.y = 295 - 120;
			
			backgroundMov.height = BG_NORMAL_HEIGHT - 120;	
		}
		
		private function setSoulTooltip(soulItem:SoulItem):void
		{
			progressBar.visible = true;
			levelTf.visible = true;
			effectTitleTf.visible = true;
			nextEffectTitleTf.visible = true;
			levelTitleTf.visible = true;
			
			//nameTf.text = soulItem.soulXML.name;
			nameTf.htmlText = "<font color = '" + UtilityUI.getTxtColor(soulItem.soulXML.rarity, false, false) + "'>" + soulItem.soulXML.name + "</font>";
			FontUtil.setFont(nameTf, Font.ARIAL, true);
			
			descriptionTf.text = soulItem.soulXML.description;
			descriptionTf.y = 112;
			levelTf.text = Utility.math.formatInteger(soulItem.level);
			
			var expToNextLevel:int = soulItem.soulXML.level2Exp + Math.max(0, soulItem.soulXML.expIncrementPerLevel * (soulItem.level - 1));
			
			if (soulItem.level >= soulItem.soulXML.maxLevel)
			{
				progressBar.setFullLevel();
			}
			else
			{
				progressBar.setProgress(soulItem.exp, expToNextLevel);
			}
			
			// an tat ca tf
			for (var j:int = 0; j < currEffectTfs.length; j++)
			{
				TextField(currEffectTfs[j]).visible = false;
				TextField(nextEffectTfs[j]).visible = false;
			}
			
			var bonusAttributes:Array = soulItem.soulXML.bonusAttributes;
			
			for (var i:int = 0; i < bonusAttributes.length; i++)
			{
				
				if (i >= currEffectTfs.length)
				{
					var tf:TextField = TextFieldUtil.createTextfield(Font.ARIAL, 14, 120, 25, 0x09FF00, false);
					currEffectTfs.push(tf);
					tf.visible = false;
					this.addChild(tf);
					tf = TextFieldUtil.createTextfield(Font.ARIAL, 14, 120, 25, 0xFFFFFF0, false);
					nextEffectTfs.push(tf);
					tf.visible = false;
					this.addChild(tf);
				}
				var effectTf:TextField = TextField(currEffectTfs[i]) as TextField;
				FontUtil.setFont(effectTf, Font.ARIAL, false);
				effectTf.x = 106;
				effectTf.y = Y_ALIGN + i * 20;
				effectTf.text = GameUtil.getBonusText(bonusAttributes[i], soulItem.level);
				effectTf.width = effectTf.textWidth + 10;
				//Utility.log("Text : " + effectTf.text);
				//Utility.log("height : " + effectTf.height);
				//Utility.log("textHeight : " + effectTf.textHeight);
				
				TextField(currEffectTfs[i]).visible = true;

				nextEffectTitleTf.y = effectTf.y + 20;
			}
			
			var maxLimit:int = Game.database.gamedata.getConfigData(GameConfigID.MAX_SAME_SOUL_EQUIP_PER_CHARACTER) as int;
			limitTf.text = "Không thể gắn quá " + maxLimit + " mệnh khí cùng loại trên cùng nhân vật";
			sellPricelTf.text = Utility.math.formatInteger(soulItem.soulXML.goldPriceSell);
			
			if (soulItem.level < soulItem.soulXML.maxLevel)
			{
				nextEffectTitleTf.visible = true;
				for (i = 0; i < bonusAttributes.length; i++)
				{
					var nextEffectTf:TextField = TextField(nextEffectTfs[i]) as TextField;
					nextEffectTf.x = 106;
					nextEffectTf.y = nextEffectTitleTf.y + i * 20;
					nextEffectTf.text = GameUtil.getBonusText(bonusAttributes[i], soulItem.level + 1);
					nextEffectTf.width = nextEffectTf.textWidth + 10;
					nextEffectTf.visible = true;

					limitTf.y = nextEffectTf.y + 20;
				}
				
				backgroundMov.height = BG_NORMAL_HEIGHT + (bonusAttributes.length - 1) * 20 * 2;
			}
			else
			{
				nextEffectTitleTf.visible = false;				
				backgroundMov.height = BG_NORMAL_HEIGHT + (bonusAttributes.length - 2) * 20 - 12;				
			}
			
			priceTitleTf.y = limitTf.y + limitTf.textHeight + 5 ;
			sellPricelTf.y = priceTitleTf.y - 3;
			goldMov.y = sellPricelTf.y - 5;
			
			totalExpTf.text = "Tổng kinh nghiệm \t\t" + soulItem.getSoulExp();
			totalExpTf.y = priceTitleTf.y + priceTitleTf.textHeight + 5;
			
			backgroundMov.width = this.width;
			nameTf.width = backgroundMov.width * 0.8;
		}
		
		override public function get height():Number
		{
			return backgroundMov.height;
		}
		
		private function setBadSoulTooltip(soulItem:SoulItem):void
		{		
			progressBar.visible = false;
			levelTf.visible = false;
			effectTitleTf.visible = false;
			nextEffectTitleTf.visible = false;
			levelTitleTf.visible = false;
			// an tat ca tf
			for (var j:int = 0; j < currEffectTfs.length; j++)
			{
				TextField(currEffectTfs[j]).visible = false;
				TextField(nextEffectTfs[j]).visible = false;
			}
			
			nameTf.text = soulItem.soulXML.name;
			descriptionTf.text = soulItem.soulXML.description;
			descriptionTf.y = 112 - 60;
			
			sellPricelTf.text = Utility.math.formatInteger(soulItem.soulXML.goldPriceSell);
			priceTitleTf.y = 146;
			goldMov.y = 140;
			sellPricelTf.y = priceTitleTf.y - 4;
			
			limitTf.text = "";
			totalExpTf.text = "";
			
			backgroundMov.height = BG_NORMAL_HEIGHT - 120;		
		}
	}

}