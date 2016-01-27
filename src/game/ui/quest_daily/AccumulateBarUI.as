package game.ui.quest_daily 
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenAlign;
	import com.greensock.TweenLite;
	import core.display.animation.Animator;
	import core.util.MovieClipUtils;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import game.data.xml.DataType;
	import game.data.xml.LevelQuestDailyXML;
	import game.data.xml.RewardXML;
	import game.Game;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class AccumulateBarUI extends MovieClip
	{
		public static const RECEIVE_ACCUMULATE_REWARD:String = "receiveAccumulateRewards";
		
		public var maskMov:MovieClip;
		public var barMov:MovieClip;
		public var bgMov:MovieClip;
		
		private var _currentPoint:int;
		private var _targetPoint:MovieClip;
		
		private var _data:LevelQuestDailyXML;
		private var _rewardsContainer:MovieClip;
		
		private var _moreTween:Boolean = false;
		
		private static const BAR_LENGTH:int = 1000;
		
		private var _effectReachAccumulate:Animator;
		private var _currentReceiveIndex:int = -1;
		
		public function AccumulateBarUI() 
		{
			initUI();
		}
		
		public function initUI():void {
			//prepare UI			
//			_targetPoint = new (etDefinitionByName("Target") as Class)();
			_targetPoint = new MovieClip();
			_targetPoint.y = maskMov.y + (maskMov.height - _targetPoint.height) / 2;
			addChild(_targetPoint);
			
			_rewardsContainer = new MovieClip();
			addChild(_rewardsContainer);
			
			barMov.mask = maskMov;
			maskMov.scaleX = 0;			
			
			_effectReachAccumulate = new Animator();
			_effectReachAccumulate.visible = false;
			_effectReachAccumulate.load("resource/anim/ui/fx_motinhnang.banim");
			_effectReachAccumulate.addEventListener(Event.COMPLETE, onEffectPlayCompletedHdl);
			addChild(_effectReachAccumulate);
			
			bgMov.mouseEnabled = false;
		}		
		
		private function onEffectPlayCompletedHdl(e:Event):void 
		{
			//Utility.log( "AccumulateBarUI.onEffectPlayCompletedHdl > e : ");
			_effectReachAccumulate.visible = false;
			//dispatchEvent(new Event(RECEIVE_ACCUMULATE_REWARD, true));
		}
		
		public function setAccumulatePoint(point:int, indexAccumulated:int, noTween:Boolean = false):void {
			//Utility.log( "AccumulateBarUI.setAccumulatePoint > point : " + point + ", indexAccumulated : " + indexAccumulated + ", noTween : " + noTween );
			if (_data) {		
				var maxScore:int = _data.arrScore[_data.arrScore.length - 1];
				
				for (var i:int = 0; i < _rewardsContainer.numChildren; i++) {
					var pointReceive:PointReceiveUI = _rewardsContainer.getChildAt(i) as PointReceiveUI;
					pointReceive.setReceived(indexAccumulated >= i);
				}
				
				_moreTween = point < _currentPoint ? true : false;
				//Utility.log("tween to target point " + point + " with index accumulate " + indexAccumulated);
				var nextPoint:int = maskMov.x + point / maxScore * BAR_LENGTH - _targetPoint.width / 2;
				
				var pointTimeLine:TimelineLite = new TimelineLite();
				var maskTimeLine:TimelineLite = new TimelineLite();				
				var targetTimeLine:TimelineLite = new TimelineLite( { onUpdate: onTweenProgress, onUpdateParams :
											[/*_currentReceiveIndex == -1 || _currentReceiveIndex == indexAccumulated*/] } );
				if (_moreTween) {
					//Utility.log("first tween to full");
					pointTimeLine.append(new TweenLite(this, noTween ? 0 : 1, { currentPoint: maxScore + 1,
							onComplete:function():void {
								_moreTween = false;
								_currentPoint = 0;
							}} ));
					maskTimeLine.append(new TweenLite(maskMov, noTween ? 0 : 1, { scaleX: 1,
							onComplete:function():void {
								_moreTween = false;
								maskMov.scaleX = 0; 
							} } ));	
					targetTimeLine.append(TweenLite.to(_targetPoint, noTween ? 0 : 1,
							{ x: (maskMov.x + BAR_LENGTH - _targetPoint.width / 2),
							onComplete:function():void {
								_moreTween = false;
								_targetPoint.x = maskMov.y + (maskMov.height - _targetPoint.height) / 2;
							} } ));
							
				}
				pointTimeLine.append(TweenLite.to(this, noTween ? 0 : 1, { delay:_moreTween ? 1 : 0, currentPoint: point } ));				
				maskTimeLine.append(TweenLite.to(maskMov, noTween ? 0 : 1, { delay:_moreTween ? 1 : 0, scaleX: point / maxScore } ));				
				targetTimeLine.append(TweenLite.to(_targetPoint, noTween ? 0 : 1, { delay: _moreTween ? 1 : 0, x: nextPoint } ));				
				//_currentReceiveIndex = indexAccumulated;
				//_currentPoint = point;
				/*if (!_moreTween) {
					Utility.log("tween to next point " + point);
					TweenLite.to(maskMov, noTween ? 0 : 0.5, {scaleX: point / maxScore} );
					TweenLite.to(_targetPoint, noTween ? 0 : 0.5, {x: nextPoint} );
				}else {
					Utility.log("tween to next and back point " + point);
					TweenLite.to(maskMov, noTween ? 0 : 0.5, { scaleX: 1,
							onComplete:function():void {
								_moreTween = false;
								maskMov.scaleX = 0;
								TweenLite.to(maskMov, noTween ? 0 : 0.5, {scaleX: point / maxScore} );
							}} );
					TweenLite.to(_targetPoint, noTween ? 0 : 0.5,
							{ x: (maskMov.x + BAR_LENGTH - _targetPoint.width / 2),
							onComplete:function():void {
								_moreTween = false;
								_targetPoint.x = 0;
								TweenLite.to(_targetPoint, noTween ? 0 : 0.5, {x: nextPoint} );
							} });
				}*/
			}
		}
		
		private function onTweenProgress (/*index:int, *//*noChange:Boolean*/):void {
			//if (noChange /*|| index < 0 || index >= _rewardsContainer.numChildren*/) 
				//return;
				
			var index:int = _data.arrScore.indexOf(_currentPoint) != -1 ? _data.arrScore.indexOf(_currentPoint) : -1;
			//Utility.log( "AccumulateBarUI.onTweenProgress > e : " + _currentPoint + " // " + index);
			var pointReceive:PointReceiveUI = index > -1 ? _rewardsContainer.getChildAt(index) as PointReceiveUI : null;
			if (pointReceive && _currentReceiveIndex != index) {
				//Utility.log("point receive is: " + index);
				_currentReceiveIndex = index;
				_effectReachAccumulate.x = pointReceive.x;
				_effectReachAccumulate.y = pointReceive.y + pointReceive.height * 2 / 3;
				_effectReachAccumulate.visible = true;
				_effectReachAccumulate.play(0, 1);
				
				//point receive tween effect
				pointReceive.showEffect();
			}
		}
		
		public function updateRewardAccumulate(data:LevelQuestDailyXML):void {
			_data = data;
			if (data) {
				//MovieClipUtils.removeAllChildren(_rewardsContainer);
				while (_rewardsContainer.numChildren > 0) {
					var child:PointReceiveUI = _rewardsContainer.getChildAt(0) as PointReceiveUI;
					child.destroy();
					_rewardsContainer.removeChild(child);
				}
				
				var numPoint:int = data.arrScore.length;
				var maxScore:int = data.arrScore[numPoint - 1];
				
				for (var i:int = 0; i < numPoint; i++ ) {
					var point:int = data.arrScore[i];
					var pointReceive:PointReceiveUI = new PointReceiveUI();
					pointReceive.x = maskMov.x + point / maxScore * BAR_LENGTH - 8;
					var rewardXML:RewardXML = Game.database.gamedata.getData(DataType.REWARD, data.arrRewardByScore[i]) as RewardXML;
					pointReceive.y = maskMov.y - 5;
					pointReceive.setValue(point, rewardXML);
					pointReceive.setReceived(false);
					_rewardsContainer.addChild(pointReceive);
				}
			}
		}
		
		public function get currentPoint():int {
			return _currentPoint;
		}
		
		public function set currentPoint(point:int):void {
			_currentPoint = point;
		}
	}

}