package red.game.witcher3.menus.worldmap
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Exponential;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   import red.core.CoreMenu;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.InputFeedbackButton;
   import red.game.witcher3.data.StaticMapPinData;
   import red.game.witcher3.events.ControllerChangeEvent;
   import red.game.witcher3.events.MapContextEvent;
   import red.game.witcher3.managers.InputFeedbackManager;
   import red.game.witcher3.managers.InputManager;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.events.ButtonEvent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.MouseEventEx;
   
   public class MapMenu extends CoreMenu
   {
      
      public static var m_debugInfo:MapDebugInfo;
      
      public static var m_showDebugBorders:Boolean = false;
      
      private static var m_currGlobalMousePos:Point = new Point();
      
      private static var m_currLocalMousePos:Point = new Point();
      
      private static var m_isUsingGamepad:Boolean = false;
       
      
      private const GOTO_WORLD_HINT_HIDDEN_Y:Number = 946;
      
      private const GOTO_WORLD_HINT_SHOWN_Y:Number = 870;
      
      private const TOOLTIP_POS:Number = 1006;
      
      private const FAST_TRAVEL_ZOOM:Number = 1;
      
      private const DROPDOWN_POS_LEFT:Number = 138;
      
      private const DROPDOWN_POS_RIGHT:Number = 1200;
      
      private const LAYER_UNIVERSE = 0;
      
      private const LAYER_HUB = 1;
      
      private const LAYER_INTERIOR = 2;
      
      public var tfDebugInfo:TextField;
      
      public var mcVisibleArea:MovieClip;
      
      public var mcUniverseMap:UniverseMap;
      
      public var mcHubMap:HubMap;
      
      public var mcInteriorMap:InteriorMap;
      
      public var tooltipAnchor:Sprite;
      
      public var tooltipInstance:TooltipMap;
      
      public var userPinPanel:UserPinPanel;
      
      public var userPinPanelBackground:MovieClip;
      
      public var mcHubMapPinPanel:MovieClip;
      
      public var mcHubMapQuestTracker:MovieClip;
      
      public var mcGotoWorldMap:MovieClip;
      
      public var mapName:MovieClip;
      
      public var objectivesTitleHint:CurrentQuestMapHint;
      
      public var mcWorldMapButton:MovieClip;
      
      private var m_fastTravelPinData:Object;
      
      private var m_trackableMappinTag:uint;
      
      private var m_currentLayer:int = -1;
      
      private var m_currentState:String = "";
      
      private var m_blockNavigation:Boolean;
      
      private var m_loadingState:Boolean;
      
      private var m_action_Zoom:int = -1;
      
      private var m_action_QuestTrack:int = -1;
      
      private var m_action_FastTravel:int = -1;
      
      private var m_action_OpenRegion:int = -1;
      
      private var m_action_PlaceMappin:int = -1;
      
      private var m_action_MappinPanel:int = -1;
      
      private var m_action_NavigateFilters:int = -1;
      
      private var m_action_GotoPlayer:int = -1;
      
      private var m_action_GotoQuest:int = -1;
      
      private var m_action_GotoObjectives:int = -1;
      
      private var m_action_GotoFastTravel:int = -1;
      
      private var m_selectedPinData:StaticMapPinData;
      
      private var m_userPinPanelShown:Boolean;
      
      private var m_invalidateState:String;
      
      private var m_gotoWorldHintShown:Boolean;
      
      private var _pendingMapContext:MapContextEvent;
      
      private var m_isLMBDown:Boolean = false;
      
      private var m_lastLMBPos:Point;
      
      public var mcPointersCanvas:MovieClip;
      
      public var mcMapHitArea:Sprite;
      
      private var _lastVisitedHub:UniverseArea;
      
      public function MapMenu()
      {
         this.m_lastLMBPos = new Point();
         super();
         this.userPinPanel.visible = false;
         this.userPinPanelBackground.visible = false;
         this.mcHubMapPinPanel.visible = false;
         this.mcHubMapQuestTracker.visible = false;
         this.invalidateControlPanels();
         upToCloseEnabled = false;
         this.tfDebugInfo.visible = false;
         m_debugInfo = new MapDebugInfo();
         m_debugInfo.__mapMenu = this;
         this.mcHubMap.showGotoWorldHint = this.showGotoWorldHint;
         this.mcHubMap.showGotoPlayerPin = this.ShowGotoPlayerButton;
         this.mcHubMap.showGotoQuestPin = this.ShowGotoQuestButton;
         this.mcHubMap.enableUserPinPanel = this.enableUserPinPanel;
         this.mcHubMap.funcClearCategoryPanel = this.clearCategoryPanel;
         this.mcHubMap.funcInitializeCategoryPanel = this.initializeCategoryPanel;
         this.mcHubMap.funcUpdateCategoryPanel = this.updateCategoryPanel;
         this.mcHubMap.funcEnableCategoryPanel = this.enableCategoryPanel;
         this.mcHubMap.funcAddPinToCategoryPanel = this.addPinToCategoryPanel;
         this.mcHubMap.funcEnableQuestTracker = this.enableQuestTracker;
         this.mcHubMapPinPanel.funcCenterOnWorldPosition = this.centerOnWorldPosition;
         this.mcHubMapPinPanel.funcShowPinsFromCategory = this.showPinsFromCategory;
         this.mcHubMapPinPanel.funcIsAnimationRunning = this.isAnimationRunning;
         this.userPinPanel.enableUserPinPanel = this.enableUserPinPanel;
         this.userPinPanel.setUserMapPin = this.setUserMapPin;
         this.mcPointersCanvas.mouseChildren = false;
         this.mcPointersCanvas.mouseEnabled = false;
         PinPointersManager.getInstance().init(this.mcPointersCanvas);
      }
      
      public static function GetCurrGlobalMousePos() : Point
      {
         return m_currGlobalMousePos;
      }
      
      public static function GetCurrLocalMousePos() : Point
      {
         return m_currLocalMousePos;
      }
      
      public static function IsUsingGamepad() : Boolean
      {
         return m_isUsingGamepad;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"map.name.set",[this.setMapName]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"map.current.area.id",[this.setCurrentArea]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"map.current.area.name",[this.setCurrentName]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"map.quest.name",[this.setCurrentQuest]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"map.objectives",[this.setCurrentObjectives]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"map.hubs.custom",[this.handleCustomHubs]));
         _inputHandlers.push(this.mcUniverseMap);
         _inputHandlers.push(this.mcHubMap);
         _inputHandlers.push(this.mcInteriorMap);
         stage.addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
         this.mcMapHitArea.doubleClickEnabled = true;
         this.mcMapHitArea.addEventListener(MouseEvent.MOUSE_DOWN,this.OnMouseDown,false,0,true);
         this.mcMapHitArea.addEventListener(MouseEvent.CLICK,this.OnMouseDoubleDown,false,0,true);
         this.mcMapHitArea.addEventListener(MouseEvent.MOUSE_UP,this.OnMouseUp,false,0,true);
         this.mcMapHitArea.addEventListener(MouseEvent.MOUSE_MOVE,this.OnMouseMove,false,0,true);
         this.mcMapHitArea.addEventListener(MouseEvent.MOUSE_WHEEL,this.OnMouseWheel,false,0,true);
         this.userPinPanelBackground.addEventListener(MouseEvent.MOUSE_DOWN,this.OnUserPinBackgroundMouseDown,false,0,true);
         this.userPinPanelBackground.addEventListener(MouseEvent.MOUSE_MOVE,this.OnUserPinBackgroundMouseMove,false,0,true);
         this.userPinPanel.addEventListener(MouseEvent.MOUSE_MOVE,this.OnUserPinBackgroundMouseMove,false,0,true);
         this.mcHubMap.addEventListener(MapContextEvent.CONTEXT_CHANGE,this.handleMapContext,false,0,true);
         this.mcHubMap.addEventListener(Event.CHANGE,this.handleHubMapUpdated,false,0,true);
         this.mcUniverseMap.addEventListener(MapContextEvent.CONTEXT_CHANGE,this.handleMapContext,false,0,true);
         this.initializeKeyboardButtons();
         if(!Extensions.isScaleform)
         {
            this.debugData();
         }
         var _loc1_:TextField = this.mcGotoWorldMap["textField"] as TextField;
         var _loc2_:InputFeedbackButton = this.mcGotoWorldMap["button"] as InputFeedbackButton;
         _loc1_.text = "[[panel_map_title_worldmap]]";
         _loc2_.label = "";
         _loc2_.setDataFromStage(NavigationCode.GAMEPAD_RSTICK_DOWN,-1);
         if(this.m_action_NavigateFilters < 0)
         {
            this.m_action_NavigateFilters = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_DPAD_ALL,-1,"panel_map_navigate_filters");
         }
         this.UpdateLayers(this.LAYER_HUB,true);
         this.updateKeyboardButtons();
      }
      
      override protected function handleShowAnimComplete(param1:GTween) : void
      {
         super.handleShowAnimComplete(param1);
         this.mcHubMap.SetMenuAnimCompleted();
      }
      
      public function setDefaultMapPostion(param1:Number, param2:Number) : void
      {
         this.mcHubMap.setDefaultPosition(param1,param2);
      }
      
      public function isGotoWorldHintFullyVisible() : Boolean
      {
         if(!this.mcGotoWorldMap.visible)
         {
            return false;
         }
         return this.mcGotoWorldMap.y <= this.GOTO_WORLD_HINT_SHOWN_Y;
      }
      
      public function showGotoWorldHint(param1:Boolean) : void
      {
         if(param1 && !this.m_gotoWorldHintShown)
         {
            this.mcGotoWorldMap.visible = true;
            GTweener.removeTweens(this.mcGotoWorldMap);
            GTweener.to(this.mcGotoWorldMap,0.5,{"y":this.GOTO_WORLD_HINT_SHOWN_Y},{"ease":Exponential.easeOut});
            this.m_gotoWorldHintShown = true;
         }
         else if(!param1 && this.m_gotoWorldHintShown)
         {
            GTweener.removeTweens(this.mcGotoWorldMap);
            GTweener.to(this.mcGotoWorldMap,0.5,{"y":this.GOTO_WORLD_HINT_HIDDEN_Y},{
               "ease":Exponential.easeOut,
               "onComplete":this.handleGotoWorldHintHidden
            });
            this.m_gotoWorldHintShown = false;
         }
      }
      
      public function setUserMapPin(param1:int, param2:Boolean) : *
      {
         this.mcHubMap.setUserMapPin(param1,param2);
      }
      
      private function updateKeyboardButtons() : *
      {
         var _loc1_:Boolean = this.IsLayer(this.LAYER_HUB) && !m_isUsingGamepad;
         if(this.IsLayer(this.LAYER_HUB))
         {
            this.mcWorldMapButton.btnWorldMap.label = "[[panel_map_title_worldmap]]";
         }
         else if(this._lastVisitedHub)
         {
            this.mcWorldMapButton.btnWorldMap.label = "[[map_location_" + this._lastVisitedHub.GetWorldName() + "]]";
         }
         this.mcWorldMapButton.btnWorldMap.updateDataFromStage();
         var _loc2_:Number = Number(this.mcWorldMapButton.btnWorldMap.getViewWidth());
         var _loc3_:Number = _loc2_ + 2 * 20;
         var _loc4_:Number = _loc3_ - this.mcWorldMapButton.mcBackground.width;
         this.mcWorldMapButton.btnWorldMap.x = -_loc2_;
         this.mcWorldMapButton.mcBackground.x -= _loc4_;
         this.mcWorldMapButton.mcBackground.width = _loc3_;
      }
      
      private function initializeKeyboardButtons() : *
      {
         this.mcWorldMapButton.btnWorldMap.clickable = true;
         this.mcWorldMapButton.btnWorldMap.setDataFromStage(NavigationCode.GAMEPAD_Y,KeyCode.SPACE);
         this.mcWorldMapButton.btnWorldMap.visible = true;
         this.mcWorldMapButton.btnWorldMap.addEventListener(ButtonEvent.CLICK,this.handleWorldMapButtonClicked,false,0,true);
         this.mcWorldMapButton.btnWorldMap.validateNow();
         this.mcWorldMapButton.btnWorldMap.x = -this.mcWorldMapButton.btnWorldMap.getViewWidth();
      }
      
      public function handleWorldMapButtonClicked(param1:ButtonEvent) : *
      {
         if(this.IsLayer(this.LAYER_HUB))
         {
            if(this.mcHubMap.CanProcessInput())
            {
               this.switchMap();
            }
         }
         else if(this.IsLayer(this.LAYER_UNIVERSE))
         {
            if(this.mcUniverseMap.CanProcessInput())
            {
               this.switchMap(true);
            }
         }
      }
      
      override protected function handleControllerChanged(param1:ControllerChangeEvent) : void
      {
         super.handleControllerChanged(param1);
         m_isUsingGamepad = InputManager.getInstance().isGamepad();
         this.mcUniverseMap.OnControllerChanged(m_isUsingGamepad);
         this.mcHubMap.OnControllerChanged(m_isUsingGamepad);
         this.mcHubMapPinPanel.OnControllerChanged(m_isUsingGamepad);
         this.updateKeyboardButtons();
      }
      
      private function handleGotoWorldHintHidden(param1:GTween) : void
      {
         this.mcGotoWorldMap.visible = false;
      }
      
      public function RemoveUserMapPin(param1:uint) : void
      {
         if(this.IsLayer(this.LAYER_HUB))
         {
            this.mcHubMap.RemoveUserMapPin(param1);
            this.removePinFromCategoryPanel(param1);
         }
      }
      
      public function SetMapZooms(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : *
      {
         this.mcHubMap.SetMapZooms(param1,param2,param3,param4,param5);
      }
      
      public function SetMapVisibilityBoundaries(param1:int, param2:int, param3:int, param4:int, param5:Number) : *
      {
         this.mcHubMap.SetMapVisibilityBoundaries(param1,param2,param3,param4,param5);
      }
      
      public function SetMapScrollingBoundaries(param1:int, param2:int, param3:int, param4:int) : *
      {
         this.mcHubMap.SetMapScrollingBoundaries(param1,param2,param3,param4);
      }
      
      public function SetMapSettings(param1:Number, param2:int, param3:int, param4:int, param5:int, param6:String, param7:Boolean, param8:int) : *
      {
         this.mcHubMap.SetMapSettings(param1,param2,param3,param4,param5,param6,this.mcVisibleArea,param7,param8);
      }
      
      public function ReinitializeMap() : *
      {
         this.mcHubMap.ReinitializeMap();
      }
      
      public function EnableDebugMode(param1:Boolean) : *
      {
         if(this.tfDebugInfo)
         {
            this.tfDebugInfo.visible = param1;
         }
      }
      
      public function EnableUnlimitedZoom(param1:Boolean) : *
      {
         this.mcHubMap.EnableUnlimitedZoom(param1);
      }
      
      public function EnableManualLod(param1:Boolean) : *
      {
         this.mcHubMap.EnableManualLod(param1);
      }
      
      public function ShowBorders(param1:Boolean) : *
      {
         m_showDebugBorders = param1;
         this.mcHubMap.UpdateDebugBorders();
      }
      
      public function ShowToussaint(param1:Boolean) : *
      {
         this.mcUniverseMap.mcUniverseMapContainer.mcToussaint.visible = param1;
         this.mcUniverseMap.mcUniverseMapContainer.mcToussaint.enabled = param1;
         this.mcUniverseMap.mcUniverseMapContainer.mcToussaint_mask.enabled = param1;
      }
      
      public function SetHighlightedMapPin(param1:int) : *
      {
         this.mcHubMap.setHighlightedMapPin(param1);
      }
      
      protected function setCurrentQuest(param1:Object) : void
      {
         this.mcHubMapQuestTracker.setCurrentQuest(param1);
      }
      
      protected function setCurrentObjectives(param1:Object) : *
      {
         this.mcHubMapQuestTracker.setCurrentObjectives(param1 as Array);
      }
      
      protected function setMapName(param1:String) : void
      {
         var _loc2_:TextField = this.mapName["textField"];
         _loc2_.text = param1;
         _loc2_.text = CommonUtils.toUpperCaseSafe(_loc2_.text);
      }
      
      protected function setCurrentArea(param1:int) : void
      {
         this.mcHubMap.setCurrentAreaId(param1);
      }
      
      protected function setCurrentName(param1:String) : void
      {
         this._lastVisitedHub = this.mcUniverseMap.mcUniverseMapContainer.GetHubMapByName(param1);
      }
      
      override public function setMenuState(param1:String) : void
      {
         super.setMenuState(param1);
         removeEventListener(Event.ENTER_FRAME,this.handleStateValidate,false);
         addEventListener(Event.ENTER_FRAME,this.handleStateValidate,false,1,true);
         this.m_invalidateState = param1;
      }
      
      private function handleStateValidate(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.handleStateValidate,false);
         this.applyState(this.m_invalidateState);
      }
      
      private function applyState(param1:String, param2:Boolean = false) : void
      {
         if(param1 != this.m_currentState)
         {
            this.deactivateContext();
            this.m_currentState = param1;
            this.invalidateControlPanels();
            this.m_blockNavigation = false;
            if(param2)
            {
               this.UpdateLayers(this.LAYER_HUB);
            }
            if(this.IsLayer(this.LAYER_HUB))
            {
               if(this.m_action_Zoom < 0)
               {
                  this.m_action_Zoom = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_RSTICK_SCROLL,KeyCode.MOUSE_SCROLL,"panel_button_common_zoom");
               }
               if(this.m_action_PlaceMappin < 0)
               {
                  this.m_action_PlaceMappin = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_X,KeyCode.RIGHT_MOUSE,"panel_map_place_waypoint");
               }
               if(this.m_action_MappinPanel < 0)
               {
                  this.m_action_MappinPanel = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_X,KeyCode.RIGHT_MOUSE,"panel_map_open_waypoint_panel",true);
               }
               this.updateGotoPinButton();
               InputFeedbackManager.updateButtons(this);
            }
            if(this.IsLayer(this.LAYER_UNIVERSE))
            {
               this.mcUniverseMap.updateAreaSelection();
            }
         }
      }
      
      private function handleHubMapUpdated(param1:Event) : void
      {
         this.updateGotoPinButton();
         InputFeedbackManager.updateButtons(this);
      }
      
      public function enableUserPinPanel(param1:Boolean, param2:Point = null) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:int = 0;
         var _loc5_:* = undefined;
         var _loc6_:int = 0;
         if(this.m_userPinPanelShown != param1)
         {
            if(param1)
            {
               if(!this.mcVisibleArea.hitTestPoint(param2.x,param2.y))
               {
                  return;
               }
               this.userPinPanel.btnClose.x = -this.userPinPanel.btnClose.getViewWidth() / 2;
            }
            this.m_userPinPanelShown = param1;
            this.userPinPanel.visible = this.m_userPinPanelShown;
            this.userPinPanel.enabled = this.m_userPinPanelShown;
            this.userPinPanel.focused = this.m_userPinPanelShown ? 1 : 0;
            this.userPinPanelBackground.visible = this.m_userPinPanelShown;
            if(param1)
            {
               _loc3_ = param2.x;
               _loc4_ = param2.y;
               if(_loc3_ - this.userPinPanel.width / 2 < this.mcVisibleArea.x - this.mcVisibleArea.width / 2)
               {
                  _loc3_ = this.mcVisibleArea.x - this.mcVisibleArea.width / 2 + this.userPinPanel.width / 2;
               }
               else if(_loc3_ + this.userPinPanel.width / 2 > this.mcVisibleArea.x + this.mcVisibleArea.width / 2)
               {
                  _loc3_ = this.mcVisibleArea.x + this.mcVisibleArea.width / 2 - this.userPinPanel.width / 2;
               }
               if(m_isUsingGamepad)
               {
                  _loc5_ = _loc3_;
                  _loc6_ = _loc4_ - 30;
               }
               else
               {
                  _loc5_ = _loc3_;
                  _loc6_ = _loc4_;
               }
               this.userPinPanel.x = _loc5_;
               this.userPinPanel.y = _loc6_;
            }
         }
      }
      
      private function invalidateControlPanels() : void
      {
         this.m_blockNavigation = false;
         if(this.m_action_Zoom > 0)
         {
            InputFeedbackManager.removeButton(this,this.m_action_Zoom);
            this.m_action_Zoom = -1;
         }
         if(this.m_action_PlaceMappin > 0)
         {
            InputFeedbackManager.removeButton(this,this.m_action_PlaceMappin);
            this.m_action_PlaceMappin = -1;
         }
         if(this.m_action_MappinPanel > 0)
         {
            InputFeedbackManager.removeButton(this,this.m_action_MappinPanel);
            this.m_action_MappinPanel = -1;
         }
         InputFeedbackManager.updateButtons(this);
         this.deactivateContext();
      }
      
      private function handleMapContext(param1:MapContextEvent) : void
      {
         this._pendingMapContext = param1;
         removeEventListener(Event.ENTER_FRAME,this.pendingMapContextUpdate,false);
         addEventListener(Event.ENTER_FRAME,this.pendingMapContextUpdate,false,0,true);
      }
      
      private function pendingMapContextUpdate(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.pendingMapContextUpdate,false);
         if(this._pendingMapContext)
         {
            if(!this._pendingMapContext.active)
            {
               this.deactivateContext();
            }
            else
            {
               this.activateContext(this._pendingMapContext);
            }
         }
      }
      
      private function deactivateContext() : void
      {
         this.tooltipInstance.HideTooltip();
         this.m_trackableMappinTag = 0;
         this.m_selectedPinData = null;
         this.cleanUpContextButtons();
         this.updateGotoPinButton();
         InputFeedbackManager.updateButtons(this);
      }
      
      private function cleanUpContextButtons() : void
      {
         if(this.m_action_QuestTrack > 0)
         {
            InputFeedbackManager.removeButton(this,this.m_action_QuestTrack);
            this.m_action_QuestTrack = -1;
         }
         if(this.m_action_FastTravel > 0)
         {
            InputFeedbackManager.removeButton(this,this.m_action_FastTravel);
            this.m_action_FastTravel = -1;
         }
         if(this.m_action_OpenRegion > 0)
         {
            InputFeedbackManager.removeButton(this,this.m_action_OpenRegion);
            this.m_action_OpenRegion = -1;
         }
      }
      
      private function activateContext(param1:MapContextEvent) : void
      {
         var event:MapContextEvent = param1;
         try
         {
            this.tooltipInstance.ShowTooltip(event.tooltipData,isArabicAligmentMode);
            this.tooltipInstance.y = this.TOOLTIP_POS - this.tooltipInstance.actualHeight;
            this.m_selectedPinData = event.mapppinData;
            this.cleanUpContextButtons();
            if(Boolean(event.tooltipData) && Boolean(event.tooltipData.openRegion))
            {
               if(this.m_action_OpenRegion < 0)
               {
                  this.m_action_OpenRegion = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_A,KeyCode.E,"panel_button_map_open");
               }
            }
            else if(event.mapppinData.isFastTravel)
            {
               if(this.m_action_FastTravel < 0)
               {
                  this.m_action_FastTravel = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_A,KeyCode.E,"panel_button_map_fasttravel");
               }
            }
            else
            {
               this.m_trackableMappinTag = 0;
               if(this.m_action_QuestTrack > 0)
               {
                  InputFeedbackManager.removeButton(this,this.m_action_QuestTrack);
                  this.m_action_QuestTrack = -1;
               }
            }
            this.updateGotoPinButton();
            InputFeedbackManager.updateButtons(this);
         }
         catch(er:Error)
         {
            updateGotoPinButton();
            InputFeedbackManager.updateButtons(this);
         }
      }
      
      private function updateGotoPinButton() : void
      {
         if(this.IsLayer(this.LAYER_HUB) && !MapMenu.IsUsingGamepad())
         {
            return;
         }
         this.ShowGotoPlayerButton(false);
         this.ShowGotoQuestButton(false);
         if(!this.IsLayer(this.LAYER_HUB))
         {
            return;
         }
         this.mcHubMap.UpdateGotoButton(true);
      }
      
      private function ShowGotoPlayerButton(param1:Boolean) : void
      {
         if(param1 && this.m_action_GotoPlayer < 0)
         {
            this.m_action_GotoPlayer = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_LSTICK_HOLD,KeyCode.TAB,"panel_map_goto_player_pin");
         }
         else if(!param1 && this.m_action_GotoPlayer > 0)
         {
            InputFeedbackManager.removeButton(this,this.m_action_GotoPlayer);
            this.m_action_GotoPlayer = -1;
         }
      }
      
      private function ShowGotoQuestButton(param1:Boolean) : void
      {
         if(param1 && this.m_action_GotoQuest < 0)
         {
            this.m_action_GotoQuest = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_LSTICK_HOLD,KeyCode.TAB,"panel_map_goto_quest_pin");
         }
         else if(!param1 && this.m_action_GotoQuest > 0)
         {
            InputFeedbackManager.removeButton(this,this.m_action_GotoQuest);
            this.m_action_GotoQuest = -1;
         }
      }
      
      private function IsLayer(param1:int) : *
      {
         return this.m_currentLayer == param1;
      }
      
      private function UpdateLayers(param1:int, param2:Boolean = false) : *
      {
         if(param1 < this.LAYER_UNIVERSE || param1 > this.LAYER_INTERIOR)
         {
            throw new Error("Minimap Wrong layer FFS! (" + param1 + ")");
         }
         if(this.m_currentLayer == param1)
         {
            return;
         }
         this.deactivateContext();
         this.m_currentLayer = param1;
         this.mcUniverseMap.Enable(this.m_currentLayer == this.LAYER_UNIVERSE,param2);
         this.mcHubMap.Enable(this.m_currentLayer == this.LAYER_HUB,param2);
         this.mcInteriorMap.Enable(this.m_currentLayer == this.LAYER_INTERIOR,param2);
         PinPointersManager.getInstance().disabled = this.m_currentLayer != this.LAYER_HUB;
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc6_:UIComponent = null;
         if(this.m_userPinPanelShown)
         {
            this.userPinPanel.handleInput(param1);
            param1.handled = true;
            param1.stopImmediatePropagation();
            return;
         }
         if(param1.handled)
         {
            return;
         }
         var _loc2_:InputDetails = param1.details;
         var _loc3_:* = _loc2_.value == InputValue.KEY_DOWN;
         var _loc4_:* = _loc2_.value == InputValue.KEY_UP;
         var _loc5_:Boolean = _loc2_.value == InputValue.KEY_DOWN || _loc2_.value == InputValue.KEY_HOLD;
         if(param1.handled || this.m_blockNavigation)
         {
            return;
         }
         if(this.mcHubMapPinPanel.visible)
         {
            this.mcHubMapPinPanel.handleInput(param1);
         }
         if(this.mcHubMapQuestTracker.visible)
         {
            this.mcHubMapQuestTracker.handleInput(param1);
         }
         switch(_loc2_.code)
         {
            case KeyCode.SPACE:
               if(_loc3_)
               {
                  if(this.IsLayer(this.LAYER_UNIVERSE))
                  {
                     if(this.mcUniverseMap.CanProcessInput())
                     {
                        this.switchMap(true);
                     }
                  }
                  else if(this.IsLayer(this.LAYER_HUB))
                  {
                     if(this.mcHubMap.CanProcessInput())
                     {
                        this.switchMap();
                     }
                  }
               }
               break;
            case KeyCode.E:
            case KeyCode.ENTER:
            case KeyCode.PAD_A_CROSS:
               if(_loc3_)
               {
                  if(this.IsLayer(this.LAYER_UNIVERSE) && _loc3_)
                  {
                     if(this.mcUniverseMap.CanProcessInput())
                     {
                        this.switchMap();
                     }
                  }
                  else if(this.IsLayer(this.LAYER_HUB) && Boolean(this.m_trackableMappinTag))
                  {
                     if(this.mcHubMap.CanProcessInput())
                     {
                        dispatchEvent(new GameEvent(GameEvent.CALL,"OnTrackQuest",[this.m_trackableMappinTag]));
                     }
                  }
               }
               break;
            case KeyCode.PAD_Y_TRIANGLE:
               if(_loc3_)
               {
                  if(this.IsLayer(this.LAYER_UNIVERSE))
                  {
                     if(this.mcUniverseMap.CanProcessInput())
                     {
                        this.switchMap(true);
                     }
                  }
                  else if(this.IsLayer(this.LAYER_HUB))
                  {
                     if(this.mcHubMap.CanProcessInput())
                     {
                        this.switchMap();
                     }
                  }
               }
               break;
            case KeyCode.PAD_RIGHT_STICK_DOWN:
               break;
            case KeyCode.PAD_RIGHT_STICK_UP:
               if(this.IsLayer(this.LAYER_UNIVERSE) && _loc3_)
               {
                  if(this.mcUniverseMap.CanProcessInput())
                  {
                     this.switchMap();
                  }
               }
         }
         for each(_loc6_ in _inputHandlers)
         {
            if(param1.handled)
            {
               param1.stopImmediatePropagation();
               return;
            }
            if(_loc6_.enabled)
            {
               _loc6_.handleInput(param1);
            }
         }
      }
      
      override public function handleDebugInput(param1:InputEvent) : *
      {
         if(param1.handled)
         {
            return;
         }
         if(!this.mcHubMap.CanProcessInput())
         {
            return;
         }
         var _loc2_:InputDetails = param1.details;
         switch(_loc2_.code)
         {
            case KeyCode.NUMPAD_4:
               if(_loc2_.value == InputValue.KEY_UP && this.IsLayer(this.LAYER_HUB))
               {
                  if(this.m_selectedPinData)
                  {
                     dispatchEvent(new GameEvent(GameEvent.CALL,"OnDebugTeleportToHighlightedMappin",[this.m_selectedPinData.posX,this.m_selectedPinData.posY]));
                     param1.handled = true;
                  }
               }
               return;
            default:
               return;
         }
      }
      
      override protected function handleInputNavigate(param1:InputEvent) : void
      {
         if(this.m_loadingState)
         {
            param1.handled = true;
            param1.stopImmediatePropagation();
            return;
         }
         super.handleInputNavigate(param1);
      }
      
      protected function switchMap(param1:Boolean = false) : *
      {
         var _loc2_:Boolean = false;
         if(this.IsLayer(this.LAYER_HUB))
         {
            this.showGotoWorldHint(false);
            this.UpdateLayers(this.LAYER_UNIVERSE);
            this.mcUniverseMap.centerCurrentArea(false);
            this.ForceMouseMove();
            this.mcUniverseMap.updateAreaSelection(true);
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnSwitchToWorldMap"));
            if(this.m_action_Zoom > 0)
            {
               InputFeedbackManager.removeButton(this,this.m_action_Zoom);
               this.m_action_Zoom = -1;
            }
            if(this.m_action_NavigateFilters > 0)
            {
               InputFeedbackManager.removeButton(this,this.m_action_NavigateFilters);
               this.m_action_NavigateFilters = -1;
            }
            if(this.m_action_PlaceMappin > 0)
            {
               InputFeedbackManager.removeButton(this,this.m_action_PlaceMappin);
               this.m_action_PlaceMappin = -1;
            }
            if(this.m_action_MappinPanel > 0)
            {
               InputFeedbackManager.removeButton(this,this.m_action_MappinPanel);
               this.m_action_MappinPanel = -1;
            }
         }
         else
         {
            _loc2_ = false;
            if(param1)
            {
               _loc2_ = this.mcUniverseMap.GoToHubMap(this._lastVisitedHub);
            }
            else
            {
               _loc2_ = this.mcUniverseMap.GoToSelectedHubMap();
            }
            if(_loc2_)
            {
               this.UpdateLayers(this.LAYER_HUB);
               if(this.m_action_Zoom < 0)
               {
                  this.m_action_Zoom = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_RSTICK_SCROLL,1002,"panel_button_common_zoom");
               }
               if(this.m_action_NavigateFilters < 0)
               {
                  this.m_action_NavigateFilters = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_DPAD_ALL,-1,"panel_map_navigate_filters");
               }
               if(this.m_action_PlaceMappin < 0)
               {
                  this.m_action_PlaceMappin = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_X,KeyCode.RIGHT_MOUSE,"panel_map_place_waypoint");
               }
               if(this.m_action_MappinPanel < 0)
               {
                  this.m_action_MappinPanel = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_X,KeyCode.RIGHT_MOUSE,"panel_map_open_waypoint_panel",true);
               }
               InputFeedbackManager.updateButtons(this);
            }
         }
         InputFeedbackManager.updateButtons(this);
         this.updateGotoPinButton();
         this.updateKeyboardButtons();
      }
      
      public function OnMouseDoubleDown(param1:MouseEvent) : *
      {
         if(this.m_blockNavigation)
         {
            return;
         }
         var _loc2_:MouseEventEx = param1 as MouseEventEx;
         if(Boolean(_loc2_) && _loc2_.buttonIdx == MouseEventEx.LEFT_BUTTON)
         {
            if(this.IsLayer(this.LAYER_UNIVERSE))
            {
               if(this.mcUniverseMap.CanProcessInput())
               {
                  this.switchMap();
               }
            }
            else if(this.IsLayer(this.LAYER_HUB))
            {
               if(this.mcHubMap.CanProcessInput())
               {
                  this.mcHubMap.OnMouseDoubleDown(_loc2_.buttonIdx,new Point(param1.stageX,param1.stageY));
               }
            }
         }
      }
      
      public function OnMouseDown(param1:MouseEvent) : *
      {
         this.mcWorldMapButton.btnWorldMap.mouseEnabled = false;
         this.mcWorldMapButton.btnWorldMap.mouseChildren = false;
         this.updateMouseCoords(param1.stageX,param1.stageY,param1.localX,param1.localY);
         if(this.m_blockNavigation)
         {
            return;
         }
         var _loc2_:MouseEventEx = param1 as MouseEventEx;
         if(_loc2_)
         {
            if(_loc2_.buttonIdx == MouseEventEx.LEFT_BUTTON)
            {
               this.m_isLMBDown = true;
               this.m_lastLMBPos.x = param1.stageX;
               this.m_lastLMBPos.y = param1.stageY;
               this.mcHubMapQuestTracker.enableMouse(false);
               this.mcHubMapPinPanel.enableMouse(false);
               this.mcWorldMapButton.mouseEnabled = false;
               this.mcWorldMapButton.mouseChildren = false;
            }
            else if(_loc2_.buttonIdx == MouseEventEx.MIDDLE_BUTTON)
            {
               if(this.IsLayer(this.LAYER_HUB))
               {
                  if(this.mcHubMap.CanProcessInput())
                  {
                     this.switchMap();
                     return;
                  }
               }
               else if(this.IsLayer(this.LAYER_UNIVERSE))
               {
                  if(this.mcUniverseMap.CanProcessInput())
                  {
                     this.switchMap(true);
                     return;
                  }
               }
            }
         }
         if(this.IsLayer(this.LAYER_HUB))
         {
            this.mcHubMap.OnMouseDown(_loc2_.buttonIdx,m_currGlobalMousePos);
         }
      }
      
      public function OnMouseUp(param1:MouseEvent) : *
      {
         this.mcWorldMapButton.btnWorldMap.mouseEnabled = true;
         this.mcWorldMapButton.btnWorldMap.mouseChildren = true;
         this.updateMouseCoords(param1.stageX,param1.stageY,param1.localX,param1.localY);
         if(this.m_blockNavigation)
         {
            return;
         }
         var _loc2_:MouseEventEx = param1 as MouseEventEx;
         if(Boolean(_loc2_) && _loc2_.buttonIdx == MouseEventEx.LEFT_BUTTON)
         {
            this.m_isLMBDown = false;
            this.mcHubMapQuestTracker.enableMouse(true);
            this.mcHubMapPinPanel.enableMouse(true);
            this.mcWorldMapButton.mouseEnabled = true;
            this.mcWorldMapButton.mouseChildren = true;
         }
         if(this.IsLayer(this.LAYER_HUB))
         {
            this.mcHubMap.OnMouseUp(_loc2_.buttonIdx,m_currGlobalMousePos);
         }
      }
      
      public function OnMouseMove(param1:MouseEvent) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this.updateMouseCoords(param1.stageX,param1.stageY,param1.localX,param1.localY);
         if(this.IsLayer(this.LAYER_UNIVERSE))
         {
            this.mcUniverseMap.OnMouseMove(m_currGlobalMousePos);
         }
         else if(this.IsLayer(this.LAYER_HUB))
         {
            this.mcHubMap.OnMouseMove(m_currGlobalMousePos);
            if(this.mcHubMapPinPanel.visible)
            {
               this.mcHubMapPinPanel.OnMouseMoveFromParent(m_currGlobalMousePos);
               this.mcHubMapQuestTracker.OnMouseMoveFromParent(m_currGlobalMousePos);
            }
         }
         if(this.m_blockNavigation)
         {
            return;
         }
         if(this.m_isLMBDown)
         {
            _loc2_ = param1.stageX - this.m_lastLMBPos.x;
            _loc3_ = param1.stageY - this.m_lastLMBPos.y;
            this.m_lastLMBPos.x = param1.stageX;
            this.m_lastLMBPos.y = param1.stageY;
            if(this.IsLayer(this.LAYER_UNIVERSE))
            {
               if(this.mcUniverseMap.CanProcessInput())
               {
                  this.mcUniverseMap.ScrollMap(_loc2_,_loc3_);
               }
            }
            else if(this.IsLayer(this.LAYER_HUB))
            {
               if(this.mcHubMap.CanProcessInput())
               {
                  this.mcHubMap.scrollMap(_loc2_,_loc3_);
               }
            }
         }
      }
      
      public function OnMouseWheel(param1:MouseEvent) : *
      {
         if(this.m_blockNavigation)
         {
            return;
         }
         if(!this.IsLayer(this.LAYER_UNIVERSE))
         {
            if(this.IsLayer(this.LAYER_HUB))
            {
               if(this.mcHubMap.CanProcessInput())
               {
                  this.mcHubMap.zoomMap(param1.delta > 0);
               }
            }
         }
      }
      
      public function OnUserPinBackgroundMouseDown(param1:MouseEvent) : *
      {
         this.enableUserPinPanel(false);
      }
      
      public function OnUserPinBackgroundMouseMove(param1:MouseEvent) : *
      {
         this.updateMouseCoords(param1.stageX,param1.stageY,param1.localX,param1.localY);
      }
      
      private function updateMouseCoords(param1:Number, param2:Number, param3:Number, param4:Number) : *
      {
         m_currGlobalMousePos.x = param1;
         m_currGlobalMousePos.y = param2;
         m_currLocalMousePos.x = param3;
         m_currLocalMousePos.y = param4;
      }
      
      private function ForceMouseMove() : *
      {
         if(!m_isUsingGamepad)
         {
            this.mcUniverseMap.OnMouseMove(m_currGlobalMousePos);
         }
      }
      
      public function CloseMenu() : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnCloseMenu"));
      }
      
      override protected function get menuName() : String
      {
         return "MapMenu";
      }
      
      public function clearCategoryPanel() : *
      {
         this.mcHubMapPinPanel.clearCategoryPanel();
      }
      
      public function initializeCategoryPanel() : *
      {
         this.mcHubMapPinPanel.initializeCategoryPanel();
         dispatchEvent(new GameEvent(GameEvent.CALL,"SetInitialFilters"));
      }
      
      public function updateCategoryPanel() : *
      {
         this.mcHubMapPinPanel.updateCategoryPanel();
      }
      
      public function enableCategoryPanel(param1:Boolean) : *
      {
         this.mcHubMapPinPanel.visible = param1;
      }
      
      public function enableQuestTracker(param1:Boolean) : *
      {
         if(param1)
         {
            if(!this.mcHubMapQuestTracker.canBeShown())
            {
               return;
            }
         }
         this.mcHubMapQuestTracker.visible = param1;
      }
      
      public function addPinToCategoryPanel(param1:StaticMapPinData) : *
      {
         this.mcHubMapPinPanel.addPinInstance(param1);
      }
      
      public function removePinFromCategoryPanel(param1:uint) : *
      {
         this.mcHubMapPinPanel.removePinInstance(param1);
         this.updateCategoryPanel();
      }
      
      public function centerOnWorldPosition(param1:Point, param2:Boolean = false) : *
      {
         this.mcHubMap.centerOnWorldPosition(param1,param2);
      }
      
      public function showPinsFromCategory(param1:Array, param2:Boolean, param3:Boolean, param4:Boolean, param5:Dictionary, param6:Boolean) : *
      {
         this.mcHubMap.showPinsFromCategory(param1,param2,param3,param4,param5,param6);
      }
      
      public function isAnimationRunning() : Boolean
      {
         return this.mcHubMap.isAnimationRunning();
      }
      
      protected function debugData() : void
      {
      }
      
      public function __UpdateDebugInfo() : *
      {
         var _loc1_:* = null;
         var _loc2_:Vector.<ZoomBoundary> = null;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(this.tfDebugInfo)
         {
            _loc1_ = "Current LOD: " + m_debugInfo._currentLod + " (" + m_debugInfo._minLod + ", " + m_debugInfo._maxLod + ")" + "<BR>Zoom: " + m_debugInfo._zoom.toFixed(2) + "<BR>Visible tiles: " + m_debugInfo._visibleTiles + "<BR>Scroll posX: " + m_debugInfo._scrollX.toFixed(2) + "<BR>Scroll posY: " + m_debugInfo._scrollY.toFixed(2) + "<BR>Center: " + m_debugInfo._pointedTileX + " " + m_debugInfo._pointedTileY + "<BR>Min tile: " + m_debugInfo._pointedMinTileX + " " + m_debugInfo._pointedMinTileY + "<BR>Max tile: " + m_debugInfo._pointedMaxTileX + " " + m_debugInfo._pointedMaxTileY + "<BR>";
            _loc2_ = this.mcHubMap.GetZoomBoundaries();
            if(_loc2_)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc2_.length)
               {
                  if(_loc2_[_loc4_].IsValid())
                  {
                     _loc1_ += "<BR>LOD" + (_loc4_ + 1) + " - (" + _loc2_[_loc4_]._min.toFixed(2) + ", " + _loc2_[_loc4_]._max.toFixed(2) + ")";
                  }
                  _loc4_++;
               }
            }
            _loc1_ += "<BR>";
            _loc3_ = m_debugInfo._minLod;
            while(_loc3_ <= m_debugInfo._maxLod)
            {
               if(_loc3_ == 1)
               {
                  _loc1_ += _loc3_ + ": " + m_debugInfo._lod1Visible + " " + m_debugInfo._lod1Invisible + "<BR>";
               }
               if(_loc3_ == 2)
               {
                  _loc1_ += _loc3_ + ": " + m_debugInfo._lod2Visible + " " + m_debugInfo._lod2Invisible + "<BR>";
               }
               if(_loc3_ == 3)
               {
                  _loc1_ += _loc3_ + ": " + m_debugInfo._lod3Visible + " " + m_debugInfo._lod3Invisible + "<BR>";
               }
               if(_loc3_ == 4)
               {
                  _loc1_ += _loc3_ + ": " + m_debugInfo._lod4Visible + " " + m_debugInfo._lod4Invisible + "<BR>";
               }
               _loc3_++;
            }
            this.tfDebugInfo.htmlText = _loc1_;
         }
      }
      
      protected function handleCustomHubs(param1:Object) : *
      {
         this.mcUniverseMap.mcUniverseMapContainer.addCustomHubs(param1 as Array);
      }
   }
}

