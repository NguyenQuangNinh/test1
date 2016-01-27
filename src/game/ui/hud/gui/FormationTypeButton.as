package game.ui.hud.gui
{
	import flash.display.MovieClip;
	
	import game.ui.hud.HUDButtonID;
	
	/**
	 * ...
	 * @author anhtinh
	 */
	public class FormationTypeButton extends HUDButton
	{
		public var notify:MovieClip;
		
		public function FormationTypeButton()
		{
			notify.visible = false;
			ID = HUDButtonID.FORMATION_TYPE;
		}
		
		override public function setNotify(val:Boolean, jsonData:Object):void
		{
			super.setNotify(val, jsonData);
			notify.visible = val;
		}
	}

}