package game.ui.game_levelup.gui
{
	import core.display.animation.Animator;
	import core.display.BitmapEx;
	import core.display.pixmafont.PixmaText;
	import core.event.EventEx;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class UnlockInfo extends Sprite
	{
		public static const SHOW_UNLOCK_COMPLETE:String = "show_unlock_complete";
		
		private var unlockInfoAppearAnim:Animator;
		private var unlockInfoDisappearAnim:Animator;
		private var unlockInfoLoopAnim:Animator;
		private var pixmaText:PixmaText;
		private var _iconBmp:BitmapEx;
		
		public function UnlockInfo()
		{
			_iconBmp = new BitmapEx();
			_iconBmp.addEventListener(BitmapEx.LOADED, onBitmapLoaded)
			this.addChild(_iconBmp);
			
			pixmaText = new PixmaText();
			pixmaText.loadFont("resource/anim/font/font_text.banim");
			
			unlockInfoAppearAnim = new Animator();
			unlockInfoAppearAnim.setCacheEnabled(false);
			unlockInfoAppearAnim.x = 0;
			unlockInfoAppearAnim.y = 0;
			unlockInfoAppearAnim.load("resource/anim/ui/level_up_level_info.banim");
			unlockInfoAppearAnim.addEventListener(Event.COMPLETE, onCompleteAppear);
			
			unlockInfoAppearAnim.stop();
			unlockInfoAppearAnim.visible = false;
			this.addChild(unlockInfoAppearAnim);
			
			unlockInfoLoopAnim = new Animator();
			unlockInfoLoopAnim.setCacheEnabled(false);
			unlockInfoLoopAnim.x = 0;
			unlockInfoLoopAnim.y = 0;
			unlockInfoLoopAnim.load("resource/anim/ui/level_up_level_info.banim");
			unlockInfoLoopAnim.stop();
			unlockInfoLoopAnim.visible = false;
			this.addChild(unlockInfoLoopAnim);
			
			unlockInfoDisappearAnim = new Animator();
			unlockInfoDisappearAnim.setCacheEnabled(false);
			unlockInfoDisappearAnim.x = 0;
			unlockInfoDisappearAnim.y = 0;
			unlockInfoDisappearAnim.load("resource/anim/ui/level_up_level_info.banim");
			unlockInfoDisappearAnim.addEventListener(Event.COMPLETE, function(e:Event):void
				{
					unlockInfoDisappearAnim.stop();
					unlockInfoDisappearAnim.visible = false;
				});
			unlockInfoDisappearAnim.stop();
			unlockInfoDisappearAnim.visible = false;
			//this.addChild(unlockInfoDisappearAnim);
		}
		
		private function onBitmapLoaded(e:Event):void
		{
			
			var sp:Sprite = new Sprite();
			sp.addChild(_iconBmp);
			pixmaText.x = _iconBmp.width + 20;
			pixmaText.y = _iconBmp.height / 2;
			sp.addChild(pixmaText);
			
			var bitmapData:BitmapData = new BitmapData(pixmaText.getWidth() + _iconBmp.width + 25, _iconBmp.height + 15, true, 0);
			bitmapData.draw(sp);
			
			unlockInfoAppearAnim.replaceFMBitmapData([0], [bitmapData]);
			unlockInfoLoopAnim.replaceFMBitmapData([0], [bitmapData]);
			unlockInfoDisappearAnim.replaceFMBitmapData([0], [bitmapData]);
		}
		
		private function onCompleteAppear(e:Event):void
		{
			unlockInfoAppearAnim.stop();
			unlockInfoAppearAnim.visible = false;
			
			unlockInfoLoopAnim.play(1);
			unlockInfoLoopAnim.visible = true;
			this.dispatchEvent(new Event(SHOW_UNLOCK_COMPLETE, true));
		}
		
		public function initEffect(obj:Object):void
		{
			if (obj)
			{
				pixmaText.setText(obj.text);
				_iconBmp.load(obj.url != "" ? obj.url : "resource/image/icon_hud/sell.png");
				
				var sp:Sprite = new Sprite();
				sp.addChild(_iconBmp);
				pixmaText.x = _iconBmp.width + 20;
				pixmaText.y = _iconBmp.height / 2;
				sp.addChild(pixmaText);
				
				var bitmapData:BitmapData = new BitmapData(pixmaText.getWidth() + _iconBmp.width + 25, _iconBmp.height + 15, true, 0);
				bitmapData.draw(sp);
				
				unlockInfoAppearAnim.replaceFMBitmapData([0], [bitmapData]);
				unlockInfoLoopAnim.replaceFMBitmapData([0], [bitmapData]);
				unlockInfoDisappearAnim.replaceFMBitmapData([0], [bitmapData]);
			}
		}
		
		public function reset():void
		{
			unlockInfoAppearAnim.stop();
			unlockInfoAppearAnim.visible = false;
			
			unlockInfoDisappearAnim.stop();
			unlockInfoDisappearAnim.visible = false;
			
			unlockInfoLoopAnim.stop();
			unlockInfoLoopAnim.visible = false;
			_iconBmp.reset();
		}
		
		public function hideEffect():void
		{
			unlockInfoLoopAnim.stop();
			unlockInfoLoopAnim.visible = false;
			unlockInfoDisappearAnim.play(2, 1);
			unlockInfoDisappearAnim.visible = true;
		}
		
		public function playEffect():void
		{
			unlockInfoAppearAnim.play(0, 1);
			unlockInfoAppearAnim.visible = true;
		}
	}

}