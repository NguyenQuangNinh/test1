package game.ui.dialog.dialogs.select_class 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import core.event.EventEx;
	
	import game.Game;
	import game.data.model.Character;
	import game.net.lobby.request.RequestUpClass;
	import game.ui.dialog.dialogs.Dialog;
	import game.ui.dialog.dialogs.DialogEvent;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class SelectClassDialog extends Dialog 
	{
		private static const MAX_ITEMS	:int = 2;
		public var btnConfirm			:SimpleButton;
		public var subClassesContainer	:MovieClip;
		private var _subClasses			:Array;
		private var _selectedID			:int;
		
		public function SelectClassDialog() {
			_subClasses = [];
			_selectedID = -1;
			initUI();
			btnConfirm.addEventListener(MouseEvent.CLICK, onOK);
		}
		
		private function initUI():void 	
		{
			var subClass:SubClassItem;
			for (var i:int = 0; i < MAX_ITEMS; i++) {
				subClass = new SubClassItem();
				subClass.x = 327 * i;
				subClass.index = i;
				subClass.addEventListener(DialogEvent.SUB_CLASS_SELECTED, onDialogEventHdl);
				subClassesContainer.addChild(subClass);
				_subClasses.push(subClass);
			}
		}
		
		private function onDialogEventHdl(e:EventEx):void {
			deselectAllItems();
			if (_subClasses[e.data.index]) {
				_subClasses[e.data.index].isSelect = true;
				var character:Character = e.data.value;
				if (character && character.xmlData) {
					_selectedID = character.xmlData.ID;
				}
			}
		}
		
		private function deselectAllItems():void {
			var subClass:SubClassItem;
			for (var i:int = 0; i < _subClasses.length; i++) {
				subClass = _subClasses[i];
				if (subClass) {
					subClass.isSelect = false;
				}
			}
		}
		
		override protected function onOK(event:Event = null):void {
			var character:Character = data as Character;
			var selectedCharacterID:int = 0;
			for each(var subClass:SubClassItem in _subClasses)
			{
				if(subClass.isSelect)
				{
					selectedCharacterID = subClass.getData().xmlData.ID;
					break;
				}
			}
			if(character != null && selectedCharacterID > 0)
			{
				var packet:RequestUpClass = new RequestUpClass();
				packet.slotIndex = character.ID;
				packet.nextID = selectedCharacterID;
				Game.network.lobby.sendPacket(packet);
			}
			deselectAllItems();
			close();
		}
		
		override public function get data():Object {
			return super.data;
		}
		
		override public function set data(value:Object):void {
			super.data = value;
			var character:Character = data as Character;
			if(character != null)
			{
				var i:int;
				var length:int;
				var subClass:SubClassItem;
				var nextCharacter:Character;
				for(i = 0, length = character.xmlData.nextIDs.length; i < length; ++i)
				{
					subClass = _subClasses[i];
					nextCharacter = character.clone();
					nextCharacter.setXML(character.xmlData.nextIDs[i]);

					if(subClass != null) subClass.setData(nextCharacter);
				}
				_subClasses[0].isSelect = true;
			}
		}
	}
}