import red.game.witcher3.menus.worldmap.MapMenu;

class MapDebugInfo
{
    
   
   public var __mapMenu:MapMenu;
   
   public var _currentLod:int = -1;
   
   public var _minLod:int = -1;
   
   public var _maxLod:int = -1;
   
   public var _zoom:Number;
   
   public var _visibleTiles:int = 0;
   
   public var _scrollX:Number;
   
   public var _scrollY:Number;
   
   public var _pointedTileX:int = -1;
   
   public var _pointedTileY:int = -1;
   
   public var _pointedMinTileX:int = -1;
   
   public var _pointedMinTileY:int = -1;
   
   public var _pointedMaxTileX:int = -1;
   
   public var _pointedMaxTileY:int = -1;
   
   public var _lod1Visible:int = 0;
   
   public var _lod1Invisible:int = 0;
   
   public var _lod2Visible:int = 0;
   
   public var _lod2Invisible:int = 0;
   
   public var _lod3Visible:int = 0;
   
   public var _lod3Invisible:int = 0;
   
   public var _lod4Visible:int = 0;
   
   public var _lod4Invisible:int = 0;
   
   public function MapDebugInfo()
   {
      super();
   }
   
   public function __DebugInfo_SetCurrentLod(param1:int) : *
   {
      this._currentLod = param1;
      this.__mapMenu.__UpdateDebugInfo();
   }
   
