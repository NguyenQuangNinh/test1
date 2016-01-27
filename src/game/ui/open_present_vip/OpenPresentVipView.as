package game.ui.open_present_vip
{
	import com.greensock.TweenMax;
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.util.FontUtil;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import game.data.model.item.Item;
	import game.data.model.item.ItemFactory;
	import game.data.xml.DataType;
	import game.data.xml.item.ItemChestXML;
	import game.data.xml.RewardXML;
	import game.data.xml.VIPConfigXML;
	import game.enum.Font;
	import game.enum.GameConfigID;
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.request.RequestUseItems;
	import game.net.lobby.response.ResponseGetGiftOnlineInfo;
	import game.ui.gift_online.gui.GiftItem;
	import game.ui.open_present_vip.gui.CellGiftVipContainer;
	import game.utility.GameUtil;
	import game.utility.UtilityUI;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class OpenPresentVipView extends ViewBase
	{
		
		private static const TYPE_RECEVIVE_GIFT_ONLINE_NORMAL:int = 0;
		private static const TYPE_RECEVIVE_GIFT_ONLINE_FAST:int = 1;
		
		public var closeBtn:SimpleButton;
		public var btnOpen:SimpleButton;
		
		private var cellContainer:CellGiftVipContainer;
		
		public function OpenPresentVipView()
		{
			closeBtn = UtilityUI.getComponent(UtilityUI.CLOSE_BTN) as SimpleButton;
			
			if (closeBtn != null)
			{
				closeBtn.x = Game.WIDTH - 2 * closeBtn.width - 750;
				closeBtn.y = 2 * closeBtn.height - 15;
				addChild(closeBtn);
				closeBtn.addEventListener(MouseEvent.CLICK, closeHandler);
			}
			
			btnOpen.addEventListener(MouseEvent.CLICK, onOpenPresentVip);
			
			cellContainer = new CellGiftVipContainer(this);
			cellContainer.x = 45;
			cellContainer.y = 140;
			this.addChild(cellContainer);
		
		}
		
		private function onOpenPresentVip(e:Event):void
		{
			var item:Item = data as Item;
			if (item)
			{
				btnOpen.mouseEnabled = false;
				closeBtn.mouseEnabled = false;
				Game.network.lobby.sendPacket(new RequestUseItems(item.itemXML.type.ID,item.xmlData.ID, 1));
			}
		}
		
		private function closeHandler(e:Event):void
		{
			this.dispatchEvent(new EventEx(OpenPresentVipModule.CLOSE_OPEN_PRESENT_VIP_VIEW));
		}
		
		public function update(extraInfo:Object):void
		{
			var item:Item = extraInfo as Item;
			if (item)
			{
				var xmlData:ItemChestXML = item.itemXML as ItemChestXML;
				if (xmlData)
				{
					btnOpen.mouseEnabled = true;
					closeBtn.mouseEnabled = true;
					TweenMax.to(btnOpen, 0, { alpha: 1, colorMatrixFilter: { saturation: 1 }} );
					
					cellContainer.init(xmlData.rewardIDs);
				}
			}
		}
		
		public function resetButton():void
		{
			btnOpen.mouseEnabled = false;
			closeBtn.mouseEnabled = true;
		}
		
		public function startAnimOpen(indexRewardID:int):void
		{
			TweenMax.to(btnOpen, 0, {alpha: 1, colorMatrixFilter: {saturation: 0}});
			cellContainer.startAnim();
			cellContainer.rewardIndex = indexRewardID;	
		}
	
	}
}