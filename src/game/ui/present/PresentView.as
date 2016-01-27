package game.ui.present
{
	import core.display.ViewBase;
	import core.event.EventEx;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.response.ResponseGetRewardRequireLevelInfo;
	import game.net.lobby.response.ResponseGetShopVipInfo;
	import game.net.lobby.response.ResponseGetTopLevelInPresent;
	import game.net.RequestPacket;
	import game.ui.present.gui.CaoThuNguPhaiView;
	import game.ui.present.gui.DeTuChanTruyenView;
	import game.ui.present.gui.GiftCodeView;
	import game.ui.present.gui.NguPhaiDaiDeTuView;
	import game.ui.present.gui.PresentContainer;
	import game.ui.present.gui.PresentTopView;
	import game.ui.present.gui.RewardLevelView;
	import game.utility.UtilityUI;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class PresentView extends ViewBase
	{
		private var closeBtn:SimpleButton;
		
		public var presentContainer:PresentContainer;
		
		public var giftCodeView:GiftCodeView;
		public var presentTopView:PresentTopView;
		public var rewardLevelView:RewardLevelView;
		public var nguPhaiDaiDeTuView:NguPhaiDaiDeTuView;
		public var deTuChanTruyenView:DeTuChanTruyenView;
		public var caoThuNguPhaiView:CaoThuNguPhaiView;
		
		private var _previousIndexView:int = -1;
		
		public function PresentView()
		{
			init();
		}
		
		private function init(e:Event = null):void
		{
			closeBtn = UtilityUI.getComponent(UtilityUI.CLOSE_BTN) as SimpleButton;
			
			if (closeBtn != null)
			{
				closeBtn.x = Game.WIDTH - 2 * closeBtn.width - 50;
				closeBtn.y = 2 * closeBtn.height + 30;
				addChild(closeBtn);
				closeBtn.addEventListener(MouseEvent.CLICK, closeHandler);
			}
			
			giftCodeView.visible = false;
			presentTopView.visible = false;
			rewardLevelView.visible = false;
			nguPhaiDaiDeTuView.visible = false;
			caoThuNguPhaiView.visible = false;
		
		}
		
		private function closeHandler(e:Event):void
		{
			this.dispatchEvent(new EventEx(PresentModule.CLOSE_PRESENT_VIEW));
		}
		
		public function reset():void
		{
			_previousIndexView = -1;
			giftCodeView.giftcodeTf.text = "";
			
			giftCodeView.visible = false;
			presentTopView.visible = false;
			rewardLevelView.visible = false;
			nguPhaiDaiDeTuView.visible = false;
			deTuChanTruyenView.visible = false;
			caoThuNguPhaiView.visible = false;
			
			presentContainer.init(this);
		
		}
		
		private function setViewContent(index:int, visible:Boolean):void
		{
			switch (index)
			{
				
				case presentContainer.arrBtnName.indexOf(PresentContainer.BTN_TOP_LEVEL): //dua top
				{
					presentTopView.visible = visible;
					if (visible)
						Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_TOP_LEVEL_IN_PRESENT));
				}
					break;
				case presentContainer.arrBtnName.indexOf(PresentContainer.BTN_GIFTCODE): //gift code
				{
					giftCodeView.visible = visible;
				}
					break;
				case presentContainer.arrBtnName.indexOf(PresentContainer.BTN_NGU_PHAI_DAI_DE_TU): 
				{
					if (visible)
					{
						nguPhaiDaiDeTuView.init();
						Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_SHOP_VIP_INFO, 1));
					}
					nguPhaiDaiDeTuView.visible = visible;
				}
					break;
				case presentContainer.arrBtnName.indexOf(PresentContainer.BTN_DE_TU_CHAN_TRUYEN): 
				{
					if (visible)
					{
						deTuChanTruyenView.init();
						Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_SHOP_VIP_INFO, 3));
					}
					deTuChanTruyenView.visible = visible;
				}
					break;
				case presentContainer.arrBtnName.indexOf(PresentContainer.BTN_CAO_THU_NGU_DAI_PHAI): 
				{
					if (visible)
					{
						caoThuNguPhaiView.init();
						Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_SHOP_VIP_INFO, 5));
					}
					caoThuNguPhaiView.visible = visible;
				}
					break;
				case presentContainer.arrBtnName.indexOf(PresentContainer.BTN_REWARD_LEVEL): //thuong level
				{
					rewardLevelView.visible = visible;
					if (visible)
						Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_REWARD_REQUIRE_LEVEL_INFO));
				}
					break;
			}
		}
		
		public function set previousIndexView(value:int):void
		{
			if (_previousIndexView == value)
				return;
			setViewContent(_previousIndexView, false);
			_previousIndexView = value;
			setViewContent(_previousIndexView, true);
		
		}
		
		public function setIndex(index:int):void
		{
			presentContainer.setIndex(index);
		}
		
		public function updatePresentTop(packetGetTopLevelInPresent:ResponseGetTopLevelInPresent):void
		{
			presentTopView.init(packetGetTopLevelInPresent);
		}
		
		public function initRewardLevelView(packet:ResponseGetRewardRequireLevelInfo):void
		{
			rewardLevelView.init(packet);
		}
		
		public function setNotify(btnName:String, val:Boolean):void
		{
			presentContainer.setNotify(btnName, val);
		}
		
		private function resetView():void
		{
			nguPhaiDaiDeTuView.reset();
			deTuChanTruyenView.reset();
		}
		
		override protected function transitionOutComplete():void
		{
			super.transitionOutComplete();
			this.resetView();
		}
		
		public function updateShopVip(packet:ResponseGetShopVipInfo):void
		{
			switch (packet.nVipID)
			{
				case 1: 
				{
					nguPhaiDaiDeTuView.updateShopVip(packet);
				}
					break;
				case 3: 
				{
					deTuChanTruyenView.updateShopVip(packet);
				}
					break;
				case 5: 
				{
					caoThuNguPhaiView.updateShopVip(packet);
				}
					break;
			}
		}
	}
}