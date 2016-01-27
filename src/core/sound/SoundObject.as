package core.sound {
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	/**
	 * ...
	 * @author anhtinh
	 */
	
    public class SoundObject {
        public var sound:Sound;
        protected var m_soundChannel:SoundChannel;
        protected var m_pausePoint:Number = 0;
        protected var m_isPaused:Boolean = false;
        public var isMusic:Boolean = false;
		
        public function SoundObject(sound:Sound, soundChannel:SoundChannel) {
            this.sound = sound;
            this.m_soundChannel = soundChannel;
            this.m_soundChannel.addEventListener(Event.SOUND_COMPLETE, this.onComplete);
        }
		
        public function set volume(value:Number) : void {
            var soundTransform:SoundTransform = new SoundTransform(value, this.pan);
            this.m_soundChannel.soundTransform = soundTransform;
        }
		
        public function get volume() : Number {
            return this.m_soundChannel.soundTransform.volume;
        }
		
        public function set pan(panning:Number) : void {
            var soundTransform:SoundTransform = new SoundTransform(this.volume, panning);
            this.m_soundChannel.soundTransform = soundTransform;
        }
		
        public function get pan() : Number {
            return this.m_soundChannel.soundTransform.pan;
        }
		
        public function isPlaying() : Boolean {
            return this.m_isPaused == false;
        }
		
        public function pause() : void {
            if (this.m_isPaused == false) {
                this.m_pausePoint = this.m_soundChannel.position;
                this.m_soundChannel.stop();
                this.m_isPaused = true;
            }
        }
		
        public function unpause() : void {
            if (this.m_isPaused) {
                this.m_isPaused = false;
                this.m_soundChannel = this.sound.play(this.m_pausePoint, this.isMusic ? (9999) : (0), this.m_soundChannel.soundTransform);
                this.m_pausePoint = 0;
            }
        }
		
        public function stop(isDispatch:Boolean = true) : void {
            this.m_soundChannel.stop();
            if (isDispatch) {
                this.sound.dispatchEvent(new Event(Event.SOUND_COMPLETE));
            }
        }
		
        private function onComplete(event:Event) : void {
            this.sound.dispatchEvent(new Event(Event.SOUND_COMPLETE));
        }
    }
}
