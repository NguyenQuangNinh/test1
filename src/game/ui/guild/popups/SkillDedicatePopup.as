package game.ui.guild.popups 
{
	import components.enum.PopupAction;
	import components.popups.OKCancelPopup;
	import core.util.FontUtil;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.enum.Font;
	import game.enum.GameConfigID;
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.response.ResponseGuOwnGuildInfo;
	import game.net.RequestPacket;
	import game.ui.guild.popups.skill_dedicate.GuildSkillItem;
	import game.ui.guild.popups.skill_dedicate.GuildSkillContent;
	/**
	 * ...
	 * @author vu anh
	 */
	public class SkillDedicatePopup extends OKCancelPopup
	{
		private var itemName:String;
		
		public var currentAdditionalTf:TextField;
		public var nextAdditionalTf:TextField;
		
		public var desTf:TextField;
		
		public var activeItem:GuildSkillItem;
		public var selectedItem:GuildSkillItem;
		
		public var skillContent:GuildSkillContent;
		
		public var dedicateBtn:SimpleButton;
		
		public function SkillDedicatePopup() 
		{
			FontUtil.setFont(currentAdditionalTf, Font.ARIAL, true);
			FontUtil.setFont(nextAdditionalTf, Font.ARIAL, true);
			FontUtil.setFont(desTf, Font.ARIAL, true);
			setActiveItem(skillContent.vitality);
			
			skillContent.vitality.addEventListener(MouseEvent.CLICK, skillContentHdl);
			skillContent.strength.addEventListener(MouseEvent.CLICK, skillContentHdl);
			skillContent.agility.addEventListener(MouseEvent.CLICK, skillContentHdl);
			skillContent.intelligent.addEventListener(MouseEvent.CLICK, skillContentHdl);
			
			dedicateBtn.addEventListener(MouseEvent.CLICK, dedicateBtnHdl);
		}
		
		private function dedicateBtnHdl(e:MouseEvent):void 
		{
			GuildPopupMng.messagePopup.show(dedicateConfirmHdl, "", "Đóng góp nâng cấp kỹ năng " + itemName + " của bang tiêu tốn " 
				+ Game.database.gamedata.getConfigData(GameConfigID.GUILD_SKILL_DEDICATED_POINT) + " điểm cống hiến, bạn đồng ý chứ?");
		}
		
		private function dedicateConfirmHdl(action:int, data:Object):void 
		{
			if (action != PopupAction.OK) return;
			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GU_DEDICATED_SKILL, selectedItem.type));
		}
		
		private function skillContentHdl(e:MouseEvent):void 
		{
			var item:GuildSkillItem = e.currentTarget as GuildSkillItem;
			setActiveItem(item);
		}
		
		public function update(info:ResponseGuOwnGuildInfo):void
		{
			skillContent.vitality.update(info.guildVitalitySkillLvl, info.guildVitalityDP);
			skillContent.strength.update(info.guildStrengthSkillLvl, info.guildStrengthDP);
			skillContent.agility.update(info.guildAgilitySkillLvl, info.guildAgilityDP);
			skillContent.intelligent.update(info.guildIntelligentSkillLvl, info.guildIntelligentDP);
		}
		
		override public function show(callback:Function = null, title:String = "", msg:String = "", data:Object = null, isHideCancelBtn:Boolean = false):void
		{
			super.show(callback, title, msg, data);
		}
		
		public function setActiveItem(item:GuildSkillItem):void
		{
			if (activeItem) activeItem.deactive();
			activeItem = item;
			activeItem.active();
			selectedItem.copy(activeItem);
			itemName = "";
			var gameConfigID:int;
			switch (item)
			{
				case skillContent.vitality:
					itemName = "sinh khí";
					gameConfigID = GameConfigID.GUILD_SKILL_ADDITIONAL_VITALITY;
					break
				case skillContent.strength:
					itemName = "sức mạnh";
					gameConfigID = GameConfigID.GUILD_SKILL_ADDITIONAL_STRENGTH;
					break
				case skillContent.agility:
					itemName = "thân pháp";
					gameConfigID = GameConfigID.GUILD_SKILL_ADDITIONAL_AGILITY;
					break
				case skillContent.intelligent:
					itemName = "trí tuệ";
					gameConfigID = GameConfigID.GUILD_SKILL_ADDITIONAL_INTELLIGENT;
					break
			}
			currentAdditionalTf.text = "Tăng " + Game.database.gamedata.getConfigData(gameConfigID)[activeItem.skillLevel] + " " + itemName + " cho các nhân vật của toàn bộ thành viên trong bang";
			nextAdditionalTf.text = "Tăng " + Game.database.gamedata.getConfigData(gameConfigID)[activeItem.skillLevel + 1] + " " + itemName + " cho các nhân vật của toàn bộ thành viên trong bang";
			desTf.text = "Đóng góp " + Game.database.gamedata.getConfigData(GameConfigID.GUILD_SKILL_DEDICATED_POINT) + " điểm cống hiến cá nhân cho kỹ năng " + itemName + " của bang";
		}
	}

}