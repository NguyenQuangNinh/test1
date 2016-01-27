package game.utility
{
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	
	import core.util.Utility;
	
	import game.Game;
	import game.data.model.item.Item;
	import game.data.model.item.ItemFactory;
	import game.data.xml.DataType;
	import game.data.xml.RewardXML;

	//import game.ui.components.ItemSlot;
	
	/**
	 * ...
	 * @author anhtinh
	 */
	public class UtilityUI
	{
		public static const CLOSE_BTN:String = "game.ui.components.ButtonClose";
		public static const OK_BTN:String = "game.ui.components.ButtonOK";
		public static const SKIP_BTN:String = "game.ui.components.SkipButton";
		public static const SOUND_BTN:String = "game.ui.hud.gui.SoundButton";
		public static const INVITE_BTN:String = "game.ui.hud.gui.InviteButton";
		public static const BACK_BTN:String = "game.ui.components.ButtonBack";
		public static const PAGING_MOV:String = "game.ui.components.PagingMov";
		public static const STAR:String = "game.ui.components.CharacterStar";
		public static const PAYMENT_TYPE:String = "game.ui.components.PaymentType";
		public static const HELP_BTN:String = "game.ui.components.ButtonHelp";
		
		public static const SIGNAL_COMPLETE:String = "game.ui.components.SignalComplete";
		public static const SIGNAL_RED_ALERT:String = "game.ui.components.SignalRedAlert";
		public static const SIGNAL_NEW:String = "game.ui.components.SignalNew";
		public static const ARROW_INFO:String = "game.ui.components.ArrowInfo";
		public static const HINT_ARROW:String = "game.ui.components.HintingArrow";
		public static const SUGGEST_BOARD:String = "game.ui.components.SuggestBoard";
		public static const GO_TO_BTN:String = "game.ui.components.GoToButton";
		
		public static function getComponent(className:String):DisplayObject
		{
			try
			{
				var classDef:Class = getDefinitionByName(className) as Class;
				
			}
			catch (err:Error)
			{
				Utility.error(className + " is Not define in share lib UI");
				return null;
			}
			
			return new classDef();
		}
		
		public static function getComponentPosition(className:String):Point
		{
			var point:Point = new Point(0, 0);
			switch (className)
			{
				case BACK_BTN: 
					point.x = 1190;
					point.y = 585;
					break;
			}
			return point;
		}
		
		public static function getElementGlow(element:int):uint
		{
			switch (element)
			{
				case ElementUtil.EARTH: 
					return 0xff8400;
				
				case ElementUtil.FIRE: 
					return 0xffff00;
				
				case ElementUtil.METAL: 
					return 0xffff00;
				
				case ElementUtil.WATER: 
					return 0x0000ff;
				
				case ElementUtil.WOOD: 
					return 0x00ff00;
			}
			return 0xffffff;
		}
		
		public static function getElementColorStr(element:int):String {
			switch (element)
			{
				case ElementUtil.EARTH: 
					return "#f7c961"; //ffffbe
				
				case ElementUtil.FIRE: 
					return "#e3da47"; //ffa700
				
				case ElementUtil.METAL: 
					return "#ffffe0"; //fff600
				
				case ElementUtil.WATER: 
					return "#5bfdfb"; //49adff
				
				case ElementUtil.WOOD: 
					return "#43ff10"; //30ff00
			}
			return "#ffffff";
		}
		
		public static function getElementColor(element:int):uint
		{
			switch (element)
			{
				case ElementUtil.EARTH: 
					return 0xf7c961; //ffffbe
				
				case ElementUtil.FIRE: 
					return 0xe3da47; //ffa700
				
				case ElementUtil.METAL: 
					return 0xffffe0; //fff600
				
				case ElementUtil.WATER: 
					return 0x5bfdfb; //49adff
				
				case ElementUtil.WOOD: 
					return 0x43ff10; //30ff00
			}
			return 0xffffff;
		}
		
		public static function getTxtColor(rarity:int, isMainCharacter:Boolean, isLegendary:Boolean):String
		{
			if (isMainCharacter || isLegendary)
			{
				return "#ffff00";
			}
			
			switch (rarity)
			{
				case 1: //white
					return "#fffdee";
				
				case 2: //green
					return "#43fe0f";
				
				case 3: //blue
					return "#12ebfe";
				
				case 4: //red
					return "#fd2405";
				
				case 5: //pink
					return "#ff10f7";
				
				case 6: //yellow
					return "#fff71d";
				
				default: 
					return "#000000";
			}
		}
		
		public static function getTxtColorUINT(rarity:int, isMainCharacter:Boolean, isLegendary:Boolean):uint
		{
			if (isMainCharacter || isLegendary)
			{
				return 0xffff00;
			}
			
			switch (rarity)
			{
				case 1: //white
					return 0xfffdee;
					
				case 2: //green
					return 0x43fe0f;
					
				case 3: //blue
					return 0x12ebfe;
					
				case 4: //red
					return 0xfd2405;
					
				case 5: //pink
					return 0xff10f7;
					
				case 6: //yellow
					return 0xfff71d;
					
				default: 
					return 0x000000;
			}
		}
		
		public static function getTxtGlowColor(rarity:int, isMainCharacter:Boolean, isLegendary:Boolean):uint
		{
			if (isMainCharacter || isLegendary)
			{
				return 0x663300;
			}
			
			switch (rarity)
			{
				case 1: //white
					return 0x000000;
				
				case 2: //green
					return 0x0a4411;
				
				case 3: //blue
					return 0x064a79;
				
				case 4: //red
					return 0x520b07;
				
				case 5: //pink
					return 0x3b0767;
				
				case 6: //yellow
					return 0x935206;
				
				default: 
					return 0x000000;
			}
		}
		
		public static function enableDisplayObj(enable:Boolean, displayObj:DisplayObject, eventListener:String = "", eventCallback:Function = null):void {
			if (enable) {
				TweenMax.to(displayObj, 0, { colorMatrixFilter: { saturation:1.0 }} );
				if (displayObj is SimpleButton) {
					SimpleButton(displayObj).mouseEnabled = true;
				}
				if (eventListener.length && (eventCallback != null)) {
					if (!displayObj.hasEventListener(eventListener)) {
						displayObj.addEventListener(eventListener, eventCallback);
					}	
				}
			} else {
				TweenMax.to(displayObj, 0, { colorMatrixFilter: { saturation:0.05 }} );
				if (displayObj is SimpleButton) {
					SimpleButton(displayObj).mouseEnabled = false;
				}
				if (eventListener.length && (eventCallback != null) ) {
					if (displayObj.hasEventListener(eventListener)) {
						displayObj.removeEventListener(eventListener, eventCallback);
					}	
				}
			}
		}
		
		/*public static function createObjectUI(objClass:Class):Object {
			return Manager.pool.pop(objClass);
		}
		
		public static function destroyObjectUI(obj:Object, objClass :Class = null):void {
			Manager.pool.push(obj, objClass);
		}*/
		
		public static function sumRewards(items:Array, rewardIDs:Array):void
		{
			for(var k:int = 0; k < rewardIDs.length; ++k)
			{
				var rewardID:int = rewardIDs[k];
				var rewardXML:RewardXML = Game.database.gamedata.getData(DataType.REWARD, rewardID) as RewardXML;
				if(rewardXML != null)
				{
					var item:Item = null;
					for each(item in items)
					{
						if(item.itemXML.type == rewardXML.type && item.itemXML.ID == rewardXML.itemID)
						{
							item.quantity += rewardXML.quantity;
							break;
						}
						else
						{
							item = null;
						}
					}
					if(item == null)
					{
						item = ItemFactory.createItem(rewardXML.type, rewardXML.itemID) as Item;
						if(item != null)
						{
							item.quantity = rewardXML.quantity;
							items.push(item);
						}
					}
				}
				else
				{
					//Utility.error("ERROR > itemID=" + itemID + " is undefined");
				}
			}
		}
	}

}