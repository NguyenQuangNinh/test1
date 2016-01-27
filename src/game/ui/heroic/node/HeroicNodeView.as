package game.ui.heroic.node
{
	import com.greensock.easing.Back;
	import com.greensock.TweenMax;
	import core.display.animation.Animator;
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import game.data.gamemode.ModeDataPVEHeroic;
	import game.data.model.Character;
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.enum.CharacterAnimation;
	import game.enum.Font;
	import game.enum.GameMode;
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	import game.ui.dialog.DialogID;
	import game.ui.dialog.dialogs.YesNo;
	import game.ui.heroic.world_map.CampaignData;
	import game.ui.ModuleID;
	import game.utility.UtilityUI;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class HeroicNodeView extends ViewBase
	{
		private static const MAX_FORMATION_SLOTS:int = 6;
		
		public var btnBack				:SimpleButton;
		public var btnInviteFriend		:SimpleButton;
		public var btnKickConfirm		:SimpleButton;
		public var formationContainer	:MovieClip;
		public var nodeContainer		:MovieClip;
		public var movNodes				:MovieClip;
		public var movKickItemContainer	:MovieClip;
		public var txtName				:TextField;
		
		private var nodeDict			:Dictionary;
		private var formation			:Array;
		private var nodesIndex			:Array;
		private var kickItems			:Array;
		private var lastNodesIndex		:int;
		private var timer				:Timer;
		private var timerFrom			:int;
		private var timerTo				:int;
		private var kickPlayerID		:int;
		
		public function HeroicNodeView() {
			nodeDict = new Dictionary();
			formation = [];
			nodesIndex = [];
			kickItems = [];
			lastNodesIndex = 0;
			kickPlayerID = -1;
			
			timer = new Timer(150, 0);
			timer.addEventListener(TimerEvent.TIMER, onUpdateTimerHdl);
			timer.stop();
			timerFrom = timerTo = 0;
			
			initUI();
			initHandlers();
		}
		
		public function setName(value:String):void {
			txtName.text = value;	
		}
		
		public function updateNodeUI(arr:Array):void {
		/*	for each (var node:HeroicNode in nodeDict) {
				if (node && node.parent) {
					node.parent.removeChild(node);	
				}
				node = null;
			}
			
			var i:int = 0;
			var nodeContainerLength:int = nodeContainer.numChildren;
			var nodeIndex:int;
			nodesIndex = [];
			for each (var missionID:int in arr) {
				node = new HeroicNode();
				node.setData(missionID);
				nodeIndex = Math.floor(nodeContainerLength / arr.length) * i;
				nodesIndex.push(nodeIndex);
				node.x = nodeContainer.getChildAt(nodeIndex).x - 50;
				node.y = nodeContainer.getChildAt(nodeIndex).y - node.height;
				
				i++;
				movNodes.addChild(node);
				nodeDict[missionID] = node;
			}
			
			if (nodesIndex[nodesIndex.length - 1] != null) {
				nodesIndex[nodesIndex.length - 1] = nodeContainer.numChildren - 1;
			}
			if (node != null) {
				node.x = nodeContainer.getChildAt(nodeContainer.numChildren - 1).x - node.width / 2;
				node.y = nodeContainer.getChildAt(nodeContainer.numChildren - 1).y - node.height;
			}
			updateFormation();
			updateStatus([]);*/
		}
		
		public function updateFormation():void {
			var lobbyPlayers:Array = ModeDataPVEHeroic(Game.database.userdata.getModeData(GameMode.PVE_HEROIC)).getPlayers();
			var i:int = 0;
			var animCount:int = 0;
			var playerIndex:int;
			for each (var formationIndex:int in ModeDataPVEHeroic(Game.database.userdata.getModeData(GameMode.PVE_HEROIC)).formationIndex) {
				var anim:Animator = formation[i];
				anim.reset();
				if (anim.parent == formationContainer) {
					formationContainer.removeChild(anim);	
				}
				if (formationIndex != -1) {
					playerIndex = Math.floor(formationIndex / 2);
					for each (var lobbyPlayer:LobbyPlayerInfo in lobbyPlayers) {
						if (lobbyPlayer && (lobbyPlayer.index == playerIndex)) {
							var character:Character = lobbyPlayer.characters[formationIndex % 2];
							var sex:int = lobbyPlayer.charactersSex[formationIndex % 2];
							if (character && character.xmlData) {
								character.sex = sex;	
								anim.load(character.xmlData.animURLs[character.sex]);
								anim.x = animCount * 50;
								formationContainer.addChild(anim);
								
								animCount ++;
							}	
							
							break;
						}
					}
					
				}
				i++;
			}
			
			if (lobbyPlayers.length == 3 && (lobbyPlayers.indexOf(null) == -1)) {
				enableBtn(false, btnInviteFriend, onBtnClickHdl);
			} else {
				enableBtn(true, btnInviteFriend, onBtnClickHdl);
			}
			
			updateKickPlayersList();
		}
		
		public function updateStatus(arr:Array):void {
			/*var lastNode:HeroicNode;
			for each (var missionID:int in arr) {
				lastNode = nodeDict[missionID];
				if (lastNode != null) {
					lastNode.setNodeEnable(false);
				}
			}
			
			if ((arr.length > lastNodesIndex) && (arr.length < nodesIndex.length)) {
				for each (var anim:Animator in formation) {
					if (anim && (anim.parent == formationContainer)) {
						anim.play(CharacterAnimation.RUN);
					}
				}
				timerFrom = nodesIndex[lastNodesIndex];
				timerTo = nodesIndex[arr.length];
				timer.start();
				lastNodesIndex = arr.length;	
			}
			
			if (lastNode != null) {
				var nextMissionID:int = lastNode.getData().nextMissionID;
				if (nodeDict[nextMissionID] == null) {
					var caveID:int = ModeDataPVEHeroic(Game.database.userdata.getModeData(GameMode.PVE_HEROIC)).caveID;
					var data:CampaignData = Game.database.gamedata.getHeroicConfig(caveID);
					if (data) {
						Manager.display.showDialog(DialogID.GLOBAL_BOSS_CONFIRM, onDialogConfirmHdl, null, 
												{content:"Chúc mừng bạn đã hoàn thành ải " + data.name + ". Nhấn Đồng Ý để tiếp tục." }, Layer.BLOCK_BLACK);
					}
				} else {
					nodeDict[nextMissionID].isNextNode(true);
				}
			} else {
				formationContainer.x = 265;
				formationContainer.y = 285;
				HeroicNode(movNodes.getChildAt(0)).isNextNode(true);
			}
			
			updateKickPlayersList();*/
		}
		
		private function enableBtn(value:Boolean, btn:SimpleButton, listener:Function):void {
			if (value) {
				TweenMax.to(btn, 0, { colorMatrixFilter: { saturation:1.0 }} );
				btn.mouseEnabled = true;
				if (!btn.hasEventListener(MouseEvent.CLICK)) {
					btn.addEventListener(MouseEvent.CLICK, listener);
				}	
			} else {
				TweenMax.to(btn, 0, { colorMatrixFilter: { saturation:0.05 }} );
				btn.mouseEnabled = false;
				if (btn.hasEventListener(MouseEvent.CLICK)) {
					btn.removeEventListener(MouseEvent.CLICK, listener);
				}	
			}
		}
		
		private function updateKickPlayersList():void {
			enableBtn(true, btnKickConfirm, onBtnClickHdl);
			for each (var kickItem:KickItem in kickItems) {
				if (kickItem && kickItem.parent == movKickItemContainer) {
					movKickItemContainer.removeChild(kickItem);
					kickItem.reset();
					kickItem = null;
				}
			}
			kickItems.splice(0);
			
			var row:int = 0;
			for each (var lobbyPlayerInfo:LobbyPlayerInfo in ModeDataPVEHeroic(Game.database.userdata.getModeData(GameMode.PVE_HEROIC)).getPlayers()) {
				kickItem = new KickItem();
				kickItem.setData(lobbyPlayerInfo);
				kickItem.y = 40 + row * 30;
				kickItem.x = 10;
				kickItems.push(kickItem);
				kickItem.addEventListener(KickItem.SELECTED, onKickItemSelectedHdl);
				movKickItemContainer.addChild(kickItem);
				
				row ++;
			}
		}
		
		private function onKickItemSelectedHdl(e:EventEx):void {
			if (e.data.id != -1) {
				for each (var kickItem:KickItem in kickItems) {
					if (kickItem && (kickItem != e.target as KickItem)) {
						kickItem.setSelect(false);
					}
				}
				
				KickItem(e.target).setSelect(true);	
			} else {
				for each (kickItem in kickItems) {
					kickItem.setSelect(false);
				}
			}
			kickPlayerID = e.data.id;
		}
		
		private function onUpdateTimerHdl(e:TimerEvent):void {
			if (timerFrom < timerTo) {
				MovieClip(nodeContainer.getChildAt(timerFrom)).gotoAndStop(2);
				TweenMax.to(formationContainer, 0.15, { x:nodeContainer.getChildAt(timerFrom).x,
													y:nodeContainer.getChildAt(timerFrom).y} );	
				timerFrom ++;
			} else {
				timerFrom = timerTo = 0;
				timer.stop();
				for each (var anim:Animator in formation) {
					if (anim && (anim.parent == formationContainer)) {
						anim.play(CharacterAnimation.STAND);
					}
				}
			}
		}
		
		private function reset():void {
			for each (var anim:Animator in formation) {
				if (anim && (anim.parent == formationContainer)) {
					formationContainer.removeChild(anim);
				}
			}
			
			updateStatus([]);
		}
		
		private function onDialogConfirmHdl(data:Object):void {
			reset();
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.LEAVE_GAME));
			Manager.display.to(ModuleID.HEROIC_MAP);
		}
	
		private function initUI():void {
			btnBack = UtilityUI.getComponent(UtilityUI.BACK_BTN) as SimpleButton;
			var btnBackPos:Point = UtilityUI.getComponentPosition(UtilityUI.BACK_BTN) as Point;
			btnBack.x = btnBackPos.x;
			btnBack.y = btnBackPos.y;
			addChild(btnBack);
			
			formationContainer.mouseChildren = false;
			formationContainer.mouseEnabled = false;
			
			FontUtil.setFont(txtName, Font.ARIAL, true);
			
			var anim:Animator;
			for (var i:int = 0; i < MAX_FORMATION_SLOTS; i++) {
				anim = new Animator();
				anim.addEventListener(Animator.LOADED, onAnimLoadedHdl);
				formation.push(anim);
				formationContainer.addChild(anim);
			}
			
			TweenMax.to(formationContainer, 0.5, { x:100, y:250 } );
		}
		
		private function onAnimLoadedHdl(e:Event):void {
			var anim:Animator = e.target as Animator;
			if (anim) {
				anim.play(CharacterAnimation.STAND);
			}
		}
		
		private function initHandlers():void {
			btnBack.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			btnInviteFriend.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			btnKickConfirm.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
		}
		
		private function onBtnClickHdl(e:MouseEvent):void {
			switch(e.target) {
				case btnBack:
					Manager.display.to(ModuleID.HEROIC_LOBBY);
					break;
					
				case btnInviteFriend:
					Manager.display.showModule(ModuleID.INVITE_PLAYER, new Point(0, 0), LayerManager.LAYER_POPUP,
							"top_left",Layer.BLOCK_BLACK, {moduleID:ModuleID.HEROIC_NODE});
					break;
					
				case btnKickConfirm:
					if (kickPlayerID != -1) {
						Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.HEROIC_KICK, kickPlayerID));
						enableBtn(false, btnKickConfirm, onBtnClickHdl);
					}
					break;
			}
		}
	}

}