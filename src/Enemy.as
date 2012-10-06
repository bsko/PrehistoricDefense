package  
{
	import Enemies.BlueDino;
	import Enemies.Doublelegged;
	import Enemies.Flying;
	import Enemies.Frog;
	import Enemies.Kaban;
	import Enemies.Rat;
	import Enemies.SaberTooth;
	import Enemies.Spider;
	import Enemies.Thorner;
	import Enemies.Web;
	import Events.PauseEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import Magic.Chest;
	import Magic.LightningStrike;
	import flash.filters.GlowFilter;
	/**
	 * ...
	 * @author author
	 */
	public class Enemy extends Sprite
	{
		public static const UP_RIGHT_DIR:int = 1;
		public static const DOWN_RIGHT_DIR:int = 2;
		public static const DOWN_LEFT_DIR:int = 3;
		public static const UP_LEFT_DIR:int = 4;
		
		public static const BOSS:int = 1;
		public static const NOT_BOSS:int = 0;
		
		private static const ADDED_MONEY_KOEFFICIENT:Number = 0.1;
		
		public static const SLOW_TYPE_COLD:int = 102;
		public static const SLOW_TYPE_EARTH:int = 101;
		public static const SLOW_TYPE_SPEEDUP:int = 103;
		
		//visual
		public var enemyTile:MovieClip;
		public var enemyHP:MovieClip = new HPprogress();
		//moving vars
		public var checkpointArray:Array;
		public var currentCheckpoint:int;
		//характеристики
		protected var speed:Number;
		protected var health:int;
		protected var fullHealth:int;
		protected var isVoluptuous:Boolean;
		protected var armor:int
		protected var _moneyCost:int
		protected var _damage:Number;
		protected var resistToBlunt:int;
		protected var resistToSword:int;
		protected var resistToPike:int;
		protected var resistToMagic:int;
		
		private var totalResistBlunt:int;
		private var totalResistSword:int;
		private var totalResistPike:int;
		private var totalResistMagic:int;
		
		protected var bonusResistBlunt:int;
		protected var bonusResistSword:int;
		protected var bonusResistPike:int;
		protected var bonusResistMagic:int;
		
		protected var _direction:String;
		
		private var _isKeyOwner:Boolean;
		protected var _isDead:Boolean;
		
		private var _isBoss:int;
		private var _isSlowed:Boolean;
		private var _slowPercentage:int;
		private var _slowCounter:int;
		private var _slowTime:int;
		
		private var _dealingDamageTimer:Timer = new Timer(1000);
		private var _replaysNumber:int;
		private var _isOnDamageDealing:Boolean;
		private var _periodicDamage:int;
		
		private var _fireFilter:GlowFilter = new GlowFilter(0xFF0000, 1, 5, 5, 2, 1, false, false);
		private var _coldFilter:GlowFilter = new GlowFilter(0x879EF8, 1, 5, 5, 2, 1, false, false);
		private var _earthFilter:GlowFilter = new GlowFilter(0xB88203, 1, 5, 5, 2, 1, false, false);
		private var _speedUpFilter:GlowFilter = new GlowFilter(0xFFFFFF, 1, 5, 5, 2, 1, false, false);
		private var _coldTransform:ColorTransform = new ColorTransform(.6, 1, 1, 1, 0, 0 , 0 , 0);
		private var _fireTransform:ColorTransform = new ColorTransform(1, .6, .6, 1, 0, 0 , 0 , 0);
		private var _earthTransform:ColorTransform = new ColorTransform(1, .8, .4, 1, 0, 0 , 0 , 0);
		private var _speedUpTransform:ColorTransform = new ColorTransform(1.5, 1.5, 1.5, 1, 0, 0, 0, 0);
		private var _FireFiltersArray:Array = [];
		private var _ColdFiltersArray:Array = [];
		private var _EarthFiltersArray:Array = [];
		private var _SpeedUpFiltersArray:Array = [];
		
		private var _stopTime:int;
		private var _stopTimer:Timer = new Timer(1000);
		private var _isStopped:Boolean;
		
		private var _isAdditionalMoneySpell:Object = new Object();
		private var _isAdditionalDiamondsSpell:Object = new Object();
		private var _EventListenersArray:Array = [];
		private var _TimersArray:Array = [];
		private var _decreasedResistances:Object = new Object();
		protected var _moving_pts_delay:Number;
		protected var _startPt:Point;
		protected var _destinationPt:Point;
		
		public function Enemy()
		{
			_ColdFiltersArray.push(_coldFilter);
			_FireFiltersArray.push(_fireFilter);
			_EarthFiltersArray.push(_earthFilter);
			_SpeedUpFiltersArray.push(_speedUpFilter);
			_damage = 2;
			enemyHP.stop();
			
		}
		
		public function Init(checksAr:Array, _enemyHP:int, enemyArmor:int, cost:int, resistBlunt:int, resistSword:int, resistPike:int, resistMagic:int, isThereAKey:Boolean = false, boss:int = NOT_BOSS):void
		{
			x = -100;
			y = -100;
			
			addChild(enemyTile);
			
			enemyTile.filters = null;
			enemyTile.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 1, 1, 1, 1);
			
			_isOnDamageDealing = false;
			_moving_pts_delay = 1;
			_isDead = false;
			_isStopped = false;
			_isSlowed = false;
			health = _enemyHP;
			fullHealth = _enemyHP;
			armor = enemyArmor;
			_moneyCost = cost;
			resistToBlunt = resistBlunt;
			resistToSword = resistSword;
			resistToPike = resistPike;
			resistToMagic = resistMagic;
			isKeyOwner = isThereAKey;
			isBoss = boss;
			initSpellInfluences();
			initDecreasedResistances();
			CalculateChars();
			checkpointArray = [];
			addChild(enemyHP);
			enemyHP.visible = true;
			enemyHP.gotoAndStop(enemyHP.totalFrames);
			(enemyTile.getChildAt(0) as MovieClip).play();
			checkpointArray = checksAr;
			addEventListener(Event.ENTER_FRAME, onUpdatePosition, false, 0, true);
			App.ingameInterface.addEventListener(PauseEvent.PAUSE, onPauseEvent, false, 0, true);
			App.ingameInterface.addEventListener(PauseEvent.UNPAUSE, onUnpauseEvent, false, 0, true);
		}
		
		private function initDecreasedResistances():void 
		{
			_decreasedResistances.blunt = 0;
			_decreasedResistances.sword = 0;
			_decreasedResistances.pike = 0;
			_decreasedResistances.magic = 0;
		}
		
		protected function onUnpauseEvent(e:PauseEvent):void 
		{
			var tmpObject:Object;
			while (_EventListenersArray.length != 0)
			{
				tmpObject = _EventListenersArray.pop();
				tmpObject.object.addEventListener(tmpObject.type, tmpObject.handler, false, 0, true);
			}
			(enemyTile.getChildAt(0) as MovieClip).play();
			var tmpTimer:Timer;
			while (_TimersArray.length != 0)
			{
				tmpTimer = _TimersArray.pop();
				tmpTimer.start();
			}
		}
		
		protected function onPauseEvent(e:PauseEvent):void 
		{
			_EventListenersArray.length = 0;
			var tmpObject:Object;
			if (hasEventListener(Event.ENTER_FRAME))
			{
				tmpObject = new Object();
				tmpObject.object = this;
				tmpObject.type = Event.ENTER_FRAME;
				tmpObject.handler = onUpdatePosition;
				_EventListenersArray.push(tmpObject);
				removeEventListener(Event.ENTER_FRAME, onUpdatePosition, false);
				
			}
			(enemyTile.getChildAt(0) as MovieClip).stop();
			// TIMERS
			var tmpTimer:Timer;
			if (_dealingDamageTimer.running)
			{
				tmpTimer = _dealingDamageTimer;
				tmpTimer.stop();
				_TimersArray.push(tmpTimer);
			}
			if (_stopTimer.running)
			{
				tmpTimer = _stopTimer;
				tmpTimer.stop();
				_TimersArray.push(tmpTimer);
			}
		}
		
		protected function initSpellInfluences():void 
		{
			_isAdditionalDiamondsSpell.inUse = false;
			_isAdditionalDiamondsSpell.level = 0;
			_isAdditionalDiamondsSpell.movie = new diamond_spell();
			_isAdditionalMoneySpell.inUse = false;
			_isAdditionalMoneySpell.level = 0;
			_isAdditionalMoneySpell.movie = new money_spell();
		}
		
		protected function onUpdatePosition(e:Event):void 
		{
			if (_moving_pts_delay >= 1)
			{
				checkPointChange();
			}
			else
			{
				_moving_pts_delay += 1 / ( Point.distance(_startPt, _destinationPt) / speed);
				var tmpPoint:Point = Point.interpolate(_destinationPt, _startPt, _moving_pts_delay);
				x = tmpPoint.x;
				y = tmpPoint.y;
				/*x += Xdelay;
				y += Ydelay;
				movingFramesCounter++;*/
				if (this is Flying)
				{
					if (Math.random() < 0.02)
					{
						var tmpEgg:Egg = App.pools.getPoolObject(Egg.NAME);
						App.universe.eggsLayer.addChild(tmpEgg);
						tmpEgg.Init(new Point(this.x, this.y));
					}
				}
			}
			if (_isSlowed)
			{
				_slowCounter++;
				if (_slowCounter == _slowTime)
				{
					TakeEnemySpeedToNormal();
				}
			}
		}
		
		protected function checkPointChange():void 
		{
			var tmpCheck:Checkpoint = checkpointArray[currentCheckpoint];
			var tmpX1:int = tmpCheck.currentPoint.x;
			var tmpY1:int = tmpCheck.currentPoint.y;
			x = App.Half_W_DIV + tmpX1 * App.Half_Cell_W - tmpY1 * App.Half_Cell_W;
			y = - App.Cell_H * 5 + App.Half_Cell_H + tmpY1 * App.Half_Cell_H + App.Half_Cell_H * tmpX1;
			/*if (currentCheckpoint == (checkpointArray.length - 1))
			{
				App.universe.campObject.addEnemy(fullHealth, health, damage, isVoluptuous);
				destroy();
				return;
			}*/
			var tmpLength:int = tmpCheck.nextPointArray.length;
			var nextCheck:Checkpoint;
			if (tmpLength == 0)
			{
				App.universe.campObject.addEnemy(fullHealth, health, damage, isVoluptuous);
				destroy();
				return;
			}
			if (tmpLength != 1)
			{
				var randomUint:int = App.randomInt(0 , tmpLength);
				nextCheck = tmpCheck.nextPointArray[randomUint];
			}
			else 
			{
				nextCheck = tmpCheck.nextPointArray[0];
			}
			for (var i:int = 0; i < checkpointArray.length; i++)
			{
				tmpCheck = checkpointArray[i];
				if (nextCheck.currentPoint.x == tmpCheck.currentPoint.x && nextCheck.currentPoint.y == tmpCheck.currentPoint.y)
				{
					currentCheckpoint = i;
					break;
				}
			}
			var tmpX2:int = nextCheck.currentPoint.x;
			var tmpY2:int = nextCheck.currentPoint.y;
			var tmpRealX:int = App.Half_W_DIV + tmpX2 * App.Half_Cell_W - tmpY2 * App.Half_Cell_W;
			var tmpRealY:int = - App.Cell_H * 5 + App.Half_Cell_H + tmpY2 * App.Half_Cell_H + App.Half_Cell_H * tmpX2;
			
			/*var distance:Number = Math.sqrt((tmpRealX - x) * (tmpRealX - x) + (tmpRealY - y) * (tmpRealY - y));
			numberOfFrames = distance / speed;
			Xdelay = (tmpRealX - x) / numberOfFrames;
			
			Ydelay = (tmpRealY - y) / numberOfFrames;
			movingFramesCounter = 0;*/
			
			_startPt = new Point(this.x, this.y);
			_destinationPt = new Point(tmpRealX, tmpRealY);
			_moving_pts_delay = 0;
			
			if (tmpX1 == tmpX2)
			{
				if ((tmpY1 - tmpY2) > 0)
				{
					_direction = "UP_RIGHT";
					enemyTile.gotoAndStop(_direction);
				}
				else
				{
					_direction = "DOWN_LEFT";
					enemyTile.gotoAndStop(_direction);
				}
			}
			else if (tmpY1 == tmpY2)
			{
				if ((tmpX1 - tmpX2) > 0)
				{
					_direction = "UP_LEFT";
					enemyTile.gotoAndStop(_direction);
				}
				else
				{
					_direction = "DOWN_RIGHT";
					enemyTile.gotoAndStop(_direction);
				}
			}
		}
	
		public function destroy():void 
		{
			RemoveAdditionalDiamondsSpell();
			RemoveAdditionalMoneySpell();
			
			enemyTile.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 1, 1, 1, 1);
			enemyTile.filters = null;
			currentCheckpoint = 0;
			initDecreasedResistances();
			App.ingameInterface.removeEventListener(PauseEvent.PAUSE, onPauseEvent, false);
			App.ingameInterface.removeEventListener(PauseEvent.UNPAUSE, onUnpauseEvent, false);
			initSpellInfluences();
			removeChild(enemyTile);
			removeChild(enemyHP);
			while (numChildren != 0)
			{
				removeChildAt(0);
			}
			removeEventListener(Event.ENTER_FRAME, onUpdatePosition, false);
			App.universe.removeEnemy(this);
			_isKeyOwner = false;
			_isDead = true;
			if (_isOnDamageDealing)
			{
				_dealingDamageTimer.removeEventListener(TimerEvent.TIMER, onDamageDealing, false);
				_dealingDamageTimer.reset();
				_isOnDamageDealing = false;
			}
			if (_isStopped)
			{
				_stopTimer.removeEventListener(TimerEvent.TIMER, onDeclineStopping, false);
				_stopTimer.reset();
				_isStopped = false;
			}
		}
	
		public function StopEnemy(stopTime:int):void 
		{
			if (!_isDead)
			{
				enemyTile.gotoAndStop(_direction);
				(enemyTile.getChildAt(0) as MovieClip).stop();
				_isStopped = true;
				removeEventListener(Event.ENTER_FRAME, onUpdatePosition, false);
				_stopTimer.reset();
				_stopTimer.delay = stopTime;
				_stopTimer.repeatCount = 1;
				_stopTimer.addEventListener(TimerEvent.TIMER, onDeclineStopping, false, 0, true);
				_stopTimer.start();
			}
		}
		
		private function onDeclineStopping(e:TimerEvent):void 
		{
			StartEnemy();
		}
			
		public function StartEnemy():void 
		{
			if (!_isDead && _isStopped)
			{
				_stopTimer.stop();
				_stopTimer.removeEventListener(TimerEvent.TIMER, onDeclineStopping, false);
				_isStopped = false;
				(enemyTile.getChildAt(0) as MovieClip).play();
				addEventListener(Event.ENTER_FRAME, onUpdatePosition, false, 0, true);
			}
		}
		
		public function SlowEnemy(percentage:int, slowTime:int, slowType:int = SLOW_TYPE_COLD):void 
		{
			if (_slowPercentage < percentage)
			{
				if (_isSlowed)
				{
					TakeEnemySpeedToNormal();
				}
				
				_isSlowed = true;
				_slowPercentage = percentage;
				var tmpKoefficient:Number = percentage / 100;
				speed = speed * tmpKoefficient;
				_slowTime = slowTime;
				if (slowType == SLOW_TYPE_COLD)
				{
					enemyTile.filters = _ColdFiltersArray;
					enemyTile.transform.colorTransform = _coldTransform;
				}
				else if(slowType == SLOW_TYPE_EARTH)
				{
					enemyTile.filters = _EarthFiltersArray;
					enemyTile.transform.colorTransform = _earthTransform;
				}
				else if (slowType == SLOW_TYPE_SPEEDUP)
				{
					enemyTile.filters = _SpeedUpFiltersArray;
					enemyTile.transform.colorTransform = _speedUpTransform;
				}
			}
		}
		
		public function TakeEnemySpeedToNormal():void 
		{
			_isSlowed = false;
			var tmpKoefficient:Number = _slowPercentage / 100;
			speed = speed / tmpKoefficient;
			_slowPercentage = 0;
			_slowTime = 0;
			_slowCounter = 0;
			
			if (!_isOnDamageDealing)
			{
				enemyTile.filters = null;
				enemyTile.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 1, 1, 1, 1);
			}
		}
		
		public function DealDamageEveryXSecs(damage:int, delay:int, fulltime:Number):void 
		{
			_isOnDamageDealing = true;
			_dealingDamageTimer.reset();
			_dealingDamageTimer.delay = delay;
			_periodicDamage = damage;
			_replaysNumber = fulltime * 1000 / delay;
			enemyTile.transform.colorTransform = _fireTransform;
			enemyTile.filters = _FireFiltersArray;
			_dealingDamageTimer.addEventListener(TimerEvent.TIMER, onDamageDealing, false, 0, true);
			_dealingDamageTimer.start();
		}
		
		private function onDamageDealing(e:TimerEvent):void 
		{
			enemyTakingDamage(null, false, DamageTypes.MAGIC, _periodicDamage, 0);
			if (_dealingDamageTimer.currentCount >= _replaysNumber)
			{
				_dealingDamageTimer.removeEventListener(TimerEvent.TIMER, onDamageDealing, false);
				_dealingDamageTimer.stop();
				_isOnDamageDealing = false;
				if (!_isSlowed)
				{
					enemyTile.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 1, 1, 1, 1);
					enemyTile.filters = null;
				}
			}
		}
		
		public function UseAdditionalMoneySpell(skill_level:int):void 
		{
			if (_isAdditionalMoneySpell.inUse)
			{
				if (_isAdditionalMoneySpell.level > skill_level)
				{
					_isAdditionalMoneySpell.level += skill_level / 2;
				}
				else
				{
					_isAdditionalMoneySpell.level = skill_level;
				}
			}
			else
			{
				_isAdditionalMoneySpell.inUse = true;
				_isAdditionalMoneySpell.level = skill_level;
				addChild(_isAdditionalMoneySpell.movie);
			}
		}
		
		private function RemoveAdditionalDiamondsSpell():void
		{
			if (_isAdditionalDiamondsSpell.inUse == true)
			{
				_isAdditionalDiamondsSpell.inUse = false;
				_isAdditionalDiamondsSpell.level = 0;
				if (contains(_isAdditionalDiamondsSpell.movie))
				{
					removeChild(_isAdditionalDiamondsSpell.movie);
				}
			}
		}
		
		private function RemoveAdditionalMoneySpell():void
		{
			if (_isAdditionalMoneySpell.inUse == true)
			{
				_isAdditionalMoneySpell.inUse = false;
				_isAdditionalMoneySpell.level = 0;
				if (contains(_isAdditionalMoneySpell.movie))
				{
					removeChild(_isAdditionalMoneySpell.movie);
				}
			}
		}
		
		public function UseAdditionalDiamondsSpell(skill_level:int):void 
		{
			if (_isAdditionalDiamondsSpell.inUse)
			{
				if (_isAdditionalDiamondsSpell.level > skill_level)
				{
					_isAdditionalDiamondsSpell.level += skill_level / 2;
				}
				else
				{
					_isAdditionalDiamondsSpell.level = skill_level;
				}
			}
			else
			{
				_isAdditionalDiamondsSpell.inUse = true;
				_isAdditionalDiamondsSpell.level = skill_level;
				addChild(_isAdditionalDiamondsSpell.movie);
			}
		}
		
		public function enemyTakingDamage(_tower:Tower, meleeAttackFlag:Boolean = false, damageType:int = 0, dmg:int = 0, percentage:int = 0):void 
		{
			var _damageType:int;
			var damage:int;
			var isCriticalStrike:Boolean = false;
			var armorPierced:Boolean = false;
			var percentageFlag:Boolean = false;
			var _extraDamage:Boolean = false;
			var _armorPierced:Boolean = false;
			var _deadlyStrike:Boolean = false;
			// Если урон нанесен башней:
			if (_tower != null)
			{
				var tmpTower:Tower = _tower;
				var tmpA:int = 0;
				if (tmpTower.skillsInfluence.addedAccuracy != null && tmpTower.skillsInfluence.addedAccuracy != 0)
				{ tmpA = tmpTower.skillsInfluence.addedAccuracy; }
				if ((!(this is Thorner) && (App.randomInt(0,100) > tmpTower.accuracy + tmpA)) || ((this is Doublelegged) && tmpTower.isAirKiller))
				{
					var tmpMovie:MovieClip = new missMovie();
					tmpMovie.gotoAndPlay(1);
					tmpMovie.x = this.x;
					tmpMovie.y = this.y - 20;
					App.universe.critsLayer.addChild(tmpMovie);
					return;
				}
				
				// splash!!!!
				var splash:MovieClip = new splashMovie();
				splash.x = Math.random() * 20 - 10;
				splash.y = Math.random() * 20 - 30;
				splash.scaleX = splash.scaleY = Math.random() * 0.2 + 0.4;
				addChild(splash);
				// end splash!!!
				
				tmpA = 0;
				if (tmpTower.skillsInfluence.addedCritical != null && tmpTower.skillsInfluence.addedCritical != 0)
				{ tmpA = tmpTower.skillsInfluence.addedCritical; }
				if (!(this is Thorner) && App.randomInt(0, 100) < tmpTower.criticalChance + tmpA)
				{
					tmpMovie = new critMovie();
					tmpMovie.gotoAndPlay(1);
					tmpMovie.x = this.x;
					tmpMovie.y = this.y - 20;
					App.universe.critsLayer.addChild(tmpMovie);
					isCriticalStrike = true;
					App.soundControl.playSound("crit");
				}
				if (meleeAttackFlag)
				{
					damage = int((App.randomInt(tmpTower.damageMin, tmpTower.damageMax) + tmpTower.addedDamage) / 3);
				}
				else
				{
					damage = App.randomInt(tmpTower.damageMin, tmpTower.damageMax) + tmpTower.addedDamage;
				}
				if (isCriticalStrike)
				{
					var tmpCritPowerKoefficient:int = 1;
					if (tmpTower.skillsInfluence.addedExtraCritDamage != 0 && tmpTower.skillsInfluence.addedExtraCritDamage != null)
					{
						if (App.randomInt(0, 100) < tmpTower.skillsInfluence.addedExtraCritDamage)
						{
							tmpCritPowerKoefficient = 2;
							_extraDamage = true;
						}
					}
					
					damage *= tmpCritPowerKoefficient * (1 + tmpTower.criticalPower);
				}
				if (tmpTower.skillsInfluence.addedChanceArmorIgnoring != 0 && tmpTower.skillsInfluence.addedChanceArmorIgnoring != null)
				{
					if (App.randomInt(0, 100) < tmpTower.skillsInfluence.addedChanceArmorIgnoring)
					{
						armorPierced = true;
						_armorPierced = true;
					}
				}
				_damageType = tmpTower.damageType;
				if (!(this is Thorner) && tmpTower.skillsInfluence.addedDeadlyChance != 0 && tmpTower.skillsInfluence.addedDeadlyChance != null)
				{
					if (Math.random() < (tmpTower.skillsInfluence.addedDeadlyChance / 100))
					{
						damage += fullHealth + armor;
						_deadlyStrike = true;
					}
				}
				// пофиксить добавление экспы и очков за убийство/урон монстрам
				//var tmpExperience:int = (_moneyCost * 5) * tmpTower.addedMoneyForKilling;
				var tmpDamage:int = damage;
				if (tmpDamage > 1000) { tmpDamage = 500; }
				var tmpExperience:int = _moneyCost * Math.sqrt(tmpDamage) / 2;
				tmpTower.experience += tmpExperience;
				App.universe.experienceGainedCount += tmpExperience;
			}
			// Если урон нанесен НЕ башней:
			else
			{
				if (dmg != 0)
				{
					damage = dmg;
				}
				else
				{
					percentageFlag = true;
					damage = fullHealth * (percentage / 100);
				}
				_damageType = damageType;
			}
			
			// обработка модификаторов урона ( броня, резисты )
			if (damageType != DamageTypes.MAGIC)
			{
				if ((!armorPierced) && (!percentageFlag))
				{
					damage -= armor;
					if (damage < 0)
					{
						damage = 0;
					}
				}
			}
			var realDamage:int;
			switch(_damageType)
			{
				case DamageTypes.BLUNT:
				realDamage = damage * (1 - (totalResistBlunt - _decreasedResistances.blunt) / 100);// * ( 1 + App.military / 100);
				break;
				case DamageTypes.SWORD:
				realDamage = damage * ( 1 - (totalResistSword - _decreasedResistances.sword) / 100);// * ( 1 + App.military / 100);
				break;
				case DamageTypes.PIKE:
				realDamage = damage * ( 1 - (totalResistPike - _decreasedResistances.pike) / 100);// * ( 1 + App.military / 100);
				break;
				case DamageTypes.MAGIC:
				realDamage = damage * ( 1 - (totalResistMagic - _decreasedResistances.magic) / 100);// * ( 1 + App.military / 100);
				break;
			}
			health -= realDamage;
			if (tmpTower != null && tmpTower.skillsInfluence.addedMagicDamage != 0 && tmpTower.skillsInfluence.addedMagicDamage != null)
			{
				health -= tmpTower.skillsInfluence.addedMagicDamage * ( 1 - (resistToMagic - _decreasedResistances.magic) / 100);
			}
			var tmpFlyingDamageMovie:FlyingDamage = App.pools.getPoolObject(FlyingDamage.NAME);
			tmpFlyingDamageMovie.Init(new Point(x, y), realDamage);
			enemyHP.gotoAndStop(int(health / fullHealth * enemyHP.totalFrames));
			// Если враг умер :
			if (health <= 0 && !_isDead)
			{
				App.soundControl.playSound("death");
				
				_isDead = true;
				if (isKeyOwner)
				{
					onAddKeyAnimation();
				}
				App.currentPlayer.score += moneyCost * 10;
				if (_tower != null)
				{
					tmpTower.experience += _moneyCost * Math.sqrt(tmpDamage) * 2;
					App.universe.experienceGainedCount += _moneyCost * Math.sqrt(tmpDamage) * 2;
					if (tmpTower.isBaffed) {
						if (App.universe.warriorTwr != null) {
							App.universe.warriorTwr.experience += _moneyCost * Math.sqrt(tmpDamage) * 2;
						}
					}
				}
				var tmpGoldKoefficient:Number = 1;
				var tmpMonsterSpellGoldKoefficient:Number = 1;
				var tmpAddedMoney:int = 0;
				if (_isAdditionalMoneySpell.inUse)
				{
					tmpAddedMoney += _isAdditionalMoneySpell.level;
					tmpMonsterSpellGoldKoefficient += _isAdditionalMoneySpell.level * ADDED_MONEY_KOEFFICIENT;
				}
				if (this is Frog) { (this as Frog).UsePoisonSplash(); }
				if (tmpTower != null)
				{
					if (tmpTower.addedMoneyForKilling != 0)
					{ 
						tmpAddedMoney += tmpTower.addedMoneyForKilling;
					}
					if (tmpTower.skillsInfluence.addedBonusMoney != 0 && tmpTower.skillsInfluence.addedBonusMoney != null)
					{
						tmpGoldKoefficient = moneyCost + (moneyCost * tmpTower.skillsInfluence.addedBonusMoney / 100);
					}
				}
				var tmpGoldIncreasing:int = moneyCost * tmpGoldKoefficient * tmpMonsterSpellGoldKoefficient + tmpAddedMoney; 
				App.universe.goldCount += tmpGoldIncreasing;
				App.currentPlayer.gold += tmpGoldIncreasing;
				if (_isAdditionalDiamondsSpell.inUse)
				{
					Universe.additional_diamonds += Chest.BASE_BONUS + Chest.PEL_LEVEL_BONUS * _isAdditionalDiamondsSpell.level;
				}
				App.universe.destroyedEnemiesCount += 1;
				
				if (!(this is Flying) && !(this is Web))
				{
					var tmpDeath:MovieClip = new death_movie();
					tmpDeath.x = this.x;
					tmpDeath.y = this.y;
					tmpDeath.gotoAndPlay(1);
					var tmpIndex:int = App.universe.mainLayer.getChildIndex(this);
					
					App.universe.mainLayer.addChildAt(tmpDeath, tmpIndex);
				}
				
				destroy();
			}
			else
			{
				if (tmpTower != null)
				{
					if (tmpTower.skillsInfluence.addedBleedingChance != 0 && tmpTower.skillsInfluence.addedBleedingChance != null)
					{
						if ( App.randomInt(0, 100) < tmpTower.skillsInfluence.addedBleedingChance)
						{
							App.soundControl.playSound("bleed");
							
							var tmpAddedPower:int = 0;
							var tmpAddedTime:int = 0;
							if (tmpTower.skillsInfluence.addedBleedingPower != null)
							{
								tmpAddedPower = tmpTower.skillsInfluence.addedBleedingPower;
							}
							if (tmpTower.skillsInfluence.addedBleedingTime != null)
							{
								tmpAddedTime = tmpTower.skillsInfluence.addedBleedingTime;
							}
							DealDamageEveryXSecs(tmpTower.bleedDamage + tmpAddedPower, tmpTower.bleedDelay, tmpTower.bleedTime + tmpAddedTime);
						}
					}
					if (tmpTower.skillsInfluence.addedSlowChance != 0 && tmpTower.skillsInfluence.addedSlowChance != null)
					{
						if (App.randomInt(0, 100) < tmpTower.skillsInfluence.addedSlowChance)
						{
							SlowEnemy(tmpTower.slowPercentage + tmpTower.skillsInfluence.addedSlowPower, tmpTower.slowTime, SLOW_TYPE_EARTH);
						}
					}
					if (tmpTower.skillsInfluence.addedStunChance != 0 && tmpTower.skillsInfluence.addedStunChance != null)
					{
						if (App.randomInt(0, 100) < tmpTower.skillsInfluence.addedStunChance)
						{
							StopEnemy(tmpTower.stunTime + tmpTower.skillsInfluence.addedStunTime);
						}
					}
					if (tmpTower.skillsInfluence.addedEnemyBluntResistToZero != 0 && tmpTower.skillsInfluence.addedEnemyBluntResistToZero != null)
					{
						if (App.randomInt(0, 100) < tmpTower.skillsInfluence.addedEnemyBluntResistToZero)
						{
							_decreasedResistances.blunt = resistToBlunt;
						}
					}
					if (tmpTower.skillsInfluence.addedEnemyPikeResistToZero != 0 && tmpTower.skillsInfluence.addedEnemyPikeResistToZero != null)
					{
						if (App.randomInt(0, 100) < tmpTower.skillsInfluence.addedEnemyPikeResistToZero)
						{
							_decreasedResistances.pike = resistToPike;
						}
					}
					if (tmpTower.skillsInfluence.addedEnemyMagicResistToZero != 0 && tmpTower.skillsInfluence.addedEnemyMagicResistToZero != null)
					{
						if (App.randomInt(0, 100) < tmpTower.skillsInfluence.addedEnemyMagicResistToZero)
						{
							_decreasedResistances.magic = resistToMagic;
						}
					}
					if (tmpTower.skillsInfluence.addedLightningChance != 0 && tmpTower.skillsInfluence.addedLightningChance != null)
					{
						if (App.randomInt(0, 100) < tmpTower.skillsInfluence.addedLightningChance)
						{
							var tmpLightning:LightningStrike = App.pools.getPoolObject(LightningStrike.NAME);
							tmpLightning.UseLightning(this, tmpTower.skillsInfluence.addedLightningDamage);
						}
					}
				}
				if (this is Rat)
				{
					if(!(this as Rat).isRegenerating) {
						(this as Rat).startRegeneration();
					}
				}
				else if (this is BlueDino && tmpTower)
				{
					if (App.randomInt(0, 100) <= (this as BlueDino).fearChance)
					{
						App.soundControl.playSound("fear");
						tmpTower.UseFear();
					}
				}
				else if (this is SaberTooth)
				{
					if (App.randomInt(0, 100) <= (this as SaberTooth).speedUpChance)
					{
						SlowEnemy(200, 90, SLOW_TYPE_SPEEDUP);
					}
				}
				else if (this is Kaban)
				{
					var tmpKaban:Kaban = this as Kaban;
					if ((!tmpKaban.isVicious) && (health / fullHealth * 100 < tmpKaban._HPtoStartAngrer))
					{
						tmpKaban.ViciousKaban();
					}
				}
				else if (this is Spider && tmpTower)
				{
					if (App.randomInt(0, 100) < (this as Spider).chanceToCreateWeb)
					{
						App.soundControl.playSound("web");
						(this as Spider).createWeb(tmpTower);
					}
				}
			}
		}
		
		public function CalculateChars():void 
		{
			totalResistBlunt = resistToBlunt + bonusResistBlunt;
			totalResistSword = resistToSword + bonusResistSword;
			totalResistPike = resistToPike + bonusResistPike;
			totalResistMagic = resistToMagic + bonusResistMagic;
		}
		
		private function onAddKeyAnimation():void 
		{
			var tmpKey:KeyControl = App.pools.getPoolObject(KeyControl.NAME);
			tmpKey.Init(new Point(this.x, this.y));
		}
		
		public function get isDead():Boolean { return _isDead; }
		
		public function get damage():Number { return _damage; }
		
		public function get isKeyOwner():Boolean { return _isKeyOwner; }
		
		public function set isKeyOwner(value:Boolean):void 
		{
			_isKeyOwner = value;
		}
		
		public function get moneyCost():int { return _moneyCost; }
		
		public function get isStopped():Boolean { return _isStopped; }
		
		public function get isBoss():int { return _isBoss; }
		
		public function set isBoss(value:int):void 
		{
			_isBoss = value;
		}
	}
}