package game.ui.soul_center.gui 
{
	import core.display.layer.Layer;
	import core.Manager;
	import core.util.FontUtil;
	import core.util.Utility;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import game.data.model.Character;
	import game.data.model.item.SoulItem;
	import game.enum.DialogEventType;
	import game.enum.Font;
	import game.Game;
	import game.ui.dialog.DialogID;
	import game.ui.soul_center.event.EventSoulCenter;
	import game.ui.soul_center.gui.toggle.GenderMov;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class AttachSoulPanel extends MovieClip
	{
		public var genderMov : GenderMov;
		public var characterNameTf : TextField;
		public var soulCharacterChain : SoulCharacterChain;
		
		public function AttachSoulPanel() 
		{
			FontUtil.setFont(characterNameTf, Font.ARIAL, true);
		}
		
		
		public function updateCharacter(character : Character) : void {
			soulCharacterChain.update(character);
			genderMov.setGender(character.sex);
			characterNameTf.text = character.name != null ? character.name : "";
		}
		
		public function checkInsertSoul(slot:SoulItem):void {
			soulCharacterChain.checkInsertSoul(slot);
		}
		
		public function checkHitDropToEquip(obj:DisplayObject, data:SoulItem):Boolean {
			return soulCharacterChain.checkHitDropToEquip(obj, data);
		}
		
		public function removeAttachAtIndex(index:int):void {
			soulCharacterChain.removeAttachAtIndex(index);
		}
	}

}