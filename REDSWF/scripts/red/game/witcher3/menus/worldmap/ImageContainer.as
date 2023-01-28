package red.game.witcher3.menus.worldmap
{
   import flash.geom.Point;
   import scaleform.clik.core.UIComponent;
   
   public class ImageContainer extends UIComponent
   {
       
      
      private var _tiles:Vector.<Vector.<HubMapTile>>;
      
      private var _boundariesX:Vector.<Boundary>;
      
      private var _boundariesY:Vector.<Boundary>;
      
      private var _tileCount:int;
      
      private var _tileScale:Number;
      
      private var _mapImagesPath:String;
      
      private var _mapTextureSize:int;
      
      private var _currentLod:int;
      
      private var _tileMinX:int;
      
      private var _tileMaxX:int;
      
      private var _tileMinY:int;
      
      private var _tileMaxY:int;
      
      private var _tilesInvisible:int = 0;
      
      private var _tilesVisible:int = 0;
      
      private var _hideInterval:int = 0;
      
      private var _showOnlyTilesFromBoundaries:Boolean = true;
      
      public function ImageContainer()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
      }
      
      public function GetMapTextureSize() : int
      {
         return this._mapTextureSize;
      }
      
      public function CreateLod(param1:int, param2:int, param3:String, param4:int, param5:int, param6:int, param7:int) : *
      {
         this.DeleteTiles();
         this._mapTextureSize = param1;
         this._currentLod = param2;
         this._mapImagesPath = param3;
         this._tileCount = Math.pow(2,this._currentLod);
         this._tileScale = Math.pow(2,this._currentLod - 1);
         this.CreateBoundaries();
         this._tileMinX = this.GetBoundaryX(param4 + 1);
         this._tileMaxX = this.GetBoundaryX(param5 - 1);
         this._tileMinY = this.GetBoundaryY(param6 + 1);
         this._tileMaxY = this.GetBoundaryY(param7 - 1);
         this.CreateTiles();
      }
      
      private function CreateBoundaries() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         this._boundariesX = new Vector.<Boundary>();
         _loc1_ = 0;
         while(_loc1_ < this._tileCount)
         {
            this._boundariesX[_loc1_] = new Boundary(-(this._tileScale - _loc1_) * this._mapTextureSize / this._tileScale,-(this._tileScale - _loc1_ - 1) * this._mapTextureSize / this._tileScale);
            _loc1_++;
         }
         this._boundariesY = new Vector.<Boundary>();
         _loc2_ = 0;
         while(_loc2_ < this._tileCount)
         {
            this._boundariesY[_loc2_] = new Boundary(-(this._tileScale - _loc2_) * this._mapTextureSize / this._tileScale,-(this._tileScale - _loc2_ - 1) * this._mapTextureSize / this._tileScale);
            _loc2_++;
         }
      }
      
      private function CreateTiles() : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc1_:* = "img://maps/" + this._mapImagesPath + "/level" + this._currentLod + "/tile";
         var _loc2_:String = ".jpg";
         this._tiles = new Vector.<Vector.<HubMapTile>>();
         _loc4_ = 0;
         while(_loc4_ < this._tileCount)
         {
            _loc5_ = this._tileScale - _loc4_ - 1;
            this._tiles[_loc4_] = new Vector.<HubMapTile>();
            _loc3_ = 0;
            while(_loc3_ < this._tileCount)
            {
               _loc6_ = this._tileScale - _loc3_;
               this._tiles[_loc4_][_loc3_] = new HubMapTile(_loc1_ + _loc3_ + "x" + _loc4_ + _loc2_,_loc3_,_loc4_,_loc6_ * this._mapTextureSize / this._tileScale,-_loc5_ * this._mapTextureSize / this._tileScale,this._tileScale,this);
               _loc3_++;
            }
            _loc4_++;
         }
      }
      
      public function DeleteTiles() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         if(!this._tiles)
         {
            return;
         }
         _loc2_ = 0;
         while(_loc2_ < this._tileCount)
         {
            _loc1_ = 0;
            while(_loc1_ < this._tileCount)
            {
               this._tiles[_loc2_][_loc1_].ShowTile(false);
               _loc1_++;
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this._tileCount)
         {
            this._tiles[_loc2_].splice(0,this._tiles[_loc2_].length);
            this._tiles[_loc2_] = null;
            _loc2_++;
         }
         this._tiles.splice(0,this._tiles.length);
         this._tiles = null;
      }
      
      private function PrintTiles() : *
      {
         var _loc2_:* = undefined;
         var _loc3_:HubMapTile = null;
         var _loc1_:* = 0;
         while(_loc1_ < this._tileCount)
         {
            _loc2_ = 0;
            while(_loc2_ < this._tileCount)
            {
               _loc3_ = this._tiles[_loc1_][_loc2_] as HubMapTile;
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      private function PrintTiles2() : *
      {
         var _loc2_:* = null;
         var _loc3_:* = undefined;
         var _loc4_:HubMapTile = null;
         var _loc1_:* = this._tileCount - 1;
         while(_loc1_ >= 0)
         {
            _loc2_ = "";
            _loc3_ = 0;
            while(_loc3_ < this._tileCount)
            {
               if((_loc4_ = this._tiles[_loc1_][_loc3_] as HubMapTile).IsLoader())
               {
                  _loc2_ += "X";
               }
               else
               {
                  _loc2_ += ".";
               }
               _loc3_++;
            }
            _loc1_--;
         }
      }
      
      public function GetBoundaryX(param1:Number) : int
      {
         var _loc2_:int = int(this._boundariesX.length);
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_)
         {
            if(this._boundariesX[_loc3_].IsInside(param1))
            {
               return _loc3_;
            }
            _loc3_++;
         }
         if(param1 >= this._boundariesX[_loc2_ - 1]._max)
         {
            return _loc2_;
         }
         return -1;
      }
      
      public function GetBoundaryY(param1:Number) : int
      {
         var _loc2_:int = int(this._boundariesY.length);
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_)
         {
            if(this._boundariesY[_loc3_].IsInside(param1))
            {
               return _loc3_;
            }
            _loc3_++;
         }
         if(param1 >= this._boundariesY[_loc2_ - 1]._max)
         {
            return _loc2_;
         }
         return -1;
      }
      
      public function UpdateTileStats() : *
      {
      }
      
      public function UpdateTiles(param1:Point, param2:Point, param3:Point) : *
      {
         var _loc10_:* = undefined;
         var _loc4_:int = this.GetBoundaryX(param2.x);
         var _loc5_:int = this.GetBoundaryY(-param2.y);
         var _loc6_:int = this.GetBoundaryX(param3.x);
         var _loc7_:int = this.GetBoundaryY(-param3.y);
         var _loc8_:int = 0;
         var _loc9_:* = 0;
         while(_loc9_ < this._tileCount)
         {
            if(!(this._showOnlyTilesFromBoundaries && (_loc9_ < this._tileMinY || _loc9_ > this._tileMaxY)))
            {
               _loc10_ = 0;
               while(_loc10_ < this._tileCount)
               {
                  if(!(this._showOnlyTilesFromBoundaries && (_loc10_ < this._tileMinX || _loc10_ > this._tileMaxX)))
                  {
                     if(_loc10_ >= _loc4_ && _loc10_ <= _loc6_ && _loc9_ >= _loc5_ && _loc9_ <= _loc7_)
                     {
                        this._tiles[_loc9_][_loc10_].ShowTile(true);
                        _loc8_++;
                     }
                     else
                     {
                        this._tiles[_loc9_][_loc10_].ShowTile(false);
                     }
                  }
                  _loc10_++;
               }
            }
            _loc9_++;
         }
         this.UpdateTileStats();
         this._hideInterval = 0;
      }
      
      public function ShowAllTiles() : *
      {
         var _loc2_:* = undefined;
         var _loc3_:HubMapTile = null;
         var _loc1_:* = 0;
         while(_loc1_ < this._tileCount)
         {
            _loc2_ = 0;
            while(_loc2_ < this._tileCount)
            {
               _loc3_ = this._tiles[_loc1_][_loc2_];
               if(_loc3_)
               {
                  _loc3_.ShowTile(true);
               }
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      public function HideTiles() : *
      {
         var _loc2_:* = undefined;
         var _loc3_:HubMapTile = null;
         var _loc1_:* = 0;
         while(_loc1_ < this._tileCount)
         {
            _loc2_ = 0;
            while(_loc2_ < this._tileCount)
            {
               _loc3_ = this._tiles[_loc1_][_loc2_];
               if(_loc3_)
               {
                  _loc3_.ShowTile(false);
               }
               _loc2_++;
            }
            _loc1_++;
         }
         this.UpdateTileStats();
      }
      
      public function RequestHideTiles() : *
      {
         this._hideInterval = 1000;
      }
      
      public function ProcessHidingTiles(param1:int) : *
      {
         if(this._hideInterval > 0)
         {
            this._hideInterval -= param1;
            if(this._hideInterval <= 0)
            {
               this.HideTiles();
            }
         }
      }
      
      public function UpdateDebugBorders() : *
      {
         var _loc2_:* = undefined;
         var _loc3_:HubMapTile = null;
         var _loc1_:* = 0;
         while(_loc1_ < this._tileCount)
         {
            _loc2_ = 0;
            while(_loc2_ < this._tileCount)
            {
               _loc3_ = this._tiles[_loc1_][_loc2_];
               if(Boolean(_loc3_) && _loc3_.IsLoader())
               {
                  _loc3_.UpdateDebugBorders();
               }
               _loc2_++;
            }
            _loc1_++;
         }
      }
   }
}

class Boundary
{
    
   
   public var _min:int;
   
   public var _max:int;
   
   public function Boundary(param1:int, param2:int)
   {
      super();
      this._min = param1;
      this._max = param2;
   }
   
   public function IsInside(param1:int) : Boolean
   {
      return param1 >= this._min && param1 <= this._max;
   }
}
