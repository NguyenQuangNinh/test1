package game.ui.heal_hp 
{
	import core.display.animation.Animator;
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.util.Utility;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import game.enum.GameConfigID;
	import game.Game;
	import game.ui.heal_hp.gui.FoodInfoPanel;
	import game.ui.heal_hp.gui.FoodSlot;
	import game.utility.UtilityUI;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class HealHpView extends ViewBase
	{
		private static const SLOT_WIDTH : int = 125;
		private static const SLOT_Y : int = 419;
		private static const SLOT_BEGIN_X : int = 359;
		
		private var closeBtn:SimpleButton;
		public var foodInfoPanel : FoodInfoPanel;
		private var slots : Array = [];
		private var totalHpList : Array;
		
		private var foodNames : Array = ["Đùi gà", "Bánh bao", "Bún bò", "Kim sang dược"];
		
		private var iconUrls : Array = ["resource/image/ui/heal_hp/item_banhbao.png", "resource/image/ui/heal_hp/item_duiga.png",
										"resource/image/ui/heal_hp/item_bunbo.png", "resource/image/ui/heal_hp/item_kimsangduoc.png"];
										private var vipList:Array;
		public function HealHpView() 
		{
			
			foodInfoPanel.visible = false;
			closeBtn = UtilityUI.getComponent(UtilityUI.CLOSE_BTN) as SimpleButton;
			if (closeBtn != null) {
				closeBtn.x = 765;
				closeBtn.y = 145;
				addChild(closeBtn);
				closeBtn.addEventListener(MouseEvent.CLICK, closeHandler);
			}
			
			initSlots();
			
			var npcAnim : Animator = new Animator();
			npcAnim.x = 508 ;
			npcAnim.y = 385;
			npcAnim.load("resource/anim/ui/nhanvat.banim");
			
			this.addChildAt(npcAnim, 0);
		}
		
		private function initSlots():void 
		{
			var xuList : Array = Game.database.gamedata.getConfigData(GameConfigID.HEAL_HP_XU_LIST) as Array;
			vipList = Game.database.gamedata.getConfigData(GameConfigID.HEAL_HP_VIP_LIST) as Array;
			totalHpList = Game.database.gamedata.getConfigData(GameConfigID.HEAL_HP_TOTAL_ADDED_HP_LIST) as Array;
			
			for (var i:int = 0; i < 4; i++) 
			{
				var foodSlot : FoodSlot = new FoodSlot();
				foodSlot.loadIcon(iconUrls[i]);
				foodSlot.x = SLOT_BEGIN_X + i * SLOT_WIDTH;
				foodSlot.y = SLOT_Y;
				foodSlot.index = i;
				foodSlot.setPrice(xuList[i]);
				foodSlot.setVip(vipList[i]);
				this.addChild(foodSlot);
				slots.push(foodSlot);
			}
		}
		
		public function update() : void {
			for (var i:int = 0; i < slots.length; i++) 
			{
				FoodSlot(slots[i]).setVip(vipList[i]);
			}
		}
		
		private function closeHandler(e:MouseEvent):void 
		{
			this.dispatchEvent(new EventEx(HealHpEvent.CLOSE));
		}
		
		public function setTooltip(index : int) : void {
			foodInfoPanel.setFoodName(foodNames[index]);
			foodInfoPanel.setTotalHp(Utility.math.formatInteger(totalHpList[index]));
			foodInfoPanel.visible = true;
		}
		
		public function hideTooltip() : void {
			foodInfoPanel.visible = false;
		}
	}

}