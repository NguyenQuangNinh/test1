package game.ui.inventoryitem
{
	import com.greensock.TweenMax;

	import flash.display.MovieClip;

	import game.data.model.item.IItemConfig;
	import game.data.model.item.ItemFactory;

	import game.data.xml.DataType;

	import game.data.xml.RewardXML;

	import game.data.xml.item.ItemChestXML;
	import game.net.lobby.request.RequestUseItems;
	import game.ui.chat.ChatModule;
	
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import core.Manager;
	import core.display.BitmapEx;
	import core.display.ViewBase;
	import core.display.animation.Animator;
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;
	import core.enum.Align;
	import core.event.EventEx;
	import core.util.FontUtil;
	
	import game.Game;
	import game.data.model.Character;
	import game.data.model.item.Item;
	import game.enum.Font;
	import game.enum.ItemType;
	import game.net.IntRequestPacket;
	import game.net.RequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.ui.ModuleID;
	import game.ui.components.ItemSlot;
	import game.ui.components.StarBase;
	import game.ui.dialog.DialogID;
	import game.ui.dialog.dialogs.YesNo;
	import game.ui.inventoryitem.gui.AllTap;
	import game.ui.inventoryitem.gui.CellPanel;
	import game.ui.inventoryitem.gui.ConsumableTap;
	import game.ui.inventoryitem.gui.FunctionalTap;
	import game.ui.inventoryitem.gui.ItemCell;
	import game.ui.inventoryitem.gui.QuestTap;
	import game.ui.inventoryitem.gui.UseItemPopup;
	import game.ui.tooltip.TooltipEvent;
	import game.utility.UtilityEffect;
	import game.utility.UtilityUI;
	
	/**
	 * ...
	 * @author anhtinh
	 */
	public class InventoryItemView extends ViewBase
	{
		private static const ALL_TAP_INDEX:int = 0;
		private static const CONSUMABLE_TAP_INDEX:int = 1;
		private static const FUNCTIONAL_TAP_INDEX:int = 2;
		private static const QUEST_TAP_INDEX:int = 3;
		
		public var allTap:AllTap;
		public var consumableTap:ConsumableTap;
		public var functionalTap:FunctionalTap;
		public var questTap:QuestTap;
		public var msgTf:TextField;
		public var cursorDelete:BitmapEx = new BitmapEx();
		
		public var btnSortItem:SimpleButton;
		public var btnDeleteItem:SimpleButton;
		public var useItemPopup:UseItemPopup;
		public var cellPanelContainer:MovieClip;

		private var closeBtn:SimpleButton;
		private var taps:Array;
		private var cellPanel:CellPanel = new CellPanel();
		private var currentTap:int = ALL_TAP_INDEX;
		
		private var animOpenItem:Animator = new Animator();
		public var clickItemSlotIndex:int = -1;
		public var clickItemSlot:Item;

		public var bDeleteItem:Boolean = false;
		
		public function InventoryItemView()
		{
			
			closeBtn = UtilityUI.getComponent(UtilityUI.CLOSE_BTN) as SimpleButton;
			
			if (closeBtn != null)
			{
				closeBtn.x = 375;
				closeBtn.y = 0;
				addChild(closeBtn);
				closeBtn.addEventListener(MouseEvent.CLICK, closeInventoryHandler);
			}
			
			taps = [allTap, consumableTap, functionalTap, questTap];
			
			for each (var tap:StarBase in taps)
			{
				tap.addEventListener(MouseEvent.CLICK, onTapClick);
			}
			
			reset();

			cellPanelContainer.addChild(cellPanel);
			
			FontUtil.setFont(msgTf, Font.ARIAL, false);
			
			animOpenItem.load("resource/anim/ui/hieuung_mo_qua.banim");
			this.addEventListener(Animator.LOADED, onLoadedAnim);
			this.addChild(animOpenItem);
			
			btnDeleteItem.addEventListener(MouseEvent.CLICK, onDeleteItem);
			btnSortItem.addEventListener(MouseEvent.CLICK, onSortItem);
			
			cursorDelete.load("resource/image/sell.png");
			cursorDelete.visible = false;

			useItemPopup.hide();

			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			this.addEventListener(ItemCell.ITEM_CELL_DOUBLE_CLICK, onItemCellDoubleClick);
			this.addEventListener(ItemCell.ITEM_CELL_CLICK, onItemCellClickHdl);
		}
		
		private function onItemCellClickHdl(e:EventEx):void {
			var item:Item = e.data as Item;
			if (item && item.itemXML) {
				if (bDeleteItem) //delete item
				{
					var dialogData:Object = {};
					dialogData.title = "Thông báo";
					dialogData.message = "Bạn có muốn xóa: " + item.itemXML.getName() + " hay không?"
					dialogData.option = YesNo.YES | YesNo.CLOSE | YesNo.NO;
					Manager.display.showDialog(DialogID.YES_NO, function():void
						{
							Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.INVENTORY_SELL_ITEM, item.index));
						}, null, dialogData, Layer.BLOCK_BLACK);
				}
			}
		}

		private function useItem(item:Item):void
		{
			this.clickItemSlotIndex = item.index;
			this.clickItemSlot = item;

			var total:int = Game.database.inventory.getItemQuantity(item.itemXML.type, item.itemXML.ID);
			if(total > 1)
			{
				useItemPopup.show(item, total);
			}
			else
			{
				Game.network.lobby.sendPacket(new RequestUseItems(item.itemXML.type.ID,item.xmlData.ID, 1));
			}

			this.dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
		}

		private function onItemCellDoubleClick(e:EventEx):void
		{
			var item:Item = e.data as Item;
			if (item && item.itemXML)
			{
				switch(item.itemXML.type) {
					case ItemType.NORMAL_CHEST:
						useItem(item);
						break;
					case ItemType.LUCKY_CHEST:
						this.clickItemSlotIndex = item.index;
						this.clickItemSlot = item;
						Game.network.lobby.sendPacket(new RequestUseItems(item.itemXML.type.ID,item.xmlData.ID, 1));
						this.dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
						break;
						
					case ItemType.MASTER_INVITATION_CHEST:
						Manager.display.showModule(ModuleID.MASTER_INVITATION, new Point(), LayerManager.LAYER_DIALOG, Align.CENTER, Layer.BLOCK_BLACK, item);
						break;
						
					case ItemType.PRESENT_VIP_CHEST:
						Manager.display.showModule(ModuleID.OPEN_PRESENT_VIP, new Point(), LayerManager.LAYER_DIALOG, Align.CENTER, Layer.BLOCK_BLACK, item);
						break;
						
					case ItemType.SPEAKER:
						ChatModule(Manager.module.getModuleByID(ModuleID.CHAT)).enableSpeaker(item.itemXML.value);
						break;
				}
				
			}
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			if (cursorDelete.visible)
			{
				cursorDelete.x = e.stageX - this.x;
				cursorDelete.y = e.stageY - this.y;
			}
		}
		
		private function onDeleteItem(e:MouseEvent):void
		{
			
			cursorDelete.visible = !cursorDelete.visible;
			bDeleteItem = !bDeleteItem;
			
			if (cursorDelete.visible)
			{
				cursorDelete.x = e.stageX - this.x;
				cursorDelete.y = e.stageY - this.y;
				
				this.addChild(cursorDelete);
			}
			else
				this.removeChild(cursorDelete);
		}
		
		private function onSortItem(e:Event):void
		{
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.SORT_ITEM_INVENTORY));
		}
		
		private function onLoadedAnim(e:Event):void
		{
			animOpenItem.visible = false;
			animOpenItem.stop();
		}
		
		public function updateInventoryItemView():void
		{
			switch (currentTap)
			{
				case ALL_TAP_INDEX: 
					cellPanel.update(Game.database.inventory.getAllItems(), true);
					break;
				
				case CONSUMABLE_TAP_INDEX: 
					cellPanel.update(Game.database.inventory.getItemsByFilter(1), false);
					break;
				
				case FUNCTIONAL_TAP_INDEX: 
					cellPanel.update(Game.database.inventory.getItemsByFilter(2), false);
					break;
				
				case QUEST_TAP_INDEX: 
					cellPanel.update(Game.database.inventory.getItemsByFilter(3), false);
					break;
				default: 
			}
		
		}
		
		override protected function transitionInComplete():void
		{
			super.transitionInComplete();
			
			if (bDeleteItem)
			{
				bDeleteItem = false;
				cursorDelete.visible = false;
			}
		}
		
		public function updateView():void
		{
			msgTf.text = Game.database.inventory.getItemsNotContainNull().length + "/" + Game.database.inventory.getAllItems().length;
		}
		
		private function onTapClick(e:MouseEvent):void
		{
			var target:StarBase = e.target as StarBase;
			if (target.isActive)
				return;
			
			clearTaps();
			
			target.isActive = true;
			
			switch (target)
			{
				case allTap: 
					cellPanel.setItemList(Game.database.inventory.getAllItems(), true);
					currentTap = ALL_TAP_INDEX;
					break;
				case consumableTap: 
					cellPanel.setItemList(Game.database.inventory.getItemsByFilter(1), false);
					currentTap = CONSUMABLE_TAP_INDEX;
					break;
				case functionalTap: 
					cellPanel.setItemList(Game.database.inventory.getItemsByFilter(2), false);
					currentTap = FUNCTIONAL_TAP_INDEX;
					break;
				case questTap: 
					cellPanel.setItemList(Game.database.inventory.getItemsByFilter(3), false);
					currentTap = QUEST_TAP_INDEX;
					break;
			
			}
			
			btnSortItem.mouseEnabled = currentTap == ALL_TAP_INDEX;
			var nSaturation:int = currentTap == ALL_TAP_INDEX ? 1 : 0;
			TweenMax.to(btnSortItem, 0, {alpha: 1, colorMatrixFilter: {saturation: nSaturation}});
		}
		
		private function closeInventoryHandler(e:MouseEvent):void
		{
			this.dispatchEvent(new EventEx(InventoryItemEvent.HIDE_INVENTORY));
		}
		
		public function reset():void
		{
			clearTaps();
			allTap.isActive = true;
			currentTap = ALL_TAP_INDEX;
		}
		
		private function clearTaps():void
		{
			for each (var tap:StarBase in taps)
			{
				tap.isActive = false;
			}
		}
		
		public function playAnimOpenItem():void
		{
			if (clickItemSlotIndex != -1)
			{
				
				animOpenItem.x = (clickItemSlotIndex % 5) * CellPanel.CELL_WIDTH - 30;
				animOpenItem.y = Math.floor(clickItemSlotIndex / 5) * CellPanel.CELL_HEIGHT - 30;
				
				animOpenItem.visible = true;
				animOpenItem.play(0, 1);
				clickItemSlotIndex = -1; //reset
			}
		}

		private var arrRewardEffect:Array;

		public function playAnimUnpackChest(numUse:int):void
		{
			var item:Item = clickItemSlot;
			var itemChestXML:ItemChestXML = item.xmlData as ItemChestXML;

			if(itemChestXML == null) return;

			var stageWidth:int = Manager.display.getStage().stageWidth;
			var stageHeight:int = Manager.display.getStage().stageHeight;
			var slot:ItemSlot;

			arrRewardEffect = [];
			for (var i:int = 0; i < itemChestXML.rewardIDs.length; i++)
			{
				var rewardID:int = itemChestXML.rewardIDs[i] as int;
				var rewardXML:RewardXML = Game.database.gamedata.getData(DataType.REWARD, rewardID) as RewardXML;
				var config:IItemConfig = ItemFactory.buildItemConfig(rewardXML.type, rewardXML.itemID);

				slot = Manager.pool.pop(ItemSlot) as ItemSlot;
				slot.x = (stageWidth - length*65)/2 + i* 65;
				slot.y = (stageHeight - 65)/2;
				slot.setConfigInfo(config);
				slot.setQuantity(numUse * rewardXML.quantity);
				arrRewardEffect.push(slot);
			}

			UtilityEffect.tweenItemEffects(arrRewardEffect, function():void
			{
				for each(var slot:ItemSlot in arrRewardEffect)
				{
					slot.reset();
					Manager.pool.push(slot, ItemSlot);
				}

				arrRewardEffect = [];
			}, true);
		}

		public function checkHitDragFromItemInventory(objDrag:DisplayObject, item:Item):void 
		{
			if (cellPanel)
				cellPanel.checkHitDragFromItemInventory(objDrag,item);
		}
	}

}