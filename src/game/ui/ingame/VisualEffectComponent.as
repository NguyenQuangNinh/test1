package game.ui.ingame 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import core.Manager;
	import core.display.animation.Animator;
	import core.display.animation.PixmaData;
	
	import game.Game;
	import game.data.xml.DataType;
	import game.data.xml.VisualEffectComponentXML;
	
	/**
	 * ...
	 * @author bangnd2
	 */
	public class VisualEffectComponent extends EventDispatcher
	{
		private var animators:Array;
		private var completeCount:int;
		private var xmlData:VisualEffectComponentXML;
		
		public function VisualEffectComponent() 
		{
			animators = [];
			reset();
		}
		
		public function reset():void
		{
			var i:int;
			var length:int;
			var animator:Animator;
			for (i = 0, length = animators.length; i < length; ++i)
			{
				animator = animators[i];
				if (animator != null)
				{
					animator.reset();
					animator.removeEventListener(Event.COMPLETE, onAnimatorComplete);
					Manager.pool.push(animator);
				}
			}
			animators.splice(0);
			completeCount = 0;
		}
		
		public function destroy():void
		{
			reset();
			animators = null;
		}
		
		public function getAnimatorLayer(index:int):int
		{
			var layer:int = 0;
			if (xmlData != null) layer = xmlData.layers[index];
			return layer;
		}
		
		private function onAnimatorComplete(e:Event):void 
		{
			if (++completeCount == animators.length) dispatchEvent(new Event(Event.COMPLETE, true));
		}
		
		public function play():void
		{
			var i:int;
			var length:int;
			var animator:Animator;
			for (i = 0, length = animators.length; i < length; ++i)
			{
				animator = animators[i];
				if (animator != null) animator.resume();
			}
			completeCount = 0;
		}
		
		public function setXmlID(ID:int):void
		{
			reset();
			xmlData = Game.database.gamedata.getData(DataType.VISUAL_EFFECT_COMPONENT, ID) as VisualEffectComponentXML;
			if (xmlData != null)
			{
				var i:int;
				var length:int;
				var animator:Animator;
				for (i = 0, length = xmlData.indexes.length; i < length; ++i)
				{
					animator = Manager.pool.pop(Animator) as Animator;
					animator.load(xmlData.animURL);
					animator.y = xmlData.offsetY;
					animator.play(xmlData.indexes[i], xmlData.repeats[i]);
					animator.pause();
					animator.visible = false;
					animator.addEventListener(Event.COMPLETE, onAnimatorComplete);
					animators.push(animator);
				}
			}
		}
		
		public function getAnimators():Array { return animators; }
		public function getXMLData():VisualEffectComponentXML { return xmlData; }
	}
}