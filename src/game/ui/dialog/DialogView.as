package game.ui.dialog 
{
	import core.display.layer.Layer;
	import core.display.ViewBase;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import game.ui.dialog.dialogs.AddFriendDialog;
	import game.ui.dialog.dialogs.Dialog;
	import game.ui.dialog.dialogs.GiftCodeDialog;
	import game.ui.dialog.dialogs.GlobalBossConfirmDialog;
	import game.ui.dialog.dialogs.GlobalBossReviveDialog;
	import game.ui.dialog.dialogs.GlobalBossYesNoDialog;
	import game.ui.dialog.dialogs.HealAPDialog;
	import game.ui.dialog.dialogs.HeroicCreateRoomDialog;
	import game.ui.dialog.dialogs.PassConfirm;
	import game.ui.dialog.dialogs.SweepCampaignDialog;
	import game.ui.dialog.dialogs.ShopHeroesConfirmDialog;
	import game.ui.dialog.dialogs.TuuLauChienDialog;
	import game.ui.dialog.dialogs.TuuLauChienHistoryDialog;
	//import game.ui.dialog.dialogs.quest_transport.MissionCompleted;
	import game.ui.dialog.dialogs.select_class.SelectClassDialog;
	import game.ui.dialog.dialogs.UpStarDialog;
	import game.ui.dialog.dialogs.YesNo;
	
	/**
	 * ...
	 * @author ...
	 */
	public class DialogView extends ViewBase 
	{
		public static const EVENT	:String = "DialogEvent";
		
		private var dialogs:Dictionary = new Dictionary();
		private var mapping:Dictionary = new Dictionary();
		private var blocks:Dictionary = new Dictionary();
		
		private var blackBlock:Sprite;
		private var alphaBlock:Sprite;
		
		private function setUp():void 
		{
			mapping[DialogID.YES_NO] 				= YesNo;
			mapping[DialogID.PASS_CONFIRM] 			= PassConfirm;
			mapping[DialogID.UP_STAR] 				= UpStarDialog;
			mapping[DialogID.SELECT_CLASS] 			= SelectClassDialog;
			//mapping[DialogID.MISSION_COMPLETED] 	= MissionCompleted;
			mapping[DialogID.GLOBAL_BOSS_CONFIRM] 	= GlobalBossConfirmDialog;
			mapping[DialogID.GLOBAL_BOSS_YES_NO] 	= GlobalBossYesNoDialog;
			mapping[DialogID.GLOBAL_BOSS_REVIVE] 	= GlobalBossReviveDialog;
			mapping[DialogID.GIFT_CODE_DIALOG] 		= GiftCodeDialog;
			mapping[DialogID.HEROIC_CREATE_ROOM] 	= HeroicCreateRoomDialog;
			mapping[DialogID.HEAL_AP] 				= HealAPDialog;
			mapping[DialogID.UPGRADE_INFO] 			= UpgradeInfo;
			mapping[DialogID.QUICK_BUY_ITEM] 		= QuickBuyDialog;
			mapping[DialogID.HEROIC_TOWER] 			= HeroicTowerDialog;
			mapping[DialogID.HEROIC_TOWER_ITEM] 	= HeroicTowerItemDialog;
			mapping[DialogID.HELP] 					= DialogHelp;
			mapping[DialogID.HELP_TUULAU] 			= DialogHelpTuuLau;
			mapping[DialogID.ADD_FRIEND] 			= AddFriendDialog;
			mapping[DialogID.TOWER_AUTO] 			= TowerAuto;
			mapping[DialogID.SHOP_HEROES] 			= ShopHeroesConfirmDialog;
			mapping[DialogID.QUICK_FINISH_CAMPAIGN] = SweepCampaignDialog;
			mapping[DialogID.GUILD_MESSAGE] 		= GuildMessageDialog;
			mapping[DialogID.TUU_LAU_CHIEN]			= TuuLauChienDialog;
			mapping[DialogID.TUU_LAU_CHIEN_HISTORY] = TuuLauChienHistoryDialog
		}
		
		public function show(dialogID:String, okCallback:Function, cancelCallback:Function, data:Object, block:int = 2):void {
			var dialog:Dialog = dialogs[dialogID];
			
			if (!dialog) {
				dialog = new mapping[dialogID]();
				dialogs[dialogID] = dialog;
				dialog.addEventListener(Event.CLOSE, onDialogClose);
			}

			dialog.okCallback = okCallback;
			dialog.cancelCallback = cancelCallback;
			dialog.data = data;
			addChild(dialog);
			dialog.onShow();
			dialog.visible = true;
			dialog.block = block;

			if(blocks[block]) blocks[block].visible = true;
		}
		
		public function hide(dialogID:String):Boolean {
			var dialog:Dialog = dialogs[dialogID];
			if (dialog) {
				if (dialog.parent) dialog.parent.removeChild(dialog);
				dialog.onHide();
				dialog.visible = false;
				alphaBlock.visible = false;
				blackBlock.visible = false;
				return true;
			}
			return false;
		}
		
		private function onDialogClose(e:Event):void 
		{
			var dialog:Dialog = e.target as Dialog;
			
			for each (var dlg:Dialog in dialogs) 
			{
				if (dlg.visible && dlg.block == dialog.block) return;
			}
			
			if(blocks[dialog.block]) blocks[dialog.block].visible = false;
		}
		
		public function closeAll():void {
			for each (var dialog:Dialog in dialogs) 
			{
				if (dialog.parent) dialog.parent.removeChild(dialog);
				dialog.visible = false;
			}
			
			alphaBlock.visible = false;
			blackBlock.visible = false;
		}
		
		public function DialogView() 
		{
			blackBlock = new Sprite();
			blackBlock.graphics.beginFill(0, 0.6);
			blackBlock.graphics.drawRect(-500, -200, 2100, 1600);
			blackBlock.graphics.endFill();
		
			alphaBlock = new Sprite();
			alphaBlock.graphics.beginFill(0, 0.001);
			alphaBlock.graphics.drawRect(-500, -200, 2100, 1110);
			alphaBlock.graphics.endFill();
			
			addChild(alphaBlock);
			addChild(blackBlock);
			
			blocks[Layer.BLOCK_BLACK] = blackBlock;
			blocks[Layer.BLOCK_ALPHA] = alphaBlock;
			
			setUp();
			closeAll();
		}

		public function showHint(dialogID:String):void
		{
			var dialog:Dialog = dialogs[dialogID];

			if (dialog) {
				dialog.showHint();
			}
		}
	}

}