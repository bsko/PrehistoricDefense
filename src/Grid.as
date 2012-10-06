package  
{
	import flash.display.MovieClip;
	import flash.display.Shader;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author author
	 */
	public class Grid extends Sprite
	{
		private var _tileSkin:MovieClip = new tileMovie();
		private var _cellState:int;
		private var _ableState:String;
		private var _tower:Tower;
		private var _gridHeight:int;
		private var _isCampOwner:Boolean;
		private var _objectsArray:Array = [];
		private var _isChestOwner:Boolean;
		private var _isWheatOwner:Boolean;
		private var _wheat:WheatControl;
		private var _ableMovie:MovieClip = new MarkersMovie();
		private var _X_index:int;
		private var _Y_index:int;
		
		public function Grid(x:int, y:int):void 
		{
			_X_index = x;
			_Y_index = y;
			var tmpPoint:Point = App.gridCoordinatesToUniverse(x, y);
			this.y = tmpPoint.y;
			this.x = tmpPoint.x;
			// тест
			tmpPoint = App.universeCoordinatesToGrid(this.x, this.y);
			addChild(_tileSkin);
			_tileSkin.name = "tileSkin_" + x.toString() + "_" + y.toString();
			cellState = App.CELL_STATE_GRASS;
			ableState = App.CELL_STATE_BUSY;
			isCampOwner = false;
			isWheatOwner = false;
			isChestOwner = false;
			_ableMovie.alpha = 0.5;
			addChild(_ableMovie);
			_ableMovie.visible = false;
		}
		
		public function addObject(_x:int, _y:int, type:int):void
		{
			var tmpObject:VisualObject = App.pools.getPoolObject(VisualObject.NAME);
			addChild(tmpObject);
			tmpObject.Init(type, this);
			tmpObject.x = _x;
			tmpObject.y = _y;// - gridHeight;
			addChild(_ableMovie);
		}
		
		public function removeVisualObjects():void
		{
			if (_isWheatOwner)
			{
				wheat.Destroy();
			}
			var length:int = objectsArray.length;
			for (var i:int = 0; i < length; i++)
			{
				var tmpObj:VisualObject = objectsArray[i];
				tmpObj.destroy();
				removeChild(tmpObj);
			}
			objectsArray.length = 0;
			isCampOwner = false;
			isChestOwner = false;
		}
		
		public function removeTower():void
		{
			if (_tower)
			{
				_tower.destroy();
			}
		}
		
		public function get cellState():int { return _cellState; }
		
		public function set cellState(value:int):void 
		{
			_cellState = value;
			_tileSkin.gotoAndStop(_cellState);
		}
		
		public function get ableState():String { return _ableState; }
		
		public function set ableState(value:String):void 
		{
			_ableState = value;
		}
		
		public function get tower():Tower { return _tower; }
		
		public function set tower(value:Tower):void 
		{
			_tower = value;
		}
		
		public function get gridHeight():int { return _gridHeight; }
		
		public function set gridHeight(value:int):void 
		{
			_gridHeight = value;
			_tileSkin.y = ( -1) * value;
			_ableMovie.y = (- 1) * value;
		}
		
		public function get isCampOwner():Boolean { return _isCampOwner; }
		
		public function set isCampOwner(value:Boolean):void 
		{
			_isCampOwner = value;
		}
		
		public function get isChestOwner():Boolean { return _isChestOwner; }
		
		public function set isChestOwner(value:Boolean):void 
		{
			_isChestOwner = value;
		}
		
		public function get ableMovie():MovieClip { return _ableMovie; }
		
		public function set ableMovie(value:MovieClip):void 
		{
			_ableMovie = value;
		}
		
		public function get X_index():int { return _X_index; }
		
		public function get Y_index():int { return _Y_index; }
		
		public function get isWheatOwner():Boolean { return _isWheatOwner; }
		
		public function set isWheatOwner(value:Boolean):void 
		{
			_isWheatOwner = value;
		}
		
		public function get wheat():WheatControl { return _wheat; }
		
		public function set wheat(value:WheatControl):void 
		{
			_wheat = value;
		}
		
		public function get objectsArray():Array { return _objectsArray; }
		
		public function set objectsArray(value:Array):void 
		{
			_objectsArray = value;
		}
	}

}