package red.game.witcher3.hud.modules
{
   import flash.display.MovieClip;
   import red.core.events.GameEvent;
   import red.game.witcher3.hud.modules.minimap2.DistanceInfo;
   import red.game.witcher3.hud.modules.minimap2.WorldConditionInfo;
   import red.game.witcher3.utils.CommonUtils;
   
   public class HudModuleMinimap2 extends HudModuleBase
   {
      
      public static const HEIGHT_THRESHOLD:Number = 4;
      
      public static const DEFAULT_RADIUS:Number = 33;
      
      public static var m_worldName:String = "";
      
      public static var m_worldSize:Number = 0;
      
      public static var m_tileCount:int = 0;
      
      public static var m_tileSize:Number = 0;
      
      public static var m_tileExteriorTextureSize:Number = 0;
      
      public static var m_tileInteriorTextureSize:Number = 0;
      
      public static var m_tileExteriorTextureExtension:String = "jpg";
      
      public static var m_tileInteriorTextureExtension:String = "png";
      
      public static var m_zoom:Number = 1;
      
      public static var m_radius:Number = DEFAULT_RADIUS / m_zoom;
      
      public static var m_radiusSquared:Number = m_radius * m_radius;
      
      public static var m_isInterior:Boolean = false;
      
      public static var m_isDebug:Boolean = false;
      
      public static var m_showDebugBorders:Boolean = false;
      
      public static var m_playerWorldPosX:Number = 1000000;
      
      public static var m_playerWorldPosY:Number = 1000000;
      
      public static var m_playerWorldPosZ:Number = 1000000;
      
      public static var m_playerTileX:int = -1;
      
      public static var m_playerTileY:int = -1;
      
      public static var m_playerTilePosX:Number;
      
      public static var m_playerTilePosY:Number;
      
      public static var m_playerTexturePosX:Number;
      
      public static var m_playerTexturePosY:Number;
      
      public static var m_cameraAngle:Number = NaN;
      
      public static var m_rotationEnabled:Boolean = false;
      
      private static var m_exteriorCoef:Number;
      
      private static var m_interiorCoef:Number;
       
      
      public var mcCommonMap:CommonMap;
      
      public var mcHubMap:HubMap;
      
      public var mcInteriorMap:InteriorMap;
      
      public var mcCommonMapMask:MovieClip;
      
      public var mcHubMapMask:MovieClip;
      
      public var mcInteriorMapMask:MovieClip;
      
      public var mcPlayerMarker:MovieClip;
      
      public var mcPlayerCamera:MovieClip;
      
      public var mcNorthSign:MovieClip;
      
      public var mcWorldCondition:WorldConditionInfo;
      
      public var mcDistanceQuest:DistanceInfo;
      
      public var mcDistanceUser:DistanceInfo;
      
      public var mcShading:MovieClip;
      
      private var _lastGeneralRotation:Number = NaN;
      
      private var _lastPlayerMarkerRotation:Number = NaN;
      
      private var _lastPlayerCameraRotation:Number = NaN;
      
      public function HudModuleMinimap2()
      {
         super();
         visible = false;
         this.EnableMask(true);
         this.__setProp_mcDistanceQuest_Scene1_DistanceIndicator_0();
         this.__setProp_mcWorldCondition_Scene1_Graphic_TimeofDay_0();
      }
      
      public static function GetCurrCoef() : Number
      {
         return GetCoef(m_isInterior);
      }
      
      public static function GetCoef(param1:Boolean) : Number
      {
         if(param1)
         {
            return m_interiorCoef;
         }
         return m_exteriorCoef;
      }
      
      public static function WorldToMapX(param1:Number) : Number
      {
         return param1 / m_exteriorCoef;
      }
      
      public static function WorldToMapY(param1:Number) : Number
      {
         return -param1 / m_exteriorCoef;
      }
      
      public static function WorldToInteriorMapX(param1:Number) : Number
      {
         return param1 / m_interiorCoef;
      }
      
      public static function WorldToInteriorMapY(param1:Number) : Number
      {
         return -param1 / m_interiorCoef;
      }
      
      public static function GetCameraAngle() : Number
      {
         if(m_rotationEnabled)
         {
            return m_cameraAngle;
         }
         return 0;
      }
      
      override public function get moduleName() : String
      {
         return "Minimap2Module";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         alpha = 0.01;
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         this.mcCommonMapMask.visible = false;
         this.mcHubMapMask.visible = false;
         this.mcInteriorMapMask.visible = false;
         this.mcDistanceQuest.visible = false;
         this.mcDistanceQuest.mcIcon.gotoAndStop("Quest");
         this.mcDistanceUser.visible = false;
         this.mcDistanceUser.mcIcon.gotoAndStop("User1");
         this.mcCommonMap.Initialize(this.mcPlayerMarker);
         this.UpdateVisibility();
         registerDataBinding("hud.minimap.paths.add",this.handleAddPath);
         registerDataBinding("hud.minimap.paths.delete",this.handleDeletePaths);
      }
      
      public function SetMapSettings(param1:String, param2:Number, param3:int, param4:int, param5:int) : *
      {
         m_worldName = param1;
         m_worldSize = param2;
         m_tileCount = param5;
         m_tileSize = m_worldSize / m_tileCount;
         m_tileExteriorTextureSize = param3;
         m_tileInteriorTextureSize = param4;
         m_exteriorCoef = m_tileSize / m_tileExteriorTextureSize;
         m_interiorCoef = m_tileSize / m_tileInteriorTextureSize;
         this.mcHubMap.mcHubMapContainer.InitializeTilePositions();
      }
      
      public function SetTextureExtensions(param1:String, param2:String) : *
      {
         m_tileExteriorTextureExtension = CommonUtils.strTrim(param1);
         m_tileInteriorTextureExtension = CommonUtils.strTrim(param2);
      }
      
      public function SetZoom(param1:Number, param2:Boolean) : *
      {
         m_zoom = param1;
         m_radius = DEFAULT_RADIUS / m_zoom;
         m_radiusSquared = m_radius * m_radius;
         if(param2)
         {
            this.mcCommonMap.SetScale(param1);
            this.mcHubMap.SetScale(param1);
            this.mcInteriorMap.SetScale(param1);
         }
         else
         {
            this.mcCommonMap.SetScale(param1);
            this.mcHubMap.SetScale(param1);
            this.mcInteriorMap.SetScale(param1);
         }
      }
      
      public function SetPlayerRotation(param1:Number, param2:Number) : *
      {
         var _loc3_:* = param1 - m_cameraAngle;
         m_cameraAngle = param1;
         if(m_rotationEnabled)
         {
            if(this._lastGeneralRotation != m_cameraAngle)
            {
               this._lastGeneralRotation = m_cameraAngle;
               this.mcCommonMap.SetRotation(this._lastGeneralRotation);
               this.mcHubMap.rotation = this._lastGeneralRotation;
               this.mcInteriorMap.rotation = this._lastGeneralRotation;
               this.mcNorthSign.rotation = this._lastGeneralRotation;
            }
            if(this._lastPlayerMarkerRotation != -param2 + m_cameraAngle)
            {
               this._lastPlayerMarkerRotation = -param2 + m_cameraAngle;
               this.mcPlayerMarker.rotation = this._lastPlayerMarkerRotation;
            }
            if(this._lastPlayerCameraRotation != 0)
            {
               this._lastPlayerCameraRotation = 0;
               this.mcPlayerCamera.rotation = this._lastPlayerCameraRotation;
            }
            this.mcCommonMap.UpdateMapPinArrowRotations(_loc3_);
         }
         else
         {
            if(this._lastGeneralRotation != 0)
            {
               this._lastGeneralRotation = 0;
               this.mcCommonMap.SetRotation(this._lastGeneralRotation);
               this.mcHubMap.rotation = this._lastGeneralRotation;
               this.mcInteriorMap.rotation = this._lastGeneralRotation;
               this.mcNorthSign.rotation = this._lastGeneralRotation;
            }
            if(this._lastPlayerMarkerRotation != -param2)
            {
               this._lastPlayerMarkerRotation = -param2;
               this.mcPlayerMarker.rotation = this._lastPlayerMarkerRotation;
            }
            if(this._lastPlayerCameraRotation != -m_cameraAngle)
            {
               this._lastPlayerCameraRotation = -m_cameraAngle;
               this.mcPlayerCamera.rotation = this._lastPlayerCameraRotation;
            }
         }
      }
      
      public function SetPlayerPosition(param1:Number, param2:Number, param3:Number, param4:Boolean) : *
      {
         var _loc5_:Number = 0.2 / m_zoom;
         if(Math.abs(m_playerWorldPosX - param1) > _loc5_ || Math.abs(m_playerWorldPosY - param2) > _loc5_)
         {
            m_playerWorldPosX = param1;
            m_playerWorldPosY = param2;
            m_playerWorldPosZ = param3;
            this.UpdatePosition();
            this.mcHubMap.mcHubMapContainer.UpdatePosition(m_radius,m_playerTexturePosX,m_playerTexturePosY);
            this.mcCommonMap.mcCommonMapContainer.UpdatePosition();
            this.mcInteriorMap.mcInteriorMapContainer.UpdatePosition();
         }
         if(param4)
         {
            this.mcCommonMap.UpdateMapPinsAppearance(m_radiusSquared);
         }
      }
      
      public function SetPlayerPositionAndRotation(param1:Number, param2:Number, param3:Number, param4:Boolean, param5:Number, param6:Number) : *
      {
         this.SetPlayerPosition(param1,param2,param3,param4);
         this.SetPlayerRotation(param5,param6);
      }
      
      public function NotifyPlayerEnteredInterior(param1:Number, param2:Number, param3:Number, param4:String) : void
      {
         m_isInterior = true;
         this.mcInteriorMap.mcInteriorMapContainer.NotifyPlayerEnteredInterior(param1,param2,param3,param4);
         this.mcCommonMap.UpdateMapPinsAppearance(m_radiusSquared);
         this.UpdateVisibility();
      }
      
      public function NotifyPlayerExitedInterior() : void
      {
         m_isInterior = false;
         this.mcInteriorMap.mcInteriorMapContainer.NotifyPlayerExitedInterior();
         this.mcCommonMap.UpdateMapPinsAppearance(m_radiusSquared);
         this.UpdateVisibility();
      }
      
      public function DoFading(param1:Boolean, param2:Boolean) : *
      {
         if(param1)
         {
            if(param2)
            {
               this.mcShading.gotoAndPlay("FadedOut");
            }
            else
            {
               this.mcShading.gotoAndPlay("FadingOut");
            }
         }
         else if(param2)
         {
            this.mcShading.gotoAndPlay("FadedIn");
         }
         else
         {
            this.mcShading.gotoAndPlay("FadingIn");
         }
      }
      
      public function EnableRotation(param1:Boolean) : *
      {
         m_rotationEnabled = param1;
      }
      
      public function EnableMask(param1:Boolean) : *
      {
         if(param1)
         {
            this.mcCommonMap.mask = this.mcCommonMapMask;
            this.mcHubMap.mask = this.mcHubMapMask;
            this.mcInteriorMap.mask = this.mcInteriorMapMask;
         }
         else
         {
            this.mcCommonMap.mask = null;
            this.mcHubMap.mask = null;
            this.mcInteriorMap.mask = null;
         }
      }
      
      public function EnableDebug(param1:Boolean) : *
      {
         m_isDebug = param1;
         this.UpdateVisibility();
      }
      
      public function EnableBorders(param1:Boolean) : *
      {
         m_showDebugBorders = param1;
         this.UpdateDebugBorders();
      }
      
      protected function handleAddPath(param1:Object, param2:int) : *
      {
         if(param2 <= 0)
         {
            if(param1)
            {
               this.mcCommonMap.AddPath(param1);
            }
         }
      }
      
      protected function handleDeletePaths(param1:Object, param2:int) : *
      {
         if(param2 <= 0)
         {
            if(param1)
            {
               this.mcCommonMap.DeletePaths(param1 as Array);
            }
         }
      }
      
      public function AddMapPin(param1:int, param2:String, param3:String, param4:Number, param5:Boolean, param6:int, param7:Boolean, param8:Boolean, param9:Boolean) : *
      {
         this.mcCommonMap.AddMapPin(param1,param2,param3,param4,param5,param6,param7,param8,param9);
      }
      
      public function MoveMapPin(param1:int, param2:*, param3:*, param4:Number) : *
      {
         this.mcCommonMap.MoveMapPin(param1,param2,param3,param4);
      }
      
      public function DeleteMapPin(param1:int) : *
      {
         this.mcCommonMap.DeleteMapPin(param1);
      }
      
      public function HighlightMapPin(param1:int, param2:Boolean) : *
      {
         this.mcCommonMap.HighlightMapPin(param1,param2);
      }
      
      public function UpdateDistanceToHighlightedMapPin(param1:Number, param2:Number) : *
      {
         if(this.mcDistanceQuest)
         {
            this.mcDistanceQuest.Update(param1,this.mcCommonMap.GetHighlightedMapPinPosZ(),m_playerWorldPosZ,HEIGHT_THRESHOLD);
         }
         if(this.mcDistanceUser)
         {
            this.mcDistanceUser.Update(param2,m_playerWorldPosZ,m_playerWorldPosZ,HEIGHT_THRESHOLD);
         }
      }
      
      public function AddWaypoint(param1:Number, param2:Number) : *
      {
         this.mcCommonMap.AddWaypoint(WorldToMapX(param1),WorldToMapY(param2));
      }
      
      public function ClearWaypoints(param1:int) : *
      {
         this.mcCommonMap.ClearWaypoints(param1);
      }
      
      public function UpdateVisibility() : *
      {
         if(m_isDebug)
         {
            this.mcHubMap.visible = true;
            this.mcInteriorMap.visible = true;
            this.mcInteriorMap.mcInteriorBackground.visible = false;
         }
         else
         {
            this.mcHubMap.visible = !m_isInterior;
            this.mcInteriorMap.visible = m_isInterior;
            this.mcInteriorMap.mcInteriorBackground.visible = true;
         }
      }
      
      public function UpdateDebugBorders() : *
      {
         this.mcHubMap.mcHubMapContainer.UpdateTileDebugBorders();
      }
      
      public function UpdatePosition() : *
      {
         var _loc1_:Number = m_playerWorldPosX + m_worldSize / 2;
         var _loc2_:Number = m_playerWorldPosY + m_worldSize / 2;
         m_playerTileX = _loc1_ / m_tileSize;
         m_playerTileY = _loc2_ / m_tileSize;
         m_playerTilePosX = m_playerTileX * m_tileSize - _loc1_;
         m_playerTilePosY = m_playerTileY * m_tileSize - _loc2_;
         m_playerTexturePosX = WorldToMapX(m_playerTilePosX);
         m_playerTexturePosY = WorldToMapY(m_playerTilePosY);
      }
      
      internal function __setProp_mcDistanceQuest_Scene1_DistanceIndicator_0() : *
      {
         try
         {
            this.mcDistanceQuest["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcDistanceQuest.enabled = true;
         this.mcDistanceQuest.enableInitCallback = false;
         this.mcDistanceQuest.minimalSize = 10;
         this.mcDistanceQuest.visible = true;
         try
         {
            this.mcDistanceQuest["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcWorldCondition_Scene1_Graphic_TimeofDay_0() : *
      {
         try
         {
            this.mcWorldCondition["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcWorldCondition.enabled = true;
         this.mcWorldCondition.enableInitCallback = false;
         this.mcWorldCondition.minimalSize = 80;
         this.mcWorldCondition.visible = true;
         try
         {
            this.mcWorldCondition["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
