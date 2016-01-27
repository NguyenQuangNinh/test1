package game.ui.activity_point {
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.net.lobby.response.ResponseGlobalBossTopDmg;
	import game.enum.Font;
	import game.ui.global_boss.GlobalBossEvent;
	import game.ui.hud.HUDModule;
	import game.ui.ModuleID;
	import game.utility.UtilityUI;
	/**
	 * ...
	 * @author vu anh
	 */
	public class ActivityPointView extends ViewBase
	{
		
		public var actionPointTf:TextField;
		public var actionList:ActivityList;
		public var rewardCon:ActivityRewardContainer;
		public var closeBtn:SimpleButton;
		
		public function ActivityPointView() 
		{
			FontUtil.setFont(actionPointTf, Font.ARIAL, true);
			closeBtn.addEventListener(MouseEvent.CLICK, closeHandler);
		}
		
		private function closeHandler(e:MouseEvent):void 
		{
			var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
			if (hudModule != null)
			{
				hudModule.updateHUDButtonStatus(ModuleID.ACTIVITY, false);
			}
		}
		
	}

}