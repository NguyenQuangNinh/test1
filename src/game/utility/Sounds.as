package game.utility {
	import core.sound.SoundManager;
	import core.sound.SoundObject;
	import core.util.Utility;
	import flash.events.Event;
	import flash.media.SoundTransform;
	

	/**
	 * ...
	 * @author anhtinh
	 */
	
    public class Sounds extends Object {
       
		public static const BG_MUSIC: String = "bgMusic";
		public static const BG_MUSIC2: String = "bgMusic2";
		public static const EFFECT_1: String = "effect1";
		public static const EFFECT_2: String = "effect2";
		public static const EFFECT_3: String = "effect3";
		
		
		public static const SET_MUSIC: String = "set_music";
        public static const LOOPING: int = 999999;
		
        private static const ALL_SETS: Object = { 	set_forceLoad: ["bgMusic","bgMusic2","effect1", "effect2", "effect3"],
													set_music: ["bgMusic", "bgMusic2"]
												};
												
        private static const ALL_SOUNDS:Object = {  bgMusic: "resource/sounds/music/ThanDieuDaiHiep1995.mp3", 
													bgMusic2: "resource/sounds/music/bgMusic.mp3", 
													effect1:"resource/sounds/effect/effect1.mp3", 
													effect2:"resource/sounds/effect/effect2.mp3", 
													effect3:"resource/sounds/effect/effect3.mp3"
												 };
		
		/**
		 * set mute for all effect sounds from local setting (share object)
		 */
        public static function setSoundManagerSFXMute(): void {
            var sfxDisabled: Boolean = false;
            if (sfxDisabled) {
                SoundManager.mute();
            } else {
                SoundManager.unmute();
            }
        }
		
		/**
		 * set mute for background music from local setting (share object)
		 */
        public static function setSoundManagerMusicMute(): void {
            var musicDisabled: Boolean = false;
            if (musicDisabled) {
                SoundManager.pauseMusic();
            } else {
                SoundManager.unpauseMusic();
            }
        }
		
		/**
		 * First, init sound here
		 */
        public static function init(): void {
			
            setSoundManagerSFXMute();
            setSoundManagerMusicMute();
        }

        public static function startPostloading(): void {
            var url: String;
            var soundIDs: Array = ALL_SETS["set_forceLoad"] as Array;
            for each (var id: String in soundIDs) {
                url = ALL_SOUNDS[id];
                SoundManager.addSound(id, url, false);
            }
        }
		
		public static function loadSoundByName(soundName:String) : void {
            var url: String = ALL_SOUNDS[soundName];
            SoundManager.addSound(soundName, url, false);
        }
		/**
		 * Use this method to play effect sound 
		 * @param	id
		 * @param	startTime
		 * @param	loops
		 * @param	sndTransform
		 */
        public static function playSound(id: String, startTime :Number = 0, loops: int = 0, sndTransform : SoundTransform = null): void {
			
            var url: String;
			
            if (SoundManager.getSoundById(id) != null) {
                SoundManager.playSound(id, startTime, loops, sndTransform);
                
            } else {
                url = ALL_SOUNDS[id];
                if (url != null) {
                    SoundManager.addSound(id, url, false, function(event : Event) : void 
						{ 
							SoundManager.playSound(id, startTime, loops, sndTransform, false);
						});
                    
                } else {
					
					throw new Error("Sound not registered in Sounds.as: " + id);
                }
                
            }
        }
		
		/**
		 * Use this method to play background music sound 
		 * @param	id
		 * @param	startTime
		 * @param	loops
		 * @param	sndTransform
		 */
		public static function playMusic(id: String, startTime :Number = 0, sndTransform : SoundTransform = null) : void {
			
            var url: String;
			
            if (SoundManager.getSoundById(id) != null) {
				
                SoundManager.playSound(id, startTime, Sounds.LOOPING, sndTransform, true);
                
            } else {
				
                url = ALL_SOUNDS[id];
				
                if (url != null) {
                    SoundManager.addSound(id, url, false, function(event : Event) : void 
						{ 
							SoundManager.playSound(id, startTime, Sounds.LOOPING, sndTransform, true);
						} );
						
                } else {
					throw new Error("Sound not registered in Sounds.as: " + id);
                }
                
            }
		}

        public static function stop(soundObj: Object): void {
            if (!soundObj) {
                return;
            }
            if (soundObj is String && SoundManager.getSoundById(String(soundObj)) != null) {
                SoundManager.stopSoundByID(String(soundObj));
            } else if (soundObj is SoundObject) {
                (soundObj as SoundObject).stop();
            }
        }


    }
}
