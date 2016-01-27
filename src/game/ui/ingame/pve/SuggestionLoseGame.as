package game.ui.ingame.pve
{	
	import com.greensock.easing.Bounce;
	import com.greensock.TweenLite;
	import core.event.EventEx;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import game.data.xml.DataType;
	import game.data.xml.FeatureXML;
	import game.Game;
	import game.ui.components.GoToButton;
	
	public class SuggestionLoseGame extends MovieClip
	{	
		public static const GOTO_SUGGESTION	:String = "goto_suggestion";
		
		public var goiyMov1:MovieClip;
		public var goiyMov2:MovieClip;
		public var goiyMov3:MovieClip;
		public var goiyMov4:MovieClip;
		
		private var btn1:GoToButton;
		private var btn2:GoToButton;
		private var btn3:GoToButton;
		private var btn4:GoToButton;
		
		public function SuggestionLoseGame()
		{
			super();
			init();
		}
		
		public function init():void
		{
			btn1 = new GoToButton();
			btn2 = new GoToButton();
			btn3 = new GoToButton();
			btn4 = new GoToButton();
			
			btn1.x = 44;
			btn1.y = 313;
			btn2.x = 44;
			btn2.y = 313;
			btn3.x = 44;
			btn3.y = 313;
			btn4.x = 44;
			btn4.y = 313;
			
			btn1.addEventListener(MouseEvent.CLICK, btnClickHandler);
			btn2.addEventListener(MouseEvent.CLICK, btnClickHandler);
			btn3.addEventListener(MouseEvent.CLICK, btnClickHandler);
			btn4.addEventListener(MouseEvent.CLICK, btnClickHandler);

			if (goiyMov1 != null)
			{
				goiyMov1.addChild(btn1);
				goiyMov2.addChild(btn2);
				goiyMov3.addChild(btn3);
				goiyMov4.addChild(btn4);
			}
		}
		
		private function btnClickHandler(e:MouseEvent):void 
		{
			switch(e.currentTarget)
			{
				case btn1:
					dispatchEvent(new EventEx(GOTO_SUGGESTION,1));
					break;
				case btn2:
					dispatchEvent(new EventEx(GOTO_SUGGESTION,2));
					break;
				case btn3:
					dispatchEvent(new EventEx(GOTO_SUGGESTION,3));
					break;
				case btn4:
					dispatchEvent(new EventEx(GOTO_SUGGESTION,4));
					break;
			}
		}
		
		private function updateUI():void
		{
			visible = false;
			var dic:Dictionary = Game.database.gamedata.getTable(DataType.FEATURE) as Dictionary;
			if (Game.database.userdata.level <= 4)
				return;
			goiyMov3.visible = Game.database.userdata.level >= dic[7].levelRequirement;
			goiyMov2.visible = Game.database.userdata.level >= dic[9].levelRequirement;
			goiyMov4.visible = Game.database.userdata.level >= 10 || Game.database.userdata.getFinishTutorialIDs().indexOf(5) != -1;
			goiyMov1.visible = Game.database.userdata.level >= dic[11].levelRequirement;

			btn1.visible = Game.database.userdata.level >=8;
			btn2.visible = Game.database.userdata.level >=8;
			btn3.visible = Game.database.userdata.level >=8;
			btn4.visible = Game.database.userdata.level >=8;

			var x:int = 490;
			var y:int = 185;
			var mov:MovieClip;
			for (var i:int = 1; i < 5; i++)
			{
				mov = this["goiyMov" + i];
				if (mov.visible)
					x -= (228 + 10) / 2;
			}
			for (i = 1; i < 5; i++)
			{
				mov = this["goiyMov" + i];
				if (mov.visible)
				{
					mov.x = x;
					mov.y = y;
					x += (228 + 10);
					visible = true;
				}
			}
		}
		
		public function show():void
		{
			this.y = -400;
			TweenLite.to(this, 1, { y : 0, ease:Bounce.easeOut } );
			updateUI();
		}
	}
}