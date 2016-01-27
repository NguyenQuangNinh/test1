package game.data.model.shop 
{
	import flash.utils.Dictionary;
	
	import game.Game;
	import game.data.model.Character;
	import game.data.xml.DataType;
	import game.data.xml.ExtensionItemXML;
	import game.data.xml.GameConditionXML;
	import game.data.xml.ShopXML;
	import game.enum.ItemType;
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ShopItem 
	{
		public static const LOCKED /*khóa*/				:int = 0;
		public static const NOT_BUYABLE /*chưa tỉ thí*/	:int = 1;
		public static const BUYABLE	/*đã tỉ thí nhưng chưa mua*/	:int = 2;
		public static const ALREADY_BOUGHT /*đã mua*/	:int = 3;
		
		public var item						: * = null;
		public var shopXML					:ShopXML;
		public var conditions				:Array = [];
		public var status					:int = -1;
		public var missionID				:int = -1;
		
		public function ShopItem(_shopItemXML:ShopXML) {
			shopXML = _shopItemXML;
			if (shopXML) {
				if (shopXML.enable) {
					switch(shopXML.type) {
						case ItemType.UNIT:
							if (shopXML.itemID > 0) {
								var character:Character = new Character(shopXML.itemID);
								if (character && character.xmlData) {
									character.name = character.xmlData.name;
									character.ID = shopXML.itemID;
								}
								
								item = character;
							}
							break;
					}
					
					var conditionItem:GameConditionXML;
					for each (var conditionID:int in _shopItemXML.conditions) {
						conditionItem = Game.database.gamedata.getData(DataType.GAME_CONDITION, conditionID)  as GameConditionXML;
						conditions.push(conditionItem);
					}
				}
			}
		}
		
		public function getExtendPrice():int {
			if (shopXML) {
				var extensionItemXMLs:Dictionary = Game.database.gamedata.getTable(DataType.EXTENSION_ITEM);
				for each(var extensionItemXML:ExtensionItemXML in extensionItemXMLs){
					if (extensionItemXML != null 
						&& (shopXML.type == extensionItemXML.itemType) 
						&& (shopXML.itemID == extensionItemXML.itemID)){
						return extensionItemXML.price;
					}
				}
			}
			return -1;
		}
	}

}