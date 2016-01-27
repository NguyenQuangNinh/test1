package game.ui.soul_center.gui
{
	import components.scroll.VerScroll;
	import core.display.layer.Layer;
	import core.event.EventEx;
	import core.Manager;
	import core.util.MovieClipUtils;
	import core.util.Utility;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.utils.getDefinitionByName;
	import game.data.model.item.SoulItem;
	import game.data.xml.item.SoulXML;
	import game.enum.DialogEventType;
	import game.enum.ItemType;
	import game.Game;
	import game.ui.components.ScrollBar;
	import game.ui.dialog.DialogID;
	import game.ui.player_profile.Soul;
	import game.ui.soul_center.event.EventSoulCenter;
	
	/**
	 * ...
	 * @author anhtinh
	 */
	public class SoulInventoryUI extends MovieClip
	{
		
		private static const VIEW_COLUMNS:int = 4;
		private static const VIEW_ROWS:int = 6;
		
		public var maskMov:MovieClip;
		public var scrollbar:MovieClip;
		public var scroller:VerScroll;
		
		public var lockBtn:SimpleButton;
		//public var sortBtn:SimpleButton;
		
		private var _lockMov:MovieClip;
		private var _content:MovieClip = new MovieClip();
		private var _soulSlots:Array = [];
		
		private var _soulSelected:SoulSlot;
		private var _isSelectLock:Boolean = false;
		
		public function SoulInventoryUI()
		{
			maskMov.visible = false;
			_content.x = 11;
			_content.y = 75;
			this.addChild(_content);
			
			var lockClass:Class = getDefinitionByName("LockMov") as Class;
			_lockMov = lockClass ? new lockClass() as MovieClip : new MovieClip();
			_lockMov.visible = false;
			Manager.display.getStage().addChild(_lockMov);
			
			lockBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			//sortBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			addEventListener(SoulSlot.SOUL_SLOT_CLICK, onSoulSlotClickHdl);
			Manager.display.getStage().addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHdl);
			//addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHdl);
			//content.addEventListener(SoulSlot.SOUL_SLOT_CLICK, onSoulSlotClickHdl);
		}
		
		private function onSoulSlotClickHdl(e:EventEx):void
		{
			var soulInfo:SoulItem = e.data ? e.data as SoulItem : null;
			//var slotData:SoulItem = e.data ? e.data.info as SoulItem : null;
			/*if (slot && _soulSlots.indexOf(slot) != -1) {
			   slot.status = !slot.isEmpty && slot.status == SoulSlot.UNLOCK ? SoulSlot.LOCK_MERGE :
			   slot.status == SoulSlot.LOCK_MERGE ? SoulSlot.UNLOCK : slot.status;
			 }*/
			
			/*for each (var slot:SoulSlot in _soulSlots)
			{
				if (slot && slot.soulItem == soulInfo)
				{
					//slot.status = !slot.isEmpty && slot.status == SoulSlot.UNLOCK ? SoulSlot.LOCK_MERGE : slot.status == SoulSlot.LOCK_MERGE ? SoulSlot.UNLOCK : slot.status;
					dispatchEvent(new EventSoulCenter(EventSoulCenter.LOCK_MERGE_SOUL, slot.soulItem, true));
					break;
				}
			}*/
			var slot:SoulSlot = e.target as SoulSlot;
			if (_isSelectLock && slot && !slot.isEmpty)
				dispatchEvent(new EventSoulCenter(EventSoulCenter.LOCK_MERGE_SOUL, slot.soulItem, true));
			_isSelectLock = false;
			processLock();
		}
		
		/*private function onMouseOutHdl(e:MouseEvent):void
		   {
		   lockMov.visible = false;
		   Mouse.show();
		 }*/
		
		private function onMouseMoveHdl(e:MouseEvent):void
		{
			if (_isSelectLock)
			{
				_lockMov.x = e.stageX;
				_lockMov.y = e.stageY;
			}
		}
		
		/*private function onSoulSlotClickHdl(e:EventEx):void
		   {
		   var slotData:SoulItem =  e.data as SoulItem;
		   for each(var slot:SoulSlot in soulSlots) {
		   if (slot && slot.soulItem && slot.soulItem == slotData) {
		   _soulSelected = slot;
		   _soulSelected.setSelected(true)
		   }else {
		   slot.setSelected(false);
		   }
		   }
		 }*/
		private function processLock(posX:int = 0, posY:int = 0):void
		{
			if (_isSelectLock)
			{
				_lockMov.x = posX;
				_lockMov.y = posY;
				_lockMov.visible = true;
				Mouse.hide();
			}
			else
			{
				_lockMov.visible = false;
				Mouse.show();
			}
		}
		
		public function releaseMouse():void
		{
			_isSelectLock = false;
			_lockMov.visible = false;
			Mouse.show();
		}
		
		private function onBtnClickHdl(e:MouseEvent):void
		{
			switch (e.target)
			{
				case lockBtn: 
					_isSelectLock = !_isSelectLock;
					//if (_soulSelected) {
					//_soulSelected.status = _soulSelected.status != SoulSlot.LOCK_MERGE ? SoulSlot.LOCK_MERGE : SoulSlot.UNLOCK;
					//}
					processLock();
					break;
				//case sortBtn: 
					/*soulSlots.sortOn("name", Array.DESCENDING | Array.NUMERIC);
					   for each(var slot:SoulSlot in soulSlots) {
					   if (slot && slot.soulItem && slot.soulItem.soulXML)
					   Utility.log("soul array sort data with order: " + slot.soulItem.soulXML.getName());
					 }*/
					
					/*var data:Array = [];
					   for each(var slot:SoulSlot in soulSlots) {
					   data.push(slot.soulItem ? slot.soulItem.soulXML : null);
					   }
					   data.sortOn("name", Array.DESCENDING);
					   data.reverse();
					   for each(var soulXML:SoulXML in data) {
					   Utility.log("soul array sort data with order: " + soulXML.getName());
					 }*/
					
					//break;
			}
		}

		public function getSoulSlot():SoulSlot
		{
			if(_soulSlots.length > 0)
			{
				return _soulSlots[0] as SoulSlot;
			}

			return null;
		}

		public function update():void
		{
			_soulSlots = [];
			var souls:Array = Game.database.inventory.getSouls();
			var numOpenSlot:int = souls.length;
			
			while (_content.numChildren > 0)
			{
				_content.removeChildAt(0);
			}
			
			for (var i:int = 0; i < numOpenSlot; i++)
			{
				
				var slot:SoulSlot = new SoulSlot();
				slot.x = (i % 4) * 59;
				slot.y = Math.floor(i / 4) * 59 + 2;
				slot.setData(souls[i]);
				slot.status = (souls[i] as SoulItem).locked ? SoulSlot.LOCK_MERGE : SoulSlot.UNLOCK;
				_content.addChild(slot);
				_soulSlots.push(slot);
				//if(souls[i] as SoulItem && (souls[i] as SoulItem).soulXML)
				//Utility.log("soul array push data with order: " + (souls[i] as SoulItem).soulXML.getName());
			}
			
			var totalSlot:int = Math.max(28, numOpenSlot + (8 - (numOpenSlot % 4)));
			
			for (var j:int = numOpenSlot; j < totalSlot; j++)
			{
				slot = new SoulSlot();
				slot.x = (j % 4) * 59;
				slot.y = Math.floor(j / 4) * 59 + 2;
				slot.status = (j > numOpenSlot) ? SoulSlot.LOCK : SoulSlot.UNLOCK_GUILD;
			
				_content.addChild(slot);
			}
			
			if (!scroller) {
				scroller = new VerScroll(maskMov, _content, scrollbar);
				scroller.updateScroll();
			} else {
				scroller.updateScroll();
			}
		}
		
		public function checkHitDropOnInventory(drapObj:DisplayObject, data:SoulItem):Boolean
		{
			
			for (var i:int = 0; i < _soulSlots.length; i++)
			{
				var soulSlot:SoulSlot = SoulSlot(_soulSlots[i]);
				
				/*if ( node.getBounds(node).intersects(drapObj.getBounds(node)) ) {
				   Utility.log("Hit on index : " + i);
				   break;
				 }*/
				
				if (soulSlot.hitTestPoint(drapObj.x, drapObj.y))
				{
					if (soulSlot.isEmpty)
					{
						this.dispatchEvent(new EventSoulCenter(EventSoulCenter.SWAP_SOUL_INVENTORY, {indexFrom: data.index, indexTo: soulSlot.soulItem.index}, true));
					}
					else
					{
						if (soulSlot.soulItem != data)
						{
							if (soulSlot.soulItem.level < soulSlot.soulItem.soulXML.maxLevel)
							{
								//if (data.soulXML.rarity >= 1)
								if (data.soulXML.isRare)
								{
									//la menh khi hiem, can confirm khi nang cap								
									Manager.display.showDialog(DialogID.YES_NO, function():void
										{
											dispatchEvent(new EventSoulCenter(EventSoulCenter.UPGRADE_SOUL, {indexFrom: data.index, indexTo: soulSlot.soulItem.index}, true));
										}, null, {type: DialogEventType.CONFIRM_UPGRADE_SOUL, name: data.soulXML.name}, Layer.BLOCK_BLACK);
								}
								else
								{
									dispatchEvent(new EventSoulCenter(EventSoulCenter.UPGRADE_SOUL, {indexFrom: data.index, indexTo: soulSlot.soulItem.index}, true));
								}
							}
							else
							{
								Manager.display.showMessageID(32);
							}
						}
						else
						{
							Utility.log("checkHitDropOnInventory.Drop on It selft ");
						}
					}
					Utility.log("checkHitDropOnInventory.Hit on index : " + i);
					return true;
				}
			}
			return false;
		}
		
		public function checkHitDropFromNodeChain(drapObj:DisplayObject, data:SoulItem, selectedCharacterIndex:int):Boolean
		{
			
			for (var i:int = 0; i < _soulSlots.length; i++)
			{
				var soulSlot:SoulSlot = SoulSlot(_soulSlots[i]);
				
				if (soulSlot.hitTestPoint(drapObj.x, drapObj.y))
				{
					
					this.dispatchEvent(new EventSoulCenter(EventSoulCenter.EQUIP_ATTACH_SOUL,
								{unitIndex: selectedCharacterIndex, soulIndex: soulSlot.soulItem.index, slotIndex: data.index}, true));
					
					Utility.log("checkHitDropFromNodeChain.Hit on index : " + i);
					
					return true;
					
				}
			}
			
			return false;
		}
		
		public function checkHitDropFromMergeSoul(drapObj:DisplayObject, data:SoulItem):Boolean
		{
			
			for (var i:int = 0; i < _soulSlots.length; i++)
			{
				var soulSlot:SoulSlot = SoulSlot(_soulSlots[i]);
				
				if (soulSlot.hitTestPoint(drapObj.x, drapObj.y))
				{
					
					this.dispatchEvent(new EventSoulCenter(EventSoulCenter.EQUIP_MERGE_SOUL, {soulIndex: soulSlot.soulItem.index, slotIndex: data.index}, true));
					
					Utility.log("checkHitDropFromMergeSoul.Hit on index : " + i);
					
					return true;
					
				}
			}
			
			return false;
		}
		
		public function setSlotMerge(data:SoulItem):void {
			var souls:Array = Game.database.inventory.getSouls();
			var index:int = souls.indexOf(data);
			if (index > -1 && index < souls.length) {
				var slot:SoulSlot = _soulSlots[index] as SoulSlot;
				slot.setSlotMerge();
				//if (data.usedInMerge)
					//MovieClipUtils.applyGrayScale(_soulSlots[index]);
				//else 
					//MovieClipUtils.removeAllFilters(_soulSlots[index]);
			}
		}
	}

}