   public function __DebugInfo_SetMinMaxLod(param1:int, param2:int) : *
   {
      this._minLod = param1;
      this._maxLod = param2;
      this.__mapMenu.__UpdateDebugInfo();
   }
   
   public function __DebugInfo_SetZoom(param1:Number) : *
   {
      this._zoom = param1;
      this.__mapMenu.__UpdateDebugInfo();
   }
   
   public function __DebugInfo_SetScroll(param1:Number, param2:Number) : *
   {
      this._scrollX = -param1;
      this._scrollY = -param2;
      this.__mapMenu.__UpdateDebugInfo();
   }
   
   public function __DebugInfo_SetPointedTile(param1:int, param2:int) : *
   {
      this._pointedTileX = param1;
      this._pointedTileY = param2;
      this.__mapMenu.__UpdateDebugInfo();
   }
   
   public function __DebugInfo_SetVisibleAndPointedTiles(param1:int, param2:int, param3:int, param4:int, param5:int) : *
   {
      this._visibleTiles = param1;
      this._pointedMinTileX = param2;
      this._pointedMinTileY = param3;
      this._pointedMaxTileX = param4;
      this._pointedMaxTileY = param5;
      this.__mapMenu.__UpdateDebugInfo();
   }
   
   public function __DebugInfo_SetTileStats(param1:int, param2:int, param3:int) : *
   {
      if(param1 == 1)
      {
         this._lod1Visible = param2;
         this._lod1Invisible = param3;
      }
      else if(param1 == 2)
      {
         this._lod2Visible = param2;
         this._lod2Invisible = param3;
      }
      else if(param1 == 3)
      {
         this._lod3Visible = param2;
         this._lod3Invisible = param3;
      }
      else if(param1 == 4)
      {
         this._lod4Visible = param2;
         this._lod4Invisible = param3;
      }
   }
}
