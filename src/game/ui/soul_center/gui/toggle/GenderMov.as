package game.ui.soul_center.gui.toggle 
{
	import game.ui.components.ToggleMov;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class GenderMov extends ToggleMov
	{
		public static const MALE : int = 1;
		public static const FEMALE : int = 0;
		
		public function GenderMov() 
		{
			setGender(FEMALE);
		}
		/**
		 * 
		 * @param	gender : 0 female --- 1 : male
		 */
		public function setGender(gender : int) : void {
			isActive = (gender == 0);
		}
	}

}