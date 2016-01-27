package game.ui.tutorial.scenes 
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Circ;

	import flash.display.SimpleButton;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.utils.setTimeout;
	
	import core.Manager;
	import core.display.animation.Animator;
	import core.event.EventEx;
	
	import game.Game;
	import game.data.xml.BackgroundXML;
	import game.data.xml.DataType;
	import game.enum.CharacterAnimation;
	import game.ui.ModuleID;
	import game.ui.ingame.BackgroundLayer;
	import game.ui.tutorial.TutorialEvent;
	import game.utility.UtilityUI;

	/**
	 * ...
	 * @author MaiPTT
	 */
	public class TutorialScene1 extends BaseScene 
	{
		private static const GROUND_ZERO		:int = 500;
		private static const ENEMY_DELAY_APPEAR	:int = 3500;
		private static const STAND				:int = 0;
		private static const RUN				:int = 1;
		private static const HIT				:int = 2;
		private static const CRY				:int = 3;
		private static const EMO_1				:int = 4;
		private static const EMO_2				:int = 5;
		
		private var animMyChar		:Animator;
		private var animEnemy		:Animator;
		private var animEmoticon	:Animator;
		private var animQT			:Animator;
		private var animHD			:Animator;
		private var moon			:Animator;
		private var containerBackgrounds:Sprite;
		private var backgroundLayers:Array;
		private var skipBtn:SimpleButton;

		public function TutorialScene1() {
			super(1);
			sceneName = "Khoi tao nhan vat chinh";

			init();
		}

		private function skipHdl(event:MouseEvent):void
		{
			onEndOfScene1();
		}
		
		override protected function init():void {
			super.init();
			containerBackgrounds = new Sprite();
			addChild(containerBackgrounds);
			if (Game.database.userdata.getFinishTutorialIDs().length == 0) {
				loadResourceAnimator();
			}
		}
		
		override public function start():void 
		{
			super.start();
			Game.logService.requestTracking("1_001", "start TutorialScene1");
			backgroundLayers = [];
			var backgroundXML:BackgroundXML = Game.database.gamedata.getData(DataType.BACKGROUND, 13) as BackgroundXML;
			if (backgroundXML) {
				for each (var layerID:int in backgroundXML.layerIDs) {
					var backgroundLayer:BackgroundLayer = new BackgroundLayer();
					backgroundLayer.setXMLID(layerID);
					containerBackgrounds.addChild(backgroundLayer);
					backgroundLayers.push(backgroundLayer);
				}
			}

			skipBtn = UtilityUI.getComponent(UtilityUI.SKIP_BTN) as SimpleButton;
			if(skipBtn)
			{
				skipBtn.x = Game.WIDTH - skipBtn.width;
				skipBtn.y = 0;
				skipBtn.addEventListener(MouseEvent.CLICK, skipHdl);
				Manager.display.getContainer().addChildAt(skipBtn ,Manager.display.getContainer().numChildren);
			}

			beginIntro();
		}
		//Step 1: cot truyen
		private function beginIntro():void
		{
			conversation(0, onCharactersAppear);
			Game.logService.requestTracking("1_002", "play anim opening complete");
		}
		
		//Step 2: nhan vat chinh di ra giua va chem gio voi Au Duong Phong
		private function onCharactersAppear():void {
			animMyChar.scaleX = -1;
			animMyChar.x = - animMyChar.width;
			animMyChar.y = GROUND_ZERO;

			animEnemy.scaleX = -1;
			animEnemy.x = 700;
			animEnemy.y = GROUND_ZERO;

			Game.logService.requestTracking("1_003", "conversation complete: 0");
			setTimeout(function onRunObj():void {
				animMyChar.play(CharacterAnimation.RUN);
				TweenMax.to(animMyChar, 2.0, { x:500, onComplete:conversation, onCompleteParams:[1, shootMoon] } );
			}, 500);
		}
		
		//Step 3: NV chinh rut sung ra ban lam vo mat trang, Tay Doc lui xa may met
		private function shootMoon():void {
			setTimeout(function():void {//anim shoot
				animMyChar.play(2,1);
			},100);

			setTimeout(function():void {//anim no
				moon.play(1,1);
			},1500);

			setTimeout(function():void {// Tay Doc hoang so lui xa
				animEnemy.play(CharacterAnimation.KNOCKBACK,1);
				TweenMax.to(animEnemy, 1.0, { x:1024, onComplete:function():void{
					animEnemy.play(CharacterAnimation.STAND);
					//DVL day bi kip cho Tay Doc
					conversation(2, teachTayDocComplete);
				}
				});
			},1600);
		}
		
		//Step 4: Sau khi chi tuyet chieu Quay Tay cho Tay Doc
		private function teachTayDocComplete():void {
			moon.reset();
			removeChild(moon);

			animEnemy.scaleX = 1;
			animEnemy.play(CharacterAnimation.RUN);
			TweenMax.to(animEnemy, 1, {x:Game.WIDTH + animEnemy.width, onComplete:function():void {
				animMyChar.x = -animMyChar.width;
				conversation(3, DVLRunToMidScreen);
			}});

			Game.logService.requestTracking("1_005", "conversation complete: 2");
		}
		
		//Step 5: DVL Chay ra giua man hinh
		private function DVLRunToMidScreen():void {
			setTimeout(function onRunObj():void {
				animMyChar.play(CharacterAnimation.RUN);
				TweenMax.to(animMyChar, 2.0, { x:600, onComplete:TayDocHitDVL} );
			}, 500);
		}

		//Step 6: Tay Doc dam vao mat DVL
		private function TayDocHitDVL():void {
			animEnemy.scaleX = -1;
			animEnemy.play(CharacterAnimation.RUN);
			TweenMax.to(animEnemy, 0.3, {x:animMyChar.x+animMyChar.width, onComplete:function():void{
				animEnemy.play(CharacterAnimation.MELEE_ATTACK,1);
				animEnemy.addEventListener(Event.COMPLETE, LMSHitFinish);

				animMyChar.x -= 50;
				animMyChar.play(3,1); //Nv te xuong hoang so
				animMyChar.addEventListener(Event.COMPLETE, DVLFallComplete);
			}});
		}

		private function DVLFallComplete(event:Event):void
		{
			setTimeout(function():void {
				conversation(4,QTHDHitTayDoc);
			}, 500);
		}
		
		//Step 7: LMS hit character va duong qua bay ra do don
		private function QTHDHitTayDoc():void {
			
			animQT.play(CharacterAnimation.MELEE_ATTACK, 1);
			animQT.addEventListener(Event.COMPLETE, DQHitFinish);
			animQT.x = -200;
			animQT.y = GROUND_ZERO;
			var blurFilter:BlurFilter = new BlurFilter(40, 0, 1);			
			animQT.filters = [blurFilter];
			
			animHD.play(CharacterAnimation.RUN);
			animHD.x = -250;
			animHD.y = GROUND_ZERO;
			new TweenLite(animHD, 0.6, { x:400, onComplete:TLNAppearFinish} );
			
			var timeline:TimelineLite = new TimelineLite();
			timeline.append( new TweenLite(animQT, 0.3, {x:animEnemy.x, ease:Circ.easeOut, blurFilter:{blurX:0}}) );
			timeline.append( new TweenLite(animEnemy, 1, { x:1000, ease:Circ.easeOut, onComplete:conversation, onCompleteParams:[5, DQTLNRunToBattle] } ) );
			
			Game.logService.requestTracking("1_006", "conversation complete: 3");
		}
		
		//Step 8: DQ TLN chay vao battle
		private function DQTLNRunToBattle():void {
			animHD.play(CharacterAnimation.RUN);
			animQT.play(CharacterAnimation.RUN);
			new TweenLite(animHD, 0.8, { x:660 } );
			new TweenLite(animQT, 0.8, { x:700, onComplete:onStartTutorialIngame } );
		}
		
		//Step 9: chuyen vao Ingame dap nhau voi LMS
		private function onStartTutorialIngame():void {
			Game.logService.requestTracking("1_007", "start game tutorial");
			Manager.tutorial.tutorialIngame.start();
		}
		
		//Step 10: LMS thua tran nhung van chem gio
		override protected function onTutorialEventHdl(e:EventEx):void {
			if (Manager.tutorial.getCurrentTutorialID() != sceneID) {
				return;
			}
			
			switch(e.data.type) {
				case TutorialEvent.OPENING_TUTORIAL_END_GAME:
					animQT.play(CharacterAnimation.STAND);
					animHD.play(CharacterAnimation.STAND);
					conversation(6, LMSRunAway);
					Game.logService.requestTracking("1_201", "conversation complete: 5");
					break;
			}
		}
		
		//Step 11: LMS bo chay
		private function LMSRunAway():void {
			animEnemy.play(CharacterAnimation.RUN);
			animEnemy.scaleX = 1;
			new TweenLite(animEnemy, 1.5, { x:1400, onComplete:endStartGameStory} )
		}
		
		//Step 12: nhan vat chinh doi thoai voi DQ TLN
		private function endStartGameStory():void {
			animQT.scaleX = -1;
			animHD.scaleX = -1;
			conversation(7, onEndOfScene1);
			Game.logService.requestTracking("1_202", "conversation complete: 6");
		}
		
		//Step 13: chuyen qua tao nhan vat
		private function onEndOfScene1():void {
			setTimeout(function endOfScene():void {
				Manager.display.getContainer().removeChild(skipBtn);
				Manager.display.hideModule(ModuleID.TUTORIAL);
				Manager.display.to(ModuleID.CREATE_CHARACTER);	
				
				Game.logService.requestTracking("1_203", "end tutorial, to create character");
			}, 1000);
		}
		
		private function TLNAppearFinish():void {
			animHD.play(CharacterAnimation.STAND);
		}		
		
		private function conversation(convID:int, functionCallBack:Function):void {
			setConversation(convID, functionCallBack);
			if (convID == 1 || convID == 3) {
				animMyChar.play(CharacterAnimation.STAND);
			}
			if (convID == 5) {
				animQT.play(CharacterAnimation.STAND);
				animHD.play(CharacterAnimation.STAND);
			}
		}		
		
		private function loadResourceAnimator():void {
			animMyChar = new Animator();
			animMyChar.setCacheEnabled(false);
			animMyChar.addEventListener(Animator.LOADED, onAnimLoadedHdl);
			animMyChar.load("resource/anim/character/nv_bian.banim");
			addChild(animMyChar);
			
			animEnemy = new Animator();
			animEnemy.setCacheEnabled(false);
			animEnemy.addEventListener(Animator.LOADED, onAnimLoadedHdl);
			animEnemy.load("resource/anim/character/unique_auduongphong.banim");
			addChild(animEnemy);
			
			animEmoticon = new Animator();
			animEmoticon.setCacheEnabled(false);
			animEmoticon.addEventListener(Animator.LOADED, onAnimLoadedHdl);
			animEmoticon.load("resource/anim/character/nv_bian.banim");
			addChild(animEmoticon);
			
			animQT = new Animator();
			animQT.setCacheEnabled(false);
			animQT.addEventListener(Animator.LOADED, onAnimLoadedHdl);
			animQT.load("resource/anim/character/unique_quachtinh.banim");
			addChild(animQT);
			
			animHD = new Animator();
			animHD.setCacheEnabled(false);
			animHD.addEventListener(Animator.LOADED, onAnimLoadedHdl);
			animHD.load("resource/anim/character/unique_hoangdung.banim");
			addChild(animHD);

			moon = new Animator();
			moon.setCacheEnabled(false);
			moon.addEventListener(Animator.LOADED, onAnimLoadedHdl);
			moon.load("resource/tutorial/moon.banim");
			addChild(moon);
		}
		
		private function DQHitFinish(e:Event):void 
		{
			animQT.removeEventListener(Event.COMPLETE, DQHitFinish);
			animQT.play(CharacterAnimation.STAND);
		}
		
		private function LMSHitFinish(e:Event):void 
		{
			animEnemy.removeEventListener(Event.COMPLETE, LMSHitFinish);
			animEnemy.play(CharacterAnimation.STAND);
		}
		
		private function onAnimLoadedHdl(e:Event):void {
			var animator:Animator = e.target as Animator;
			switch(animator) {
				case animMyChar:
				case animEnemy:
					animator.play(CharacterAnimation.STAND);		
					break;
					
				case animEmoticon:
					animator.visible = false;
					break;
				case moon:
					animator.play(0);
					animator.x = 900;
					animator.y = 80;
					break;
			}
		}
	}

}