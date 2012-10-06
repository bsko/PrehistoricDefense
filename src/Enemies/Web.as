package Enemies 
{
	import Events.PauseEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author 
	 */
	public class Web extends Enemy
	{
		public static const NAME:String = "Web";
		public static const BASE_HP:int = 10;
		public static const BASE_ARMOR:int = 0;
		public static const EXIST_TIME:int = 10000;
		private var _tower:Tower;
		private var _isOnDamageDealing:Boolean;
		private var _isStopped:Boolean;
		private var _isSlowed:Boolean;
		
		private var _existTimer:Timer = new Timer(EXIST_TIME, 1);
		
		public function Web() 
		{
			enemyTile = new webMovieFull();
			enemyTile.scaleX = 1;
			enemyTile.scaleY = 1;
			enemyTile.x = 0;
			enemyTile.y = 0;
			addChild(enemyTile);
			//характеристики
			isVoluptuous = true;
			speed = 0;
			//Init();
		}
		
		override public function Init(checksAr:Array, _enemyHP:int, enemyArmor:int, cost:int, resistBlunt:int, resistSword:int, resistPike:int, resistMagic:int, isThereAKey:Boolean = false, boss:int = NOT_BOSS):void 
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
			//initDecreasedResistances();
			CalculateChars();
			checkpointArray = [];
			addChild(enemyHP);
			enemyHP.visible = false;
			enemyHP.gotoAndStop(enemyHP.totalFrames);
			checkpointArray = checksAr;
			_existTimer.start();
			
			_existTimer.addEventListener(TimerEvent.TIMER, onExistTimePassed, false, 0, true);
			addEventListener(Event.ENTER_FRAME, onUpdatePosition, false, 0, true);
			App.ingameInterface.addEventListener(PauseEvent.PAUSE, onPauseEvent, false, 0, true);
			App.ingameInterface.addEventListener(PauseEvent.UNPAUSE, onUnpauseEvent, false, 0, true);
		}
		
		override public function enemyTakingDamage(_tower:Tower, meleeAttackFlag:Boolean = false, damageType:int = 0, dmg:int = 0, percentage:int = 0):void 
		{
			var damage:int;
			var isCriticalStrike:Boolean = false;
			var _extraDamage:Boolean = false;
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
			}
			// Если урон нанесен НЕ башней:
			else
			{
				if (dmg != 0)
				{
					damage = dmg;
				}
			}
			
			var realDamage:int = damage;
			
			health -= realDamage;
			
			var tmpFlyingDamageMovie:FlyingDamage = App.pools.getPoolObject(FlyingDamage.NAME);
			tmpFlyingDamageMovie.Init(new Point(x, y), realDamage);
			
			// Если враг умер :
			if (health <= 0 && !_isDead)
			{
				_isDead = true;	
				destroy();
			}
		}
		
		private function onExistTimePassed(e:TimerEvent):void 
		{
			destroy();
		}
		
		public function SetTower(tower:Tower):void 
		{
			_tower = tower;
			_tower.addChild(enemyTile);
			x = _tower.currentCell.x;
			y = _tower.currentCell.y + _tower.y;
			enemyTile.x = 0;
			enemyTile.y = 0
		}
		
		override public function destroy():void  
		{
			_existTimer.removeEventListener(TimerEvent.TIMER, onExistTimePassed, false);
			App.ingameInterface.removeEventListener(PauseEvent.PAUSE, onPauseEvent, false);
			App.ingameInterface.removeEventListener(PauseEvent.UNPAUSE, onUnpauseEvent, false);
			
			_existTimer.reset();
			if (contains(enemyHP))
			{
				removeChild(enemyHP);
			}
			removeEventListener(Event.ENTER_FRAME, onUpdatePosition, false);
			
			_isDead = true;

			if (_tower != null) 
			{
				_tower.QuitWeb();
				_tower.removeChild(enemyTile);
				_tower = null; 
				x = -100;
				y = -100;
			}
			App.universe.removeEnemy(this);
			App.pools.returnPoolObject(NAME, this)
		}
		
		override public function StopEnemy(stopTime:int):void 
		{}
		
		override public  function SlowEnemy(percentage:int, slowTime:int, slowType:int = SLOW_TYPE_COLD):void 
		{}
		
		override public function DealDamageEveryXSecs(damage:int, delay:int, fulltime:Number):void 
		{}
		
		override public function UseAdditionalDiamondsSpell(skill_level:int):void 
		{}
		
		override public function UseAdditionalMoneySpell(skill_level:int):void 
		{}
		
		override protected function onUpdatePosition(e:Event):void 
		{}
			
		override protected function initSpellInfluences():void 
		{}
	}

}