package game.ui.formation 
{
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import game.data.vo.formation.FormationStat;
	import game.data.xml.DataType;
	import game.data.xml.FormationTypeXML;
	import game.enum.Font;
	import game.Game;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class FormationStatUI extends MovieClip
	{
		
		public var damageTf:TextField;
		public var typeTf:TextField;
		public var levelTf:TextField;
		public var hpTf:TextField;
		public var physicalDamageTf:TextField;
		public var physicalArmorTf:TextField;
		public var magicalDamageTf:TextField;
		public var magicalArmorTf:TextField;
		
		private var _data:FormationStat;
		
		public function FormationStatUI() 
		{
			if (stage)
				init();
			else addEventListener(Event.ADDED_TO_STAGE, init);	
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			
			initUI();
		}
		
		private function initUI():void 
		{
			//set font
			FontUtil.setFont(damageTf, Font.ARIAL, true);
			FontUtil.setFont(typeTf, Font.ARIAL, true);
			FontUtil.setFont(levelTf, Font.ARIAL, true);
			FontUtil.setFont(hpTf, Font.ARIAL, true);
			FontUtil.setFont(physicalDamageTf, Font.ARIAL, true);
			FontUtil.setFont(physicalArmorTf, Font.ARIAL, true);
			FontUtil.setFont(magicalDamageTf, Font.ARIAL, true);
			FontUtil.setFont(magicalArmorTf, Font.ARIAL, true);
		}
		/*
		 * data: 
		 * {
		 * 		damage // type // level // hp // physicalDamage // physicalArmor // magicalDamage // magicalArmor
		 * }
		 */ 
		public function update(data:FormationStat):void {
			_data = data;
			if (data) {
				damageTf.text = data.damage.toString();
				var formationTypeXml : FormationTypeXML = Game.database.gamedata.getData(DataType.FORMATION_TYPE, data.ID) as FormationTypeXML;
				if (formationTypeXml != null) {
					typeTf.text = formationTypeXml.name;
				}else {
					typeTf.text = "Chưa chọn trận hình";
				}
				levelTf.text = data.level.toString();
				hpTf.text = data.hp.toString();
				physicalDamageTf.text = data.physicalDamage.toString();
				physicalArmorTf.text = data.physicalArmor.toString();
				magicalDamageTf.text = data.magicalDamage.toString();
				magicalArmorTf.text = data.magicalArmor.toString();
			}
		}
	}

}