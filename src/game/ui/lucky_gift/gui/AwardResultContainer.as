package game.ui.lucky_gift.gui 
{
	import com.greensock.TweenMax;
	import components.scroll.VerScroll;
	import core.Manager;
	import core.memory.MemoryPool;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import game.data.xml.DataType;
	import game.data.xml.RewardXML;
	import game.Game;
	import game.enum.GameConfigID;
	import game.utility.UtilityUI;
	/**
	 * ...
	 * @author vu anh
	 */
	public class AwardResultContainer extends MovieClip
	{
		public var awardList:Array;
		public var masker:MovieClip;
		public var scrollMov:MovieClip;
		public var vScroller:VerScroll;
		public var awardContent:Sprite;
		public var closeBtn:SimpleButton;
		public function AwardResultContainer() 
		{
			awardList = new Array();
			awardContent = new Sprite();
			addChild(awardContent);
			vScroller = new VerScroll(masker, awardContent, scrollMov);
			awardContent.mask = masker;
			awardContent.x = masker.x;
			awardContent.y = masker.y;
			closeBtn.addEventListener(MouseEvent.CLICK, closeHandler);
		}
		
		public function closeHandler(e:MouseEvent):void 
		{
			fadeOut();
		}
		
		public function initCellGiftList(awardIndexes:Array):void
		{
			reset();
			var COL:int = 6;
			var startPos:Point = new Point(14, 18);
			var pos:Point = startPos.clone();
			var arrRewardIDs:Array = Game.database.gamedata.getConfigData(GameConfigID.REWARD_LUCKY_GIFT_LIST) as Array;
			for (var i:int = 0; i < awardIndexes.length; i++)
			{
				var rewardXml:RewardXML = Game.database.gamedata.getData(DataType.REWARD, arrRewardIDs[awardIndexes[i]]) as RewardXML;
				
				if (rewardXml != null)
				{
					var item:CellGift = Manager.pool.pop(CellGift) as CellGift;
					item.init(rewardXml.itemID, rewardXml.type, rewardXml.quantity);
					item.bg.visible = true;
					item.x = pos.x;
					item.y = pos.y;
			
					awardList.push(item);
					awardContent.addChild(item);
					
					if ((i + 1) % COL == 0) 
					{
						pos.x = startPos.x;
						pos.y += 88;
					}
					else pos.x += 88;
				}
			}
			vScroller.updateScroll(awardContent.height + 30);
		}
		
		public function reset():void 
		{
			for (var i:int = 0; i < awardList.length; i++)
			{
				var child:CellGift = awardList[i] as CellGift;
				child.destroy();
				
				awardContent.removeChild(child);
				Manager.pool.push(child, CellGift);
			}
			awardList = new Array();
		}
		
		public function fadeIn():void
		{
			this.visible = true;
			this.alpha = 0;
			TweenMax.to(this, 0.5, {alpha: 1});
		}
		
		public function fadeOut():void
		{
			this.visible = false;
		}
	}

}