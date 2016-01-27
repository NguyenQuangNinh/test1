package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.Game;
	import game.net.ResponsePacket;
	import game.ui.daily_task.DailyTaskType;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ResponseDailyTaskInfo extends ResponsePacket 
	{
		public var result	:Array = [];
		
		override public function decode(data:ByteArray):void {
			super.decode(data);
			
			var obj:Object;
			//reset chuc phuc
			obj = new Object();
			obj.type = DailyTaskType.COUNT_DOWN;
			data.readInt();
			//calculate o client
			var date:Date = new Date();
			obj.value1 = (24 + 9) * 60 * 60
						- (date.getHours() * 60 * 60)
						- (date.getMinutes() * 60)
						- (date.getSeconds())
						+ int(Game.database.userdata.serverTimeDifference / 1000);
			result.push(obj);
			
			//da tau
			obj = new Object();
			obj.type = DailyTaskType.INT;
			obj.value1 = data.readInt();
			obj.value2 = data.readInt();
			result.push(obj);
			
			//van tieu
			obj = new Object();
			obj.type = DailyTaskType.INT;
			obj.value1 = data.readInt();
			obj.value2 = data.readInt();
			result.push(obj);
			
			//thap cao thu
			obj = new Object();
			obj.type = DailyTaskType.INT;
			obj.value1 = data.readInt();
			obj.value2 = data.readInt();
			result.push(obj);
			
			//hoa son luan kiem
			obj = new Object();
			obj.type = DailyTaskType.COUNT_DOWN;
			obj.value1 = data.readInt();
			result.push(obj);
			
			//anh hung ai
			obj = new Object();
			obj.type = DailyTaskType.INT;
			obj.value1 = data.readInt();
			obj.value2 = data.readInt();
			result.push(obj);
			
			//boss the gioi
			obj = new Object();
			obj.type = DailyTaskType.BOOLEAN;
			obj.value1 = Game.database.userdata.worldBossEnable;
			result.push(obj);
			
			//menh khi
			obj = new Object();
			obj.type = DailyTaskType.INT;
			obj.value1 = data.readInt();
			obj.value2 = data.readInt();
			result.push(obj);
			
			//luyen kim
			obj = new Object();
			obj.type = DailyTaskType.INT;
			obj.value1 = data.readInt();
			obj.value2 = data.readInt();
			result.push(obj);
			
			//phuc hoi the luc
			obj = new Object();
			obj.type = DailyTaskType.INT;
			obj.value1 = data.readInt();
			obj.value2 = data.readInt();
			result.push(obj);
			
			//tam hung ky hiep
			obj = new Object();
			obj.type = DailyTaskType.INT;
			obj.value1 = data.readInt();
			obj.value2 = data.readInt();
			result.push(obj);
			
			//vo lam minh chu
			obj = new Object();
			obj.type = DailyTaskType.INT;
			obj.value1 = data.readInt();
			obj.value2 = data.readInt();
			result.push(obj);
			
			//boss the gioi
			obj = new Object();
			obj.type = DailyTaskType.ACTIVE;
			obj.value1 = !Game.database.userdata.attendanceChecked;
			result.push(obj);

			//Cho the luc
			obj = new Object();
			obj.type = DailyTaskType.INT;
			obj.value1 = data.readInt();
			obj.value2 = data.readInt();
			result.push(obj);

			//Nhan the luc
			obj = new Object();
			obj.type = DailyTaskType.INT;
			obj.value1 = data.readInt();
			obj.value2 = data.readInt();
			result.push(obj);
		}
	}

}