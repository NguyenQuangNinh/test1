package game.ui.present.gui
{
	import com.greensock.TweenMax;
	import core.event.EventEx;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.enum.Font;
	import game.enum.ShopID;
	import game.Game;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.request.RequestBuyItemShopVip;
	import game.net.lobby.response.ResponseGetShopVipInfo;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class CaoThuNguPhaiView extends MovieClip
	{
		
		public var btnEnlist:SimpleButton;
		public var container:ContainerCaoThu;
		public var msgTf:TextField;
		public var priceTf:TextField;
		
		public function CaoThuNguPhaiView()
		{
			FontUtil.setFont(msgTf, Font.ARIAL, false);
			FontUtil.setFont(priceTf, Font.ARIAL, false);
			
			this.addEventListener(ContainerCaoThu.CHANGE_SELECT, onChangeSelectCaoThu);
			
			msgTf.visible = false;
			
			btnEnlist.addEventListener(MouseEvent.CLICK, onBtnEnlistClick);
		}
		
		private function onBtnEnlistClick(e:Event):void 
		{
			var caothu:CaoThuItem = container.getCaoThuItem();
			if (caothu && caothu.shopXML)
			{
				Game.network.lobby.sendPacket(new RequestBuyItemShopVip(LobbyRequestType.SHOP_BUY_ITEM_SHOP_VIP, caothu.shopXML.ID, 1, 5));
			}
		}
		
		private function onChangeSelectCaoThu(e:EventEx):void
		{
			var caothu:CaoThuItem = container.getCaoThuItem();
			if (caothu && caothu.shopXML)
			{
				priceTf.text = caothu.shopXML.price.toString();
			}
		}
		
		public function init():void
		{
			var nVipNeed:int = 5;
			if (container.nCurrentIndex == -1)
				container.init(nVipNeed);
			if (Game.database.userdata.vip >= nVipNeed)
			{
				btnEnlist.mouseEnabled = true;
				TweenMax.to(btnEnlist, 0, {alpha: 1, colorMatrixFilter: {saturation: 1}});
			}
			else
			{
				TweenMax.to(btnEnlist, 0, {alpha: 1, colorMatrixFilter: {saturation: 0}});
				btnEnlist.mouseEnabled = false;
			}
		}
		
		public function reset():void
		{
			container.reset();
		}
		
		public function updateShopVip(packet:ResponseGetShopVipInfo):void
		{
			if (packet && packet.arrItemShop.length > 0)
			{
				msgTf.visible = true;
				btnEnlist.visible = false;
				container.grayCaoThu(packet.arrItemShop[0].itemShopID);
			}
			else
			{
				msgTf.visible = false;
				btnEnlist.visible = true;
			}
		}
	}

}