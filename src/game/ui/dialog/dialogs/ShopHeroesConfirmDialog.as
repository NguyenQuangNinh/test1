package game.ui.dialog.dialogs 
{
	import core.event.EventEx;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import game.data.xml.ShopXML;
	import game.enum.Font;
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.request.RequestShopBuySingleItem;
	import game.ui.components.OptionGroup;
	import game.ui.dialog.HeroesPriceOption;
	import game.ui.shop.ShopEvent;
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ShopHeroesConfirmDialog extends Dialog 
	{
		public static const BUY		:int = 1;
		public static const EXTEND	:int = 2;
		
		public var txtMessage		:TextField;
		public var optionsContainer	:MovieClip; 
		private var optionsGroup	:OptionGroup;
		private var options			:Array;
		
		public function ShopHeroesConfirmDialog() {
			FontUtil.setFont(txtMessage, Font.ARIAL);
			optionsGroup = new OptionGroup();
			options = [];
			for(var i:int = 0; i < 3; ++i)
			{
				var option:HeroesPriceOption= new HeroesPriceOption();
				option.y = i * 46;
				optionsContainer.addChild(option);
				optionsGroup.addOption(option.checkbox);
				options.push(option);
			}
			optionsGroup.setSelected(0);
		}
		
		override public function set data(value:Object):void {
			value.objs = value.objs.sortOn("price", Array.NUMERIC);
			_data = value;
		}
		
		override public function onShow():void {
			super.onShow();
			if (data) {
				var length:int = Math.min(options.length, data.objs.length);
				var obj:Object;
				for (var i:int = 0; i < length; i++) {
					obj = data.objs[i];
					HeroesPriceOption(options[i]).visible = true;
					HeroesPriceOption(options[i]).setData(obj.ID, obj.expirationTime, obj.itemType, obj.itemID, obj.price);
				}
				
				for (i = length; i < options.length; i++) {
					HeroesPriceOption(options[i]).visible = false;
				}
				txtMessage.text = data.message;
			}
		}
		
		override protected function onOK(event:Event = null):void {
			var selectedIndex:int = optionsGroup.getSelected();
			if (options[selectedIndex] != null) {
				var id:int = HeroesPriceOption(options[selectedIndex]).getID();
				switch(data.processType) {
					case BUY:
						var requestPacket:RequestShopBuySingleItem = new RequestShopBuySingleItem();
						requestPacket.shopItemID = id;
						requestPacket.itemQuantity = 1;
						Game.network.lobby.sendPacket(requestPacket);
						break;
						
					case EXTEND:
						Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.EXTEND_RECRUITMENT_SHOP_HEROES, id));
						break;
				}
			}
			super.onOK(event);
		}
	}

}