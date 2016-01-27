package game.ui.character_enhancement.skill_upgrade 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.data.xml.EffectXML;
	import game.ui.components.ScrollBar;
	import game.ui.components.VerScroll;
	import game.ui.tooltip.tooltips.SkillEffectUI;
	
	import core.Manager;
	import core.event.EventEx;
	import core.util.FontUtil;
	
	import game.Game;
	import game.data.model.item.Item;
	import game.data.vo.skill.Skill;
	import game.enum.Font;
	import game.enum.GameConfigID;
	import game.enum.ItemType;
	import game.ui.components.ItemSlot;
	import game.utility.ElementUtil;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class SubSkillInfo extends MovieClip
	{
		public static const UPGRADE_SKILL	:String = "upgradeSkill";
		
		//public var descTf:TextField;
		//public var maskMov:MovieClip;		
		//public var scrollBar:MovieClip;
		//private var _vScroll:VerScroll;
		
		public var descMov:MovieClip;
		public var payTf:TextField;
		public var countTf:TextField;
		public var requireTf:TextField;
		public var nextLevelTf:TextField;
		public var rateTf:TextField;
		public var upgradeBtn:SimpleButton;
		public var goldMov:MovieClip;
		
		//sub skill info 
		//private static const ITEM_VOKINH_ID:int = 3;
		//private var _itemID:int = -1;
		//private static const ITEM_VOKINH_TYPE:int = 10;
		//private var _itemType:int = -1;
		
		public var itemMov:MovieClip;
		private var _itemSlot:ItemSlot;
		private var _skill:Skill;
		private var _effectUIArr:Array = [];
		
		private var _costItem:Array = [];
		private var _costGold:Array = [];
		private var _percentSuccess:Array = [];
		private var _itemScroll:Item;
		
		public function SubSkillInfo() 
		{
			initUI();
		}
		
		private function initUI():void 
		{
			//set fonts
			//FontUtil.setFont(descTf, Font.ARIAL, false);
			FontUtil.setFont(payTf, Font.ARIAL, false);
			FontUtil.setFont(requireTf, Font.ARIAL, false);
			FontUtil.setFont(countTf, Font.ARIAL, false);
			FontUtil.setFont(nextLevelTf, Font.ARIAL, false);
			FontUtil.setFont(rateTf, Font.ARIAL, false);
			
			upgradeBtn.addEventListener(MouseEvent.CLICK, onUpgradeClickHdl);
			
			//item mov
			//_itemSlot = new ItemSlot();
			_itemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
			_itemSlot.reset();
			_itemSlot.x = _itemSlot.y = 0;
			itemMov.addChild(_itemSlot);	
			//_itemSlot.addEventListener(BitmapEx.LOADED, onLoadCompleteHdl);
			
			//init item require
			//_itemScroll = new Item(ITEM_VOKINH_ID);
			_itemScroll = new Item();
			
			_costItem = Game.database.gamedata.getConfigData(GameConfigID.ITEM_UPGRADE_SKILL) as Array;
			_costGold = Game.database.gamedata.getConfigData(GameConfigID.COST_UPGRADE_SKILL) as Array;
			_percentSuccess = Game.database.gamedata.getConfigData(GameConfigID.PERCENT_UPGRADE_SKILL) as Array;
			upgradeBtn.addEventListener(MouseEvent.ROLL_OVER, onUpgradeRollOverHdl);
			upgradeBtn.addEventListener(MouseEvent.ROLL_OUT, onUpgradeRollOutHdl);
			
			/*_vScroll = new VerScroll(maskMov, descMov, scrollBar, false, -1, 0, 5, false);
			_vScroll.x = scrollBar.x;
			_vScroll.y = scrollBar.y;
			addChild(_vScroll);*/
		}
		
		private function onUpgradeRollOutHdl(e:MouseEvent):void 
		{
			var i:int = 0;	
			for each(var effectUI:SkillEffectUI in _effectUIArr) {
				effectUI.updateEffect(_skill.inCharacterID, _skill.inCharacterSubClass,
										_skill.xmlData.ID, _skill.level,
										_skill.xmlData.effectArr[i], false);
				i++;
			}
		}
		
		private function onUpgradeRollOverHdl(e:MouseEvent):void 
		{
			var i:int = 0;	
			for each(var effectUI:SkillEffectUI in _effectUIArr) {
				effectUI.updateEffect(_skill.inCharacterID, _skill.inCharacterSubClass,
										_skill.xmlData.ID, _skill.level,
										_skill.xmlData.effectArr[i], true);
				i++;
			}
		}
		
		/*private function onLoadCompleteHdl(e:Event):void 
		{
			_itemSlot.x = _itemSlot.width / 2;
			_itemSlot.y = _itemSlot.height / 2;
		}*/
		
		private function onUpgradeClickHdl(e:MouseEvent):void 
		{
			dispatchEvent(new EventEx(UPGRADE_SKILL, _skill, true));
		}
		
		public function updateInfo(skill:Skill): void {
			_skill = skill;
			//update info to show
			switch(skill.skillElement) {
				case ElementUtil.FIRE:
					_itemScroll.setXMLByType(ItemType.SKILL_SCROLL_FIRE);
					break;
				case ElementUtil.EARTH:
					_itemScroll.setXMLByType(ItemType.SKILL_SCROLL_EARTH);
					break;
				case ElementUtil.METAL:
					_itemScroll.setXMLByType(ItemType.SKILL_SCROLL_METAL);
					break;
				case ElementUtil.WATER:
					_itemScroll.setXMLByType(ItemType.SKILL_SCROLL_WATER);
					break;
				case ElementUtil.WOOD:
					_itemScroll.setXMLByType(ItemType.SKILL_SCROLL_WOOD);
					break;	
			}
			
			_itemScroll.quantity = _skill ? getCurrentCount() : 0;
			
			//descTf.text = _skill && _skill.xmlData ? _skill.xmlData.desc : "";
			//clear effect UI
			for each(var effectUI:SkillEffectUI in _effectUIArr) {
				descMov.removeChild(effectUI);
			}
			_effectUIArr = [];
			
			//reset position
			goldMov.y = 120;
			payTf.y = 120;
			countTf.y = 120;
			requireTf.y = 120;
			nextLevelTf.y = 80;
			rateTf.y = 100;
			upgradeBtn.y = 100;
			itemMov.y = 95;
				
			if (skill && skill.xmlData) {
				/*txtName.text = _model.xmlData.name;
				txtDescription.text = _model.xmlData.desc.toString();
				txtLevel.text = _model.level.toString();*/
				
				var i:int = 0;
				//skill.xmlData.effectArr = skill.xmlData.effectArr.concat(skill.xmlData.effectArr);				
				for each(var effect:XML in skill.xmlData.effectArr) {
					effectUI = new SkillEffectUI();
					effectUI.x = 0;
					effectUI.y = (effectUI.height + 27) * i;
					effectUI.updateEffect(skill.inCharacterID, skill.inCharacterSubClass, skill.xmlData.ID, skill.level, effect);
					descMov.addChild(effectUI);
					_effectUIArr.push(effectUI);
					i++;
				}
			}
			
			//update position
			goldMov.y = descMov.height + 50;
			payTf.y = descMov.height + 50;
			countTf.y = descMov.height + 50;
			requireTf.y = descMov.height + 50;
			nextLevelTf.y = descMov.height + 10;
			rateTf.y = descMov.height + 30;
			upgradeBtn.y = descMov.height + 30;
			itemMov.y = descMov.height + 25;
			
			payTf.text = _skill ? "x " + getRequireGoldByLevel(_skill.level).toString() : "";
			requireTf.text = _skill ? "x " + getRequireCountByLevel(_skill.level).toString() : "";
			countTf.text = _skill ? "(" + _itemScroll.quantity.toString() + ")": "";
			countTf.textColor = _itemScroll.quantity >= (_skill ? getRequireCountByLevel(_skill.level) : 0) ? 0x00FF00 : 0xFF0000;
			nextLevelTf.text = "cấp " + skill.level.toString() + " -> cấp " + (skill.level + 1).toString();
			rateTf.text = "Tỉ lệ thành công: " + getRateUpgradeByLevel(_skill.level) + " %";
			_itemSlot.setConfigInfo(_itemScroll.itemXML);			
		}
		
		/*private function checkValidUpgrade():Boolean {			
			var result:Boolean = true;
			//check rule if can upgrade to next level
			//reach max skill level config		
			result &&= _skill ? (_skill.level < _costItem.length) : false;
			//Utility.log("check valid upgrade by reach max skill level config " + result) ;			
			//reach max character level
			var character:Character = _skill ? Game.database.userdata.getCharacter(_skill.inCharacterID) : null;
			result &&= _skill && character ? _skill.level < character.level : false;			
			//Utility.log("check valid upgrade by reach max player level " + result) ;
			//not enough item require
			result &&= _skill ? getRequireCountByLevel(_skill.level) <= _itemScroll.quantity : false;
			//Utility.log("check valid upgrade by check enough item require " + result) ;
			//not enough gold require
			result &&= _skill ? getRequireGoldByLevel(_skill.level) <= Game.database.userdata.getGold() : false;
			//Utility.log("check valid upgrade by check enough gold require " + result) ;
			
			return result;			
		}*/
		
		private function getItemSpecialCount():int {
			var result:int = 0;
			
			var itemSpecial:Array = Game.database.inventory.getItemsByType(ItemType.SKILL_SCROLL);
			if (itemSpecial) {
				for each (var item:Item in itemSpecial) {
					if (item && !item.isExpired) {
						result += item.quantity;
					}
				}
			}
			
			return result;
		}
		
		private function getCurrentCount():int {			
			var count:int = 0;
			count += getItemSpecialCount();
			
			var items:Array = Game.database.inventory.getItemsByType(_itemScroll.itemXML.type);
			if (items) {
				for each (var item:Item in items) {
					if (item && !item.isExpired) {
						count += item.quantity;
					}
				}
			}
			return count;
		}
		
		private function getRateUpgradeByLevel(level:int):int {
			var rate:int = 0;	
			if (_percentSuccess[level + 1] != null) {
				rate = _percentSuccess[level + 1];
			}
			return rate;
		}
		
		private function getRequireCountByLevel(level:int):int {
			var count:int = 0;	
			if (_costItem[level + 1] != null) {
				count = _costItem[level + 1];
			}
			return count;
		}
		
		private function getRequireGoldByLevel(level:int):int {
			var count:int = 0;	
			if (_costGold[level] != null) {
				count = _costGold[level];
			}
			return count;
		}
		
		public function destroy():void {
			_itemSlot.reset();
			Manager.pool.push(_itemSlot, ItemSlot);
		}
	}

}