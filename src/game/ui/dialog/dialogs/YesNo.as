package game.ui.dialog.dialogs 
{
	import core.Manager;
	import core.util.Enum;
	import core.util.FontUtil;
	import core.util.MovieClipUtils;
	import core.util.TextFieldUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import game.data.model.item.IItemConfig;
	import game.data.model.item.ItemFactory;
	import game.data.xml.DataType;
	import game.data.xml.ModeConfigXML;
	import game.data.xml.RewardXML;
	import game.enum.DialogEventType;
	import game.enum.Font;
	import game.enum.GameMode;
	import game.enum.HeroicHardMode;
	import game.enum.ItemType;
	import game.Game;
	import game.net.lobby.response.ResponseRequestToPlayGame;
	import game.ui.arena.RewardModeInfoElement;
	import game.ui.components.CheckBox;
	import game.ui.components.ItemSlot;
	import game.ui.components.Reward;
	import game.ui.heroic.world_map.CampaignData;
	import game.ui.tooltip.TooltipID;
	import game.utility.GameUtil;
	import game.utility.UtilityEffect;
	/**
	 * ...
	 * @author ...
	 */
	public class YesNo extends Dialog 
	{
		public static const YES		:int = 1;
		public static const NO		:int = 2;
		public static const CLOSE	:int = 4;
		public static const NAP_XU:int = 8;
		public static const METAL_FURNACE:int = 16;
		public static const DONT_ASK:int = 32;

		public var messageTf: TextField;		
		public var titleTf: TextField;		
		public var closeBtn:SimpleButton;
		public var purchaseBtn:SimpleButton;
		public var metalFurnaceBtn:SimpleButton;
		//private var _subTitleTf: TextField;		
		public var dontAskMov:MovieClip;

		private var _container:MovieClip;
		
		private static const MAX_ITEM_PER_ROW:int = 3;
		private static const DISTANCE_X_PER_ITEM:int = 40 * 3;
		private static const DISTANCE_Y_PER_ITEM:int = -5;
		
		private static const SPACE_LENGTH:int = 20;
		
		private var _item:RewardModeInfoElement;
		private var _rewardSlotArr:Array = [];
		
		public function YesNo() 
		{
			/*if (stage) 
				init();
			else addEventListener(Event.ADDED_TO_STAGE, init);	*/
			//set font
			FontUtil.setFont(messageTf, Font.ARIAL, false);
			FontUtil.setFont(titleTf, Font.ARIAL, true);
			
			/*_subTitleTf = TextFieldUtil.createTextfield("Arial", 22, 250, 50 , 0xFFFFFF, true);
			_subTitleTf.filters = messageTf.filters;
			FontUtil.setFont(_subTitleTf, Font.ARIAL);
			addChild(_subTitleTf);*/
			
			//set container
			_container = new MovieClip();
			_container.x = messageTf.x + 45;
			_container.y = messageTf.y;
			addChild(_container);
			
			var itemConfig:IItemConfig = ItemFactory.buildItemConfig(ItemType.XU, 0) as IItemConfig;
			_item = new RewardModeInfoElement();
			_item.scaleX = _item.scaleY = 1.2;
			_item.y = messageTf.y - 5;
			_item.setConfigInfo(itemConfig);
			_item.visible = false;
			//if(itemConfig) {
				//_item.setQuantity(rewardXML.quantity);
				//_item.x = i * DISTANCE_X_PER_REWARD_ITEM;
				//dailyContainer.addChild(rewardItem);
			//}
			addChild(_item);
			
			closeBtn.addEventListener(MouseEvent.CLICK, onCloseClickHdl);
			purchaseBtn.addEventListener(MouseEvent.CLICK, onPurchaseClickHdl);
			metalFurnaceBtn.addEventListener(MouseEvent.CLICK, onMetalFurnaceClickHdl);
			dontAskCheckbox.addEventListener(CheckBox.CHANGED, onCheckboxChangeHdl);
		}

		private function onCheckboxChangeHdl(event:Event):void
		{
			data.dontAsk = dontAskCheckbox.isChecked();
		}
		
		private function onMetalFurnaceClickHdl(e:MouseEvent):void 
		{
			onOK(null);
		}
		
		private function onPurchaseClickHdl(e:MouseEvent):void 
		{
			onOK(null);
		}
		
		private function onCloseClickHdl(e:MouseEvent):void 
		{
			close();
		}
		
		/*private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			initUI();
		}
		
		private function initUI():void 
		{
			
		}*/
		
		override protected function onOK(event:Event = null):void 
		{
			super.onOK(event);
			
			if (_container.numChildren > 0) {
				var child:Reward;
				var childPos:Point;
				//var childType:ItemType;					
				
				for (var i:int = 0; i < _container.numChildren; i++) {
					child = _container.getChildAt(i) as Reward;
					//childType = child.getItemConfig().getType();
					childPos = child.getGlobalPos();
					var itemSlot:ItemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
					if (/*childType && */itemSlot) {					
						itemSlot.reset();
						itemSlot.x = childPos.x;
						itemSlot.y = childPos.y;
						itemSlot.setConfigInfo(child.getItemConfig(), TooltipID.ITEM_COMMON);
						_rewardSlotArr.push(itemSlot);
					}
				}
				
				UtilityEffect.tweenItemEffects(_rewardSlotArr, onShowEffectCompleted, true);
			}
			
		}
		
		private function onShowEffectCompleted():void 
		{
			for each(var slot:ItemSlot in _rewardSlotArr) {
				Manager.pool.push(slot, ItemSlot);
			}
			
			_rewardSlotArr = [];
		}
		
		override public function onShow():void {
			//reset UI
			//MovieClipUtils.removeAllChildren(_container);
			while (_container.numChildren > 0) {
				var child:Reward = _container.getChildAt(0) as Reward;
				child.destroy();
				_container.removeChild(child);
			}
			setTitle("");
			messageTf.text = "";
			//_subsetTitle("";
			_item.setQuantity(0);
			_item.visible = false;
			gotoAndStop("confirm");
			okBtn.visible = true;
			cancelBtn.visible = true;
			closeBtn.visible = true;
			purchaseBtn.visible = false;
			metalFurnaceBtn.visible = false;
			
			if (!(data.option & NO))
			{
				okBtn.x = (okBtnPos + cancelBtnPos) / 2;
				cancelBtn.visible = false;
				okBtn.visible = true;
			}
			else
			{
				okBtn.x = okBtnPos;
				cancelBtn.x = cancelBtnPos;
				cancelBtn.visible = true;
				okBtn.visible = true;
			}

			if(data.option & DONT_ASK)
			{
				dontAskMov.visible = true;
				dontAskCheckbox.setChecked(false);
			}
			else
			{
				dontAskMov.visible = false;
			}

			if (data) {
				var subString:String = "";
				switch(data.type) {
					case DialogEventType.INVITE_TO_PLAY_GAME_YN:
						trace("yes no dialog: invite to play game");
						setTitle("Mời chơi game");
						var packet:ResponseRequestToPlayGame = data.packet as ResponseRequestToPlayGame;
						if (packet) {
							var message:String = packet.nameInvite + " mời bạn vào chơi ở phòng " + packet.roomID + ".\nChế độ: ";							
							var modeXMLs:Dictionary = Game.database.gamedata.getTable(DataType.MODE_CONFIG);
							for each(var modeXML:ModeConfigXML in modeXMLs) {
								if (modeXML.ID == packet.mode.ID) {
									message += modeXML.name;
									break;
								}
							}
							
							if (packet.mode == GameMode.PVE_HEROIC) {
								var maxStep:int = 0;
								message += "Anh Hùng Ải.\nBản Đồ: ";
								var campaignData:CampaignData = Game.database.gamedata.getHeroicConfig(packet.heroicCampaignID);
								if (campaignData) {
									message += campaignData.name;
									message += "\nĐộ Khó: " + HeroicHardMode(Enum.getEnum(HeroicHardMode, packet.heroicCampaignDifficultyLevel)).name;
									message += "\nẢi: " + (packet.heroicCampaignStep + 1) + "/" + campaignData.missionIDs[packet.heroicCampaignDifficultyLevel].length;
								}
							}
							messageTf.text = message;
						}
						
						break;
					case DialogEventType.CONFIRM_CHALLENGE_PLAYER_PVP1vs1_AI:
						setTitle("Thách đấu");
						messageTf.text = "Bạn có muốn đấu với người này không ?";
						break;
					case DialogEventType.REQUEST_CHANGE_LOBBY_SLOT_YN:
						messageTf.text = data.name + " yêu cầu đổi chổ với bạn ";
						break;
					case DialogEventType.CONFIRM_UPGRADE_SOUL:
						setTitle("Nâng Cấp Mệnh Khí");
						messageTf.text = data.name + " là mệnh khí hiếm, bạn có muốn dùng làm nguyên liệu ?";
						break;
					case DialogEventType.CONFIRM_ADD_HP_POTION:
						setTitle("Hồi Máu");
						_item.setQuantity(data.cost);
						//messageTf.text = "Bạn có muốn dùng " + data.xu + " xu để hồi máu ngay ?";
						messageTf.text = "Bạn có muốn dùng ";
						//_subsetTitle(" để hồi máu ngay ?";
						subString = " để hồi máu ngay ?";
						/*_item.x = messageTf.x + messageTf.textWidth + 2;
						_item.y = messageTf.y + 5;
						_item.visible = true;
						_subTitleTf.x = _item.x + _item.width + 2;
						_subTitleTf.y = _item.y;*/
						break;
					case DialogEventType.CONFIRM_ADD_ACTION_POINT:
						setTitle("Hồi AP");
						messageTf.text = "Bạn có muốn dùng " + data.xu + " xu để hồi AP ngay ?";
						break;
					case DialogEventType.CONFIRM_UNLOCK_INVENTORY_SLOT:
						setTitle("Mở Rộng Kho");
						//messageTf.text = "Bạn có muốn dùng " + data.xu + " xu để mở khóa " + data.slot + " ô ?";
						_item.setQuantity(data.xu);
						messageTf.text = "Bạn có muốn dùng ";
						//_subsetTitle(" để mở khóa " + data.slot + " ô ?";
						subString = " để mở khóa " + data.slot + " ô ?";
						/*_item.x = messageTf.x + messageTf.textWidth + 2;
						_item.y = messageTf.y + 5;
						_item.visible = true;
						_subTitleTf.x = _item.x + _item.width + 2;
						_subTitleTf.y = _item.y;*/
						break;
					case DialogEventType.CONFIRM_UNLOCK_SOUL_SLOT:
						setTitle("Mở Rộng Khí Mệnh");
						//messageTf.text = "Bạn có muốn dùng " + data.xu + " xu để mở khóa " + data.slot + " ô ?";
						_item.setQuantity(data.xu);
						messageTf.text = "Bạn có muốn dùng ";
						//_subsetTitle(" để mở khóa " + data.slot + " ô ?";
						subString = " để mở khóa " + data.slot + " ô ?";
						/*_item.x = messageTf.x + messageTf.textWidth + 2;
						_item.y = messageTf.y + 5;
						_item.visible = true;
						_subTitleTf.x = _item.x + _item.width - 5;
						_subTitleTf.y = _item.y;*/
						break;
					case DialogEventType.CONFIRM_SAVE_FORMATION_CHALLENGE:
						setTitle("Lưu trận");
						messageTf.text = "Không cập nhật thông tin đội hình, đồng ý thoát ?";
						break;
					case DialogEventType.CONFIRM_SKIP_COUNT_DOWN_PVP1vs1_AI:
						setTitle("Tua nhanh");
						//messageTf.text = "Bạn có muốn dùng " + data.cost + " xu bỏ qua thời gian không ?";
						_item.setQuantity(data.cost);
						messageTf.text = "Đợi hết thời gian mới thách đấu được.\nDùng ";
						//_subsetTitle(" để bỏ qua thời gian không ?";
						subString = " để thách đấu ngay ?";
						break;
					case DialogEventType.CONFIRM_SKIP_LIMIT_PLAY_DAILY_PVP1vs1_AI:
						/*Nội dung pop up mua thêm lượt : 
						Có thể mua <số lượt còn lại> lượt đấu
						Trả < số xu + icon vàng> để đấu?*/
						setTitle("Thêm lượt");
						//messageTf.text = "Đã đến giới hạn số lần chơi trong ngày, bạn có đồng ý trả thêm " + data.cost + " xu để đấu với người này không ?";
						_item.setQuantity(data.cost);
						messageTf.text = "\t\tCó thể mua " + data.exist.toString() + " lượt đấu.\n\t\tTrả";
						//_subsetTitle(" để đấu tiếp không ?";
						subString = " để đấu ?";
						break;	
					case DialogEventType.CONFIRM_SKIP_LIMIT_PLAY_DAILY_PVP1vs1_MM:
						setTitle("Thêm lượt");
						//messageTf.text = "Đã đến giới hạn số lần chơi trong ngày, bạn có đồng ý trả thêm " + data.cost + " xu để chơi tiếp không ?";
						_item.setQuantity(data.cost);
						messageTf.text = "Bạn có đồng ý trả thêm ";
						//_subsetTitle(" để chơi tiếp không ?";
						subString = " để chơi tiếp không ?";
						break;	
					case DialogEventType.CONFIRM_REFRESH_TIME_DAILY_QUEST:
						setTitle("Tua nhanh");
						//messageTf.text = "Bạn có muốn dùng " + data.cost + " xu để bỏ qua thời gian chờ không?";
						_item.setQuantity(data.cost);
						messageTf.text = "Bạn có muốn dùng ";
						//_subsetTitle(" để bỏ qua thời gian chờ không ?";
						subString = " để bỏ qua thời gian chờ không ?";
						break;
					case DialogEventType.CONFIRM_FINISH_DAILY_QUEST:
						setTitle("Hoàn thành nhanh");
						//messageTf.text = "Bạn có muốn dùng " + data.cost + " xu để hoàn thành nhanh nhiệm vụ không?";
						_item.setQuantity(data.cost);
						messageTf.text = "Các hạ có muốn dùng ";
						//_subsetTitle(" để hoàn thành nhiệm vụ không ?";
						subString = " để hoàn thành nhiệm vụ nhanh không ?";
						break;
					case DialogEventType.CONFIRM_FINISH_GIFT_ONLINE:
						setTitle("Quà Online");
						_item.setQuantity(data.xu);
						messageTf.text = "Bạn có muốn dùng ";
						//_subsetTitle(" để nhận ngay quà tặng online không ?";
						subString = " để nhận ngay quà tặng online không ?";
						break;
					case DialogEventType.CONFIRM_RECEIVE_REWARD_QUEST_DAILY:
						gotoAndStop("normal");
						setTitle("Dã tẩu thưởng tích lũy");
						messageTf.text = "";
						
						//init reward UI
						var rewards:Array = [];
						for (var i:int = 0; i < data.rewards.length; i++) {
							rewards = (GameUtil.getItemRewardsByID(data.rewards[i]));
						}
						//rewards = rewards.concat(rewards);
						//rewards = rewards.concat(rewards);
						//rewards = rewards.concat(rewards);
						for (i = 0; i < rewards.length; i++) {
							var reward:Reward = new Reward();
							reward.changeType(Reward.QUEST);
							_container.addChild(reward);
							reward.x = DISTANCE_X_PER_ITEM * (i % MAX_ITEM_PER_ROW);
							reward.y = (DISTANCE_Y_PER_ITEM + reward.height) * (int) (i / MAX_ITEM_PER_ROW);
							reward.updateInfo((rewards[i] as RewardXML).getItemInfo(), (rewards[i] as RewardXML).quantity);
						}
						
						break;
					case DialogEventType.CONFIRM_PURCHASE_RESOURCE:
						/*gotoAndStop("purchase");
						setTitle("Thông báo";
						messageTf.text = "Bạn có đồng ý trả thêm tiền " + "\n Còn " + data.exist.toString() + " lượt có thể mua";*/
						
						
						
						break;
					case DialogEventType.CONFIRM_CLEAR_QUEST_TRANSPORT:
						setTitle("TÌM NHIỆM VỤ");
						messageTf.text = "Bạn có thật sự muốn bỏ qua các nhiệm vụ hiện tại để tìm nhiệm vụ mới hay không?";
						break;
                    case DialogEventType.CONFIRM_UNLOCK_DW_INVENTORY:
                        setTitle("Rương Thần Binh");
                        _item.setQuantity(data.xu);
                        messageTf.text = "Bạn muốn dùng ";
                        subString = " để mở khóa " + data.slot + " ô ?";
                        break;
					default:
						setTitle((data.title != null ? data.title : "Thông báo"));
						messageTf.htmlText = data.message;
						FontUtil.setFont(messageTf, Font.ARIAL, false);
						okBtn.visible 		= (data.option & YES  ) != 0;
						cancelBtn.visible 	= (data.option & NO   ) != 0;
						closeBtn.visible 	= (data.option & CLOSE) != 0;
						purchaseBtn.visible	= (data.option & NAP_XU) != 0;
						
						metalFurnaceBtn.visible	= (data.option & METAL_FURNACE) != 0;
						break;
				}
				
				if (_item.getQuantity() != 0) {
					var mcX:int= messageTf.x + messageTf.getLineMetrics(messageTf.numLines - 1).width;
					var mcY:int = messageTf.y + messageTf.textHeight - (messageTf.getTextFormat().size as int) - 5;
					
					//_item.x = messageTf.x + messageTf.textWidth + 5;
					//_item.y = messageTf.y + messageTf.textHeight ;
					_item.x = mcX + 10;
					_item.y = mcY ;
					_item.visible = true;
				}
				
				if (subString != "") {
					//_subTitleTf.x = _item.x + _item.width - 10;
					var numSpaceAdd:int = _item.width / SPACE_LENGTH + 15;
					//_subTitleTf.y = messageTf.y;
					for (var count:int = 0; count < numSpaceAdd; count++) {
						subString = " " + subString;
					}
					messageTf.appendText(subString);
				}
			}
		}
		
		private function setTitle(str:String):void {
			titleTf.text = str.toUpperCase();
		}

		private function get dontAskCheckbox():CheckBox
		{
			return dontAskMov.checkbox as CheckBox;
		}
	}

}