package game.ui.components 
{
	import com.greensock.TweenMax;
	import core.display.animation.Animator;
	import core.display.BitmapEx;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.data.model.ConversationModel;
	import game.enum.Font;
	import game.Game;
	import game.ui.components.dynamicobject.ObjectDirection;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class CharacterDialogue extends MovieClip 
	{
		public static const COMPLETE:String = "character_dialog_complete";
		private static const ANIM_WIDTH	:int = 160;
		public var movAvatar			:MovieClip;
		public var movTextbg			:MovieClip;
		public var movLayerMask			:MovieClip;
		public var btnNextConversation	:SimpleButton;
		public var txtConversation		:TextField;
		
		private var animAvatar		:Animator;
		private var imgName			:BitmapEx;
		private var objData			:ConversationModel;
		private var callbackFunc	:Function;
		private var textIndex		:int;
		private var _currentString		:String;
		private var currentStringIndex	:int;
		private var enterFramCount		:int;
		private var direction			:int;
		private var finishDisplayText	:Boolean;
		private var content:String = "";
		private var words:Array = [];

		public function CharacterDialogue() {
			movTextbg.visible = false;
			textIndex = -1;
			setIsFinishConversation(false);
			FontUtil.setFont(txtConversation, Font.ARIAL);
			
			animAvatar = new Animator();
			animAvatar.addEventListener(Animator.LOADED, onAnimLoadedHdl);
			
			imgName = new BitmapEx();
			addChild(imgName);
			imgName.alpha = 0;
		}
		
		public function setData(value:ConversationModel):void {
			objData = value;
			if (objData) {
				direction = objData.direction;
				if (objData.nameURL.length > 0) {
					imgName.load(objData.nameURL);	
				}
				
				var animURL:String = objData.animURL;
				if (animURL && animURL.length > 0) {
					animAvatar.load(animURL);	
				} else {
					onTweenCompleteHdl();
				}
				
				if (objData.layerMask == 0) {
					movLayerMask.gotoAndStop(2);
				} else {
					movLayerMask.gotoAndStop(1);
				}
			}
		}
		
		public function setCallbackFunc(func:Function):void {
			callbackFunc = func;
		}
		
		private function setTxtConversation(string:String):void {
			txtConversation.htmlText = string;
			FontUtil.setFont(txtConversation, Font.ARIAL);
			txtConversation.y = movTextbg.y + (movTextbg.height - txtConversation.textHeight) / 2;
			finishDisplayText = true;
			if (animAvatar) {
				animAvatar.play(objData.animIndex, 0);
			}
		}
		
		private function appendTxtConversation(string:String):void {
			content += string + " ";
			txtConversation.htmlText = content;
			FontUtil.setFont(txtConversation, Font.ARIAL);
			txtConversation.y = movTextbg.y + (movTextbg.height - txtConversation.textHeight) / 2;
			finishDisplayText = false;
		}
		
		private function setTextIndex(value:int):void {
			textIndex = value;
			if (hasEventListener(Event.ENTER_FRAME)) {
				removeEventListener(Event.ENTER_FRAME, onEnterFrameHdl);
			}
			if (textIndex < objData.texts.length && objData.texts[textIndex] != null) {
				setTxtConversation(objData.texts[textIndex]);
			}
		}
		
		private function processNextConversation():void {
			if (objData.texts[textIndex + 1] != null) {
				currentString = objData.texts[textIndex + 1];
				currentStringIndex = 0;
				content = "";
				txtConversation.htmlText = "";
				FontUtil.setFont(txtConversation, Font.ARIAL);
				if (!hasEventListener(Event.ENTER_FRAME)) {
					setIsFinishConversation(false);
					addEventListener(Event.ENTER_FRAME, onEnterFrameHdl);	
				}
			} else {
				if (callbackFunc != null) {
					callbackFunc();
				}
			}
		}
		
		private function onAnimLoadedHdl(e:Event):void {
			movAvatar.addChild(animAvatar);
			animAvatar.play(objData.animIndex, 0);
			movAvatar.y = Game.HEIGHT / 2 + 75;
			switch(direction) {
				case ObjectDirection.LEFT:
					animAvatar.scaleX = 1;
					movAvatar.x = - ANIM_WIDTH;
					TweenMax.to(movAvatar, 0.5, { x:(txtConversation.x - ANIM_WIDTH), onComplete:onTweenCompleteHdl } );
					break;
					
				case ObjectDirection.RIGHT:
					animAvatar.scaleX = -1;
					movAvatar.x = Game.WIDTH + ANIM_WIDTH;
					TweenMax.to(movAvatar, 0.5, { x:(775 + ANIM_WIDTH), onComplete:onTweenCompleteHdl } );
					break;
			}
		}
		
		private function onTweenCompleteHdl():void {
			imgName.y = movAvatar.y;
			imgName.x = movAvatar.x - imgName.width / 2;
			TweenMax.to(imgName, 0.5, { alpha:1.0 } );
			movTextbg.visible = true;
			if (objData.texts[0] != null) {
				currentString = objData.texts[0];
				currentStringIndex = 0;
				addEventListener(Event.ENTER_FRAME, onEnterFrameHdl);
				addEventListener(MouseEvent.CLICK, onMouseClickHdl);
			}
		}
		
		private function onMouseClickHdl(e:MouseEvent):void {
			if (e.target == btnNextConversation) {
				processNextConversation();
			} else {
				if (!finishDisplayText) {
					setTextIndex(textIndex + 1);
					setIsFinishConversation(true);	
				}
			}
		}
		
		private function onEnterFrameHdl(e:Event):void {
			if (enterFramCount < 3) {
				enterFramCount ++;
			} else {
				if (currentStringIndex < words.length) {
					appendTxtConversation(words[currentStringIndex]);
					currentStringIndex ++;	
				} else {
					setIsFinishConversation(true);
					setTextIndex(textIndex + 1);
				}	
				enterFramCount = 0;
			}
		}
		
		private function setIsFinishConversation(value:Boolean):void {
			finishDisplayText = value;
			btnNextConversation.visible = finishDisplayText;
			if (value) {
				if (animAvatar) {
				animAvatar.play(objData.animIndex, 0);
				animAvatar.pause();
			}
			}
		}

		private function set currentString(value:String):void
		{
			_currentString = value;
			words = _currentString.split(" ");
		}

		private function get currentString():String
		{
			return	_currentString;
		}
	}

}