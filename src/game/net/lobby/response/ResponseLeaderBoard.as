package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	
	import flash.utils.ByteArray;
	
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.enum.LeaderBoardTypeEnum;
	import game.net.ResponsePacket;
	import game.ui.challenge_center.RankingRecordData;

	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ResponseLeaderBoard extends ResponsePacket
	{		
		public var players:Array = [];
		public var typeRequest:int;
		public var rankingRecords:Array = [];
		
		public function ResponseLeaderBoard() 
		{
			
		}
		
		override public function decode(data:ByteArray):void 
		{
			super.decode(data);
			typeRequest = data.readInt();
			if(typeRequest == LeaderBoardTypeEnum.HEROIC_TOWER.type)
			{
				var record:RankingRecordData;
				while(data.bytesAvailable > 0)
				{
					record = new RankingRecordData();
					record.playerID = data.readInt();
					record.maxFloor = data.readInt();
					record.name = ByteArrayEx(data).readString();
					record.rank = data.readInt();
					rankingRecords.push(record);
				}
			}
			else
			{
				var info:LobbyPlayerInfo;
				var index:int = 0;
				while (data && data.bytesAvailable > 0) {
					info = new LobbyPlayerInfo();
					info.index = index++;
					info.id = data.readInt();
					info.name = ByteArrayEx(data).readString();
					switch(typeRequest){
						case LeaderBoardTypeEnum.TOP_LEVEL.type:
							info.level = data.readInt();	
							break;
						case LeaderBoardTypeEnum.TOP_1vs1_AI.type:
							info.level = data.readInt();
							break;
						case LeaderBoardTypeEnum.TOP_1VS1_MM.type:
						case LeaderBoardTypeEnum.TOP_3VS3_MM.type:
						case LeaderBoardTypeEnum.TOP_2VS2_MM.type:
						case LeaderBoardTypeEnum.DICE.type:
							info.eloScore = data.readInt();
							info.rank = data.readInt();
							break;
						/*case LeaderBoardTypeEnum.TOP_CHAMPIONSHIP:
							info.rank = data.readInt();
							info.championPoint = data.readInt();
							break;*/
						case LeaderBoardTypeEnum.TOP_DAMAGE.type:
							info.damage = data.readInt(); //TrungLMN
							break;
						default:
							break;
					}				
					players.push(info);
				}
			}
		}
	}

}