package game.ui.ingame 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import core.Manager;
	import core.display.animation.Animator;
	import core.util.Utility;
	
	import game.Game;
	import game.data.xml.DataType;
	import game.data.xml.VisualEffectXML;
	import game.enum.TeamID;

	/**
	 * ...
	 * @author bangnd2
	 */
	public class VisualEffect extends BaseObject
	{
		private var xmlData:VisualEffectXML;
		private var compositions:Array;
		private var currentCompIndex:int;
		private var duration:Number;
		private var currentDuration:Number;
		private var boundingBox:Sprite;
		
		public function VisualEffect() 
		{
			compositions = [];
			reset();
		}
		
		override public function reset():void
		{
			super.reset();
			
			var i:int;
			var length:int;
			var composition:VisualEffectComponent;
			for (i = 0, length = compositions.length; i < length; ++i)
			{
				composition = compositions[i];
				if (composition != null)
				{
					composition.reset();
					composition.removeEventListener(Event.COMPLETE, onCompositionComplete);
					Manager.pool.push(composition);
				}
			}
			compositions.splice(0);
			currentCompIndex = -1;
			duration = 0;
			currentDuration = 0;
		}
		
		public function destroy():void
		{
			reset();
			compositions = null;
		}
		
		public function lastComponent():void
		{
			clear();
			if (currentCompIndex != compositions.length - 1)
			{
				currentCompIndex = compositions.length - 1;
				playCurrentComponent();
			}
			else
			{
				isDead = true;
			}
		}
		
		private function playCurrentComponent():void
		{
			var composition:VisualEffectComponent = compositions[currentCompIndex];
			if (composition != null)
			{
				var i:int;
				var length:int;
				var animator:Animator;
				var animators:Array = composition.getAnimators();
				for (i = 0, length = animators.length; i < length; ++i)
				{
					animator = animators[i];
					if (animator != null)
					{
						animator.resume();
						animator.visible = true;
					}
				}
			}

			currentDuration = duration;
		}
		
		private function clear():void
		{
			var composition:VisualEffectComponent = compositions[currentCompIndex];
			if (composition != null)
			{
				var i:int;
				var length:int;
				var animator:Animator;
				var animators:Array = composition.getAnimators();
				for (i = 0, length = animators.length; i < length; ++i)
				{
					animator = animators[i];
					if (animator != null)
					{
						animator.pause();
						animator.visible = false;
					}
				}
			}
		}
		
		public function nextComponent():void
		{
			clear();
			if (currentCompIndex != compositions.length - 1)
			{
				++currentCompIndex;
				playCurrentComponent();
			}
			else
			{
				isDead = true;
			}
		}
		
		override public function update(delta:Number):void 
		{
			if(paused) return;
			
			if (currentVelocity != 0) x += currentVelocity * delta;
			var composition:VisualEffectComponent = compositions[currentCompIndex];
			if (composition != null)
			{
				var animators:Array = composition.getAnimators();
				var i:int;
				var length:int;
				var animator:Animator;
				for (i = 0, length = animators.length; i < length; ++i)
				{
					animator = animators[i];
					if (animator != null)
					{
						switch(teamID)
						{
							case TeamID.LEFT:
								animator.x = x + (xmlData.width >> 1);
								break;
							case TeamID.RIGHT:
								animator.x = x + xmlData.width;
								break;
						}
						animator.y = y + composition.getXMLData().offsetY;
					}
				}
			}
			if (duration > 0)
			{
				currentDuration -= delta;
				if (currentDuration < 0)
				{
					duration = 0;
					nextComponent();
				}
			}
		}
		
		private function onCompositionComplete(event:Event):void
		{
			var composition:VisualEffectComponent = event.target as VisualEffectComponent;
			var index:int = compositions.indexOf(composition);
			if (index == compositions.length - 1)
			{
				isDead = true;
			}
			else
			{
				nextComponent();
			}
		}
		
		public function setXmlID(ID:int):void
		{
			xmlData = Game.database.gamedata.getData(DataType.VISUAL_EFFECT, ID) as VisualEffectXML;
			if (xmlData)
			{
				var i:int;
				var length:int;
				var composition:VisualEffectComponent;
				for (i = 0, length = xmlData.compositionIDs.length; i < length; ++i)
				{
					composition = Manager.pool.pop(VisualEffectComponent) as VisualEffectComponent;
					composition.setXmlID(xmlData.compositionIDs[i]);
					composition.addEventListener(Event.COMPLETE, onCompositionComplete);
					compositions[i] = composition;
				}
			}
			else
			{
				Utility.error("Undefined visual effect ID " + ID);
			}
		}
		
		override public function setTeamID(teamID:int):void
		{
			var i:int;
			var length:int;
			var composition:VisualEffectComponent;
			for (i = 0, length = xmlData.compositionIDs.length; i < length; ++i)
			{
				composition = compositions[i];
				if (composition != null)
				{
					var animators:Array = composition.getAnimators();
					var index:int;
					var total:int;
					var animator:Animator;
					for (index = 0, total = animators.length; index < total; ++index)
					{
						animator = animators[index];
						if (animator != null)
						{
							switch(teamID)
							{
								case TeamID.LEFT:
									animator.scaleX = 1;
									break;
								case TeamID.RIGHT:
									animator.scaleX = -1;
									break;
							}
						}
					}
				}
			}
		}
		
		public function getXmlData():VisualEffectXML { return xmlData; }
		
		public function getCompositions():Array { return compositions; }
		
		public function start():void
		{
			if (compositions.length > 0)
			{
				clear();
				currentCompIndex = 0;
				playCurrentComponent();
			}
		}
		
		public function setDuration(duration:Number):void
		{
			this.duration = duration;
		}
		
		override public function pause():void
		{
			var composition:VisualEffectComponent = compositions[currentCompIndex];
			if (composition != null)
			{
				var i:int;
				var length:int;
				var animator:Animator;
				var animators:Array = composition.getAnimators();
				for (i = 0, length = animators.length; i < length; ++i)
				{
					animator = animators[i];
					if (animator != null)
					{
						animator.pause();
					}
				}
			}
			super.pause();
		}
		
		override public function resume():void
		{
			var composition:VisualEffectComponent = compositions[currentCompIndex];
			if (composition != null)
			{
				var i:int;
				var length:int;
				var animator:Animator;
				var animators:Array = composition.getAnimators();
				for (i = 0, length = animators.length; i < length; ++i)
				{
					animator = animators[i];
					if (animator != null)
					{
						animator.resume();
					}
				}
			}
			super.resume();
		}
	}

}