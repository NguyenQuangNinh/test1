package game.ui.soul_center
{
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;
	import core.display.ModuleBase;
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.Utility;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import game.data.model.item.ItemFactory;
	import game.data.model.item.SoulItem;
	import game.enum.Direction;
	import game.enum.InventoryMode;
	import game.enum.ItemType;
	import game.Game;
	import game.ui.components.ToggleMov;
	import game.ui.dialog.DialogID;
	import game.ui.dialog.dialogs.YesNo;
	import game.ui.inventory.InventoryModule;
	import game.ui.inventory.InventoryView;
	import game.ui.message.MessageID;
	import game.ui.ModuleID;
	import game.ui.soul_center.event.EventSoulCenter;
	import game.ui.soul_center.gui.AttachSoulPanel;
	import game.ui.soul_center.gui.DivineSoulPanel;
	import game.ui.soul_center.gui.ExchangePointInfo;
	import game.ui.soul_center.gui.MergeSoulPanel;
	import game.ui.soul_center.gui.NodeCell;
	import game.ui.soul_center.gui.SoulContentPanel;
	import game.ui.soul_center.gui.SoulInventoryUI;
	import game.ui.soul_center.gui.SoulNode;
	import game.ui.soul_center.gui.SoulSlot;
	import game.ui.soul_center.gui.toggle.AttachSoulTap;
	import game.ui.soul_center.gui.toggle.DivineSoulTap;
	import game.ui.soul_center.gui.toggle.MergeSoulTap;
	import game.ui.tutorial.TutorialEvent;

	/**
	 * ...
	 * @author anhtinh
	 */
	public class SoulCenterView extends ViewBase
	{
		public var closeBtn:SimpleButton;
		public var divineSoulTap:DivineSoulTap;
		public var attachSoulTap:AttachSoulTap;
		public var mergeSoulTap:MergeSoulTap;
		
		public var soulInventoryUI:SoulInventoryUI;
		public var soulPanel:SoulContentPanel;
		public var mergeSoulPanel:MergeSoulPanel;
		public var attachSoulPanel:AttachSoulPanel;
		public var guideMov:MovieClip;
		
		private var currentTap:ToggleMov;
		
		public function SoulCenterView()
		{			
			showTap(divineSoulTap);
			
			closeBtn.addEventListener(MouseEvent.CLICK, onClose);
			divineSoulTap.addEventListener(MouseEvent.CLICK, tapClickHandler);
			attachSoulTap.addEventListener(MouseEvent.CLICK, tapClickHandler);
			mergeSoulTap.addEventListener(MouseEvent.CLICK, tapClickHandler);
			
			addEventListener(SoulSlot.SOUL_SLOT_DCLICK, onSoulSlotDClickHdl);
			addEventListener(SoulNode.SOUL_NODE_DCLICK, onSoulNodeDClickHdl);
			addEventListener(NodeCell.NODE_CELL_DCLICK, onNodeCellDClickHdl);
			
			addEventListener(EventSoulCenter.AUTO_INSERT_SOUL_RECIPE, onAutoInsertSoulRecipeHdl);		
		}

		public function showHintButton():void
		{
			if(currentTap == divineSoulTap)
			{
				if(soulPanel.divinePanel.countGoodSoul() >= 3)
				{
					var receiveAllBtn:SimpleButton = soulPanel.divinePanel.getAllSoulBtn;
					Game.hint.showHint(receiveAllBtn, Direction.DOWN, receiveAllBtn.x + receiveAllBtn.width / 2, receiveAllBtn.y, "Nhận hết Mệnh Khí");
				}
				else
				{
					var devineBtn:SimpleButton = soulPanel.divinePanel.normalDivineBtn;
					Game.hint.showHint(devineBtn, Direction.LEFT, devineBtn.x + devineBtn.width, devineBtn.y + devineBtn.height/2, "Click chuột");
				}
			}
			else if(currentTap == mergeSoulTap)
			{
				if(mergeSoulPanel.itemMerge.isActive)
				{
					if(mergeSoulPanel.hasRecipe())
					{
						var mergeBtn:SimpleButton = mergeSoulPanel.mergeBtn as SimpleButton;
						Game.hint.showHint(mergeBtn, Direction.LEFT, mergeBtn.x + mergeBtn.width, mergeBtn.y + mergeBtn.height/2, "Click chuột");
					}
					else
					{
						var auto:SimpleButton = mergeSoulPanel.autoMergeBtn as SimpleButton;
						Game.hint.showHint(auto, Direction.LEFT, auto.x + auto.width, auto.y + auto.height/2, "Click chuột");
					}
				}
				else
				{
					showHintSlot();
				}
			}
			else if(currentTap == attachSoulTap)
			{
				showHintSlot();
			}
		}

		public function showHintTab(index:int = 1):void
		{
			switch (index)
			{
				case 0:
					break;
				case 1:
					Game.hint.showHint(mergeSoulTap, Direction.UP, mergeSoulTap.x + mergeSoulTap.width / 2, mergeSoulTap.y + mergeSoulTap.height - 20, "Ghép Mệnh Khí");
					break;
				case 2:
					Game.hint.showHint(attachSoulTap, Direction.UP, attachSoulTap.x + attachSoulTap.width / 2, attachSoulTap.y + attachSoulTap.height - 20, "Lắp Mệnh Khí");
					break;
			}
		}

		public function showHintSlot():void
		{
			var slot:SoulSlot = soulInventoryUI.getSoulSlot();
			if(slot && !slot.isEmpty)
			{
				Game.hint.showHint(slot, Direction.LEFT, slot.x + slot.width, slot.y + slot.height/2, "Click đúp để gắn Mệnh Khí");
			}
			else
			{

			}
		}

		private function onSoulNodeDClickHdl(e:EventEx):void 
		{
			var nodeIndex:int = e.data ? e.data.index : -1;
			var nodeInfo:SoulItem = e.data ? e.data.info : null;
			if (nodeIndex > -1 && nodeInfo) {
				mergeSoulPanel.updateSoulAtIndex(nodeIndex, ItemFactory.createItem(ItemType.EMPTY_SLOT, 0, SoulItem) as SoulItem);
				nodeInfo.usedInMerge = false;
				setSlotMerge(nodeInfo);
			}
		}
		
		private function onNodeCellDClickHdl(e:EventEx):void 
		{
			var nodeIndex:int = e.data ? e.data.index : -1;
			var nodeInfo:SoulItem = e.data ? e.data.info : null;
			if (nodeIndex > -1 && nodeInfo) {
				attachSoulPanel.removeAttachAtIndex(nodeIndex);
			}
		}
		
		private function onAutoInsertSoulRecipeHdl(e:EventSoulCenter):void 
		{
			//auto insert to all empty slot
			var numRecipe:int = mergeSoulPanel.numSlotRecipeAvailable();
			Utility.log("num recipe available: " + numRecipe);
			var recipeArrObj:Object = Game.database.inventory.getSoulsAvailableByNumber(numRecipe, true);
			
			if (recipeArrObj.rare) {
				//confirm to use goodSoul
				var dialogData:Object = {};
				dialogData.title = "Nâng Cấp Mệnh Khí";
				dialogData.message = "Có mệnh khí hiếm, các hạ có muốn dùng làm nguyên liệu ?";
				dialogData.option = YesNo.YES | YesNo.CLOSE | YesNo.NO;
				dialogData.info = recipeArrObj.data;
				Manager.display.showDialog(DialogID.YES_NO, onAcceptUseRare, null, dialogData, Layer.BLOCK_BLACK);
			}else {								
				onAcceptUseRare( { info: recipeArrObj.data } );				
			}
		}
		
		private function onAcceptUseRare(data:Object):void 
		{
			for each(var soul:SoulItem in data.info) {
				if (mergeSoulPanel.checkInsertSoul(soul))
					setSlotMerge(soul);
			}
		}
		
		public function onSoulSlotDClickHdl(e:EventEx):void 
		{
			var soul:SoulItem = e.data as SoulItem;			
			switch(currentTap) {
				case divineSoulTap:
					
					break;
				case mergeSoulTap:
					if (soul.isRecipeSoul() && !mergeSoulPanel.itemMerge.isActive) {
						Manager.display.showMessageID(MessageID.MERGE_SOUL_FAIL_BY_RECIPE);
						return;
					}
						
					if (mergeSoulPanel.checkInsertSoul(soul))
					{
						setSlotMerge(e.data as SoulItem);
						dispatchEvent(new EventEx(TutorialEvent.EVENT, {type: TutorialEvent.SOUL_DCLICK_SOUL_CENTER}, true));
					}
					break;
				case attachSoulTap:
					if (soul.isRecipeSoul()) 
					{
						Manager.display.showMessageID(MessageID.ATTACH_SOUL_FAIL_BY_RECIPE);
					}else {
						attachSoulPanel.checkInsertSoul(soul);
					}	
					break;
			}
		}
		
		public function setSlotMerge(data: SoulItem):void {
			soulInventoryUI.setSlotMerge(data);
		}
		
		private function tapClickHandler(e:MouseEvent):void
		{
			showTap(e.target as ToggleMov);

			if(e.target == divineSoulTap)
			{
				dispatchEvent(new EventEx(TutorialEvent.EVENT, {type: TutorialEvent.TAB_CLICK_SOUL_CENTER, index: 0}, true));
			}
			else if(e.target == mergeSoulTap)
			{
				dispatchEvent(new EventEx(TutorialEvent.EVENT, {type: TutorialEvent.TAB_CLICK_SOUL_CENTER, index: 1}, true));
			}
			else if(e.target == attachSoulTap)
			{
				dispatchEvent(new EventEx(TutorialEvent.EVENT, {type: TutorialEvent.TAB_CLICK_SOUL_CENTER, index: 2}, true));
			}
		}
		
		public function resetUI():void {
			//mergeSoulPanel.resetUI();
			showTap(divineSoulTap);
		}
		
		private function showTap(tapMov:ToggleMov):void
		{
			if(currentTap != tapMov) {
				this.currentTap = tapMov;
				divineSoulTap.isActive = currentTap == divineSoulTap;
				soulPanel.visible  = currentTap == divineSoulTap;
				
				mergeSoulPanel.resetUI();
				mergeSoulTap.isActive = currentTap == mergeSoulTap;
				mergeSoulPanel.visible  = currentTap == mergeSoulTap;
				
				attachSoulTap.isActive = currentTap == attachSoulTap;
				attachSoulPanel.visible  = currentTap == attachSoulTap; 
				
				if (currentTap == mergeSoulTap || currentTap == attachSoulTap) {
					guideMov.visible = true;
					guideMov.gotoAndStop(currentTap == mergeSoulTap ? "merge" : "attach");
				}else {
					guideMov.visible = false;
				}
			}
		}
		
		private function onClose(e:MouseEvent):void
		{
			this.dispatchEvent(new EventSoulCenter(EventSoulCenter.HIDE_POPUP, null, true));
		}
		
		public function checkHitDragFromInventory(dragObj:DisplayObject, soulItem:SoulItem):void
		{				
			/*switch(currentTap) {
				case attachSoulTap:
					//check hit on attach soul panel
					var attachHit:Boolean = attachSoulPanel.checkHitDropToEquip(dragObj, soulItem);
					break;
				case mergeSoulTap:
					//check hit on merget soul panel	
					var mergeHit:Boolean = mergeSoulPanel.checkHitDropToEquip(dragObj, soulItem);
					if (mergeHit)
						setSlotMerge(soulItem);
					break;
			}*/
			//check it on inventory itself
			//if (!mergeHit || !attachHit)
				soulInventoryUI.checkHitDropOnInventory(dragObj, soulItem);
		}
		
		public function checkHitDragFromNodeChain(drapObj:DisplayObject, soulItem:SoulItem):void
		{
			var inventoryHit:Boolean = soulInventoryUI.checkHitDropFromNodeChain(drapObj,
											soulItem, attachSoulPanel.soulCharacterChain.currentCharacter.ID);
			if (!inventoryHit)
				attachSoulPanel.soulCharacterChain.checkHitDropToSwap(drapObj, soulItem);
		}
		
		/*public function checkHitDragFromMergeSoul(dragObj:DisplayObject, soulItem:SoulItem, nodeIndex:int):void {
			var inventoryHit:Boolean = soulInventoryUI.checkHitDropFromMergeSoul(dragObj, soulItem);
			if (!inventoryHit)
				mergeSoulPanel.checkHitDropToSwap(dragObj, soulItem, nodeIndex);
		}*/
		
		
		public function buyItemSuccess():void
		{
			soulPanel.buyItemSuccess();
		}
		
		public function updateExchangePoint():void
		{
			soulPanel.updateExchangePoint();
		}
		
		public function activeAutoDivine(active:Boolean):void {
			soulPanel.activeAutoDivine(active);
		}
		
	}

}