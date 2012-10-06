package  
{
	import Events.SoundsControlEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.system.Capabilities;
	
	/**
	 * ...
	 * @author GG.Gurov - samoh
	 */
	public class SoundsManager extends EventDispatcher
	{
		private var _onChangeMusicMode:SoundsControlEvent = new SoundsControlEvent(SoundsControlEvent.CHANGE_MUSIC_MODE);
		private var _onChangeSoundsMode:SoundsControlEvent = new SoundsControlEvent(SoundsControlEvent.CHANGE_SOUNDS_MODE);
		public static const MUSIC_STEP:Number = 0.05;
		
		private var _musicOn:Boolean = false;
		private var _soundsOn:Boolean = false;
		private var _haveMediaDevice:Boolean = false;
		private var _sounds:Object = new Object();
		private var _musics:Object = new Object();
		private var _currentMusicId:String = null;
		private var _nextMusicId:String = null;
		private var _musicChanel:SoundChannel;
		private var _musicTransform:SoundTransform = new SoundTransform(0);
		private var playingFlag:Boolean;
		private var waterSoundChanel:SoundChannel;
		
		
		public function initSounds():void {
			if (Capabilities.hasAudio && Capabilities.hasMP3) {
				_haveMediaDevice = true;
				changeSoundsMode();
				changeMusicMode();
				_musics.MenuTheme = new prehistorik_menu_theme();
				_musics.GameTheme = new prehistoric_ingame_theme();
				
				
				/*_sounds.ClickMenu = new ClickMenu(); //++
				_sounds.FailedBuilding = new FailedBuilding(); //++
				_sounds.FanDeath = new FanDeath(); //++
				_sounds.Fighting = new Fighting(); //++
				_sounds.GranatoShoot = new GranatoShoot(); //++
				_sounds.HealSound = new HealSound(); //++
				_sounds.HelicopterSound = new HelicopterSound(); //++
				_sounds.HitSound = new HitSound(); //++
				_sounds.LooseSound = new LooseSound();
				_sounds.MoneySound = new MoneySound(); //++
				_sounds.PistolShoot = new PistolShoot(); //++
				_sounds.ReloadSound = new ReloadSound(); //++
				_sounds.ShockerShoot = new ShockerShoot(); //++
				_sounds.TowerUpgrade = new TowerUpgrade(); //++
				_sounds.Watertank = new Watertank(); //++
				_sounds.WaveStart = new WaveStart(); //++
				_sounds.WinSound = new WinSound(); //++
				_sounds.TowerUpgrade = new TowerUpgrade();*/
			}
		}
		
		private function upVolume(e:Event):void {
            _musicTransform.volume += MUSIC_STEP;
            if (_musicTransform.volume > 1.0) {
                _musicTransform.volume = 1.0;
                App.rootMC.removeEventListener(Event.ENTER_FRAME, upVolume, false);
            }
            if (_haveMediaDevice && _musicOn) {
                _musicChanel.soundTransform = _musicTransform;
            }
            if (_nextMusicId != null) {
                App.rootMC.removeEventListener(Event.ENTER_FRAME, upVolume, false);
                App.rootMC.addEventListener(Event.ENTER_FRAME, downVolume, false, 0, true);
            }
        }
		
		private function downVolume(e:Event):void {
			_musicTransform.volume -= MUSIC_STEP;
			if (_musicTransform.volume < 0.0) {
				_musicTransform.volume = 0.0;
				App.rootMC.removeEventListener(Event.ENTER_FRAME, downVolume, false);
				if (_nextMusicId != null) {
					_currentMusicId = _nextMusicId;
					_nextMusicId = null;
					initMusic(_currentMusicId);
				}
			}
			if (_haveMediaDevice && _musicOn) {
				_musicChanel.soundTransform = _musicTransform;
			}
		}
		
		public function setMusic(id:String):void {
			if (_currentMusicId != null) {
				_nextMusicId = id;
				App.rootMC.addEventListener(Event.ENTER_FRAME, downVolume, false, 0, true);
			} else {
				_currentMusicId = id;
				initMusic(_currentMusicId);
			}
		}
		
		private function initMusic(id:String):void {
			if (_musicChanel != null) {
				_musicChanel.stop();
			}
			var tmpMusic:Sound = _musics[id];
			_musicChanel = tmpMusic.play(0, int.MAX_VALUE, _musicTransform);
			App.rootMC.addEventListener(Event.ENTER_FRAME, upVolume, false, 0, true);
		}
		
		public function playSound(id:String):void {
			if(_haveMediaDevice && _soundsOn) {
				var tmpSound:Sound = _sounds[id];
				var soundChanel:SoundChannel = tmpSound.play(0, 0, new SoundTransform(0.2));
			}
		}
		
		public function changeSoundsMode():void {
			if(_haveMediaDevice) {
				_soundsOn = !_soundsOn;
				_onChangeSoundsMode.soundStatus = _soundsOn;
				dispatchEvent(_onChangeSoundsMode);
			}
		}
		
		public function changeMusicMode():void {
			if (_haveMediaDevice) {
				_musicOn = !_musicOn;
				_onChangeMusicMode.soundStatus = _musicOn;
				dispatchEvent(_onChangeMusicMode);
				if (_musicOn) {
					playMusic();
				} else {
					muteMusic();
				}
			}
		}
		
		public function muteMusic():void {
			if(_musicChanel != null) {
				_musicChanel.soundTransform = new SoundTransform(0);
			}
		}
		
		public function playMusic():void {
			if(_musicChanel != null) { 
				_musicChanel.soundTransform = _musicTransform;
			}
		}
		
		public function get haveMediaDevice():Boolean { return _haveMediaDevice; }
		
		public function get musicOn():Boolean { return _musicOn; }
		
		public function get soundsOn():Boolean { return _soundsOn; }
	}

}