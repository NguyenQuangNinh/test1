package game.ui.tooltip
{
	import core.display.ViewBase;
	import core.event.EventEx;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import game.data.model.Character;
	import game.data.model.item.DivineWeaponItem;
	import game.data.model.item.IItemConfig;
	import game.data.model.item.SoulItem;
	import game.data.vo.formation.FormationStat;
	import game.data.vo.skill.Skill;
	import game.data.xml.item.ItemChestXML;
	import game.data.xml.item.ItemXML;
	import game.data.xml.item.MergeItemXML;
	import game.data.xml.MissionXML;
	import game.data.xml.RewardXML;
	import game.Game;
	import game.ui.tooltip.tooltips.CharacterSlotTooltip;
	import game.ui.tooltip.tooltips.ConsumeEventTooltip;
	import game.ui.tooltip.tooltips.DivineWeaponTooltip;
	import game.ui.tooltip.tooltips.HeroicRewardTooltip;
	import game.ui.tooltip.tooltips.ItemSetTooltip;
	import game.ui.tooltip.tooltips.ItemTooltip;
	import game.ui.tooltip.tooltips.MergeItemTooltip;
	import game.ui.tooltip.tooltips.MissionTooltip;
	import game.ui.tooltip.tooltips.PlayerFormationInfoToolTip;
	import game.ui.tooltip.tooltips.RewardTooltip;
	import game.ui.tooltip.tooltips.SimpleTooltip;
	import game.ui.tooltip.tooltips.SkillSlotTooltip;
	import game.ui.tooltip.tooltips.SoulTooltip;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class TooltipView extends ViewBase
	{
		public var movCharacterSlotTooltip:CharacterSlotTooltip;
		public var movSkillTooltip:SkillSlotTooltip;
		public var movSimpleTooltip:SimpleTooltip;
		public var soulTooltip:SoulTooltip;
		public var missionTooltip:MissionTooltip;
		public var playerFormationInfoTooltip:PlayerFormationInfoToolTip;
		private var itemSetTooltip:ItemSetTooltip = new ItemSetTooltip();
		private var itemTooltip:ItemTooltip = new ItemTooltip();
		public var rewardTooltip:RewardTooltip;
		private var mergeItemTooltip:MergeItemTooltip = new MergeItemTooltip();
		public var heroicRewardTooltip:HeroicRewardTooltip;
		public var consumeEventTooltip:ConsumeEventTooltip;
		public var divineWeaponToolTip:DivineWeaponTooltip;
		
		public function TooltipView()
		{
			invisibleAll();
			
			this.addChild(itemSetTooltip);
			this.addChild(itemTooltip);
			this.addChild(mergeItemTooltip);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		private function onAddToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			this.mouseChildren = false;
			this.mouseEnabled = false;
			stage.addEventListener(TooltipEvent.SHOW_TOOLTIP, onShowTooltipHdl);
			stage.addEventListener(TooltipEvent.HIDE_TOOLTIP, onHideTooltipHdl);
			stage.addEventListener(TooltipEvent.ENABLE, onToolTipEnableHdl);
		}
		
		private function onToolTipEnableHdl(e:EventEx):void
		{
			var enable:Boolean = e.data as Boolean;
			if (!enable)
			{
				if (stage.hasEventListener(TooltipEvent.SHOW_TOOLTIP))
				{
					stage.removeEventListener(TooltipEvent.SHOW_TOOLTIP, onShowTooltipHdl);
				}
				if (stage.hasEventListener(TooltipEvent.HIDE_TOOLTIP))
				{
					stage.removeEventListener(TooltipEvent.HIDE_TOOLTIP, onHideTooltipHdl);
				}
			}
			else
			{
				if (!stage.hasEventListener(TooltipEvent.SHOW_TOOLTIP))
				{
					stage.addEventListener(TooltipEvent.SHOW_TOOLTIP, onShowTooltipHdl);
				}
				if (!stage.hasEventListener(TooltipEvent.HIDE_TOOLTIP))
				{
					stage.addEventListener(TooltipEvent.HIDE_TOOLTIP, onHideTooltipHdl);
				}
			}
		}
		
		private function onHideTooltipHdl(e:EventEx):void
		{
			hideToolTip();
		}
		
		private function onShowTooltipHdl(e:EventEx):void
		{
			if (e.data)
			{
				showTooltip(e.data);
			}
		}
		
		private function showTooltip(data:Object):void
		{
			if (data)
			{
				invisibleAll();
				switch (data.type)
				{
					case TooltipID.CHARACTER_SLOT:
						if (data.value)
						{
							var model:Character = data.value as Character;
							movCharacterSlotTooltip.model = model;
							movCharacterSlotTooltip.visible = true;
						}
						else
						{
							movCharacterSlotTooltip.visible = false;
						}
						break;
					
					case TooltipID.SKILL_SLOT: 
						if (data.value)
						{
							var skillModel:Skill = data.value as Skill;
							movSkillTooltip.model = skillModel;
							movSkillTooltip.visible = true;
						}
						else
						{
							movSkillTooltip.visible = false;
						}
						break;
					
					case TooltipID.SIMPLE: 
						if (data.value)
						{
							movSimpleTooltip.content = (data.value as String);
							movSimpleTooltip.visible = true;
						}
						else
						{
							movSimpleTooltip.visible = false;
						}
						break;
					
					case TooltipID.ITEM_SET: 
						if (data.value)
						{
							
							var itemChestXML:ItemChestXML = data.value as ItemChestXML;
							itemSetTooltip.setData(itemChestXML);
							
							itemSetTooltip.x = mouseX + 20;
							itemSetTooltip.y = mouseY;
							
							if (itemSetTooltip.y + itemSetTooltip.height > Game.HEIGHT)
							{
								itemSetTooltip.y = mouseY - 20 - itemSetTooltip.getHeight()/2;
							}
							
							if (itemSetTooltip.x + itemSetTooltip.width > Game.WIDTH)
							{
								itemSetTooltip.x = mouseX - 20 - itemSetTooltip.width;
							}
							itemSetTooltip.visible = true;
							
						}
						else
						{
							itemSetTooltip.visible = false;
						}
						break;
					/*case TooltipID.LIST_ITEM_SET:
					   if (data.value) {
					
					   for (var i:int = 0; i < data.value.length; i++) {
					   itemChestXML = data.value[i] as ItemChestXML;
					
					   }
					
					   }else {
					   itemSetTooltip.visible = false;
					   }
					 break;*/
					case TooltipID.ITEM_COMMON: 
						if (data.value)
						{							
							var itemConfig:IItemConfig = data.value as IItemConfig;
							itemTooltip.setData(itemConfig);
							if (data.quantity) {
								itemTooltip.setQuantity(data.quantity);	
							}
							
							itemTooltip.x = mouseX + 20;
							itemTooltip.y = mouseY + 20;
							
							if (itemTooltip.y + itemTooltip.getHeight() > Game.HEIGHT)
							{
								itemTooltip.y = Game.HEIGHT - itemTooltip.getHeight() - 30;
								if (itemTooltip.y < 0) {
									itemTooltip.y = 20;
								}
							}
							
							if (itemTooltip.x + itemTooltip.width > Game.WIDTH)
							{
								itemTooltip.x = mouseX - 20 - itemTooltip.width;
							}
							itemTooltip.visible = true;
						}
						else
						{
							itemTooltip.visible = false;
						}
						break;
					case TooltipID.SOUL: 
						if (data.value)
						{
							
							var soulItem:SoulItem = data.value as SoulItem;
							soulTooltip.setData(soulItem);
							
							soulTooltip.x = mouseX + 20;
							soulTooltip.y = mouseY;
							
							if (soulTooltip.y + soulTooltip.height > 650)
							{
								soulTooltip.y = mouseY - 20 - soulTooltip.height/2;
								if (soulTooltip.y - soulTooltip.height < 0)
								{
									soulTooltip.y = 20;
								}
							}
							
							if (soulTooltip.x + soulTooltip.width > 1210)
							{
								soulTooltip.x = mouseX - 20 - soulTooltip.width;
							}
							soulTooltip.visible = true;
						}
						else
						{
							soulTooltip.visible = false;
						}
						break;
					
					case TooltipID.MISSION_TOOLTIP: 
						if (data.value)
						{
							missionTooltip.content = (data.value as MissionXML);
							missionTooltip.visible = true;
						}
						else
						{
							missionTooltip.visible = false;
						}
						break;
					case TooltipID.REWARD_TOOLTIP: 
						if (data.value)
						{
							rewardTooltip.content = (data.value as RewardXML);
							rewardTooltip.visible = true;
						}
						else
						{
							rewardTooltip.visible = false;
						}
						break;
					case TooltipID.MERGE_ITEM: 
						if (data.value)
						{
							mergeItemTooltip.setContent((data.value as MergeItemXML));
							mergeItemTooltip.visible = true;
						}
						else
						{
							mergeItemTooltip.visible = false;
						}
						break;
					case TooltipID.PLAYER_FORMATION_INFO: 
						//request server to get info can display
						var playerID:int = data.value;
						var source:int = data.from;
						dispatchEvent(new EventEx(TooltipEvent.REQUEST_PLAYER_FORMATION_INFO, {id: playerID, from: source}));
						
						break;
					
					case TooltipID.HEROIC_REWARD: 
						heroicRewardTooltip.visible = true;
						heroicRewardTooltip.setRewards(data.value);
						break;
					case TooltipID.CONSUME_EVENT: 
						if (data.value)
						{
							consumeEventTooltip.update(data.value);
							consumeEventTooltip.x = mouseX + 15;
							consumeEventTooltip.y = mouseY;
							consumeEventTooltip.visible = true;
						}
						else
						{
							consumeEventTooltip.visible = false;
						}
						break;
					case TooltipID.DIVINE_WEAPON:
							if (data.value) {
								divineWeaponToolTip.mouseChildren = false;
								divineWeaponToolTip.mouseEnabled = false
								this.mouseChildren = false;
								this.mouseEnabled = false;
								divineWeaponToolTip.setData(data.value as DivineWeaponItem);
								divineWeaponToolTip.x = mouseX - divineWeaponToolTip.width / 2;
								divineWeaponToolTip.x += Game.WIDTH - divineWeaponToolTip.x - divineWeaponToolTip.width - 15;
								divineWeaponToolTip.y = mouseY + 10;
								if ((divineWeaponToolTip.y + divineWeaponToolTip.height) >= Game.HEIGHT) {
									divineWeaponToolTip.y = mouseY - divineWeaponToolTip.height-10;
								}

								divineWeaponToolTip.visible = true;
							}else{
								divineWeaponToolTip.visible = false;
							}
						break;
				}
			}
		}
		
		private function hideToolTip():void
		{
			invisibleAll();
		}
		
		private function invisibleAll():void
		{
			movCharacterSlotTooltip.visible = false;
			itemSetTooltip.visible = false;
			itemTooltip.visible = false;
			movSkillTooltip.visible = false;
			movSimpleTooltip.visible = false;
			soulTooltip.visible = false;
			missionTooltip.visible = false;
			playerFormationInfoTooltip.visible = false;
			rewardTooltip.visible = false;
			heroicRewardTooltip.visible = false;
			mergeItemTooltip.visible = false;
			consumeEventTooltip.visible = false;
			divineWeaponToolTip.visible = false;
		}
		
		public function updatePlayerFormationInfo(stat:FormationStat, characters:Array, from:int):void
		{
			if (stat && characters && from)
			{
				playerFormationInfoTooltip.visible = true;
				playerFormationInfoTooltip.updateFormation(characters);
				playerFormationInfoTooltip.displayStat(stat);
				
				switch (from)
				{
					case TooltipID.FROM_HISTORY: 
						playerFormationInfoTooltip.x = mouseX - playerFormationInfoTooltip.width - 20;
						playerFormationInfoTooltip.y = mouseY;
						break;
					case TooltipID.FROM_LEADER_BOARD: 
						playerFormationInfoTooltip.x = mouseX - 20;
						playerFormationInfoTooltip.y = mouseY - playerFormationInfoTooltip.height / 2;
						break;
				}
				
				if (playerFormationInfoTooltip.y + playerFormationInfoTooltip.height > Game.HEIGHT)
				{
					playerFormationInfoTooltip.y = mouseY - 20 - playerFormationInfoTooltip.height;
				}
				
				if (playerFormationInfoTooltip.x + playerFormationInfoTooltip.width > Game.WIDTH)
				{
					playerFormationInfoTooltip.x = mouseX - 20 - playerFormationInfoTooltip.width;
				}
				
			}
			else
			{
				playerFormationInfoTooltip.visible = false;
			}
		}
	}

}