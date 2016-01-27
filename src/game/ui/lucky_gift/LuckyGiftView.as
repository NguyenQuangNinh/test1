package game.ui.lucky_gift
{
	import com.adobe.utils.StringUtil;
	import core.display.pixmafont.PixmaText;
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.FontUtil;
	import core.util.Utility;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.enum.Font;
	import game.enum.GameConfigID;
	import game.Game;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	import game.ui.components.ProgressBar;
	import game.ui.lucky_gift.gui.AwardResultContainer;
	import game.ui.lucky_gift.gui.CellGiftContainer;
	import game.utility.UtilityUI;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class LuckyGiftView extends ViewBase
	{
		public var closeBtn:SimpleButton;
		public var progressBar:ProgressBar;
		public var btnLuckyGift:SimpleButton;
		public var desciptionTf:TextField;
		public var progressTf:TextField;
		public var timeTf:TextField;
		public var spinNumTf:TextField;
		
		public var rewardResultPopup:AwardResultContainer;
		
		private var cellContainer:CellGiftContainer;
		private var rewardIndexArr:Array;
		
		public function LuckyGiftView()
		{
			closeBtn = UtilityUI.getComponent(UtilityUI.CLOSE_BTN) as SimpleButton;
			if (!stage) addEventListener(Event.ADDED_TO_STAGE, onStageInit);
			else onStageInit();
		}
		
		private function onStageInit(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStageInit);
			rewardResultPopup.fadeOut();
			spinNumTf.maxChars = 2;
			spinNumTf.text = "1";
			spinNumTf.restrict = "0-9";
			spinNumTf.addEventListener(MouseEvent.CLICK, spinNumTfHdl);
			spinNumTf.addEventListener(Event.CHANGE, spinNumTfChangeHdl);
			
			if (closeBtn != null)
			{
				closeBtn.x = 782;
				closeBtn.y = 104;
				addChild(closeBtn);
				closeBtn.addEventListener(MouseEvent.CLICK, closeHandler);
			}
			
			btnLuckyGift.addEventListener(MouseEvent.CLICK, btnLuckyGiftHandler);
			
			cellContainer = new CellGiftContainer(this);
			var arrRewardID:Array = Game.database.gamedata.getConfigData(GameConfigID.REWARD_LUCKY_GIFT_LIST) as Array;
			cellContainer.init(arrRewardID);
			
			this.addChildAt(cellContainer, 1);
			
			FontUtil.setFont(desciptionTf, Font.ARIAL, false);
			FontUtil.setFont(progressTf, Font.TAHOMA, false);
			FontUtil.setFont(timeTf, Font.TAHOMA, false);
			FontUtil.setFont(spinNumTf, Font.TAHOMA, false);
			
			this.setChildIndex(rewardResultPopup, this.numChildren - 1);
		}
		
		private function spinNumTfChangeHdl(e:Event):void 
		{
			//if (spinNumTf.text == "") spinNumTf.text = "1";
		}
		
		private function spinNumTfHdl(e:MouseEvent):void 
		{
			spinNumTf.setSelection(0, spinNumTf.text.length);
		}
		
		public function init():void
		{
			var nXuConsumeNeed:int = Game.database.gamedata.getConfigData(GameConfigID.CONSUME_XU_NEED_CHANGE_LUCKY_GIFT_TIME) as int;
			progressTf.text = Game.database.userdata.luckyGiftXu + "/" + nXuConsumeNeed;
			timeTf.text = Game.database.userdata.luckyGiftTime.toString() + " lần";
			
			progressBar.setProgress(Game.database.userdata.luckyGiftXu, nXuConsumeNeed);
			cellContainer.reset();
			btnLuckyGift.mouseEnabled = true;
			closeBtn.mouseEnabled = true;
			desciptionTf.text = "Tiêu " + nXuConsumeNeed.toString() + " vàng để được 1 lần quay";
		}
		
		private function closeHandler(e:MouseEvent):void
		{
			this.dispatchEvent(new EventEx(LuckyGiftModule.CLOSE_LUCKY_GIFT_VIEW));
		}
		
		private function btnLuckyGiftHandler(e:MouseEvent):void
		{
			//kiem tra so lan quay may man
            var max:int = 30;
            if (spinNumTf.text == "") spinNumTf.text = "1";
            if (int(spinNumTf.text) > max) spinNumTf.text = "30";
			var spinNum:int = int(spinNumTf.text);
			if (Game.database.userdata.luckyGiftTime - spinNum < 0)
			{
				Manager.display.showMessageID(56);
				return;
			}
			
			btnLuckyGift.mouseEnabled = false;
			closeBtn.mouseEnabled = false;
			this.dispatchEvent(new EventEx(LuckyGiftModule.REQUEST_REWARD_LUCKY_GIFT));
		}
		
		public function updateLuckyGiftView(rewardIndexArr:Array):void
		{
			timeTf.text = Game.database.userdata.luckyGiftTime.toString() + " lần";
			this.rewardIndexArr = rewardIndexArr;
			var arrRewardID:Array = Game.database.gamedata.getConfigData(GameConfigID.REWARD_LUCKY_GIFT_LIST) as Array;
			var indexRewardID:int = rewardIndexArr[0];
			btnLuckyGift.mouseEnabled = false;
			closeBtn.mouseEnabled = false;
			cellContainer.reset();
			cellContainer.startAnim(this.onAnimCompleteHdl);
			//update indexRewardID;
			cellContainer.rewardIndex = indexRewardID;
		}
		
		public function onAnimCompleteHdl():void
		{
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_PLAYER_INFO));
			rewardResultPopup.initCellGiftList(this.rewardIndexArr);
			rewardResultPopup.fadeIn();
		}
	
	}

}