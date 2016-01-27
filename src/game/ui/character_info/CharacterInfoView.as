package game.ui.character_info 
{
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.data.model.UserData;
	import game.enum.Font;
	
	import core.Manager;
	import core.display.BitmapEx;
	import core.display.ViewBase;
	import core.event.EventEx;
	
	import game.Game;
	import game.data.model.Character;
	import game.data.model.UIData;
	import game.data.model.shop.ShopItem;
	import game.data.vo.skill.Skill;
	import game.main.SkillSlot;
	import game.ui.ModuleID;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class CharacterInfoView extends ViewBase 
	{		
		public static const CHARACTER_INFO_EVENT	:String = "character_info_event";
		public static const CLOSE					:String = "close";
		public var btnClose				:SimpleButton;
		public var skillGuideTf			:TextField;
		public var movSkills			:MovieClip;
		public var movCharacterAvatar	:MovieClip;
		public var characterInfo		:CharacterViewBase;
		public var movDetails			:CharacterInfoInDetails;
		public var shopHeroInfo			:ShopHeroInfo;
		private var _skillSlots			:Array;
		private var _model				:Character;
		
		private static const MAX_SKILL_SLOT_SHOW:int = 2;
		private static const DISTANCE_PER_SKILL_SLOT:int = 55;
		
		public function CharacterInfoView() 
		{
			_skillSlots = [];
			initUI();
			initHandlers();
		}
		
		private function initHandlers():void {
			btnClose.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
		}
		
		protected function onDetailCharacterChanged(event:EventEx):void
		{
			model = event.data as Character;
		}
		
		private function initUI():void {
			//set fonts
			FontUtil.setFont(skillGuideTf, Font.ARIAL, true);
			skillGuideTf.text = "chưa có";
			
			shopHeroInfo.visible = false;
		}
		
		private function onBtnClickHdl(e:MouseEvent):void {
			switch(e.target) {			
				case btnClose:
					dispatchEvent(new EventEx(CHARACTER_INFO_EVENT, { type:CLOSE }, true ));
					break;
			}
		}
		
		public function set displayMode(moduleID:String):void {
			switch(moduleID) {
				case ModuleID.INVENTORY_UNIT.name:
					movSkills.visible = true;
					movCharacterAvatar.visible = false;
					shopHeroInfo.visible = false;
					btnClose.visible = false;
					if (btnClose.hasEventListener(MouseEvent.CLICK)) {
						btnClose.removeEventListener(MouseEvent.CLICK, onBtnClickHdl);
					}
					break;
					
				case ModuleID.SHOP.name:
					movSkills.visible = false;
					movCharacterAvatar.visible = true;
					shopHeroInfo.visible = true;
					btnClose.visible = true;
					if (!btnClose.hasEventListener(MouseEvent.CLICK)) {
						btnClose.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
					}
					break;
			}
		}
		
		public function set shopItemModel(shopItem:ShopItem):void {
			shopHeroInfo.model = shopItem;
		}
		
		public function set model(value:Character):void {
			_model = value;
			characterInfo.model = value;
			movDetails.model = value;
			
			for each(var skillSlot:SkillSlot in _skillSlots) {
				movSkillsContainer.removeChild(skillSlot);
				Manager.pool.push(skillSlot);
			}
			_skillSlots.splice(0);
			
			skillGuideTf.visible = true;
			
			if (_model) {
				var i:int = 0;
				for each (var skill:Skill in _model.skills) {
					if (skill && skill.xmlData && skill.isEquipped) {
						skillSlot = Manager.pool.pop(SkillSlot) as SkillSlot;
						skillSlot.setType(SkillSlot.NONE);
						skillSlot.setData(skill);
						skillSlot.showHotKey(false);
						skillSlot.x = i * 40;
						skillSlot.y = 0;
						_skillSlots.push(skillSlot);
						movSkillsContainer.addChild(skillSlot);
						skillGuideTf.visible = false;
						i++;
					}
				}
			}
		}
		
		private function get movSkillsContainer():MovieClip {
			return movSkills.movSkillsContainer;
		}
		
		override public function transitionIn(): void {
			super.transitionIn();			
			movDetails.onTransIn();
		}				
	}

}