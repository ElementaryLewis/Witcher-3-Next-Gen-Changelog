package red.game.witcher3.hud.modules.minimap2
{
   import flash.filters.GlowFilter;
   import red.game.witcher3.hud.modules.HudModuleMinimap2;
   import scaleform.clik.core.UIComponent;
   
   public class HubMapContainer extends UIComponent
   {
       
      
      private const TILE_NW = 0;
      
      private const TILE_N = 1;
      
      private const TILE_NE = 2;
      
      private const TILE_W = 3;
      
      private const TILE_C = 4;
      
      private const TILE_E = 5;
      
      private const TILE_SW = 6;
      
      private const TILE_S = 7;
      
      private const TILE_SE = 8;
      
      private const TILE_COUNT = 9;
      
      private var m_tileShiftX:Vector.<Number>;
      
      private var m_tileShiftY:Vector.<Number>;
      
      private var m_tileFilenames:Vector.<String>;
      
      private var m_tileVisible:Vector.<Boolean>;
      
      private var m_tiles:Vector.<MinimapLoader>;
      
      private var m_playerTileX:int = -1;
      
      private var m_playerTileY:int = -1;
      
      public function HubMapContainer()
      {
         super();
         this.m_tileShiftX = new Vector.<Number>(this.TILE_COUNT);
         this.m_tileShiftY = new Vector.<Number>(this.TILE_COUNT);
      }
      
      override protected function configUI() : void
      {
         var _loc1_:MinimapLoader = null;
         super.configUI();
         this.m_tileFilenames = new Vector.<String>(this.TILE_COUNT);
         this.m_tileVisible = new Vector.<Boolean>(this.TILE_COUNT);
         this.m_tiles = new Vector.<MinimapLoader>(this.TILE_COUNT);
         var _loc2_:int = 0;
         while(_loc2_ < this.TILE_COUNT)
         {
            _loc1_ = new MinimapLoader();
            _loc1_.autoSize = false;
            addChild(_loc1_);
            this.m_tiles[_loc2_] = _loc1_;
            _loc2_++;
         }
      }
      
      public function InitializeTilePositions() : *
      {
         var _loc1_:* = HudModuleMinimap2.m_tileExteriorTextureSize;
         var _loc2_:* = 0.5;
         this.m_tileShiftX[0] = -_loc1_ + _loc2_;
         this.m_tileShiftX[3] = -_loc1_ + _loc2_;
         this.m_tileShiftX[6] = -_loc1_ + _loc2_;
         this.m_tileShiftX[1] = 0;
         this.m_tileShiftX[4] = 0;
         this.m_tileShiftX[7] = 0;
         this.m_tileShiftX[2] = _loc1_ - _loc2_;
         this.m_tileShiftX[5] = _loc1_ - _loc2_;
         this.m_tileShiftX[8] = _loc1_ - _loc2_;
         this.m_tileShiftY[0] = -_loc1_ - _loc1_ + _loc2_;
         this.m_tileShiftY[1] = -_loc1_ - _loc1_ + _loc2_;
         this.m_tileShiftY[2] = -_loc1_ - _loc1_ + _loc2_;
         this.m_tileShiftY[3] = -_loc1_;
         this.m_tileShiftY[4] = -_loc1_;
         this.m_tileShiftY[5] = -_loc1_;
         this.m_tileShiftY[6] = -_loc1_ + _loc1_ - _loc2_;
         this.m_tileShiftY[7] = -_loc1_ + _loc1_ - _loc2_;
         this.m_tileShiftY[8] = -_loc1_ + _loc1_ - _loc2_;
      }
      
      public function UpdatePosition(param1:Number, param2:Number, param3:Number) : *
      {
         var _loc13_:String = null;
         var _loc14_:* = undefined;
         var _loc15_:int = 0;
         var _loc16_:Vector.<MinimapLoader> = null;
         var _loc17_:MinimapLoader = null;
         var _loc18_:MinimapLoader = null;
         var _loc19_:String = null;
         x = param2;
         y = param3;
         var _loc4_:Number = param1 * 1.25;
         var _loc5_:Number = _loc4_ * _loc4_;
         var _loc6_:Number = -HudModuleMinimap2.m_playerTilePosX;
         var _loc7_:Number = -HudModuleMinimap2.m_playerTilePosY;
         var _loc8_:Number = HudModuleMinimap2.m_tileSize;
         var _loc9_:Number = _loc6_ * _loc6_;
         var _loc10_:Number = (_loc8_ - _loc6_) * (_loc8_ - _loc6_);
         var _loc11_:Number = _loc7_ * _loc7_;
         var _loc12_:Number = (_loc8_ - _loc7_) * (_loc8_ - _loc7_);
         this.m_tileVisible[this.TILE_NW] = _loc9_ + _loc12_ < _loc5_;
         this.m_tileVisible[this.TILE_N] = _loc12_ < _loc5_;
         this.m_tileVisible[this.TILE_NE] = _loc10_ + _loc12_ < _loc5_;
         this.m_tileVisible[this.TILE_W] = _loc9_ < _loc5_;
         this.m_tileVisible[this.TILE_C] = true;
         this.m_tileVisible[this.TILE_E] = _loc10_ < _loc5_;
         this.m_tileVisible[this.TILE_SW] = _loc9_ + _loc11_ < _loc5_;
         this.m_tileVisible[this.TILE_S] = _loc11_ < _loc5_;
         this.m_tileVisible[this.TILE_SE] = _loc10_ + _loc11_ < _loc5_;
         if(HudModuleMinimap2.m_playerTileX != this.m_playerTileX || HudModuleMinimap2.m_playerTileY != this.m_playerTileY)
         {
            this.m_playerTileX = HudModuleMinimap2.m_playerTileX;
            this.m_playerTileY = HudModuleMinimap2.m_playerTileY;
            this.m_tileFilenames[this.TILE_NW] = this.GetTileFilename(this.m_playerTileX - 1,this.m_playerTileY + 1);
            this.m_tileFilenames[this.TILE_N] = this.GetTileFilename(this.m_playerTileX,this.m_playerTileY + 1);
            this.m_tileFilenames[this.TILE_NE] = this.GetTileFilename(this.m_playerTileX + 1,this.m_playerTileY + 1);
            this.m_tileFilenames[this.TILE_W] = this.GetTileFilename(this.m_playerTileX - 1,this.m_playerTileY);
            this.m_tileFilenames[this.TILE_C] = this.GetTileFilename(this.m_playerTileX,this.m_playerTileY);
            this.m_tileFilenames[this.TILE_E] = this.GetTileFilename(this.m_playerTileX + 1,this.m_playerTileY);
            this.m_tileFilenames[this.TILE_SW] = this.GetTileFilename(this.m_playerTileX - 1,this.m_playerTileY - 1);
            this.m_tileFilenames[this.TILE_S] = this.GetTileFilename(this.m_playerTileX,this.m_playerTileY - 1);
            this.m_tileFilenames[this.TILE_SE] = this.GetTileFilename(this.m_playerTileX + 1,this.m_playerTileY - 1);
            _loc16_ = this.m_tiles;
            this.m_tiles = new Vector.<MinimapLoader>(this.TILE_COUNT);
            _loc14_ = 0;
            while(_loc14_ < this.TILE_COUNT)
            {
               if(this.m_tileVisible[_loc14_])
               {
                  _loc13_ = this.m_tileFilenames[_loc14_];
                  _loc15_ = 0;
                  while(_loc15_ < _loc16_.length)
                  {
                     if((_loc17_ = _loc16_[_loc15_]) && _loc17_.source && _loc17_.source == _loc13_)
                     {
                        this.m_tiles[_loc14_] = _loc17_;
                        this.UpdateTilePosition(_loc14_);
                        _loc16_.splice(_loc15_,1);
                        break;
                     }
                     _loc15_++;
                  }
               }
               _loc14_++;
            }
            _loc14_ = 0;
            while(_loc14_ < this.TILE_COUNT)
            {
               if(!this.m_tiles[_loc14_])
               {
                  if(_loc16_.length != 0)
                  {
                     this.m_tiles[_loc14_] = _loc16_[0];
                     _loc16_.splice(0,1);
                     if(this.m_tileVisible[_loc14_])
                     {
                        this.m_tiles[_loc14_].source = this.m_tileFilenames[_loc14_];
                        this.m_tiles[_loc14_].visible = true;
                        this.UpdateTilePosition(_loc14_);
                     }
                  }
               }
               _loc14_++;
            }
         }
         else
         {
            _loc14_ = 0;
            while(_loc14_ < this.TILE_COUNT)
            {
               _loc13_ = this.m_tileFilenames[_loc14_];
               _loc19_ = (_loc18_ = this.m_tiles[_loc14_]).source;
               if(this.m_tileVisible[_loc14_])
               {
                  if(!_loc19_ || _loc19_ && _loc19_ != _loc13_)
                  {
                     _loc18_.source = _loc13_;
                     _loc18_.visible = true;
                     this.UpdateTilePosition(_loc14_);
                  }
               }
               else if(Boolean(_loc19_) && _loc19_.length > 0)
               {
                  _loc18_.source = "";
               }
               _loc14_++;
            }
         }
      }
      
      private function GetTileFilename(param1:int, param2:int) : String
      {
         if(param1 < 0 || param1 >= HudModuleMinimap2.m_tileCount || param2 < 0 || param2 >= HudModuleMinimap2.m_tileCount)
         {
            return "";
         }
         return "img://minimaps/" + HudModuleMinimap2.m_worldName + "/tile" + param1 + "x" + param2 + "." + HudModuleMinimap2.m_tileExteriorTextureExtension;
      }
      
      public function UpdateTilePosition(param1:int) : *
      {
         if(this.m_tiles[param1])
         {
            this.m_tiles[param1].x = this.m_tileShiftX[param1];
            this.m_tiles[param1].y = this.m_tileShiftY[param1];
         }
      }
      
      public function UpdateTileDebugBorders() : *
      {
         var _loc1_:int = int(this.m_tiles.length);
         var _loc2_:* = 0;
         while(_loc2_ < _loc1_)
         {
            if(this.m_tiles[_loc2_])
            {
               if(HudModuleMinimap2.m_showDebugBorders)
               {
                  this.m_tiles[_loc2_].filters = [new GlowFilter(16711680,1,6,6,2,1,true)];
               }
               else
               {
                  this.m_tiles[_loc2_].filters = [];
               }
            }
            _loc2_++;
         }
      }
   }
}
