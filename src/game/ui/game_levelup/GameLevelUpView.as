package game.ui.game_levelup
{
	import core.display.animation.Animator;
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.Manager;
	import flash.events.Event;
	import flash.utils.setTimeout;
	import game.Game;
	import game.ui.game_levelup.gui.UnlockInfo;
	import game.ui.home.HomeModule;
	import game.ui.hud.HUDModule;
	import game.ui.ModuleID;
	import game.ui.tutorial.TutorialEvent;
	
	/**
	 * ...
	 * @author anhtinh
	 */
	public class GameLevelUpView extends ViewBase
	{
		private const NUMBER0:int = 17;
		private const EMPTY:int = 29;

		private var levelUpAnim:Animator;
		
		private var arrUnlockInfo:Array = [];
		
		private var level:int;
		
		private var unlockContentList:Array = [];
		
		private var pos:int = 0;
		
		public function GameLevelUpView()
		{
			initAnim();
		}
		
		private function initAnim():void
		{
			levelUpAnim = new Animator();
			levelUpAnim.setCacheEnabled(false);
			levelUpAnim.x = 650;
			levelUpAnim.y = 325;
			levelUpAnim.load("resource/anim/ui/level_up.banim");
			levelUpAnim.stop();
			levelUpAnim.visible = false;
			levelUpAnim.addEventListener(Event.COMPLETE, levelUpCompleteHandler);
			addChild(levelUpAnim);
			
			for (var i:int = 0; i < 15; i++)
			{
				var unlockInfo:UnlockInfo = new UnlockInfo();
				unlockInfo.x = 600;
				unlockInfo.y = 400 + i * 70;
				arrUnlockInfo.push(unlockInfo);
				this.addChild(unlockInfo);
			}
			
			this.addEventListener(UnlockInfo.SHOW_UNLOCK_COMPLETE, onUnlockInfoComplete);
		
		}

		private function levelUpCompleteHandler(event:Event):void
		{
			levelUpAnim.stop();
			levelUpAnim.visible = false;
			Manager.display.hideModule(ModuleID.GAME_LEVEL_UP);
		}
		
		private function onUnlockInfoComplete(e:Event):void
		{
			pos++;
			if (pos == this.unlockContentList.length || pos == this.arrUnlockInfo.length)
			{
				setTimeout(hideEffect, 200);
			}
		}
		
		private function hideEffect():void
		{
			//
			//hide effect
			if (this.unlockContentList.length < arrUnlockInfo.length)
			{
				var unlockInfo:UnlockInfo = arrUnlockInfo[this.unlockContentList.length];
				if (unlockInfo)
					unlockInfo.hideEffect();
			}
			
			var homeModule:HomeModule = Manager.module.getModuleByID(ModuleID.HOME) as HomeModule;
			if (homeModule)
			{
				homeModule.updateNPCDisplay();
			}
			
			/*var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
			if (hudModule)
			{
				hudModule.updateHUDButton();
			}*/
		}
		
		/**
		 * Play effect lên cấp
		 * @param	level
		 */
		public function playLevelUp(level:int, unlockContentList:Array):void
		{
			//reset
			for (var i:int = 0; i < this.unlockContentList.length && i < arrUnlockInfo.length; i++)
			{
				this.removeChild(arrUnlockInfo[i]);
			}
			
			Game.mouseEnable = false;
			this.pos = 0;
			this.level = level;
			this.unlockContentList = unlockContentList;
			
			var c:int = level % 10;
			level = (level - c) / 10;
			var b:int = level % 10;
			level = (level - b) / 10;
			var a:int = level % 10;

			var srcIDs:Array = [NUMBER0, NUMBER0 + 1, NUMBER0 + 2];
			var desIDs:Array;
			if(this.level < 10)
			{
				desIDs = [NUMBER0 + c, EMPTY, EMPTY];
			}
			else if(this.level < 100)
			{
				desIDs = [NUMBER0 + b, NUMBER0 + c, EMPTY];
			}
			else
			{
				desIDs = [NUMBER0 + a, NUMBER0 + b, NUMBER0 + c];
			}

			levelUpAnim.replaceModules(srcIDs, desIDs);
			
			//init effect
			for (i = 0; i < unlockContentList.length && i < arrUnlockInfo.length; i++)
			{
				var unlockInfo:UnlockInfo = arrUnlockInfo[i];
				if (unlockInfo)
				{
					unlockInfo.initEffect(unlockContentList[i]);
					this.addChild(unlockInfo);
				}
			}
			
			setTimeout(showEffect, 1000);
		}
		
		private function showEffect():void
		{
			Game.mouseEnable = true;
			levelUpAnim.play(0, 1);
			levelUpAnim.visible = true;

			if(unlockContentList.length == 0) setTimeout(hideEffect, 700);

			//play effect
			for (var i:int = 0; i < unlockContentList.length && i < arrUnlockInfo.length; i++)
			{
				var unlockInfo:UnlockInfo = arrUnlockInfo[i];
				if (unlockInfo)
					unlockInfo.playEffect();
			}
		}
		
		public function reset():void
		{
			
			levelUpAnim.stop();
			levelUpAnim.visible = false;

			//reset effect
			for (var i:int = 0; i < arrUnlockInfo.length; i++)
			{
				var unlockInfo:UnlockInfo = arrUnlockInfo[i];
				if (unlockInfo)
					unlockInfo.reset();
			}
		}
		
		override public function transitionOut():void {
			dispatchEvent(new EventEx(TutorialEvent.EVENT, { type:TutorialEvent.LEVEL_UP }, true));
			super.transitionOut();
		}
	}

}