package game.ui.soul_center.gui
{
	import core.display.animation.Animator;
	import core.event.EventEx;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.data.model.item.IItemConfig;
	import game.data.model.item.ItemFactory;
	import game.data.model.item.SoulItem;
	import game.data.xml.DataType;
	import game.data.xml.item.SoulXML;
	import game.data.xml.ShopXML;
	import game.enum.Font;
	import game.enum.PaymentType;
	import game.Game;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.request.RequestBuyItem;
	import game.ui.soul_center.PriceObject;
	import game.ui.soul_center.SoulShopItem;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class ExchangeSlot extends MovieClip
	{
		public var nameTf:TextField;
		public var buyInfo:ExchangeSlotBuyInfo;
		public var exchangeInfo:ExchangeSlotExchangeInfo;
		private var soulAnim:Animator = new Animator();
		public var soulItem:SoulItem;
		
		private var shopItemIDBuy:int = 0;
		private var shopItemIDExchange:int = 0;
		private var quantityBuy:int = 0;
		private var quantityExchange:int = 0;
		
		public function ExchangeSlot()
		{
			FontUtil.setFont(nameTf, Font.ARIAL, true);
			soulAnim.setCacheEnabled(false);
			soulAnim.x = 46;
			soulAnim.y = 47;
			if (!soulAnim.hasEventListener(Animator.LOADED))
				soulAnim.addEventListener(Animator.LOADED, onAnimLoaded);
			
			this.addChild(soulAnim);
			
			soulAnim.addEventListener(MouseEvent.ROLL_OVER, onRollOverHdl);
			soulAnim.addEventListener(MouseEvent.ROLL_OUT, onRollOutHdl);
			
			this.addEventListener(ExchangeSlotBuyInfo.CLICK_BUY_ITEM, onBuyItem);
			this.addEventListener(ExchangeSlotExchangeInfo.CLICK_EXCHANGE_ITEM, onExchangeItem);
			
			buyInfo.visible = false;
			exchangeInfo.visible = false;
		}
		
		private function onExchangeItem(e:Event):void
		{
			if (shopItemIDExchange > 0 && quantityExchange >= 0)
			{
				Game.network.lobby.sendPacket(new RequestBuyItem(LobbyRequestType.SHOP_BUY_SINGLE_ITEM, shopItemIDExchange, quantityExchange));
			}
		}
		
		private function onBuyItem(e:Event):void
		{
			if (shopItemIDBuy > 0 && quantityBuy >= 0)
			{
				Game.network.lobby.sendPacket(new RequestBuyItem(LobbyRequestType.SHOP_BUY_SINGLE_ITEM, shopItemIDBuy, quantityBuy));
			}
		}
		
		private function onRollOutHdl(e:MouseEvent):void
		{
			dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
		}
		
		private function onRollOverHdl(e:MouseEvent):void
		{
			dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type: TooltipID.SOUL, value: this.soulItem}, true));
		}
		
		private function onAnimLoaded(e:Event):void
		{
			//var index : int = Math.min(soulAnim.getAnimationCount() - 1, soulItem.level - 1)
			soulAnim.play();
		}
		
		public function init(soulShopItem:SoulShopItem):void
		{
			soulItem = ItemFactory.createItem(soulShopItem.type, soulShopItem.itemID, SoulItem) as SoulItem;
			if (soulItem)
			{
				soulItem.level = 1;
				nameTf.text = soulItem.soulXML.getName();
				
				for (var i:int; i < soulShopItem.arrPrice.length; i++)
				{
					var price:PriceObject = soulShopItem.arrPrice[i];
					if (price.paymentType == PaymentType.XU_NORMAL)
					{
						quantityBuy = price.maxBuyNum;
						shopItemIDBuy = price.ID;
						
						buyInfo.visible = true;
						buyInfo.priceTf.text = "" + price.price + " vàng";
					}
					else if (price.paymentType == PaymentType.SOUL_SCORE)
					{
						quantityExchange = price.maxBuyNum;
						shopItemIDExchange = price.ID;
						
						exchangeInfo.visible = true;
						exchangeInfo.priceTf.text = "" + price.price +" điểm tích lũy";
					}
				}
				
				var xmlData:SoulXML = Game.database.gamedata.getData(DataType.ITEMSOUL, soulShopItem.itemID) as SoulXML;
				if (xmlData)
					soulAnim.load(xmlData.animURL);
			}
		}
	}

}