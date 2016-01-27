package game.enum 
{
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class TutorialTriggerType 
	{
		public static const NONE				:TutorialTriggerType = new TutorialTriggerType( -1, "lan dau choi tutorial");
		public static const PREV_SCENE_COMPLETE	:TutorialTriggerType = new TutorialTriggerType(1, "hoan thanh scene truoc do");
		public static const NEXT_LOOSE_END_GAME	:TutorialTriggerType = new TutorialTriggerType(2, "hoan thanh scene truoc va lan thua tiep theo");
		public static const CHAR_LEVEL_UP		:TutorialTriggerType = new TutorialTriggerType(3, "nhan vat duoc truyen cong thanh cong");
		public static const ACC_LEVEL_UP		:TutorialTriggerType = new TutorialTriggerType(4, "account level up");
		public static const UP_STAR				:TutorialTriggerType = new TutorialTriggerType(5, "nhan vat thang cap sao thanh cong + hoan thanh step truoc");
		public static const OCCUR_ONCE			:TutorialTriggerType = new TutorialTriggerType(6, "chi su dung 1 lan trong doi");
		
		public var enum	:int;
		public var name	:String;
		
		public function TutorialTriggerType(enum:int, name:String){
			this.enum = enum;
			this.name = name;
		}
		
	}

}