package game.ui.ingame 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import core.display.animation.Animator;
	import core.display.pixmafont.PixmaText;
	
	import game.enum.TeamID;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class DamageText extends Sprite 
	{
		public static const COMPLETE	:String = "damage_text_play_complete";
		private var teamLeftPixmaText		:PixmaText;
		private var teamRightPixmaText		:PixmaText;
		private var ptHealHp				:PixmaText;
		private var anim					:Animator;
		
		public function DamageText() {
			anim = new Animator();
			anim.setCacheEnabled(false);
			anim.load("resource/anim/ui/skill_text.banim");
			anim.stop();
			addChild(anim);
			
			teamLeftPixmaText = new PixmaText();
			
			teamRightPixmaText = new PixmaText();
			//teamRightPixmaText.loadFont("resource/anim/font/font_item_name_cyan.banim");
			
			ptHealHp = new PixmaText();
		}
		
		public function reset():void {
			
		}
		
		public function playDodgeEffect():void {
			anim.addEventListener(Event.COMPLETE, onAnimPlayCompleteHdl);
			anim.play(5, 1);
		}
		
		public function setText(value:String, critical:Boolean, teamID:int):void {
			var bitmapData:BitmapData;
			var nVal:int = parseInt(value);
			if (nVal < 0)
			{
				teamLeftPixmaText.loadFont("resource/anim/font/font_item_name_yellow.banim");
				teamLeftPixmaText.setText(value);
				bitmapData = new BitmapData(teamLeftPixmaText.getWidth(), teamLeftPixmaText.getHeight(), true, 0);
				bitmapData.draw(teamLeftPixmaText);
				
				/*switch(teamID) {
					case TeamID.LEFT:
						teamLeftPixmaText.setText(value);
						bitmapData = new BitmapData(teamLeftPixmaText.getWidth(), teamLeftPixmaText.getHeight(), true, 0);
						bitmapData.draw(teamLeftPixmaText);
						break;
						
					case TeamID.RIGHT:
						teamRightPixmaText.setText(value);
						bitmapData = new BitmapData(teamRightPixmaText.getWidth(), teamRightPixmaText.getHeight(), true, 0);
						bitmapData.draw(teamRightPixmaText);
						break;
				}*/
			}
			else
			{
				ptHealHp.loadFont("resource/anim/font/font_item_name.banim");
				ptHealHp.setText("+" + value);
				bitmapData = new BitmapData(ptHealHp.getWidth(), ptHealHp.getHeight(), true, 0);
				bitmapData.draw(ptHealHp);
			}
			
			anim.addEventListener(Event.COMPLETE, onAnimPlayCompleteHdl);
			anim.replaceFMBitmapData([8], [bitmapData]);
			if (critical) {
				anim.play(7, 1);
			} else {
				anim.play(6, 1);
			}
		}
		
		private function onAnimPlayCompleteHdl(e:Event):void {
			anim.removeEventListener(Event.COMPLETE, onAnimPlayCompleteHdl);
			
			dispatchEvent(new Event(COMPLETE));
		}
	}

}