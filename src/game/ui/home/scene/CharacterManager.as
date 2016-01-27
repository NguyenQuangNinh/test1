package game.ui.home.scene
{
	import com.greensock.TweenMax;
	import components.KeyUtils;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import game.ui.components.dynamicobject.DynamicObjectStatus;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import core.Manager;
	import core.display.animation.Animator;
	import core.util.Utility;
	
	import game.Game;
	import game.data.model.Character;
	import game.ui.components.dynamicobject.DynamicObject;
	import game.ui.components.dynamicobject.ObjectDirection;
	import game.ui.home.CharacterOutGame;
	import game.ui.home.SceneLayer;
	import game.ui.home.gui.CharacterLayer;
	import game.utility.Ticker;
	
	/**
	 * ...
	 * @author anhtinh
	 */
	public class CharacterManager
	{
		
		public static const CHARACTER_AREA:Rectangle = new Rectangle(130, 460, 2260, 130);
		static public const MAX_CHARACTER_NUM:int = 20;
		
		private var sceneLayer:SceneLayer
		private var characterLayer:CharacterLayer;
		private var characters:Array;
		private var mainCharacter:CharacterOutGame;
		private var mouseClick:Animator;
		
		private static var _instance:CharacterManager;
		
		private var _isInit:Boolean;
		
		private var _isMouseDown:Boolean = false;
		private var mouseClickId:uint;
		private var isKeyRegistered:Boolean;
		
		public function CharacterManager()
		{
			mouseClick = new Animator();
			mouseClick.load("resource/anim/effect/muiten.banim");
			mouseClick.scaleX = mouseClick.scaleY = 0.5;
			//mouseClick.y = -50;
			mouseClick.visible = false;					
		}
		
		public static function get instance():CharacterManager
		{
			if (_instance == null)
				_instance = new CharacterManager();
			return _instance;
		}
		
		public function init(sceneLayer:SceneLayer):void
		{
			
			if (_isInit)
			{
				return;
			}
			else
			{
				this.sceneLayer = sceneLayer;
				this.characterLayer = sceneLayer.characterLayer;
				this.sceneLayer.addChild(mouseClick);
				characters = [];
				
				_isInit = true;
				
				//Ticker.getInstance().addEnterTickFunction(update);
				Ticker.getInstance().addEnterFrameFunction(update);
			}
			//move main character
			this.sceneLayer.bgNearLayer.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.sceneLayer.addEventListener(CharacterOutGame.REACH_TARGET, onReachTargetHdl);
		}
		
		private function onMouseDown(e:MouseEvent = null):void 		
		{
			Game.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_isMouseDown = true;
			//Utility.log("set mouse down " + _isMouseDown);
			
			var desPos:Point = getCurrentPointClick();
			mouseClick.x = desPos.x;
			mouseClick.y = desPos.y + 1.5 * mouseClick.height;
			//Utility.log("mouse add at pos: " + mouseClick.x + " // " + mouseClick.y);
			mouseClick.visible = true;
			mouseClick.play(0, 0);
				
			//onMouseUp(null);
		}
		
		private function onReachTargetHdl(e:Event):void 
		{
			/*if (_isMouseDown) {
				var mainPos:Point = new Point(mainCharacter.x, mainCharacter.y);
				var targetPoint:Point = new Point(Manager.display.getMouseX() + sceneLayer.x, Manager.display.getMouseY() + sceneLayer.y);
				if (mainPos.x != targetPoint.x || mainPos.y != targetPoint.y)
					mainCharacter.updateTargetPoint(targetPoint);
				return;	
			}*/
			//Utility.log("main character reach target set");	
			//var mainPos:Point = new Point(mainCharacter.x, mainCharacter.y);
			//var desPos:Point = getCurrentPointClick();
			//_isMouseDown = _isMouseDown && (mainPos.x != desPos.x || mainPos.y != desPos.y);
			if (!_isMouseDown) mouseClick.visible = false;
		}
		
		private function onMouseUp(e:MouseEvent = null):void
		{			
			Game.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_isMouseDown = false;			
			//Utility.log("set mouse down " + _isMouseDown);
			if (mainCharacter != null)
			{			
				var desPos:Point = getCurrentPointClick();
				mainCharacter.moveTo(desPos, 0.25, true);
				//clearTimeout(mouseClickId);
				//mouseClickId = setTimeout(hideMouseClick, 1000);
			}
		}
		
		private function hideMouseClick():void 
		{
			mouseClick.visible = false;
		}
		
		private function getCurrentPointClick():Point {
			var desPos:Point = new Point(Manager.display.getMouseX(), Manager.display.getMouseY());
			desPos.x = desPos.x/Manager.display.getContainer().scaleX - sceneLayer.x;
			desPos.y = desPos.y/Manager.display.getContainer().scaleY - sceneLayer.y;
			//var desPos:Point = new Point(Manager.display.getMouseX() + sceneLayer.x,
											//Manager.display.getMouseY() + sceneLayer.y);
			desPos.x = Utility.math.clamp(desPos.x, CHARACTER_AREA.x, CHARACTER_AREA.x + CHARACTER_AREA.width);
			desPos.y = Utility.math.clamp(desPos.y, CHARACTER_AREA.y, CHARACTER_AREA.y + CHARACTER_AREA.height);
			//Utility.log("des pos set to main character is: " + desPos.x + " // " + desPos.y);
			return desPos;
		}
		
		private function moveViewPort(desPos:Point):void
		{
			//if (mainCharacterOnView()) 
			var dis:Number = Game.WIDTH / 2 - (desPos.x);
			this.sceneLayer.moveToX(dis);
		}
		
		private function mainCharacterOnView():Boolean
		{
			if (mainCharacter == null)
			{
				Utility.error("@@@ Main Character has not inited yet");
				return false;
			}
			var mainCharacterOnGlobalPos:Point = this.sceneLayer.characterLayer.localToGlobal(new Point(mainCharacter.x, mainCharacter.y));
			return (mainCharacterOnGlobalPos.x > 10 && mainCharacterOnGlobalPos.x < Game.WIDTH - 10);
		}
		
		public function createCharacter(character:Character):CharacterOutGame
		{
			var characterObj:CharacterOutGame = Manager.pool.pop(CharacterOutGame) as CharacterOutGame;
			characterObj.setData(character.clone());
			
			if (character.isMainCharacter)
			{
				mainCharacter = characterObj;
				
				//mainCharacter.addChild(mouseClick);
				
				mainCharacter.addEventListener(DynamicObject.MOVING, onMainCharacterMoving);
				characterObj.direction = ObjectDirection.RIGHT;
				characterLayer.addCharacter(characterObj, 190, 445);
			}
			else
			{
				
				if (Math.random() > 0.5)
				{
					characterObj.direction = ObjectDirection.RIGHT;
				}
				else
				{
					characterObj.direction = ObjectDirection.LEFT;
				}
				characterLayer.addCharacter(characterObj, Utility.math.random(CHARACTER_AREA.x, CHARACTER_AREA.x + CHARACTER_AREA.width), Utility.math.random(CHARACTER_AREA.y, CHARACTER_AREA.y + CHARACTER_AREA.height));
			}
			
			characters.push(characterObj);
			
			return characterObj;
		}
		
		private function onMainCharacterMoving(e:Event):void
		{
			checkMoveViewPort();
		}
		
		private function checkMoveViewPort():void
		{
			if (mainCharacter == null)
			{
				Utility.error("@@@ Main Character has not inited yet");
				return;
			}
			var x:int = mainCharacter.x >= Game.WIDTH/2 ? mainCharacter.x - sceneLayer.x : mainCharacter.x;
			
			if (x < Game.WIDTH/2 || x > (Game.WIDTH - 300))
			{
				moveViewPort(new Point(mainCharacter.x, 0));
			}
		}
		
		private function getCharacterStagePos(charater:CharacterOutGame):Point
		{
			return this.sceneLayer.characterLayer.localToGlobal(new Point(charater.x, charater.y));
		}
		
		public function update():void
		{
			for each (var character:CharacterOutGame in characters)
			{
				character.update();
				characterLayer.updateCharacterDepth(character);
			}
			
			if (_isMouseDown) {
				if (mainCharacter == null)
				{
					Utility.error("@@@ Main Character has not inited yet");
					return;
				}			
				var mainPos:Point = new Point(mainCharacter.x, mainCharacter.y);
				var desPos:Point = getCurrentPointClick();
				if (mainPos.x != desPos.x || mainPos.y != desPos.y) {
					/*
					if(mainCharacter.status == DynamicObjectStatus.STANDING)
						mainCharacter.moveTo(desPos, 0.25, true);
					else
						mainCharacter.updateTargetPoint(desPos);
						*/
						mainCharacter.moveTo(desPos, 0.25, true);
				}
				
				desPos = getCurrentPointClick();
				mouseClick.x = desPos.x;
				mouseClick.y = desPos.y + 1.5 * mouseClick.height;
			}
			
			//if (isKeyRegistered) onKeyHdl();
		}
		
		public function showAllCharacter():void
		{
			removeAllCharacter();
			//Ticker.getInstance().addEnterTickFunction(update);
			Ticker.getInstance().addEnterFrameFunction(update);
			
			var characterDatas:Array = Game.database.userdata.characters;
			var count:int = 0;
			for (var i:int = 0; i < characterDatas.length; i++)
			{
				var character:Character = characterDatas[i] as Character;
				// cao nhan an danh ko co anim nen ko hien ngoai home
				if (!character.isMystical())
				{
					CharacterManager.instance.createCharacter(character);
					count++;
					if (count >= MAX_CHARACTER_NUM) break;
				}
				else
				{
					//trace("@@@ Cao nhan an danh index : " + i + " --- ID : " + character.ID);
				}
			}
			
			checkMoveViewPort();
		}
		
		public function removeAllCharacter():void
		{
			
			//Ticker.getInstance().removeEnterTickFunction(update);
			Ticker.getInstance().removeEnterFrameFunction(update);
			
			if (characters == null || characters.length == 0)
				return;
			
			for (var j:int = 0; j < characters.length; j++)
			{
				CharacterOutGame(characters[j]).parent.removeChild(characters[j]);
				Manager.pool.push(characters[j]);
			}
			characters = [];
		}
		
		private function removeCharacter(characterOutGame:CharacterOutGame):void
		{
			if (characterOutGame.parent)
				characterOutGame.parent.removeChild(characterOutGame);
			Manager.pool.push(characterOutGame);
			characters.splice(characters.indexOf(characterOutGame), 1);
		
		}
		
		private function haveCharacterOnHome(ID:int):Boolean
		{
			for each (var characterOutGame:CharacterOutGame in characters)
			{
				if (characterOutGame.character.ID == ID)
				{
					return true;
				}
				
			}
			return false;
		}
		
		public function updateCharatersOnHome():void
		{
			
			if (characters == null || characters.length == 0)
				return;
			var curCharacters:Array = Game.database.userdata.characters;
			
			for each (var characterOutGame:CharacterOutGame in characters)
			{
				if (!Game.database.userdata.haveCharacter(characterOutGame.character.ID))
				{
					removeCharacter(characterOutGame);
				}
				
			}
			
			for each (var curCharacter:Character in curCharacters)
			{
				if ((!haveCharacterOnHome(curCharacter.ID)) && (!curCharacter.isMystical()))
				{
					CharacterManager.instance.createCharacter(curCharacter);
				}
			}
		}
		
		//This method run faster but not test finish
		
		/*public function updateCharatersOnHome() : void {
		   //characters : DS cac CharacterOutGame dang o trang Home
		   if (characters == null || characters.length == 0) return ;
		   var curCharacters : Array = Game.database.userdata.characters;
		
		   //add index
		   var addIndexs : Array = [];
		   for (var k:int = 0; k < curCharacters.length; k++)
		   {
		   addIndexs.push(true);
		   }
		
		   var characterOutGame: CharacterOutGame;
		   var curCharacter: Character;
		   var isRemove: Boolean ;
		   for (var i:int = 0; i < characters.length; i++)
		   {
		   characterOutGame = characters[i];
		   isRemove = true;
		   for (var j:int = 0; j < curCharacters.length; j++)
		   {
		   curCharacter = curCharacters[j];
		   if (characterOutGame.character.ID == curCharacter.ID) {
		   addIndexs[j] = false;
		   isRemove = false
		   break;
		   }
		   }
		
		   if (isRemove) {
		   if(CharacterOutGame(characters[i]).parent) CharacterOutGame(characters[i]).parent.removeChild(characters[i]);
		   Manager.pool.push(characters[i]);
		   characters.splice(i, 1);
		   i--;
		   }
		   }
		
		   for (var m:int = 0; m < addIndexs.length; m++)
		   {
		   if (addIndexs[m]) {
		   if ( ! Character(curCharacters[m]).isMystical())
		   CharacterManager.instance.createCharacter(curCharacters[m]);
		   }
		   }
		 }*/
		
		public function displayCharacters():void
		{
			
			if (characterLayer != null)
			{
				characterLayer.alpha = 0;
				characterLayer.visible = true;
				TweenMax.to(characterLayer, 0.8, {alpha: 1});
				//Ticker.getInstance().addEnterTickFunction(update);
				Ticker.getInstance().addEnterFrameFunction(update);
				
				checkMoveViewPort();
			}
		}
		
		public function hideCharacters():void
		{
			if (characterLayer != null)
			{
				
				TweenMax.to(characterLayer, 0.5, {alpha: 0, onComplete: function():void
					{
						characterLayer.visible = false
					}});
				//Ticker.getInstance().removeEnterTickFunction(update);
				Ticker.getInstance().removeEnterFrameFunction(update);
			}
		}
		
		private function onKeyHdl():void 
		{
			if (!mainCharacter) return;
			var disX:Number = 30;
			var disY:Number = 20;
			var v:Point = new Point();
			
			if (KeyUtils.isDown(Keyboard.UP)) v.y = - disY;
			if (KeyUtils.isDown(Keyboard.DOWN)) v.y = disY;
			if (KeyUtils.isDown(Keyboard.LEFT )) v.x = - disX;
			if (KeyUtils.isDown(Keyboard.RIGHT)) v.x = disX;
			if (v.x == 0 && v.y == 0) return;
			v.x += mainCharacter.x;
			v.y += mainCharacter.y;
			mainCharacter.moveTo(v, 0.25, true);
		}
		
		public function registerKeyEvents():void
		{
			isKeyRegistered = true;
		}
		
		public function unregisterKeyEvents():void
		{
			isKeyRegistered = false;
		}
	}

}