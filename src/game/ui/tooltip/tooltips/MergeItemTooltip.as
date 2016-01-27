package game.ui.tooltip.tooltips 
{
	import core.Manager;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import game.data.model.item.IItemConfig;
	import game.data.model.item.ItemFactory;
	import game.data.xml.item.ItemChestXML;
	import game.data.xml.item.ItemXML;
	import game.data.xml.item.MergeItemXML;
	import game.data.xml.RewardXML;
	import game.enum.Font;
	import game.ui.components.ItemSlot;
	import game.ui.tooltip.TooltipBase;
	import game.utility.GameUtil;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class MergeItemTooltip extends TooltipBase
	{
		public var background : MovieClip;
		public var groupTf : TextField;
		public var rankTf : TextField;
		private var _groupContainer : Sprite = new Sprite();
		private var _rankContainer : Sprite = new Sprite();
		private var _data : IItemConfig;
		
		private static const MAX_ITEM_PER_ROW:int = 3;
		private static const DISTANCE_X_PER_ITEM:int = 20;
		private static const DISTANCE_Y_PER_ITEM:int = -5;
		
		public function MergeItemTooltip() 
		{
			background.scale9Grid = new Rectangle(50, 60, 50, 60);
			
			FontUtil.setFont(groupTf, Font.ARIAL, true);
			FontUtil.setFont(rankTf, Font.ARIAL, true);
			
			//_groupContainer.x = groupTf.x + 5;
			//_groupContainer.y = groupTf.y + groupTf.height;
			//addChild(_groupContainer);
			
			//_rankContainer.x = rankTf.x + 5;
			//_rankContainer.y = rankTf.y + rankTf.height;
			//addChild(_rankContainer);
			
			groupTf.text = "Phần thưởng nhóm trong tuần";
			rankTf.text = "Phần thưởng hạng trong tuần";
		}
		
		public function  setContent(info:IItemConfig) : void {
			_data = info;
			//var itemConfig : IItemConfig = ItemFactory.buildItemConfig(groupXML.type, groupXML.ID);			
			//groupTf.text = itemConfig.getName();
			
			while (_groupContainer.numChildren > 0) 
			{
				var child:ItemSlot = _groupContainer.getChildAt(0) as ItemSlot;
				child.reset();
				Manager.pool.push(child, ItemSlot);
				_groupContainer.removeChildAt(0);
			}
			//var itemSlot : ItemSlot = new ItemSlot();
			while (_rankContainer.numChildren > 0) 
			{
				child= _rankContainer.getChildAt(0) as ItemSlot;
				child.reset();
				Manager.pool.push(child, ItemSlot);
				_rankContainer.removeChildAt(0);
			}
			
			for (var i:int = 0; i < (info as MergeItemXML).getMergeItem().length; i++) {								
				var rewardXML:RewardXML = (info as MergeItemXML).getMergeItem()[i] as RewardXML;
				var rewards:Array = GameUtil.getItemRewardsByID(rewardXML.ID);
				for (var j:int = 0; j < rewards.length; j++) {
					var itemSlot:ItemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;			
					itemSlot.setConfigInfo((rewards[j] as RewardXML).getItemInfo());
					itemSlot.x = (DISTANCE_X_PER_ITEM + 60) * (j % MAX_ITEM_PER_ROW);
					itemSlot.y = (DISTANCE_Y_PER_ITEM + 60) * (int) (j / MAX_ITEM_PER_ROW);
					itemSlot.setQuantity((rewards[j] as RewardXML).quantity);
					if (i % 2 == 0) {					
						_groupContainer.addChild(itemSlot);	
					}else {					
						_rankContainer.addChild(itemSlot);
					}
				}
			}
			
			/*var rewards:Array = GameUtil.getItemRewardsByID(groupXML.ID);
			for (var i:int = 0; i < rewards.length; i++) {
				var itemSlot:ItemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;			
				itemSlot.setConfigInfo(rewards[i]);
				itemSlot.x = (DISTANCE_X_PER_ITEM + 60) * (i % MAX_ITEM_PER_ROW);
				itemSlot.y = (DISTANCE_Y_PER_ITEM + 60) * (int) (i / MAX_ITEM_PER_ROW);
				itemSlot.setQuantity(groupXML.quantity);
				_groupContainer.addChild(itemSlot);	
			}
			
			itemConfig = ItemFactory.buildItemConfig(rankXML.type, rankXML.itemID);			
			rankTf.text = itemConfig.getName();
			
			//var itemSlot : ItemSlot = new ItemSlot();
			rewards = GameUtil.getItemRewardsByID(rankXML.ID);
			for (i = 0; i < rewards.length; i++) {
				itemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;			
				itemSlot.setConfigInfo(rewards[i]);
				itemSlot.x = (DISTANCE_X_PER_ITEM + 60) * (i % MAX_ITEM_PER_ROW);
				itemSlot.y = (DISTANCE_Y_PER_ITEM + 60) * (int) (i / MAX_ITEM_PER_ROW);
				itemSlot.setQuantity(groupXML.quantity);
				_rankContainer.addChild(itemSlot);	
			}*/
			
			alignPosition();
		}
		
		private function alignPosition():void {
			_rankContainer.x = rankTf.x + 5;
			_rankContainer.y = rankTf.y + rankTf.height;
			addChild(_rankContainer);
			
			groupTf.x = rankTf.x;
			groupTf.y = _rankContainer.y + _rankContainer.height + 5;
			
			_groupContainer.x = groupTf.x + 5;
			_groupContainer.y = groupTf.y + groupTf.height;
			addChild(_groupContainer);
			
			background.width = Math.max(_rankContainer.width, _groupContainer.width, rankTf.width) + 15;
			background.height = _groupContainer.y + _groupContainer.height + 15;			
		}
		
	}

}