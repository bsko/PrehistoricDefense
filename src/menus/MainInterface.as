package menus 
{
	import Events.InterfaceEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	/**
	 * ...
	 * @author author
	 */
	public class MainInterface extends Sprite
	{
		public static const MENU_SPELLS:int = 101;
		public static const MENU_UNITS:int = 102;
		private var _mainMenuGrp:MovieClip = new MainMenu();
		private var _currentSelectedSpell:int;
		private var _accToDelete:int = 0;
		private var _menuType:int;
		private var _currentSlide:int;
		
		public function MainInterface() 
		{
			Init();
		}
		
		public function Init():void 
		{
			App.stage.frameRate = App.FRAMERATE;
			addChild(_mainMenuGrp);
			MainMenuPage();
		}
		
		public function QuitFromGame():void 
		{
			SelectLevelPage();
		}
		
		//функции открытия страниц
		
		public function WonMenuPage(enemies:int, totalEnemies:int, wavesDestroyed:int, totalWaves:int, gold:int, wheat:int, experience:int, wasCampInBattle:Boolean):void
		{
			_mainMenuGrp.gotoAndStop("mission_complete");
			
			_mainMenuGrp.enemies.text = String(enemies) + " / " + String(totalEnemies);
			_mainMenuGrp.waves.text = String(wavesDestroyed) + " / " + String(totalWaves);
			_mainMenuGrp.gold.text = String(gold);
			_mainMenuGrp.wheat.text = String(wheat);
			_mainMenuGrp.experience.text = String(experience);
			
			var tmpVar:int = enemies * App.ENEMIES_BONUS;
			_mainMenuGrp.enemiesPts.text = String(tmpVar);
			var tmpVar1:int = wavesDestroyed * App.WAVES_BONUS;
			_mainMenuGrp.wavesPts.text = String(tmpVar1);
			var tmpVar2:int = gold * App.GOLD_BONUS + wheat * App.WHEAT_BONUS;
			_mainMenuGrp.resourcesPts.text = String(tmpVar2);
			var tmpVar3:int = experience * App.EXPERIENCE_BONUS;
			_mainMenuGrp.experiencePts.text = String(tmpVar3);
			var tmpVar4:int = tmpVar + tmpVar1 + tmpVar2 + tmpVar3;
			_mainMenuGrp.totalPts.text = String(tmpVar4);
			var tmpVar5:int = CalculateBonus(tmpVar4);
			_mainMenuGrp.totalCrystals.text = String(tmpVar5) + "+" + String(Universe.additional_diamonds);
			App.currentPlayer.money += tmpVar5 + Universe.additional_diamonds;
			_mainMenuGrp.restart.addEventListener(MouseEvent.CLICK, onRestartEvent, false, 0, true);
			_mainMenuGrp.map.addEventListener(MouseEvent.CLICK, onWonToSelectLevel, false, 0, true);
			if (App.currentLevel != 20)
			{
				if (App.currentPlayer.levelsArray[App.currentLevel + 1] != "unlocked")
				{
					App.currentPlayer.levelsArray[App.currentLevel + 1] = "unlocked";
					for (var cp:int = 0; cp < App.LEVELS_TO_UNLOCK_HEROES.length; cp++)
					{
						if ((App.currentLevel + 1) == App.LEVELS_TO_UNLOCK_HEROES[cp])
						{
							if (App.currentPlayer.unlockedHeroesCount < cp + 2)
							{
								var tmpIndex:int = App.randomInt(0, App.currentPlayer.lockedHeroesArray.length + 1);
								App.currentPlayer.unlockedHeroesCount++;
								var tmpTowerData:TowerData = App.currentPlayer.lockedHeroesArray[tmpIndex];
								tmpTowerData.isUnlocked = true;
								App.currentPlayer.lockedHeroesArray.splice(tmpIndex, 1);
							}
						}
					}
				}
			}
			else
			{
				//_mainMenuGrp.next.visible = false;
			}
			
			if(!wasCampInBattle) {
				_mainMenuGrp.stars.gotoAndStop(4);
			} else {
				if (enemies / totalEnemies >= 0.85)
				{
					_mainMenuGrp.stars.gotoAndStop(3);
				}
				else
				{
					_mainMenuGrp.stars.gotoAndStop(2);
				}
			}
			
			updateButtonsBySoundStatus();
			_mainMenuGrp.next.addEventListener(MouseEvent.CLICK, onNextLevelEvent, false, 0, true);
			_mainMenuGrp.musicBtn.addEventListener(MouseEvent.CLICK, onChangeMusicStatus, false, 0, true);
			_mainMenuGrp.volumeBtn.addEventListener(MouseEvent.CLICK, onChangeSoundStatus, false, 0, true);
			_mainMenuGrp.BackBtn.addEventListener(MouseEvent.CLICK, onWonToUpdates, false, 0, true);
		}
		
		private function onWonToUpdates(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			_mainMenuGrp.musicBtn.removeEventListener(MouseEvent.CLICK, onChangeMusicStatus, false);
			_mainMenuGrp.volumeBtn.removeEventListener(MouseEvent.CLICK, onChangeSoundStatus, false);
			_mainMenuGrp.restart.removeEventListener(MouseEvent.CLICK, onRestartEvent, false);
			_mainMenuGrp.map.removeEventListener(MouseEvent.CLICK, onWonToSelectLevel, false);
			if (_mainMenuGrp.next)
			{
				_mainMenuGrp.next.removeEventListener(MouseEvent.CLICK, onNextLevelEvent, false);
			}
			_mainMenuGrp.BackBtn.removeEventListener(MouseEvent.CLICK, onWonToUpdates, false);
			UpdatesPage();
		}
		
		public function LooseMenuPage(enemies:int, totalEnemies:int, wavesDestroyed:int, totalWaves:int, gold:int, wheat:int, experience:int):void
		{
			_mainMenuGrp.gotoAndStop("mission_failed");
			
			_mainMenuGrp.enemies.text = String(enemies) + " / " + String(totalEnemies);
			_mainMenuGrp.waves.text = String(wavesDestroyed) + " / " + String(totalWaves);
			_mainMenuGrp.gold.text = String(gold);
			_mainMenuGrp.wheat.text = String(wheat);
			_mainMenuGrp.experience.text = String(experience);
			
			var tmpVar:int = enemies * App.ENEMIES_BONUS;
			_mainMenuGrp.enemiesPts.text = String(tmpVar);
			var tmpVar1:int = wavesDestroyed * App.WAVES_BONUS;
			_mainMenuGrp.wavesPts.text = String(tmpVar1);
			var tmpVar2:int = gold * App.GOLD_BONUS + wheat * App.WHEAT_BONUS;
			_mainMenuGrp.resourcesPts.text = String(tmpVar2);
			var tmpVar3:int = experience * App.EXPERIENCE_BONUS;
			_mainMenuGrp.experiencePts.text = String(tmpVar3);
			var tmpVar4:int = tmpVar + tmpVar1 + tmpVar2 + tmpVar3;
			_mainMenuGrp.totalPts.text = String(tmpVar4);
			var tmpVar5:int = CalculateBonus(tmpVar4) * 0.75;
			_mainMenuGrp.totalCrystals.text = String(tmpVar5);
			App.currentPlayer.money += tmpVar5;
			updateButtonsBySoundStatus();
			_mainMenuGrp.restart.addEventListener(MouseEvent.CLICK, onRestartEvent, false, 0, true);
			_mainMenuGrp.map.addEventListener(MouseEvent.CLICK, onWonToSelectLevel, false, 0, true);
			_mainMenuGrp.musicBtn.addEventListener(MouseEvent.CLICK, onChangeMusicStatus, false, 0, true);
			_mainMenuGrp.volumeBtn.addEventListener(MouseEvent.CLICK, onChangeSoundStatus, false, 0, true);
			_mainMenuGrp.BackBtn.addEventListener(MouseEvent.CLICK, onWonToUpdates, false, 0, true);
		}
		
		private function MainMenuPage():void 
		{
			_mainMenuGrp.gotoAndStop("main_menu");
			updateButtonsBySoundStatus();
			_mainMenuGrp.musicBtn.addEventListener(MouseEvent.CLICK, onChangeMusicStatus, false, 0, true);
			_mainMenuGrp.volumeBtn.addEventListener(MouseEvent.CLICK, onChangeSoundStatus, false, 0, true);
			_mainMenuGrp.playBtn.addEventListener(MouseEvent.CLICK, onMainMenuToSelectProfileMenu, false, 0, true);
			_mainMenuGrp.creditsBtn.addEventListener(MouseEvent.CLICK, onMainMenuToCreditsMenu, false, 0, true);
		}
		
		private function CreditsPage():void 
		{
			_mainMenuGrp.gotoAndStop("credits");
			updateButtonsBySoundStatus();
			_mainMenuGrp.musicBtn.addEventListener(MouseEvent.CLICK, onChangeMusicStatus, false, 0, true);
			_mainMenuGrp.volumeBtn.addEventListener(MouseEvent.CLICK, onChangeSoundStatus, false, 0, true);
			_mainMenuGrp.BackBtn.addEventListener(MouseEvent.CLICK, onCreditsToMainMenu, false, 0, true);
		}
				
		private function UpdatesPage():void 
		{
			_mainMenuGrp.gotoAndStop("upgr_units");
			_menuType = MENU_UNITS;
			_mainMenuGrp._unitsTabSprite.gotoAndStop(1);
			_mainMenuGrp.UpgradesTab.UnitsTab.gotoAndStop(1);
			_mainMenuGrp.UpgradesTab.SpellsTab.gotoAndStop(2);
			_mainMenuGrp.UpgradesTab.SpellsTab.addEventListener(MouseEvent.CLICK, onUpdatesToSpells, false, 0, true);
			_mainMenuGrp.BackBtn.addEventListener(MouseEvent.CLICK, onUpdatesToSelectLevel, false, 0, true);		
			// *************************************************
			//_mainMenuGrp.UndoBtn.addEventListener(MouseEvent.CLICK, onUndoUpdates, false, 0, true);
			//_mainMenuGrp.OkBtn.addEventListener(MouseEvent.CLICK, onAplyUpdates, false, 0, true);
			// *************************************************
			_mainMenuGrp.musicBtn.addEventListener(MouseEvent.CLICK, onChangeMusicStatus, false, 0, true);
			_mainMenuGrp.volumeBtn.addEventListener(MouseEvent.CLICK, onChangeSoundStatus, false, 0, true);
			_mainMenuGrp.MoneyField.text = String(App.currentPlayer.money - Update.tmpMoney);
			_mainMenuGrp._unitsTabSprite.Economy.addEventListener(MouseEvent.MOUSE_OVER, onEconomyDescr, false, 0, true);
			_mainMenuGrp._unitsTabSprite.Economy.addEventListener(MouseEvent.MOUSE_OUT, onCloseDescr, false, 0, true);
			_mainMenuGrp._unitsTabSprite.Agriculture.addEventListener(MouseEvent.MOUSE_OVER, onAgricultureDescr, false, 0, true);
			_mainMenuGrp._unitsTabSprite.Agriculture.addEventListener(MouseEvent.MOUSE_OUT, onCloseDescr, false, 0, true);
			_mainMenuGrp._unitsTabSprite.Military.addEventListener(MouseEvent.MOUSE_OVER, onMilitaryDescr, false, 0, true);
			_mainMenuGrp._unitsTabSprite.Military.addEventListener(MouseEvent.MOUSE_OUT, onCloseDescr, false, 0, true);
			
			App.economy = 0;
			App.agriculture = 0;
			App.military = 0;
			updateTextFieldsInUpdatePage();
			
			if (Update.tmpMoney == 0)
			{
				_mainMenuGrp.pressOK.visible = false;
				_mainMenuGrp.applyBtn.gotoAndStop(1);
				_mainMenuGrp.undoBtn.gotoAndStop(1);
				
			}
			else
			{
				_mainMenuGrp.pressOK.visible = true;
				_mainMenuGrp.applyBtn.gotoAndStop(2);
				_mainMenuGrp.undoBtn.gotoAndStop(2);
				_mainMenuGrp.applyBtn.OkBtn.addEventListener(MouseEvent.CLICK, onAplyUpdates, false, 0, true);
				_mainMenuGrp.undoBtn.UndoBtn.addEventListener(MouseEvent.CLICK, onUndoUpdates, false, 0, true);
			}
			
			var tmpProgressBar:MovieClip;
			for (var i:int = 0; i < App.UPDATES_NMBR; i++)
			{
				var tmpUpdateVisual:MovieClip = _mainMenuGrp._unitsTabSprite.getChildByName("update_" + String(i)) as MovieClip;
				var tmpHitArea:MovieClip = _mainMenuGrp._unitsTabSprite.getChildByName("hitarea_" + String(i)) as MovieClip;
				tmpHitArea.alpha = 0;
				tmpHitArea.addEventListener(MouseEvent.MOUSE_OVER, onCurrentUpdateDescr, false, 0, true);
				tmpHitArea.addEventListener(MouseEvent.MOUSE_OUT, onCloseDescr, false, 0, true);
				var tmpUpdate:Update = App.currentPlayer.updatesArray[i];
				tmpUpdateVisual.IconMovie.gotoAndStop(tmpUpdate.label);
				
				for (var j:int = 1; j <= tmpUpdate.stepsToAvailable; j++)
				{
					tmpProgressBar = _mainMenuGrp._unitsTabSprite.getChildByName("ProgressBar_" + String(i) + "_" + String(j)) as MovieClip;
					if (tmpProgressBar)
					{
						tmpProgressBar.gotoAndStop("Passive");
					}	
				}
			}
			for (i = 0; i < App.UPDATES_NMBR; i++)
			{
				tmpUpdateVisual = _mainMenuGrp._unitsTabSprite.getChildByName("update_" + String(i)) as MovieClip;
				tmpUpdate = App.currentPlayer.updatesArray[i];
				
				if (!tmpUpdate.preBuyAvailable)
				{
					tmpUpdateVisual.gotoAndStop("Passive");
					tmpUpdateVisual.mouseEnabled = false;
				}
				else
				{
					tmpUpdateVisual.gotoAndStop("Active");
					tmpUpdateVisual.button.addEventListener(MouseEvent.CLICK, onUpdateEpoch, false, 0, true);
					tmpUpdateVisual.button.addEventListener(MouseEvent.MOUSE_OVER, onDescriptionOnBtn, false, 0, true);
					tmpUpdateVisual.button.addEventListener(MouseEvent.MOUSE_OUT, onCloseDescr, false, 0, true);
				}
				
				if (tmpUpdate.preBuyIsUpdated)
				{
					if (i < 5)
					{
						App.economy += 2;
						App.economy += tmpUpdate.preBuyLevel;
					}
					else if ( i < 9)
					{
						App.agriculture += 2;
						App.agriculture += tmpUpdate.preBuyLevel;
					}
					else
					{
						App.military += 2;
						App.military += tmpUpdate.preBuyLevel;
					}
					tmpUpdateVisual.gotoAndStop("Prebuy");
					tmpUpdateVisual.mouseEnabled = false;
					//clearMouseEnabled(tmpUpdateVisual as DisplayObjectContainer);
					if (tmpUpdate.preBuyLevel == tmpUpdate.maxLocalUpdate)
					{
						tmpUpdateVisual.LvlBtn.visible = false;
					}
					else
					{
						tmpUpdateVisual.LvlBtn.visible = true;
						tmpUpdateVisual.LvlBtn.addEventListener(MouseEvent.CLICK, onUpdateCurrentLevel, false, 0, true);
						tmpUpdateVisual.LvlBtn.addEventListener(MouseEvent.MOUSE_OVER, onPipkaAbout, false, 0, true);
						tmpUpdateVisual.LvlBtn.addEventListener(MouseEvent.MOUSE_OUT, onCloseDescr, false, 0, true);
					}
					tmpUpdateVisual.LvlField.text = tmpUpdate.preBuyLevel;
					var length:int = tmpUpdate.nextUpsArray.length;
					var tmpNextUpdate:Update;
					for (var k:int = 0; k < length; k++)
					{
						tmpNextUpdate = tmpUpdate.nextUpsArray[k];
						var tmpPipka:MovieClip;
						for (var l:int = 1; l <= tmpNextUpdate.stepsToAvailable; l++)
						{
							tmpPipka = _mainMenuGrp._unitsTabSprite.getChildByName("ProgressBar_" + String(i + 1 + k) + "_" + String(l)) as MovieClip;
							if (l <= tmpNextUpdate.preBuyRoadToAvailable)
							{
								tmpPipka.gotoAndStop("Pressed");
								if (i < 5)
								{
									App.economy += 1;
								}
								else if ( i < 9)
								{
									App.agriculture += 1;
								}
								else
								{
									App.military += 1;
								}
							}
							else if (l == tmpNextUpdate.preBuyRoadToAvailable + 1)
							{
								tmpPipka.gotoAndStop("Active");
								tmpPipka.addEventListener(MouseEvent.CLICK, onUpdatePipkaUpgrade, false, 0, true);
								tmpPipka.smplbtn.addEventListener(MouseEvent.MOUSE_OVER, onPipkaUpdDescription, false, 0, true);
								tmpPipka.smplbtn.addEventListener(MouseEvent.MOUSE_OUT, onCloseDescr, false, 0, true);
							}
						}
					}
				}
				else
				{
					tmpUpdateVisual.LvlBtn.visible = false;
					tmpUpdateVisual.LvlField.text = "";
				}
				
				
				if (tmpUpdate.isUpdated)
				{
					tmpUpdateVisual.gotoAndStop("Confirmed");
					tmpUpdateVisual.mouseEnabled = false;
					//clearMouseEnabled(tmpUpdateVisual as DisplayObjectContainer);
					length = tmpUpdate.nextUpsArray.length;
					for (k = 0; k < length; k++)
					{
						tmpNextUpdate = tmpUpdate.nextUpsArray[k];
						for (l = 1; l <= tmpNextUpdate.stepsToAvailable; l++)
						{
							tmpPipka = _mainMenuGrp._unitsTabSprite.getChildByName("ProgressBar_" + String(i + 1 + k) + "_" + String(l)) as MovieClip;
							if (l <= tmpNextUpdate.roadToAvailable)
							{
								tmpPipka.gotoAndStop("Full");
							}
						}
					}
				}	
			}
			updateTextFieldsInUpdatePage();
		}
		
		private function SpellsPage():void 
		{
			_mainMenuGrp.gotoAndStop("upgr_units");
			_menuType = MENU_SPELLS;
			_mainMenuGrp._unitsTabSprite.gotoAndStop(2);
			_mainMenuGrp.UpgradesTab.UnitsTab.gotoAndStop(2);
			_mainMenuGrp.UpgradesTab.SpellsTab.gotoAndStop(1);
			_mainMenuGrp.MoneyField.text = String(App.currentPlayer.money - Spell.tmpMoney);
			_mainMenuGrp.UpgradesTab.UnitsTab.addEventListener(MouseEvent.CLICK, onSpellsToUpdates, false, 0, true);
			_mainMenuGrp.BackBtn.addEventListener(MouseEvent.CLICK, onSpellsToSelectLevel, false, 0, true);
			//_mainMenuGrp.OkBtn.addEventListener(MouseEvent.CLICK, onAplySpells, false, 0, true);
			//_mainMenuGrp.UndoBtn.addEventListener(MouseEvent.CLICK, onUndoSpells, false, 0, true);
			_mainMenuGrp.musicBtn.addEventListener(MouseEvent.CLICK, onChangeMusicStatus, false, 0, true);
			_mainMenuGrp.volumeBtn.addEventListener(MouseEvent.CLICK, onChangeSoundStatus, false, 0, true);
			
			if (Spell.tmpMoney == 0)
			{
				_mainMenuGrp.pressOK.visible = false;
				_mainMenuGrp.applyBtn.gotoAndStop(1);
				_mainMenuGrp.undoBtn.gotoAndStop(1);
			}
			else
			{
				_mainMenuGrp.pressOK.visible = true;
				_mainMenuGrp.applyBtn.gotoAndStop(2);
				_mainMenuGrp.undoBtn.gotoAndStop(2);
				_mainMenuGrp.applyBtn.OkBtn.addEventListener(MouseEvent.CLICK, onAplySpells, false, 0, true);
				_mainMenuGrp.undoBtn.UndoBtn.addEventListener(MouseEvent.CLICK, onUndoSpells, false, 0, true);
			}
			
			var tmpProgressBar:MovieClip;
			for (var i:int = 0; i < App.SPELLS_NMBR; i++)
			{
				var tmpSpellVisual:MovieClip = _mainMenuGrp._unitsTabSprite.getChildByName("spell_" + String(i)) as MovieClip;
				var tmpSpell:Spell = App.currentPlayer.spellsArray[i];
				tmpSpellVisual.magicCheckbox.gotoAndStop(tmpSpell.checkBoxState);
				tmpSpellVisual.IconMovie.gotoAndStop(tmpSpell.label);
				
				for (var j:int = 1; j <= tmpSpell.stepsToAvailable; j++)
				{
					tmpProgressBar = _mainMenuGrp._unitsTabSprite.getChildByName("ProgressBar_" + String(i) + "_" + String(j)) as MovieClip;
					if (tmpProgressBar)
					{
						tmpProgressBar.gotoAndStop("Passive");
					}	
				}
			}
			for (i = 0; i < App.SPELLS_NMBR; i++)
			{
				tmpSpellVisual = _mainMenuGrp._unitsTabSprite.getChildByName("spell_" + String(i)) as MovieClip;
				var tmpHitArea:MovieClip = _mainMenuGrp._unitsTabSprite.getChildByName("spellarea_" + String(i)) as MovieClip;
				tmpHitArea.alpha = 0;
				tmpHitArea.addEventListener(MouseEvent.MOUSE_OVER, onCurrentUpdateDescr, false, 0, true);
				tmpHitArea.addEventListener(MouseEvent.MOUSE_OUT, onCloseDescr, false, 0, true);
				tmpSpell = App.currentPlayer.spellsArray[i];
				if (!tmpSpell.preBuyAvailable)
				{
					tmpSpellVisual.gotoAndStop("Passive");
				}
				else
				{
					tmpSpellVisual.gotoAndStop("Active");
					tmpSpellVisual.addEventListener(MouseEvent.CLICK, onUpdateMagic, false, 0, true);
					tmpSpellVisual.button.addEventListener(MouseEvent.MOUSE_OVER, onDescriptionOnBtn, false, 0, true);
					tmpSpellVisual.button.addEventListener(MouseEvent.MOUSE_OUT, onCloseDescr, false, 0, true);
				}
				
				if (tmpSpell.preBuyIsUpdated)
				{
					tmpSpellVisual.gotoAndStop("Prebuy");
					if (tmpSpell.preBuyLevel == tmpSpell.maxLocalUpdate)
					{
						tmpSpellVisual.LvlBtn.visible = false;
					}
					else
					{
						tmpSpellVisual.LvlBtn.visible = true;
						tmpSpellVisual.LvlBtn.addEventListener(MouseEvent.CLICK, onMagicCurrentLevel, false, 0, true);
						tmpSpellVisual.LvlBtn.addEventListener(MouseEvent.MOUSE_OVER, onPipkaAbout, false, 0, true);
						tmpSpellVisual.LvlBtn.addEventListener(MouseEvent.MOUSE_OUT, onCloseDescr, false, 0, true);
					}
					tmpSpellVisual.LvlField.text = tmpSpell.preBuyLevel;
					var tmpNextSpell:Spell;
					tmpNextSpell = tmpSpell.nextUp;
					if (tmpNextSpell != null)
					{
						var tmpPipka:MovieClip;
						for (var l:int = 1; l <= tmpNextSpell.stepsToAvailable; l++)
						{
							tmpPipka = _mainMenuGrp._unitsTabSprite.getChildByName("ProgressBar_" + String(i + 1) + "_" + String(l)) as MovieClip;
							if (l <= tmpNextSpell.preBuyRoadToAvailable)
							{
								tmpPipka.gotoAndStop("Pressed");
							}
							else if (l == tmpNextSpell.preBuyRoadToAvailable + 1)
							{
								tmpPipka.gotoAndStop("Active");
								tmpPipka.addEventListener(MouseEvent.CLICK, onMagicPipkaUpgrade, false, 0, true);
								tmpPipka.smplbtn.addEventListener(MouseEvent.MOUSE_OVER, onPipkaUpdDescription, false, 0, true);
								tmpPipka.smplbtn.addEventListener(MouseEvent.MOUSE_OUT, onCloseDescr, false, 0, true);
							}
						}
					}
				}
				else
				{
					tmpSpellVisual.LvlBtn.visible = false;
					tmpSpellVisual.LvlField.text = "";
				}
				if (tmpSpell.isUpdated)
				{
					tmpSpellVisual.magicCheckbox.visible = true;
					tmpSpellVisual.gotoAndStop("Confirmed");
					tmpSpellVisual.magicCheckbox.addEventListener(MouseEvent.CLICK, onUpdateInGameSpells, false, 0, true);
					tmpNextSpell = tmpSpell.nextUp;
					if (tmpNextSpell != null)
					{
						for (l = 1; l <= tmpNextSpell.stepsToAvailable; l++)
						{
							tmpPipka = _mainMenuGrp._unitsTabSprite.getChildByName("ProgressBar_" + String(i + 1) + "_" + String(l)) as MovieClip;
							if (l <= tmpNextSpell.roadToAvailable)
							{
								tmpPipka.gotoAndStop("Full");
							}
						}
					}
				}
				else { tmpSpellVisual.magicCheckbox.visible = false; }
			}
			
			var length:int = App.currentPlayer.selectedSpells.length;
			for (i = 0; i < length; i++)
			{
				var a:Spell = App.currentPlayer.selectedSpells[i];
				a.checkBoxState = "on";
				(_mainMenuGrp._unitsTabSprite.getChildByName("spell_" + String(a.index)) as MovieClip).magicCheckbox.gotoAndStop("on");
			}
		}
		
		private function SelectLevelPage():void 
		{
			_mainMenuGrp.gotoAndStop("select_level");
			updateButtonsBySoundStatus();
			_mainMenuGrp.BackBtn.addEventListener(MouseEvent.CLICK, onSelectLevelToSelectProfile, false, 0, true);
			_mainMenuGrp.UnitsBtn.addEventListener(MouseEvent.CLICK, onSelectLevelToUpdates, false, 0, true);
			_mainMenuGrp.musicBtn.addEventListener(MouseEvent.CLICK, onChangeMusicStatus, false, 0, true);
			_mainMenuGrp.volumeBtn.addEventListener(MouseEvent.CLICK, onChangeSoundStatus, false, 0, true);
			
			var tmpLevel:MovieClip;
			var tmpStars:MovieClip;
			var tmpLevelStatus:String;
			var percentage:Number = 0;
			for (var i:int = 1; i <= App.LEVELS_NMBR; i++)
			{
				tmpLevelStatus = App.currentPlayer.levelsArray[i - 1];
				if (_mainMenuGrp.getChildByName("level_" + String(i)))
				{
					tmpLevel = _mainMenuGrp.getChildByName("level_" + String(i)) as MovieClip;
					tmpStars = tmpLevel.stars;
					tmpLevel.numberLvl.text = String(i);
				}
				else
				{
					continue;
				}
				
				if (tmpLevelStatus == "locked")
				{
					tmpLevel.visible = false;
				}
				else
				{
					tmpLevel.visible = true;
					tmpLevel.gotoAndStop("out");
					tmpLevel.addEventListener(MouseEvent.CLICK, onStartLevel, false, 0, true);
					tmpLevel.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
					tmpLevel.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
					if (tmpLevelStatus == "unlocked")
					{
						tmpStars.gotoAndStop(1);
						percentage += App.PERCENTAGE_FOR_UNLOCK;
					}
					else if (tmpLevelStatus == "normal")
					{
						tmpStars.gotoAndStop(2);
						percentage += App.PERCENTAGE_FOR_UNLOCK + App.PERCENTAGE_FOR_STAR;
					}
					else if (tmpLevelStatus == "good")
					{
						tmpStars.gotoAndStop(3);
						percentage += App.PERCENTAGE_FOR_UNLOCK + App.PERCENTAGE_FOR_STAR * 2;
					}
					else if (tmpLevelStatus == "perfect")
					{
						tmpStars.gotoAndStop(4);
						percentage += App.PERCENTAGE_FOR_UNLOCK + App.PERCENTAGE_FOR_STAR * 3;
					}
				}
			}
			
			App.currentPlayer.progress = String(Math.ceil(percentage));
		}
		
		private function SelectProfilePage():void 
		{
			_mainMenuGrp.gotoAndStop("select_profile");
			_mainMenuGrp.musicBtn.addEventListener(MouseEvent.CLICK, onChangeMusicStatus, false, 0, true);
			_mainMenuGrp.volumeBtn.addEventListener(MouseEvent.CLICK, onChangeSoundStatus, false, 0, true);
			updateButtonsBySoundStatus();
			
			for (var i:int = 0; i < App.ACCS_NMBR; i++)
			{
				var tmpObject:PlayerAccount = App.playersArray[i];
				(_mainMenuGrp.getChildByName("name_" + i.toString()) as TextField).text = tmpObject.name;
				(_mainMenuGrp.getChildByName("name_" + String(i)) as TextField).text = tmpObject.name;
				if (tmpObject.available)
				{
					(_mainMenuGrp.getChildByName("progress_" + i.toString()) as TextField).text = tmpObject.progress + " %";
					(_mainMenuGrp.getChildByName("delete_" + i.toString()) as SimpleButton).visible = true;
					(_mainMenuGrp.getChildByName("delete_" + String(i)) as SimpleButton).addEventListener(MouseEvent.CLICK, onDeleteEvent, false, 0, true);
				}
				else
				{
					(_mainMenuGrp.getChildByName("progress_" + i.toString()) as TextField).text = "";
					(_mainMenuGrp.getChildByName("delete_" + i.toString()) as SimpleButton).visible = false;
				}
				var tmpIconBtn:MovieClip = (_mainMenuGrp.getChildByName("icon_" + i.toString()) as MovieClip);
				tmpIconBtn.iconPlayer.gotoAndStop(tmpObject.icon);
				tmpIconBtn.addEventListener(MouseEvent.CLICK, onSelectProfileToSelectHero, false, 0, true);
				
			}
			_mainMenuGrp.backBtn.addEventListener(MouseEvent.CLICK, onSelectProfileToMainMenu, false, 0, true);
		}
		
		private function SelectHeroPage():void 
		{
			_mainMenuGrp.gotoAndStop("select_hero");
			_mainMenuGrp.inputName.text = "Name";
			_mainMenuGrp.heroButton.downHeroButton.mouseEnabled = false;
			_mainMenuGrp.heroButton.iconPlayer.gotoAndStop(1);
			_mainMenuGrp.musicBtn.addEventListener(MouseEvent.CLICK, onChangeMusicStatus, false, 0, true);
			_mainMenuGrp.volumeBtn.addEventListener(MouseEvent.CLICK, onChangeSoundStatus, false, 0, true);
			_mainMenuGrp.nextHero.addEventListener(MouseEvent.CLICK, onNextHero, false, 0, true);
			_mainMenuGrp.prevHero.addEventListener(MouseEvent.CLICK, onPrevHero, false, 0, true);
			_mainMenuGrp.cancelBtn.addEventListener(MouseEvent.CLICK, onCancelEvent, false, 0, true);
			_mainMenuGrp.okBtn.addEventListener(MouseEvent.CLICK, onOkEvent, false, 0, true);
		}
		
		
		//разное:
		
		private function CalculateBonus(points:int):int 
		{
			var times:int = points / 20000;
			var result:int = 0;
			
			for (var i:int = 0; i < times; i++)
			{
				result += 125 * (1 - 0.05 * i);
			}
			result += points % 20000 / 160;
			return result;
		}
		
		private function onPipkaUpdDescription(e:MouseEvent):void 
		{
			var index:int = ((e.target as SimpleButton).parent as MovieClip).name.split("_")[1];
			var description:String;
			if (_menuType == MENU_UNITS)
			{
				var tmpUpdate:Update = App.currentPlayer.updatesArray[index];
				description = "Costs : " + tmpUpdate.roadCost;
			}
			else if (_menuType == MENU_SPELLS)
			{
				var tmpSpell:Spell = App.currentPlayer.spellsArray[index];
				description = "Costs : " + tmpSpell.roadCost;
			}
			App.appearingWindow.NewText1(description, new Point(mouseX, mouseY), 10, 10);
		}
		
		private function onPipkaAbout(e:MouseEvent):void 
		{
			var tmpBtn:SimpleButton = e.target as SimpleButton;
			var tmpIndex:int = int((tmpBtn.parent.name).split("_")[1]);
			if (_menuType == MENU_UNITS)
			{
				var tmpUpdate:Update = App.currentPlayer.updatesArray[tmpIndex];
				var tmpDescription:String = "Costs: " + tmpUpdate.lvlUpCost.toString();
			}
			else if (_menuType == MENU_SPELLS)
			{
				var tmpSpell:Spell = App.currentPlayer.spellsArray[tmpIndex];
				tmpDescription = "Costs: " + tmpSpell.currUpdCost.toString();
			}
			App.appearingWindow.NewText1(tmpDescription, new Point(mouseX, mouseY), 10, 10);
		}
		
		private function onDescriptionOnBtn(e:MouseEvent):void 
		{
			currentUpdateDescr((e.currentTarget as DisplayObject).parent as DisplayObjectContainer);
		}
		
		private function clearMouseEnabled(obj:DisplayObjectContainer):void
		{
			for (var i:int = 0; i < obj.numChildren; i++)
			{
				(obj.getChildAt(i) as InteractiveObject).mouseEnabled = false;
			}
		}
		
		private function onMouseOut(e:MouseEvent):void 
		{
			(e.currentTarget as MovieClip).gotoAndStop("out");
			App.appearingWindow.Hide();
		}
		
		private function onMouseOver(e:MouseEvent):void 
		{
			(e.currentTarget as MovieClip).gotoAndStop("over");
			var lvl_index:String = (e.currentTarget as MovieClip).name.split("_")[1];
			var tmpObjectField:String = "level" + lvl_index;
			App.appearingWindow.NewText(App.descriptions[tmpObjectField], e.currentTarget as MovieClip);
		}
		
		private function currentUpdateDescr(displayObjectContainer:DisplayObjectContainer):void
		{
			var index:int = (displayObjectContainer as MovieClip).name.split("_")[1];
			var tmpDisplayObject:DisplayObject = displayObjectContainer as DisplayObject;
			if (_menuType == MENU_UNITS)
			{
				var tmpUpdate:Update = App.currentPlayer.updatesArray[index];
				var tmpDescription:String = tmpUpdate.description;
				if (tmpUpdate.preBuyAvailable)
				{
					tmpDescription += ("  Costs: " + tmpUpdate.currUpdCost);
				}
			}
			else if(_menuType == MENU_SPELLS)
			{
				var tmpSpell:Spell = App.currentPlayer.spellsArray[index];
				tmpDescription = tmpSpell.title + "\n" + tmpSpell.description;
				if (tmpSpell.preBuyAvailable)
				{
					tmpDescription += ("  Costs: " + tmpSpell.currUpdCost);
				}
			}
			var tmpPoint:Point = _mainMenuGrp._unitsTabSprite.localToGlobal(new Point(tmpDisplayObject.x, tmpDisplayObject.y));
			App.appearingWindow.NewText1(tmpDescription, tmpPoint);
		}
		
		private function onCurrentUpdateDescr(e:MouseEvent):void 
		{
			var index:int = (e.currentTarget as MovieClip).name.split("_")[1];
			var tmpDisplayObject:DisplayObject = e.currentTarget as DisplayObject;
			if (_menuType == MENU_UNITS)
			{
				var tmpUpdate:Update = App.currentPlayer.updatesArray[index];
				var tmpDescription:String = tmpUpdate.description;
				if (tmpUpdate.preBuyAvailable)
				{
					tmpDescription += ("  Costs: " + tmpUpdate.currUpdCost);
				}
			}
			else if(_menuType == MENU_SPELLS)
			{
				var tmpSpell:Spell = App.currentPlayer.spellsArray[index];
				tmpDescription = tmpSpell.title + "\n" + tmpSpell.description;
				if (tmpSpell.preBuyAvailable)
				{
					tmpDescription += ("  Costs: " + tmpSpell.currUpdCost);
				}
			}
			var tmpPoint:Point = _mainMenuGrp._unitsTabSprite.localToGlobal(new Point(tmpDisplayObject.x, tmpDisplayObject.y));
			App.appearingWindow.NewText1(tmpDescription, tmpPoint);
		}
		
		private function onCloseDescr(e:MouseEvent):void 
		{
			App.appearingWindow.Hide();
		}
		
		private function onMilitaryDescr(e:MouseEvent):void 
		{
			var tmpDisplayObject:DisplayObject = e.currentTarget as DisplayObject;
			var tmpPoint:Point = _mainMenuGrp._unitsTabSprite.localToGlobal(new Point(tmpDisplayObject.x, tmpDisplayObject.y));
			App.appearingWindow.NewText1(MainMenuDescriptions.MILITARY, tmpPoint, 30, 25);
		}
		
		private function onAgricultureDescr(e:MouseEvent):void 
		{
			var tmpDisplayObject:DisplayObject = e.currentTarget as DisplayObject;
			var tmpPoint:Point = _mainMenuGrp._unitsTabSprite.localToGlobal(new Point(tmpDisplayObject.x, tmpDisplayObject.y));
			App.appearingWindow.NewText1(MainMenuDescriptions.AGRICULTURE, tmpPoint, 30, 25);
		}
		
		private function onEconomyDescr(e:MouseEvent):void 
		{
			var tmpDisplayObject:DisplayObject = e.currentTarget as DisplayObject;
			var tmpPoint:Point = _mainMenuGrp._unitsTabSprite.localToGlobal(new Point(tmpDisplayObject.x, tmpDisplayObject.y));
			App.appearingWindow.NewText1(MainMenuDescriptions.ECONOMY, tmpPoint, 30, 25);
		}
		
		private function onStartLevel(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			_mainMenuGrp.BackBtn.removeEventListener(MouseEvent.CLICK, onSelectLevelToSelectProfile, false);
			_mainMenuGrp.UnitsBtn.removeEventListener(MouseEvent.CLICK, onSelectLevelToUpdates, false);
			//TO DO переход от Селект_Левел в Скилы
			_mainMenuGrp.musicBtn.removeEventListener(MouseEvent.CLICK, onChangeMusicStatus, false);
			_mainMenuGrp.volumeBtn.removeEventListener(MouseEvent.CLICK, onChangeSoundStatus, false);
			var tmpLevel:MovieClip;
			var tmpLevelStatus:String;
			for (var i:int = 1; i <= App.LEVELS_NMBR; i++)
			{
				tmpLevelStatus = App.currentPlayer.levelsArray[i - 1];
				if (tmpLevelStatus != "locked")
				{
					tmpLevel = _mainMenuGrp.getChildByName("level_" + String(i)) as MovieClip;
					tmpLevel.removeEventListener(MouseEvent.CLICK, onStartLevel, false);
				}
			}
			var tmpLabel:String = (e.currentTarget as MovieClip).name;
			App.currentLevel = int(tmpLabel.split("_")[1]) - 1;
			if (App.currentLevel != 0)
			{
				dispatchEvent(new InterfaceEvent(InterfaceEvent.INTERFACE_EVENT, true, false, InterfaceEvent.START_GAME, App.currentLevel));
			}
			else
			{
				_currentSlide = 1;
				StartUpPage();
			}
		}
		
		private function StartUpPage():void 
		{
			_mainMenuGrp.gotoAndStop("story");
			var tmpLabel:String = "slide_" + String(_currentSlide);
			_mainMenuGrp.story_movie.gotoAndStop(tmpLabel);
			_mainMenuGrp.story_movie.nextBtn.addEventListener(MouseEvent.CLICK, onNextSlide, false, 0, true);
			_mainMenuGrp.story_movie.skipBtn.addEventListener(MouseEvent.CLICK, onSkipSlide, false, 0, true);
			_mainMenuGrp.story_movie.backBtn.addEventListener(MouseEvent.CLICK, onBackSlide, false, 0, true);
			_mainMenuGrp.musicBtn.addEventListener(MouseEvent.CLICK, onChangeMusicStatus, false, 0, true);
			_mainMenuGrp.volumeBtn.addEventListener(MouseEvent.CLICK, onChangeSoundStatus, false, 0, true);
		}
		
		private function onBackSlide(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			if (_currentSlide > 1)
			{
				_currentSlide--;
				var tmpString:String = "slide_" + String(_currentSlide);
				_mainMenuGrp.story_movie.gotoAndStop(tmpString);
			}
			else
			{
				_currentSlide = 1;
				_mainMenuGrp.story_movie.nextBtn.removeEventListener(MouseEvent.CLICK, onNextSlide, false);
				_mainMenuGrp.story_movie.skipBtn.removeEventListener(MouseEvent.CLICK, onSkipSlide, false);
				_mainMenuGrp.story_movie.backBtn.removeEventListener(MouseEvent.CLICK, onBackSlide, false);
				SelectLevelPage();
			}
		}
		
		private function onSkipSlide(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			_mainMenuGrp.musicBtn.removeEventListener(MouseEvent.CLICK, onChangeMusicStatus, false);
			_mainMenuGrp.volumeBtn.removeEventListener(MouseEvent.CLICK, onChangeSoundStatus, false);
			dispatchEvent(new InterfaceEvent(InterfaceEvent.INTERFACE_EVENT, true, false, InterfaceEvent.START_GAME, App.currentLevel));
		}
		
		private function onNextSlide(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			if (_currentSlide == 4)
			{
				_mainMenuGrp.musicBtn.removeEventListener(MouseEvent.CLICK, onChangeMusicStatus, false);
				_mainMenuGrp.volumeBtn.removeEventListener(MouseEvent.CLICK, onChangeSoundStatus, false);
				dispatchEvent(new InterfaceEvent(InterfaceEvent.INTERFACE_EVENT, true, false, InterfaceEvent.START_GAME, App.currentLevel));
			}
			else
			{
				_currentSlide++;
				_mainMenuGrp.story_movie.play();
				_mainMenuGrp.story_movie.nextBtn.removeEventListener(MouseEvent.CLICK, onNextSlide, false);
				_mainMenuGrp.story_movie.skipBtn.removeEventListener(MouseEvent.CLICK, onSkipSlide, false);
				_mainMenuGrp.story_movie.backBtn.removeEventListener(MouseEvent.CLICK, onBackSlide, false);
				_mainMenuGrp.story_movie.addEventListener("stopped", onAddListenersToSlides, false, 0, true);
			}
		}
		
		private function onAddListenersToSlides(e:Event):void 
		{
			_mainMenuGrp.story_movie.nextBtn.addEventListener(MouseEvent.CLICK, onNextSlide, false, 0, true);
			_mainMenuGrp.story_movie.skipBtn.addEventListener(MouseEvent.CLICK, onSkipSlide, false, 0, true);
			_mainMenuGrp.story_movie.backBtn.addEventListener(MouseEvent.CLICK, onBackSlide, false, 0, true);
		}
		
		private function onMagicPipkaUpgrade(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			var params:Array = ((e.currentTarget as MovieClip).name).split("_");
			App.currentPlayer.spellsArray[params[1]].preBuyRoadToAvailable = params[2];
			SpellsPage();
		}
		
		private function onMagicCurrentLevel(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			var tmpBtn:SimpleButton = e.target as SimpleButton;
			var tmpIndex:int = int((tmpBtn.parent.name).split("_")[1]);
			var tmpSpell:Spell = App.currentPlayer.spellsArray[tmpIndex];
			if (tmpSpell.preBuyLevel < tmpSpell.maxLocalUpdate)
			{
				tmpSpell.preBuyLevel += 1;
				var tmpTextField:TextField = (_mainMenuGrp._unitsTabSprite.getChildByName("spell_" + String(tmpIndex)) as MovieClip).LvlField;
				tmpTextField.text = String(int(tmpTextField.text) + 1);
			}
			SpellsPage();
		}
		
		private function onUpdateMagic(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			var tmpIndex:int = ((e.currentTarget as MovieClip).name).split("_")[1];
			App.currentPlayer.spellsArray[tmpIndex].preBuyIsUpdated = true;
			SpellsPage();
		}
		
		private function updateTextFieldsInUpdatePage():void 
		{
			if (App.economy > 0)
			{
				_mainMenuGrp._unitsTabSprite.EconomyField.text = "+" + App.economy + "%";
			}
			else
			{
				_mainMenuGrp._unitsTabSprite.EconomyField.text = "";
			}
			if (App.agriculture > 0)
			{
				_mainMenuGrp._unitsTabSprite.AgroField.text = "+" + App.agriculture + "%";
			}
			else
			{
				_mainMenuGrp._unitsTabSprite.AgroField.text = "";
			}
			if (App.military > 0)
			{
				_mainMenuGrp._unitsTabSprite.MilitaryField.text = "+" + App.military + "%";
			}
			else
			{
				_mainMenuGrp._unitsTabSprite.MilitaryField.text = "";
			}
		}
		
		private function onUpdatePipkaUpgrade(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			var tmpIndex:int = ((e.currentTarget as MovieClip).name).split("_")[1];
			App.currentPlayer.updatesArray[tmpIndex].preBuyRoadToAvailable = ((e.currentTarget as MovieClip).name).split("_")[2];
			UpdatesPage();
		}
		
		private function onUpdateEpoch(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			var tmpIndex:int = ((e.currentTarget as SimpleButton).parent.name).split("_")[1];
			App.currentPlayer.updatesArray[tmpIndex].preBuyIsUpdated = true;
			UpdatesPage();
		}
		
		private function onUpdateCurrentLevel(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			var tmpBtn:SimpleButton = e.target as SimpleButton;
			var tmpIndex:int = int((tmpBtn.parent.name).split("_")[1]);
			var tmpUpdate:Update = App.currentPlayer.updatesArray[tmpIndex];
			if (tmpUpdate.preBuyLevel < tmpUpdate.maxLocalUpdate)
			{
				tmpUpdate.preBuyLevel += 1;
				var tmpTextField:TextField = (_mainMenuGrp._unitsTabSprite.getChildByName("update_" + String(tmpIndex)) as MovieClip).LvlField;
				tmpTextField.text = String(int(tmpTextField.text) + 1);
			}
			UpdatesPage();
		}
		
		private function onDeleteEvent(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			_mainMenuGrp.gotoAndStop("deleteProfile");
			_mainMenuGrp.okBtn.addEventListener(MouseEvent.CLICK, onDeleteProfile, false, 0, true);
			_mainMenuGrp.cancelBtn.addEventListener(MouseEvent.CLICK, onReturnProfile, false, 0, true);
			var tmpString:String = (e.currentTarget as SimpleButton).name;
			var numAcc:int = int(tmpString.split("_")[1]);
			_accToDelete = numAcc;
		}
		
		private function onReturnProfile(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			_mainMenuGrp.okBtn.removeEventListener(MouseEvent.CLICK, onDeleteProfile, false);
			_mainMenuGrp.cancelBtn.removeEventListener(MouseEvent.CLICK, onReturnProfile, false);
			SelectProfilePage();
		}
		
		private function onDeleteProfile(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			_mainMenuGrp.okBtn.removeEventListener(MouseEvent.CLICK, onDeleteProfile, false);
			_mainMenuGrp.cancelBtn.removeEventListener(MouseEvent.CLICK, onReturnProfile, false);
			
			App.playersArray[_accToDelete].Free();
			App.MakeSignatureForShObject();
			SelectProfilePage();
		}
		
		private function onOkEvent(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			removeListenersFromSelectHero();
			var tmpObject:PlayerAccount = App.currentPlayer;
			tmpObject.name = _mainMenuGrp.inputName.text;
			tmpObject.progress = "0";
			tmpObject.available = true;
			tmpObject.icon = (_mainMenuGrp.heroButton.iconPlayer as MovieClip).currentLabel;
			var tmpString:String;
			var tmpTowerData:TowerData;
			switch(tmpObject.icon)
			{
				case "warrior":
				tmpString = "Warrior";
				break;
				case "berserk":
				tmpString = "Berserk";
				break;
				case "robinhood":
				tmpString = "Robin Hood";
				break;
				case "shaman":
				tmpString = "Shaman";
				break;
				case "gladiator":
				tmpString = "Gladiator";
				break;
			}
			for (var i:int = 0; i < tmpObject.lockedHeroesArray.length; i++)
			{
				tmpTowerData = tmpObject.lockedHeroesArray[i];
				if (tmpTowerData.title == tmpString)
				{
					tmpTowerData.isUnlocked = true;
					tmpObject.lockedHeroesArray.splice(i, 1);
					break;
				}
			}
			tmpObject.money = App.START_MONEY;
			App.MakeSignatureForShObject();
			SelectLevelPage();
		}
		
		private function onCancelEvent(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			removeListenersFromSelectHero();
			SelectProfilePage();
		}
		
		private function onNextHero(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			var tmpIcon:MovieClip = _mainMenuGrp.heroButton.iconPlayer;
			if (tmpIcon.currentFrame < tmpIcon.totalFrames)
			{
				tmpIcon.gotoAndStop(tmpIcon.currentFrame + 1);
			}
			else
			{
				tmpIcon.gotoAndStop(1);
			}
		}
		
		private function onPrevHero(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			var tmpIcon:MovieClip = _mainMenuGrp.heroButton.iconPlayer;
			if (tmpIcon.currentFrame > 1)
			{
				tmpIcon.gotoAndStop(tmpIcon.currentFrame - 1);
			}
			else
			{
				tmpIcon.gotoAndStop(tmpIcon.totalFrames);
			}
		}
			
		private function onAplyUpdates(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			App.soundControl.playSound("upgrade");
			
			var tmpUpdate:Update;
			for (var i:int = 0; i < App.UPDATES_NMBR; i++)
			{
				tmpUpdate = App.currentPlayer.updatesArray[i];
				tmpUpdate.UpdateVars();
			}
			App.MakeSignatureForShObject();
			UpdatesPage();
		}
		
		private function onUndoUpdates(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			Update.AllUpsToZero();
			UpdatesPage();
		}
		
		private function onAplySpells(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			App.soundControl.playSound("upgrade");
			
			var tmpSpell:Spell;
			for (var i:int = 0; i < App.SPELLS_NMBR; i++)
			{
				tmpSpell = App.currentPlayer.spellsArray[i];
				tmpSpell.UpdateVars();
			}
			App.MakeSignatureForShObject();
			SpellsPage();
		}
		
		private function onUndoSpells(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			Spell.AllSpellsToZero();
			SpellsPage();
		}
		
		private function onUpdateInGameSpells(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			var tmpCheckbox:MovieClip = e.currentTarget as MovieClip;
			App.currentPlayer.spellsArray[tmpCheckbox.parent.name.split("_")[1]].checkBoxState = "change";
			SpellsPage();
		}
		
		private function onNextLevelEvent(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			_mainMenuGrp.musicBtn.removeEventListener(MouseEvent.CLICK, onChangeMusicStatus, false);
			_mainMenuGrp.volumeBtn.removeEventListener(MouseEvent.CLICK, onChangeSoundStatus, false);
			_mainMenuGrp.restart.removeEventListener(MouseEvent.CLICK, onRestartEvent, false);
			_mainMenuGrp.map.removeEventListener(MouseEvent.CLICK, onWonToSelectLevel, false);
			if (_mainMenuGrp.next)
			{
				_mainMenuGrp.next.removeEventListener(MouseEvent.CLICK, onNextLevelEvent, false);
			}
			
			if (App.currentLevel != 20)
			{
				App.currentLevel++;
				dispatchEvent(new InterfaceEvent(InterfaceEvent.INTERFACE_EVENT, true, false, InterfaceEvent.START_GAME, App.currentLevel));
			}
			else
			{
				EndStoryPage();
			}
		}
		
		private function EndStoryPage():void 
		{
			_mainMenuGrp.gotoAndStop("end_story");
			_mainMenuGrp.musicBtn.addEventListener(MouseEvent.CLICK, onChangeMusicStatus, false, 0, true);
			_mainMenuGrp.volumeBtn.addEventListener(MouseEvent.CLICK, onChangeSoundStatus, false, 0, true);
			_mainMenuGrp.BackBtn.addEventListener(MouseEvent.CLICK, onEndStoryToMap, false, 0, true);
		}
		
		private function onEndStoryToMap(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			_mainMenuGrp.musicBtn.removeEventListener(MouseEvent.CLICK, onChangeMusicStatus, false);
			_mainMenuGrp.volumeBtn.removeEventListener(MouseEvent.CLICK, onChangeSoundStatus, false);
			_mainMenuGrp.BackBtn.removeEventListener(MouseEvent.CLICK, onEndStoryToMap, false);
			SelectLevelPage();
		}
		
		private function onRestartEvent(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			_mainMenuGrp.musicBtn.removeEventListener(MouseEvent.CLICK, onChangeMusicStatus, false);
			_mainMenuGrp.volumeBtn.removeEventListener(MouseEvent.CLICK, onChangeSoundStatus, false);
			_mainMenuGrp.restart.removeEventListener(MouseEvent.CLICK, onRestartEvent, false);
			_mainMenuGrp.map.removeEventListener(MouseEvent.CLICK, onWonToSelectLevel, false);
			if (_mainMenuGrp.next)
			{
				_mainMenuGrp.next.removeEventListener(MouseEvent.CLICK, onNextLevelEvent, false);
			}
			dispatchEvent(new InterfaceEvent(InterfaceEvent.INTERFACE_EVENT, true, false, InterfaceEvent.START_GAME, App.currentLevel));
		}
		
		
		//функции удаления ивент листенеров со страниц
		
		private function removeListenersFromSelectHero():void
		{
			_mainMenuGrp.musicBtn.removeEventListener(MouseEvent.CLICK, onChangeMusicStatus, false);
			_mainMenuGrp.volumeBtn.removeEventListener(MouseEvent.CLICK, onChangeSoundStatus, false);
			_mainMenuGrp.nextHero.removeEventListener(MouseEvent.CLICK, onNextHero, false);
			_mainMenuGrp.prevHero.removeEventListener(MouseEvent.CLICK, onPrevHero, false);
			_mainMenuGrp.cancelBtn.removeEventListener(MouseEvent.CLICK, onCancelEvent, false);
			_mainMenuGrp.okBtn.removeEventListener(MouseEvent.CLICK, onOkEvent, false);
		}
		
		private function removeListenersFromUpdatesPage():void
		{	
			_mainMenuGrp.UpgradesTab.SpellsTab.removeEventListener(MouseEvent.CLICK, onUpdatesToSpells, false);
			_mainMenuGrp.BackBtn.removeEventListener(MouseEvent.CLICK, onUpdatesToSelectLevel, false);
			if (_mainMenuGrp.applyBtn.currentFrame == 2)
			{ _mainMenuGrp.applyBtn.OkBtn.removeEventListener(MouseEvent.CLICK, onAplyUpdates, false); }
			if (_mainMenuGrp.undoBtn.currentFrame == 2)
			{ _mainMenuGrp.undoBtn.UndoBtn.removeEventListener(MouseEvent.CLICK, onUndoUpdates, false); }
			_mainMenuGrp.musicBtn.removeEventListener(MouseEvent.CLICK, onChangeMusicStatus, false);
			_mainMenuGrp.volumeBtn.removeEventListener(MouseEvent.CLICK, onChangeSoundStatus, false);
			
			var tmpUpdate:Update;
			var tmpUpdateVisual:MovieClip;
			for (var i:int = 0; i < App.UPDATES_NMBR; i++)
			{
				tmpUpdateVisual = _mainMenuGrp._unitsTabSprite.getChildByName("update_" + String(i)) as MovieClip;
				tmpUpdateVisual.LvlBtn.removeEventListener(MouseEvent.CLICK, onUpdateCurrentLevel, false);
				tmpUpdateVisual.removeEventListener(MouseEvent.CLICK, onUpdateEpoch, false);
				tmpUpdate = App.currentPlayer.updatesArray[i];
				var length:int = tmpUpdate.nextUpsArray.length;
				var tmpNextUpdate:Update;
				for (var k:int = 0; k < length; k++)
				{
					tmpNextUpdate = tmpUpdate.nextUpsArray[k];
					var tmpPipka:MovieClip;
					for (var l:int = 1; l <= tmpNextUpdate.stepsToAvailable; l++)
					{
						tmpPipka = _mainMenuGrp._unitsTabSprite.getChildByName("ProgressBar_" + String(i + 1 + k) + "_" + String(l)) as MovieClip;
						if (tmpPipka)
						{
							tmpPipka.removeEventListener(MouseEvent.CLICK, onUpdatePipkaUpgrade, false);
						}
					}
				}
			}
		}
		
		private function removeListenersFromSpellsPage():void 
		{
			_mainMenuGrp.UpgradesTab.UnitsTab.removeEventListener(MouseEvent.CLICK, onSpellsToUpdates, false);
			_mainMenuGrp.BackBtn.removeEventListener(MouseEvent.CLICK, onSpellsToSelectLevel, false);
			if (_mainMenuGrp.applyBtn.currentFrame == 2)
			{ _mainMenuGrp.applyBtn.OkBtn.removeEventListener(MouseEvent.CLICK, onAplyUpdates, false); }
			if (_mainMenuGrp.undoBtn.currentFrame == 2)
			{ _mainMenuGrp.undoBtn.UndoBtn.removeEventListener(MouseEvent.CLICK, onUndoUpdates, false); }
			_mainMenuGrp.musicBtn.removeEventListener(MouseEvent.CLICK, onChangeMusicStatus, false);
			_mainMenuGrp.volumeBtn.removeEventListener(MouseEvent.CLICK, onChangeSoundStatus, false);
			
			var tmpSpell:Spell;
			var tmpVisualSpell:MovieClip;
			
			for (var i:int = 0; i < App.SPELLS_NMBR; i++)
			{
				tmpVisualSpell = _mainMenuGrp._unitsTabSprite.getChildByName("spell_" + String(i)) as MovieClip;
				tmpVisualSpell.LvlBtn.removeEventListener(MouseEvent.CLICK, onMagicCurrentLevel, false);
				tmpVisualSpell.removeEventListener(MouseEvent.CLICK, onUpdateMagic, false);
				tmpSpell = App.currentPlayer.spellsArray[i];
				var tmpNextSpell:Spell = tmpSpell.nextUp;
				if (tmpNextSpell)
				{
					var tmpPipka:MovieClip;
					for (var l:int = 1; l <= tmpNextSpell.stepsToAvailable; l++)
					{
						tmpPipka = _mainMenuGrp._unitsTabSprite.getChildByName("ProgressBar_" + String(i + 1) + "_" + String(l)) as MovieClip;
						if (tmpPipka)
						{
							tmpPipka.removeEventListener(MouseEvent.CLICK, onMagicPipkaUpgrade, false);
						}
					}
				}
			}
		}
		
		
		//функции перехода со страницы на страницу
		
		private function onMainMenuToCreditsMenu(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			_mainMenuGrp.musicBtn.removeEventListener(MouseEvent.CLICK, onChangeMusicStatus, false);
			_mainMenuGrp.volumeBtn.removeEventListener(MouseEvent.CLICK, onChangeSoundStatus, false);
			_mainMenuGrp.playBtn.removeEventListener(MouseEvent.CLICK, onMainMenuToSelectProfileMenu, false);
			_mainMenuGrp.creditsBtn.removeEventListener(MouseEvent.CLICK, onMainMenuToCreditsMenu, false);
			CreditsPage();
		}
		
		private function onCreditsToMainMenu(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			_mainMenuGrp.musicBtn.removeEventListener(MouseEvent.CLICK, onChangeMusicStatus, false);
			_mainMenuGrp.volumeBtn.removeEventListener(MouseEvent.CLICK, onChangeSoundStatus, false);
			_mainMenuGrp.BackBtn.removeEventListener(MouseEvent.CLICK, onCreditsToMainMenu, false);
			MainMenuPage();
		}
		
		private function onMainMenuToSelectProfileMenu(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			_mainMenuGrp.playBtn.removeEventListener(MouseEvent.CLICK, onMainMenuToSelectProfileMenu, false);
			_mainMenuGrp.musicBtn.removeEventListener(MouseEvent.CLICK, onChangeMusicStatus, false);
			_mainMenuGrp.volumeBtn.removeEventListener(MouseEvent.CLICK, onChangeSoundStatus, false);
			SelectProfilePage();
		}
		
		private function onUpdatesToSpells(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			Update.AllUpsToZero();
			removeListenersFromUpdatesPage();
			Spell.AllSpellsToZero();
			SpellsPage();
		}
		
		private function onSpellsToUpdates(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			Spell.AllSpellsToZero();
			removeListenersFromSpellsPage();
			Update.AllUpsToZero();
			UpdatesPage();
		}
		
		private function onSelectProfileToMainMenu(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			_mainMenuGrp.backBtn.removeEventListener(MouseEvent.CLICK, onSelectProfileToMainMenu, false);
			_mainMenuGrp.musicBtn.removeEventListener(MouseEvent.CLICK, onChangeMusicStatus, false);
			_mainMenuGrp.volumeBtn.removeEventListener(MouseEvent.CLICK, onChangeSoundStatus, false);
			for (var i:int = 0; i < App.ACCS_NMBR; i++)
			{
				var tmpIconBtn:MovieClip = (_mainMenuGrp.getChildByName("icon_" + i.toString()) as MovieClip);
				tmpIconBtn.removeEventListener(MouseEvent.CLICK, onSelectProfileToSelectHero, false);
				(_mainMenuGrp.getChildByName("delete_" + String(i)) as SimpleButton).removeEventListener(MouseEvent.CLICK, onDeleteEvent, false);
			}
			MainMenuPage();
		}
		
		private function onSelectProfileToSelectHero(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			_mainMenuGrp.backBtn.removeEventListener(MouseEvent.CLICK, onSelectProfileToMainMenu, false);
			_mainMenuGrp.musicBtn.removeEventListener(MouseEvent.CLICK, onChangeMusicStatus, false);
			_mainMenuGrp.volumeBtn.removeEventListener(MouseEvent.CLICK, onChangeSoundStatus, false);
			for (var i:int = 0; i < App.ACCS_NMBR; i++)
			{
				var tmpIconBtn:MovieClip = (_mainMenuGrp.getChildByName("icon_" + i.toString()) as MovieClip);
				tmpIconBtn.removeEventListener(MouseEvent.CLICK, onSelectProfileToSelectHero, false);
				(_mainMenuGrp.getChildByName("delete_" + String(i)) as SimpleButton).removeEventListener(MouseEvent.CLICK, onDeleteEvent, false);
			}
			var tmpString:String = (e.currentTarget as MovieClip).name;
			var numAcc:int = int(tmpString.split("_")[1]);
			var tmpObject:PlayerAccount = App.playersArray[numAcc];
			App.currentPlayer = tmpObject;
			
			if (tmpObject.available)
			{
				onSelectProfileToSelectLevel();
			}
			else
			{
				SelectHeroPage();
			}
		}
		
		private function onSelectProfileToSelectLevel():void 
		{
			SelectLevelPage();
		}
		
		private function onUpdatesToSelectLevel(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			removeListenersFromUpdatesPage();
			SelectLevelPage();
		}
		
		private function onSpellsToSelectLevel(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			removeListenersFromSpellsPage();
			SelectLevelPage();
		}
		
		private function onSelectLevelToSelectProfile(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			_mainMenuGrp.BackBtn.removeEventListener(MouseEvent.CLICK, onSelectLevelToSelectProfile, false);
			_mainMenuGrp.UnitsBtn.removeEventListener(MouseEvent.CLICK, onSelectLevelToUpdates, false);
			var tmpLevel:MovieClip;
			for (var i:int = 1; i <= App.LEVELS_NMBR; i++)
			{
				tmpLevel = _mainMenuGrp.getChildByName("level_" + String(i)) as MovieClip;
				tmpLevel.removeEventListener(MouseEvent.CLICK, onStartLevel, false);
				tmpLevel.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false);
				tmpLevel.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false);
			}
			//TO DO переход от Селект_Левел в Скилы
			_mainMenuGrp.musicBtn.removeEventListener(MouseEvent.CLICK, onChangeMusicStatus, false);
			_mainMenuGrp.volumeBtn.removeEventListener(MouseEvent.CLICK, onChangeSoundStatus, false);
			SelectProfilePage();
		}
		
		private function onSelectLevelToUpdates(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			_mainMenuGrp.BackBtn.removeEventListener(MouseEvent.CLICK, onSelectLevelToSelectProfile, false);
			_mainMenuGrp.UnitsBtn.removeEventListener(MouseEvent.CLICK, onSelectLevelToUpdates, false);
			//TO DO переход от Селект_Левел в Скилы
			var tmpLevel:MovieClip;
			for (var i:int = 1; i <= App.LEVELS_NMBR; i++)
			{
				tmpLevel = _mainMenuGrp.getChildByName("level_" + String(i)) as MovieClip;
				tmpLevel.removeEventListener(MouseEvent.CLICK, onStartLevel, false);
				tmpLevel.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false);
				tmpLevel.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false);
			}
			_mainMenuGrp.musicBtn.removeEventListener(MouseEvent.CLICK, onChangeMusicStatus, false);
			_mainMenuGrp.volumeBtn.removeEventListener(MouseEvent.CLICK, onChangeSoundStatus, false);
			
			Update.AllUpsToZero();
			UpdatesPage();
		}
		
		private function onWonToSelectLevel(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			_mainMenuGrp.musicBtn.removeEventListener(MouseEvent.CLICK, onChangeMusicStatus, false);
			_mainMenuGrp.volumeBtn.removeEventListener(MouseEvent.CLICK, onChangeSoundStatus, false);
			_mainMenuGrp.restart.removeEventListener(MouseEvent.CLICK, onRestartEvent, false);
			_mainMenuGrp.map.removeEventListener(MouseEvent.CLICK, onWonToSelectLevel, false);
			if (_mainMenuGrp.next)
			{
				_mainMenuGrp.next.removeEventListener(MouseEvent.CLICK, onNextLevelEvent, false);
			}
			_mainMenuGrp.BackBtn.removeEventListener(MouseEvent.CLICK, onWonToUpdates, false);
			SelectLevelPage();
		}
		
		
		//управление звуком
		
		private function onChangeSoundStatus(e:MouseEvent):void 
		{
			App.soundControl.ChangeSoundMode();
			App.soundControl.playSound("click");
			App.soundStatus = !App.soundStatus;
			updateButtonsBySoundStatus();
		}
		
		private function onChangeMusicStatus(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			App.musicStatus = !App.musicStatus;
			App.sndManager.changeMusicMode();
			updateButtonsBySoundStatus();
		}
		
		private function updateButtonsBySoundStatus():void
		{
			if (App.soundStatus)
			{
				_mainMenuGrp.volumeBtn.gotoAndStop("on");
			}
			else
			{
				_mainMenuGrp.volumeBtn.gotoAndStop("off");
			}
			if (App.musicStatus)
			{
				_mainMenuGrp.musicBtn.gotoAndStop("on");
			}
			else
			{
				_mainMenuGrp.musicBtn.gotoAndStop("off");
			}
		}
	}
}