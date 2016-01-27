package game.data.xml
{

	import game.data.xml.event.EventsHotXML;
import game.data.xml.item.DivineWeaponXML;
import game.data.xml.item.ItemChestXML;
	import game.data.xml.item.ItemXML;
	import game.data.xml.item.SoulXML;
import game.enum.DivineWeaponAttributeType;

	public class DataType
	{
		public static const CHARACTER:DataType = new DataType("resource/xml/character.xml", CharacterXML);
		public static const BULLET:DataType = new DataType("resource/xml/bullet.xml", BulletXML);
		public static const CAMPAIGN:DataType = new DataType("resource/xml/campaign.xml", CampaignXML);
		public static const MISSION:DataType = new DataType("resource/xml/mission.xml", MissionXML);
		public static const ELEMENT:DataType = new DataType("resource/xml/element.xml", ElementData);
		public static const UNITCLASS:DataType = new DataType("resource/xml/unitclass.xml", UnitClassXML);
		public static const SKILL:DataType = new DataType("resource/xml/skill.xml", SkillXML);
		public static const STANCE:DataType = new DataType("resource/xml/stance.xml", StanceXML);
		public static const EFFECT:DataType = new DataType("resource/xml/effect.xml", EffectXML);
		public static const EFFECT_ANIM:DataType = new DataType("resource/xml/effectanim.xml", EffectAnimXML);
		public static const GAMECONFIG:DataType = new DataType("resource/xml/gameconfig.xml", GameConfig);
		public static const ITEM:DataType = new DataType("resource/xml/itemcommon.xml", ItemXML);
		public static const ITEMCHEST:DataType = new DataType("resource/xml/itemchest.xml", ItemChestXML);
		public static const ITEMSOUL:DataType = new DataType("resource/xml/soul.xml", SoulXML);
		public static const MESSAGE:DataType = new DataType("resource/xml/message.xml", MessageXML);
		public static const SHOP:DataType = new DataType("resource/xml/shop.xml", ShopXML);
		public static const BONUS_ATTRIBUTE:DataType = new DataType("resource/xml/bonusattribute.xml", BonusAttributeXML);
		public static const BONUS_ATTR_NAME_MAPPING:DataType = new DataType("resource/xml/unitattributemapping.xml", BonusAttrNameMappingXML);
		public static const FORMATION_TYPE:DataType = new DataType("resource/xml/formationtype.xml", FormationTypeXML);
		public static const GAME_CONDITION:DataType = new DataType("resource/xml/gamecondition.xml", GameConditionXML);
		public static const QUEST_TRANSPORT:DataType = new DataType("resource/xml/questtransporter.xml", QuestTransportXML);
		public static const VISUAL_EFFECT_COMPONENT:DataType = new DataType("resource/xml/visualeffectcomponent.xml", VisualEffectComponentXML);
		public static const VISUAL_EFFECT:DataType = new DataType("resource/xml/visualeffect.xml", VisualEffectXML);
		public static const REWARD:DataType = new DataType("resource/xml/reward.xml", RewardXML);
		public static const LEVEL:DataType = new DataType("resource/xml/level.xml", LevelFeatureXML);
		public static const FEATURE:DataType = new DataType("resource/xml/feature.xml", FeatureXML);
		public static const QUEST_MAIN:DataType = new DataType("resource/xml/quest.xml", QuestMainXML);
		public static const MODE_CONFIG:DataType = new DataType("resource/xml/modeconfig.xml", ModeConfigXML);
		public static const TOP_CONFIG:DataType = new DataType("resource/xml/topconfig.xml", TopConfigXML);
		public static const BACKGROUND_LAYER:DataType = new DataType("resource/xml/background_layer.xml", BackgroundLayerXML);
		public static const BACKGROUND:DataType = new DataType("resource/xml/background.xml", BackgroundXML);
		public static const EXTENSION_ITEM:DataType = new DataType("resource/xml/extensionitem.xml", ExtensionItemXML);
		public static const CONSUME_EVENT:DataType = new DataType("resource/xml/consumeeventconfig.xml", ConsumeEventXML);
		public static const VIP:DataType = new DataType("resource/xml/vip.xml", VIPConfigXML);
		public static const CHARGE_EVENT:DataType = new DataType("resource/xml/paymenteventconfig.xml", ChargeEventXML);
		public static const SKILL_EFFECT_FORMULA:DataType = new DataType("resource/xml/skill_effect_formula.xml", SkillEffectFormulaXML);
		public static const SECRET_MERCHANT_EVENT:DataType = new DataType("resource/xml/secretmerchantevent.xml", SecretMerchantEventXML);
		public static const SOUND:DataType = new DataType("resource/xml/sound.xml", SoundXML);
		public static const TUTORIAL:DataType = new DataType("resource/xml/tutorial.xml", TutorialXML);
		public static const SUGGESTION:DataType = new DataType("resource/xml/suggestion.xml", SuggestionXML);
		public static const EVENTS_HOT:DataType = new DataType("resource/xml/eventhot.xml", EventsHotXML);
		public static const WIKI:DataType = new DataType("resource/xml/wiki.xml", WikiXML);
		public static const DIVINEWEAPON:DataType = new DataType("resource/xml/divineweapon.xml", DivineWeaponXML);
		public static const DIVINEWEAPON_ATTRIBUTE:DataType = new DataType("resource/xml/divineweapon_attribute.xml", DivineWeaponAttributeType);
		public static const VIP_DISCOUNT_SHOP:DataType = new DataType("resource/xml/viptribute.xml", VIPDiscountXML);

		public static const ALL:Array = [CHARACTER, BULLET, CAMPAIGN, MISSION, ELEMENT, UNITCLASS, SKILL, STANCE,
			EFFECT, EFFECT_ANIM, GAMECONFIG, ITEM, ITEMCHEST, ITEMSOUL, MESSAGE, SHOP,
			BONUS_ATTRIBUTE, BONUS_ATTR_NAME_MAPPING, FORMATION_TYPE, GAME_CONDITION,
			QUEST_TRANSPORT, VISUAL_EFFECT_COMPONENT, VISUAL_EFFECT, REWARD, LEVEL,
			FEATURE, QUEST_MAIN, MODE_CONFIG, TOP_CONFIG, BACKGROUND_LAYER,
			BACKGROUND, EXTENSION_ITEM, CONSUME_EVENT, CHARGE_EVENT, VIP, SKILL_EFFECT_FORMULA,
			SECRET_MERCHANT_EVENT, SOUND, TUTORIAL, SUGGESTION, EVENTS_HOT, WIKI, VIP_DISCOUNT_SHOP, DIVINEWEAPON, DIVINEWEAPON_ATTRIBUTE];

		public function DataType(xml:String, className:Class):void
		{
			this.xml = xml;
			this.className = className;
			
		}

		public var xml:String;
		public var className:Class;
	}
}