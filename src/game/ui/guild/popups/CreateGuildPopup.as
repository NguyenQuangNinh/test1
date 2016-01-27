package game.ui.guild.popups 
{
	import components.popups.OKCancelPopup;
	import core.Manager;
	import core.util.FontUtil;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import game.data.model.item.IItemConfig;
	import game.data.model.item.ItemFactory;
	import game.data.xml.GameConfig;
	import game.enum.Font;
	import game.enum.GameConfigID;
	import game.enum.ItemType;
	import game.Game;
	import game.ui.components.ItemSlot;
	/**
	 * ...
	 * @author vu anh
	 */
	public class CreateGuildPopup extends OKCancelPopup
	{
		public var createBtn:SimpleButton;
		public var nameTf:TextField;
		public function CreateGuildPopup() 
		{
			FontUtil.setFont(nameTf, Font.ARIAL, true);
			FontUtil.setFont(messageTf, Font.ARIAL, true);
			var slot:ItemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
			var itemConfig:IItemConfig = ItemFactory.buildItemConfig(ItemType.GOLD, 0) as IItemConfig;
			slot.setConfigInfo(itemConfig);
			slot.x = 290;
			slot.y = 135;
			slot.scaleX = slot.scaleY = 0.8;
			addChild(slot);
			messageTf.text = "Tạo bang hội cần " + Game.database.gamedata.getConfigData(GameConfigID.GUILD_CREATE_XU_PRICE) + "             , bạn đồng ý tạo?";
		}
		
	}

}