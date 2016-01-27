package game.ui.home 
{
	import core.display.animation.Animator;
	import core.event.EventEx;
	import core.util.TextFieldUtil;
	import core.util.Utility;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	import flash.utils.setInterval;
	
	import game.data.model.Character;
	import game.data.xml.CharacterXML;
	import game.enum.CharacterAnimation;
	import game.enum.Font;
	import game.ui.components.dynamicobject.DynamicObject;
	import game.ui.components.dynamicobject.DynamicObjectStatus;
	import game.ui.components.dynamicobject.ObjectDirection;
	import game.ui.home.scene.CharacterManager;
	import game.ui.ingame.CharacterObject;
	import game.utility.Ticker;

	/**
	 * ...
	 * @author anhtinh
	 */
	public class CharacterOutGame extends DynamicObject
	{
		public var movingArea : Rectangle;
		
		private var characterWrapper : Sprite = new Sprite();
		public var animator : Animator;
		private var dummy : Animator;
		private var xmlData:CharacterXML;
		private var elapsedTime : uint = 0;
		private var standingTime : uint = 1000;
		
		private var hitArea1 : Sprite;
		private var hitArea2 : Sprite;
		private var nameTf:TextField;
		public var character : Character;
		
		public static const REACH_TARGET:String = "reach_target";
		
		public function CharacterOutGame() 
		{
			this.movingArea = CharacterManager.CHARACTER_AREA;
			
			this.animator = new Animator();
			this.animator.addEventListener(Animator.LOADED, onAnimatorLoaded);
			this.characterWrapper.addChild(this.animator);
			
			this.addChild(characterWrapper);
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
			
			var glow : GlowFilter = new GlowFilter();
			glow.color = 0x003300;
			glow.strength = 10;
			glow.blurX = glow.blurY = 4;
			
			nameTf = TextFieldUtil.createTextfield(Font.ARIAL, 13, 120, 15, 0x00FF00, false, TextFormatAlign.CENTER, [glow]);
			nameTf.text = "Character";
			nameTf.x = -60;
			nameTf.y = -100;
			nameTf.mouseEnabled = false;
			this.addChild(nameTf);
		}
		
		/*public function setClickable() : void {
			
			var hitBmd:BitmapData = new BitmapData(50, 50, true, 0xff0000ff);
			var hitBm:Bitmap = new Bitmap(hitBmd);
			hitArea1 = new Sprite();
			hitArea1.x = -20;
			hitArea1.y = -70;
			
			var hitBmd2:BitmapData = new BitmapData(80, 90, true, 0xff0000ff);
			var hitBm2:Bitmap = new Bitmap(hitBmd2);
			hitArea2 = new Sprite();
			hitArea2.x = -40;
			hitArea2.y = -80;
			
			hitArea1.addChild(hitBm);
			hitArea2.addChild(hitBm2);
			
			this.hitArea = hitArea1;
			this.addChild(hitArea1);
			this.addChild(hitArea2);
			this.mask = hitArea2;
			
			this.buttonMode = true;
			
			this.mouseEnabled = true;
			this.mouseChildren = true;
			
			this.addEventListener(MouseEvent.CLICK, onCharacterClick);
		}*/
		
		private function onCharacterClick(e:MouseEvent):void 
		{
			Utility.log("onCharacterClick");
		}
		
		override public function set x(posX : Number) : void {
			
			if (movingArea) posX = Utility.math.clamp(posX, movingArea.x, movingArea.right);
			super.x = posX;
			
		}
		
		override public function set y(posY : Number) : void {
			
			if (movingArea) posY = Utility.math.clamp(posY, movingArea.y, movingArea.bottom);
			super.y = posY;
		}
		
		override public function update() : void {
			super.update();
			
			if (this.status == DynamicObjectStatus.STANDING && this.character && !this.character.isMainCharacter) {
				
				elapsedTime += Ticker.FRAME_TIME;
				
				if (elapsedTime >= standingTime) {
					this.moveToRandomPos();
					elapsedTime = 0;
				}
			}
		}
		
		public function setData(data:Character) : void {
			this.character = data;
			nameTf.text = data.name;
			
			if (data.isMainCharacter) {
				nameTf.visible = true;
			}else {
				nameTf.visible = false;
			}
			
			this.xmlData = data.xmlData;
			if (xmlData != null)
			{
				this.animator.load(xmlData.animURLs[data.sex]);
				//this.animator.play(0, 0);
				
				if (!this.animator.isLoaded()) {
					dummy = new Animator();
					dummy.load("resource/anim/character/dummy.banim");
					dummy.play(0, 0);
					this.characterWrapper.addChild(dummy);
					this.animator = dummy;
					dummy.alpha = 0.5;
				}
				
				this.status = DynamicObjectStatus.STANDING;
			}
		}
		
		
		private function onAnimatorLoaded(e:Event):void 
		{
			this.animator = e.target as Animator;
			
			if (dummy && dummy.parent) {
				this.characterWrapper.removeChild(dummy);
				dummy.reset();
				dummy = null;
			}
			
			this.status = status;
		}
		
		private function moveToRandomPos():void 
		{
			var posX : Number = Utility.math.random(CharacterManager.CHARACTER_AREA.x, 
															CharacterManager.CHARACTER_AREA.x + CharacterManager.CHARACTER_AREA.width);
			var posY : Number = Utility.math.random(CharacterManager.CHARACTER_AREA.y , 
								CharacterManager.CHARACTER_AREA.y + CharacterManager.CHARACTER_AREA.height);
								
			//this.moveTo(new Point(posX, posY), Utility.math.random(0,2) * 0.1);
			this.moveTo(new Point(posX, posY), 0);
		}
		
		public function changeAnimation(animationIndex : int) : void {
			if(this.animator != null) this.animator.play(animationIndex, -1);
		}
		
		override public function set direction(direction : int) : void {
			
			direction >= 1 ? super.direction = ObjectDirection.RIGHT : super.direction = ObjectDirection.LEFT;
			this.characterWrapper.scaleX = this.direction;
		}
		
		override public function set status(status : uint) : void {
			if (status != DynamicObjectStatus.STANDING && super.status == status) return;
			
			super.status = status;
			switch (status) 
			{
				case DynamicObjectStatus.STANDING:
					standingTime = Utility.math.random(1000, 8000);
					elapsedTime = 0;
					if (animator != null) {
						changeAnimation(CharacterAnimation.STAND);
					}
					break;
				case DynamicObjectStatus.WALKING:
					if (animator != null) {
						changeAnimation(CharacterAnimation.WALKING);
					}
					
					break;
				case DynamicObjectStatus.RUNNING:
					if (animator != null) {
						changeAnimation(CharacterAnimation.RUN);
					}
					
					break;
				default:
					changeAnimation(CharacterAnimation.STAND);
			}
		}
		
		override protected function onChangeSpeed(nSpeed:Number):void 
		{
			if (nSpeed > this.speed) {
				animator.setAnimationSpeed(this.speed / nSpeed);
			}else {
				animator.setAnimationSpeed(1);
			}
			
		}
		
		override protected function onReachTarget():void 
		{
			super.onReachTarget();
			dispatchEvent(new EventEx(REACH_TARGET, character, true));
		}
	}

}