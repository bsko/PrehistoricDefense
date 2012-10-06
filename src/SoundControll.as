package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLLoader
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	/**
	 * ...
	 * @author ...
	 */
	public class SoundControll
	{
		public static const MAX_SOUNDS:int = 10;
		public static const SOUNDS_VOLUME:int = 1;
		
		private var _sounds:Object = new Object();
		private var _music:Sound = new Sound();
		private var _hasSoundDevice:Boolean = false;
		private var _soundOn:Boolean;
		private var _soundsCounter:int = 0;
		private var _fightingSoundChannel:SoundChannel;
		private var _playingFightingSound:Boolean = false;
		
		public function Init():void 
		{
			if (Capabilities.hasAudio && Capabilities.hasMP3) {
				_hasSoundDevice = true;
				_soundsCounter = 0;
				_soundOn = true;
				var urlRequest:URLRequest;
				
				_sounds.click = new click();
				_sounds.level_begin = new level_begin();
				_sounds.wave_begin = new wave_begin();
				_sounds.win = new win();
				_sounds.loose = new loose();
				//towers
				_sounds.tower_death = new tower_death();
				_sounds.tower_install = new tower_install();
				_sounds.sling_stroke = new sling_stroke();
				_sounds.arrow_shooting = new arrow_shooting();
				_sounds.move_to_barrak = new move_to_barrak();
				_sounds.delete_tower = new delete_tower();
				_sounds.buff = new buff();
				_sounds.mage = new mage();
				//chests
				_sounds.get_key = new get_key();
				_sounds.open_chest_crystal = new open_chest_crystal();
				_sounds.open_chest_gold = new open_chest_gold();
				_sounds.open_chest_nothing = new open_chest_nothing();
				//hits
				_sounds.hit_axe = new hit_axe();
				_sounds.hit_sword = new hit_sword();
				_sounds.hit_flesh = new hit_flesh();
				_sounds.hit_stone = new hit_stone();
				_sounds.hit_blunt = new hit_blunt();
				_sounds.hit_molot = new hit_molot();
				_sounds.hit_big_stone = new hit_big_stone();
				//magic
				_sounds.stone_rain = new stone_rain_snd();
				_sounds.earthquake = new earthquake();
				_sounds.fireball = new fireball();
				_sounds.crystal = new crystal();
				_sounds.firerain = new firerain();
				_sounds.frostrain = new frostrain();
				_sounds.trap_install = new trap_install();
				_sounds.money = new money();
				_sounds.money_bags = new money_bags();
				_sounds.stone_appear = new stone_appear();
				_sounds.fall_down = new fall_down();
				_sounds.roots = new roots();
				//enemies
				_sounds.fear = new fear();
				_sounds.web = new web();
				_sounds.frog = new frog();
				//other
				_sounds.bleed = new bleed();
				_sounds.crit = new crit();
				_sounds.egg_splash = new egg_splash();
				_sounds.upgrade = new upgrade();
				_sounds.moving_hay = new moving_hay();
				_sounds.fight_in_camp = new fight_in_camp();
				_sounds.death = new death2();
				_sounds.no_action = new no_action();
			}
		}
		
		public function playSound(id:String):void 
		{
			if (_sounds[id]) {
				if (_hasSoundDevice && _soundOn && (_soundsCounter < MAX_SOUNDS)) {
					_soundsCounter++;
					var soundChannel:SoundChannel = _sounds[id].play(0, 0, new SoundTransform(SOUNDS_VOLUME));
					soundChannel.addEventListener(Event.SOUND_COMPLETE, onComplete, false, 0, false);
				}
			}
		}
		
		public function ChangeSoundMode():void
		{
			_soundOn = !_soundOn;
			if (!_soundOn)
			{
				if (_playingFightingSound)
				{
					stopFightingSound();
				}
			}
		}
		
		public function startFightingSound():void 
		{
			if (!_playingFightingSound && _soundOn) {
				_playingFightingSound = true;
				_fightingSoundChannel = _sounds.fight_in_camp.play();
				_fightingSoundChannel.addEventListener(Event.SOUND_COMPLETE, onCompleteFightingSound, false, 0, true);
			}
		}
		
		private function onCompleteFightingSound(e:Event):void 
		{
			if(_playingFightingSound) {
				_fightingSoundChannel.removeEventListener(Event.SOUND_COMPLETE, onCompleteFightingSound, false);
				_fightingSoundChannel = _sounds.fight_in_camp.play();
				_fightingSoundChannel.addEventListener(Event.SOUND_COMPLETE, onCompleteFightingSound, false, 0, true);
			}
		}
		
		public function stopFightingSound():void 
		{
			if (_playingFightingSound) {
				_fightingSoundChannel.removeEventListener(Event.SOUND_COMPLETE, onCompleteFightingSound, false);
				_fightingSoundChannel.stop();
				_playingFightingSound = false;
			}
		}
		
		private function onComplete(e:Event):void 
		{
			if(e.target is SoundChannel) {
				_soundsCounter--;
				(e.target as SoundChannel).removeEventListener(Event.SOUND_COMPLETE, onComplete);
			}
		}
	}

}