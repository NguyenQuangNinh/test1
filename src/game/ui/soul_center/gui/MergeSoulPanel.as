package game.ui.soul_center.gui 
{
	import core.event.EventEx;
	import core.Manager;
	import core.util.FontUtil;
	import core.util.Utility;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import game.data.model.item.ItemFactory;
	import game.data.model.item.SoulItem;
	import game.data.xml.BonusAttributeXML;
	import game.data.xml.DataType;
	import game.data.xml.item.SoulXML;
	import game.enum.Font;
	import game.enum.ItemType;
	import game.Game;
	import game.ui.components.ToggleMov;
	import game.ui.message.MessageID;
	import game.ui.soul_center.event.EventSoulCenter;
	import game.ui.tutorial.TutorialEvent;
	import game.utility.GameUtil;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class MergeSoulPanel extends MovieClip
	{
		
		public var mergeBtn:SimpleButton;
		public var autoMergeBtn:SimpleButton;
		public var txtGuideMov:MovieClip;
		
		public var itemMerge:SoulNode;
		
		public var currentLevelTf:TextField;
		public var nextLevelTf:TextField;
		public var currentBonusTf:TextField;
		public var nextBonusTf:TextField;
		public var bonusTf:TextField;
		
		public var soulMerge1:SoulNode;
		public var soulMerge2:SoulNode;
		public var soulMerge3:SoulNode;
		public var soulMerge4:SoulNode;
		public var soulMerge5:SoulNode;
		public var soulMerge6:SoulNode;
		public var soulMerge7:SoulNode;
		public var soulMerge8:SoulNode;
		public var soulMerge9:SoulNode;
		public var soulMerge10:SoulNode;
		public var soulMerge11:SoulNode;
		public var soulMerge12:SoulNode;
		public var soulMerge13:SoulNode;
		public var soulMerge14:SoulNode;
		public var soulMerge15:SoulNode;
		public var soulMerge16:SoulNode;
		public var soulMerge17:SoulNode;
		public var soulMerge18:SoulNode;
		public var soulMerge19:SoulNode;
		public var soulMerge20:SoulNode;
		
		private static const MAX_SOUL_MERGE_NODE:int = 20;
		
		private var _soulNodes:Array;
		
		private var _currentIndexReady:int;
		
		public function MergeSoulPanel() 
		{			
			mergeBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			autoMergeBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			
			_soulNodes = [itemMerge, soulMerge1, soulMerge2, soulMerge3, soulMerge4, soulMerge5,
							soulMerge6, soulMerge7, soulMerge8, soulMerge9, soulMerge10,
							soulMerge11, soulMerge12, soulMerge13, soulMerge14, soulMerge15,
							soulMerge16, soulMerge17, soulMerge18, soulMerge19, soulMerge20];
				
			var index:int = 0;
			for each(var node:SoulNode in _soulNodes) {
				node.isRecipe = true;
				node.nodeIndex = index;
				index++;
			}
			
			itemMerge.isRecipe = false;
			resetUI();
			
			FontUtil.setFont(currentLevelTf, Font.ARIAL);
			FontUtil.setFont(nextLevelTf, Font.ARIAL);
			FontUtil.setFont(currentBonusTf, Font.ARIAL);
			FontUtil.setFont(nextBonusTf, Font.ARIAL);
			FontUtil.setFont(bonusTf, Font.ARIAL);

		}
		
		private function getRecipeIndex():Array {
			var result:Array = [];
			for (var i:int = 1; i < _soulNodes.length; i++) {
				var slot:SoulNode = _soulNodes[i] as SoulNode;
				result.push(slot && slot.isMergeSoul ? slot.soulItem.index : -1);
			}
			
			return result;
		}
		
		private function onBtnClickHdl(e:MouseEvent):void
		{
			switch(e.target) {
				case mergeBtn:
					if (itemMerge.isMergeSoul)
					{
						dispatchEvent(new EventSoulCenter(EventSoulCenter.ACTION_MERGE_SOUL,
								{ item: itemMerge.soulItem.index, recipeArr: getRecipeIndex() }, true));

						dispatchEvent(new EventEx(TutorialEvent.EVENT, {type: TutorialEvent.MERGE_SOUL_CENTER}, true));
					}
					else
						Manager.display.showMessageID(MessageID.FAIL_MERGE_BY_NO_ITEM_RECIPE);
					break;
				case autoMergeBtn:
					if(itemMerge.isMergeSoul)
					{
						dispatchEvent(new EventSoulCenter(EventSoulCenter.AUTO_INSERT_SOUL_RECIPE, null, true));
						dispatchEvent(new EventEx(TutorialEvent.EVENT, {type: TutorialEvent.AUTO_MERGE_SOUL_CENTER}, true));
					}
					else
					Manager.display.showMessageID(MessageID.FAIL_MERGE_BY_NO_ITEM_RECIPE);
					break;
			}
		}

		public function hasRecipe():Boolean
		{
			for (var i:int = 1; i < _soulNodes.length; i++)
			{
				var node:SoulNode = _soulNodes[i] as SoulNode;
				if(node.soulItem) return true;
			}

			return false;
		}

		public function resetUI():void 
		{		
			txtGuideMov.visible = true;
			itemMerge.dispatchEvent(new EventEx(SoulNode.SOUL_NODE_DCLICK, { index: itemMerge.nodeIndex, info: itemMerge.soulItem }, true));	
			itemMerge.isActive = false;	
			itemMerge.setData(null);
			currentLevelTf.text = "";
			nextLevelTf.text = "";
			bonusTf.text = "";
			currentBonusTf.text = "";
			nextBonusTf.text = "";
			for (var i:int = 1; i < _soulNodes.length; i++) {
				var node:SoulNode = _soulNodes[i];
				node.dispatchEvent(new EventEx(SoulNode.SOUL_NODE_DCLICK, { index: node.nodeIndex, info: node.soulItem }, true));	
				node.isActive = true;
				node.setData(null);
			}
			_currentIndexReady = 0;
			updateSoulReady();
		}		
		
		private function updateSoulReady():void 
		{
			txtGuideMov.visible = !itemMerge.isActive;
			
			var expAdd:int = 0;
			
			var first_ready:Boolean = false;
			for (var i:int = 1; i < _soulNodes.length; i++) {
				var node:SoulNode = _soulNodes[i] as SoulNode;
				node.isActive = true;
				node.isActive = !node.isMergeSoul && i <= _currentIndexReady && !first_ready ? false : true;
				first_ready ||= !node.isActive;
				expAdd += node.soulItem ? node.soulItem.getSoulExp() : 0;
			}
			//Utility.log("total exp add is " + expAdd);
			if (itemMerge.isActive) {
				var soulItem:SoulItem = (_soulNodes[0] as SoulNode).soulItem;
				var nextLevel:int = GameUtil.checkSoulNextLevel(soulItem, expAdd);
				if (nextLevel != -1) {
					var soulXml:SoulXML = soulItem.soulXML;
					if (soulXml != null)
					{
						var bonusAttributes:Array = soulXml.bonusAttributes;
						var currentLevel:int = (_soulNodes[0] as SoulNode).soulItem.level;
						currentLevelTf.text = currentLevel.toString();
						nextLevelTf.text = nextLevel.toString();
						
						//insert text value for attribute // current bonus and next bonus
						for (i = 0; i < bonusAttributes.length; i++)
						{							
							//quoctpb
							bonusTf.text = "" + GameUtil.getSoulBonusAttName(bonusAttributes[i]);
							currentBonusTf.text = "" + GameUtil.getSoulBonusValue(bonusAttributes[i], currentLevel);
							nextBonusTf.text = "" + GameUtil.getSoulBonusValue(bonusAttributes[i], nextLevel);
						}
					}
				}				
			}
		}
		
		public function checkInsertSoul(soul:SoulItem):Boolean {
			var result:Boolean = false;
			//if (itemMerge.isActive) {				
			for (var i:int = 0; i < _soulNodes.length; i++) {
				var node:SoulNode = SoulNode(_soulNodes[i]);
				if (!node.isActive) {
					if(!node.isRecipe || (!soul.usedInMerge && !soul.locked)) {
						this.dispatchEvent(new EventSoulCenter(EventSoulCenter.EQUIP_MERGE_SOUL, 
									{soulIndex: soul.index, slotIndex: i}, true));
						Utility.log("merge --> insert on index : " + i);
						_currentIndexReady++;
						updateSoulAtIndex(i, soul);
						result = true;						
					}else {
						Utility.log("can not use soul had been used in merge or locked");
					}
					break;
				}
			}
			
			updateSoulReady();
			
			return result;
		}
		
		public function updateSoulAtIndex(index:int, data:SoulItem):void {
			if (index >= 0 && index < _soulNodes.length) {
				var node:SoulNode = _soulNodes[index] as SoulNode;
				if (node /*&& !node.isActive*/) {
					Utility.log("update --> soul node at index : " + index);
					if (data)
						data.usedInMerge = true;
					node.setData(data);					
					updateSoulReady();
				}else {
					Utility.log("can not update soul on NUll node");
				}
			}else {
				Utility.log("can not update soul with index out of bound");
			}
		}
		
		/*public function checkHitDropToEquip(dragObj:DisplayObject, data:SoulItem):Boolean
		{
			for (var i:int = 0; i < _soulNodes.length; i++)
			{
				var node:SoulNode = SoulNode(_soulNodes[i]);
				var nodeBound:Rectangle = node.getBounds(Game.stage);
				var dragBound:Rectangle = dragObj.getBounds(Game.stage);
				if (!node.isActive && nodeBound.intersects(dragBound))
				{
					if (data && !data.usedInMerge && !data.locked) {						
						this.dispatchEvent(new EventSoulCenter(EventSoulCenter.EQUIP_MERGE_SOUL, 
									{soulIndex: data.index, slotIndex: i}, true));
						Utility.log("merge --> hit on index : " + i);
						_currentIndexReady++;
						updateSoulAtIndex(i, data);
						updateSoulReady();
						return true;
					}else {
						Utility.log("can not drop soul has been used in merge");
					}
					
				}
			}			
			return false;
		}*/
		
		/*public function checkHitDropToSwap(dragObj:DisplayObject, data:SoulItem, nodeIndex:int):Boolean
		{			
			for (var i:int = 0; i < _soulNodes.length; i++) {
				var node:SoulNode = SoulNode(_soulNodes[i]);
				var nodeBound:Rectangle = node.getBounds(Game.stage);
				var dragBound:Rectangle = dragObj.getBounds(Game.stage);					
				if (nodeBound.intersects(dragBound)) {					
					Utility.log("merge --> swap from index: " + data.index + " to " + i);					
					if (node.soulItem != data) {
						updateSoulAtIndex(nodeIndex, node.soulItem);
						updateSoulAtIndex(node.nodeIndex, data);
						this.dispatchEvent(new EventSoulCenter(EventSoulCenter.SWAP_SOUL_EQUIP_MERGE, 
									{indexFrom: nodeIndex, indexTo: node.nodeIndex}, true));	
						return true;
					}else {
						Utility.log("merge --> drop out on itself");				
						return false;
					}			
				}
			}
			Utility.log("merge --> drop out on nothing ");
			node.dispatchEvent(new EventEx(SoulNode.SOUL_NODE_DCLICK, { index: nodeIndex, info: data }, true));	
			
			return false;
		}*/
		
		public function numSlotRecipeAvailable():int {
			var result:int = 0;
			
			for each(var node:SoulNode in _soulNodes) {
				result += node.isActive ? 1 : 0;
			}
			
			return result;
		}
		
		public function getSoulItemMerge():SoulItem {
			return itemMerge.soulItem;
		}
	}

}