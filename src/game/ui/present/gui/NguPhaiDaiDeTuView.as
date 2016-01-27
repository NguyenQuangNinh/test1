package game.ui.present.gui
{
	import com.greensock.TweenMax;
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
	public class NguPhaiDaiDeTuView extends MovieClip
	{
		
		public var btnReceive:SimpleButton;
		public var container:ContainerCaoThu;
		public var msgTf:TextField;
		
		public function NguPhaiDaiDeTuView()
		{
			FontUtil.setFont(msgTf, Font.ARIAL, false);
			btnReceive.addEventListener(MouseEvent.CLICK, onBtnReceiveClick);
			msgTf.visible = false;
		}
		
		private function onBtnReceiveClick(e:Event):void
		{
			var caothu:CaoThuItem = container.getCaoThuItem();
			if (caothu && caothu.shopXML)
			{
				Game.network.lobby.sendPacket(new RequestBuyItemShopVip(LobbyRequestType.SHOP_BUY_ITEM_SHOP_VIP, caothu.shopXML.ID, 1, 1));
			}
		}
		
		public function init():void
		{
			var nVipNeed:int = 1;
			if (container.nCurrentIndex == -1)
				container.init(nVipNeed);
			
			if (Game.database.userdata.vip >= nVipNeed)
			{
				btnReceive.mouseEnabled = true;
				TweenMax.to(btnReceive, 0, {alpha: 1, colorMatrixFilter: {saturation: 1}});
			}
			else
			{
				
				TweenMax.to(btnReceive, 0, {alpha: 1, colorMatrixFilter: {saturation: 0}});
				btnReceive.mouseEnabled = false;
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
				btnReceive.visible = false;
				container.grayCaoThu(packet.arrItemShop[0].itemShopID);
			}
			else
			{
				msgTf.visible = false;
				btnReceive.visible = true;
			}
		}
	}

}