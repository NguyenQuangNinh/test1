package game.ui.dialog
{
	import core.event.EventEx;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import game.ui.tutorial.TutorialEvent;
	
	import game.data.model.Character;
	import game.ui.components.ButtonOK;
	import game.ui.components.characterslot.CharacterSlotAnimation;
	import game.ui.dialog.dialogs.Dialog;
	
	public class UpgradeInfo extends Dialog
	{
		public var btnCloseContainer:MovieClip;
		public var oldCharacterSlotContainer:MovieClip;
		public var newCharacterSlotContainer:MovieClip;
		
		private var btnClose:ButtonOK = new ButtonOK();
		private var statInfos:Array = [];
		private var oldCharacterSlot:CharacterSlotAnimation = new CharacterSlotAnimation();
		private var newCharacterSlot:CharacterSlotAnimation = new CharacterSlotAnimation();
		
		public function UpgradeInfo()
		{
			btnCloseContainer.addChild(btnClose);
			btnClose.addEventListener(MouseEvent.CLICK, btnClose_onClicked);
			
			oldCharacterSlotContainer.addChild(oldCharacterSlot);
			newCharacterSlotContainer.addChild(newCharacterSlot);
			
			for(var i:int = 0; i < 5; ++i)
			{
				var statInfo:StatInfo = new StatInfo();
				statInfo.x = 532;
				statInfo.y = 350 + i * 23;
				addChild(statInfo);
				statInfos.push(statInfo);
			}
		}
		
		override public function onShow():void
		{
			var oldCharacter:Character = data.oldCharacter;
			var newCharacter:Character = data.newCharacter;
			oldCharacterSlot.setData(oldCharacter);
			newCharacterSlot.setData(newCharacter);
			if(oldCharacter == null || newCharacter == null) return;
			StatInfo(statInfos[0]).setData(oldCharacter.battlePoint, newCharacter.battlePoint);
			StatInfo(statInfos[1]).setData(oldCharacter.vitality, newCharacter.vitality);
			StatInfo(statInfos[2]).setData(oldCharacter.strength, newCharacter.strength);
			StatInfo(statInfos[3]).setData(oldCharacter.agility, newCharacter.agility);
			StatInfo(statInfos[4]).setData(oldCharacter.intelligent, newCharacter.intelligent);
		}
		
		protected function btnClose_onClicked(event:MouseEvent):void
		{
			dispatchEvent(new EventEx(TutorialEvent.EVENT, { type:TutorialEvent.CLOSE_UPGRADE_INFO }, true));
			onOK();
		}
	}
}