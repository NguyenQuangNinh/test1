package game.net.lobby.request 
{
import core.util.Utility;

import flash.utils.ByteArray;
import flash.utils.getQualifiedClassName;

import game.net.RequestPacket;

public class RequestDivineWeaponArrayPacket extends RequestPacket
	{
        public var arrValue:Array;
		public function RequestDivineWeaponArrayPacket(requestType:int, arrInput:Array)
		{
			super(requestType);
            this.arrValue = arrInput;
		}
		
		override public function encode():ByteArray 
		{
			var data:ByteArray = super.encode();
			for each (var value:* in this.arrValue){
                var dataType:String = getQualifiedClassName(value);
                switch (dataType){
                    case "int":
                        data.writeInt(value);
                        break
                    case "Boolean":
                        data.writeBoolean(value);
                        break;
                    default :
                        Utility.log("DivineWeapon RequestPacket wrong data!!!");
                        return null;
                }
            }
			return data;
		}	
	}

	
		
}