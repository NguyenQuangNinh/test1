package game.ui.soul_center.gui
{
	import core.Manager;
	import core.util.FontUtil;
	import core.util.Utility;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import game.data.model.Character;
	import game.data.model.item.SoulItem;
	import game.enum.Font;
	import game.enum.GameConfigID;
	import game.Game;
	import game.ui.components.ToggleMov;
	import game.ui.message.MessageID;
	import game.ui.soul_center.event.EventSoulCenter;
	import game.ui.soul_center.gui.toggle.LineToggle1;
	import game.ui.soul_center.gui.toggle.LineToggle2;
	import game.ui.soul_center.gui.toggle.LineToggle3;
	import game.ui.soul_center.gui.toggle.LineToggle4;
	import game.ui.soul_center.gui.toggle.LineToggle5;
	import game.ui.soul_center.gui.toggle.LineToggle6;
	import game.ui.soul_center.gui.toggle.LineToggle7;
	
	/**
	 * ...
	 * @author anhtinh
	 */
	public class SoulCharacterChain extends MovieClip
	{
		public var node1:NodeCell;
		public var node2:NodeCell;
		public var node3:NodeCell;
		public var node4:NodeCell;
		public var node5:NodeCell;
		public var node6:NodeCell;
		public var node7:NodeCell;
		public var node8:NodeCell;
		
		public var nodeTf1:TextField;
		public var nodeTf2:TextField;
		public var nodeTf3:TextField;
		public var nodeTf4:TextField;
		public var nodeTf5:TextField;
		public var nodeTf6:TextField;
		public var nodeTf7:TextField;
		public var nodeTf8:TextField;
		
		public var line1:LineToggle1;
		public var line2:LineToggle2;
		public var line3:LineToggle3;
		public var line4:LineToggle4;
		public var line5:LineToggle5;
		public var line6:LineToggle6;
		public var line7:LineToggle7;
		
		private var names:Array = ["Dương Kiều Mạch", "Đốc Mạch", "Âm Duy Mạch", "Xung Mạch", "Dương Duy Mạch", "Đới Mạch", "Âm Kiều Mạch", "Nhâm Mạch"];
		private var nodeTfs:Array;
		private var nodes:Array;
		private var lines:Array;
		
		public var currentCharacter:Character;
		
		public function SoulCharacterChain()
		{
			FontUtil.setFont(nodeTf1, Font.ARIAL, true);
			FontUtil.setFont(nodeTf2, Font.ARIAL, true);
			FontUtil.setFont(nodeTf3, Font.ARIAL, true);
			FontUtil.setFont(nodeTf4, Font.ARIAL, true);
			FontUtil.setFont(nodeTf5, Font.ARIAL, true);
			FontUtil.setFont(nodeTf6, Font.ARIAL, true);
			FontUtil.setFont(nodeTf7, Font.ARIAL, true);
			FontUtil.setFont(nodeTf8, Font.ARIAL, true);
			
			nodes = [node1, node2, node3, node4, node5, node6, node7, node8];
			nodeTfs = [nodeTf1, nodeTf2, nodeTf3, nodeTf4, nodeTf5, nodeTf6, nodeTf7, nodeTf8];
			
			lines = [line1, line2, line3, line4, line5, line6, line7];	
			
			var i:int = 0;
			for each(var node:NodeCell in nodes) {
				node.nodeIndex = i
				i++;
			}
		}
		
		public function checkInsertSoul(soul:SoulItem):void {
			if (currentCharacter) {									
				for (var i:int = 0; i < nodes.length; i++)
				{
					var node:NodeCell = NodeCell(nodes[i]);
					if (node.isActive && !node.isAttachSoul)
					{
						this.dispatchEvent(new EventSoulCenter(EventSoulCenter.EQUIP_ATTACH_SOUL, 
									{unitIndex: this.currentCharacter.ID, soulIndex: soul.index, slotIndex: i}, true));
						Utility.log("insert on index : " + i);
						break;
					}
				}				
			}else {
				Utility.log("can not insert soul on null selected character");
			}
		}
		
		public function checkHitDropToEquip(drapObj:DisplayObject, data:SoulItem):Boolean
		{
			for (var i:int = 0; i < nodes.length; i++)
			{
				var node:ToggleMov = ToggleMov(nodes[i]);
				if (node.isActive && node.getBounds(node).intersects(drapObj.getBounds(node)))
				{
					this.dispatchEvent(new EventSoulCenter(EventSoulCenter.EQUIP_ATTACH_SOUL, 
								{unitIndex: this.currentCharacter.ID, soulIndex: data.index, slotIndex: i}, true));
					Utility.log("hit on index : " + i);
					return true;
				}
			}
			
			return false;
		}
		
		public function checkHitDropToSwap(dragObj:DisplayObject, data:SoulItem):Boolean
		{
			
			for (var i:int = 0; i < nodes.length; i++) {
				var node:NodeCell = NodeCell(nodes[i]);
				var nodeBound:Rectangle = node.getBounds(node);
				var dragBound:Rectangle = dragObj.getBounds(node);
				if (node.isActive && node.getBounds(node).intersects(dragObj.getBounds(node))) {					
					Utility.log("swap on index : " + i);					
					if (node.soulItem != data) {
						this.dispatchEvent(new EventSoulCenter(EventSoulCenter.SWAP_SOUL_EQUIP_ATTACH, 
									{unitIndex: this.currentCharacter.ID, indexFrom: data.index, indexTo: node.soulItem.index}, true));						
						return true;
					}else {
						Utility.log("drop on it self ");
						return false;
					}					
				}				
			}			
			//remove from node
			//var emptySlot:SoulItem = Game.database.inventory.getFirstSlotSoulEmpty();
			/*if (emptySlot != null) {
				this.dispatchEvent(new EventSoulCenter(EventSoulCenter.EQUIP_ATTACH_SOUL, 
							{unitIndex: this.currentCharacter.ID, soulIndex: emptySlot.index, slotIndex: data.index}, true));
			}*/
			removeAttachAtIndex(data.index);
			
			return false;
		}
		
		public function removeAttachAtIndex(index:int):void {
			//remove from node
			var emptySlot:SoulItem = Game.database.inventory.getFirstSlotSoulEmpty();
			if (emptySlot != null) {
				this.dispatchEvent(new EventSoulCenter(EventSoulCenter.EQUIP_ATTACH_SOUL, 
							{unitIndex: this.currentCharacter.ID, soulIndex: emptySlot.index, slotIndex: index}, true));
			}
		}
		
		public function update(character:Character):void
		{
			this.currentCharacter = character;
			var souls:Array = character.soulItems;
			
			var numOpenSlot:int = Math.min(souls.length, 8);
			activeTo(numOpenSlot);
			
			for (var i:int = 0; i < 8; i++) {
				if (i < numOpenSlot) {
					var soulItem:SoulItem = souls[i] as SoulItem;
					NodeCell(nodes[i]).setData(soulItem);
				}else {
					NodeCell(nodes[i]).isAttachSoul = false;
				}				
			}
		}
		
		private function activeTo(index:int):void
		{
			
			var textFm:TextFormat;
			var arrStarOpenSlotSoulUnit:Array = Game.database.gamedata.getConfigData(GameConfigID.STAR_OPEN_SLOT_SOUL_UNIT) as Array;
			
			for (var i:int = 0; i < arrStarOpenSlotSoulUnit.length; i++) {
				if (i < index) {
					ToggleMov(nodes[i]).isActive = true;
					TextField(nodeTfs[i]).text = names[i];
					textFm = TextField(nodeTfs[i]).defaultTextFormat;
					textFm.color = 0x00FF00;
					TextField(nodeTfs[i]).setTextFormat(textFm);
				}else {
					ToggleMov(nodes[i]).isActive = false;
					TextField(nodeTfs[i]).text = arrStarOpenSlotSoulUnit[i] + " sao mở";
					textFm = TextField(nodeTfs[i]).defaultTextFormat;
					textFm.color = 0xFF0000;
					TextField(nodeTfs[i]).setTextFormat(textFm);
				}				
			}
			
			for (i = 0; i < arrStarOpenSlotSoulUnit.length - 1; i++) {
				if (i < lines.length && lines[i])
					ToggleMov(lines[i]).isActive = i < index - 1;
			}
		
		}
	}

}