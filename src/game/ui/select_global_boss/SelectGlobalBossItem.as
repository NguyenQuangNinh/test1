package game.ui.select_global_boss 
{
	import com.greensock.TweenMax;
	import core.display.BitmapEx;
	import core.display.layer.Layer;
	import core.event.EventEx;
	import core.Manager;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.data.vo.reward.RewardInfo;
	import game.data.xml.CharacterXML;
	import game.data.xml.DataType;
	import game.data.xml.MissionXML;
	import game.data.xml.UnitClassXML;
	import game.enum.Font;
	import game.enum.ItemType;
	import game.Game;
	import game.ui.components.ItemSlot;
	import game.ui.dialog.DialogID;
	import game.ui.tooltip.TooltipID;
	import game.utility.ElementUtil;
	import game.utility.GameUtil;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class SelectGlobalBossItem extends MovieClip 
	{
		
		public static const CLOSE			:int = 0;
		public static const OPEN_NOT_ACCESS	:int = 1;
		public static const OPEN			:int = 2;
		public static const FINISH			:int = 3;
		public static const BOSS_DIE		:int = 4;
		
		static public const SHOW_ERR_DIALOG	:String = "showErrDialog";
		
		public var iconMasker			:MovieClip;
		public var txtTitle			:TextField;
		public var txtElement		:TextField;
		public var txtDescription	:TextField;
		public var movIcon			:MovieClip;
		public var movReward		:MovieClip;
		public var movDirection		:MovieClip;
		
		public var doMissionBtn		:SimpleButton;
		public var viewTopBtn		:SimpleButton;
		public var viewGiftBtn		:SimpleButton;
		
		private var missionXML		:MissionXML;
		private var iconBitmap		:BitmapEx;
		private var rewards			:Array;
		private var status			:int;
		private var index			:int;
		private var bossName		:String;
		private var damageRequired	:int;
		
		public var bossType:int;
		
		public function SelectGlobalBossItem() {
			rewards = [];
			initUI();
			doMissionBtn.addEventListener(MouseEvent.CLICK, doMissionBtnClickHdl);
			viewTopBtn.addEventListener(MouseEvent.CLICK, viewTopBtnClickHdl);
			viewGiftBtn.addEventListener(MouseEvent.CLICK, viewGiftBtnClickHdl);
			status = OPEN;
		}
		
		private function viewGiftBtnClickHdl(e:MouseEvent):void 
		{
			dispatchEvent(new EventEx(SelectGlobalBossEvent.EVENT, { type:SelectGlobalBossEvent.VIEW_GIFT, missionID: missionXML.ID, bossType: bossType }, true));
		}
		
		private function viewTopBtnClickHdl(e:MouseEvent):void 
		{
			dispatchEvent(new EventEx(SelectGlobalBossEvent.EVENT, { type:SelectGlobalBossEvent.VIEW_TOP, missionID: missionXML.ID, bossType: bossType }, true));
		}
		
		private function doMissionBtnClickHdl(e:MouseEvent):void 
		{
			var obj:Object = { };
			switch(status) {
				case CLOSE:
					obj.content = "Boss chưa mở.";
					Manager.display.showDialog(DialogID.GLOBAL_BOSS_CONFIRM, null, null, obj, Layer.BLOCK_BLACK);
					break;
				
				case OPEN_NOT_ACCESS:
					if (missionXML) {
						dispatchEvent(new EventEx(SHOW_ERR_DIALOG, { index:index, missionID: missionXML.ID }, true));
					}
					break;
					
				case OPEN:
					if (missionXML) {
						dispatchEvent(new EventEx(SelectGlobalBossEvent.EVENT, { type:SelectGlobalBossEvent.REQUEST_MISSION_INFO, missionID: missionXML.ID, bossType: bossType }, true));
					}
					break;
					
				case FINISH:
					obj.content = "Bạn đã chinh phục boss này và thoát ra. Vì vậy không thể vào lại được nữa.";
					Manager.display.showDialog(DialogID.GLOBAL_BOSS_CONFIRM, null, null, obj, Layer.BLOCK_BLACK);
					break;
					
				case BOSS_DIE:
					obj.content = "Boss đã bị tiêu diệt.";
					Manager.display.showDialog(DialogID.GLOBAL_BOSS_CONFIRM, null, null, obj, Layer.BLOCK_BLACK);
					break;
			}
		}
		
		private function initUI():void {
			FontUtil.setFont(txtTitle, Font.ARIAL, true);
			FontUtil.setFont(txtDescription, Font.ARIAL);
			FontUtil.setFont(txtElement, Font.ARIAL);
			
			txtTitle.mouseEnabled = false;
			txtDescription.mouseEnabled = false;
			
			iconBitmap = new BitmapEx();
			iconBitmap.addEventListener(BitmapEx.LOADED, onIconLoadHdl);
			movIcon.addChild(iconBitmap);
			movIcon.mask = iconMasker;
		}
		
		private function onIconLoadHdl(e:Event):void {
			iconBitmap.x = - iconBitmap.width / 2;
			iconBitmap.y = - iconBitmap.height / 2;
		}
		
		public function setDamageRequired(number:Number, name:String):void {
			damageRequired = number;
			if (damageRequired > 0) {
				txtDescription.text = "Điều kiện: Boss " + name + " chết và gây hơn " 
									+ damageRequired.toString() + " sát thương lên " + name;
			} else {
				txtDescription.text = "Vào tự do";
			}
		}
		
		public function getDamageRequired():int {
			return damageRequired;
		}
		
		public function getBossName():String {
			return bossName;
		}
		
		public function setStatus(value:int):void {
			status = value;
			
			switch(value) {
				case CLOSE:
					TweenMax.to(this, 0, { colorMatrixFilter: { saturation:0.05 }} );
					movDirection.gotoAndStop(1);
					break;
				
				case OPEN_NOT_ACCESS:
					TweenMax.to(this, 0, { colorMatrixFilter: { saturation:1 }} );
					movDirection.gotoAndStop(1);
					break;
					
				case OPEN:
					TweenMax.to(this, 0, { colorMatrixFilter: { saturation:1 }} );
					movDirection.gotoAndStop(2);
					break;
					
				case FINISH:
					TweenMax.to(this, 0, { colorMatrixFilter: { saturation:0.05 }} );
					movDirection.gotoAndStop(2);
					break;
					
				case BOSS_DIE:
					TweenMax.to(this, 0, { colorMatrixFilter: { saturation:0.05 }} );
					movDirection.gotoAndStop(2);
					break;
			}
		}
		
		public function setData(value:MissionXML, index:int):void {
			missionXML = value;
			this.index = index;
			/*
			for each (var itemSlot:ItemSlot in rewards) {
				itemSlot.reset();
				Manager.pool.push(itemSlot, ItemSlot);
				movReward.removeChild(itemSlot);
			}
			rewards.splice(0);
			*/
			if (index != 0) {
				movDirection.visible = true;
			} else {
				movDirection.visible = false;
			}
			
			if (missionXML) {
				/*
				// update rewards mov
				var rewardInfos:Array = GameUtil.getRewardConfigs(missionXML.fixRewardIDs);
				if (rewardInfos) {
					var i:int = 0;
					var movWidth:int = 60 * rewardInfos.length - 10;
					for each (var reward:RewardInfo in rewardInfos) {
						itemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
						itemSlot.reset();
						itemSlot.setConfigInfo(reward.itemConfig, TooltipID.ITEM_COMMON);
						switch(reward.itemType) {
							case ItemType.GOLD:
								break;
								
							default:
								itemSlot.setQuantity(reward.quantity);
								break;
						}
						itemSlot.x = 60 * i - movWidth / 2 ;
						rewards.push(itemSlot);
						movReward.addChild(itemSlot);
						
						i++;
					}
				}
				*/
				var characterXML:CharacterXML;
				for each (var wave:Array in missionXML.waves) {
					for each (var characterID:int in wave) {
						characterXML = Game.database.gamedata.getData(DataType.CHARACTER, characterID) as CharacterXML;
						if (characterXML) {
							iconBitmap.load(characterXML.getIconURL());
							bossName = characterXML.getName();
							txtTitle.text = characterXML.getName();
							var unitClassXML:UnitClassXML = Game.database.gamedata.getData(DataType.UNITCLASS, characterXML.characterClass) as UnitClassXML;
							if (unitClassXML) {
								var elementID:int = unitClassXML.element;
								addChild(txtElement);
								txtElement.text = "(Hệ: " + ElementUtil.getName(elementID) + ")";
							}
							return;
						}
					}
				}
			}	
		}
		
	}

}