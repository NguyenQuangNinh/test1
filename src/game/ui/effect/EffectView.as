package game.ui.effect
{
	import com.greensock.easing.Back;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Ease;
	import com.greensock.easing.Expo;
	import com.greensock.TimelineLite;
	import com.greensock.TweenAlign;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import core.display.ViewBase;
	import core.Manager;
	import core.util.MovieClipUtils;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import game.enum.ItemType;
	import game.ui.components.ItemSlot;
	import game.ui.effect.gui.ItemSlotEffect;
	import game.ui.hud.HUDModule;
	import game.ui.ModuleID;
	
	/**
	 * ...
	 * @author
	 */
	public class EffectView extends ViewBase
	{
		
		private var itemCount:int = 0;
		private var pos:int = 0;
		private var _itemSlots:Array;
		private var _func:Function = null;
		
		public function EffectView()
		{
		
		}
		
		public function reset():void
		{
			_itemSlots = [];
			itemCount = 0;
			pos = 0;
			_func = null;
			MovieClipUtils.removeAllChildren(this);
		}
		
		public function actionTweenItem(itemSlot:ItemSlot, type:ItemType, onCompleteTween:Function):void
		{
			if (onCompleteTween != null)
				_func = onCompleteTween;
				
			itemCount = 1;	
			var itemEffect:ItemSlotEffect = new ItemSlotEffect();
			itemEffect.init(itemSlot);
			this.addChild(itemEffect);
			tweenItem(itemEffect, type, onCompleteTweenOneItem);
		}
		
		public function actionTweenItems(itemSlots:Array, onCompleteTween:Function, sync:Boolean = false, bonusX:int = 1):void
		{
			//temp filter 3 items EXP, GOLD, HONOR
			//Utility.log("num item effect before filter is " + itemSlots.length);
			/*var itemFilter:Array = []
			for each(var item:ItemSlot in itemSlots) {
				if (item.getItemType() != ItemType.EXP 
					&& item.getItemType() != ItemType.HONOR 
					&& item.getItemType() != ItemType.GOLD)
					itemFilter.push(item);
			}
			//Utility.log("num item effect after filter is " + itemFilter.length);
			
			//itemCount = itemSlots.length;
			itemCount = itemFilter.length;*/
			if (onCompleteTween != null)
				_func = onCompleteTween;
				
			itemCount = itemSlots.length;
			var itemEffect:ItemSlotEffect;					
			//action tween
			if (sync)
			{
				pos = 0;
				for each (var itemSlot:ItemSlot in itemSlots)
				//for each (var itemSlot:ItemSlot in itemFilter)
				{
					itemEffect = new ItemSlotEffect();
					itemEffect.init(itemSlot);
					this.addChild(itemEffect);
					tweenItem(itemEffect, itemSlot.getItemType(), onCompleteTweenSync);					
				}
			}
			else
			{
				pos = 0;
				_itemSlots = itemSlots;
				itemEffect = new ItemSlotEffect();
				itemEffect.init(_itemSlots[pos]);
				this.addChild(itemEffect);
				tweenItem(itemEffect, _itemSlots[pos].getItemType(), onCompleteTweenNoSync);
			}
		
		}
		
		private function onCompleteTweenNoSync(itemEffect:ItemSlotEffect):void
		{
			if (itemEffect)
				itemEffect.visible = false;
			pos++;
			if (pos >= itemCount) //stop tween
			{
				if (_func != null) //call func
				{
					_func();
				}
				//Utility.log( "EffectView.onCompleteTweenNoSync > itemEffect : " + itemCount );
				Manager.display.hideModule(ModuleID.EFFECT);
			}
			else // tween next item
			{
				var itemEffect:ItemSlotEffect = new ItemSlotEffect();
				itemEffect.init(_itemSlots[pos]);
				this.addChild(itemEffect);
				tweenItem(itemEffect, _itemSlots[pos].getItemType(), onCompleteTweenNoSync);
			}
		}
		
		private function onCompleteTweenSync(itemEffect:ItemSlotEffect):void
		{
			//Utility.log( "EffectView.onCompleteTweenSync > itemEffect : " + itemCount );
			pos++;
			if (pos >= itemCount) //stop tween
			{
				if (_func != null) //call func
				{
					_func();
				}
				Manager.display.hideModule(ModuleID.EFFECT);
			}
		}
		
		private function tweenItem(itemEffect:ItemSlotEffect, type:ItemType, onCompleteTween:Function = null):void
		{
			var target_x:int = 0;
			var target_y:int = 0;
			
			var bezier_x:int = 900;
			var bezier_y:int = 350;
			
			var positionBtnHUD:Point;
			var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
			if (!hudModule)
				return;
			switch (type)
			{
				case ItemType.UNIT: 
				case ItemType.ITEM_SHOP_HERO: 
					positionBtnHUD = hudModule.getPositionBtnByName("changeFormationBtn");
					if (positionBtnHUD)
					{
						target_x = positionBtnHUD.x + 10;
						target_y = positionBtnHUD.y;
					}
					//TweenMax.to(itemEffect, 3, {bezierThrough: [{x: bezier_x, y: bezier_y}, {x: target_x, y: target_y}], scaleX: 0.5, scaleY: 0.5, ease: Expo.easeOut, onComplete: onCompleteTween, onCompleteParams: [itemEffect]});
					//TweenMax.to(itemEffect, 2, { x: target_x, y: target_y, scaleX: 0.5, scaleY: 0.5,
												//ease: Expo.easeOut, onComplete: onCompleteTween, onCompleteParams: [itemEffect]});
					break;
				case ItemType.ITEM_SET: 
					positionBtnHUD = hudModule.getPositionBtnByName("inventoryBtn");
					if (positionBtnHUD)
					{
						target_x = positionBtnHUD.x + 10;
						target_y = positionBtnHUD.y;
					}
					//TweenMax.to(itemEffect, 3, {bezierThrough: [{x: bezier_x, y: bezier_y}, {x: target_x, y: target_y}], scaleX: 0.5, scaleY: 0.5, ease: Expo.easeOut, onComplete: onCompleteTween, onCompleteParams: [itemEffect]});					
					//TweenMax.to(itemEffect, 2, { x: target_x, y: target_y, scaleX: 0.5, scaleY: 0.5,
												//ease: Expo.easeOut, onComplete: onCompleteTween, onCompleteParams: [itemEffect]});
					break;
				case ItemType.ITEM_SOUL: 
				case ItemType.ITEM_BAD_SOUL: 
					positionBtnHUD = hudModule.getPositionBtnByName("soulBtn");
					if (positionBtnHUD)
					{
						target_x = positionBtnHUD.x + 10;
						target_y = positionBtnHUD.y;
					}
					//TweenMax.to(itemEffect, 3, {bezierThrough: [{x: bezier_x, y: bezier_y}, {x: target_x, y: target_y}], scaleX: 0.5, scaleY: 0.5, ease: Expo.easeOut, onComplete: onCompleteTween, onCompleteParams: [itemEffect]});
					//TweenMax.to(itemEffect, 2, { x: target_x, y: target_y, scaleX: 0.5, scaleY: 0.5,
												//ease: Expo.easeOut, onComplete: onCompleteTween, onCompleteParams: [itemEffect]});
					break;
				case ItemType.EXP: 
					target_x = 280;
					target_y = 25;
					//TweenMax.to(itemEffect, 3, {bezierThrough: [{x: bezier_x, y: bezier_y}, {x: target_x, y: target_y}], scaleX: 0.5, scaleY: 0.5, ease: Expo.easeOut, onComplete: onCompleteTween, onCompleteParams: [itemEffect]});
					//timeLine.addLabel("startSequence");
					/*var timeLine:TimelineLite = new TimelineLite( { onComplete: onCompleteTween, onCompleteParams: [itemEffect] } );					
					timeLine.insertMultiple([new TweenLite(itemEffect, 1, { x: itemEffect.x, y: itemEffect.y, scaleX: 1.5, scaleY: 1.5,
											ease: Back.easeOut,	glowFilter:{color:0xFFFF33, alpha:1, blurX:20, blurY:20, strength:2, quality:3}}),										
											new TweenLite(itemEffect, 1, { delay: 0.5, x: target_x, y: target_y, scaleX: 0.5, scaleY: 0.5,
											ease: Expo.easeOut})],
											0,
											TweenAlign.SEQUENCE,
											0.2);*/
					/*timeLine.append(new TweenLite(itemEffect, 3, { x: (target_x - itemEffect.x) / 2, y: (target_y - itemEffect.y) / 2,
													scaleX: 5, scaleY: 5 } ));
					timeLine.append(new TweenLite(itemEffect, 2, { x: target_x, y: target_y, scaleX: 0.5, scaleY: 0.5,
													ease: Expo.easeOut, onComplete: onCompleteTween, oncompleteParams: [itemEffect] } ));*/
					//TweenMax.to(itemEffect, 2, { x: target_x, y: target_y, scaleX: 0.5, scaleY: 0.5,
												//ease: Expo.easeOut, onComplete: onCompleteTween, onCompleteParams: [itemEffect]});
					break;
				case ItemType.AP: 
					target_x = 280;
					target_y = 35;
					//TweenMax.to(itemEffect, 3, {bezierThrough: [{x: bezier_x, y: bezier_y}, {x: target_x, y: target_y}], scaleX: 0.5, scaleY: 0.5, ease: Expo.easeOut, onComplete: onCompleteTween, onCompleteParams: [itemEffect]});
					//TweenMax.to(itemEffect, 2, { x: target_x, y: target_y, scaleX: 0.5, scaleY: 0.5,
												//ease: Expo.easeOut, onComplete: onCompleteTween, onCompleteParams: [itemEffect]});
					break;
				case ItemType.GOLD: 
					target_x = 330;
					target_y = 10;					
					//TweenMax.to(itemEffect, 3, {bezierThrough: [{x: bezier_x, y: bezier_y}, {x: target_x, y: target_y}], scaleX: 0.5, scaleY: 0.5, ease: Expo.easeOut, onComplete: onCompleteTween, onCompleteParams: [itemEffect]});
					//TweenMax.to(itemEffect, 2, { x: target_x, y: target_y, scaleX: 0.5, scaleY: 0.5,
												//ease: Expo.easeOut, onComplete: onCompleteTween, onCompleteParams: [itemEffect]});
					break;
				case ItemType.XU_KHOA: 
				case ItemType.XU: 
					target_x = 170;
					target_y = 10;
					//TweenMax.to(itemEffect, 3, {bezierThrough: [{x: bezier_x, y: bezier_y}, {x: target_x, y: target_y}], scaleX: 0.5, scaleY: 0.5, ease: Expo.easeOut, onComplete: onCompleteTween, onCompleteParams: [itemEffect]});
					//TweenMax.to(itemEffect, 2, { x: target_x, y: target_y, scaleX: 0.5, scaleY: 0.5,
												//ease: Expo.easeOut, onComplete: onCompleteTween, onCompleteParams: [itemEffect]});
					break;
				case ItemType.SCORE_QUEST_DAILY: 
					target_x = 120;
					target_y = 500;
					//TweenMax.to(itemEffect, 3, {bezierThrough: [{x: bezier_x, y: bezier_y}, {x: target_x, y: target_y}], scaleX: 0.5, scaleY: 0.5, ease: Expo.easeOut, onComplete: onCompleteTween, onCompleteParams: [itemEffect]});
					//TweenMax.to(itemEffect, 2, { x: target_x, y: target_y, scaleX: 0.5, scaleY: 0.5,
												//ease: Expo.easeOut, onComplete: onCompleteTween, onCompleteParams: [itemEffect]});
					break;
				case ItemType.HONOR: 
					target_x = 255;
					target_y = 10;
					//TweenMax.to(itemEffect, 3, {bezierThrough: [{x: bezier_x, y: bezier_y}, {x: target_x, y: target_y}], scaleX: 0.5, scaleY: 0.5, ease: Expo.easeOut, onComplete: onCompleteTween, onCompleteParams: [itemEffect]});
					//TweenMax.to(itemEffect, 2, { x: target_x, y: target_y, scaleX: 0.5, scaleY: 0.5,
												//ease: Expo.easeOut, onComplete: onCompleteTween, onCompleteParams: [itemEffect]});
					break;
				default: 
					positionBtnHUD = hudModule.getPositionBtnByName("inventoryBtn");
					if (positionBtnHUD)
					{
						target_x = positionBtnHUD.x + 10;
						target_y = positionBtnHUD.y;
					}
					//TweenMax.to(itemEffect, 3, {bezierThrough: [{x: bezier_x, y: bezier_y}, {x: target_x, y: target_y}], scaleX: 0.5, scaleY: 0.5, ease: Expo.easeOut, onComplete: onCompleteTween, onCompleteParams: [itemEffect]});
					//TweenMax.to(itemEffect, 2, { x: target_x, y: target_y, scaleX: 0.5, scaleY: 0.5,
												//ease: Expo.easeOut, onComplete: onCompleteTween, onCompleteParams: [itemEffect]});
					break;
			}
			//if(type == ItemType.EXP || type == ItemType.GOLD || type == ItemType.HONOR) {
				var timeLine:TimelineLite = new TimelineLite( { onComplete: onCompleteTween, onCompleteParams: [itemEffect] } );					
				timeLine.insertMultiple([new TweenLite(itemEffect, 0.8, { x: itemEffect.x, y: itemEffect.y, scaleX: 1.5, scaleY: 1.5,
										ease: Back.easeOut,	glowFilter:{color:0xFFFF33, alpha:1, blurX:20, blurY:20, strength:2, quality:3}}),										
										new TweenLite(itemEffect, 0.8, { delay: 0.3, x: target_x, y: target_y, scaleX: 0.5, scaleY: 0.5,
										ease: Expo.easeOut})],
										0,
										TweenAlign.SEQUENCE,
										0.2);
			//}
		}
		
		private function onCompleteTweenOneItem(itemEffect:ItemSlotEffect):void
		{
			//Utility.log( "EffectView.onCompleteTweenOneItem > itemEffect : " + itemCount);
			if (_func != null) //call func
			{
				_func();
			}
			Manager.display.hideModule(ModuleID.EFFECT);
		}
	}
}