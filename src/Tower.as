package  
{
	import authoring.authObject;
	import Enemies.Flying;
	import Events.PauseEvent;
	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author author
	 */
	public class Tower extends Sprite
	{	
		public static const ARMY_MAX_COUNT:int = 15;
		public static const NAMES:Array = ["Alastor", "Aleus", "Alexamenus", "Alexander", "Alexiares", "Alexicacus", "Alecto", "Alectryon", " Aletes", " Alcaeus", " Alcestis", " Alcibiades", " Alcides", " Alcimus", " Alcimede", " Alcinous", " Alcmaeon", " Amyntor", " Amythaon", " Amphiaraus", " Amphigyeis", " Amphilochus", " Amphimachus", " Amphinomus", " Anance", " Androclus", " Anaxilaus", " Anaxagoras", " Anicetus", " Antaeus", " Antigonus", " Argus", " Aristaeus", " Aristides", " Aristonicus", " Arcas", " Archelaus", " Atlas", " Athamas", " Belus", " Bellerophon", " Bias", " Boreas", " Bromius", " Butes", " Ganymedes", " Hector", " Helenus", " Helius", " Hercules", " Geryon", " Herodorus", " Hesperus", " Hephaestio", " Hylas", " Hyllus", " Hyperion", " Hipparchus", " Hipponous", " Glaucus", " Homerus", " Gordius", " Danaus", " Dardanus", " Daphnis", " Daedalus", " Deiphobus", " Delius", " Demetrius", " Democritus", " Demosthenes", " Demophoon", " Diogenes", " Diocles", " Dionysus", " Euander", " Euclides", " Eurus", " Eurycrates", " Eurymachus", " Eurypylus", " Eurysacus", " Eurystheus", " Eurysthenes", " Eurytus", " Europa", " Euphemus", " Zagreus", " Zeus", " Zeno", " Zephyrus", " Zethus", " Iapetus", " Idomeneus", " Icarus", " Ixion", " Ino", " Io", " Iocastus", " Iolaus", " Hippolytus", " Isidorus", " Iphicles", " Iphicrates", " Iphitus", " Cadmus", " Calypso", " Callicratus", " Callimachus", " Callistratus", " Callisthenes", " Cassandrus", " Carpus", " Castor", " Cercyo", " Cepheus", " Cycnus", " Cyparissus", " Cleander", " Cleitus", " Cleon", " Clymenus", " Cleitus", " Clotho", " Codrus", " Copreus", " Creon", " Xanthippus", " Xanthus", " Xenocles", " Xenocrates", " Xenophanes", " Xenophon", " Laocoon", " Lachesis", " Laertes", " Leander", " Leon", " Leucippe", " Leto", " Leonidas", " Linus", " Lycurgus", " Lysippus", " Aiax", " Euclides", " Euander", " Aesopus", " Oedipus", " Aegialeus", " Manto", " Machaon", " Medus", " Melampus", " Melanippus", " Menander", " Mentor", " Midas", " Minos", " Myron", " Myrtilus", " Momus", " Morpheus", " Nauplius", " Nearchus", " Neleus", " Neocles", " Nestor", " Nicanor", " Nicomachus", " Nicomedes", " Nicostratus", "Notus"];
		private static const TOWER_HEIGHT:int = 50;
		
		public static var enemiesArray:Array;
		public static var towersArray:Array;
		
		protected var _experience:int;
		
		protected var _descriptionText:String;
		protected var _realName:String;
		
		//базовые характеристики
		protected var _baseExpToNextLevel:int = 500;
		protected var _baseAttackRange:Number;
		protected var _baseAttackSpeed:Number;
		protected var _baseDamageMin:Number;
		protected var _baseDamageMax:Number;
		protected var _baseHealth:Number;
		protected var _damageType:int;
		
		protected var _level:int = 1;
		protected var _baseWheatCost:int;
		protected var _baseGoldCost:int;
		protected var _skillsArray:Array;
		protected var _skillsInfluence:Object = new Object();
		protected var _skillPoints:int = 0;
		
		//множители к базовым характеристикам
		protected var _koefLevelToNextLvlExp:Number = 0.3;
		protected var _koefLevelToDmgMin:Number = 0;
		protected var _koefLevelToDmgMax:Number = 0;
		protected var _koefLevelToRange:Number = 0;
		protected var _koefLevelToAttackSpeed:Number = 0;
		protected var _koefLevelToHealth:Number = 0;
		protected var _koefLevelToDmgMinAbsolute:int = 1;
		protected var _koefLevelToDmgMaxAbsolute:int = 1;
		
		//текущие характеристики башни
		protected var _experienceToNextLevel:int;
		protected var _experienceToCurrentLevel:int;
		protected var _maxExperience:int;
		protected var _attackRange:Number;
		protected var _attackSpeed:Number;
		protected var _damageMin:Number;
		protected var _damageMax:Number;
		protected var _accuracy:Number;
		protected var _criticalPower:Number;
		protected var _criticalChance:Number;
		
		protected var _wheatCost:int;
		protected var _goldCost:int;
		private var _addedDamage:Number;
		private var _addedCriticalPower:Number;
		private var _addedCriticalChance:Number;
		private var _addedRange:Number;
		private var _addedAccuracy:Number;
		
		//системные переменные
		protected var _curEnemyToAttack:Enemy;
		protected var _currentCell:Grid;
		protected var _attackTimer:Timer = new Timer(1000);
		protected var distance:int;
		protected var _maxHealth:Number;
		protected var _health:Number;
		protected var _title:String;
		protected var _isHero:Boolean = false;
		protected var _isAirKiller:Boolean = false;
		protected var _EventListenersArray:Array = [];
		protected var _TimersArray:Array = [];
		protected var _isShooting:Boolean = false;
		
		// специальные возможности ( скилы )
		protected var _bleedTime:int = 2500; // в милисекундах
		protected var _bleedDelay:int = 500;
		protected var _bleedDamage:int = 5;
		protected var _slowPercentage:int = 30;
		protected var _slowTime:int = 90; // во фреймах
		protected var _stunTime:int = 1300; // в милисекундах
		
		public static const KOEFFICIENT_OF_ADDED_MONEY_PER_LEVEL:int = 1;
		public static const BASE_ADDED_MONEY:int = 4;
		private var _isBuffedWithAdditionalMoney:Boolean = false;
		private var _addedMoneyForKilling:int = 0;
		private var _additionalMoneyTimer:Timer = new Timer(10000);
		
		// бонус к характеристикам
		protected var _BONUS_damage:Number;
		protected var _BONUS_crit:Number;
		protected var _BONUS_accuracy:Number;
		protected var _BONUS_range:Number;
		private var _isBaffed:Boolean = false;
		
		private var _BonusesObject:Object;
		private var _buffTimer:Timer = new Timer(1000);
		
		//визуальная часть
		protected var _towerMovie:MovieClip;
		protected var _type:String;
		protected var _movieClipLabel:String;
		protected var _HPprogress:MovieClip = new HPprogressTowers();
		private var _dyingTower:MovieClip = new death_movie();
		private var _lvl_up_movie:MovieClip = new levelupmovie();
		
		private var expKoefficientsArray:Array;
		private var _a:Boolean = false;
		
		private var _isFrightened:Boolean;
		private var _fearTime:int = 5000;
		private var _fearTimer:Timer = new Timer(_fearTime);
		
		private var _isWebbed:Boolean;
		private var _fearMovie:MovieClip = new afraidMovie();
		private var _isAdditionalMoneySpell:MovieClip = new money_spell();
		
		public function Tower() 
		{
			// init koefficients array
			var d:Number = 0.3;
			var current:int = 1;
			expKoefficientsArray = [];
			for (var c:int = 0; c < 26; c++)
			{
				//current = (int(current / 10)) * 10;
				expKoefficientsArray.push(current);
				d += 3.0;
				current += d + 1;
			}
			_maxExperience = _baseExpToNextLevel * expKoefficientsArray[expKoefficientsArray.length - 1];
			//---
			
			_fearMovie.stop();
			
			_BonusesObject = new Object();
			_BonusesObject.auraDamage = 0;
			_BonusesObject.auraCritChance = 0;
			_BonusesObject.auraCritPower = 0;
			_BonusesObject.auraRange = 0;
			_BonusesObject.auraAdditionalMoney = 0;
			_BonusesObject.buffDamage = 0;
			_BonusesObject.buffCritChance = 0;
			_BonusesObject.buffCritPower = 0;
			_BonusesObject.buffRange = 0;
		}
		
		public function Init(cellOwner:Grid, SkillsArray:Array = null):void 
		{
			this.x = 0;
			this.y = 0;
			searchForLabels();
			isBaffed = false;
			_isWebbed = false;
			towerMovie.y = - App.HEIGHT_DELAY - cellOwner.gridHeight;
			_currentCell = cellOwner;
			_currentCell.addChild(this);
			_currentCell.tower = this; 
			_currentCell.ableState = App.CELL_STATE_TOWER;
			_attackTimer.addEventListener(TimerEvent.TIMER, onFindTarget, false, 0, true);
			_attackTimer.start();
			skillPoints = 0;
			_HPprogress.y = - TOWER_HEIGHT;
			addChild(_HPprogress);
			maxHealth = _health;
			_HPprogress.gotoAndStop(_HPprogress.totalFrames);
			_lvl_up_movie.visible = false;
			_isFrightened = false;
			_lvl_up_movie.y = - TOWER_HEIGHT - App.HEIGHT_DELAY - cellOwner.gridHeight - 25;
			addChild(_lvl_up_movie);
			App.ingameInterface.addEventListener(PauseEvent.PAUSE, onPauseEvent, false, 0, true);
			App.ingameInterface.addEventListener(PauseEvent.UNPAUSE, onUnpauseEvent, false, 0, true);
		}
		
		protected function onPauseEvent(e:PauseEvent):void 
		{
			var tmpObject:Object;
			_EventListenersArray.length = 0;
			var tmpTimer:Timer;
			_TimersArray.length = 0;
			if (_buffTimer.running)
			{
				tmpTimer = _buffTimer;
				tmpTimer.stop();
				_TimersArray.push(tmpTimer);
			}
			if (_attackTimer.running)
			{
				tmpTimer = _attackTimer;
				tmpTimer.stop();
				_TimersArray.push(tmpTimer);
			}
			if (_additionalMoneyTimer.running)
			{
				tmpTimer = _additionalMoneyTimer;
				tmpTimer.stop();
				_TimersArray.push(tmpTimer);
			}
			
			if (_isShooting)
			{
				(towerMovie.getChildAt(0) as MovieClip).stop();
			}
		}
		
		private function onUnpauseEvent(e:PauseEvent):void 
		{
			var tmpObject:Object;
			while (_EventListenersArray.length != 0)
			{
				tmpObject = _EventListenersArray.pop();
				tmpObject.object.addEventListener(tmpObject.type, tmpObject.handler, false, 0, true);
			}
			var tmpTimer:Timer;
			while (_TimersArray.length != 0)
			{
				tmpTimer = _TimersArray.pop();
				tmpTimer.start();
			}
			
			if (_isShooting)
			{
				(towerMovie.getChildAt(0) as MovieClip).play();
			}
		}
		
		public function calculateSkills():void 
		{
			for (nameSkill in _skillsInfluence) 
			{ 
				_skillsInfluence[nameSkill] = 0;
			}
			var lengthSkills:int = _skillsArray.length;
			var skill:Object;
			var realSkill:RealTowerSkill;
			var levelSkill:int;
			for (var i:int = 0; i < lengthSkills; i++) 
			{
				realSkill = _skillsArray[i];
				skill = realSkill.skill.skills;
				levelSkill = realSkill.currentLevel;
				for (var nameSkill:String in skill) 
				{
					if (_skillsInfluence[nameSkill] != null) 
					{
						_skillsInfluence[nameSkill] += skill[nameSkill] * levelSkill;
					} 
					else 
					{
						_skillsInfluence[nameSkill] = skill[nameSkill] * levelSkill;
					}
				}
			}
		}
		
		public function preBuildInit():void 
		{
			
		}
		
		public function UseFear():void 
		{
			if (!_isFrightened)	{
				_isFrightened = true;
				_attackTimer.stop();
				_fearTimer.addEventListener(TimerEvent.TIMER, QuitFear, false, 0, true);
				_fearTimer.start();
				_fearMovie.x = 0;
				_fearMovie.y = -100;
				addChild(_fearMovie);
				_fearMovie.play();
			}
			else {
				_fearTimer.reset();
				_fearTimer.start();
			}
		}
		
		public function QuitFear(e:TimerEvent = null):void 
		{
			if (_isFrightened)
			{
				_fearTimer.removeEventListener(TimerEvent.TIMER, QuitFear, false);
				_fearTimer.reset();
				_isFrightened = false;
				if (contains(_fearMovie))
				{
					removeChild(_fearMovie);
					_fearMovie.stop();
				}
				_attackTimer.start();
			}
		}
		
		public function updateReferences():void 
		{
			_experienceToNextLevel = _baseExpToNextLevel * expKoefficientsArray[level - 1];
			if (level > 1)
			{
				_experienceToCurrentLevel = _baseExpToNextLevel * expKoefficientsArray[level - 2];
			}
			else
			{
				_experienceToCurrentLevel = 0;
			}
			_damageMin = ((_level - 1) * _koefLevelToDmgMin + 1) * _baseDamageMin;
			_damageMax = ((_level - 1) * _koefLevelToDmgMax + 1) * _baseDamageMax;
			_damageMin += (_level - 1) * _koefLevelToDmgMinAbsolute;
			_damageMax += (_level - 1) * _koefLevelToDmgMaxAbsolute;
			_attackSpeed = ((_level - 1) * _koefLevelToAttackSpeed + 1) * _baseAttackSpeed;
			_attackRange = ((_level - 1) * _koefLevelToRange + 1) * _baseAttackRange;
			_maxHealth = ((_level - 1) * _koefLevelToHealth + 1) * _baseHealth;
			_health = maxHealth;
			_HPprogress.gotoAndStop(int(_health / maxHealth * _HPprogress.totalFrames));
			_goldCost = _baseGoldCost;
			_wheatCost = _baseWheatCost;
		}
		
		public function GetLevelUp():void 
		{
			_lvl_up_movie.visible = true;
			_lvl_up_movie.gotoAndPlay(1);
		}
		
		public function SetLevel(value:int):void 
		{
			_level = value;
			updateReferences();
		}
		
		public function SetExperience(value:int):void 
		{
			if (value <= _maxExperience) {
				_experience = value;
			} else {
				_experience = _maxExperience;
			}
		}
		
		protected function searchForLabels():void 
		{
			
		}
		
		protected function onFindTarget(e:Event):void 
		{
			if (!App.isPauseOn && !_isFrightened && !_isWebbed)
			{
				if ((_curEnemyToAttack != null) && (!_curEnemyToAttack.isDead))
				{
					
					distance = Math.sqrt((_curEnemyToAttack.x - _currentCell.x) * (_curEnemyToAttack.x - _currentCell.x) 
													+ (_curEnemyToAttack.y - _currentCell.y) * (_curEnemyToAttack.y - _currentCell.y) / ( App.YScale * App.YScale ));
					if (distance <= _attackRange)
					{
						shootTo();
						return;
					}
					else
					{
						_curEnemyToAttack = null;
					}
				}
				var length:int = enemiesArray.length;
				var tmpEnemy:Enemy;
				for (var i:int = 0; i < length; i++)
				{
					tmpEnemy = enemiesArray[i];
					if (tmpEnemy is Flying)
					{
						if (!isAirKiller)
						{
							continue;
						}
					}
					distance = Math.sqrt((tmpEnemy.x - _currentCell.x) * (tmpEnemy.x - _currentCell.x) 
													+ (tmpEnemy.y - _currentCell.y) * (tmpEnemy.y - _currentCell.y) / ( App.YScale * App.YScale));
					if (distance <= _attackRange)
					{
						_curEnemyToAttack = tmpEnemy;
						shootTo();
						return;
					}
				}
			}
		}
		
		public function AddBonus(damage:int = 0, crit:int = 0, accuracy:int = 0, range:int = 0):void 
		{
			BONUS_damage = damage;
			BONUS_crit = crit;
			BONUS_accuracy = accuracy;
			BONUS_range = range;
		}
		
		protected function shootTo():void 
		{	
			var angle:int = App.angleFinding(new Point(_currentCell.x, _currentCell.y), new Point(_curEnemyToAttack.x, _curEnemyToAttack.y)) % 360;
			var quarter:int = angle / 90;
			switch(quarter)
			{
				case 0:
				towerMovie.gotoAndStop("right_up");
				break;
				case 1:
				towerMovie.gotoAndStop("right_down");
				break;
				case 2:
				towerMovie.gotoAndStop("left_down");
				break;
				case 3:
				towerMovie.gotoAndStop("left_up");
				break;
			}
			var tmpPosa:MovieClip = towerMovie.getChildAt(0) as MovieClip;
			var numLabels:int = tmpPosa.currentLabels.length;
			var rndAttackType:int = App.randomInt(0, numLabels);
			var nameLable:String = (tmpPosa.currentLabels[rndAttackType] as FrameLabel).name;
			tmpPosa.gotoAndPlay(nameLable);
			_isShooting = true;
			towerMovie.addEventListener("shoot", onShoot, false, 0, true);
		}
		
		public function StartBuff(time:int):void 
		{
			_buffTimer.delay = time;
			_buffTimer.repeatCount = 1;
			_buffTimer.addEventListener(TimerEvent.TIMER, onStopBuff, false, 0, true);
			_buffTimer.start();
			_isBaffed = true;
		}
		
		private function onStopBuff(e:TimerEvent = null):void 
		{
			_buffTimer.reset();
			_buffTimer.removeEventListener(TimerEvent.TIMER, onStopBuff, false);
			_isBaffed = false;
			_BonusesObject.buffDamage = 0;
			_BonusesObject.buffCritChance = 0;
			_BonusesObject.buffCritPower = 0;
			_BonusesObject.buffRange = 0;
			calculateAddedDamage();
		}
		
		protected function onShoot(e:Event):void 
		{
			towerMovie.removeEventListener("shoot", onShoot, false);
			_isShooting = false;
		}
		
		public function destroyPreBuildedTower():void 
		{
			alpha = 1;
		}
		
		public function QuitWeb():void
		{
			if (_isWebbed)
			{
				_isWebbed = false;
			}
		}
		
		public function AddWeb():void
		{
			if (!_isWebbed)
			{
				_isWebbed = true;
			}
		}
		
		public function ImportFromTowerData(towerData:TowerData):void 
		{
			if (towerData.realTitle != null) { _title = towerData.realTitle; }
			goldCost = towerData.goldCost;
			wheatCost  = towerData.whealCost;
			SetExperience(towerData.experience);
			//experience = towerData.experience;
			//level = towerData.level;
			SetLevel(towerData.level);
			realName = towerData.realName;
			_movieClipLabel = towerData.title;
			skillPoints = towerData.skillPoints;
			_descriptionText = towerData.description;
			for (var count:int = 0; count < App.SKILLS_NMBR; count++)
			{
				if (towerData.skillsArray[count] != null)
				{
					skillsArray[count].currentLevel = towerData.skillsArray[count].currentLevel;
					skillsArray[count].isAvailable = towerData.skillsArray[count].isAvailable;
				}
				else
				{
					skillsArray[count].currentLevel = 0;
					skillsArray[count].isAvailable = false;
				}
			}
			calculateSkills();
			calculateAddedDamage();
		}
		
		public function destroy():void 
		{
			onStopAdditionalMoneySpell();
			QuitFear();
			QuitWeb();
			removeChild(_HPprogress);
			towerMovie.removeEventListener("shoot", onShoot, false);
			_attackTimer.stop();
			_attackTimer.removeEventListener(TimerEvent.TIMER, onFindTarget, false);
			if (_isBaffed)
			{
				onStopBuff();
			}
			removeChild(_lvl_up_movie);
			towerMovie.gotoAndStop(1);
			//removeChild(towerMovie);
			_currentCell.removeChild(this);
			_currentCell.tower = null;
			_currentCell.ableState = App.CELL_STATE_FREE;
			_currentCell = null;
			_curEnemyToAttack = null;
			skillPoints = 0;
			this.x = 0;
			this.y = 0;
			var tmpArray:Array = App.universe.towersArray;
			var length:int = tmpArray.length;
			for (var i:int = 0; i < length; i++)
			{
				if (tmpArray[i] == this)
				{
					tmpArray.splice(i, 1);
					break;
				}
			}
		}
		
		public function TowerTakingDamage(damage:int):void 
		{
			if (!isHero)
			{
				_health -= damage;
				_HPprogress.gotoAndStop(int(_health / maxHealth * _HPprogress.totalFrames));
				if (_health <= 0)
				{
					_dyingTower.gotoAndPlay(1);
					_currentCell.addChild(_dyingTower);
					App.soundControl.playSound("tower_death");
					destroy();
				}
			}
		}
		
		public function calculateAddedDamage():void 
		{
			addedDamage = 0;
			addedDamage += BonusesObject.buffDamage;
			if (BonusesObject.auraDamage != 0)
			{
				var a:int = (damageMin + damageMax) / 2;
				addedDamage += int(a * BonusesObject.auraDamage / 100);
			}
			//addedDamage += BonusesObject.auraDamage;
			if (_skillsInfluence.addedDamage != null)
			{
				addedDamage += _skillsInfluence.addedDamage;
			}
			if (_skillsInfluence.addedDamagePercent != 0 && _skillsInfluence.addedDamagePercent != null)
			{
				var tmpInt:int = (damageMin + damageMax) / 2;
				tmpInt = tmpInt * (_skillsInfluence.addedDamagePercent / 100);
				addedDamage += tmpInt;
			}
			
			addedCriticalChance = 0;
			addedCriticalChance += BonusesObject.auraCritChance;
			addedCriticalChance += BonusesObject.buffCritChance;
			if (_skillsInfluence.addedCritical != null)
			{
				addedCriticalChance += _skillsInfluence.addedCritical;
			}
			
			addedCriticalPower = 0;
			addedCriticalPower += BonusesObject.auraCritPower;
			addedCriticalPower += BonusesObject.buffCritPower;
			if (_skillsInfluence.addedCriticalPower != null)
			{
				addedCriticalPower += _skillsInfluence.addedCriticalPower;
			}
			
			addedRange = 0;
			addedRange += BonusesObject.auraRange;
			addedRange += BonusesObject.buffRange;
			if (_skillsInfluence.addedRange != null)
			{
				addedRange += _skillsInfluence.addedRange;
			}
			
			addedAccuracy = 0;
			if (_skillsInfluence.addedAccuracy != null)
			{
				addedAccuracy += _skillsInfluence.addedAccuracy;
			}
			
			if (_skillsInfluence.addedSpellsDamage != 0 && _skillsInfluence.addedSpellsDamage != null)
			{
				App.universe.increasedSpellsDamage = _skillsInfluence.addedSpellsDamage;
			}
		}
		
		public function AdditionalMoneyMagic(skill_level:int, timerDelay:int):void 
		{
			if (!_isBuffedWithAdditionalMoney)
			{
				_isBuffedWithAdditionalMoney = true;
				_addedMoneyForKilling = BASE_ADDED_MONEY + KOEFFICIENT_OF_ADDED_MONEY_PER_LEVEL * skill_level;
				_additionalMoneyTimer.delay = timerDelay;
				_additionalMoneyTimer.start();
				_additionalMoneyTimer.addEventListener(TimerEvent.TIMER, onStopAdditionalMoneySpell, false, 0, true);
				_isAdditionalMoneySpell.y = -40;
				addChild(_isAdditionalMoneySpell);
			}
		}
		
		public function addExperienceEqualsToLevel():void 
		{
			SetExperience(_baseExpToNextLevel * expKoefficientsArray[level - 2]);
		}
		
		private function onStopAdditionalMoneySpell(e:TimerEvent = null):void 
		{
			if (_isBuffedWithAdditionalMoney)
			{
				_isBuffedWithAdditionalMoney = false;
				_addedMoneyForKilling = 0;
				_additionalMoneyTimer.reset();
				_additionalMoneyTimer.removeEventListener(TimerEvent.TIMER, onStopAdditionalMoneySpell, false);
				if (contains(_isAdditionalMoneySpell))
				{
					removeChild(_isAdditionalMoneySpell);
				}
			}
		}
		
		public function get damageMax():int { return _damageMax; }
		
		public function get damageMin():int { return _damageMin; }
		
		public function get attackRange():int { return _attackRange; }
		
		public function get level():int { return _level; }
		
		public function set level(value:int):void 
		{
			skillPoints++;
			GetLevelUp();
			_level = value;
			updateReferences();
		}
		
		public function get type():String { return _type; }
		
		public function get wheatCost():int { return _wheatCost; }
		
		public function get goldCost():int { return _goldCost; }
		
		public function get experience():int { return _experience; }
		
		public function set experience(value:int):void 
		{
			if (value > _maxExperience) {
				_experience = _maxExperience;
			} else {
				_experience = value;
			}
			
			if (_experience > _experienceToNextLevel)
			{
				level = level + (_experience / _experienceToNextLevel);
				_experience = _experience % _experienceToNextLevel;
			}
		}
		
		public function get attackSpeed():int { return _attackSpeed; }
		
		public function get currentCell():Grid { return _currentCell; }
		
		public function get title():String { return _title; }
		
		public function set type(value:String):void 
		{
			_type = value;
			switch(value)
			{
				case "ArcherTwr":
				_title = "Elite Archer";
				break;
				case "ClubmanTwr":
				_title = "Cave Overseer";
				break;
				case "HummerStoneTwr":
				_title = "Warhammer";
				break;
				case "SwordmanTwr":
				_title = "Elite Swordbearer";
				break;
				case "EliteSpearmanTwr":
				_title = "Elite Spearman";
				break;
				case "HummerManTwr":
				_title = "Reptile Hunter";
				break;
				case "HunterTwr":
				_title = "Mammoth Hunter";
				break;
				case "JavelinThrowerTwr":
				_title = "Deathdarter";
				break;
				case "RangerTwr":
				_title = "Hawkeye";
				break;
				case "RegularSpearmanTwr":
				_title = "Boarkiller";
				break;
				case "SlingManTwr":
				_title = "Squirrel Hunter";
				break;
				case "SpearmanTwr":
				_title = "Caveguard";
				break;
				case "StoneThrowerTwr":
				_title = "Cavekeeper";
				break;
				case "WoodcutterTwr":
				_title = "Woodcuter";
				break;
				case "ShamanTwr":
				_title = "Dreamcatcher";
				break;
				case "WarriorTwr":
				_title = "Prairielord";
				break;
				case "BerserkTwr":
				_title = "Desertwatcher";
				break;
				case "GladiatorTwr":
				_title = "Gladiator";
				break;
				case "RobinHoodTwr":
				_title = "Woodmarshal";
				break;
				default:
				_title = value;
				break;
			}
		}
		
		public function get experienceToNextLevel():int { return _experienceToNextLevel; }
		
		public function get damageType():int { return _damageType; }
		
		public function set wheatCost(value:int):void 
		{
			_wheatCost = value;
		}
		
		public function set goldCost(value:int):void 
		{
			_goldCost = value;
		}
		
		public function get isHero():Boolean { return _isHero; }
		
		public function get BONUS_damage():int { return _BONUS_damage; }
		
		public function set BONUS_damage(value:int):void 
		{
			_BONUS_damage = value;
		}
		
		public function get BONUS_crit():int { return _BONUS_crit; }
		
		public function set BONUS_crit(value:int):void 
		{
			_BONUS_crit = value;
		}
		
		public function get BONUS_accuracy():int { return _BONUS_accuracy; }
		
		public function set BONUS_accuracy(value:int):void 
		{
			_BONUS_accuracy = value;
		}
		
		public function get BONUS_range():int { return _BONUS_range; }
		
		public function set BONUS_range(value:int):void 
		{
			_BONUS_range = value;
		}
		
		public function get skillsArray():Array { return _skillsArray; }
		
		public function set skillsArray(value:Array):void 
		{
			_skillsArray = value;
		}
		
		public function get accuracy():Number { return _accuracy; }
		
		public function set accuracy(value:Number):void 
		{
			_accuracy = value;
		}
		
		public function get criticalPower():Number { return _criticalPower; }
		
		public function set criticalPower(value:Number):void 
		{
			_criticalPower = value;
		}
		
		public function get criticalChance():Number { return _criticalChance; }
		
		public function set criticalChance(value:Number):void 
		{
			_criticalChance = value;
		}
		
		public function get isBaffed():Boolean { return _isBaffed; }
		
		public function set isBaffed(value:Boolean):void 
		{
			_isBaffed = value;
		}
		
		public function get maxHealth():int { return _maxHealth; }
		
		public function set maxHealth(value:int):void 
		{
			_maxHealth = value;
		}
		
		public function get BonusesObject():Object { return _BonusesObject; }
		
		public function set BonusesObject(value:Object):void 
		{
			_BonusesObject = value;
		}
		
		public function get addedDamage():int { return _addedDamage; }
		
		public function set addedDamage(value:int):void 
		{
			_addedDamage = value;
		}
		
		public function get addedCriticalPower():Number { return _addedCriticalPower; }
		
		public function set addedCriticalPower(value:Number):void 
		{
			_addedCriticalPower = value;
		}
		
		public function get addedCriticalChance():int { return _addedCriticalChance; }
		
		public function set addedCriticalChance(value:int):void 
		{
			_addedCriticalChance = value;
		}
		
		public function get addedRange():int { return _addedRange; }
		
		public function set addedRange(value:int):void 
		{
			_addedRange = value;
		}
		
		public function get realName():String { return _realName; }
		
		public function set realName(value:String):void 
		{
			_realName = value;
		}
		
		public function get skillsInfluence():Object { return _skillsInfluence; }
		
		public function set skillsInfluence(value:Object):void 
		{
			_skillsInfluence = value;
		}
		
		public function get addedAccuracy():int { return _addedAccuracy; }
		
		public function set addedAccuracy(value:int):void 
		{
			_addedAccuracy = value;
		}
		
		public function get bleedTime():int { return _bleedTime; }
		
		public function get bleedDelay():int { return _bleedDelay; }
		
		public function get bleedDamage():int { return _bleedDamage; }
		
		public function get slowPercentage():int { return _slowPercentage; }
		
		public function get slowTime():int { return _slowTime; }
		
		public function get stunTime():int { return _stunTime; }
		
		public function get movieClipLabel():String { return _movieClipLabel; }
		
		public function get skillPoints():int { return _skillPoints; }
		
		public function set skillPoints(value:int):void 
		{
			_skillPoints = value;
		}
		
		public function get addedMoneyForKilling():int { return _addedMoneyForKilling; }
		
		public function get isAirKiller():Boolean { return _isAirKiller; }
		
		public function set isAirKiller(value:Boolean):void 
		{
			_isAirKiller = value;
		}
		
		public function get towerMovie():MovieClip { return _towerMovie; }
		
		public function set towerMovie(value:MovieClip):void 
		{
			_towerMovie = value;
		}
		
		public function get descriptionText():String { return _descriptionText; }
		
		public function set descriptionText(value:String):void 
		{
			_descriptionText = value;
		}
		
		public function get experienceToCurrentLevel():int { return _experienceToCurrentLevel; }
	}

}