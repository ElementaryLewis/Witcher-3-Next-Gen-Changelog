package red.game.witcher3.menus.worldmap
{
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   import red.core.events.GameEvent;
   import red.game.witcher3.data.StaticMapPinData;
   import scaleform.clik.core.UIComponent;
   
   public class HubMapPreview extends UIComponent
   {
       
      
      public var mcHubMapPreviewGeneralMask:MovieClip;
      
      public var mcHubMapPreviewGeneralContainer:MovieClip;
      
      public var mcHubMapPreviewFrame:MovieClip;
      
      private var _mapPinClass:Class;
      
      private var _mapSize:Number;
      
      private var _textureSize:int;
      
      private var _visibilityWorldMinX:int;
      
      private var _visibilityWorldMaxX:int;
      
      private var _visibilityWorldMinY:int;
      
      private var _visibilityWorldMaxY:int;
      
      private var _previewAvailable:Boolean;
      
      private var _previewMode:int;
      
      private var _staticMapPins:Vector.<StaticMapPinPreviewDescribed>;
      
      private const MAP_WIDTH_HEIGHT_RATIO:Number = 1.5;
      
      private const MODE_INVISIBLE:int = 0;
      
      private const MODE_SMALL_MAP:int = 1;
      
      private const MODE_BIG_MAP:int = 2;
      
      private const SMALL_MAP_HEIGHT:int = 150;
      
      private const BIG_MAP_HEIGHT:int = 250;
      
      private const SMALL_MAP_PIN_SCALE:Number = 1;
      
      private const BIG_MAP_PIN_SCALE:Number = 1.6666666666666667;
      
      private var _globalAnchorPos:Point;
      
      private var _worldLeftBottom:Point;
      
      private var _worldRightTop:Point;
      
      private var _lmbDown:Boolean = false;
      
      public function HubMapPreview()
      {
         this._previewMode = this.MODE_SMALL_MAP;
         this._staticMapPins = new Vector.<StaticMapPinPreviewDescribed>();
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this._mapPinClass = getDefinitionByName("StaticMapPinPreviewBase") as Class;
      }
      
      public function setMapSettings(param1:Number, param2:int, param3:String, param4:int, param5:int, param6:int, param7:int, param8:Boolean, param9:int) : *
      {
         this._mapSize = param1;
         this._textureSize = param2;
         this._visibilityWorldMinX = param4;
         this._visibilityWorldMaxX = param5;
         this._visibilityWorldMinY = param6;
         this._visibilityWorldMaxY = param7;
         this._previewAvailable = param8;
         this._previewMode = param9;
         if(this.CanBeToggled())
         {
            this.mcHubMapPreviewGeneralContainer.mcHubMapPreviewZoomContainer.SetMapSettings(param3);
         }
         if(this._previewMode == this.MODE_SMALL_MAP)
         {
            this.rescaleMap(this.SMALL_MAP_HEIGHT);
         }
         else if(this._previewMode == this.MODE_BIG_MAP)
         {
            this.rescaleMap(this.BIG_MAP_HEIGHT);
         }
         this.updatePinsPositionAndScale(this.GetPinScaleByMode(this._previewMode));
      }
      
      private function GetPinScaleByMode(param1:int) : *
      {
         if(param1 == this.MODE_SMALL_MAP)
         {
            return this.SMALL_MAP_PIN_SCALE;
         }
         if(param1 == this.MODE_BIG_MAP)
         {
            return this.BIG_MAP_PIN_SCALE;
         }
         return this.SMALL_MAP_PIN_SCALE;
      }
      
      private function rescaleMap(param1:Number) : *
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         visible = this.CanBeToggled();
         var _loc2_:Number = Math.abs(this.WorldYToMapY(-this._visibilityWorldMinY) - this.WorldYToMapY(-this._visibilityWorldMaxY));
         this.mcHubMapPreviewGeneralContainer.mcHubMapPreviewZoomContainer.scaleX = param1 / _loc2_;
         this.mcHubMapPreviewGeneralContainer.mcHubMapPreviewZoomContainer.scaleY = param1 / _loc2_;
         var _loc3_:Number = this.GetScale();
         _loc4_ = this.WorldXToMapX(this._visibilityWorldMinX) * _loc3_;
         _loc5_ = this.WorldXToMapX(this._visibilityWorldMaxX) * _loc3_;
         var _loc6_:Number = this.WorldYToMapY(-this._visibilityWorldMaxY) * _loc3_;
         var _loc7_:Number = this.WorldYToMapY(-this._visibilityWorldMinY) * _loc3_;
         this.mcHubMapPreviewGeneralContainer.mcHubMapPreviewTextureMask.x = (_loc5_ + _loc4_) / 2;
         this.mcHubMapPreviewGeneralContainer.mcHubMapPreviewTextureMask.y = (_loc7_ + _loc6_) / 2;
         this.mcHubMapPreviewGeneralContainer.mcHubMapPreviewTextureMask.width = Math.abs(_loc5_ - _loc4_);
         this.mcHubMapPreviewGeneralContainer.mcHubMapPreviewTextureMask.height = Math.abs(_loc7_ - _loc6_);
         this.mcHubMapPreviewGeneralContainer.mcHubMapPreviewZoomContainer.mask = this.mcHubMapPreviewGeneralContainer.mcHubMapPreviewTextureMask;
         this.mcHubMapPreviewGeneralMask.x = (_loc5_ + _loc4_) / 2;
         this.mcHubMapPreviewGeneralMask.y = (_loc7_ + _loc6_) / 2;
         this.mcHubMapPreviewGeneralMask.width = param1 * this.MAP_WIDTH_HEIGHT_RATIO;
         this.mcHubMapPreviewGeneralMask.height = Math.abs(_loc7_ - _loc6_);
         this.mcHubMapPreviewGeneralContainer.mask = this.mcHubMapPreviewGeneralMask;
         this.mcHubMapPreviewFrame.x = (_loc5_ + _loc4_) / 2;
         this.mcHubMapPreviewFrame.y = (_loc7_ + _loc6_) / 2;
         this.mcHubMapPreviewFrame.width = param1 * this.MAP_WIDTH_HEIGHT_RATIO + 20;
         this.mcHubMapPreviewFrame.height = Math.abs(_loc7_ - _loc6_) + 20;
         this.mcHubMapPreviewGeneralContainer.mcTopLine.visible = false;
         this.mcHubMapPreviewGeneralContainer.mcBottomLine.visible = false;
         this.mcHubMapPreviewGeneralContainer.mcLeftLine.visible = false;
         this.mcHubMapPreviewGeneralContainer.mcRightLine.visible = false;
      }
      
      public function updateAnchorPosition(param1:Point) : *
      {
         this._globalAnchorPos = param1;
         this.updateMapPosition();
      }
      
      public function updateMapPosition() : *
      {
         var _loc1_:Point = this.mcHubMapPreviewFrame.getBounds(stage).bottomRight;
         x += this._globalAnchorPos.x - _loc1_.x;
         y += this._globalAnchorPos.y - _loc1_.y;
      }
      
      private function GetScale() : Number
      {
         return this.mcHubMapPreviewGeneralContainer.mcHubMapPreviewZoomContainer.actualScaleX;
      }
      
      private function MapXToWorldX(param1:Number) : Number
      {
         var _loc2_:Number = this._textureSize / this._mapSize;
         return param1 / _loc2_;
      }
      
      private function MapYToWorldY(param1:Number) : Number
      {
         var _loc2_:Number = this._textureSize / this._mapSize;
         return -param1 / _loc2_;
      }
      
      private function WorldXToMapX(param1:Number) : Number
      {
         var _loc2_:Number = this._textureSize / this._mapSize;
         return param1 * _loc2_;
      }
      
      private function WorldYToMapY(param1:Number) : Number
      {
         var _loc2_:Number = this._textureSize / this._mapSize;
         return -param1 * _loc2_;
      }
      
      public function updateVisibleFramePosition(param1:Point, param2:Point) : *
      {
         if(param1 == null || param2 == null)
         {
            param1 = this._worldLeftBottom;
            param2 = this._worldRightTop;
         }
         else
         {
            this._worldLeftBottom = param1;
            this._worldRightTop = param2;
         }
         var _loc3_:Number = this.GetScale();
         var _loc4_:Point = new Point(this.WorldXToMapX(param1.x) * _loc3_,this.WorldYToMapY(param1.y) * _loc3_);
         var _loc5_:Point = new Point(this.WorldXToMapX(param2.x) * _loc3_,this.WorldYToMapY(param2.y) * _loc3_);
         var _loc6_:Point = new Point(this.WorldXToMapX(param1.x) * _loc3_,this.WorldYToMapY(param2.y) * _loc3_);
         var _loc7_:Point = new Point(this.WorldXToMapX(param2.x) * _loc3_,this.WorldYToMapY(param1.y) * _loc3_);
         this.mcHubMapPreviewGeneralContainer.mcTopLine.x = (_loc6_.x + _loc5_.x) / 2;
         this.mcHubMapPreviewGeneralContainer.mcTopLine.y = _loc6_.y;
         this.mcHubMapPreviewGeneralContainer.mcTopLine.scaleX = _loc5_.x - _loc6_.x;
         this.mcHubMapPreviewGeneralContainer.mcTopLine.visible = true;
         this.mcHubMapPreviewGeneralContainer.mcBottomLine.x = (_loc4_.x + _loc7_.x) / 2;
         this.mcHubMapPreviewGeneralContainer.mcBottomLine.y = _loc4_.y;
         this.mcHubMapPreviewGeneralContainer.mcBottomLine.scaleX = _loc7_.x - _loc4_.x;
         this.mcHubMapPreviewGeneralContainer.mcBottomLine.visible = true;
         this.mcHubMapPreviewGeneralContainer.mcLeftLine.x = _loc6_.x;
         this.mcHubMapPreviewGeneralContainer.mcLeftLine.y = (_loc6_.y + _loc4_.y) / 2;
         this.mcHubMapPreviewGeneralContainer.mcLeftLine.scaleY = _loc6_.y - _loc4_.y;
         this.mcHubMapPreviewGeneralContainer.mcLeftLine.visible = true;
         this.mcHubMapPreviewGeneralContainer.mcRightLine.x = _loc5_.x;
         this.mcHubMapPreviewGeneralContainer.mcRightLine.y = (_loc5_.y + _loc7_.y) / 2;
         this.mcHubMapPreviewGeneralContainer.mcRightLine.scaleY = _loc5_.y - _loc7_.y;
         this.mcHubMapPreviewGeneralContainer.mcRightLine.visible = true;
      }
      
      public function updateMapPinHighlighting() : *
      {
         var _loc1_:int = 0;
         var _loc2_:StaticMapPinPreviewDescribed = null;
         _loc1_ = 0;
         while(_loc1_ < this._staticMapPins.length)
         {
            _loc2_ = this._staticMapPins[_loc1_] as StaticMapPinPreviewDescribed;
            if(Boolean(_loc2_) && _loc2_.data.isQuest)
            {
               _loc2_.mcHighlight.visible = _loc2_.data.highlighted;
            }
            _loc1_++;
         }
      }
      
      public function CanBeToggled() : Boolean
      {
         return this._previewAvailable;
      }
      
      public function Toggle() : *
      {
         if(this._previewMode == this.MODE_SMALL_MAP)
         {
            this._previewMode = this.MODE_BIG_MAP;
            this.rescaleMap(this.BIG_MAP_HEIGHT);
         }
         else if(this._previewMode == this.MODE_BIG_MAP)
         {
            this._previewMode = this.MODE_SMALL_MAP;
            this.rescaleMap(this.SMALL_MAP_HEIGHT);
         }
         this.updateMapPosition();
         this.updatePinsPositionAndScale(this.GetPinScaleByMode(this._previewMode));
         this.updateVisibleFramePosition(null,null);
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnToggleMinimap",[this._previewMode]));
      }
      
      public function SetLMBDown(param1:Boolean) : *
      {
         this._lmbDown = param1;
      }
      
      public function IsLMBDown() : *
      {
         return this._lmbDown;
      }
      
      public function GetWorldMapHitPoint(param1:Point) : Point
      {
         var _loc2_:Point = this.mcHubMapPreviewGeneralContainer.globalToLocal(param1);
         var _loc3_:Number = this.GetScale();
         return new Point(this.MapXToWorldX(_loc2_.x / _loc3_),this.MapYToWorldY(_loc2_.y / _loc3_));
      }
      
      public function addPin(param1:StaticMapPinData) : *
      {
         var _loc2_:StaticMapPinPreviewDescribed = null;
         if(param1.isPlayer)
         {
            _loc2_ = new this._mapPinClass();
            _loc2_.data = param1;
            _loc2_.gotoAndStop("Player");
            _loc2_.rotation = param1.rotation;
            _loc2_.isPlayer = true;
            _loc2_.mcHighlight.visible = false;
         }
         else if(param1.isQuest)
         {
            _loc2_ = new this._mapPinClass();
            _loc2_.data = param1;
            _loc2_.gotoAndStop("Quest");
            _loc2_.mcHighlight.visible = param1.highlighted;
         }
         else
         {
            if(!param1.isUserPin)
            {
               return;
            }
            _loc2_ = new this._mapPinClass();
            _loc2_.data = param1;
            _loc2_.gotoAndStop(param1.type);
            _loc2_.mcHighlight.visible = false;
         }
         var _loc3_:Number = this.GetScale();
         var _loc4_:Number = this.GetPinScaleByMode(this._previewMode);
         _loc2_.id = param1.id;
         _loc2_.worldX = param1.posX;
         _loc2_.worldY = param1.posY;
         _loc2_.x = this.WorldXToMapX(param1.posX) * _loc3_;
         _loc2_.y = this.WorldYToMapY(param1.posY) * _loc3_;
         var _loc5_:Number = 1;
         if(_loc2_.isPlayer)
         {
            _loc5_ = 0.5;
         }
         _loc2_.scaleX = _loc4_ * _loc5_;
         _loc2_.scaleY = _loc4_ * _loc5_;
         this._staticMapPins[this._staticMapPins.length] = _loc2_;
         this.mcHubMapPreviewGeneralContainer.mcHubMapPreviewPinContainer.addChild(_loc2_);
      }
      
      public function removePin(param1:uint) : *
      {
         var _loc2_:int = int(this._staticMapPins.length - 1);
         while(_loc2_ >= 0)
         {
            if(this._staticMapPins[_loc2_].id == param1)
            {
               this.mcHubMapPreviewGeneralContainer.mcHubMapPreviewPinContainer.removeChild(this._staticMapPins[_loc2_]);
               this._staticMapPins.splice(_loc2_,1);
               return;
            }
            _loc2_--;
         }
      }
      
      public function clearPins() : *
      {
         var _loc1_:int = int(this._staticMapPins.length - 1);
         while(_loc1_ >= 0)
         {
            this.mcHubMapPreviewGeneralContainer.mcHubMapPreviewPinContainer.removeChild(this._staticMapPins[_loc1_]);
            _loc1_--;
         }
         this._staticMapPins.length = 0;
      }
      
      public function updatePinsPositionAndScale(param1:Number) : *
      {
         var _loc4_:Number = NaN;
         var _loc2_:Number = this.GetScale();
         var _loc3_:int = int(this._staticMapPins.length - 1);
         while(_loc3_ >= 0)
         {
            this._staticMapPins[_loc3_].x = this.WorldXToMapX(this._staticMapPins[_loc3_].worldX) * _loc2_;
            this._staticMapPins[_loc3_].y = this.WorldYToMapY(this._staticMapPins[_loc3_].worldY) * _loc2_;
            _loc4_ = 1;
            if(this._staticMapPins[_loc3_].isPlayer)
            {
               _loc4_ = 0.5;
            }
            this._staticMapPins[_loc3_].scaleX = param1 * _loc4_;
            this._staticMapPins[_loc3_].scaleY = param1 * _loc4_;
            _loc3_--;
         }
      }
   }
}
