package red.game.witcher3.menus.worldmap
{
   import flash.display.MovieClip;
   import flash.geom.Point;
   import scaleform.clik.core.UIComponent;
   
   public class HubMapContainer extends UIComponent
   {
       
      
      public var mcLodContainer:LodContainer;
      
      public var mcGradientContainer:MovieClip;
      
      public var mcHubMapContainerLodMask:MovieClip;
      
      public var mcHubMapContainerGradientMask:MovieClip;
      
      private var _visibleAreaGlobalLeftBottom:Point;
      
      private var _visibleAreaGlobalRightTop:Point;
      
      private var _visibleAreaLocalLeftBottom:Point;
      
      private var _visibleAreaLocalRightTop:Point;
      
      private var _mapVisMinX:int;
      
      private var _mapVisMaxX:int;
      
      private var _mapVisMinY:int;
      
      private var _mapVisMaxY:int;
      
      private var _mapScrollMinX:int;
      
      private var _mapScrollMaxX:int;
      
      private var _mapScrollMinY:int;
      
      private var _mapScrollMaxY:int;
      
      private var _gradientScale:Number;
      
      public function HubMapContainer()
      {
         super();
      }
      
      public function GetCurrentLod() : int
      {
         return this.mcLodContainer.GetCurrentLod();
      }
      
      public function GetMapTextureSize() : int
      {
         return this.mcLodContainer.GetCurrentContainer().GetMapTextureSize();
      }
      
      public function SetMapVisibilityBoundaries(param1:int, param2:int, param3:int, param4:int, param5:Number) : *
      {
         this._mapVisMinX = param1;
         this._mapVisMaxX = param2;
         this._mapVisMinY = param3;
         this._mapVisMaxY = param4;
         this._gradientScale = param5;
         this.UpdateGradient();
      }
      
      public function SetMapScrollingBoundaries(param1:int, param2:int, param3:int, param4:int) : *
      {
         this._mapScrollMinX = param1;
         this._mapScrollMaxX = param2;
         this._mapScrollMinY = param3;
         this._mapScrollMaxY = param4;
      }
      
      public function SetMapSettings(param1:int, param2:int, param3:int, param4:String, param5:MovieClip) : *
      {
         this.mcLodContainer.CreateLods(param1,param2,param3,param4,this._mapVisMinX,this._mapVisMaxX,this._mapVisMinY,this._mapVisMaxY);
         this._visibleAreaGlobalLeftBottom = new Point(param5.x - param5.width / 2,param5.y + param5.height / 2);
         this._visibleAreaGlobalRightTop = new Point(param5.x + param5.width / 2,param5.y - param5.height / 2);
      }
      
      public function UpdateGradient() : *
      {
         var _loc1_:int = 1;
         this.mcGradientContainer.mcGradientLeft.x = this._mapVisMinX - _loc1_;
         this.mcGradientContainer.mcGradientRight.x = this._mapVisMaxX + _loc1_;
         this.mcGradientContainer.mcGradientTop.y = -this._mapVisMaxY - _loc1_;
         this.mcGradientContainer.mcGradientBottom.y = -this._mapVisMinY + _loc1_;
         this.mcGradientContainer.mcGradientLeft.scaleX = this._gradientScale;
         this.mcGradientContainer.mcGradientRight.scaleX = this._gradientScale;
         this.mcGradientContainer.mcGradientTop.scaleY = this._gradientScale;
         this.mcGradientContainer.mcGradientBottom.scaleY = this._gradientScale;
         this.mcHubMapContainerLodMask.x = this._mapVisMinX;
         this.mcHubMapContainerLodMask.y = -this._mapVisMaxY;
         this.mcHubMapContainerLodMask.width = Math.abs(this._mapVisMinX - this._mapVisMaxX);
         this.mcHubMapContainerLodMask.height = Math.abs(this._mapVisMinY - this._mapVisMaxY);
         this.mcHubMapContainerGradientMask.x = this.mcHubMapContainerLodMask.x - 1;
         this.mcHubMapContainerGradientMask.y = this.mcHubMapContainerLodMask.y - 1;
         this.mcHubMapContainerGradientMask.width = this.mcHubMapContainerLodMask.width + 2;
         this.mcHubMapContainerGradientMask.height = this.mcHubMapContainerLodMask.height + 2;
      }
      
      public function UpdateVisibileArea() : *
      {
         this._visibleAreaLocalLeftBottom = globalToLocal(this._visibleAreaGlobalLeftBottom);
         this._visibleAreaLocalRightTop = globalToLocal(this._visibleAreaGlobalRightTop);
      }
      
      public function GetVisibleAreaLocalLeftBottomPos() : Point
      {
         return this._visibleAreaLocalLeftBottom;
      }
      
      public function GetVisibleAreaLocalRightTopPos() : Point
      {
         return this._visibleAreaLocalRightTop;
      }
      
      public function UpdateDebugBorders() : *
      {
         this.mcLodContainer.UpdateDebugBorders();
      }
      
      public function scrollMap(param1:Number, param2:Number, param3:Boolean = false) : *
      {
         var _loc5_:Number = NaN;
         var _loc4_:Number = x + param1;
         _loc5_ = y + param2;
         _loc4_ = this.GetRestrictedX(_loc4_);
         _loc5_ = this.GetRestrictedY(_loc5_);
         x = _loc4_;
         y = _loc5_;
         this.ShowTilesFromCurrentLod();
      }
      
      public function setImmediatePosition(param1:Number, param2:Number) : *
      {
         x = this.GetRestrictedX(param1);
         y = this.GetRestrictedY(param2);
      }
      
      private function GetRestrictedX(param1:Number) : Number
      {
         if(param1 > -this._mapScrollMinX)
         {
            return -this._mapScrollMinX;
         }
         if(param1 < -this._mapScrollMaxX)
         {
            return -this._mapScrollMaxX;
         }
         return param1;
      }
      
      private function GetRestrictedY(param1:Number) : Number
      {
         if(param1 > this._mapScrollMaxY)
         {
            return this._mapScrollMaxY;
         }
         if(param1 < this._mapScrollMinY)
         {
            return this._mapScrollMinY;
         }
         return param1;
      }
      
      public function IncreaseLod() : *
      {
         var _loc1_:int = this.mcLodContainer.GetMaxLod();
         var _loc2_:int = this.mcLodContainer.GetCurrentLod();
         if(_loc2_ < _loc1_)
         {
            _loc2_++;
            this.SwitchToLod(_loc2_,true);
         }
      }
      
      public function DecreaseLod() : *
      {
         var _loc1_:int = this.mcLodContainer.GetMinLod();
         var _loc2_:int = this.mcLodContainer.GetCurrentLod();
         if(_loc2_ > _loc1_)
         {
            _loc2_--;
            this.SwitchToLod(_loc2_,true);
         }
      }
      
      public function SwitchToLod(param1:int, param2:Boolean) : *
      {
         var _loc5_:* = undefined;
         var _loc3_:int = this.mcLodContainer.GetMinLod();
         var _loc4_:int = this.mcLodContainer.GetMaxLod();
         this.mcLodContainer.SetCurrentLod(param1,true);
         if(param2)
         {
            _loc5_ = _loc3_;
            while(_loc5_ <= _loc4_)
            {
               if(_loc5_ == param1)
               {
                  this.ShowTiles(_loc5_);
               }
               else
               {
                  this.HideTiles(_loc5_);
               }
               _loc5_++;
            }
         }
      }
      
      public function ShowTilesFromCurrentLod() : *
      {
         this.ShowTiles(this.mcLodContainer.GetCurrentLod());
      }
      
      public function ShowTiles(param1:int) : *
      {
         var _loc2_:ImageContainer = this.mcLodContainer.GetContainer(param1);
         if(_loc2_)
         {
            _loc2_.UpdateTiles(null,this._visibleAreaLocalLeftBottom,this._visibleAreaLocalRightTop);
         }
      }
      
      public function HideTiles(param1:int) : *
      {
         var _loc2_:ImageContainer = this.mcLodContainer.GetContainer(param1);
         if(_loc2_)
         {
            _loc2_.RequestHideTiles();
         }
      }
      
      public function HideAllTiles() : *
      {
         var _loc3_:ImageContainer = null;
         var _loc1_:int = this.mcLodContainer.GetMinLod();
         var _loc2_:int = this.mcLodContainer.GetMaxLod();
         var _loc4_:* = _loc1_;
         while(_loc4_ <= _loc2_)
         {
            _loc3_ = this.mcLodContainer.GetContainer(_loc4_);
            if(_loc3_)
            {
               _loc3_.HideTiles();
            }
            _loc4_++;
         }
      }
      
      public function ProcessHidingTiles(param1:int) : *
      {
         var _loc6_:ImageContainer = null;
         var _loc2_:int = this.mcLodContainer.GetMinLod();
         var _loc3_:int = this.mcLodContainer.GetMaxLod();
         var _loc4_:int = this.mcLodContainer.GetCurrentLod();
         var _loc5_:* = _loc2_;
         while(_loc5_ <= _loc3_)
         {
            if(_loc5_ != _loc4_)
            {
               if(_loc6_ = this.mcLodContainer.GetContainer(_loc5_))
               {
                  _loc6_.ProcessHidingTiles(param1);
               }
            }
            _loc5_++;
         }
      }
   }
}
