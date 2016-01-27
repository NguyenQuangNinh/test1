package game.ui.player_profile
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import core.Manager;
	import core.display.ModuleBase;
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.util.FontUtil;
	import core.util.Utility;
	
	import game.Game;
	import game.data.model.item.SoulItem;
	import game.data.xml.DataType;
	import game.data.xml.FormationTypeXML;
	import game.enum.Font;
	import game.net.IntRequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.request.RequestPlayerCharacterInfo;
	import game.net.lobby.response.ResponseCharacterInfo;
	import game.net.lobby.response.ResponsePlayerProfile;
	import game.ui.ModuleID;
	import game.ui.chat.ChatModule;
	import game.ui.components.ButtonClose;
	import game.ui.components.ScrollBar;
	import game.ui.components.characterslot.CharacterSlotAnimation;
	
	public class PlayerProfileView extends ViewBase
	{
		public var txtPlayerName:TextField;
		public var txtLevel:TextField;
		public var txtTotalPower:TextField;
		public var txtFormationName:TextField;
		public var formationElementContainer:MovieClip;
		public var formationEffectContainer:MovieClip;
		public var characterContainer:MovieClip;
		public var skillsContainer:MovieClip;
		public var thumbnailsContainer:MovieClip;
		public var btnClose:ButtonClose;
		public var soulsContainer:MovieClip;
		public var soulScrollbar:ScrollBar;
		public var soulMask:MovieClip;
		public var btnAddFriend:SimpleButton;
		public var btnMessage:SimpleButton;
		
		private var thumbnails:Array = [];
		private var characterSlot:CharacterSlotAnimation;
		private var playerID:int;
		private var skillIcons:Array  = [];
		private var souls:Array = [];
		private var formationEffects:Array = [];
		
		public function PlayerProfileView()
		{			
			FontUtil.setFont(txtFormationName, Font.UVN_THANGVU, false);
			FontUtil.setFont(txtPlayerName, Font.ARIAL, false);
			FontUtil.setFont(txtTotalPower, Font.ARIAL, true);
			FontUtil.setFont(txtLevel, Font.ARIAL, true);
			
			var thumbnail:CharacterThumbnail;
			for(var i:int = 0; i < Game.MAX_CHARACTER; ++i)
			{
				thumbnail = new CharacterThumbnail();
				thumbnail.x = i * 84;
				thumbnail.mouseChildren = false;
				thumbnail.addEventListener(MouseEvent.CLICK, thumbnail_onClicked);
				thumbnailsContainer.addChild(thumbnail);
				thumbnails.push(thumbnail);
			}
			
			var skillIcon:SkillIcon;
			for(i = 0; i < 3; ++i)
			{
				skillIcon = new SkillIcon();
				skillIcon.y = i * 44;
				skillsContainer.addChild(skillIcon);
				skillIcons.push(skillIcon);
			}
			
			characterSlot = new CharacterSlotAnimation();
			characterContainer.addChild(characterSlot);
			
			soulScrollbar.init(soulsContainer, soulMask, "vertical", true, false, false);
			soulScrollbar.height = 185;
			
			btnClose.addEventListener(MouseEvent.CLICK, btnClose_onClicked);
			btnAddFriend.addEventListener(MouseEvent.CLICK, btnAddFriend_onClicked);
			btnMessage.addEventListener(MouseEvent.CLICK, btnMessage_onClicked);
		}
		
		protected function btnAddFriend_onClicked(event:MouseEvent):void
		{
			Game.friend.addFriendByID(playerID);
		}
		
		protected function btnMessage_onClicked(event:MouseEvent):void
		{
			var moduleChat:ChatModule = Manager.module.getModuleByID(ModuleID.CHAT) as ChatModule;
			if (moduleChat != null)
			{
				moduleChat.showChatPrivate(txtPlayerName.text);
			}
		}
		
		protected function thumbnail_onClicked(event:MouseEvent):void
		{
			var thumbnail:CharacterThumbnail = event.target as CharacterThumbnail;
			if(thumbnail.getData() != null) select(thumbnail);
		}
		
		protected function btnClose_onClicked(event:MouseEvent):void
		{
			Manager.display.hideModule(ModuleID.PLAYER_PROFILE);
		}
		
		override public function transitionIn():void
		{
			Game.network.lobby.addEventListener(Server.SERVER_DATA, lobby_onPacketReceived);
			var module:ModuleBase = Manager.module.getModuleByID(ModuleID.PLAYER_PROFILE);
			playerID = module.extraInfo as int;
			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_PLAYER_PROFILE, playerID));
			super.transitionIn();
		}
		
		override public function transitionOut():void
		{
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, lobby_onPacketReceived);
			super.transitionOut();
		}
		
		protected function lobby_onPacketReceived(event:EventEx):void
		{
			var packet:ResponsePacket = event.data as ResponsePacket;
			switch(packet.type)
			{
				case LobbyResponseType.RECEIVE_PLAYER_PROFILE:
					onReceivePlayerProfile(packet as ResponsePlayerProfile);
					break;
				case LobbyResponseType.RECEIVE_PLAYER_CHARACTER_INFO:
					onReceivePlayerCharacterInfo(packet as ResponseCharacterInfo);
					break;
			}
		}
		
		private function onReceivePlayerCharacterInfo(packet:ResponseCharacterInfo):void
		{
			characterSlot.setData(packet.character);
			var skills:Array = packet.character.getSkills();
			for(var i:int = 0; i < skillIcons.length; ++i)
			{
				var skillIcon:SkillIcon = skillIcons[i];
				skillIcon.setData(skills[i]);
			}
			
			clearSoulSlots();
			var soulItem:SoulItem;
			var soul:Soul;
			for(i = 0; i < packet.character.soulItems.length; ++i)
			{
				soulItem = packet.character.soulItems[i];
				if(soulItem != null && soulItem.soulXML.ID > 0)
				{
					soul = Manager.pool.pop(Soul) as Soul;
					soul.y = i * 63;
					soul.setData(soulItem);
					soulsContainer.addChild(soul);
					souls.push(soul);
				}
			}
			soulScrollbar.update();
		}
		
		private function onReceivePlayerProfile(packet:ResponsePlayerProfile):void
		{					
			txtPlayerName.text = packet.playerName;
			txtTotalPower.text = Utility.formatNumber(packet.totalPower);
			txtLevel.text = packet.playerLevel.toString();
			
			if(packet.formationID > 0)
			{
				var formationXML:FormationTypeXML = Game.database.gamedata.getData(DataType.FORMATION_TYPE, packet.formationID) as FormationTypeXML;
				if(formationXML != null) 
				{
					txtFormationName.text = String(formationXML.name + " - cấp " + packet.formationLevel).toUpperCase();
				}
			}
			else
			{
				txtFormationName.text = "";
			}
			
			var effect:FormationEffect
			for(i = 0; i < formationEffects.length; ++i)
			{
				effect = formationEffects[i];
				formationEffectContainer.removeChild(effect);
				Manager.pool.push(effect, FormationEffect);
			}
			formationEffects.splice(0);
			
			var effectObject:Object;
			for(i = 0; i < 4; ++i)
			{
				effectObject = packet.effects[i];
				if(effectObject != null)
				{
					effect = Manager.pool.pop(FormationEffect) as FormationEffect;
					effect.setData(packet.effects[i]);
					effect.x = (i % 2) * 320;
					effect.y = int(i / 2) * 20;
					formationEffectContainer.addChild(effect);
					formationEffects.push(effect);
				}
			}
			
			var thumbnail:CharacterThumbnail;
			for(var i:int = 0; i < thumbnails.length; ++i)
			{
				thumbnail = thumbnails[i];
				if(thumbnail != null) thumbnail.setData(packet.formations[i]);
			}
			select(thumbnails[0]);
		}
		
		private function select(thumbnail:CharacterThumbnail):void
		{
			for(var i:int = 0; i < thumbnails.length; ++i)
			{
				var t:CharacterThumbnail = thumbnails[i];
				t.setSelected(t == thumbnail);
			}
			var character:CharacterSimple = thumbnail.getData();
			if(character != null)
			{
				var packet:RequestPlayerCharacterInfo = new RequestPlayerCharacterInfo();
				packet.playerID = playerID;
				packet.characterID = character.inventoryID;
				Game.network.lobby.sendPacket(packet);
			}
			else
			{
				characterSlot.setData(null);
				clearSoulSlots();
				clearSkillSlots();
			}
		}
		
		private function clearSkillSlots():void
		{
			for(var i:int = 0; i < skillIcons.length; ++i)
			{
				var skillIcon:SkillIcon = skillIcons[i];
				skillIcon.setData(null);
			}
		}
		
		private function clearSoulSlots():void
		{
			var soul:Soul;
			for(var i:int = 0; i < souls.length; ++i)
			{
				soul = souls[i];
				soulsContainer.removeChild(soul);
				Manager.pool.push(soul, Soul);
			}
			souls.splice(0);
		}
	}
}