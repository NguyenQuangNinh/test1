package core.sound {
	import core.event.EventEx;
	import core.util.Utility;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	/**
	 * ...
	 * @author anhtinh
	 */
	
    public class SoundManager {
		public static const NUM_PLAY_LOOP: int = 9999;
		
        private static var m_sounds:Dictionary = new Dictionary();
        private static var m_activeChannels:Array = [];
        private static var m_isMuted:Boolean = false;
		private static var m_isPauseMusic:Boolean;
		private static var m_currentMusicObject : SoundObject;
		private static var m_currentMusic : Sound;
		
        public function SoundManager() {
		
        }
		/**
		 * Load a sound 
		 * 
		 * @param	id : sound id
		 * @param	url : sound url
		 * @param	playOnLoad : play sound after load complete
		 * @param	onLoadComplete : a callback is executed when sound load complete
		 * @return a Sound object
		 */
		
        public static function addSound(id:String, url:String, playOnLoad:Boolean = true, onLoadComplete:Function = null, loop:int = 0, isMusic:Boolean = false) : Sound {
            var sound:Sound;
            var onLoadCompleteWrapper:Function;
			var onLoadCompleteAndPlayWrapper:Function;
			
            sound = m_sounds[id];
			// if sound is still Not loaded
            if (sound == null) {
                sound = new Sound();
                sound.addEventListener(Event.COMPLETE, onComplete);
                if (playOnLoad) {
                    //sound.addEventListener(Event.COMPLETE, playSoundOnComplete);	
					onLoadCompleteAndPlayWrapper = function (event:Event) : void {												
												onLoadCompleteAndPlay(new EventEx(Event.COMPLETE, {target: event.target, loop: loop, isMusic: isMusic}));												
												sound.removeEventListener(Event.COMPLETE, onLoadCompleteAndPlayWrapper);
											};
                    sound.addEventListener(Event.COMPLETE, onLoadCompleteAndPlayWrapper);
                }
				
                if (onLoadComplete != null) {
                    onLoadCompleteWrapper = function (event:Event) : void {
												onLoadComplete(event);
												sound.removeEventListener(Event.COMPLETE, onLoadCompleteWrapper);
											};
                    sound.addEventListener(Event.COMPLETE, onLoadCompleteWrapper);
                }
                sound.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
                sound.load(new URLRequest(url));
                m_sounds[id] = sound;
                Utility.log("Add sound, id: " + id + ", url: " + url);
            }
			
            return sound;
        }
		
        private static function onComplete(event:Event) : void {
            var sound:Sound = event.target as Sound;			
            Utility.log("Sound loaded: " + sound.url);
        }
		
		private static function onLoadCompleteAndPlay(event:EventEx):void {
			var sound:Sound = event.data.target as Sound;
			if (event.data.isMusic)
				conditionallyPlayMusic(sound, 0, event.data.loop);
			else 	
				conditionallyPlaySound(sound, 0, event.data.loop);
		}
		
		/*private static function playSoundOnComplete(event:Event) : void {
            var sound:Sound = event.target as Sound;
            sound.removeEventListener(Event.COMPLETE, playSoundOnComplete);
			
			if (sound) {
                conditionallyPlaySound(sound);
			}
        }*/
		
        private static function onIOError(event:Event) : void {
            var sound:Sound = event.target as Sound;
            Utility.error("Error loading sound: " + sound.toString() + " -- url : " + sound.url);
        }
		
		/**
		 * play a sound
		 * @param	id ; sound id
		 * @param	startTime : start position play
		 * @param	loops : num loops of sound, 
		 * @param	sndTransform
		 * @param	isMusic : indicate sound is background music (play whith infinite loop)
		 * @return
		 */
        public static function playSound(id:String, startTime:Number = 0, loops:int = 0, sndTransform:SoundTransform = null, isMusic:Boolean = false) : SoundObject {
            var sound:Sound = getSoundById(id);
            var soundObject:SoundObject = null;
			
            Utility.log("Play Sound: " + id + " (muted: " + isMuted() + ")");
            if (sound && sound.bytesLoaded > 0) {
				
				if (isMusic) {
					soundObject = conditionallyPlayMusic(sound, startTime, loops, sndTransform);
				}else {
					soundObject = conditionallyPlaySound(sound, startTime, loops, sndTransform);
				}
                
            }else {
				if (sound == null) {
					Utility.error("Sound: " + id + " is NOT exist, so can't play!");
				}else {
					Utility.error("Sound: " + id + " can NOT play because it still hasn't loaded yet");
				}
				
			}
            return soundObject;
        }
		
		/**
		 * if sound has already loaded, play it, otherwise load that sound and play it after load complete
		 * 
		 * @param	id : id (name) of sound
		 * @param	url : url of sound
		 */
        public static function addOrPlaySound(id:String, url:String, loop:int = 0, isMusic:Boolean = false) : void {
            if (getSoundById(id) != null) {
                playSound(id, 0, loop, null, isMusic);				
            } else {
                addSound(id, url, true, null, loop, isMusic);
            }
        }
		
		/**
		 * Stop a sound by id (name)
		 * 
		 * @param	id : id (name) of sound
		 */
        public static function stopSoundByID(id:String) : void {
            var soundObject:SoundObject = null;
            var sound:Sound = getSoundById(id);
            var i:int = 0;
			
            while (sound && i < m_activeChannels.length) {
                soundObject = m_activeChannels[i] as SoundObject;
                if (soundObject.sound.url == sound.url) {
                    soundObject.stop();
                }
                i++;
            }
        }
		
		/**
		 * Stop all sound
		 * 
		 */
        public static function stopAllSound() : void {
            var soundObject:SoundObject = null;
            var i:int = 0;
			
            while (i < m_activeChannels.length) {
                soundObject = m_activeChannels[i] as SoundObject;
				soundObject.stop();
                i++;
            }
        }
		
        private static function conditionallyPlaySound(sound:Sound, startTime:Number = 0, loops:int = 0, sndTransform:SoundTransform = null) : SoundObject {
			var soundChannel:SoundChannel = null;
            var soundObject:SoundObject = null;
			
            if (isMuted() == false) {
                soundChannel = sound.play(startTime, loops, sndTransform);
                if (soundChannel) {
                    soundObject = new SoundObject(sound, soundChannel);
                    soundObject.isMusic = false;
                    m_activeChannels.push(soundObject);
                    sound.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
                }
            }
			
            return soundObject;
        }
		
		private static function conditionallyPlayMusic(sound:Sound, startTime:Number = 0, loops:int = 0, sndTransform:SoundTransform = null) : SoundObject {
			var soundChannel:SoundChannel = null;
            var soundObject:SoundObject = null;
			
            if (isPauseMusic() == false) {
				if (m_currentMusicObject != null) {
					m_currentMusicObject.stop();
				}
                soundChannel = sound.play(startTime, loops, sndTransform);
                if (soundChannel) {
                    soundObject = new SoundObject(sound, soundChannel);
                    soundObject.isMusic = true;
					m_currentMusicObject = soundObject;
                    m_activeChannels.push(soundObject);
                    sound.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
                }
            }else {
				
				if (m_currentMusicObject != null) {
					m_currentMusicObject.stop();
					m_currentMusicObject = null;
				}
				
				m_currentMusic = sound;
			}
			
            return soundObject;
        }
		
        private static function onSoundComplete(event:Event) : void {
            var soundObject:SoundObject = null;
            var sound:Sound = event.target as Sound;
            var i:int = 0;
            while (i < m_activeChannels.length) {
                soundObject = m_activeChannels[i] as SoundObject;
                if (soundObject.sound.url == sound.url) {
                    m_activeChannels.splice(m_activeChannels.indexOf(soundObject), 1);
                    break;
                }
                i++;
            }
        }
		
        /**
         * get a sound by id
         * @param	id : sound id
         * @return Sound object
         */
        public static function getSoundById(id:String) : Sound {
            return m_sounds[id] as Sound;
        }
		
		public static function checkSoundPlayingByID(id:String): Boolean {
			var result:Boolean = false;
			var sound:Sound = getSoundById(id);
			var soundObject:SoundObject = null;
			if (sound) {
				for (var i:int = 0; i < m_activeChannels.length; i++) {
					soundObject = m_activeChannels[i] as SoundObject;
					if (soundObject && soundObject.sound.url == sound.url) {
						result = soundObject.isPlaying();
						break;
					}					
				}            
			}
			
			return result;
		}			
		
		public static function pauseMusic() : void {
			m_isPauseMusic = true;
			if (m_currentMusicObject != null) {
				m_currentMusicObject.pause();				
			}
		}
		
		public static function unpauseMusic() : void {
			m_isPauseMusic = false;
			
			if (m_currentMusicObject != null) {
				m_currentMusicObject.unpause();
				
			}else if (m_currentMusic != null){
				conditionallyPlayMusic(m_currentMusic, 0, 0, null) 
			}
			
		}
		
		public static function isPauseMusic() : Boolean {
			return m_isPauseMusic;
		}
		
		/**
		 * mute all effect sounds
		 */
        public static function mute() : void {
            var soundObject:SoundObject = null;
            m_isMuted = true;
			
            var i:int = 0;
            while (i < m_activeChannels.length) {
                soundObject = m_activeChannels[i] as SoundObject;
                if (soundObject /*&& soundObject.isMusic == false*/) {
                    soundObject.volume = 0;
                }
                i++;
            }
        }
		
		/**
		 * unmute all effect sounds
		 */
		
        public static function unmute() : void {
            var soundObject:SoundObject = null;
            m_isMuted = false;
			
            var i:int = 0;
            while (i < m_activeChannels.length) {
                soundObject = m_activeChannels[i] as SoundObject;
                if (soundObject /*&& soundObject.isMusic == false*/) {
                    soundObject.volume = 1;
                }
                i++;
            }
        }
		
		/**
		 * Toggle all effect sounds
		 */
        public static function toggleMute() : void {
            if (isMuted()) {
                unmute();
            } else {
                mute();
            }
        }
		
		/**
		 * get state of all effect sounds (mute or unmute)
		 * 
		 * @return state of all effect sounds
		 */
        public static function isMuted() : Boolean {
            return m_isMuted;
        }
		
        public static function chooseAndPlaySound(ids:Array) : void {
            var index:int = 0;
            var id:String = null;
			
            if (ids.length == 1) {
                id = ids[0] as String;
            } else if (ids.length > 0) {
                index = Math.floor(Math.random() * ids.length);
                id = ids[index] as String;
            }
			
            if (id != null) {
                playSound(id);
            }
        }
    }
}
