package game.ui.dialog.dialogs
{
	import com.greensock.easing.Expo;
	import com.greensock.TweenMax;
	import core.display.animation.Animator;
	import core.Manager;
	import core.util.FontUtil;
	import core.util.Utility;
	import flash.text.TextField;
	import game.data.model.item.ItemFactory;
	import game.data.xml.DataType;
	import game.data.xml.RewardXML;
	import game.enum.Font;
	import game.enum.ItemType;
	import game.Game;
	import game.ui.components.ItemSlot;
	import game.ui.tooltip.TooltipID;
	import game.utility.UtilityEffect;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class GiftCodeDialog extends Dialog
	{
		public var txtMessage:TextField;
		
		private var _arrItemSlot:Array;
	
		
		public function GiftCodeDialog()
		{
			FontUtil.setFont(txtMessage, Font.ARIAL);
		}
		
		override public function onShow():void
		{
			reset();
			if (data)
			{
				txtMessage.text = data.content;
				//init reward nhan duoc
				if (data.errorcode == 0 && data.arrRewardID)
				{
					for (var i:int = 0; i < data.arrRewardID.length; i++)
					{
						var rewardXml:RewardXML = Game.database.gamedata.getData(DataType.REWARD, data.arrRewardID[i]) as RewardXML;
						if (rewardXml != null)
						{
							//var itemSlot:ItemSlot = new ItemSlot();
							var itemSlot:ItemSlot = Manager.pool.pop(ItemSlot) as ItemSlot
							itemSlot.setConfigInfo(ItemFactory.buildItemConfig(rewardXml.type, rewardXml.itemID));
							itemSlot.setQuantity(rewardXml.quantity);
							itemSlot.x = 100 + i * 70;
							itemSlot.y = 160;
							_arrItemSlot.push(itemSlot);
							this.addChild(itemSlot);
						}
					}
				}
			}
		}
		
		override protected function close():void
		{
			//super.close();
			if (data == null || data.arrRewardID == null)
				return;
			if (data.arrRewardID.length == 0)
				super.close();
			else
				showAnim();
		}
		
		private function showAnim():void
		{
			//hide okBtn -> cheat
			okBtn.visible = false;
			
			if (data == null || data.arrRewardID == null)
				return;
			if (data.noAnim != null)
			{
				super.close();
				return;
			}
			var itemSlots:Array = new Array();
			
			for (var i:int = 0; i < data.arrRewardID.length; i++)
			{
				var rewardXml:RewardXML = Game.database.gamedata.getData(DataType.REWARD, data.arrRewardID[i]) as RewardXML;
				if (rewardXml != null)
				{
						
					var _itemSlot:ItemSlot = new ItemSlot();
					_itemSlot.setConfigInfo(rewardXml.getItemInfo(), TooltipID.ITEM_COMMON);
					_itemSlot.setQuantity(rewardXml.quantity);
					_itemSlot.x = 100 + i * 70;
					_itemSlot.y = 160;
					itemSlots.push(_itemSlot);
				} else
				{
					Utility.error("ERROR: don't see itemID: " + data.arrRewardID[i]);
				}
			}
			UtilityEffect.tweenItemEffects(itemSlots, onCompleteTween, true);
		}
		
		private function onCompleteTween():void
		{
			super.close();
		}
		
		private function reset():void
		{
			okBtn.visible = true;
			for each (var obj:ItemSlot in _arrItemSlot) {
				obj.reset();
				Manager.pool.push(obj, ItemSlot);
				this.removeChild(obj);
			}
			_arrItemSlot = [];
		
		}
	}

}