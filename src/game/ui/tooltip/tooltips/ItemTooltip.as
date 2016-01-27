package game.ui.tooltip.tooltips 
{
	import core.display.BitmapEx;
	import core.Manager;
	import core.util.Enum;
	import core.util.FontUtil;
	import core.util.Utility;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import game.data.model.item.IItemConfig;
	import game.data.xml.CharacterXML;
	import game.data.xml.DataType;
	import game.data.xml.item.ItemChestXML;
	import game.data.xml.item.SoulXML;
	import game.data.xml.RewardXML;
	import game.data.xml.UnitClassXML;
	import game.enum.Element;
	import game.enum.Font;
	import game.enum.ItemType;
	import game.enum.UnitType;
	import game.Game;
	import game.ui.components.Reward;
	import game.utility.UtilityUI;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class ItemTooltip extends Sprite
	{
		public var background		:MovieClip;
		public var movRewardItems	:MovieClip;
		public var nameTf			:TextField;
		public var txtItemType		:TextField;
		public var descriptionTf	:TextField;
		public var txtQuantity		:TextField;
		
		public var itemsContainer	:MovieClip;
		protected var data 			:IItemConfig;
		private var _glow			:GlowFilter;
		private var rewards			:Array;
		
		public function ItemTooltip() 
		{
			rewards = [];
			background.scale9Grid = new Rectangle(50, 60, 50, 60);
			
			FontUtil.setFont(nameTf, Font.ARIAL);
			FontUtil.setFont(descriptionTf, Font.ARIAL);
			FontUtil.setFont(txtItemType, Font.ARIAL);
			FontUtil.setFont(txtQuantity, Font.ARIAL);
			
			_glow = new GlowFilter();
			_glow.strength = 10;
			_glow.blurX = _glow.blurY = 4;
			
			this.addChild(itemsContainer);
		}
		
		public function setData(itemConfig:IItemConfig):void {
			nameTf.text = itemConfig.getName();	
			var htmlDesc:String = itemConfig.getDescription();
			txtQuantity.text = "";
			
			for each (var reward:Reward in rewards) {
				if (reward.parent) {
					reward.parent.removeChild(reward);
				}
				Manager.pool.push(reward, Reward);
				reward = null;
			}
			rewards.splice(0);
			
			var bitmapGlow:GlowFilter = null;
			
			switch(itemConfig.getType()) {
				case ItemType.UNIT:
					var characterXML:CharacterXML = Game.database.gamedata.getData(DataType.CHARACTER, itemConfig.getID()) as CharacterXML;
					if (characterXML && characterXML.quality.length >= 1) {
						var nCharacterQuality:int = characterXML.quality[0] as int;
						nameTf.htmlText =  "<font color = '" + UtilityUI.getTxtColor(nCharacterQuality, false, false) + "'>" + itemConfig.getName() + "</font>";
						_glow.color = UtilityUI.getTxtGlowColor(nCharacterQuality, false, false);
						nameTf.filters = [_glow];
						bitmapGlow = new GlowFilter(UtilityUI.getTxtColorUINT(nCharacterQuality, false, false), 1, 5, 5, 2, BitmapFilterQuality.HIGH, false, false);
						var unitClassXML:UnitClassXML = Game.database.gamedata.getData(DataType.UNITCLASS, characterXML.characterClass) as UnitClassXML;
						if (unitClassXML) {
							var elementID:int = unitClassXML.element;
							var elementEnum:Element = Enum.getEnum(Element, elementID) as Element;
							if (elementEnum) {
								switch(characterXML.type) {
									case UnitType.MASTER:
										htmlDesc += "\n\n" + "Cao Nhân hệ:  "
											+ "<font color = '" + UtilityUI.getElementColorStr(elementID) + "'>"
											+ elementEnum.elementName + "</font>";
										htmlDesc += "\n" + "Công lực truyền thụ:  " + "<font color = '#ffff00'>" 
										+ Utility.math.formatInteger(characterXML.expTransmission) + "</font>";
										break;
										
									default:
										htmlDesc += "\n\n" + "Nhân vật hệ:  "
											+ "<font color = '" + UtilityUI.getElementColorStr(elementID) + "'>"
											+ elementEnum.elementName + "</font>";
										break;
								}
								
							}
						}
					}
					descriptionTf.htmlText = htmlDesc;
					FontUtil.setFont(descriptionTf, Font.ARIAL);
					txtItemType.y = descriptionTf.y + descriptionTf.textHeight + 15;
					movRewardItems.y = txtItemType.y;
					txtItemType.text = "";
					break;
				case ItemType.ITEM_SET:
				case ItemType.AUTO_OPEN_CHEST:
				case ItemType.CHOICE_CHEST:
				case ItemType.LUCKY_CHEST:
				case ItemType.MASTER_INVITATION_CHEST:
				case ItemType.NORMAL_CHEST:
				case ItemType.PRESENT_VIP_CHEST:
					descriptionTf.htmlText = htmlDesc;
					FontUtil.setFont(descriptionTf, Font.ARIAL);
					txtItemType.y = descriptionTf.y + descriptionTf.textHeight + 15;
					txtItemType.text = "";
					movRewardItems.y = txtItemType.y;
					var itemChestXML:ItemChestXML = Game.database.gamedata.getData(DataType.ITEMCHEST, itemConfig.getID()) as ItemChestXML;
					if (itemChestXML) {
						var rewardIDs:Array = itemChestXML.rewardIDs;
						var i:int = 0;
						for each (var rewardID:int in rewardIDs) {
							var rewardXML:RewardXML = Game.database.gamedata.getData(DataType.REWARD, rewardID) as RewardXML;
							if (rewardXML) {
								reward = Manager.pool.pop(Reward) as Reward;
								reward.changeType(Reward.QUEST);
								reward.updateInfo(rewardXML.getItemInfo(), rewardXML.quantity);
								reward.x = (i % 3) * 68;
								reward.y = Math.floor(i / 3) * 60;
								rewards.push(reward);
								movRewardItems.addChild(reward);
							}
							i++;
						}
					}
					
					nameTf.htmlText = "<font color = '0xffffff'>" + itemConfig.getName() + "</font>";
					nameTf.filters = [];
					break;
				case ItemType.ITEM_SOUL:
					descriptionTf.htmlText = htmlDesc;
					FontUtil.setFont(descriptionTf, Font.ARIAL);
					txtItemType.y = descriptionTf.y + descriptionTf.textHeight + 10;
					txtItemType.text = "Tổng kinh nghiệm \t\t" + (itemConfig as SoulXML).expBase;
					movRewardItems.y = txtItemType.y;
					nameTf.htmlText = "<font color = '0xffffff'>" + itemConfig.getName() + "</font>";
					nameTf.filters = [];
					break;
				default:
					descriptionTf.htmlText = htmlDesc;
					FontUtil.setFont(descriptionTf, Font.ARIAL);
					txtItemType.y = descriptionTf.y + descriptionTf.textHeight + 10;
					txtItemType.text = "";
					movRewardItems.y = txtItemType.y;
					nameTf.htmlText = "<font color = '0xffffff'>" + itemConfig.getName() + "</font>";
					nameTf.filters = [];
					break;
			}
			
			FontUtil.setFont(nameTf, Font.ARIAL);
			
			while (itemsContainer.numChildren > 0) 
			{
				var child:DisplayObject = itemsContainer.getChildAt(0) as DisplayObject;
				if (child is BitmapEx) {
					Manager.pool.push(child, BitmapEx);
					itemsContainer.removeChild(child);
				}
			}
			var bitmap:BitmapEx = Manager.pool.pop(BitmapEx) as BitmapEx;
			bitmap.reset();
			bitmap.addEventListener(BitmapEx.LOADED, onIconLoadedHdl);
			bitmap.load(itemConfig.getIconURL());
			 
			if (bitmapGlow != null)
			{
				bitmap.filters = [bitmapGlow];
			}
			
			background.height = Math.max(movRewardItems.y + movRewardItems.height + 15, txtItemType.y + txtItemType.textHeight + 15);
		}
		
		public function setQuantity(value:int):void {
			txtQuantity.text = "Số lượng: " + Utility.math.formatInteger(value);
		}
		
		public function getHeight():int {
			return background.height;
		}
		
		private function onIconLoadedHdl(e:Event):void 	{
			var bitmap:BitmapEx = e.target as BitmapEx;
			if (bitmap) {
				itemsContainer.addChild(bitmap);
			}
		}
		
	}

}