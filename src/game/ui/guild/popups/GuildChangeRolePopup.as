package game.ui.guild.popups 
{
	import components.enum.PopupAction;
	import components.ExButtonCheckBox;
	import components.ExRadioButtonGroup;
	import components.popups.OKCancelPopup;
	import core.Manager;
	import core.util.FontUtil;
	import flash.events.Event;
	import flash.text.TextField;
	import game.net.lobby.response.data.GuMemberInfo;
	import game.ui.guild.components.GuildExButtonCheckBox;
	import game.ui.guild.enum.GuildRole;
	import game.enum.Font;
	/**
	 * ...
	 * @author vu anh
	 */
	public class GuildChangeRolePopup extends OKCancelPopup
	{
		public var nameTf:TextField;
		public var levelTf:TextField;
		public var dpTf:TextField;
		
		public var roleRBGroup:ExRadioButtonGroup;
		public var elderCheck:GuildExButtonCheckBox;
		public var captainCheck:GuildExButtonCheckBox;
		public var memberCheck:GuildExButtonCheckBox;
		
		public function GuildChangeRolePopup() 
		{
			FontUtil.setFont(nameTf, Font.ARIAL, true);
			FontUtil.setFont(levelTf, Font.ARIAL, true);
			FontUtil.setFont(dpTf, Font.ARIAL, true);
			roleRBGroup = new ExRadioButtonGroup();
		}
		
		override protected function okBtnClickHdl(e:Event):void 
		{
			if (!roleRBGroup.activeItem)
			{
				Manager.display.showMessage("Bạn chưa chọn chức vụ");
				return;
			}
			hide(PopupAction.OK);
		}
		
		public function updateRole(currentUserRoleId:int, memberInfo:GuMemberInfo):void
		{
			nameTf.text = memberInfo.strRoleName;
			levelTf.text = memberInfo.nLevel.toString();
			dpTf.text = memberInfo.nTotalDedicationPoint.toString();
			roleRBGroup.reset();
			elderCheck.lock();
			captainCheck.lock();
			memberCheck.lock();
			switch(currentUserRoleId)
			{
				case GuildRole.PRESIDENT:
					roleRBGroup.addItem(GuildRole.ELDER, elderCheck);
					roleRBGroup.addItem(GuildRole.CAPTAIN, captainCheck);
					roleRBGroup.addItem(GuildRole.MEMBER, memberCheck);
					break;
				case GuildRole.ELDER:
					roleRBGroup.addItem(GuildRole.CAPTAIN, captainCheck);
					roleRBGroup.addItem(GuildRole.MEMBER, memberCheck);
					break;
				case GuildRole.CAPTAIN:
					roleRBGroup.addItem(GuildRole.MEMBER, memberCheck);
					break;
				case GuildRole.MEMBER:
					break;
			}
			
			switch(memberInfo.nMemberType)
			{
				case GuildRole.ELDER:
					roleRBGroup.setActiveItem(0);
					break;
				case GuildRole.CAPTAIN:
					roleRBGroup.setActiveItem(1);
					break;
				case GuildRole.MEMBER:
					roleRBGroup.setActiveItem(2);
					break;
			}
		}
	}

}