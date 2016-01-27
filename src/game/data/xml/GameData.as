package game.data.xml
{

	import core.Manager;
	import core.event.EventEx;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.net.SharedObject;
	import flash.utils.Dictionary;

	import game.Game;
	import game.Main;
	import game.data.model.ModeConfigGlobalBoss;
	import game.data.model.event.EventsHotData;
	import game.data.xml.item.ItemXML;
	import game.enum.GameMode;
	import game.enum.ItemType;
	import game.enum.ShopID;
	import game.ui.heroic.world_map.CampaignData;

	public class GameData extends EventDispatcher
	{
		public static const RESOURCE_URL:String = "resource/";
		
		private static const CONFIG_URL:String = "config.xml";
		
		public var externalConfig:ExternalConfig = new ExternalConfig();
		public var serviceConfig:ServiceConfig = new ServiceConfig();
		public var maxVIP:int = -1;
		public var eventsData:EventsHotData = new EventsHotData();
		public var clientCookiesURL:String = "daivolam_ssgroup";
		public var localSO:SharedObject;
		private var dictionary:Dictionary = new Dictionary();
		private var gameConfigData:GameConfig;
		private var _allowTracing:Boolean = false;
		private var _listBulletID:Array = [];

		public function GameData()
		{
			localSO = SharedObject.getLocal("daivolam_ssgroup");
			if(!localSO.data.enableRI)
			{
				enableReceiveInvitation = true;
			}

			if(!localSO.data.enableRE)
			{
				enableReduceEffect = false;
			}
		}

		public function load():void
		{
			var xmlURLs:Array = [CONFIG_URL];
			
			if(Game.database.flashVar.debug == true)
			{
				for each(var dataType:DataType in DataType.ALL)
				{
					xmlURLs.push(dataType.xml);
				}
			}
			else
			{
				xmlURLs.push(RESOURCE_URL + "res.dat");
			}
			Manager.resource.load(xmlURLs, onLoadXMLComplete, onLoadXMLProgress);
		}

		public function loadPaymentHTML():void
		{
			if(ExternalInterface.available)
			{
				ExternalInterface.call("onDeposit");
			}
		}

		public function initTracing():void
		{
			_allowTracing = true;
//			if(!ExternalInterface.available)
//			{
//				_allowTracing = true;
//			}
//			else
//			{
//				var domain:Array = ["http://volam","http://40.40.40.235","http://113.161.70.146"];
//				var rootURL:String = Game.database.flashVar.rootURL;
//				for each (var url:String in domain)
//				{
//					if(rootURL.indexOf(url) != -1)
//					{
//						_allowTracing = true;
//						return;
//					}
//				}
//				_allowTracing = false;
//			}
		}

		public function getConfigData(id:int):*
		{
			gameConfigData = getData(DataType.GAMECONFIG, id) as GameConfig;
			if (gameConfigData)
			{
				return gameConfigData.value;
			}
		}

		public function getGlobalBossConfig():ModeConfigGlobalBoss
		{
			return (ModeConfigXML)(getData(DataType.MODE_CONFIG, GameMode.PVE_GLOBAL_BOSS.ID)).globalBossConfig;
		}

		public function getHeroicConfig(campaignID:int):CampaignData
		{
			return (ModeConfigXML)(getData(DataType.MODE_CONFIG, GameMode.PVE_HEROIC.ID)).heroicConfig[campaignID];
		}

		public function getAllData(type:DataType):Array
		{
			var result:Array = [];
			var table:Dictionary = getTable(type);

			if(table)
			{
				for each(var item:Object in table)
				{
					result.push(item);
				}
			}

			result.sortOn("ID", Array.NUMERIC);

			return result;
		}

		public function getData(type:DataType, ID:int):XMLData
		{
			return dictionary[type][ID];
		}

		public function getTable(type:DataType):Dictionary
		{
			return dictionary[type];
		}

		public function getAllItems(type:ItemType):Array
		{
			var rs:Array = [];
			for each (var item:ItemXML in dictionary[DataType.ITEM])
			{
				if(item.type == type) rs.push(item);
			}

			return rs;
		}

		public function getShopByShopID(shopID:int):Array
		{
			var arr:Array = [];
			var dics:Dictionary = dictionary[DataType.SHOP];

			switch (shopID)
			{
				case ShopID.ITEM.ID:
					for each (var shopXml:ShopXML in dics)
					{
						if (shopXml && shopXml.shopID.ID == shopID && shopXml.enable
								&& shopXml.levelRequire <= Game.database.userdata.level
								&& (shopXml.serverID.indexOf(-1) == 0
										|| shopXml.serverID.indexOf(parseInt(Game.database.flashVar.server)) != -1))
						{
							arr.push(shopXml);
						}
					}
					break;
				case ShopID.GUILD_ITEM.ID:
					for each (shopXml in dics)
					{
						if (shopXml && shopXml.shopID.ID == shopID && shopXml.enable
								&& shopXml.levelRequire <= Game.database.userdata.guildLevel
								&& (shopXml.serverID.indexOf(-1) == 0
										|| shopXml.serverID.indexOf(parseInt(Game.database.flashVar.server)) != -1))
						{
							arr.push(shopXml);
						}
					}
					break;
				case ShopID.HERO.ID:
				case ShopID.SOUL.ID:
				case ShopID.SECRET_MERCHANT.ID:
					for each (shopXml in dics)
					{
						if (shopXml && shopXml.shopID.ID == shopID && shopXml.enable)
						{
							arr.push(shopXml);
						}
					}
					break;
			}
			return arr;
		}

		public function getShopItem(shopID:ShopID, itemType:ItemType, itemID:int):ShopXML
		{
			var shopXMLTable:Dictionary = getTable(DataType.SHOP);
			for each(var shopXML:ShopXML in shopXMLTable)
			{
				if (shopXML != null && shopXML.shopID == shopID && shopXML.type == itemType && shopXML.itemID == itemID) return shopXML;
			}
			return null;
		}

		public function getShopItemsByItemID(itemType:ItemType, itemID:int):Array
		{
			var rs:Array = [];
			var shopXMLTable:Dictionary = getTable(DataType.SHOP);
			for each (var shopXML:ShopXML in shopXMLTable)
			{
				if (shopXML && shopXML.type == itemType && shopXML.itemID == itemID
						&& shopXML.shopID == ShopID.HERO)
				{
					rs.push(shopXML);
				}
			}

			return rs;
		}

		public function getExtensionByItemID(itemType:ItemType, itemID:int):Array
		{
			var rs:Array = [];
			var extensionTable:Dictionary = getTable(DataType.EXTENSION_ITEM);
			for each (var item:ExtensionItemXML in extensionTable)
			{
				if (item && item.itemType == itemType && item.itemID == itemID)
				{
					rs.push(item);
				}
			}

			return rs;
		}

		public function getNextVIPConfigXML(vipCurrent:int, labelString:String):XMLData
		{
			if (vipCurrent == maxVIP)
			{
				return null;
			}
			var vipInfoDic:Dictionary = getTable(DataType.VIP);
			if (vipCurrent == 0)
			{
				return vipInfoDic[1];
			}
			for (var i:int = vipCurrent + 1; i <= maxVIP; i++)
			{
				if (vipInfoDic[i][labelString] > vipInfoDic[vipCurrent][labelString])
				{
					return vipInfoDic[i];
				}
			}
			return vipInfoDic[maxVIP];
		}

		public function isBullet(effectID:int):Boolean
		{
			return _listBulletID.indexOf((effectID)) != -1;
		}

		private function onLoadXMLProgress(percent:Number):void
		{
			//Game.preloader.setPercent(0.05 + event.target.progress * 0.1, true);
			var t:String = "Đang tải thiết lập (" + int(percent * 100) + "%)";
			dispatchEvent(new EventEx(Main.UPDATE_PROGRESS, t));
		}

		private function onLoadXMLComplete():void
		{
			parseGameConfig();
			parseGameData();
			parseBasicEffectID();
			dispatchEvent(new Event(Event.COMPLETE));
			//Manager.resource.unload(xmlURLs);
			//dispatchEvent(new EventEx(InitGameStep.STEP_COMPLETED, InitGameStep.LOAD_CONFIG_COMPLETED));
		}

		private function parseBasicEffectID():void
		{
			var list:Array = getAllData(DataType.CHARACTER);
			for (var i:int = 0; i < list.length; i++)
			{
				var character:CharacterXML = list[i] as CharacterXML;
				var bullet:BulletXML = getData(DataType.BULLET, character.bulletID) as BulletXML;

				if(bullet && _listBulletID.indexOf(bullet.effectID) == -1)
				{
					_listBulletID.push(bullet.effectID);
				}
			}
		}

		private function parseGameConfig():void
		{
			var configXML:XML = Manager.resource.getResourceByURL(CONFIG_URL);
			serviceConfig.linkPaymentATM = configXML.service.linkPaymentATM;
			serviceConfig.logService = configXML.service.logService;
			var lobbyServers:XMLList = configXML.lobbyAddress;
			for each(var lobbyServer:XML in lobbyServers)
			{
				if (lobbyServer.@id == Game.database.flashVar.server)
				{
					externalConfig.lobbyAddress.parse(lobbyServer.toString());
					break;
				}
			}
		}

		private function parseGameData():void
		{
			for each(var type:DataType in DataType.ALL)
			{
				var table:XML = Manager.resource.getResourceByURL(type.xml);
				var dict:Dictionary = new Dictionary();
				for each(var record:XML in table.Data)
				{
					var xmlData:XMLData = new type.className();
					xmlData.parseXML(record);
					dict[xmlData.ID] = xmlData;
				}
				dictionary[type] = dict;
			}
		}

		public function get allowTracing():Boolean
		{
			return _allowTracing;
		}

		public function get enableReceiveInvitation():Boolean
		{
			return localSO.data.enableRI == "true";
		}

		public function set enableReceiveInvitation(value:Boolean):void
		{
			localSO.data.enableRI = (value) ? "true" : "false";
			localSO.flush();
		}

		public function get enableReduceEffect():Boolean
		{
			return localSO.data.enableRE == "true";
		}

		public function set enableReduceEffect(value:Boolean):void
		{
			localSO.data.enableRE = (value) ? "true" : "false";
			localSO.flush();
		}
	}
}