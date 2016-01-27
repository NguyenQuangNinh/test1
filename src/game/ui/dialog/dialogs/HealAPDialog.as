package game.ui.dialog.dialogs 
{
	import core.display.layer.Layer;
	import core.Manager;
	import core.util.FontUtil;
	import flash.events.Event;
	import flash.text.TextField;
	import game.enum.Font;
	import game.ui.ModuleID;
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class HealAPDialog extends Dialog 
	{		
		public function HealAPDialog() {	
			
		}
		
		override protected function onOK(event:Event = null):void {
			super.onOK(event);
			Manager.display.showPopup(ModuleID.HEAL_AP, Layer.BLOCK_BLACK);
		}
	}

}