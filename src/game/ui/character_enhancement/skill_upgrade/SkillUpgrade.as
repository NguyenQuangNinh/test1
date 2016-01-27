package game.ui.character_enhancement.skill_upgrade 
{
	import core.util.Enum;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.enum.FlowActionEnum;
	import game.enum.PaymentType;
	
	import core.Manager;
	import core.event.EventEx;
	import core.util.FontUtil;
	import core.util.Utility;
	
	import game.Game;
	import game.data.model.Character;
	import game.data.model.UIData;
	import game.data.vo.skill.Skill;
	import game.data.xml.DataType;
	import game.data.xml.SkillEffectFormulaXML;
	import game.enum.Font;
	import game.enum.SkillType;
	import game.net.IntResponsePacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.request.RequestUnitChangeSkill;
	import game.net.lobby.request.RequestUpgradeSkill;
	import game.ui.character_enhancement.TabContent;
	import game.ui.components.SmallStar;
	import game.ui.message.MessageID;
	import game.ui.tutorial.TutorialEvent;
	import game.utility.GameUtil;

	/**
	 * ...
	 * @author TrungLNM
	 */
	public class SkillUpgrade extends TabContent
	{		
		//public static const SHOW_SKILL_HELP:String 		= "showSkillHelp";
		public static const CHANGE_SKILL_ACTIVE:String 	= "changeSkillActive";
			
		public var movActiveSkills	:SkillList;
		public var movPassiveSkills	:SkillList;
		public var activeGuideTf	:TextField;
		public var passiveGuideTf	:TextField;
		
		private var _selectedCharacter:Character;		
		private var _skillChanged:Skill;
		private var _autoUpdate:Boolean = true;
		
		public function SkillUpgrade() 
		{
			initUI();
			addEventListener(SubSkillInfo.UPGRADE_SKILL, onUpgradeSkillHdl);
			addEventListener(SkillInfo.EQUIP_SKILL, onEquipSkillHdl);
		}
		
		override protected function onActivate():void
		{
			//Game.database.userdata.addEventListener(UserData.UPDATE_CHARACTER_INFO, onUpdateCharacterInfoHdl);
			Game.uiData.addEventListener(UIData.CHARACTER_SKILL_CHANGED, onUpdateCharacterInfoHdl);
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerReceiveHdl);
			//_selectedCharacter = null;
			//updateInfo(false);
			super.onActivate();
		}
		
		override protected function onDeactivate():void
		{
			//Game.database.userdata.removeEventListener(UserData.UPDATE_CHARACTER_INFO, onUpdateCharacterInfoHdl);
			Game.uiData.addEventListener(UIData.CHARACTER_SKILL_CHANGED, onUpdateCharacterInfoHdl);
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerReceiveHdl);
			super.onDeactivate();
		}
		
		private function onLobbyServerReceiveHdl(e:EventEx):void {
			var packet: ResponsePacket = e.data as ResponsePacket;
			switch(packet.type) {
				case LobbyResponseType.UPGRADE_SKILL:
					var packetUpgrade:IntResponsePacket = packet as IntResponsePacket;
					Utility.log("skill upgrade response value " + packetUpgrade.value);
					switch(packetUpgrade.value) {
						case 0:
							//upgrade success
							Manager.display.showMessageID(MessageID.UPGRADE_SKILL_SUCCESS);
							updateInfo(false);
							dispatchEvent(new EventEx(TutorialEvent.EVENT, { type:TutorialEvent.UPGRADE_SKILL_SUCCESS }, true));
							break;
						case 5:
							//upgrade fail by not enough item require							
							Manager.display.showMessageID(MessageID.UPGRADE_SKILL_FAIL_BY_NOT_ENOUGH_SCROLL);
							break;
						case 2:
							//upgrade fail by reach level character
							Manager.display.showMessageID(MessageID.UPGRADE_SKILL_FAIL_BY_REACH_CHARACTER_LEVEL);
							break;
						case 1:	//upgrade fail by normal error
						case 6: //upgrade fail by rate
							Manager.display.showMessageID(MessageID.UPGRADE_SKILL_FAIL);
							//update so item con lai
							updateInfo(false);
							break;
						case 4:
							//not enough gold
							Game.flow.doAction(FlowActionEnum.PURCHASE_RESOURCE, PaymentType.GOLD.ID);	
							break;
					}
					_autoUpdate = true;
					break;
				case LobbyResponseType.UNIT_CHANGE_SKILL:
					var packetChange:IntResponsePacket = packet as IntResponsePacket;
					Utility.log("skill change response value " + packetChange.value);
					_autoUpdate = true;
					if (_skillChanged && _selectedCharacter) {
						var skillEquipedInPast:Skill = _selectedCharacter.getEquipSkill(_skillChanged.xmlData.type);
						if (skillEquipedInPast) 
							skillEquipedInPast.isEquipped = false;
							
						var skillChanged:Skill = _selectedCharacter.getSkillByIndex(_skillChanged.skillIndex);
						if (skillChanged)
							skillChanged.isEquipped = true;
						updateInfo(false);
					}
					break;
			}
		}


		
		private function onUpdateCharacterInfoHdl(e:Event):void {
			//_selectedCharacter = Game.database.userdata.selectedCharacter;
			//_selectedCharacter = e.data as Character;
			var characterID:int = Game.uiData.getCharacterSkillID();
			//Utility.log("character selected ID: " + characterID);
			_selectedCharacter = Game.database.userdata.getCharacter(characterID);
			
			if (_selectedCharacter) {
				updateInfo(_autoUpdate);
			}else {
				resetUI();
			}
		}
		
		private function resetUI():void {
			/*public var helpBtn			:SimpleButton;
			public var movActiveSkills	:SkillList;
			public var movPassiveSkills	:SkillList;
			public var activeGuideTf	:TextField;
			public var passiveGuideTf	:TextField;
			
			private var _selectedCharacter:Character;		
			private var _skillChanged:Skill;
			private var _autoUpdate:Boolean = true;*/
			activeGuideTf.text = "";
			passiveGuideTf.text = "";
			movActiveSkills.update([], true);
			movPassiveSkills.update([], true);
		}
		
		public function updateInfo(needReset:Boolean):void {
			var skills:Array = _selectedCharacter.skills;
			var activeSkills:Array = [];
			var passiveSkills:Array = [];
			for each (var skill:Skill in skills) {
				if (skill && skill.xmlData && skill.xmlData.type == SkillType.ACTIVE) {
					skill.skillElement = _selectedCharacter.unitClassXML.element;
					skill.owner = _selectedCharacter;
					activeSkills.push(skill);
					//test skill desc active
					var skillDesc:SkillEffectFormulaXML = Game.database.gamedata.getData(DataType.SKILL_EFFECT_FORMULA, 1) as SkillEffectFormulaXML;
					var test:Number = skillDesc.doVal(_selectedCharacter.ID, skill.xmlData.ID);
					//Utility.log("test number active in formation is: " + test);
				}else if (skill && skill.xmlData && skill.xmlData.type == SkillType.PASSIVE) {
					skill.skillElement = _selectedCharacter.unitClassXML.element;
					passiveSkills.push(skill);
					//test skill desc passive
					skillDesc = Game.database.gamedata.getData(DataType.SKILL_EFFECT_FORMULA, 1) as SkillEffectFormulaXML;
					test = skillDesc.doVal(_selectedCharacter.ID, skill.xmlData.ID);
					//Utility.log("test number passive in formation is: " + test);
				}
			}
			
			if (activeSkills.length == 0) {
				var nextLevelActiveSkill:int = _selectedCharacter.xmlData ? GameUtil.getNextLevelActiveSkill(_selectedCharacter.xmlData.ID) : 0;
				//Utility.log("next level get active skill is " + nextLevelActiveSkill);				
			}
			updateActiveSkills(activeSkills, nextLevelActiveSkill, needReset);
			
			if (passiveSkills.length == 0) {
				var nextLevelPassiveSkill:int = _selectedCharacter.xmlData ? GameUtil.getNextLevelPassiveSkill(_selectedCharacter.xmlData.ID) : 0;
				//Utility.log("next level get passive skill is " + nextLevelPassiveSkill);
			}
			updatePassiveSkills(passiveSkills, nextLevelPassiveSkill, needReset);			
		}
		
		private function initUI():void {		
			//set fonts
			FontUtil.setFont(activeGuideTf, Font.ARIAL, false);
			FontUtil.setFont(passiveGuideTf, Font.ARIAL, false);
			activeGuideTf.mouseEnabled = false;
			passiveGuideTf.mouseEnabled = false;
			
			//initEvents();
			//helpBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
		}
		
		/*private function onBtnClickHdl(e:MouseEvent):void 
		{
			switch(e.target) {
				case helpBtn:
					dispatchEvent(new Event(SHOW_SKILL_HELP));
					break;
			}
		}*/
		
		public function updateActiveSkills(data:Array, nextLevelActive:int, needReset:Boolean): void {
			if (data) {
				//data = data.concat(data);
				//data = data.concat(data);
				movActiveSkills.update(data, needReset);
				if (data.length == 0 /*&& nextLevelActive > 0*/) {
					//update active guide skill
					if(nextLevelActive > 0)
						activeGuideTf.text = "Truyền công cho nhân vật đến tầng thứ " + nextLevelActive * 12
												+ ", chuyển chức trách sẽ học được kĩ năng mới";
					else 
						activeGuideTf.text = "Nhân vật này không có chiêu thức";
				}else {
					activeGuideTf.text = "";
				}
			}else {
				Utility.error("can not update active skill with null data");
			}
		}
		
		public function updatePassiveSkills(data:Array, nextLevelPassive:int, needReset:Boolean): void {
			if(data) {
				movPassiveSkills.update(data, needReset);
				if (data.length == 0 /*&& nextLevelPassive > 0*/) {
					//update passive guide skill
					if(nextLevelPassive > 0)
						passiveGuideTf.text = "Truyền công cho nhân vật đến tầng thứ " + nextLevelPassive * 12
												+ ", chuyển chức trách sẽ học được kĩ năng mới";
					else 
						passiveGuideTf.text = "Nhân vật này không có tâm pháp";
				}else {
					passiveGuideTf.text = "";
				}
			}else {
				Utility.error("can not update passive skill with null data");
			}
		}
		
		private function onEquipSkillHdl(e:EventEx):void 
		{
			_skillChanged = e.data as Skill;
			if (_skillChanged) {
				_autoUpdate = false;
				Game.network.lobby.sendPacket(new RequestUnitChangeSkill(_selectedCharacter.ID, _skillChanged.skillIndex));	
			}
		}
		
		private function onUpgradeSkillHdl(e:EventEx):void {
			var skill:Skill = e.data as Skill;		
			if (_selectedCharacter && skill && skill.xmlData) {
				_autoUpdate = false;
				Game.network.lobby.sendPacket(new RequestUpgradeSkill(_selectedCharacter.ID, skill.xmlData.ID));	
			}
		}
	}

}