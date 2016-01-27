package game.ui.create_character
{
	import core.display.BitmapEx;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.setTimeout;
	
	import core.Manager;
	import core.display.ViewBase;
	import core.display.animation.Animator;
	import core.event.EventEx;
	import core.util.Enum;
	import core.util.FontUtil;
	import core.util.TextCheckUtils;
	import core.util.Utility;
	
	import game.Game;
	import game.data.vo.flashvar.FlashVar;
	import game.enum.Element;
	import game.enum.Font;
	import game.enum.GameConfigID;
	import game.net.lobby.request.RequestLoginPacket;
	import game.utility.Ticker;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class CreateCharacterView extends ViewBase
	{
		public var classViews:Array;
		public var infoMov:MovieClip;
		public var movEffect:MovieClip;
		public var txtResult:TextField;
		public var containerAvatarClasses:MovieClip;
		public var containerCharacter:MovieClip;
		public var description:MovieClip;
		public var containerThanhNT7:MovieClip;
		
		private var glow:GlowFilter;
		private var _effectGlow:GlowFilter;
		private var avatarClasses:Array;
//		private var characterAnim:Animator;
		private var avatarImage:BitmapEx;
		private var currentClass:AvatarClass;
		private var thanhNT7:ThanhNT7;
		
		public function CreateCharacterView()
		{
			avatarClasses = [];
			var avatarClass:AvatarClass;
			for (var i:int = 0; i < 5; ++i)
			{
				avatarClass = new AvatarClass();
				avatarClass.y = i * 96;
				avatarClass.setElement(Enum.getEnum(Element, i + 1) as Element);
				avatarClass.addEventListener(MouseEvent.CLICK, avatarClass_onClicked);
				avatarClass.addEventListener(AvatarClass.GENDER_CHANGED, avatarClass_onGenderChanged);
				containerAvatarClasses.addChild(avatarClass);
				avatarClasses.push(avatarClass);
			}
			
			txtName.maxChars = 16;
			txtName.text = "";
			FontUtil.setFont(txtName, Font.ARIAL, true);
			
//			characterAnim = new Animator();
//			containerCharacter.addChild(characterAnim);

			avatarImage = new BitmapEx();
			avatarImage.addEventListener(BitmapEx.LOADED, avatarImageLoadedHdl)
			containerCharacter.addChild(avatarImage);

			containerCharacter.gotoAndStop(1);
			containerCharacter.mouseChildren = false;
			containerCharacter.mouseEnabled = false;
			
			thanhNT7 = new ThanhNT7();
			containerThanhNT7.addChild(thanhNT7);
			
			AvatarClass(avatarClasses[0]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			
			
			
			/*classViews = [];
			   var classView:CreateCharacterClassView;
			   var mainCharacterIDs:Array = Game.database.gamedata.getConfigData(GameConfigID.MAIN_CHARACTER_IDS) as Array;
			
			   if (!mainCharacterIDs) return;
			   for (var i:int = 0; i < 5; i++) {
			   classView = new CreateCharacterClassView(i + 1);
			   classView.addEventListener(CreateCharacterClassView.SELECTED, onClassSelected);
			   if (mainCharacterIDs[i] != null) {
			   classView.mainCharacterID = mainCharacterIDs[i];
			   }
			   classViews.push(classView);
			   addChild(classView);
			   }
			
			   glow = new GlowFilter(0xffff00, 1, 5, 5, 4, 100);
			   _effectGlow = new GlowFilter(0xffffff, 1, 6, 6, 2, 150);
			
			   infoMov.visible = false;
			   btnCreate.buttonMode = true;
			   FontUtil.setFont(txtName, Font.ARIAL);
			   FontUtil.setFont(txtResult, Font.ARIAL);
			   movEffect.visible = false;
			   movEffect.mouseEnabled = false;
			   movEffect.mouseChildren = false;
			
			 */
			initHandlers();
		
			reseTextResult();
		}

		private function avatarImageLoadedHdl(event:Event):void
		{
			avatarImage.x = - avatarImage.width/2;
			avatarImage.y = - avatarImage.height;
		}
		
		protected function avatarClass_onGenderChanged(event:Event):void
		{
			var avatarClass:AvatarClass = event.currentTarget as AvatarClass;
//			containerCharacter.gotoAndStop(5*avatarClass.getGender() + avatarClass.getElement().ID);
			avatarImage.reset();
			avatarImage.load(avatarClass.getElement().avatarURLs[avatarClass.getGender()]);
		}
		
		protected function avatarClass_onClicked(event:MouseEvent):void
		{
			var avatarClass:AvatarClass = event.currentTarget as AvatarClass;
			for each (var o:AvatarClass in avatarClasses)
			{
				if (o == avatarClass)
				{
					if (o.isSelected() == false)
					{
						o.setSelected(true);
//						containerCharacter.gotoAndStop(5*avatarClass.getGender() + avatarClass.getElement().ID);
						avatarImage.reset();
						avatarImage.load(avatarClass.getElement().avatarURLs[avatarClass.getGender()]);
						description.gotoAndStop(avatarClass.getElement().ID);
						thanhNT7.setElement(avatarClass.getElement());
					}
					currentClass = avatarClass;
				}
				else
				{
					o.setSelected(false);
				}
			}
		
		}
		
		private function initHandlers():void
		{
			btnCreate.buttonMode = true;
			btnCreate.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHdl);
		}
		
		private function onKeyDownHdl(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
				case Keyboard.ENTER: 
					processNameEnter();
					break;
			}
		}
		
		private function onBtnClickHdl(e:MouseEvent):void
		{
			processNameEnter();
			if (stage)
			{
				stage.focus = txtName;
			}
		}
		
		private function processNameEnter():void
		{
			var error:String = preChecName();
			if(error == null)
			{
				if (currentClass != null)
				{
					var createCharacterConfig:Array = Game.database.gamedata.getConfigData(GameConfigID.MAIN_CHARACTER_IDS);
					var flashVar:FlashVar = Game.database.flashVar;
					Game.network.lobby.sendPacket(new RequestLoginPacket(Game.database.userdata.accountName, txtName.text, createCharacterConfig[currentClass.getElement().ID - 1], currentClass.getGender(),flashVar.pid,flashVar.time,flashVar.key, parseInt(flashVar.server), flashVar.channel));
				}
			} else
			{
				txtResult.text = error;
				setTimeout(reseTextResult, 4000);
			}
		}
		
		private function preChecName():String 
		{
			var name:String = txtName.text;
			Utility.log("name : "+name);
			if (TextCheckUtils.checkAllSpace(name))
			{
				return "Bạn chưa đặt tên Nhân vật!";
			}
			
			if (TextCheckUtils.checkArrayMatch_1(name))
			{
				return "Tên Nhân vật có ký tự không được phép!";
			}

			var arrFilter:Array = Manager.resource.getResourceByURL("resource/txt/sensitive_words_createcharacter.txt");
			for each(var val:String in arrFilter)
			{
				if (name.indexOf(val) != -1 && val != "")
				{
					return "Tên Nhân vật có vài từ không được phép dùng!";
				}
			}
			
			return null;
		}
		
		private function onBtnOutHdl(e:MouseEvent):void
		{
			btnCreate.filters = [];
		}
		
		private function onBtnHoverHdl(e:MouseEvent):void
		{
			btnCreate.filters = [glow];
		}
		
		private function get btnCreate():MovieClip
		{
			return infoMov.btnCreate;
		}
		
		private function get txtName():TextField
		{
			return infoMov.txtName;
		}
		
		private function onClassSelected(e:EventEx):void
		{
		/*var target:CreateCharacterClassView = e.target as CreateCharacterClassView;
		
		   if (target) {
		   MovieClipUtils.starHueAdjust(movEffect, UtilityUI.getElementColor(target.element));
		   if (!movEffect.visible) {
		   movEffect.visible = true;
		   }
		   _effectGlow.color = UtilityUI.getElementGlow(target.element);
		   movEffect.filters = [_effectGlow];
		   addChild(movEffect);
		   movEffect.x = target.x - (movEffect.width - target.width) / 2;
		   movEffect.y = target.desY + target.height - 320;
		
		   MovieClipUtils.adjustBrightness(target, 1);
		   }
		
		   if (e.data) {
		   _selectedSex = e.data._sex as int;
		   _selectedClass = e.data._class as int;
		   Utility.log("selected class: " + _selectedClass);
		   var _element:int = e.data._element as int;
		
		   var classView:CreateCharacterClassView;
		   for (var i:int = 0; i < classViews.length; i++) {
		   classView = classViews[i];
		   if (classView && (classView.element != _element)) {
		   MovieClipUtils.adjustBrightness(classView, 0.4);
		   classView.unSelect();
		   }
		   }
		   }
		
		   if (!infoMov.visible) {
		   infoMov.alpha = 0;
		   infoMov.visible = true;
		   TweenMax.to(infoMov, 0.5, { alpha:1 } );
		   }
		
		   if (stage) {
		   stage.focus = txtName;
		 }*/
		}
		
		private function reseTextResult():void
		{
			txtResult.text = "Nhập tên không quá " + txtName.maxChars + " ký tự";
			FontUtil.setFont(txtResult, Font.ARIAL);
		}
		
		public function set checkNameResult(value:Boolean):void
		{
			if (!value)
			{
				txtResult.text = "";
			}
			else
			{
				txtResult.text = "Tên Nhân vật trùng hoặc không hợp lệ. Bạn hãy chọn tên khác hén!";
				setTimeout(reseTextResult, 4000);
			}
		}
		
		override protected function transitionInComplete():void
		{
			super.transitionInComplete();
			Ticker.getInstance().addEnterFrameFunction(update);
		/*var classView:CreateCharacterClassView;
		   for (var i:int = 0; i < classViews.length; i++) {
		   classView = classViews[i];
		   classView.onTransIn();
		 }*/
		}
		
		override protected function transitionOutComplete():void
		{
			Ticker.getInstance().removeEnterFrameFunction(update);
			avatarImage.removeEventListener(BitmapEx.LOADED, avatarImageLoadedHdl);
			avatarImage.reset();
			super.transitionOutComplete();
		}
		
		public function update():void
		{
			thanhNT7.update();
		}
	
	}

}