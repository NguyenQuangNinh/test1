/**
 * http://wiki.developers.facebook.com/index.php/Events.edit
 * Feb 18/09
 */ 
/*
  Copyright (c) 2009, Adobe Systems Incorporated
  All rights reserved.

  Redistribution and use in source and binary forms, with or without 
  modification, are permitted provided that the following conditions are
  met:

  * Redistributions of source code must retain the above copyright notice, 
    this list of conditions and the following disclaimer.
  
  * Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the 
    documentation and/or other materials provided with the distribution.
  
  * Neither the name of Adobe Systems Incorporated nor the names of its 
    contributors may be used to endorse or promote products derived from 
    this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
  IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package com.facebook.commands.events {
	
	import com.facebook.net.FacebookCall;
	import com.facebook.utils.FacebookDataUtils;
	import com.facebook.facebook_internal;

	use namespace facebook_internal;

	/**
	 * The GetEvents class represents the public  
      Facebook API known as Events.get.
	 * @see http://wiki.developers.facebook.com/index.php/Events.get
	 */
	public class GetEvents extends FacebookCall {

		
		public static const METHOD_NAME:String = 'events.get';
		public static const SCHEMA:Array = ['uid', 'eids', 'start_time', 'end_time', 'rsvp_status'];
		
		public var uid:String;
		public var eids:Array;
		public var start_time:Date;
		public var end_time:Date;
		public var rsvp_status:String;
		
		public function GetEvents(uid:String = null, eids:Array = null, start_time:Date = null, end_time:Date = null, rsvp_status:String = null) {
			super(METHOD_NAME);
			
			this.uid = uid;
			this.eids = eids;
			this.start_time = start_time;
			this.end_time = end_time;
			this.rsvp_status = rsvp_status;
		}
		
		override facebook_internal function initialize():void {
			applySchema(SCHEMA, uid, FacebookDataUtils.toArrayString(eids), FacebookDataUtils.toDateString(start_time),  FacebookDataUtils.toDateString(end_time), rsvp_status);
			super.facebook_internal::initialize();
		}
	}
}