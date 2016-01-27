package game.ui.soul_center.gui
{
	import adobe.utils.CustomActions;
	import com.greensock.TweenLite;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.data.xml.DataType;
	import game.data.xml.ShopXML;
	import game.enum.Font;
	import game.enum.ShopID;
	import game.Game;
	import game.ui.components.RuningNumberTf;
	import game.ui.soul_center.PriceObject;
	import game.ui.soul_center.SoulShopItem;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class ExchangeSoulPanel extends MovieClip
	{
		public static const BACK_EXCHANGE_BTN:String = "back_exchange_btn";
		
		public static const PAGE_NUM:int = 6;
		
		public var btnBack:SimpleButton;
		public var btnLeft:SimpleButton;
		public var btnRight:SimpleButton;
		
		public var exchangePointTf:TextField;
		public var pageTf:TextField;
		
		private var bInit:Boolean = false;
		private var content:MovieClip = new MovieClip();
		
		private var currentPage:int = 1;
		private var pageNum:int = 1;
		
		
		private var _runningTf:RuningNumberTf;
		private var oldExchangePoint:int = 0;
		
		private var arrShopItem:Array = [];
		
		public function ExchangeSoulPanel()
		{
			FontUtil.setFont(exchangePointTf, Font.ARIAL, true);
			FontUtil.setFont(pageTf, Font.ARIAL, true);
			_runningTf = new RuningNumberTf(exchangePointTf);
			btnBack.addEventListener(MouseEvent.CLICK, onBackExchange);
			btnLeft.addEventListener(MouseEvent.CLICK, onPageLeft);
			btnRight.addEventListener(MouseEvent.CLICK, onPageRight);
			
			content.x = 91;
			content.y = 105;
			this.addChild(content);
		}
		
		private function onPageRight(e:Event):void
		{
			if (currentPage < pageNum)
			{
				currentPage++;
				while (content.numChildren > 0)
				{
					content.removeChildAt(0);
				}
				showContent();
			}
		}
		
		private function onPageLeft(e:Event):void
		{
			if (currentPage > 1)
			{
				currentPage--;
				while (content.numChildren > 0)
				{
					content.removeChildAt(0);
				}
				showContent();
			}
		}
		
		private function onBackExchange(e:Event):void
		{
			this.dispatchEvent(new Event(BACK_EXCHANGE_BTN, true));
		}
		
		public function setExchangePoint(val:int):void
		{
			_runningTf.value = oldExchangePoint;
			oldExchangePoint = val;
			TweenLite.to(_runningTf, 1.5, {value : val } );	
		}
		
		public function init():void
		{
			if (!bInit)
			{
				bInit = true;
				BuildGroupShopItem();
				showContent();
			}
		}
		
		private function BuildGroupShopItem():void
		{
			var arr:Array = Game.database.gamedata.getShopByShopID(ShopID.SOUL.ID);
			for (var i:int = 0; i < arr.length; i++)
			{
				var shopXML:ShopXML = arr[i];
				if (shopXML != null)
				{
					var bFound:Boolean = false;
					for ( var j:int = 0; j < arrShopItem.length; j++)
					{
						var soulShopItem:SoulShopItem = arrShopItem[j];
						if (soulShopItem != null && soulShopItem.itemID == shopXML.itemID)
						{
							//Nếu item trùng nhau thì push vào mảng giá.
							var price:PriceObject = new PriceObject();
							price.paymentType = shopXML.paymentType;
							price.price = shopXML.price;
							price.ID = shopXML.ID;
							price.maxBuyNum = shopXML.maxBuyNum;
							soulShopItem.arrPrice.push(price);
							
							//Đánh dấu tìm thấy
							bFound = true;
						}
					}
					
					//Nếu item không trùng thì thêm mới
					if (bFound == false)
					{
						var soulShopItem1:SoulShopItem = new SoulShopItem();
						soulShopItem1.itemID = shopXML.itemID;
						soulShopItem1.type = shopXML.type;
						soulShopItem1.enable = shopXML.enable;						
						
						var price1:PriceObject = new PriceObject();
						price1.paymentType = shopXML.paymentType;
						price1.price = shopXML.price;
						price1.ID = shopXML.ID;
						price1.maxBuyNum = shopXML.maxBuyNum;
						
						soulShopItem1.arrPrice.push(price1);
						
						arrShopItem.push(soulShopItem1);
					}
				}
			}
		}
		
		private function showContent():void
		{
			pageNum = arrShopItem.length / PAGE_NUM + 1;
			pageTf.text = "" + currentPage + "/" + pageNum;
			
			var start:int = (currentPage - 1) * PAGE_NUM;
			var end:int = currentPage * PAGE_NUM;
			var posX:int = 1;
			var posY:int = 0;
			for (var i:int = start; i < end && i < arrShopItem.length; i++)
			{
				var soulShopItem:SoulShopItem = arrShopItem[i];
				if (soulShopItem.enable)
				{
					var exchangeSlot:ExchangeSlot = new ExchangeSlot();
					exchangeSlot.init(soulShopItem);
					
					if (i % 2 == 0)
					{
						posX = 0;
						posY++;
					}
					else
						posX = 1;
					
					exchangeSlot.x = posX * (35 + 318 - 21);
					exchangeSlot.y = (posY - 1) * 90;
					content.addChild(exchangeSlot);
				}
			}
		}
		public function updateExchangePoint():void 
		{
			this.setExchangePoint(Game.database.userdata.soulExchangePoint);
		}
	}

}