package game.ui.player_profile
{
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.enum.Font;
	import game.utility.GameUtil;
	
	import core.display.animation.Animator;
	import core.event.EventEx;
	
	import game.data.model.item.SoulItem;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;
	
	public class Soul extends MovieClip
	{
		public var animContainer:MovieClip;
		public var txtName:TextField;
		public var txtEffect:TextField;
		
		private var animator:Animator;
		private var data:SoulItem;
		
		public function Soul()
		{
			FontUtil.setFont(txtName, Font.TAHOMA, false);
			FontUtil.setFont(txtEffect, Font.TAHOMA, false);
			
			animator = new Animator();
			animContainer.addChild(animator);
			
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type: TooltipID.SOUL, value: data}, true));
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
		}
		
		public function setData(soul:SoulItem):void
		{
			data = soul;
			if(soul != null)
			{
				txtName.text = soul.soulXML.name;
				var effect:String = "";
				var bonusAttributes:Array = soul.soulXML.bonusAttributes;
				for (var i:int = 0; i < bonusAttributes.length; i++)
					effect += GameUtil.getBonusText(bonusAttributes[i],soul.level) + " ";
				txtEffect.text = effect;
				animator.load(soul.soulXML.animURL);
				animator.play(0);
			}
		}
	}
}