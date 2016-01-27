package game.data.xml 
{
	import game.data.model.ConversationModel;
	import game.data.model.TutorialActionModel;
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class TutorialXML extends XMLData 
	{
		public var sceneID				:int;
		public var name					:String;
		public var triggerConditionType	:int;
		public var triggerConditionValue:int;
		public var actions				:Array;
		
		override public function parseXML(xml:XML):void {
			super.parseXML(xml);
			sceneID = parseInt(xml.SceneID.toString());
			name = xml.Name.toString();
			triggerConditionType = parseInt(xml.TriggerConditionType.toString());
			triggerConditionValue = parseInt(xml.TriggerConditionValue.toString());
			
			actions = [];
			var actionsXMLList:XMLList = xml.Actions.Action as XMLList;
			for each (var actionXML:XML in actionsXMLList) {
				var action:TutorialActionModel = new TutorialActionModel();
				action.ID = parseInt(actionXML.ID.toString());
				action.name = actionXML.Name.toString();
				action.type = parseInt(actionXML.Type.toString());
				action.conversations = [];
				
				var contentXMLList:XMLList = actionXML.Contents.Content as XMLList;
				for each (var contentXML:XML in contentXMLList) {
					var conversation:ConversationModel = new ConversationModel();
					conversation.ID = parseInt(contentXML.ID.toString());
					conversation.animURL = contentXML.AnimURL.toString();
					conversation.animIndex = contentXML.AnimIndex.toString();
					conversation.nameURL = contentXML.ImgNameURL.toString();
					conversation.direction = parseInt(contentXML.Direction.toString());
					conversation.layerMask = parseInt(contentXML.LayerMask.toString());
					var texts:XMLList = contentXML.Conversations.Text as XMLList;
					for each (var text:XML in texts) {
						conversation.texts.push(text.toString());
					}
					action.conversations.push(conversation);
				}
				actions.push(action);
			}
		}
	}

}