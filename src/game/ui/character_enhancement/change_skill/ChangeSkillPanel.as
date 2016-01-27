/**
 * Created by NINH on 1/21/2015.
 */
package game.ui.character_enhancement.change_skill
{

	import core.Manager;
	import core.event.EventEx;
	import core.util.Utility;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import game.Game;

	import game.data.model.Character;
	import game.data.model.Inventory;
	import game.data.model.UserData;
	import game.data.model.item.ItemFactory;

	import game.data.vo.skill.Skill;
	import game.data.vo.skill.Stance;
	import game.data.xml.DataType;
	import game.data.xml.SkillXML;
	import game.data.xml.StanceXML;
	import game.enum.ItemType;

	import game.main.SkillSlot;
	import game.net.IntRequestPacket;
	import game.net.RequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.ui.components.ItemSlot;
	import game.ui.tooltip.TooltipID;
	import game.utility.TimerEx;

	import game.utility.UtilityUI;

	public class ChangeSkillPanel extends MovieClip
	{
		public static const CLOSE:String = "ChangeSkillPanel";

		public function ChangeSkillPanel()
		{
			closeBtn = UtilityUI.getComponent(UtilityUI.CLOSE_BTN) as SimpleButton;

			if (closeBtn != null)
			{
				closeBtn.x = 450;
				closeBtn.y = 10;
				addChild(closeBtn);
				closeBtn.addEventListener(MouseEvent.CLICK, closeHandler);
			}

			srcSkillSlot = new SkillSlot();
			srcSkillSlot.showHotKey(false);
			slot1.addChild(srcSkillSlot);

			desSkillSlot1 = new SkillSlot();
			desSkillSlot1.showHotKey(false);
			slot2.addChild(desSkillSlot1);

			desSkillSlot2 = new SkillSlot();
			desSkillSlot2.showHotKey(false);
			slot3.addChild(desSkillSlot2);

			rsSkillSlot = new SkillSlot();
			rsSkillSlot.showHotKey(false);
			slot4.addChild(rsSkillSlot);

			changeBtn.addEventListener(MouseEvent.CLICK, changeClickHdl);
		}

		private function changeClickHdl(event:MouseEvent):void
		{
			changeBtn.mouseEnabled = false;

			TimerEx.stopTimer(timerID);
			timerID = TimerEx.startTimer(1000,1, null, enableClick);

			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.REQUEST_CHANGE_SKILL, owner.ID));
		}

		private function enableClick():void
		{
			changeBtn.mouseEnabled = true;
		}

		public var slot1:MovieClip;
		public var slot2:MovieClip;
		public var slot3:MovieClip;
		public var slot4:MovieClip;
		public var itemMov:MovieClip;
		public var itemMov1:MovieClip;
		public var changeBtn:SimpleButton;
		private var closeBtn:SimpleButton;
		private var srcSkillSlot:SkillSlot;
		private var desSkillSlot1:SkillSlot;
		private var desSkillSlot2:SkillSlot;
		private var rsSkillSlot:SkillSlot;
		private var owner:Character;
		private var curSkillIndex:int;
		private var timerID:int = -1;

		private function closeHandler(event:MouseEvent):void
		{
			hide();
			dispatchEvent(new EventEx(CLOSE, null, true));
		}

		public function show(skillInfo:Skill):void
		{
			Game.database.inventory.addEventListener(Inventory.UPDATE_ITEM, onInventoryItemUpdate);
			Game.database.userdata.addEventListener(UserData.UPDATE_CHARACTER_INFO, onUpdateCharacterInfo);
			owner = skillInfo.owner;
			curSkillIndex = skillInfo.skillIndex;
			reset();
			rsSkillSlot.setData(null);
			updateInfo(skillInfo);
			this.visible = true;
		}

		private function updateInfo(skillInfo:Skill):void
		{
			if (skillInfo)
			{
				srcSkillSlot.setData(skillInfo);

				var desSkillInfo:Array = getOtherSkills(owner);

				if (desSkillInfo.length == 2)
				{
					for (var i:int = 0; i < 2; i++)
					{
						var skilSlot:SkillSlot = this["desSkillSlot" + (i + 1)] as SkillSlot;
						if (skilSlot)
						{
							skilSlot.setData(desSkillInfo[i]);
						}
					}
				}
				else
				{
					Utility.log("invalid skill num to change at character ID:" + owner.xmlID);
				}
			}

			var quantity:int = Game.database.gamedata.getConfigData(276);

			var _itemSlot:ItemSlot;
			_itemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
			_itemSlot.x = 5;
			_itemSlot.y = 5;
			_itemSlot.setConfigInfo(ItemFactory.buildItemConfig(ItemType.CHANGE_SKILL_RECIPE, 27), TooltipID.ITEM_COMMON, true);
			_itemSlot.setQuantity(quantity);
			itemMov.addChild(_itemSlot);

			var count:int = Game.database.inventory.getItemQuantity(ItemType.CHANGE_SKILL_RECIPE, 27);

			_itemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
			_itemSlot.x = 5;
			_itemSlot.y = 5;
			_itemSlot.setConfigInfo(ItemFactory.buildItemConfig(ItemType.CHANGE_SKILL_RECIPE, 27), TooltipID.ITEM_COMMON, true);
			_itemSlot.setQuantity(count);
			itemMov1.addChild(_itemSlot);
		}

		private function onUpdateCharacterInfo(event:EventEx):void
		{
			owner = event.data as Character;
			reset();
			updateInfo(owner.skills[curSkillIndex]);
		}

		public function reset():void
		{
			var _itemSlot:ItemSlot;
			while(itemMov.numChildren > 0)
			{
				_itemSlot = itemMov.removeChildAt(0) as ItemSlot;
				_itemSlot.reset();
			}

			while(itemMov1.numChildren > 0)
			{
				_itemSlot = itemMov1.removeChildAt(0) as ItemSlot;
				_itemSlot.reset();
			}

			srcSkillSlot.setData(null);
			desSkillSlot1.setData(null);
			desSkillSlot2.setData(null);
		}

		private function getOtherSkills(owner:Character):Array
		{
			var rs:Array = [];

			var equipedSkillID:Array = [];
			for each (var skill:Skill in owner.skills)
			{
				equipedSkillID.push(skill.xmlData.ID);
			}

			for (var i:int = 0; i < owner.xmlData.activeSkills.length; i++)
			{
				var skillID:int = owner.xmlData.activeSkills[i] as int;
				if(equipedSkillID.indexOf(skillID) == -1)
				{
					skill = new Skill();
					skill.skillIndex = -1;
					skill.xmlData = Game.database.gamedata.getData(DataType.SKILL, skillID) as SkillXML;
					if (skill.xmlData)
					{
						for (var j:int = 0; j < skill.xmlData.stanceIDs.length; j++)
						{
							var stance:Stance = new Stance();
							stance.active = j % 2 == 0;	//temp cheat here --> need changed to real value after then
							stance.xmlData = Game.database.gamedata.getData(DataType.STANCE, skill.xmlData.stanceIDs[j]) as StanceXML;
							skill.stances.push(stance);
						}
					}
					skill.level = 1;
					skill.isEquipped = false;
					skill.inCharacterID = -1;
					skill.inCharacterSubClass = "";

					rs.push(skill);
				}
			}

			return rs;
		}

		public function hide():void
		{
			Game.database.inventory.removeEventListener(Inventory.UPDATE_ITEM, onInventoryItemUpdate);
			Game.database.userdata.removeEventListener(UserData.UPDATE_CHARACTER_INFO, onUpdateCharacterInfo);

			this.visible = false;

		}

		private function onInventoryItemUpdate(event:Event):void
		{
			var count:int = Game.database.inventory.getItemQuantity(ItemType.CHANGE_SKILL_RECIPE, 27);
			var _itemSlot:ItemSlot = itemMov1.getChildAt(0) as ItemSlot;
			_itemSlot.setQuantity(count);
		}

		public function showResult(newSkillID:int):void
		{
			var desSkillInfo:Array = getOtherSkills(owner);

			for each (var skill:Skill in desSkillInfo)
			{
				if(skill.xmlData.ID == newSkillID)
				{
					rsSkillSlot.setData(skill);
				}
			}

			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_CHARACTER_INFO, owner.ID));
		}
	}
}
