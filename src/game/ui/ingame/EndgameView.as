package game.ui.ingame
{
	import com.greensock.TweenMax;
	import core.Manager;
	import core.display.animation.Animator;
	import core.display.layer.LayerManager;
	import core.event.EventEx;
	import game.data.gamemode.ModeDataPVEHeroic;
	import game.enum.Direction;
	import game.ui.ingame.pve.SuggestionLoseGame;
	import game.ui.tutorial.TutorialEvent;
	import game.utility.GameUtil;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.setTimeout;

	import core.Manager;
	import core.display.animation.Animator;
	import core.display.layer.LayerManager;
	import core.event.EventEx;

	import game.Game;
	import game.data.gamemode.ModeData;
	import game.data.gamemode.ModeDataPVEHeroic;
	import game.data.gamemode.ModeDataPvE;
	import game.data.gamemode.ModeDataPvP;
	import game.enum.GameMode;
	import game.ui.ModuleID;
	import game.ui.tutorial.TutorialEvent;

	//import game.net.IntRequestPacket;
	//import game.net.lobby.LobbyRequestType;

	/**
	 * ...
	 * @author MaiPTT
	 */
	public class EndgameView extends Sprite
	{
		private static const NFLAG:int = 0;

		private static const PARTICLE:int = 0;
		private static const FLAG:int = 1;

		private static const APPEAR:int = 0;
		private static const LOOP:int = 1;
		private static const DISAPPEAR:int = 2;

		private var animFlagWin:Animator;
		private var animFlagLose:Animator;
		private var animStars:Animator;
		private var animPlayAgain:Animator;
		private var animContinue:Animator;
		private var animComeback:Animator;
		private var endGameState:int;
		private var eventDispatchEnable:Boolean;
		private var initialized:Boolean;
		private var suggestionLoseGame:SuggestionLoseGame;
		public static const END_GAME_REQUEST:String = "endGameRequest";
		public static const PLAY_AGAIN:int = 100;
		public static const PLAY_CONTINUE:int = 101;

		public function EndgameView()
		{
			eventDispatchEnable = true;
			initAnim();
		}

		public function initAnim():void
		{
			animFlagWin = new Animator();
			animFlagWin.setCacheEnabled(false);
			animFlagWin.load("resource/anim/ui/chien_thang.banim");
			animFlagWin.x = 650;
			animFlagWin.y = 325;
			animFlagWin.stop();
			animFlagWin.visible = false;
			animFlagWin.mouseChildren = false;
			animFlagWin.mouseEnabled = false;
			animFlagWin.addEventListener(Event.COMPLETE, onAnimEndgameComplete);
			addChild(animFlagWin);

			animFlagLose = new Animator();
			animFlagLose.setCacheEnabled(false);
			animFlagLose.load("resource/anim/ui/that_bai.banim");
			animFlagLose.x = 650;
			animFlagLose.y = 325;
			animFlagLose.stop();
			animFlagLose.visible = false;
			animFlagLose.mouseEnabled = false;
			animFlagLose.mouseChildren = false;
			animFlagLose.addEventListener(Event.COMPLETE, onAnimEndgameComplete);
			addChild(animFlagLose);

			animStars = new Animator();
			animStars.setCacheEnabled(false);
			animStars.load("resource/anim/ui/lenh_bai.banim");
			animStars.stop();
			animStars.x = 650;
			animStars.y = 365;
			animStars.addEventListener(Event.COMPLETE, onAnimStarComplete);
			animStars.visible = false;
			animStars.mouseChildren = false;
			animStars.mouseEnabled = false;
			addChild(animStars);

			suggestionLoseGame = new SuggestionLoseGame();
			suggestionLoseGame.addEventListener(SuggestionLoseGame.GOTO_SUGGESTION, onGotoSuggestionHdl);
			suggestionLoseGame.visible = false;
			addChild(suggestionLoseGame);

			animPlayAgain = new Animator();
			animPlayAgain.setCacheEnabled(false);
			animPlayAgain.load("resource/anim/ui/choi_lai.banim");
			animPlayAgain.addEventListener(Event.COMPLETE, onAnimDrumCompleteHdl);
			animPlayAgain.addEventListener(MouseEvent.MOUSE_DOWN, onBtnClickHdl);
			animPlayAgain.addEventListener(MouseEvent.ROLL_OVER, onBtnHoverHdl);
			animPlayAgain.addEventListener(MouseEvent.ROLL_OUT, onBtnOutHdl);
			animPlayAgain.x = 208;
			animPlayAgain.y = 575;
			animPlayAgain.stop();
			animPlayAgain.visible = false;
			addChild(animPlayAgain);
			animPlayAgain.buttonMode = true;

			animContinue = new Animator();
			animContinue.setCacheEnabled(false);
			animContinue.load("resource/anim/ui/choi_tiep.banim");
			animContinue.addEventListener(Event.COMPLETE, onAnimDrumCompleteHdl);
			animContinue.addEventListener(MouseEvent.MOUSE_DOWN, onBtnClickHdl);
			animContinue.addEventListener(MouseEvent.ROLL_OVER, onBtnHoverHdl);
			animContinue.addEventListener(MouseEvent.ROLL_OUT, onBtnOutHdl);
			animContinue.x = 1049;
			animContinue.y = 575;
			animContinue.stop();
			animContinue.visible = false;
			addChild(animContinue);
			animContinue.buttonMode = true;
			initialized = true;
			animComeback = new Animator();
			animComeback.setCacheEnabled(false);
			animComeback.load("resource/anim/ui/quay_lai.banim");
			animComeback.addEventListener(Event.COMPLETE, onAnimDrumCompleteHdl);
			animComeback.addEventListener(MouseEvent.MOUSE_DOWN, onBtnClickHdl);
			animComeback.addEventListener(MouseEvent.ROLL_OVER, onBtnHoverHdl);
			animComeback.addEventListener(MouseEvent.ROLL_OUT, onBtnOutHdl);
			animComeback.x = 1049;
			animComeback.y = 575;
			animComeback.stop();
			animComeback.visible = false;
			animComeback.scaleX = -1;
			addChild(animComeback);
			animComeback.buttonMode = true;
		}

		private function onAnimStarComplete(event:Event):void
		{

		}

		public function isInit():Boolean { return initialized; }

		private function onAnimDrumCompleteHdl(e:Event):void
		{
//			var anim:Animator = e.target as Animator;
//			if (anim) {
//				var currentAnimIndex:int = anim.getCurrentAnimation();
//				if ((currentAnimIndex % 4) == 0) {
//					if (Game.database.userdata.globalBossData.autoPlay
//							&& (Game.database.userdata.getGameMode() == GameMode.PVE_GLOBAL_BOSS)) {
//						endGameState = PLAY_CONTINUE;
//						processTransOut();
//					} else {
//						anim.play(currentAnimIndex + 1, -1);
//					}
//				} else if ((currentAnimIndex % 4) == 3) {
//					if (eventDispatchEnable) {
//						dispatchEvent(new EventEx(END_GAME_REQUEST, endGameState));
//					}
//					eventDispatchEnable = false;
//				}
//			}
		}

		private function onBtnClickHdl(e:MouseEvent):void
		{
			var anim:Animator = e.currentTarget as Animator;
			if (!anim) return;
			anim.removeEventListener(MouseEvent.ROLL_OVER, onBtnHoverHdl);
			anim.removeEventListener(MouseEvent.ROLL_OUT, onBtnOutHdl);
			switch (anim)
			{
				case animComeback:
				case animContinue:
					processTransOut(PLAY_CONTINUE);
					break;

				case animPlayAgain:
					processTransOut(PLAY_AGAIN);
					break;
			}

		}

		private function onBtnOutHdl(e:MouseEvent):void
		{

		}

		private function onBtnHoverHdl(e:MouseEvent):void
		{

		}

		private function processTransOut(state:int = PLAY_CONTINUE):void
		{
			endGameState = state;

			animTransOut();

			setTimeout(function ():void
			{
				dispatchEvent(new EventEx(END_GAME_REQUEST, endGameState));
			}, 500);
		}

		private function onAnimEndgameComplete(e:Event):void
		{
			var anim:Animator = e.target as Animator;
			if (anim)
			{
				anim.play(1, -1);
			}
		}

		public function reset():void
		{
			if (initialized == false) return;

			animContinue.stop();
			animContinue.visible = false;
			animFlagLose.stop();
			animFlagLose.visible = false;
			animFlagWin.stop();
			animFlagWin.visible = false;

			animComeback.stop();
			animComeback.visible = false;
			suggestionLoseGame.visible = false;

			animPlayAgain.stop();
			animPlayAgain.visible = false;
			animStars.stop();
			animStars.visible = false;

			if (!animPlayAgain.hasEventListener(MouseEvent.ROLL_OVER))
			{
				animPlayAgain.addEventListener(MouseEvent.ROLL_OVER, onBtnHoverHdl);
			}
			if (!animPlayAgain.hasEventListener(MouseEvent.ROLL_OUT))
			{
				animPlayAgain.addEventListener(MouseEvent.ROLL_OUT, onBtnOutHdl);
			}
			if (!animContinue.hasEventListener(MouseEvent.ROLL_OVER))
			{
				animContinue.addEventListener(MouseEvent.ROLL_OVER, onBtnHoverHdl);
			}
			if (!animContinue.hasEventListener(MouseEvent.ROLL_OUT))
			{
				animContinue.addEventListener(MouseEvent.ROLL_OUT, onBtnOutHdl);
			}
			if (!animComeback.hasEventListener(MouseEvent.ROLL_OVER))
			{
				animComeback.addEventListener(MouseEvent.ROLL_OVER, onBtnHoverHdl);
			}
			if (!animComeback.hasEventListener(MouseEvent.ROLL_OUT))
			{
				animComeback.addEventListener(MouseEvent.ROLL_OUT, onBtnOutHdl);
			}

			setIsHost(true);
		}

		public function animTransOut():void
		{
			var modeData:ModeData = Game.database.userdata.getCurrentModeData();
			switch (modeData.result)
			{
				case true:
					animFlagWin.play(NFLAG, 1, 0, false, true);
					animPlayAgain.visible = false;
					animContinue.visible = false;
					var numStars:int = modeData is ModeDataPvE ? (modeData as ModeDataPvE).numStars : 0;
					if (numStars > 0)
					{
						animStars.play(numStars - 1, 1, 0, false, true);
					}
					break;
				case false:
					animFlagLose.play(NFLAG, 1, 0, false, true);
					animPlayAgain.visible = false;
					animComeback.visible = false;
					break;
			}

		}

		public function processTransIn(gamemode:GameMode):void
		{
			var modeData:ModeData = Game.database.userdata.getCurrentModeData();
			if (modeData is ModeDataPvE)
			{
				var numStars:int = ModeDataPvE(modeData).numStars;
				var backModule:ModuleID = modeData.backModuleID;
				switch (modeData.result)
				{
					case true:
						animFlagWin.visible = true;
						animFlagWin.play(NFLAG, 1);
						animStars.visible = true;
						if (numStars > 0)
						{
							animStars.play(numStars - 1, 1, 1);
						}
						break;

					case false:
						animFlagLose.visible = true;
						animFlagLose.play(NFLAG, 1);
						setTimeout(showSuggestionState, 2000);
						break;
				}

				if (backModule == ModuleID.SHOP)
				{
					setTimeout(processTransOut, 2000);
				}
			}
			else if (modeData is ModeDataPvP)
			{
				switch (modeData.result)
				{
					case true:
						animFlagWin.visible = true;
						animFlagWin.play(NFLAG, 1);
						break;

					case false:
						animFlagLose.visible = true;
						animFlagLose.play(NFLAG, 1);
						break;
				}
				//animPlayAgain.visible = true;
				//animPlayAgain.play(0, 1, 3.0);
				eventDispatchEnable = true;	//hot fix --> need to change later
				animPlayAgain.visible = false;
			}
		}

		public function showReplayBtn():void
		{
			eventDispatchEnable = true;
			if (Game.database.userdata.getGameMode() == GameMode.PVE_WORLD_CAMPAIGN)
			{
				/*var backModuleID:ModuleID = ModeDataPvE(Game.database.userdata.getCurrentModeData()).backModuleID;
				 switch(backModuleID) {
				 case ModuleID.SHOP:
				 case ModuleID.GLOBAL_BOSS:
				 case ModuleID.HEROIC_TOWER:
				 break;

				 default:
				 break;
				 }*/
				animPlayAgain.visible = true;
				animPlayAgain.play(0);
			}
			else if (Game.database.userdata.getGameMode() == GameMode.PVE_HEROIC)
			{
				setIsHost(ModeDataPVEHeroic(Game.database.userdata.getModeData(GameMode.PVE_HEROIC)).isHost);
			}
			animContinue.visible = true;
			animContinue.play(0);
			dispatchEvent(new EventEx(TutorialEvent.EVENT, {type: TutorialEvent.END_GAME}, true));
		}

		public function showSuggestionState():void
		{
			eventDispatchEnable = true;
			if (Game.database.userdata.getGameMode() == GameMode.PVE_WORLD_CAMPAIGN)
			{
				var backModuleID:ModuleID = ModeDataPvE(Game.database.userdata.getCurrentModeData()).backModuleID;
				switch (backModuleID)
				{
					case ModuleID.SHOP:
					case ModuleID.GLOBAL_BOSS:
					case ModuleID.HEROIC_TOWER:
						break;

					default:
						animFlagLose.visible = true;
						suggestionLoseGame.show();
						break;
				}
			}
			else if (Game.database.userdata.getGameMode() == GameMode.PVE_HEROIC)
			{
				suggestionLoseGame.show();
				setIsHost(ModeDataPVEHeroic(Game.database.userdata.getModeData(GameMode.PVE_HEROIC)).isHost);
			}

			animComeback.visible = true;
			animComeback.play(0);

			if (Game.database.userdata.globalBossData.autoPlay
					&& (Game.database.userdata.getGameMode() == GameMode.PVE_GLOBAL_BOSS))
			{
				processTransOut(PLAY_CONTINUE);
			}
			dispatchEvent(new EventEx(TutorialEvent.EVENT, {type: TutorialEvent.END_GAME}, true));
		}

		private function setIsHost(value:Boolean):void
		{
			if (value)
			{
				TweenMax.to(animContinue, 0, {colorMatrixFilter: {saturation: 1.0}});
				TweenMax.to(animPlayAgain, 0, {colorMatrixFilter: {saturation: 1.0}});
				if (!animPlayAgain.hasEventListener(MouseEvent.MOUSE_DOWN))
				{
					animPlayAgain.addEventListener(MouseEvent.MOUSE_DOWN, onBtnClickHdl);
				}
				if (!animContinue.hasEventListener(MouseEvent.MOUSE_DOWN))
				{
					animContinue.addEventListener(MouseEvent.MOUSE_DOWN, onBtnClickHdl);
				}
				animPlayAgain.buttonMode = true;
				animContinue.buttonMode = true;
			}
			else
			{
				TweenMax.to(animContinue, 0, {colorMatrixFilter: {saturation: 0.0}});
				TweenMax.to(animPlayAgain, 0, {colorMatrixFilter: {saturation: 0.0}});
				if (animPlayAgain.hasEventListener(MouseEvent.MOUSE_DOWN))
				{
					animPlayAgain.removeEventListener(MouseEvent.MOUSE_DOWN, onBtnClickHdl);
				}
				if (animContinue.hasEventListener(MouseEvent.MOUSE_DOWN))
				{
					animContinue.removeEventListener(MouseEvent.MOUSE_DOWN, onBtnClickHdl);
				}
				animPlayAgain.buttonMode = false;
				animContinue.buttonMode = false;
			}
		}


		private function onGotoSuggestionHdl(e:EventEx):void
		{
			animComeback.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
			setTimeout(moveToSuggestionSimple, 1000, e.data);
		}

		private function moveToSuggestionSimple(index:int):void
		{
			switch (index)
			{
				case 1:
					GameUtil.moveToSuggestionSimple(0, ModuleID.CHANGE_FORMATION);
					break;
				case 2:
					GameUtil.moveToSuggestionSimple(0, ModuleID.CHARACTER_ENHANCEMENT, {tap: 0});
					break;
				case 3:
					GameUtil.moveToSuggestionSimple(0, ModuleID.SOUL_CENTER);
					break;
				case 4:
					GameUtil.moveToSuggestionSimple(0, ModuleID.CHARACTER_ENHANCEMENT, {tap: 2});
					break;

			}
		}

		//TUTORIAL
		public function showHintButton(content:String):void
		{
			if (animComeback.visible)
			{
				Game.hint.showHint(animComeback, Direction.DOWN, animComeback.x + animComeback.width / 2 - 106, animComeback.y - 52, content);
			}
			else if (animPlayAgain.visible)
			{
				Game.hint.showHint(animPlayAgain, Direction.DOWN, animPlayAgain.x + animPlayAgain.width / 2 - 106, animPlayAgain.y - 52, content);
			}
			else if (animContinue.visible)
			{
				Game.hint.showHint(animContinue, Direction.DOWN, animContinue.x + animContinue.width / 2 - 106, animContinue.y - 52, content);
			}
		}
	}

}