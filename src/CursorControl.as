package  
{
	import Events.ChangeCursor;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author i am
	 */
	public class CursorControl extends Sprite
	{
		public static const MOUSE_UNIVERSE:String = "mouseuniverse";
		public static const MOUSE_MAGIC:String = "mousemagic";
		public static const MOUSE_WHEAT:String = "mousewheat";
		public static const MOUSE_MENU:String = "mousemenu";
		public static const MOUSE_BUTTON:String = "mousebutton";
		public static const MOUSE_BUTTON_PRESSED:String = "mousebutton2";
		public static const MOUSE_TOWER:String = "mousepopuptower";
		public static const MOUSE_MAIN_MENU:String = "mousemenu";
		private var _cursorLayer:Sprite = new Sprite();
		private var _cursor:MovieClip = new menu_cursor();
		private var _universe_cursor:MovieClip = new menu_cursor();
		private var _mouseStatus:String;
		private var _mouseDown:Boolean = false;
		private var _useMagic:Boolean = false;
		private var _magicLabel:String = "";
		
		public function Init():void
		{
			Mouse.hide();
			_cursorLayer.addChild(_cursor);
			addChild(_cursorLayer);
			_cursor.x = -100;
			_cursor.y = -100;
			
			_cursorLayer.mouseEnabled = false;
			_cursor.mouseEnabled = false;
			mouseEnabled = false;
			
			addEventListener(Event.ENTER_FRAME, onUpdateCursorPosition, false, 0, true);
			App.mainInterface.addEventListener(MouseEvent.MOUSE_MOVE, onUpdateMainMenuMouse, false, 0, true);
		}
		
		private function onUpdateCursorPosition(e:Event):void 
		{
			Mouse.hide();
		}
		
		public function addUniverseCursor():void 
		{
			App.universe.cursorsLayer.addChild(_universe_cursor);
			_universe_cursor.mouseEnabled = false;
			App.universe.addEventListener(MouseEvent.MOUSE_MOVE, onUpdateUniverseMouse, false, 0, true);
			App.ingameInterface.addEventListener(MouseEvent.MOUSE_MOVE, onUpdateMenuMouse, false, 0, true);
			App.ingameInterface.addEventListener(MouseEvent.MOUSE_DOWN, onMouseInterfaceDown, false, 0, true);
			App.ingameInterface.addEventListener(MouseEvent.MOUSE_UP, onMouseInterfaceUp, false, 0, true);
			App.universe.addEventListener(ChangeCursor.CHANGE_CURSOR, onChangeCursor, false, 0, true);
		}
		
		public function removeUniverseCursor():void 
		{
			App.universe.cursorsLayer.removeChild(_universe_cursor);
			App.universe.removeEventListener(MouseEvent.MOUSE_MOVE, onUpdateUniverseMouse, false);
			App.ingameInterface.removeEventListener(MouseEvent.MOUSE_MOVE, onUpdateMenuMouse, false);
			App.ingameInterface.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseInterfaceDown, false);
			App.ingameInterface.removeEventListener(MouseEvent.MOUSE_UP, onMouseInterfaceUp, false);
			App.universe.removeEventListener(ChangeCursor.CHANGE_CURSOR, onChangeCursor, false);
		}
		
		private function onUpdateMainMenuMouse(e:MouseEvent = null):void 
		{
			if (e == null || e.target is SimpleButton)
			{
				if(!_mouseDown) {
					if (_mouseStatus != MOUSE_BUTTON) {
						_mouseStatus = MOUSE_BUTTON;
						_cursor.gotoAndStop(_mouseStatus);
					}
				} else {
					if (_mouseStatus != MOUSE_BUTTON_PRESSED) {
						_mouseStatus = MOUSE_BUTTON_PRESSED;
						_cursor.gotoAndStop(_mouseStatus);
					}
				}
			}
			else
			{
				if (_mouseStatus != MOUSE_MAIN_MENU) {
					_mouseStatus = MOUSE_MAIN_MENU;
					_cursor.gotoAndStop(_mouseStatus);
				}
			}
			_cursor.x = mouseX;
			_cursor.y = mouseY;
			if (e != null)
			{
				//e.updateAfterEvent();
			}
		}
		
		private function onMouseInterfaceDown(e:MouseEvent):void 
		{
			_mouseDown = true;
			onUpdateMenuMouse();
		}
		
		private function onMouseInterfaceUp(e:MouseEvent):void 
		{
			_mouseDown = false;
			onUpdateMenuMouse();
		}
		
		private function onChangeCursor(e:ChangeCursor):void 
		{
			switch(e.subtype)
			{
				case ChangeCursor.CURSOR_DEFAULT:
					_useMagic = false;
					_mouseStatus = MOUSE_UNIVERSE;
					_universe_cursor.gotoAndStop(_mouseStatus);
				break;
				case ChangeCursor.CURSOR_MAGIC:
					_useMagic = true;
					_magicLabel = e.cursorType;
				break;
			}
		}
		
		private function onUpdateUniverseMouse(e:MouseEvent):void 
		{	
			var tmpArray:Array = App.universe.getObjectsUnderPoint(new Point(mouseX, mouseY));
			var tmpGrid:Grid;
			for (var i:int = tmpArray.length - 1; i >= 0; i--)
			{
				if (tmpArray[i].parent is tileMovie)
				{
					var tmpShape:Shape = tmpArray[i];
					if(tmpShape.parent.parent is Grid) {
						tmpGrid = (tmpShape.parent.parent as Grid);
						_universe_cursor.visible = true;
						if (_useMagic) {
							if (_mouseStatus != MOUSE_MAGIC) {
								_mouseStatus = MOUSE_MAGIC;
								_cursor.gotoAndStop(MOUSE_MENU);
								_universe_cursor.gotoAndStop(_mouseStatus);
								_universe_cursor.magicMovie.gotoAndStop(_magicLabel);
							}
						} else if (tmpGrid.isWheatOwner) {
							if (_mouseStatus != MOUSE_WHEAT) {
								_mouseStatus = MOUSE_WHEAT;
								_cursor.gotoAndStop(MOUSE_MENU);
								_universe_cursor.gotoAndStop(_mouseStatus);
							}
						} else if(tmpGrid.tower != null) {
							if (_mouseStatus != MOUSE_TOWER) {
								_mouseStatus = MOUSE_TOWER;
								_cursor.gotoAndStop(MOUSE_MENU);
								_universe_cursor.gotoAndStop(_mouseStatus);
							}
						} else {
							if (_mouseStatus != MOUSE_UNIVERSE) {
								_mouseStatus = MOUSE_UNIVERSE;
								_cursor.gotoAndStop(MOUSE_MENU);
								_universe_cursor.gotoAndStop(_mouseStatus);
							}
						}
						_universe_cursor.x = tmpGrid.x;
						if (tmpGrid.cellState == App.CELL_STATE_ROAD || tmpGrid.cellState == App.CELL_STATE_WATER)
						{
							_universe_cursor.y = tmpGrid.y;
						}
						else
						{
							_universe_cursor.y = tmpGrid.y - App.HEIGHT_DELAY - tmpGrid.gridHeight;
						}
						if (_mouseStatus == MOUSE_MAGIC)
						{
							App.universe.magicRangeSprite.x = _universe_cursor.x;
							App.universe.magicRangeSprite.y = _universe_cursor.y;
						}
						break;
					}
				}
			}
			_cursor.x = mouseX;
			_cursor.y = mouseY;
			
			e.updateAfterEvent();
		}
		
		private function onUpdateMenuMouse(e:MouseEvent = null):void 
		{
			_universe_cursor.visible = false;
			if (e == null || e.target is SimpleButton)
			{
				if(!_mouseDown) {
					if (_mouseStatus != MOUSE_BUTTON) {
						_mouseStatus = MOUSE_BUTTON;
						_cursor.gotoAndStop(_mouseStatus);
					}
				} else {
					if (_mouseStatus != MOUSE_BUTTON_PRESSED) {
						_mouseStatus = MOUSE_BUTTON_PRESSED;
						_cursor.gotoAndStop(_mouseStatus);
					}
				}
			}
			else
			{
				if (_mouseStatus != MOUSE_MENU) {
					_mouseStatus = MOUSE_MENU;
					_cursor.gotoAndStop(_mouseStatus);
				}
			}
			_cursor.x = mouseX;
			_cursor.y = mouseY;
			if (e != null)
			{
				e.updateAfterEvent();
			}
		}
	
		public function Destroy():void
		{
			removeChild(_cursorLayer);
			App.mainInterface.removeEventListener(MouseEvent.MOUSE_MOVE, onUpdateMainMenuMouse, false);
			removeUniverseCursor();
		}
	}

}