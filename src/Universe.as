package  
{
	import Enemies.*;
	import Enemies.FlyingEnemies.*;
	import Events.AddNewWave;
	import Events.ChangeCursor;
	import Events.EndLevelEvent;
	import Events.InGameEvent;
	import Events.PauseEvent;
	import Events.PlayAnimation;
	import Events.SpellCastingEvent;
	import Events.TowerBuilding;
	import Events.UniverseDestroying;
	import Events.UniverseEvent;
	import Events.WinOrLooseEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import menus.InGameMenu;
	import Towers.ArcherTwr;
	import Towers.ClubmanTwr;
	import Towers.HummerStoneTwr;
	import Towers.SwordmanTwr;
	/**
	 * ...
	 * @author author
	 */
	public class Universe extends Sprite
	{
		public static var additional_diamonds:int;
		
		private var roadFieldSprite:Sprite = new Sprite();
		
		private var _mapMask:Array;
		private var _enemiesArray:Array = [];
		private var _towersArray:Array = [];
		private var _checksArray:Array = [];
		private var _wavesArray:Array = [];
		
		public var increasedSpellsDamage:int = 0;
		
		private var _enemiesAddingTimer:Timer = new Timer(0);
		private var _currentWave:Wave;
		private var _ground:Sprite = new Sprite();
		private var _mainLayer:Sprite = new Sprite();
		private var _radiusLayer:Sprite = new Sprite();
		private var _ableGridLayer:Sprite = new Sprite();
		private var _towerRangeSprite:Sprite = new towerRadiusMovie();
		private var _magicRangeSprite:Sprite = new towerRadiusMovie2();
		private var _eggsLayer:Sprite = new Sprite();
		private var _peageonsLayer:Sprite = new Sprite();
		private var _bulletsLayer:Sprite = new Sprite();
		private var _critsLayer:Sprite = new Sprite();
		private var _magicLayer:Sprite = new Sprite();
		private var _weatherLayer:Sprite = new Sprite();
		private var _flyingDamageLayer:Sprite = new Sprite();
		private var _keysLayer:Sprite = new Sprite();
		private var _keysControlLayer:Sprite = new Sprite();
		private var _cursorsLayer:Sprite = new Sprite();
		private var _menuOnStage:Boolean;
		private var isBuildingTower:Boolean;
		private var _towerToBuild:TowerData;
		private var _isCampExists:Boolean;
		private var _campObject:CampControl;
		private var _buildingTower:Tower;
		private var _upperGridArray:Array = [];
		private var _isLastWave:Boolean;
		private var _isEveryEnemyDied:Boolean;
		private var _isSpellUsing:Boolean;
		private var _currentMagic:Spell;
		private var _wheatArray:Array = [];
		private var _wheatherMovie:MovieClip = new weatherMovie();
		
		private var _wavesCount:int;
		private var _passedWaves:int;
		private var _destroyedEnemiesCount:int;
		private var _totalEnemiesCount:int;
		private var _wheatCount:int;
		private var _goldCount:int;
		private var _experienceGainedCount:int;
		
		private var _isWaveKilled:Boolean = false;
		private var _isDataToDelete:Boolean = false;
		
		private var _keysCount:int;
		private var _cantPassNextWave:Boolean = false;
		private var _tmpWinFlag:String = "";
		private var _EventListenersArray:Array = [];
		private var _runningTimersArray:Array = [];
		private var _keyMovie:MovieClip = new keysMovie();
		private var _podlozhka:MovieClip = new roadTileSprite();
		private var _isShaking:Boolean;
		private static const SHAKING_LENGTH:int = 30;
		private static const SHAKING_COORDINATES_DELAY:int = 25;
		private var _shaking_delay:int;
		private var _shaking_counter:int;
		public var warriorTwr:Tower = null;
		
		public function Universe() 
		{
			addChild(_ground);
			addChild(_mainLayer);
			_campObject = new CampControl();
			addChild(_radiusLayer);
			addChild(_ableGridLayer);
			_towerRangeSprite.visible = false;
			_magicRangeSprite.visible = false;
			_radiusLayer.addChild(_towerRangeSprite);
			_radiusLayer.addChild(_magicRangeSprite);
			addChild(_eggsLayer);
			addChild(_peageonsLayer);
			addChild(_bulletsLayer);
			addChild(_critsLayer);
			Bullet.layer = _bulletsLayer;
			addChild(_magicLayer);
			addChild(_weatherLayer);
			_weatherLayer.mouseEnabled = false;
			_weatherLayer.addChild(_wheatherMovie);
			_wheatherMovie.mouseEnabled = false;
			addChild(_flyingDamageLayer);
			addChild(_keysLayer);
			_keysControlLayer.mouseEnabled = false;
			_keysControlLayer.addChild(_keyMovie);
			_keyMovie.x = 550;
			_keyMovie.y = 45;
			_keyMovie.gotoAndStop(1);
			_keyMovie.mouseEnabled = false;
			addChild(_keysControlLayer);
			addChild(_cursorsLayer);
			clearMapMask();
			//addUpperGrid();
			Tower.enemiesArray = _enemiesArray;
			Tower.towersArray = _towersArray;
			Egg.towers_array = _towersArray;
		}
		
		private function updateUpperGrid():void 
		{
			var tmpSprite:Sprite;
			for (var i:int = 0; i < App.MAP_SIZE; i++)
			{
				for (var j:int = 0; j < App.MAP_SIZE; j++)
				{
					tmpSprite = _upperGridArray[i][j];
					var tmpX:int = App.Half_W_DIV + j * App.Half_Cell_W - App.Half_Cell_W * i;
					var tmpY:int = - App.Cell_H * 5 + App.Half_Cell_H + i * App.Half_Cell_H + App.Half_Cell_H * j;
					tmpSprite.x = tmpX;
					tmpSprite.y = tmpY;
				}
			}
		}
		
		private function takeLevelCountsToZero():void 
		{
			additional_diamonds = 0;
			_wavesCount = 0;
			_passedWaves = 0;
			_destroyedEnemiesCount = 0;
			_totalEnemiesCount = 0;
			_wheatCount = 0;
			_goldCount = 0;
			_experienceGainedCount = 0;
			_isShaking = false;
			
			_isWaveKilled = true;
			_cantPassNextWave = false;
			
			increasedSpellsDamage = 0;
		}
		
		public function changeKeysCount(value:int):void
		{
			_keyMovie.gotoAndStop(value);
		}
		
		private function updateUpperGridHeightsForLevel():void 
		{
			var tmpSprite:Sprite;
			var tmpGrid:Grid;
			for (var i:int = 0; i < App.MAP_SIZE; i++)
			{
				for (var j:int = 0; j < App.MAP_SIZE; j++)
				{
					tmpGrid = _mapMask[j][i];
					tmpSprite = _upperGridArray[i][j];
					tmpSprite.y -= tmpGrid.gridHeight;
				}
			}
		}
		
		public function init(lvlSignatura:String):void 
		{
			FlyingDamage.layer = _flyingDamageLayer;
			takeLevelCountsToZero();
			App.cursorControl.addUniverseCursor();
			//read from signature:   ---------------------------------------------------------------------------------------------
			var signatura:Array = lvlSignatura.split(App.DELIMITER);
			//настройка волн
			var length:int = signatura.shift();
			var tmpArray:Array;
			
			_podlozhka.gotoAndStop(searchForPodlozhkaFrame());
			
			for (var i:int = 0; i < length; i++)
			{
				var tmpWaveSignature:String = signatura.shift();
				var tmpAddedWave:Wave = App.pools.getPoolObject(Wave.NAME);
				_wavesArray.push(tmpAddedWave);
				tmpArray = tmpWaveSignature.split(App.DELIMITER2);
				var isThereAKey:Boolean = false;
				isThereAKey = (tmpArray[10] == "1") ? true : false;
				tmpAddedWave.Init(tmpArray[0], int(tmpArray[1]), int(tmpArray[2]), int(tmpArray[3]), int(tmpArray[4]), int(tmpArray[5]), int(tmpArray[6]), int(tmpArray[7]), int(tmpArray[8]), int(tmpArray[9]), isThereAKey, int(tmpArray[11]));
				_totalEnemiesCount += int(tmpArray[1]);
			}
			
			var tmpCheckpointsArray:Array = signatura.shift().split(App.DELIMITER2);
			length = tmpCheckpointsArray.shift();
			
			for (i = 0; i < length; i++)
			{
				var tmpCheck:Checkpoint = App.pools.getPoolObject(Checkpoint.NAME);
				tmpCheck.Init(new Point(tmpCheckpointsArray.shift(), tmpCheckpointsArray.shift()));
				var ptsLength:int = tmpCheckpointsArray.shift();
				var addedCheck:Checkpoint;
				
				for (var j:int = 0; j < ptsLength; j++)
				{
					addedCheck = App.pools.getPoolObject(Checkpoint.NAME);
					addedCheck.Init(new Point(tmpCheckpointsArray.shift(), tmpCheckpointsArray.shift()));
					tmpCheck.addCheckpoint(addedCheck);
				}
				_checksArray.push(tmpCheck);
			}
			
			//checkpoints ordering
			/*var lastCheck:Checkpoint;
			for (i = 0; i < _checksArray.length; i++)
			{
				tmpCheck = _checksArray[i];
				if (tmpCheck.nextPointArray.length == 0)
				{
					lastCheck = tmpCheck;
					_checksArray.splice(i, 1);
					continue;
				}
			}	
			_checksArray.push(lastCheck);*/
			
			//настройка ячеек
			for (i = 0; i < App.MAP_SIZE; i++)
			{
				for (j = 0; j < App.MAP_SIZE; j++)
				{
					var tmpGridArray:Array = signatura.shift().split(App.DELIMITER2);
					var cellState:int = tmpGridArray.shift();
					var cellHeight:int = tmpGridArray.shift();
					var cellAbleState:String = tmpGridArray.shift();
					setCellState(i, j, cellState, cellAbleState);
					var tmpGrid:Grid = _mapMask[j][i];
					tmpGrid.ableMovie.gotoAndStop(cellAbleState);
					tmpGrid.gridHeight = cellHeight;
					
					if (tmpGridArray.shift() == "1")
					{
						tmpGrid.isCampOwner = true;
						_isCampExists = true;
						_campObject.Init(tmpGrid);
					}
					
					var objectsLength:int = tmpGridArray.shift();
					
					for (var k:int = 0; k < objectsLength; k++)
					{
						var tmpType:int = tmpGridArray.shift();
						tmpGrid.addObject(tmpGridArray.shift(), tmpGridArray.shift(), tmpType);
					}
				}
			}
			
			// end reading signature------------------------------------------------------------------------------
			
			_wavesCount = _wavesArray.length;
			App.waveLine.Init(_wavesArray);
			InitTmpPlayerArrays();
			_isLastWave = false;
			_isSpellUsing = false;
			_isEveryEnemyDied = false;
			_isDataToDelete = false;
			objectsArrayOrdering();
			//updateUpperGridHeightsForLevel();
			addEventListeners();
			keysCount = 0;
			changeKeysCount(keysCount);
			
			// тест
			//_wavesArray.length = 0;
			//var tmpWave:Wave = new Wave();
			//tmpWave.Init(Pterodaktel.NAME, 1, 1000, 100, 0, 10, 0, 0 , 0, 0);
			//_wavesArray.push(tmpWave);
			//tmpWave = new Wave();
			//tmpWave.Init(SmallBlackBird.NAME, 1, 2000, 15000, 10, 22, 0, 0 , 0, 0);
			//_wavesArray.push(tmpWave);
			_wheatherMovie.gotoAndStop(InitWeather());
			App.waveLine.initAboutWavesArray(_wavesArray);
		}
		
		private function InitWeather():int 
		{
			var tmpArray:Array = App.SAND_MAPS_ARRAY;
			var length:int = tmpArray.length;
			var tmpNumber:Number;
			for (var i:int = 0; i < length; i++)
			{
				if (App.currentLevel + 1 == int(tmpArray[i]))
				{
					tmpNumber = Math.random();
					if (tmpNumber < 0.33)
					{
						return 2;
					}
					else if (tmpNumber < 0.66)
					{
						return 3;
					}
					else 
					{
						return 4;
					}
				}
			}
			
			tmpArray = App.OTHER_MAPS_ARRAY;
			length = tmpArray.length;
			for (i = 0; i < length; i++)
			{
				if (App.currentLevel + 1 == int(tmpArray[i]))
				{
					tmpNumber = Math.random();
					if (tmpNumber < 0.5)
					{
						return 3;
					}
					else
					{
						return 4;
					}
				}
			}
			
			tmpNumber = Math.random();
			if (tmpNumber < 0.33)
			{
				return 1;
			}
			else if (tmpNumber < 0.66)
			{
				return 3;
			}
			else
			{
				return 4;
			}
		}
		
		private function InitTmpPlayerArrays():void 
		{
			var tmpPlayerAcc:PlayerAccount = App.currentPlayer;
			var tmpArray:Array = tmpPlayerAcc.heroesTMPArray;
			var notTmpArray:Array = tmpPlayerAcc.heroesArray;
			var length:int = notTmpArray.length;
			var tmpTowerData:TowerData;
			var notTmpTowerData:TowerData;
			tmpArray.length = 0;
			for (var i:int = 0; i < length; i++)
			{
				notTmpTowerData = notTmpArray[i];
				tmpTowerData = App.pools.getPoolObject(TowerData.NAME);
				tmpTowerData.description = notTmpTowerData.description;
				tmpTowerData.experience = notTmpTowerData.experience;
				tmpTowerData.goldCost = notTmpTowerData.goldCost;
				tmpTowerData.isHero = notTmpTowerData.isHero;
				tmpTowerData.isUnlocked = notTmpTowerData.isUnlocked;
				tmpTowerData.level = notTmpTowerData.level;
				tmpTowerData.name = notTmpTowerData.name;
				tmpTowerData.realName = notTmpTowerData.realName;
				tmpTowerData.realTitle = notTmpTowerData.realTitle;
				tmpTowerData.skillPoints = notTmpTowerData.skillPoints;
				tmpTowerData.title = notTmpTowerData.title;
				tmpTowerData.whealCost = notTmpTowerData.whealCost;
				tmpTowerData.skillsArray = [];
				for (var count:int = 0; count < App.SKILLS_NMBR; count++)
				{
					tmpTowerData.skillsArray[count] = new Object();
					tmpTowerData.skillsArray[count].currentLevel = notTmpTowerData.skillsArray[count].currentLevel;
					tmpTowerData.skillsArray[count].isAvailable = notTmpTowerData.skillsArray[count].isAvailable;
				}
				tmpArray.push(tmpTowerData);
			}
			
			notTmpArray = tmpPlayerAcc.armyArray;
			length = notTmpArray.length;
			tmpArray = tmpPlayerAcc.armyTMPArray;
			tmpArray.length = 0;
			for (i = 0; i < length; i++)
			{
				notTmpTowerData = notTmpArray[i];
				tmpTowerData = App.pools.getPoolObject(TowerData.NAME);
				tmpTowerData.description = notTmpTowerData.description;
				tmpTowerData.experience = notTmpTowerData.experience;
				tmpTowerData.goldCost = notTmpTowerData.goldCost;
				tmpTowerData.isHero = notTmpTowerData.isHero;
				tmpTowerData.isUnlocked = notTmpTowerData.isUnlocked;
				tmpTowerData.level = notTmpTowerData.level;
				tmpTowerData.name = notTmpTowerData.name;
				tmpTowerData.realName = notTmpTowerData.realName;
				tmpTowerData.realTitle = notTmpTowerData.realTitle;
				tmpTowerData.skillPoints = notTmpTowerData.skillPoints;
				tmpTowerData.title = notTmpTowerData.title;
				tmpTowerData.whealCost = notTmpTowerData.whealCost;
				tmpTowerData.skillsArray = [];
				for (count = 0; count < App.SKILLS_NMBR; count++)
				{
					tmpTowerData.skillsArray[count] = new Object();
					tmpTowerData.skillsArray[count].currentLevel = notTmpTowerData.skillsArray[count].currentLevel;
					tmpTowerData.skillsArray[count].isAvailable = notTmpTowerData.skillsArray[count].isAvailable;
				}
				tmpArray.push(tmpTowerData);
			}
		}
		
		private function onUpdateMousePosition(e:MouseEvent):void 
		{
			if (isBuildingTower)
			{
				var tmpGrid:Grid;
				var tmpArray:Array = getObjectsUnderPoint(new Point(mouseX, mouseY));
				for (var i:int = tmpArray.length - 1; i >= 0; i--)
				{
					if (tmpArray[i].parent is tileMovie)
					{
						tmpGrid = tmpArray[i].parent.parent;
						break;
					}
				}
				if (tmpGrid != null)
				{
					if (tmpGrid.cellState != App.CELL_STATE_ROAD)
					{
						_buildingTower.x = tmpGrid.x;
						_buildingTower.y = tmpGrid.y - App.HEIGHT_DELAY - tmpGrid.gridHeight;
						_buildingTower.visible = true;
					}
					else
					{
						_buildingTower.visible = false;
					}
				}
			}
			else if (_isSpellUsing)
			{
				//if (_currentMagic.isBuffMagic)
				/*if(_isSpellUsing)
				{
					_magicRangeSprite.x = mouseX;
					_magicRangeSprite.y = mouseY;
				}*/
			}
		}
		
		private function onInterfaceEvent(e:TowerBuilding):void 
		{
			_towerToBuild = e.tower;
			_isDataToDelete = e.deleteData;
			isBuildingTower = true;
			makeGridVisible();
			var tmpTower:Tower;
			if (_towerToBuild.name == "")
			{
				tmpTower = App.pools.getPoolObject(ArcherTwr.NAME);
			}
			else
			{
				tmpTower = App.pools.getPoolObject(_towerToBuild.name);
			}
			
			tmpTower.preBuildInit();
			tmpTower.x = mouseX;
			tmpTower.y = mouseY;
			tmpTower.alpha = 0.4;
			_ableGridLayer.addChild(tmpTower);
			_buildingTower = tmpTower;
		}
		
		private function onIsBattleIsOver(e:Event):void 
		{
			//if ((_enemiesArray.length == 0) && (_wavesArray.length == 0) && (!_campObject.isInBattle) && (_currentWave == null)) 
			if ((_wavesArray.length == 0) && (!_campObject.isInBattle) && (_currentWave == null))
			{
				if (_enemiesArray.length == 0)
				{
					dispatchEvent(new EndLevelEvent(EndLevelEvent.END_LEVEL, true, false, true));
				}
				else
				{
					var count:int = 0;
					for (var i:int = 0; i < _enemiesArray.length; i++)
					{
						if (_enemiesArray[i] is Web) { count++; }
					}
					if (count == _enemiesArray.length)
					{
						dispatchEvent(new EndLevelEvent(EndLevelEvent.END_LEVEL, true, false, true));
					}
				}
			}
		}
		
		public function addEnemy(type:String, enemyHP:int, enemyArmor:int, cost:int, resistBlunt:int, resistSword:int, resistPike:int, resistMagic:int, isKeyOwner:Boolean = false, isBoss:int = 0):Enemy 
		{
			var enemy:Enemy = App.pools.getPoolObject(type);
			enemy.Init(_checksArray, enemyHP, enemyArmor, cost, resistBlunt, resistSword, resistPike, resistMagic, isKeyOwner, isBoss);
			if (enemy is Flying)
			{
				_peageonsLayer.addChild(enemy);
			}
			else if (enemy is Web)
			{}
			else
			{
				_mainLayer.addChild(enemy);
			}
			_enemiesArray.push(enemy);
			return enemy;
		}
		
		public function addTower(towerType:String, xCell:int = 0, yCell:int = 0, _grid:Grid = null, towerData:TowerData = null):void 
		{
			//берем из пула башни
			var tmpTower:Tower = App.pools.getPoolObject(towerType);
			var tmpGrid:Grid;
			if (_grid == null)
			{
				tmpGrid = _mapMask[xCell][yCell];
			}
			else
			{
				tmpGrid = _grid;
			}
			tmpTower.Init(tmpGrid);
			_towersArray.push(tmpTower);
			tmpGrid.ableState = App.CELL_STATE_TOWER;
			if (towerData != null)
			{
				if (tmpTower.type == "WarriorTwr") { warriorTwr = tmpTower; }
				tmpTower.ImportFromTowerData(towerData);
				if (tmpTower.level > 1 && tmpTower.experience == 0)
				{
					tmpTower.addExperienceEqualsToLevel();
				}
				if (towerData.realName == null || towerData.realName == "")
				{
					if (towerData.isHero) 
					{
						switch(towerData.title)
						{
							case "Warrior":
							tmpTower.realName = "Ganzloe";
							break;
							case "Berserk":
							tmpTower.realName = "Malcolin";
							break;
							case "Gladiator":
							tmpTower.realName = "Garpacius";
							break;
							case "Shaman":
							tmpTower.realName = "Redvalentor";
							break;
							case "Robin Hood":
							tmpTower.realName = "Fragonor";
							break;
						}
					}
					else 
					{
						var index:int = App.randomInt(0, Tower.NAMES.length);
						tmpTower.realName = Tower.NAMES[index];
					}
				}
			}
		}
		
		private function onUniverseUpdate(e:Event):void 
		{
			stage.focus = stage;
			var enemyLength:int = _enemiesArray.length;
			for (var i:int = 0; i < enemyLength; i++)
			{
				var tmpEnemy:Enemy = _enemiesArray[i];
				if (!(tmpEnemy is Flying) && !(tmpEnemy is Web))
				{
					enemyArrayOrdering(tmpEnemy);
				}
			}
		}
		
		private function enemyArrayOrdering(enemy:Enemy):void 
		{
			var tmpIndex:int = _mainLayer.getChildIndex(enemy);
			if ( int(enemy.y + 3) < int(_mainLayer.getChildAt(tmpIndex - 1).y))
			{
				_mainLayer.swapChildrenAt(tmpIndex, tmpIndex - 1);
				enemyArrayOrdering(enemy);
			}
			else if ( int(enemy.y + 3) > int(_mainLayer.getChildAt(tmpIndex + 1).y))
			{
				_mainLayer.swapChildrenAt(tmpIndex, tmpIndex + 1);
				enemyArrayOrdering(enemy);
			}
			else
			{
				return;
			}
		}
		
		public function removeEnemy(enemy:Enemy):void 
		{
			if (!(enemy is Flying))
			{
				if (_mainLayer.contains(enemy))
				{
					_mainLayer.removeChild(enemy);
				}
			}
			else
			{
				if (_peageonsLayer.contains(enemy))
				{
					_peageonsLayer.removeChild(enemy);
				}
			}
			
			
			var length:int = _enemiesArray.length;
			for (var i:int = 0; i < length; i++)
			{
				var tmpEnemy:Enemy = _enemiesArray[i];
				if (tmpEnemy == enemy)
				{
					_enemiesArray.splice(i, 1);
					break;
				}
			}
			
			if (_enemiesArray.length == 0)
			{
				_isWaveKilled = true;
				_passedWaves += 1;
				App.waveLine.addEventListenersToWaves();
				if (_cantPassNextWave)
				{
					_cantPassNextWave = false;
					dispatchEvent(new AddNewWave(AddNewWave.READY_FOR_NEXT_WAVE, true, false));
				}
			}
		}
		
		private function objectsArrayOrdering():void 
		{
			var length:int = _mainLayer.numChildren;
			for ( var j:int = 0; j < length; j++)
			{
				for (var i:int = 0; i < length - 1; i++)
				{
					if (_mainLayer.getChildAt(i).y > _mainLayer.getChildAt(i + 1).y)
					{
						_mainLayer.addChildAt(_mainLayer.getChildAt(i + 1), i);
					}
				}
			}
		}
		
		private function clearMapMask():void 
		{	
			/*for (var i:int = 0; i < App.MAP_SIZE; i++)
			{
				for (var j:int = 0; j < App.MAP_SIZE; j++)
				{
					var tmpSprite:Sprite = new roadTileMovie();
					var tmpX:int = App.Half_W_DIV + j * App.Half_Cell_W - App.Half_Cell_W * i;
					var tmpY:int = - App.Cell_H * 5 + App.Half_Cell_H + i * App.Half_Cell_H + App.Half_Cell_H * j;
					tmpSprite.x = tmpX;
					tmpSprite.y = tmpY;
					roadFieldSprite.addChild(tmpSprite);
				}
			}*/
			
			roadFieldSprite.addChild(_podlozhka);
			roadFieldSprite.x = -50;
			roadFieldSprite.y = -10;// - App.Cell_H * 5;
			roadFieldSprite.scaleX = 1;
			roadFieldSprite.scaleY = 1;
			_ground.addChild(roadFieldSprite);
			
			_podlozhka.gotoAndStop(1);
			
			_mapMask = [];
			var tmpGrid:Grid;
			for (var y:int = 0; y < App.MAP_SIZE; y++)
			{
				_mapMask[y] = [];
				for (var x:int = 0; x < App.MAP_SIZE; x++)
				{
					tmpGrid = new Grid(y, x);
					_mainLayer.addChild(tmpGrid);
					_mapMask[y][x] = tmpGrid;
				}
			}
			
			
		}
		
		private function searchForPodlozhkaFrame():int 
		{
			if (App.currentLevel == 10) { return 2; }
			for (var i:int = 0; i < App.PODLOZHKA_DIRT.length; i++)
			{
				if (App.PODLOZHKA_DIRT[i] == App.currentLevel)
				{
					return 1;
				}
			}
			for (i = 0; i < App.PODLOZHKA_SAND.length; i++)
			{
				if (App.PODLOZHKA_SAND[i] == App.currentLevel)
				{
					return 3;
				}
			}
			for (i = 0; i < App.PODLOZHKA_STONEFIELD.length; i++)
			{
				if (App.PODLOZHKA_STONEFIELD[i] == App.currentLevel)
				{
					return 4;
				}
			}
			for (i = 0; i < App.PODLOZHKA_GRASS.length; i++)
			{
				if (App.PODLOZHKA_GRASS[i] == App.currentLevel)
				{
					return 5;
				}
			}
			
			return 1;
		}
		
		public function setCellState(x:int, y:int, state:int = 0, ableState:String = "_"):void 
		{
			if ((y < App.MAP_SIZE) && (x < App.MAP_SIZE) && (y >= 0) && (x >= 0))
			{
				var tmpGrid:Grid = _mapMask[y][x];
				if (state != 0)
				{
					tmpGrid.cellState = state;
				}
				if (ableState != "_")
				{
					tmpGrid.ableState = ableState;
				}
			}
			else
			{
				return;
			}
		}
		
		public function getCellState(x:int, y:int):int 
		{
			if ((x < App.MAP_SIZE) && (y < App.MAP_SIZE) && (x >= 0) && (y >= 0))
			{
				return _mapMask[y][x].cellState;
			}
			else 
			{
				return 0;
			}
		}
		
		public function getAbleCellState(x:int, y:int):String 
		{
			if ((x < App.MAP_SIZE) && (y < App.MAP_SIZE) && (x >= 0) && (y >= 0))
			{
				return _mapMask[y][x].ableState;
			}
			else 
			{
				return "_";
			}
		}
	 
		private function addEventListeners():void 
		{
			addEventListener(Event.ENTER_FRAME, onUniverseUpdate, false, 0, true);
			App.waveLine.addEventListener(AddNewWave.ADD_NEW_WAVE, onWavesAdding, false, 0, true);
			addEventListener(Event.ENTER_FRAME, onIsBattleIsOver, false, 0, true);
			addEventListener(MouseEvent.CLICK, onClickEvent, false, 0, true);
			App.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardEvent, false, 0, true);
			if (_currentWave)
			{
				_enemiesAddingTimer.addEventListener(TimerEvent.TIMER, onAddEnemy, false, 0, true);
			}
			App.ingameInterface.addEventListener(TowerBuilding.BUILDING_TOWER, onInterfaceEvent, false, 0, true);
			App.ingameInterface.addEventListener(PauseEvent.PAUSE, onPauseEvent, false, 0, true);
			App.ingameInterface.addEventListener(PauseEvent.UNPAUSE, onResumeEvent, false, 0, true);
			addEventListener(MouseEvent.MOUSE_MOVE, onUpdateMousePosition, false, 0, true);
			if (_isCampExists)
			{
				_campObject.addEventListener(EndLevelEvent.END_LEVEL, onEndLevelEvent, false, 0, true);
				addEventListener(EndLevelEvent.END_LEVEL, onEndLevelEvent, false, 0, true);
			}
			App.ingameInterface.addEventListener(InGameEvent.SPELL_USING, onSpellUsing, false, 0, true);
		}
		
		private function onResumeEvent(e:PauseEvent):void 
		{
			var tmpObject:Object;
			while (_EventListenersArray.length != 0)
			{
				tmpObject = _EventListenersArray.pop();
				tmpObject.object.addEventListener(tmpObject.type, tmpObject.handler, false, 0, true);
			}
			
			var tmpTimer:Timer;
			while (_runningTimersArray.length != 0)
			{
				tmpTimer = _runningTimersArray.pop();
				tmpTimer.start();
			}
		}
		
		private function onPauseEvent(e:PauseEvent):void 
		{
			_EventListenersArray.length = 0;
			var tmpObject:Object;
			if (this.hasEventListener(Event.ENTER_FRAME))
			{
				tmpObject = new Object();
				tmpObject.object = this;
				tmpObject.type = Event.ENTER_FRAME;
				tmpObject.handler = onUniverseUpdate;
				_EventListenersArray.push(tmpObject);
				removeEventListener(Event.ENTER_FRAME, onUniverseUpdate, false);
			}
			if (this.hasEventListener(Event.ENTER_FRAME))
			{
				tmpObject = new Object();
				tmpObject.object = this;
				tmpObject.type = Event.ENTER_FRAME;
				tmpObject.handler = onIsBattleIsOver;
				_EventListenersArray.push(tmpObject);
				removeEventListener(Event.ENTER_FRAME, onIsBattleIsOver, false);
			}
			if (_isShaking)
			{
				if (this.hasEventListener(Event.ENTER_FRAME))
				{
					tmpObject = new Object();
					tmpObject.object = this;
					tmpObject.type = Event.ENTER_FRAME;
					tmpObject.handler = onShakingEvent;
					_EventListenersArray.push(tmpObject);
					removeEventListener(Event.ENTER_FRAME, onShakingEvent, false);
				}
			}
			if (this.hasEventListener(MouseEvent.CLICK))
			{
				tmpObject = new Object();
				tmpObject.object = this;
				tmpObject.type = MouseEvent.CLICK;
				tmpObject.handler = onClickEvent;
				_EventListenersArray.push(tmpObject);
				removeEventListener(MouseEvent.CLICK, onClickEvent, false);
			}
			if (App.stage.hasEventListener(KeyboardEvent.KEY_DOWN))
			{
				tmpObject = new Object();
				tmpObject.object = App.stage;
				tmpObject.type = KeyboardEvent.KEY_DOWN;
				tmpObject.handler = onKeyboardEvent;
				_EventListenersArray.push(tmpObject);
				App.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyboardEvent, false);
			}
			if (this.hasEventListener(MouseEvent.MOUSE_MOVE))
			{
				tmpObject = new Object();
				tmpObject.object = this;
				tmpObject.type = MouseEvent.MOUSE_MOVE;
				tmpObject.handler = onUpdateMousePosition;
				_EventListenersArray.push(tmpObject);
				removeEventListener(MouseEvent.MOUSE_MOVE, onUpdateMousePosition, false);
			}
			if (this.hasEventListener(EndLevelEvent.END_LEVEL))
			{
				tmpObject = new Object();
				tmpObject.object = this;
				tmpObject.type = EndLevelEvent.END_LEVEL;
				tmpObject.handler = onEndLevelEvent;
				_EventListenersArray.push(tmpObject);
				removeEventListener(EndLevelEvent.END_LEVEL, onEndLevelEvent, false);
			}
			
			// TIMERS
			_runningTimersArray.length = 0;
			if (_enemiesAddingTimer.running)
			{
				_enemiesAddingTimer.stop();
				_runningTimersArray.push(_enemiesAddingTimer);
			}
		}
		
		private function onKeyboardEvent(e:KeyboardEvent):void 
		{
			switch(e.keyCode)
			{
				case 32:
				if (isBuildingTower)
				{
					isBuildingTower = false;
					_buildingTower.destroyPreBuildedTower();
					App.pools.returnPoolObject(_buildingTower.type, _buildingTower);
					_ableGridLayer.removeChild(_buildingTower);
					_buildingTower = null;
					makeGridInvisible();
					App.ingameInterface.makePressSpaceInvisible();
				}
				break;
				case 66:
				dispatchEvent(new UniverseEvent(UniverseEvent.BUILDING_MENU, true, false));
				break;
				
				case Keyboard.ESCAPE:
				App.ingameInterface.onPauseEvent();
				break;
				// TODO добавить хоткеи
				
			}
		}
		
		private function onSpellUsing(e:InGameEvent):void 
		{
			if (_menuOnStage)
			{
				_towerRangeSprite.visible = false;
			}
			if (App.ingameInterface.isWarriorMenuOnScreen)
			{
				dispatchEvent(new UniverseEvent(UniverseEvent.CLOSE_MENU, true, false));
			}
			if (isBuildingTower)
			{
				isBuildingTower = false;
			}
			
			_currentMagic = e.spell;
			_isSpellUsing = true;
			//if (!_currentMagic.isBuffMagic)
			//{
				dispatchEvent(new ChangeCursor(ChangeCursor.CHANGE_CURSOR, ChangeCursor.CURSOR_MAGIC, true, false, _currentMagic.label));
			//}
			//else
			//{
				
			//}
			_magicRangeSprite.x = mouseX;
			_magicRangeSprite.y = mouseY;
			_magicRangeSprite.visible = true;
			_magicRangeSprite.scaleX = _currentMagic.area / 16;
			_magicRangeSprite.scaleY = _currentMagic.area / 16 * App.YScale;
		}
		
		private function onEndLevelEvent(e:EndLevelEvent):void 
		{
			removeEventListeners();
			switch(e.winFlag)
			{
				case true:
				App.soundControl.playSound("win");
				_tmpWinFlag = WinOrLooseEvent.WIN;
				break;
				case false:
				App.soundControl.playSound("loose");
				_tmpWinFlag = WinOrLooseEvent.LOOSE;
				break;
			}
			dispatchEvent(new PlayAnimation(PlayAnimation.PLAY_ANIMATION, true, false, e.winFlag));
			App.ingameInterface.addEventListener("animationOver", onEndAnimationOver, false, 0, true);
		}
		
		private function onEndAnimationOver(e:Event):void 
		{
			App.ingameInterface.removeEventListener("animationOver", onEndAnimationOver, false);
			var tmpPlayer:PlayerAccount = App.currentPlayer;
			var length:int = _towersArray.length;
			var tmpTower:Tower;
			var tmpTowerData:TowerData;
			
			updatePlayerTowersArrays();
			
			destroy(true);
			
			App.MakeSignatureForShObject();
			dispatchEvent(new WinOrLooseEvent(WinOrLooseEvent.END_LEVEL, true, false, _tmpWinFlag, _destroyedEnemiesCount, _totalEnemiesCount, _goldCount, _wheatCount, _passedWaves, _wavesCount, _experienceGainedCount, _campObject.wasInBattle));
		}
		
		private function updatePlayerTowersArrays():void 
		{
			var tmpTowerData:TowerData;
			var length:int = _towersArray.length;
			var tmpTower:Tower;
			for (i = 0; i < length; i++)
			{
				tmpTower = _towersArray[i];
				tmpTowerData = App.pools.getPoolObject(TowerData.NAME);
				tmpTowerData.ImportFromTower(tmpTower);
				if (!tmpTower.isHero)
				{
					App.currentPlayer.armyArray.push(tmpTowerData);
				}
				else
				{
					App.currentPlayer.heroesArray.push(tmpTowerData);
				}
			}
			
			var tmpArray:Array = App.currentPlayer.armyTMPArray;
			length = tmpArray.length;
			for (var i:int = 0; i < length; i++)
			{
				tmpTowerData = tmpArray[i];
				tmpTowerData.destroy();
			}
			tmpArray = App.currentPlayer.heroesTMPArray;
			length = tmpArray.length;
			for (i = 0; i < length; i++)
			{
				tmpTowerData = tmpArray[i];
				tmpTowerData.destroy();
			}
		}
		
		private function removeEventListeners():void 
		{
			removeEventListener(Event.ENTER_FRAME, onUniverseUpdate, false);
			removeEventListener(Event.ENTER_FRAME, onIsBattleIsOver, false);
			App.waveLine.removeEventListener(AddNewWave.ADD_NEW_WAVE, onWavesAdding, false);
			_enemiesAddingTimer.removeEventListener(TimerEvent.TIMER, onAddEnemy, false);
			removeEventListener(MouseEvent.CLICK, onClickEvent, false);
			removeEventListener(MouseEvent.MOUSE_MOVE, onUpdateMousePosition, false);
			App.ingameInterface.removeEventListener(InGameEvent.SPELL_USING, onSpellUsing, false);
			App.ingameInterface.removeEventListener(TowerBuilding.BUILDING_TOWER, onInterfaceEvent, false);
			App.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyboardEvent, false);
			if (_isCampExists)
			{
				_campObject.removeEventListener(EndLevelEvent.END_LEVEL, onEndLevelEvent);
				removeEventListener(EndLevelEvent.END_LEVEL, onEndLevelEvent, false);
			}
		}
		
		private function onClickEvent(e:MouseEvent):void 
		{
			var tmpArray:Array = getObjectsUnderPoint(new Point(mouseX, mouseY));
			for (var i:int = tmpArray.length - 1; i >= 0; i--)
			{
				if (tmpArray[i].parent is tileMovie)
				{
					var tmpGrid:Grid = tmpArray[i].parent.parent;
					break;
				}
			}
			if (tmpGrid != null)
			{
				// 1. если открыто меню 
				if (_menuOnStage)
				{
					_towerRangeSprite.visible = false;
				}
				// 2. если открыто меню башни
				if (App.ingameInterface.isWarriorMenuOnScreen)
				{
					dispatchEvent(new UniverseEvent(UniverseEvent.CLOSE_MENU, true, false));
				}
				// 3. если строится башня - построить башню
				if (isBuildingTower)
				{
					if (tmpGrid.ableState == App.CELL_STATE_FREE)
					{
						App.soundControl.playSound("tower_install");
						isBuildingTower = false;
						_buildingTower.destroyPreBuildedTower();
						App.pools.returnPoolObject(_buildingTower.type, _buildingTower);
						_ableGridLayer.removeChild(_buildingTower);
						_buildingTower = null;
						
						makeGridInvisible();
						App.ingameInterface.makePressSpaceInvisible();
						if (_towerToBuild.name == "")
						{
							addTower(ArcherTwr.NAME, 0, 0, tmpGrid);
						}
						else
						{
							addTower(_towerToBuild.name, 0, 0, tmpGrid, _towerToBuild);
						}
						App.currentPlayer.gold -= _towerToBuild.goldCost;
						App.currentPlayer.wheat -= _towerToBuild.whealCost;
						if (_towerToBuild.isHero)
						{
							for (i = 0; i < App.currentPlayer.heroesArray.length; i++)
							{
								if (_towerToBuild == App.currentPlayer.heroesArray[i])
								{
									App.currentPlayer.heroesArray.splice(i, 1);
									break;
								}
							}
						}
						else
						{
							for (i = 0; i < App.currentPlayer.armyArray.length; i++)
							{
								if (_towerToBuild == App.currentPlayer.armyArray[i])
								{
									App.currentPlayer.armyArray.splice(i, 1);
									break;
								}
							}
						}
					}
					return;
				}
				// 4. если юзается магия - заюзать магию
				if (_isSpellUsing)
				{
					if (_currentMagic.isTrap)
					{
						if (tmpGrid.cellState == App.CELL_STATE_ROAD)
						{
							App.currentPlayer.gold -= _currentMagic.castCost;
							_currentMagic.UseMagic(tmpGrid);
							dispatchEvent(new SpellCastingEvent(SpellCastingEvent.NEW_COOLDOWN, true, false, _currentMagic));
							destroyMagicUsing();
							return;
						}
						else
						{
							return;
						}
					}
					else
					{
						App.currentPlayer.gold -= _currentMagic.castCost;
						_currentMagic.UseMagic(tmpGrid);
						dispatchEvent(new SpellCastingEvent(SpellCastingEvent.NEW_COOLDOWN, true, false, _currentMagic));
						destroyMagicUsing();
						return;
					}
				}
				// 5. если в ячейке башня - открыть меню башни 
				if (tmpGrid.tower != null)
				{
					_menuOnStage = true;
					var tmpTower:Tower = tmpGrid.tower;
					_towerRangeSprite.x = tmpGrid.x;
					_towerRangeSprite.y = tmpGrid.y - tmpGrid.gridHeight - App.HEIGHT_DELAY;
					_towerRangeSprite.scaleX = (tmpTower.attackRange + tmpTower.addedRange) / 16;
					_towerRangeSprite.scaleY = ((tmpTower.attackRange + tmpTower.addedRange) / 16) * App.YScale;
					_towerRangeSprite.visible = true;
					dispatchEvent(new UniverseEvent(UniverseEvent.TOWER_MENU, true, false, tmpTower));
					return;
				}
				// 6. если в ячейке сундук - открыть сундук
				/*
				if (tmpGrid.isChestOwner)
				{
					if (_keysCount > 0)
					{
						var tmpObject:MovieClip;
						if (tmpGrid.objectsArray.length > 1)
						{
							trace("НЕСКОЛЬКО ОБЪЕКТОВ В ЯЧЕЙКЕ С СУНДУКОМ!");
							return;
						}
						else
						{
							tmpObject = tmpGrid.objectsArray[0].objectSkin;
						}
					}
					return;
				}
				*/
				// 7. если в ячейке сено - скосить сено
				if (tmpGrid.isWheatOwner)
				{
					var tmpWheat:WheatControl = tmpGrid.wheat;
					if (tmpWheat.tile.currentFrame == tmpWheat.tile.totalFrames)
					{
						App.soundControl.playSound("moving_hay");
						var tmpNumber:Number = WheatControl.WHEAT_COUNT * (1 + 2 * (App.agriculture / 100));
						var totalAddedWheat:int = WheatControl.WHEAT_COUNT + Math.ceil(tmpNumber);
						App.currentPlayer.wheat += totalAddedWheat;
						_wheatCount += totalAddedWheat;
						var tmpFlyindDmg:FlyingDamage = App.pools.getPoolObject(FlyingDamage.NAME);
						tmpFlyindDmg.Init(new Point(tmpGrid.x, tmpGrid.y - 15), totalAddedWheat, 0 ,0 , true);
						tmpWheat.tile.gotoAndPlay(1);
					}
				}
			}		
		}
		
		public function destroyMagicUsing():void 
		{
			if (_isSpellUsing)
			{
				//if (!_currentMagic.isBuffMagic)
				//{
					dispatchEvent(new ChangeCursor(ChangeCursor.CHANGE_CURSOR, ChangeCursor.CURSOR_DEFAULT, true, false));
				//}
				_magicRangeSprite.visible = false;
				_isSpellUsing = false;
			}
		}
		
		public function destroy(lvlEnded:Boolean = false):void 
		{
			dispatchEvent(new UniverseDestroying(UniverseDestroying.DESTROYING, true, false));
			_keysCount = 0;
			destroyMagicUsing();
			if (_isShaking)
			{
				stopShaking();
			}
			warriorTwr = null;
			_magicRangeSprite.visible = false;
			_EventListenersArray.length = 0;
			_runningTimersArray.length = 0;
			App.cursorControl.removeUniverseCursor();
			_wheatArray.length = 0;
			_isSpellUsing = false;
			removeEventListeners();
			//updateUpperGrid();
			_enemiesAddingTimer.stop();
			_towerRangeSprite.visible = false;
			
			if (isBuildingTower)
			{
				DestroyBuildingTower();
			}
			
			while(_enemiesArray.length != 0)
			{
				_enemiesArray[0].destroy();
			}
			
			var length:int = _wavesArray.length;
			for (var i:int = 0; i < length; i++)
			{
				_wavesArray[i].destroy();
			}
			_wavesArray.length = 0;
			if (_currentWave)
			{
				if (!_currentWave._destroyed)
				{
					_currentWave.destroy();
				}
			}
			length = _checksArray.length;
			for (i = 0; i < length; i++)
			{
				_checksArray[i].destroy();
			}
			_checksArray.length = 0;
			
			if (!lvlEnded)
			{
				initPlayerArraysByTMPs();
			}
			
			for (i = 0; i < App.MAP_SIZE; i++)
			{
				for (var j:int = 0; j < App.MAP_SIZE; j++)
				{
					var tmpGrid:Grid = _mapMask[i][j];
					tmpGrid.removeTower();
					tmpGrid.removeVisualObjects();
				}
			}
			_towersArray.length = 0;
			
			if (_isCampExists)
			{
				_campObject.destroy();
				_isCampExists = false;
			}
		}
		
		public function DestroyBuildingTower():void
		{
			if (isBuildingTower)
			{
				isBuildingTower = false;
				_buildingTower.destroyPreBuildedTower();
				App.pools.returnPoolObject(_buildingTower.type, _buildingTower);
				_ableGridLayer.removeChild(_buildingTower);
				_buildingTower = null;
				makeGridInvisible();
				App.ingameInterface.makePressSpaceInvisible();
			}
		}
		
		private function initPlayerArraysByTMPs():void 
		{
			// очистка массивов
			var tmpArray:Array = App.currentPlayer.armyArray;
			var length:int = tmpArray.length;
			var tmpTowerData:TowerData;
			for (var i:int = 0; i < length; i++)
			{
				tmpTowerData = tmpArray[i];
				tmpTowerData.destroy();
			}
			tmpArray = App.currentPlayer.heroesArray;
			length = tmpArray.length;
			for (i = 0; i < length; i++)
			{
				tmpTowerData = tmpArray[i];
				tmpTowerData.destroy();
			}
			
			// заполнение массивов из временных массивов
			tmpArray = App.currentPlayer.armyArray;
			tmpArray.length = 0;
			var tmpFromArray:Array = App.currentPlayer.armyTMPArray;
			length = tmpFromArray.length;
			for (i = 0; i < length; i++)
			{
				tmpTowerData = tmpFromArray[i];
				tmpArray.push(tmpTowerData);
			}
			tmpFromArray.length = 0;
			tmpFromArray = App.currentPlayer.heroesTMPArray;
			tmpArray = App.currentPlayer.heroesArray;
			tmpArray.length = 0;
			length = tmpFromArray.length;
			for (i = 0; i < length; i++)
			{
				tmpTowerData = tmpFromArray[i];
				tmpArray.push(tmpTowerData);
			}
			tmpFromArray.length = 0;
		}
		
		private function makeGridVisible():void 
		{
			var tmpGrid:Grid;
			for (var i:int = 0; i < App.MAP_SIZE; i++)
			{
				for (var j:int = 0; j < App.MAP_SIZE; j++)
				{
					tmpGrid = _mapMask[i][j];
					tmpGrid.ableMovie.visible = true;
				}
			}
		}
		
		public function startShaking():void 
		{
			if (!_isShaking)
			{
				_isShaking = true;
				_shaking_counter = 0;
				_shaking_delay = SHAKING_COORDINATES_DELAY;
				addEventListener(Event.ENTER_FRAME, onShakingEvent, false, 0, true);
			}
		}
		
		private function onShakingEvent(e:Event):void 
		{
			_shaking_counter++;
			if (_shaking_counter == SHAKING_LENGTH)
			{
				stopShaking();
				return;
			}
			
			_shaking_delay--;
			if (_shaking_delay > 1)
			{
				this.x = App.randomInt(-_shaking_delay,_shaking_delay);
				this.y = App.randomInt(-_shaking_delay,_shaking_delay);
			}
		}
		
		public function stopShaking():void 
		{
			if (_isShaking)
			{
				_isShaking = false;
				removeEventListener(Event.ENTER_FRAME, onShakingEvent, false);
				this.x = 0;
				this.y = 0;
			}
		}
		
		private function makeGridInvisible():void 
		{
			var tmpGrid:Grid;
			for (var i:int = 0; i < App.MAP_SIZE; i++)
			{
				for (var j:int = 0; j < App.MAP_SIZE; j++)
				{
					tmpGrid = _mapMask[i][j];
					tmpGrid.ableMovie.visible = false;
				}
			}
		}
		
		private function onWavesAdding(e:Event):void 
		{
			if (_isWaveKilled)
			{
				if (_wavesArray.length != 0)
				{
					_currentWave = _wavesArray.shift();
					_currentWave.findAKeyMonster();
					_enemiesAddingTimer.delay = _currentWave.enemiesDelay;
					_enemiesAddingTimer.addEventListener(TimerEvent.TIMER, onAddEnemy, false, 0, true);
					_enemiesAddingTimer.start();
					_isWaveKilled = false;
					App.waveLine.removeEventListenersFromWaves();
					
					App.soundControl.playSound("wave_begin");
				}
			}
			else
			{
				dispatchEvent(new AddNewWave(AddNewWave.NOT_READY, true, false));
				_cantPassNextWave = true;
			}
		}
		
		private function onAddEnemy(e:TimerEvent = null):void 
		{
			if (!App.isPauseOn)
			{
				if (_currentWave && (_currentWave.numberOfType > 0)) {
					var isAKeyOwner:Boolean = false;
					if (_currentWave.keyOwnerIndex == 0)
					{
						isAKeyOwner = true;
					}
					addEnemy(_currentWave.type, _currentWave.enemyHP, _currentWave.enemyArmor, _currentWave.cost, _currentWave.resistToBlunt, _currentWave.resistToSword, _currentWave.resistToPike, _currentWave.resistToMagic, isAKeyOwner, _currentWave.isBossWave);
					_currentWave.numberOfType--;
					_currentWave.keyOwnerIndex--;
				} else {
					_currentWave.destroy();
					_currentWave = null;
					_enemiesAddingTimer.removeEventListener(TimerEvent.TIMER, onAddEnemy, false);
					_enemiesAddingTimer.stop();
				}
			}
		}
		
		public function get towerRangeSprite():Sprite { return _towerRangeSprite; }
		
		public function set towerRangeSprite(value:Sprite):void 
		{
			_towerRangeSprite = value;
		}
		
		public function get campObject():CampControl { return _campObject; }
		
		public function get keysCount():int { return _keysCount; }
		
		public function set keysCount(value:int):void 
		{
			_keysCount = value;
			dispatchEvent(new UniverseEvent(UniverseEvent.ADD_KEY, true));
		}
		
		public function get isEveryEnemyDied():Boolean { return _isEveryEnemyDied; }
		
		public function get towersArray():Array { return _towersArray; }
		
		public function set towersArray(value:Array):void 
		{
			_towersArray = value;
		}
		
		public function get magicLayer():Sprite { return _magicLayer; }
		
		public function get mapMask():Array { return _mapMask; }
		
		public function get wheatArray():Array { return _wheatArray; }
		
		public function set wheatArray(value:Array):void 
		{
			_wheatArray = value;
		}
		
		public function get experienceGainedCount():int { return _experienceGainedCount; }
		
		public function set experienceGainedCount(value:int):void 
		{
			_experienceGainedCount = value;
		}
		
		public function set magicLayer(value:Sprite):void 
		{
			_magicLayer = value;
		}
		
		public function get enemiesArray():Array { return _enemiesArray; }
		
		public function get goldCount():int { return _goldCount; }
		
		public function set goldCount(value:int):void 
		{
			_goldCount = value;
		}
		
		public function get destroyedEnemiesCount():int { return _destroyedEnemiesCount; }
		
		public function set destroyedEnemiesCount(value:int):void 
		{
			_destroyedEnemiesCount = value;
		}
		
		public function get bulletsLayer():Sprite { return _bulletsLayer; }
		
		public function set bulletsLayer(value:Sprite):void 
		{
			_bulletsLayer = value;
		}
		
		public function get critsLayer():Sprite { return _critsLayer; }
		
		public function set critsLayer(value:Sprite):void 
		{
			_critsLayer = value;
		}
		
		public function get checksArray():Array { return _checksArray; }
		
		public function set checksArray(value:Array):void 
		{
			_checksArray = value;
		}
		
		public function get mainLayer():Sprite { return _mainLayer; }
		
		public function get eggsLayer():Sprite { return _eggsLayer; }
		
		public function get keysLayer():Sprite { return _keysLayer; }
		
		public function get peageonsLayer():Sprite { return _peageonsLayer; }
		
		public function get keysControlLayer():Sprite { return _keysControlLayer; }
		
		public function get cursorsLayer():Sprite { return _cursorsLayer; }
		
		public function get magicRangeSprite():Sprite { return _magicRangeSprite; }
		
		public function get ground():Sprite { return _ground; }
		
	}
}