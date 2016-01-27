package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.data.model.Character;
	import game.data.vo.formation.FormationStat;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ResponseLeaderBoardPlayerFormationInfo extends ResponsePacket
	{
		
		/*public var f_damage:Number;	// f : formation
		public var f_type:int;
		public var f_level:Number;
		public var f_hp:Number;
		public var f_physicalDamage:Number;
		public var f_physicalArmor:Number;
		public var f_magicalDamage:Number;
		public var f_magicalArmor:Number;*/
		
		public var formationStat:FormationStat = new FormationStat();
		public var characters:Array = [];
		
		public function ResponseLeaderBoardPlayerFormationInfo() 
		{
			
		}
		
		override public function decode(data:ByteArray):void 
		{
			super.decode(data);
			
			formationStat.damage = data.readInt();
			formationStat.ID = data.readInt();
			formationStat.level = data.readInt();
			formationStat.hp = data.readInt();
			formationStat.physicalDamage = data.readInt();
			formationStat.physicalArmor = data.readInt();
			formationStat.magicalDamage = data.readInt();
			formationStat.magicalArmor = data.readInt();
			
			while(data && data.bytesAvailable > 0) {
				var exist:int = data.readInt();
				var character:Character = new Character();
				if (exist > -1) {
					character.decode(data);						
				}
				characters.push(exist > -1 ? character : null);
			}
			
		}
		
		//Lay danh sach mang formation ko co phan tu null
		public function getFormation() : Array { 
			var result : Array = [];
			for (var i:int = 0; i < characters.length; i++) 
			{
				if (characters[i] != null) result.push(characters[i]);
			}
			return result;
		};
		
	}

}