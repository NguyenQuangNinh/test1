package game.ui.open_present_vip.gui
{
	import core.display.animation.Animator;
	import core.Manager;
	import core.util.Utility;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import game.data.model.item.IItemConfig;
	import game.data.model.item.ItemFactory;
	import game.data.xml.DataType;
	import game.data.xml.RewardXML;
	import game.enum.GameConfigID;
	import game.enum.ItemType;
	import game.enum.PlayerAttributeID;
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.ui.components.ItemSlot;
	import game.ui.lucky_gift.LuckyGiftView;
	import game.ui.open_present_vip.OpenPresentVipView;
	import game.ui.tooltip.TooltipID;
	import game.utility.UtilityEffect;
	
	/**
	 * ...
	 * @author xxx
	 */
	public class CellGiftVipContainer extends Sprite
	{
		
		private var _nRound:int = 8;
		private var _nDelay:int = 8;
		private var _pos:Array = [[1, 0], [1.7, 0.3], [2, 1], [1.7, 1.7], [1, 2], [0.3, 1.7], [0, 1], [0.3, 0.3]];
		private var _arrCellGift:Array;
		private var _myTimer:Timer;
		private var _currentIndex:int;
		private var _currentRound:int;
		private var _rewardIndex:int;
		
		private var _view:OpenPresentVipView;
		private var _activeAnim:Animator;
		
		private var _itemSlot:ItemSlot;
		private var _arrRewardID:Array = [];
		
		private function calDelay(x:int):int
		{
			return Math.round((x * x) + _nDelay);
		}
		
		public function CellGiftVipContainer(view:OpenPresentVipView)
		{
			_currentIndex = 0;
			_currentRound = -_nRound;
			
			_arrCellGift = new Array();
			_myTimer = new Timer(calDelay(_currentRound), _nRound * _nRound);
			_myTimer.addEventListener(TimerEvent.TIMER, timerListener);
			_view = view;
			_activeAnim = new Animator();
			_activeAnim.load("resource/anim/ui/hieuung_nhanqua.banim");
			
			this.addChildAt(_activeAnim, 0);
			_activeAnim.visible = false;
		
		}
		
		private function timerListener(e:TimerEvent):void
		{
			setCellStatus(_currentIndex, CellGiftVip.NORMAL);
			_currentIndex = (_currentIndex + 1) % _pos.length;
			setCellStatus(_currentIndex, CellGiftVip.ACTIVE);
			
			if (_currentIndex == _pos.length - 1)
			{
				_currentRound += 2;
				if (_currentRound < 0)
					_myTimer.delay = calDelay(_currentRound);
				else
					_myTimer.delay += calDelay(_currentRound + 3) * 2;
				trace("_currentRound:" + _currentRound);
				trace("_myTimer.delay:" + _myTimer.delay);
			}
			
			if (_currentRound == _nRound - 2)
			{
				if (_currentIndex == _rewardIndex)
				{
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_PLAYER_INFO_ATTRIBUTE, PlayerAttributeID.GOLD.ID));
					stopAnim();
					var cell:CellGiftVip = _arrCellGift[_currentIndex] as CellGiftVip;
					if (cell != null)
					{
						cell.status = CellGiftVip.NORMAL;
						_activeAnim.x = cell.x;
						_activeAnim.y = cell.y;
						_activeAnim.visible = true;
						_activeAnim.play(0, 0);
					}
					showReward();
				}
			}
		}
		
		public function init(arrRewardID:Array):void
		{
			reset();
			
			_arrRewardID = arrRewardID;
			// reset _arrCellGift
			for (var i:int = 0; i < _arrCellGift.length; i++)
			{
				var child:CellGiftVip = _arrCellGift[i] as CellGiftVip;
				this.removeChild(child);
				child.destroy();
			}
			_arrCellGift = [];
			
			for (i = 0; i < _arrRewardID.length && i < _pos.length; i++)
			{
				var rewardXml:RewardXML = Game.database.gamedata.getData(DataType.REWARD, _arrRewardID[i]) as RewardXML;
				if (rewardXml != null)
				{
					var cell:CellGiftVip = new CellGiftVip();
					cell.init(rewardXml.itemID, rewardXml.type, rewardXml.quantity);
					cell.x = _pos[i][0] * 150;
					cell.y = _pos[i][1] * 150;
					_arrCellGift.push(cell);
					this.addChild(cell);
				}
			}
		}
		
		private function setCellStatus(cellIndex:int, status:String):void
		{
			var cell:CellGiftVip = _arrCellGift[cellIndex] as CellGiftVip;
			if (cell != null)
				cell.status = status;
		}
		
		public function startAnim():void
		{
			_myTimer.reset();
			_myTimer.start();
		}
		
		public function stopAnim():void
		{
			//_view.btnOpen.mouseEnabled = true;
			//_view.closeBtn.mouseEnabled = true;
			_myTimer.stop();
		}
		
		public function reset():void
		{
			_myTimer.reset();
			setCellStatus(_currentIndex, CellGiftVip.NORMAL);
			_currentIndex = 0;
			_currentRound = -_nRound;
			_rewardIndex = -1;
			_activeAnim.visible = false;
			_myTimer.delay = calDelay(_currentRound);
		}
		
		public function get rewardIndex():int
		{
			return _rewardIndex;
		}
		
		public function set rewardIndex(value:int):void
		{
			_rewardIndex = value;
		}
		
		public function showReward():void
		{
			if (_arrRewardID && _rewardIndex >= 0 && _rewardIndex < _arrRewardID.length)
			{
				var rewardXml:RewardXML = Game.database.gamedata.getData(DataType.REWARD, _arrRewardID[_rewardIndex]) as RewardXML;
				if (rewardXml != null)
				{
					var item:IItemConfig = ItemFactory.buildItemConfig(rewardXml.type, rewardXml.itemID);
					if (item != null)
					{
						tweenItem(rewardXml.type, rewardXml.itemID, _rewardIndex, rewardXml.quantity);
						Manager.display.showMessage("Bạn nhận được " + rewardXml.quantity.toString() + " " + item.getName());
					}
					else
						Utility.log("ERROR: showRewardVip no itemID: " + rewardXml.itemID);
				}
				else
					Utility.log("ERROR: showRewardVip no itemID: " + _arrRewardID[_rewardIndex]);
			}
		}
		
		private function tweenItem(type:ItemType, id:int, index:int, quantity:int):void
		{
			_itemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
			_itemSlot.setConfigInfo(ItemFactory.buildItemConfig(type, id), TooltipID.ITEM_COMMON);
			_itemSlot.setQuantity(quantity);
			_itemSlot.x = _pos[index][0] * 150 + this.getRect(stage).x;
			_itemSlot.y = _pos[index][1] * 150 + this.getRect(stage).y;
			UtilityEffect.tweenItemEffect(_itemSlot, type, onCompletedFunc);
		}
		
		private function onCompletedFunc():void
		{
			if (_itemSlot)
			{
				_itemSlot.reset();
				Manager.pool.push(_itemSlot, ItemSlot);
			}
		}
	}

}