package game.ui.ingame 
{
	import core.util.TextFieldUtil;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import game.utility.UtilityUI;
	
	import core.Manager;
	import core.display.BitmapEx;
	import core.display.BitmapText;
	import core.display.animation.Animator;
	import core.display.pixmafont.PixmaFont;
	import core.display.pixmafont.PixmaText;
	import core.util.Enum;
	
	import game.Game;
	import game.data.model.item.IItemConfig;
	import game.data.model.item.ItemFactory;
	import game.data.vo.item.ItemInfo;
	import game.data.xml.CharacterXML;
	import game.data.xml.DataType;
	import game.data.xml.item.ItemXML;
	import game.enum.CharacterRarity;
	import game.enum.ItemType;
	import game.enum.Sex;
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class RewardItem extends BaseObject 
	{
		public static const OPENED	:String = "opened";
		public static const CLOSE	:int = 0;
		public static const OPEN	:int = 1;
		public static const REMAIN	:int = 2;
		
		public static const GOLD		:int = 0;
		public static const EXP			:int = 3;
		public static const CHARACTERS	:int = 6;
		public static const ITEMS		:int = 9;
		public static const HONOR		:int = 12;
		
		public static const ITEM_BITMAP_DATA_INDEX		:int = 4;
		public static const UNIT_BITMAP_DATA_INDEX		:int = 19;
		public static const ITEM_NAME_BITMAP_DATA_INDEX	:int = 7;
		public static const UNIT_NAME_BITMAP_DATA_INDEX	:int = 7;
		public static const EXP_BITMAP_DATA_INDEX		:int = 7;
		public static const GOLD_BITMAP_DATA_INDEX		:int = 7;
		public static const HONOR_BITMAP_DATA_INDEX		:int = 7;
		
		private var pixmaFonts		:Array;
		private var animator		:Animator;
		private var itemName		:TextField;
		private var rewardIcon		:BitmapEx;
		private var itemInfo		:ItemInfo;
		private var isOpened		:Boolean;
		private var replaceBitmap	:Array;
		private var iconBitmapData	:BitmapData;
		private var timeOutID		:int;
		private var x2				:Boolean;
		
		public function RewardItem() {
			animator = new Animator();
			animator.setCacheEnabled(false);
			animator.addEventListener(Animator.LOADED, onAnimLoadedHdl);
			animator.load("resource/anim/ui/ingame_rewards.banim");
			animator.stop();
			addChild(animator);
			
			itemName = TextFieldUtil.createTextfield("Arial", 14, 150, 50, 0xffffff, true, TextFormatAlign.CENTER);
			itemName.x = - itemName.width / 2;
			addChild(itemName);
			itemName.visible = false;
			
			pixmaFonts = [];
			for each (var rarityClass:CharacterRarity in Enum.getAll(CharacterRarity)) {
				var pixmaText:PixmaText = new PixmaText(rarityClass.fontURL);
				pixmaFonts[rarityClass.ID] = pixmaText;
			}
			
			animator.buttonMode = true;
			rewardIcon = new BitmapEx();
			addEventListener(MouseEvent.ROLL_OVER, onMouseOverHdl);
			
			isOpened = false;
			replaceBitmap = [];
		}
		
		public function setData(value:ItemInfo, x2:Boolean=false):void {
			this.x2 = x2;
			itemInfo = value;
			animator.addEventListener(Event.COMPLETE, onAnimCompleteHdl);
			var bitmapData:BitmapData;
			timeOutID = setTimeout(mouseOverHdl , 7500);
			var pixmaText:PixmaText;
			if (itemInfo) {
				switch(itemInfo.type) {
					case ItemType.GOLD:
						pixmaText = pixmaFonts[CharacterRarity.WHITE.ID];
						pixmaText.setText(itemInfo.quantity.toString());
						iconBitmapData = Manager.resource.getResourceByURL("resource/image/item/item_bac.png");
						bitmapData = new BitmapData(pixmaText.getWidth() + iconBitmapData.width, pixmaText.getHeight(), true, 0);
						bitmapData.draw(iconBitmapData);
						bitmapData.draw(pixmaText, new Matrix(1, 0, 0, 1, iconBitmapData.width, 0));
						animator.replaceFMBitmapData([GOLD_BITMAP_DATA_INDEX], [bitmapData]);
						animator.play(GOLD + CLOSE, -1);
						break;
						
					case ItemType.EXP:
						pixmaText = pixmaFonts[CharacterRarity.BLUE.ID];
						pixmaText.setText(itemInfo.quantity.toString());
						iconBitmapData = Manager.resource.getResourceByURL("resource/image/item/icon_exp.png");
						bitmapData = new BitmapData(pixmaText.getWidth() + iconBitmapData.width, pixmaText.getHeight(), true, 0);
						bitmapData.draw(iconBitmapData);
						bitmapData.draw(pixmaText, new Matrix(1, 0, 0, 1, iconBitmapData.width, 0));
						animator.replaceFMBitmapData([EXP_BITMAP_DATA_INDEX], [bitmapData]);	
						animator.play(EXP + CLOSE, -1);
						break;
						
					case ItemType.HONOR:
						pixmaText = pixmaFonts[CharacterRarity.GREEN.ID];
						pixmaText.setText(itemInfo.quantity.toString());
						bitmapData = new BitmapData(pixmaText.getWidth(), pixmaText.getHeight(), true, 0);
						bitmapData.draw(pixmaText);
						animator.replaceFMBitmapData([HONOR_BITMAP_DATA_INDEX], [bitmapData]);
						animator.play(HONOR + CLOSE, -1);
						break;
						
					case ItemType.UNIT:
						var characterXML:CharacterXML = Game.database.gamedata.getData(DataType.CHARACTER, itemInfo.id) as CharacterXML;
						if (characterXML) {
							pixmaText = pixmaFonts[characterXML.quality[0]];
							if (!pixmaText) {
								pixmaText = pixmaFonts[CharacterRarity.GREEN.ID];		
							}
							pixmaText.setText(characterXML.name);
							rewardIcon.addEventListener(BitmapEx.LOADED, onRewardIconLoadedHdl);
							rewardIcon.load(characterXML.largeAvatarURLs[Sex.FEMALE]);
						}
						break;

					default:
						var itemXML:ItemXML = ItemFactory.buildItemConfig(itemInfo.type, itemInfo.id) as ItemXML;
						pixmaText = pixmaFonts[CharacterRarity.GREEN.ID];
						if (itemXML) {
							animator.visible = true;
							pixmaText.setText(itemInfo.quantity + " " + itemXML.name + (x2 ? " (x2)" : ""));
							rewardIcon.addEventListener(BitmapEx.LOADED, onRewardIconLoadedHdl);
							rewardIcon.load(itemXML.getIconURL());
						} else {
							animator.visible = false;
						}
						break;
				}
				
			}
		}
		
		private function mouseOverHdl():void {
			onMouseOverHdl(null);
		}
		
		private function onRewardIconLoadedHdl(e:Event):void {
			rewardIcon.removeEventListener(BitmapEx.LOADED, onRewardIconLoadedHdl);
			var pixmaFont:PixmaText = pixmaFonts[CharacterRarity.GREEN.ID];
			if (rewardIcon && itemInfo) {
				switch(itemInfo.type) {
					case ItemType.UNIT:
						var characterXML:CharacterXML = Game.database.gamedata.getData(DataType.CHARACTER, itemInfo.id) as CharacterXML;
						if (characterXML) {
							pixmaFont = pixmaFonts[characterXML.quality[0]];
						}
						var bitmapData:BitmapData = new BitmapData(pixmaFont.getWidth(), pixmaFont.getHeight(), true, 0);
						bitmapData.draw(pixmaFont);
						replaceBitmap = [];
						replaceBitmap.push(bitmapData);
						replaceBitmap.push(rewardIcon.bitmapData);
						animator.replaceFMBitmapData([UNIT_NAME_BITMAP_DATA_INDEX, UNIT_BITMAP_DATA_INDEX], replaceBitmap);
						animator.play(CHARACTERS + CLOSE, -1);	
						break;
						
					default:
						bitmapData = new BitmapData(pixmaFont.getWidth(), pixmaFont.getHeight(), true, 0);
						bitmapData.draw(pixmaFont);
						replaceBitmap = [];
						replaceBitmap.push(bitmapData);
						replaceBitmap.push(rewardIcon.bitmapData);
						animator.replaceFMBitmapData([ITEM_NAME_BITMAP_DATA_INDEX, ITEM_BITMAP_DATA_INDEX], replaceBitmap);
						animator.play(ITEMS + CLOSE, -1);						
						break;
				}
			}
		}
		
		override public function reset():void {
			animator.visible = true;
			animator.reset();
			animator.stop();
			addEventListener(MouseEvent.ROLL_OVER, onMouseOverHdl);
			isOpened = false;
			replaceBitmap = [];
			clearTimeout(timeOutID);
			x2 = false;
		}
		
		override public function update(delta:Number):void {
			if (target != x) {
				var movementDelta:Number = delta * currentVelocity;
				if (Math.abs(x - target) < Math.abs(movementDelta)){
					x = target;
				}
				else x += movementDelta;
			} else {
				target = -1;
				currentVelocity = 0;
			}
		}
		
		public function getIsOpened():Boolean {
			return isOpened;
		}
		
		private function onMouseOverHdl(e:MouseEvent):void {
			removeEventListener(MouseEvent.ROLL_OVER, onMouseOverHdl);
			clearTimeout(timeOutID);
			var currentAnimIndex:int = animator.getCurrentAnimation();
			if ((currentAnimIndex % 3) == 0) {
				animator.play(currentAnimIndex + 1, 1);
			}
			
			itemName.visible = true;
			if (itemInfo) {
				switch(itemInfo.type) {
					case ItemType.UNIT:
						var character:CharacterXML = Game.database.gamedata.getData(DataType.CHARACTER, itemInfo.id) as CharacterXML;
						if (character) {
							itemName.text = character.name;
							if (character.quality.length) {
								itemName.textColor = UtilityUI.getTxtColorUINT(character.quality[0], false, false);	
							}
						}
						break;
						
					default:
						var itemType:ItemType = Enum.getEnum(ItemType, itemInfo.type.ID) as ItemType;
						if (itemType) {
							var itemData:ItemXML = Game.database.gamedata.getData(itemType.dataType, itemInfo.id) as ItemXML;
							if (itemData) {
								itemName.text = itemInfo.quantity + " " + itemData.name;
							} else {
								itemName.text = itemInfo.quantity.toString();
							}
						} else {
							itemName.text = itemInfo.quantity.toString();	
						}
						itemName.textColor = 0xffffff;
						break;
				}
			}
			isOpened = true;
			dispatchEvent(new Event(OPENED, true));
		}
		
		private function onAnimLoadedHdl(e:Event):void {
			
		}
		
		private function onAnimCompleteHdl(e:Event):void {
			removeEventListener(Event.COMPLETE, onAnimCompleteHdl);
			var currentAnimIndex:int = animator.getCurrentAnimation();
			if ((currentAnimIndex % 3) == 1) {
				animator.play(currentAnimIndex + 1, -1);
			}
		}
		
	}

}