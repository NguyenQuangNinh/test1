package game.ui.top_bar
{
import com.greensock.TweenLite;
import com.greensock.TweenMax;
import com.greensock.easing.Back;
import core.display.layer.LayerManager;

import core.Manager;
import core.display.ViewBase;
import core.display.animation.Animator;
import core.display.layer.Layer;
import core.event.EventEx;
import core.util.FontUtil;
import core.util.Utility;

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;
	import flash.text.TextField;

import game.Game;
import game.data.model.UserData;
import game.enum.Font;
import game.ui.ModuleID;
	import game.ui.hud.gui.ChargeBtn;
	import game.ui.tooltip.TooltipEvent;
import game.ui.tooltip.TooltipID;
import game.ui.top_bar.gui.ActionPointBar;
import game.ui.top_bar.gui.BattlePointBar;
import game.ui.top_bar.gui.ExpBar;
import game.ui.top_bar.gui.FormationStatUI;
import game.ui.top_bar.gui.NumberBar;

/**
	 * ...
	 * @author anhtinh
	 */
	public class TopBarView extends ViewBase
	{
		public var actionPointBar:ActionPointBar;
		public var expBar:ExpBar;
		
		public var xuNumber:NumberBar;
		public var goldNumber:NumberBar;
		public var hornorNumber:NumberBar;
		
		public var battlePointBar:BattlePointBar;
		
		public var nameTf:TextField;
		public var vipTf:TextField;
		public var levelTf:TextField;
		
		public var vipBtn:SimpleButton;
		public var addBtn:SimpleButton;
		public var btnFirstCharge:ChargeBtn;
		
		
		public var apTooltip:MovieClip;
		public var hitMov:MovieClip;
		public var formationView:FormationStatUI;
		
		
		private var enableClick	:Boolean; //cho tutorial
		private var _currentDamage:int = 0;
		
		public function TopBarView()
		{
			
			FontUtil.setFont(nameTf, Font.ARIAL);
			FontUtil.setFont(vipTf, Font.ARIAL);
			FontUtil.setFont(apTooltipTf, Font.ARIAL);
			FontUtil.setFont(levelTf, Font.ARIAL, true);

			nameTf.mouseEnabled = false;
			vipTf.mouseEnabled = false;
			levelTf.mouseEnabled = false;
			
			actionPointBar.setPercent(0);
			expBar.setPercent(0);
			
			xuNumber.setValue(0);
			goldNumber.setValue(0);
			hornorNumber.setValue(0);
			

			apTooltip.visible = false;
			
			//add events
			formationView.visible = false;
			hitMov.buttonMode = true;
			hitMov.addEventListener(MouseEvent.ROLL_OVER, onHitRollOverHdl);
			hitMov.addEventListener(MouseEvent.ROLL_OUT, onHitRollOutHdl);
			
			Game.database.userdata.addEventListener(UserData.GOLD_CHANGED, onGoldChanged);
			Game.database.userdata.addEventListener(UserData.BATTLE_POINT_CHANGED, onBattlePointChanged);
			Game.database.userdata.addEventListener(UserData.XU_CHANGED, onXuChanged);
			
			addBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			vipBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			btnFirstCharge.btn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			
			setClickEnable(true);
			
			var anim:Animator = new Animator();
			anim.setCacheEnabled(true);
			anim.load("resource/anim/ui/fx_button.banim");
			anim.x = 27;
			anim.y = 40;
			anim.mouseEnabled = false;
			anim.mouseChildren = false;
			//anim.scaleX = anim.scaleY = 0.8;
			anim.play();
			anim.mouseEnabled = false;
			btnFirstCharge.addChild(anim);
			
			btnFirstCharge.showFirstCharge(true);
		}

		private function get apTooltipTf():TextField
		{
			return apTooltip.contentTf;
		}

		private function onBtnClickHdl(e:Event):void 
		{
			if (!enableClick) return;
			switch(e.target) {
				case addBtn:
					this.dispatchEvent(new EventEx(TopBarEvent.ADD_ACTION_POINT, null, true));
					break;
					
				case vipBtn:
					Manager.display.showPopup(ModuleID.DIALOG_VIP, Layer.BLOCK_BLACK);
					break;
					
				case btnFirstCharge.btn:
					if(Game.database.userdata.nFirstChargeState == 1 || Game.database.userdata.nFirstChargeState == 2) // 1: chua nap lan dau, 2: nap lan dau roi nhung chua nhan thuong
					{
						Manager.display.showPopup(ModuleID.PAYMENT, Layer.BLOCK_BLACK);
					}
					else
					{
						Game.database.gamedata.loadPaymentHTML();
					}

					break;
			}
		}
		
		protected function onXuChanged(event:Event):void
		{
			xuNumber.setValue(Game.database.userdata.xu);
		}
		
		protected function onBattlePointChanged(event:Event):void
		{
			battlePointBar.setBattlePoint(_currentDamage, Game.database.userdata.formationStat.damage); //tổng lực chiến
			_currentDamage = Game.database.userdata.formationStat.damage;
		}
		
		private function onHitRollOutHdl(e:MouseEvent):void
		{
			formationView.visible = false;
		}
		
		private function onHitRollOverHdl(e:MouseEvent):void
		{
			formationView.visible = true;
		}
		
		protected function onGoldChanged(event:Event):void
		{
			
			goldNumber.setValue(Game.database.userdata.getGold());
		}
		
		public function update():void
		{
			var userData:UserData = Game.database.userdata;
			
			actionPointBar.setProgress(userData.actionPoint, userData.maxActionPoint);
			expBar.setProgress(userData.currentExp, userData.expToNextLevel, true);
			
			nameTf.text = userData.playerName;
			vipTf.text = userData.vip.toString();
			levelTf.text = userData.level.toString();
			battlePointBar.setBattlePoint(_currentDamage, userData.formationStat.damage); //tổng lực chiến
			_currentDamage = userData.formationStat.damage;
			
			xuNumber.setValue(userData.xu);
			goldNumber.setValue(userData.getGold());
			hornorNumber.setValue(userData.honor);
			
			if (Game.database.userdata.nFirstChargeState == 3)
			{
				btnFirstCharge.showFirstCharge(false);
			} else
			{
				btnFirstCharge.showFirstCharge(true);
			}
			
			formationView.update(Game.database.userdata.formationStat);
		}
		
		public function setClickEnable(value:Boolean):void {
			enableClick = value;
		}
		
		override protected function transitionInComplete():void
		{
			super.transitionInComplete();
			update();					
			
			actionPointBar.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			actionPointBar.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			hornorNumber.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			hornorNumber.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			xuNumber.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			xuNumber.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			goldNumber.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			goldNumber.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			expBar.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			expBar.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			vipBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			vipBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			addBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			btnFirstCharge.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			btnFirstCharge.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			
		
			//init formationView
			formationView.update(Game.database.userdata.formationStat);
			
			

		}
		
		override protected function transitionOutComplete():void
		{
			super.transitionOutComplete();
		
			actionPointBar.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
			actionPointBar.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			hornorNumber.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
			hornorNumber.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			xuNumber.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
			xuNumber.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			goldNumber.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
			goldNumber.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			expBar.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
			expBar.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			vipBtn.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
			vipBtn.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			addBtn.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addBtn.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			
			hideTooltip(null);
		}
		
		private function onRollOut(e:MouseEvent):void
		{
			hideTooltip(e);
		}
		
		private function onRollOver(e:MouseEvent):void
		{
			switch (e.target)
			{
				case addBtn:
						dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type: TooltipID.SIMPLE, value: "Nhấn vào để hồi phục thể lực."}, true));
					break;
				case vipBtn:
						dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type: TooltipID.SIMPLE, value: "Nhấn vào để mở VIP."}, true));
					break;
				case expBar:
					var userData:UserData = Game.database.userdata;
					if (userData != null && userData.expToNextLevel > 0){
						var expPercent:Number = Utility.math.setPrecision(userData.currentExp / userData.expToNextLevel * 100, 2);					
						dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, 
							{type: TooltipID.SIMPLE, value: "Kinh nghiệm: Dùng để lên cấp\n" + Utility.math.formatInteger(userData.currentExp) + " / " + Utility.math.formatInteger(userData.expToNextLevel) + "( " + expPercent + " %)" }, true));
					}
					else{
						dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type: TooltipID.SIMPLE, value: "Tài khoản đã đạt cấp độ tối đa."}, true));
					}
					break;
				case hornorNumber:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type: TooltipID.SIMPLE, value: "Uy danh: Dùng để chiêu mộ nhân vật trong Giang Hồ Đại Hiệp. \nNhận được trong nhiệm vụ Đưa Thư và các tính năng PvP."}, true));
					break;
				case xuNumber:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type: TooltipID.SIMPLE, value: "Vàng: Nhận được khi nạp thẻ"}, true));
					break;
				case goldNumber:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type: TooltipID.SIMPLE, value: "Bạc: Dùng để nâng cấp nhân vật, nâng cấp kỹ năng, bói mệnh khí.v.v."}, true));
					break;
				case actionPointBar: 
					apTooltip.alpha = 0;
					apTooltip.visible = true;
					var remainAPRegenTime:int = Game.database.userdata.getRemainTimeRegainAP();
						remainAPRegenTime = Math.round(remainAPRegenTime/(1000*60));
					apTooltipTf.text = 'Điểm thể lực sẽ tự động hồi phục 20 phút 1 điểm\r\nHiện tại sẽ hồi 1 thể lực sau '+ remainAPRegenTime + ' phút.';
					TweenMax.to(apTooltip, 0.3, {alpha: 1});
					break;
					
				case btnFirstCharge:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type: TooltipID.SIMPLE, value: "Nạp Xu lần đầu để nhận nhiều phần quà hấp dẫn"}, true));
					break;
					
				default: 
					break;
			}
		
		}
		
		override public function transitionIn():void
		{
			//super.transitionIn();
			Manager.layer.addToLayer(btnFirstCharge, LayerManager.LAYER_HUD_TOP);
			this.y = -120;
			this.visible = true;
			this.alpha = 1;
			mouseChildren = false;
			mouseEnabled = false;
			
			TweenLite.to(this, 0.5, {y: 0, ease: Back.easeOut, onComplete: transitionInComplete});
		}
		
		override public function transitionOut():void
		{
			addChild(btnFirstCharge);
			super.transitionOut();
		}
		
		private function hideTooltip(e:MouseEvent):void
		{
			dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
			apTooltip.visible = false;
		}
	}

}