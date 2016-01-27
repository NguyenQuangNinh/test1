package game.ui.shop_pack 
{
	import core.event.EventEx;
	import core.util.FontUtil;
	import core.util.MovieClipUtils;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.data.model.item.IItemConfig;
	import game.data.model.item.ItemFactory;
	import game.data.xml.RewardXML;
	import game.data.xml.ShopXML;
	import game.enum.Font;
	import game.enum.PaymentType;
	import game.Game;
	import game.ui.components.Reward;
	import game.utility.UtilityUI;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ItemPackMov extends MovieClip
	{
		public var nameTf:TextField;
		public var oldPriceTf:TextField;
		public var priceTf:TextField;
		public var quantityTf:TextField;
		public var buyQuantityTf:TextField;
		public var buyBtn:SimpleButton
		public var newMov:MovieClip;
		public var discountMov:MovieClip;
		public var crossMov:MovieClip;
		
		private var paymentType:MovieClip;
		private var discountPaymentType:MovieClip;
		private var _info:ShopXML;
		
		private static const ITEM_START_FROM_X:int = 6;
		private static const ITEM_START_FROM_Y:int = 28;
		private static const PAYMENT_TYPE_START_FROM_X:int = 149 + 59;
		private static const PAYMENT_TYPE_START_FROM_Y:int = 52;
		private var _item:Reward;
		private var _numBought:int = 0;
		
		public static const BUY_ITEM_PACK:String = "buy_item_pack";
		
		public function ItemPackMov() 
		{
			initUI();
		}
		
		private function initUI():void 
		{
			FontUtil.setFont(nameTf, Font.ARIAL, false);
			FontUtil.setFont(quantityTf, Font.ARIAL, false);
			FontUtil.setFont(buyQuantityTf, Font.ARIAL, true);
			FontUtil.setFont(priceTf, Font.ARIAL, false);
			FontUtil.setFont(discountMov.tf, Font.ARIAL, true);
			FontUtil.setFont(oldPriceTf, Font.ARIAL, false);

			buyQuantityTf.text = "1";
			buyQuantityTf.restrict = "0-9";
			buyQuantityTf.addEventListener(Event.CHANGE, quantityTf_textInputHandler);
			buyQuantityTf.addEventListener(FocusEvent.FOCUS_OUT, quantityTf_focusOutHandler);
			buyQuantityTf.addEventListener(MouseEvent.CLICK, quantityTf_clickHandler);

			buyBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			
			_item = new Reward();
			_item.x = ITEM_START_FROM_X;
			_item.y = ITEM_START_FROM_Y;
			_item.changeType(Reward.EMPTY);
			//addChildAt(_item, 0);
			addChild(_item);
			
			paymentType = UtilityUI.getComponent(UtilityUI.PAYMENT_TYPE) as MovieClip;
			paymentType.x = PAYMENT_TYPE_START_FROM_X;
			paymentType.y = PAYMENT_TYPE_START_FROM_Y;
			paymentType.scaleX = paymentType.scaleY = 0.5;
			addChild(paymentType);
			
			discountPaymentType = UtilityUI.getComponent(UtilityUI.PAYMENT_TYPE) as MovieClip;
			discountPaymentType.x = PAYMENT_TYPE_START_FROM_X - 59;
			discountPaymentType.y = PAYMENT_TYPE_START_FROM_Y;
			discountPaymentType.scaleX = discountPaymentType.scaleY = 0.5;
			addChild(discountPaymentType);
			
			addChild(crossMov);
			
		}

		private function quantityTf_textInputHandler(event:Event):void
		{
			if(_info.maxBuyNum > 0)
			{
				buyQuantityTf.text = (parseInt(buyQuantityTf.text) <= _info.maxBuyNum) ? buyQuantityTf.text : _info.maxBuyNum.toString();
			}
		}

		private function quantityTf_focusOutHandler(event:FocusEvent):void
		{
			buyQuantityTf.text = (buyQuantityTf.text == "") ? "1" : buyQuantityTf.text;
		}

		private function quantityTf_clickHandler(event:MouseEvent):void
		{
			buyQuantityTf.setSelection(0, buyQuantityTf.length);
		}

		private function onBtnClickHdl(e:MouseEvent):void 
		{
			var quantity:int = parseInt(buyQuantityTf.text);
			dispatchEvent(new EventEx(BUY_ITEM_PACK, {info:_info, quantity:quantity}, true));
		}
		
		public function updateInfo(info:ShopXML, isNew:Boolean = false):void {
			_info = info;
			
			var itemConfig:IItemConfig = ItemFactory.buildItemConfig(info.type, info.itemID);
			nameTf.text = itemConfig.getName();
			priceTf.text = int(info.price - info.price * (info.discount / 100)).toString();
			quantityTf.text = info.maxBuyNum > 0 ? (_numBought + "/" + info.maxBuyNum) : "không giới hạn";
			paymentType.gotoAndStop(info.paymentType.name);
			discountPaymentType.gotoAndStop(info.paymentType.name);
			if (info.discount > 0)
			{
				discountMov.visible = true;
				discountMov.tf.text = "- " + info.discount + "%";
				oldPriceTf.text = info.price.toString();
			} 
			else 
			{
				paymentType.x -= 47;
				priceTf.x -= 50;
				discountMov.visible = false;
			}
			crossMov.visible = discountMov.visible;
			oldPriceTf.visible = discountMov.visible;
			discountPaymentType.visible = discountMov.visible;
			_item.updateInfo(itemConfig, info.stackOneBuy);
			
			newMov.visible = isNew;
		}
		
		public function updateQuantityBought(quantity:int):void {
			_numBought = quantity;
			quantityTf.text = _info.maxBuyNum > 0 ? (_numBought + "/" + _info.maxBuyNum) : "không giới hạn";
		}
		
		public function getItemID():int {
			return _info ? _info.ID : -1;
		}
		
		public function updateValidBuy():int {
			var valid:int = 0;
			switch(_info.paymentType) {
				case PaymentType.GOLD:
					valid = Game.database.userdata.getGold() >= _info.price ? 1 : valid;
					break;
				case PaymentType.HONOR:
				case PaymentType.DEDICATE_POINT:
					valid = Game.database.userdata.honor >= _info.price ? 2 : valid;
					break;
				case PaymentType.XU_NORMAL:
					valid = Game.database.userdata.xu >= _info.price ? 3 : valid;					
					break;
			}
			//buyBtn.mouseEnabled = valid;
			/*if (!valid)
				MovieClipUtils.applyGrayScale(buyBtn);
			else 
				MovieClipUtils.removeAllFilters(buyBtn);*/
			return valid;	
		}
	}

}