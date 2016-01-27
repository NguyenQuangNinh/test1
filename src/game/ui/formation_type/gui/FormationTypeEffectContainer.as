package game.ui.formation_type.gui
{
	import flash.display.MovieClip;
	import game.data.vo.formation.FormationStat;
	import game.data.vo.formation_type.FormationEffectInfo;
	import game.data.xml.FormationTypeXML;
	import game.Game;
	import game.ui.components.ScrollbarEx;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class FormationTypeEffectContainer extends MovieClip
	{
		public var contentMask:MovieClip;
		public var track:MovieClip;
		public var slider:MovieClip;
		
		private var _contentScrollBar:MovieClip = new MovieClip();
		private var _arrFormationTypeEffect:Array = [];
		
		private var scrollbar:ScrollbarEx;
		
		public function FormationTypeEffectContainer()
		{
			contentMask.visible = false;
			scrollbar = new ScrollbarEx();
			_contentScrollBar.x = 0;
			_contentScrollBar.y = 0;
			this.addChild(_contentScrollBar);
		}
		
		public function init(formationTypeXML:FormationTypeXML, levelFormationType:int, level:int):void
		{
			
			while (_contentScrollBar.numChildren > 0)
			{
				_contentScrollBar.removeChildAt(0);
			}
			_arrFormationTypeEffect = [];
			
			var index:int = 0;
			var posY:int = 0;
			
			var formationStat:FormationStat = Game.database.userdata.formationStat;
			var bUsing:Boolean = formationTypeXML.ID == formationStat.ID; //current using
			
			for each (var formationEffectInfo:FormationEffectInfo in formationTypeXML.effects)
			{
				var ftItem:FormationTypeEffect = new FormationTypeEffect();
				
				ftItem.init(formationEffectInfo, index++, levelFormationType, level, bUsing);
				ftItem.y = posY;
				posY += ftItem.height + 5;
				_contentScrollBar.addChild(ftItem);
				_arrFormationTypeEffect.push(ftItem);
			}
			
			scrollbar.init(_contentScrollBar, contentMask, track, slider);
			scrollbar.verifyHeight();
		}
		
		public function reset():void
		{
			_contentScrollBar.x = 0;
			_contentScrollBar.y = 0;
			track.y = 0;
			slider.y = 0;
			while (_contentScrollBar.numChildren > 0)
			{
				_contentScrollBar.removeChildAt(0);
			}
			_arrFormationTypeEffect = [];
		}
	
		
		public function reUpdate(bUsing:Boolean):void
		{
			for each (var ftItem:FormationTypeEffect in _arrFormationTypeEffect)
			{
				if (ftItem)
				{
					ftItem.reUpdate(bUsing);
				}
			}
		}
	}

}