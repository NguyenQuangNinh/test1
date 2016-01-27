package game.ui.gift_online
{
	import com.greensock.TweenMax;
	import core.display.layer.Layer;
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.FontUtil;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import game.data.model.item.ItemFactory;
	import game.data.xml.DataType;
	import game.data.xml.RewardXML;
	import game.data.xml.VIPConfigXML;
	import game.enum.DialogEventType;
	import game.enum.Font;
	import game.enum.GameConfigID;
	import game.Game;
	import game.enum.ItemType;
	import game.net.IntRequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.response.ResponseGetGiftOnlineInfo;
	import game.ui.dialog.DialogID;
	import game.ui.gift_online.gui.GiftItem;
	import game.utility.GameUtil;
	import game.utility.UtilityUI;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class GiftOnlineView extends ViewBase
	{
		
		private static const TYPE_RECEVIVE_GIFT_ONLINE_NORMAL:int = 0;
		private static const TYPE_RECEVIVE_GIFT_ONLINE_FAST:int = 1;
		
		private var closeBtn:SimpleButton;
		
		public var btnReceive:SimpleButton;
		public var btnReceiveFast:SimpleButton;
		
		public var titleTf:TextField;
		public var bonusTf:TextField;
		public var msgTf:TextField;
		public var timeTf:TextField;
		public var vipTf:TextField;
		public var nextVipTf:TextField;
		
		private var _timer:Timer;
		private var _remainCount:int;
		private var _arrGiftItem:Array = [];
		
		public function GiftOnlineView()
		{
			closeBtn = UtilityUI.getComponent(UtilityUI.CLOSE_BTN) as SimpleButton;
			
			if (closeBtn != null)
			{
				closeBtn.x = Game.WIDTH - 2 * closeBtn.width - 300;
				closeBtn.y = 2 * closeBtn.height + 45;
				addChild(closeBtn);
				closeBtn.addEventListener(MouseEvent.CLICK, closeHandler);
			}
			
			FontUtil.setFont(titleTf, Font.ARIAL, true);
			FontUtil.setFont(bonusTf, Font.ARIAL, false);
			FontUtil.setFont(vipTf, Font.ARIAL, false);
			FontUtil.setFont(timeTf, Font.ARIAL, true);
			FontUtil.setFont(nextVipTf, Font.ARIAL, true);
			FontUtil.setFont(msgTf, Font.ARIAL, false);
			
			titleTf.text = "";
			timeTf.text = "--:--";
			vipTf.text = "";
			nextVipTf.text = "";
			
			_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER, onTimerUpdateHdl);
			
			btnReceive.addEventListener(MouseEvent.CLICK, onClickReceive);
			btnReceiveFast.addEventListener(MouseEvent.CLICK, onClickReceiveFast);
			
			msgTf.visible = false;
		}
		
		private function onClickReceiveFast(e:Event):void
		{
			var nStatusGiftOnline:int = Game.database.userdata.nStatusGiftOnline;
			var arrXuNeed:Array = Game.database.gamedata.getConfigData(GameConfigID.XU_NEED_RECEIVE_GIFT_ONLINE_FAST) as Array;
			if(nStatusGiftOnline>=0 && nStatusGiftOnline<arrXuNeed.length)
			{
			Manager.display.showDialog(DialogID.YES_NO, function():void
				{
					
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.RECEIVE_GIFT_ONLINE_REWARD, TYPE_RECEVIVE_GIFT_ONLINE_FAST));
				}, null, { type: DialogEventType.CONFIRM_FINISH_GIFT_ONLINE, xu: arrXuNeed[nStatusGiftOnline] }, Layer.BLOCK_BLACK);
				
			}
		}
		
		private function onClickReceive(e:Event):void
		{
			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.RECEIVE_GIFT_ONLINE_REWARD, TYPE_RECEVIVE_GIFT_ONLINE_NORMAL));
		}
		
		private function closeHandler(e:Event):void
		{
			this.dispatchEvent(new EventEx(GiftOnlineModule.CLOSE_GIFT_ONLINE_VIEW));
		}
		
		private function onTimerUpdateHdl(e:Event):void
		{
			_remainCount = _remainCount > 0 ? _remainCount - 1 : 0;
			timeTf.text = Utility.math.formatTime("M-S", _remainCount);
			
			if (_remainCount == 0)
			{
				_timer.stop();
				this.onCompleteCountDown();
			}
		}
		
		private function onCompleteCountDown():void
		{
			this.setStatusBtnRecevie(true);
		}
		
		private function stopCountDown():void
		{
			_timer.stop();
		}
		
		private function startCountDown():void
		{
			_timer.start();
		}
		
		public function update(responseGetGiftOnlineInfo:ResponseGetGiftOnlineInfo):void
		{
			if (!responseGetGiftOnlineInfo)
				return;
			
			this.reset();
			
			var nStatusGiftOnline:int = responseGetGiftOnlineInfo.nStatusGiftOnline;
			
			Game.database.userdata.nStatusGiftOnline = nStatusGiftOnline;
			
			var arrTimeGiftOnline:Array = Game.database.gamedata.getConfigData(GameConfigID.TIME_GIFT_ONLINE) as Array;
			if (nStatusGiftOnline >= 0 && nStatusGiftOnline < arrTimeGiftOnline.length)
			{
				updateStatus(true);
				
				_remainCount = responseGetGiftOnlineInfo.nDiffSecond;
				if (_remainCount < 0)
					_remainCount = 0;
				this.startCountDown();
				
				this.setStatusBtnRecevie(responseGetGiftOnlineInfo.bCanReceive);
				
				var arrXuNeedReceiveGiftOnlineFast:Array = Game.database.gamedata.getConfigData(GameConfigID.XU_NEED_RECEIVE_GIFT_ONLINE_FAST) as Array;
				var arrGiftOnlineRewardNormal:Array = Game.database.gamedata.getConfigData(GameConfigID.GIFT_ONLINE_REWARD_NORMAL) as Array;
				if (nStatusGiftOnline >= 0 && nStatusGiftOnline < arrTimeGiftOnline.length && nStatusGiftOnline < arrXuNeedReceiveGiftOnlineFast.length && nStatusGiftOnline < arrGiftOnlineRewardNormal.length)
				{
					titleTf.text = "Online " + arrTimeGiftOnline[nStatusGiftOnline] + "'";
					//init normal
					buildGiftItem(arrGiftOnlineRewardNormal[nStatusGiftOnline], 215);
					//init vip
					var nVip:int = Game.database.userdata.vip;
					
					vipTf.text = "Thưởng Vip" + nVip;
					nextVipTf.text = "Đạt Vip" + (nVip + 1) + " để nhận được:";
					vipTf.visible = nVip != 0;
					
					if(nVip != 0)
						this.buildGiftItemVip(nStatusGiftOnline, nVip, 290);
						
					this.buildGiftItemVip(nStatusGiftOnline, nVip + 1, 356);
				}
			}
			else
			{
				titleTf.text = "";
				timeTf.text = "--:--";
				_remainCount = 0;
				this.stopCountDown();
				updateStatus(false);
			}
		}
		
		private function buildGiftItemVip(nStatusGiftOnline:int, nVip:int, posY:int):void
		{
			var vipXML:VIPConfigXML = Game.database.gamedata.getData(DataType.VIP, nVip) as VIPConfigXML;
			if (vipXML)
			{
				if (nStatusGiftOnline >= 0 && nStatusGiftOnline < vipXML.arrRewardSetGiftOnline.length)
				{
					this.buildGiftItem(vipXML.arrRewardSetGiftOnline[nStatusGiftOnline], posY);
				}
			}
		}
		
		private function buildGiftItem(nRewardID:int, posY:int):void
		{
			var arrReward:Array = GameUtil.getItemRewardsByID(nRewardID) as Array;
			var lastType:ItemType = ItemType.NONE;

			for (var i:int = 0; i < arrReward.length; i++)
			{
				var rewardXml:RewardXML = arrReward[i] as RewardXML;
				if (rewardXml != null)
				{
					var item:GiftItem = new GiftItem();
					item.setConfigInfo(ItemFactory.buildItemConfig(rewardXml.type, rewardXml.itemID));
					item.setQuantity(rewardXml.quantity);

					if(lastType == ItemType.GOLD || lastType == ItemType.EXP)
					{
						item.x = 420 + i * 100;
					}
					else
					{
						item.x = 420 + i * 80;
					}

					item.y = posY;
					item.setScaleItemSlot(0.7);
					this.addChild(item);
					_arrGiftItem.push(item);

					lastType = rewardXml.type;
				}
			}
		}
		
		private function setStatusBtnRecevie(val:Boolean):void
		{
			btnReceive.mouseEnabled = val;
			btnReceiveFast.mouseEnabled = !val;
			
			var nSaturation:int = val == true ? 1 : 0;
			TweenMax.to(btnReceive, 0, { alpha: 1, colorMatrixFilter: { saturation: nSaturation }} );
			
			nSaturation = !val == true ? 1 : 0;
			TweenMax.to(btnReceiveFast, 0, {alpha: 1, colorMatrixFilter: {saturation: nSaturation}});
		}
		
		private function reset():void
		{
			for each (var obj:GiftItem in _arrGiftItem)
			{
				this.removeChild(obj);
			}
			_arrGiftItem = [];
		}
		
		private function updateStatus(val:Boolean):void
		{
			msgTf.visible = !val;
			
			bonusTf.visible = val;
			vipTf.visible = val;
			nextVipTf.visible = val;
			btnReceiveFast.visible = val;
			btnReceive.visible = val;
		}
	}
}