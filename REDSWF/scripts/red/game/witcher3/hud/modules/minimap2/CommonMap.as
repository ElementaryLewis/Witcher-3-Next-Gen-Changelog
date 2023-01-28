package red.game.witcher3.hud.modules.minimap2
{
   import flash.display.MovieClip;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import red.game.witcher3.hud.modules.HudModuleMinimap2;
   
   public class CommonMap extends BaseMap
   {
      
      private static const PIN_LOWEST_PRIORITY = 0;
      
      private static const PIN_NORMAL_PRIORITY = 1;
      
      private static const PIN_HIGHEST_PRIORITY = 2;
      
      private static const WAYPOINT_PRIORITY = PIN_LOWEST_PRIORITY;
       
      
      public var mcCommonMapContainer:CommonMapContainer;
      
      private var _centerMovieClip:MovieClip;
      
      private var _highlightedMapPin:MapPin;
      
      private var _mapPins:Dictionary;
      
      private var _mapPaths:Dictionary;
      
      private var _waypoints:Vector.<Waypoint>;
      
      private var _realWaypointsCount:int = 0;
      
      private var _mapPinPool:Vector.<MapPin>;
      
      private var refWaypoint:Class;
      
      private var refPin:Class;
      
      private var refArr:Class;
      
      public function CommonMap()
      {
         this._mapPins = new Dictionary();
         this._mapPaths = new Dictionary();
         this._waypoints = new Vector.<Waypoint>();
         this._mapPinPool = new Vector.<MapPin>();
         super();
      }
      
      public function Initialize(param1:MovieClip) : *
      {
         this.refWaypoint = getDefinitionByName("WaypointInstance") as Class;
         this.refPin = getDefinitionByName("MapPinInstance") as Class;
         this.refArr = getDefinitionByName("QuestDirectionCurrentMain") as Class;
         this._centerMovieClip = param1;
         this.AddMapPinsToPool(50);
      }
      
      private function AddMapPinsToPool(param1:int) : *
      {
         var _loc2_:MapPin = null;
         var _loc3_:* = 0;
         while(_loc3_ < param1)
         {
            _loc2_ = new MapPin();
            _loc2_.pinClip = new this.refPin();
            _loc2_.arrowClip = new this.refArr();
            _loc2_.arrowClip.x = this._centerMovieClip.x;
            _loc2_.arrowClip.y = this._centerMovieClip.y;
            _loc2_.arrowClip.rotationZ = -90;
            this._mapPinPool.push(_loc2_);
            _loc3_++;
         }
      }
      
      private function GetMapPinFromPool() : MapPin
      {
         if(this._mapPinPool.length == 0)
         {
            this.AddMapPinsToPool(1);
         }
         return this._mapPinPool.pop();
      }
      
      private function PutMapPinToPool(param1:MapPin) : *
      {
         return this._mapPinPool.push(param1);
      }
      
      override public function SetRotation(param1:Number) : *
      {
         rotation = param1;
         this.UpdateMapPinsRotation();
      }
      
      override public function SetScale(param1:Number) : *
      {
         var _loc2_:Number = HudModuleMinimap2.GetCoef(false);
         var _loc3_:* = ZOOM_COEF * _loc2_ * param1;
         scaleX = _loc3_;
         scaleY = _loc3_;
         this.UpdateMapPinsScale();
      }
      
      public function GetMapPinRotation() : Number
      {
         return -rotation;
      }
      
      public function GetMapPinScale() : Number
      {
         return 1 / actualScaleX;
      }
      
      public function GetAreaMapPinScale() : Number
      {
         return actualScaleX;
      }
      
      public function UpdateMapPinsAppearance(param1:Number) : *
      {
         var _loc2_:MapPin = null;
         for each(_loc2_ in this._mapPins)
         {
            _loc2_.UpdateMapPinAppearance(param1);
         }
      }
      
      public function UpdateMapPinsRotation() : *
      {
         var _loc2_:MapPin = null;
         var _loc1_:Number = this.GetMapPinRotation();
         for each(_loc2_ in this._mapPins)
         {
            _loc2_.SetPinRotation(_loc1_);
         }
      }
      
      public function UpdateMapPinsScale() : *
      {
         var _loc2_:MapPin = null;
         var _loc3_:* = undefined;
         var _loc4_:Waypoint = null;
         var _loc5_:int = 0;
         var _loc1_:Number = this.GetMapPinScale();
         for each(_loc2_ in this._mapPins)
         {
            _loc2_.SetIconScale(_loc1_);
         }
         _loc3_ = this._waypoints.length;
         _loc5_ = 0;
         while(_loc5_ < _loc3_)
         {
            (_loc4_ = this._waypoints[_loc5_] as Waypoint).SetScale(_loc1_);
            _loc5_++;
         }
      }
      
      public function UpdateMapPinArrowRotations(param1:Number) : *
      {
         var _loc2_:MapPin = null;
         for each(_loc2_ in this._mapPins)
         {
            _loc2_.UpdateMapPinArrowRotation(param1);
         }
      }
      
      public function AddWaypoint(param1:Number, param2:Number) : *
      {
         var _loc3_:Waypoint = null;
         if(this._realWaypointsCount < this._waypoints.length)
         {
            _loc3_ = this._waypoints[this._realWaypointsCount];
         }
         else
         {
            _loc3_ = new Waypoint();
            _loc3_.pinClip = new this.refWaypoint();
            _loc3_.SetScale(this.GetMapPinScale());
            _loc3_.ForceShow(true);
            this.mcCommonMapContainer.addChildPin(WAYPOINT_PRIORITY,_loc3_.pinClip);
            this._waypoints.push(_loc3_);
         }
         ++this._realWaypointsCount;
         _loc3_.Show(true);
         _loc3_.SetPosition(param1,param2);
      }
      
      public function ClearWaypoints(param1:int) : *
      {
         var _loc2_:Waypoint = null;
         var _loc3_:int = int(this._waypoints.length);
         var _loc4_:int = param1;
         while(_loc4_ < _loc3_)
         {
            this._waypoints[_loc4_].Show(false);
            _loc4_++;
         }
         this._realWaypointsCount = 0;
      }
      
      public function AddMapPin(param1:int, param2:String, param3:String, param4:Number, param5:Boolean, param6:int, param7:Boolean, param8:Boolean, param9:Boolean) : *
      {
         var _loc10_:MapPin = null;
         if(_loc10_ = this._mapPins[param1])
         {
            return;
         }
         (_loc10_ = this.GetMapPinFromPool()).OnInitialize(param3);
         _loc10_.id = param1;
         _loc10_.tag = param2;
         _loc10_.type = param3;
         _loc10_.radius = param4;
         _loc10_.highlighted = param9;
         _loc10_.canBePointedByArrow = param5;
         _loc10_.canHeightArrowsBeShown = param4 == 0 && !param8;
         _loc10_.priority = param6;
         _loc10_.isQuestPin = param7;
         _loc10_.isUserPin = param8;
         this.mcCommonMapContainer.addChildPin(_loc10_.priority,_loc10_.pinClip);
         parent.addChild(_loc10_.arrowClip);
         _loc10_.SetPinRotation(this.GetMapPinRotation());
         _loc10_.SetIconScale(this.GetMapPinScale());
         _loc10_.SetRadiusScale(param4,1 / HudModuleMinimap2.GetCoef(false));
         _loc10_.ShowPin(true);
         _loc10_.ShowPinIcon(!_loc10_.isQuestPin || _loc10_.radius == 0);
         _loc10_.ShowPinRadius(_loc10_.radius != 0);
         _loc10_.ShowArrow(false);
         _loc10_.ForceShowHeightArrows(false,false,true);
         _loc10_.ShowNewFeedback(param3 == "Enemy" || param3 == "EnemyDead");
         _loc10_.UpdatePinRadiusColor();
         _loc10_.UpdateHeightArrowsForQuestPins();
         this.HighlightMapPinInstance(_loc10_,param9);
         this._mapPins[param1] = _loc10_;
      }
      
      public function MoveMapPin(param1:int, param2:*, param3:*, param4:Number) : *
      {
         var _loc5_:MapPin = null;
         if(!(_loc5_ = this._mapPins[param1]))
         {
            return;
         }
         var _loc6_:* = _loc5_.posZ != param4;
         if(_loc5_.posX != param2 || _loc5_.posY != param3 || _loc6_)
         {
            _loc5_.posX = param2;
            _loc5_.posY = param3;
            _loc5_.posZ = param4;
            _loc5_.UpdateMapPinPosition(HudModuleMinimap2.WorldToMapX(_loc5_.posX),HudModuleMinimap2.WorldToMapY(_loc5_.posY));
            _loc5_.UpdateMapPinAppearance(HudModuleMinimap2.m_radiusSquared,_loc6_);
         }
      }
      
      public function DeleteMapPin(param1:int) : *
      {
         var _loc2_:MapPin = null;
         _loc2_ = this._mapPins[param1];
         if(!_loc2_)
         {
            return;
         }
         this.mcCommonMapContainer.removeChildPin(_loc2_.priority,_loc2_.pinClip);
         parent.removeChild(_loc2_.arrowClip);
         _loc2_.ShowPin(false);
         _loc2_.ShowArrow(false);
         _loc2_.OnDeinitialize();
         this.PutMapPinToPool(_loc2_);
         if(this._highlightedMapPin == _loc2_)
         {
            this._highlightedMapPin = null;
         }
         this._mapPins[param1] = null;
         delete this._mapPins[param1];
      }
      
      public function DeleteMapPins(param1:Array) : *
      {
         var _loc2_:int = int(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this.DeleteMapPin(param1[_loc3_].id);
            _loc3_++;
         }
      }
      
      public function HighlightMapPin(param1:int, param2:Boolean) : *
      {
         var _loc3_:MapPin = null;
         _loc3_ = this._mapPins[param1];
         if(!_loc3_)
         {
            return;
         }
         this.HighlightMapPinInstance(_loc3_,param2);
      }
      
      public function HighlightMapPinInstance(param1:MapPin, param2:Boolean) : *
      {
         param1.highlighted = param2;
         if(param2)
         {
            this._highlightedMapPin = param1;
         }
         else if(this._highlightedMapPin == param1)
         {
            this._highlightedMapPin = null;
         }
         if(param2)
         {
            parent.addChild(param1.arrowClip);
         }
         param1.UpdateHighlighting();
      }
      
      public function GetHighlightedMapPinPosZ() : Number
      {
         if(this._highlightedMapPin)
         {
            return this._highlightedMapPin.posZ;
         }
         return 0;
      }
      
      public function AddPath(param1:Object) : *
      {
         var _loc3_:MapPath = null;
         var _loc5_:int = 0;
         var _loc6_:* = undefined;
         var _loc2_:int = int(param1.id);
         _loc3_ = this._mapPaths[_loc2_];
         if(_loc3_)
         {
            return;
         }
         _loc3_ = new MapPath();
         _loc3_.x = 0;
         _loc3_.y = 0;
         _loc3_.visible = true;
         var _loc4_:Array;
         if(_loc4_ = param1.splinePoints)
         {
            _loc5_ = int(_loc4_.length);
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc3_.AddSplinePoint(_loc4_[_loc6_].x,_loc4_[_loc6_].y);
               _loc6_++;
            }
         }
         _loc3_.SetupCurve(param1.x,param1.y,param1.color,param1.lineWidth);
         this.mcCommonMapContainer.addChildPin(PIN_LOWEST_PRIORITY,_loc3_);
         this._mapPaths[_loc2_] = _loc3_;
      }
      
      public function DeletePaths(param1:Array) : *
      {
         var _loc2_:int = 0;
         var _loc3_:MapPath = null;
         var _loc4_:int = int(param1.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_ = int(param1[_loc5_].id);
            _loc3_ = this._mapPaths[_loc2_];
            if(_loc3_)
            {
               this.mcCommonMapContainer.removeChildPin(PIN_LOWEST_PRIORITY,_loc3_);
               delete this._mapPaths[_loc2_];
            }
            _loc5_++;
         }
      }
   }
}
