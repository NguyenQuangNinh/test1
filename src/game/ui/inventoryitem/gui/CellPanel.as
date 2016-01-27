package game.ui.inventoryitem.gui
{
	import core.util.Utility;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import game.data.model.item.Item;
	import game.Game;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.request.RequestSwapItemInventory;
	//import game.ui.components.ItemSlot;
	import game.ui.components.PagingMov;
	
	/**
	 * ...
	 * @author anhtinh
	 */
	public class CellPanel extends Sprite
	{
		
		public static const CELL_PER_PAGE:int = 25;
		public static const CELL_WIDTH:int = 59;
		public static const CELL_HEIGHT:int = 62;
		
		private var pagingMov:PagingMov = new PagingMov();
		private var container:Sprite = new Sprite();
		private var items:Array;
		private var totalPage:int;
		private var currentPage:int;
		private var showLockCell:Boolean;
		private var _isInit:Boolean;
		
		public function CellPanel()
		{
			this.addChild(container);
			
			pagingMov.x = 84;
			pagingMov.y = 305;
			
			this.addChild(pagingMov);
			
			pagingMov.addEventListener(PagingMov.GO_TO_PREV, prevHandler);
			pagingMov.addEventListener(PagingMov.GO_TO_NEXT, nextHandler);
		}
		
		private function prevHandler(e:Event):void
		{
			currentPage--;
			pagingMov.update(currentPage, totalPage);
			updatePage(showLockCell);
		}
		
		private function nextHandler(e:Event):void
		{
			currentPage++;
			pagingMov.update(currentPage, totalPage);
			updatePage(showLockCell);
		}
		
		public function setItemList(items:Array, showLockCell:Boolean):void
		{
			this.items = items;
			this.showLockCell = showLockCell;
			
			totalPage = Math.ceil(this.items.length / CELL_PER_PAGE);
			if (this.items.length % CELL_PER_PAGE == 0)
				totalPage++;
			
			currentPage = 1;
			pagingMov.update(currentPage, totalPage);
			
			updatePage(showLockCell);
		}
		
		public function update(items:Array, showLockCell:Boolean):void
		{
			this.items = items;
			this.showLockCell = showLockCell;
			
			totalPage = Math.ceil(this.items.length / CELL_PER_PAGE);
			if (this.items.length % CELL_PER_PAGE == 0)
				totalPage++;
			
			currentPage = Utility.math.clamp(currentPage, 1, totalPage)
			pagingMov.update(currentPage, totalPage);
			
			updatePage(showLockCell);
		}
		
		public function checkHitDragFromItemInventory(objDrag:DisplayObject, item:Item):void
		{
			if (item)
			{
				for (var i:int = 0; i < container.numChildren; i++)
				{
					var child:ItemCell = container.getChildAt(i) as ItemCell;
					
					
					if (child && child.status != ItemCell.LOCK && child.checkContains(objDrag.x , objDrag.y))
					//if (child && child.status != ItemCell.LOCK && child.getRect(stage).containsPoint(new Point(stage.mouseX, stage.mouseY)))
					{
						var sourceIndex:int = item.index;
						var targetIndex:int = child.getData().index;
						if (sourceIndex != targetIndex)
						{
							Utility.log("src:" + sourceIndex);
							Utility.log("target:" + targetIndex);
							Game.network.lobby.sendPacket(new RequestSwapItemInventory(LobbyRequestType.SWAP_ITEM_INVENTORY, sourceIndex, targetIndex));
						}
					}
				}
			}
		}
		
		private function updatePage(showLockCell:Boolean = true):void
		{
			if (this.items == null)
				return;
			
			var beginIndex:int = (currentPage - 1) * CELL_PER_PAGE;
			var endIndex:int = Math.min(currentPage * CELL_PER_PAGE, this.items.length);
			var numItem:int = endIndex - beginIndex;
			
			while (this.container.numChildren > 0)
			{
				var child:ItemCell = container.getChildAt(0) as ItemCell;
				child.destroy();
				container.removeChild(child);
			}
			
			for (var i:int = 0; i < numItem; i++)
			{
				
				var itemCell:ItemCell = new ItemCell();
				itemCell.status = ItemCell.UNLOCK;
				itemCell.x = (i % 5) * CELL_WIDTH;
				itemCell.y = Math.floor(i / 5) * CELL_HEIGHT;
				
				this.container.addChild(itemCell);
				
				var item:Item = items[beginIndex + i] as Item;
				itemCell.setData(item);
				
			}
			
			if (showLockCell && numItem < CELL_PER_PAGE)
			{
				
				for (var j:int = numItem; j < CELL_PER_PAGE; j++)
				{
					var itemCell2:ItemCell = new ItemCell();
					itemCell2.status = (j > numItem) ? ItemCell.LOCK : ItemCell.UNLOCK_GUILD;
					itemCell2.x = (j % 5) * CELL_WIDTH;
					itemCell2.y = Math.floor(j / 5) * CELL_HEIGHT;
					
					this.container.addChild(itemCell2);
				}
			}
		}
	}

}