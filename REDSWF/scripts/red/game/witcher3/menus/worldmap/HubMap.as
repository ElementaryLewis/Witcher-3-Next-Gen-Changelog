package red.game.witcher3.menus.worldmap
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Sine;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   import flash.utils.getTimer;
   import red.core.constants.KeyCode;
   import red.core.data.InputAxisData;
   import red.core.events.GameEvent;
   import red.core.utils.InputUtils;
   import red.game.witcher3.data.StaticMapPinData;
   import red.game.witcher3.events.MapContextEvent;
   import red.game.witcher3.managers.InputFeedbackManager;
   import red.game.witcher3.menus.worldmap.data.CategoryPinData;
   import red.game.witcher3.utils.Math2;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.interfaces.IListItemRenderer;
   import scaleform.clik.ui.InputDetails;
   import scaleform.gfx.MouseEventEx;
   
   public class HubMap extends BaseMap
   {
      
      private static const FORSAGE_FACTOR:Number = 1;
      
      private static const FORSAGE_TRIGGERING_LIMIT:Number = 0.9;
      
      private static const SCROLL_SNAP_SPEED = 26;
      
      private static const SCROLL_COEF_MAX = 20;
      
      private static const SCROLL_COEF_MIN = 15;
      
      private static const SCROLL_COEF_ACCELERATION:Number = 1;
      
      private static const ACCELERATION_INTERVAL:Number = 150;
      
      private static const SNAP_DISTANCE:Number = 15;
      
      private static const SNAP_DISTANCE_SQUARED:Number = SNAP_DISTANCE * SNAP_DISTANCE;
      
      private static const SNAP_FREE_LIMIT:Number = 16;
      
      private static const INITIAL_INTERVAL = 20;
      
      private static const SHOW_INTERVAL = 200;
      
      private static const UPDATE_HUB_TEXTURES_INTERVAL = 1000;
      
      private static const FADING_GRADIENT_DURATION = 0.33;
      
      private static const FADING_TEXTURES_DURATION = 0.66;
      
      private static const MAX_PROCESSED_PIN_COUNT = 30;
      
      private static const POINT_0_0:Point = new Point(0,0);
      
      private static const KEYBOARD_SCROLL_SPEED:int = 20;
       
      
      public var mcHubMapCrosshair:MapCrosshair;
      
      public var mcHubMapPinContainer:HubMapPinContainer;
      
      public var mcHubMapZoomContainer:HubMapZoomContainer;
      
      public var mcHubMapPreview:HubMapPreview;
      
      public var mcHubMapPreviewAnchor:MovieClip;
      
      private const USER_MAP_PIN_PANEL_DELAY:int = 300;
      
      internal var _prevTimeOfPressedX:int = 0;
      
      private var _stagePositionForUserPin:Point;
      
      private var _userPinTimer:Timer;
      
      private var _accelerationTimer:Timer;
      
      private var _bufPosX:Number = 0;
      
      private var _bufPosY:Number = 0;
      
      private var _snapTween1:GTween;
      
      private var _snapTween2:GTween;
      
      public var showGotoWorldHint:Function;
      
      public var showGotoPlayerPin:Function;
      
      public var showGotoQuestPin:Function;
      
      public var enableUserPinPanel:Function;
      
      public var funcClearCategoryPanel:Function;
      
      public var funcInitializeCategoryPanel:Function;
      
      public var funcUpdateCategoryPanel:Function;
      
      public var funcEnableCategoryPanel:Function;
      
      public var funcAddPinToCategoryPanel:Function;
      
      public var funcEnableQuestTracker:Function;
      
      private var _mapPinClass:Class;
      
      private var _staticMapPins:Vector.<StaticMapPinDescribed>;
      
      private var _selectedMapPinIndex:int = -1;
      
      private var _playerPinIdx:int = -1;
      
      private var _questMapPinIndices:Vector.<int>;
      
      private var _lonelyFastTravelPinIdx:int = -1;
      
      private var _fastTravelPinExist:Boolean = false;
      
      private var _initialPlayerPinIdx:int = -1;
      
      private var _initialLonelyFastTravelPinIdx:int = -1;
      
      private var _initialFastTravelPinExist:Boolean = false;
      
      private var _mapPinDataArray:Array;
      
      private var _mapPinDataIndex:int;
      
      private var _closestPinIndex:int = -1;
      
      private var _scrollCoef:Number = 0;
      
      private var _textureSize:int = 0;
      
      private var _mapSize:int = 0;
      
      private var _tileCount:int = 0;
      
      private var _speedTimer:Timer;
      
      private var _inScroll:Boolean;
      
      private var _applyAcceleration:Boolean;
      
      private var _ignoreSnapping:Boolean = false;
      
      private var _selectedPinAvatar:StaticMapPinDescribed = null;
      
      private var _initialTimer:Timer;
      
      private var _showMapTimer:Timer;
      
      private var _updateTexturesTimer:Timer;
      
      private var _scrollAndZoomTimer:Timer;
      
      private var _fastTravelMode:Boolean;
      
      private var _minZoom:Number;
      
      private var _maxZoom:Number;
      
      private var _zoomBoundaries:Vector.<ZoomBoundary>;
      
      private var _unlimitedZoom:Boolean = false;
      
      private var _manualLod:Boolean = false;
      
      private var _defaultX:Number = -1;
      
      private var _defaultY:Number = -1;
      
      private var _menuAnimCompleted:Boolean = false;
      
      private var _fadingInCompleted:Boolean = false;
      
      private var _worldLeftBottom:Point;
      
      private var _worldRightTop:Point;
      
      private var _currentAreaId:int = -1;
      
      internal var _mapVisMinX:int;
      
      internal var _mapVisMaxX:int;
      
      internal var _mapVisMinY:int;
      
      internal var _mapVisMaxY:int;
      
      private var _gamepadZoomValue:Number = 0;
      
      private var _gamepadScrollX:Number = 0;
      
      private var _gamepadScrollY:Number = 0;
      
      private var _keyboardZoomIn:Boolean = false;
      
      private var _keyboardZoomOut:Boolean = false;
      
      private var _keyboardScrollLeft:Boolean = false;
      
      private var _keyboardScrollRight:Boolean = false;
      
      private var _keyboardScrollUp:Boolean = false;
      
      private var _keyboardScrollDown:Boolean = false;
      
      private var _isZooming:Boolean = false;
      
      private var _isScrolling:Boolean = false;
      
      internal const ZOOM_SPEED:Number = 1.05;
      
      private var _animationTween:GTween;
      
      private const ANIMATION_INTERVAL:Number = 0.25;
      
      internal const ANIM_SPEED:Number = 0.01;
      
      public function HubMap()
      {
         this._mapPinClass = getDefinitionByName("StaticMapPinBase") as Class;
         this._staticMapPins = new Vector.<StaticMapPinDescribed>();
         this._questMapPinIndices = new Vector.<int>();
         this._worldLeftBottom = new Point();
         this._worldRightTop = new Point();
         super();
         _defaultScale = 1;
         this._speedTimer = new Timer(ACCELERATION_INTERVAL,0);
         this._speedTimer.addEventListener(TimerEvent.TIMER,this.handleSpeedTimer,false,0,true);
         this._speedTimer.start();
         this._scrollAndZoomTimer = new Timer(33);
         this._scrollAndZoomTimer.addEventListener(TimerEvent.TIMER,this.handleScrollAndZoomTimer,false,0,true);
         this._scrollAndZoomTimer.start();
      }
      
      override protected function showMap(param1:Boolean = true) : void
      {
         super.showMap(param1);
         this.mcHubMapCrosshair.hideLabel(true);
      }
      
      override protected function hideMap(param1:Boolean = true) : void
      {
         super.hideMap(param1);
         this.mcHubMapCrosshair.hideLabel(true);
      }
      
      override protected function handleShowAnim(param1:GTween = null) : void
      {
         super.handleShowAnim(param1);
         setActualScale(1,1);
         this.mcHubMapZoomContainer.setActualScale(this._maxZoom,this._maxZoom);
      }
      
      override public function Enable(param1:Boolean, param2:Boolean = false) : *
      {
         this.cleanup(param1);
         if(_enabled == param1)
         {
            if(!param2)
            {
               return;
            }
         }
         _enabled = param1;
         if(_enabled)
         {
            this.showMap(false);
            this.updateMapSwitchHint();
            this.ResetKeyboardInput();
            this.StartInitialTimer();
         }
         else
         {
            this.StopUpdateTexturesTimer();
            this.StopInitialTimer();
            this.StopShowTimer();
            this.hideMap(false);
            this.mcHubMapCrosshair.hideLabel(true);
            this.mcHubMapCrosshair.capturedState = false;
            this.ClearPins();
            this.mcHubMapZoomContainer.mcHubMapContainer.mcLodContainer.alpha = 0;
            this.mcHubMapZoomContainer.mcHubMapContainer.mcGradientContainer.alpha = 0;
            this.mcHubMapPinContainer.alpha = 0;
            if(this.funcEnableCategoryPanel != null)
            {
               this.funcEnableCategoryPanel(false);
            }
            if(this.funcEnableQuestTracker != null)
            {
               this.funcEnableQuestTracker(false);
            }
         }
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc6_:InputAxisData = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:* = new Namespace("");
         if(param1.handled || !IsEnabled())
         {
            return;
         }
         if(!this.CanProcessInput())
         {
            return;
         }
         var _loc2_:InputDetails = param1.details;
         var _loc3_:* = _loc2_.value == InputValue.KEY_DOWN;
         var _loc4_:* = _loc2_.value == InputValue.KEY_UP;
         var _loc5_:Boolean = _loc2_.value == InputValue.KEY_DOWN || _loc2_.value == InputValue.KEY_HOLD;
         switch(_loc2_.code)
         {
            case KeyCode.Z:
               if(_loc3_)
               {
                  if(this.mcHubMapPreview.CanBeToggled())
                  {
                     this.mcHubMapPreview.Toggle();
                  }
               }
               break;
            case KeyCode.Z:
            case KeyCode.EQUAL:
            case KeyCode.NUMPAD_ADD:
               if(!this.isAnimationRunning())
               {
                  if(_loc5_)
                  {
                     this._keyboardZoomIn = true;
                  }
                  else if(_loc4_)
                  {
                     this._keyboardZoomIn = false;
                  }
               }
               break;
            case KeyCode.C:
            case KeyCode.MINUS:
            case KeyCode.NUMPAD_SUBTRACT:
               if(!this.isAnimationRunning())
               {
                  if(_loc5_)
                  {
                     this._keyboardZoomOut = true;
                  }
                  else if(_loc4_)
                  {
                     this._keyboardZoomOut = false;
                  }
               }
               break;
            case KeyCode.W:
               if(!this.isAnimationRunning())
               {
                  if(_loc5_)
                  {
                     this._keyboardScrollUp = true;
                  }
                  else if(_loc4_)
                  {
                     this._keyboardScrollUp = false;
                  }
                  param1.handled = true;
               }
               break;
            case KeyCode.S:
               if(!this.isAnimationRunning())
               {
                  if(_loc5_)
                  {
                     this._keyboardScrollDown = true;
                  }
                  else if(_loc4_)
                  {
                     this._keyboardScrollDown = false;
                  }
                  param1.handled = true;
               }
               break;
            case KeyCode.A:
               if(!this.isAnimationRunning())
               {
                  if(_loc5_)
                  {
                     this._keyboardScrollLeft = true;
                  }
                  else if(_loc4_)
                  {
                     this._keyboardScrollLeft = false;
                  }
                  param1.handled = true;
               }
               break;
            case KeyCode.D:
               if(!this.isAnimationRunning())
               {
                  if(_loc5_)
                  {
                     this._keyboardScrollRight = true;
                  }
                  else if(_loc4_)
                  {
                     this._keyboardScrollRight = false;
                  }
                  param1.handled = true;
               }
               break;
            case KeyCode.E:
            case KeyCode.ENTER:
            case KeyCode.PAD_A_CROSS:
               if(_loc4_)
               {
                  this.UseSelectedPin();
                  param1.handled = true;
               }
               break;
            case KeyCode.Q:
            case KeyCode.PAD_X_SQUARE:
               if(_loc3_)
               {
                  this.startSettingUserPin(localToGlobal(new Point(this.mcHubMapCrosshair.x,this.mcHubMapCrosshair.y)));
                  param1.handled = true;
               }
               else if(_loc4_)
               {
                  this.finishSettingUserPin();
                  param1.handled = true;
               }
               break;
            case KeyCode.PAD_LEFT_TRIGGER:
               if(this._manualLod)
               {
                  if(_loc3_)
                  {
                     this.mcHubMapZoomContainer.mcHubMapContainer.DecreaseLod();
                  }
                  param1.handled = true;
               }
               break;
            case KeyCode.PAD_RIGHT_TRIGGER:
               if(this._manualLod)
               {
                  if(_loc3_)
                  {
                     this.mcHubMapZoomContainer.mcHubMapContainer.IncreaseLod();
                  }
                  param1.handled = true;
               }
               else if(_loc3_)
               {
                  if(this.mcHubMapPreview.CanBeToggled())
                  {
                     this.mcHubMapPreview.Toggle();
                  }
               }
               break;
            case KeyCode.PAD_LEFT_THUMB:
            case KeyCode.TAB:
               if(_loc4_ && !this.isAnimationRunning())
               {
                  this.CenterBetweenQuestAndPlayer();
                  param1.handled = true;
               }
               break;
            case KeyCode.PAD_LEFT_STICK_AXIS:
               if(!this.isAnimationRunning())
               {
                  _loc6_ = InputAxisData(_loc2_.value);
                  _loc7_ = InputUtils.getMagnitude(_loc6_.xvalue,_loc6_.yvalue);
                  _loc8_ = _loc7_ * _loc7_;
                  if(_loc7_ > FORSAGE_TRIGGERING_LIMIT)
                  {
                     _loc9_ = this._scrollCoef * _loc8_ * FORSAGE_FACTOR;
                     this._applyAcceleration = true;
                     _loc10_ = 150;
                     if(!this._accelerationTimer && !this._ignoreSnapping)
                     {
                        this._accelerationTimer = new Timer(_loc10_);
                        this._accelerationTimer.addEventListener(TimerEvent.TIMER,this.handleAccelerationTimer,false,0,true);
                        this._accelerationTimer.start();
                     }
                  }
                  else
                  {
                     _loc9_ = this._scrollCoef * _loc8_;
                     this._applyAcceleration = false;
                     this._ignoreSnapping = false;
                     if(this._accelerationTimer)
                     {
                        this._accelerationTimer.stop();
                        this._accelerationTimer.removeEventListener(TimerEvent.TIMER,this.handleAccelerationTimer);
                        this._accelerationTimer = null;
                     }
                  }
                  this._gamepadScrollX = -_loc9_ * _loc6_.xvalue;
                  this._gamepadScrollY = _loc9_ * _loc6_.yvalue;
                  param1.handled = true;
               }
               break;
            case KeyCode.PAD_RIGHT_STICK_AXIS:
               if(!this.isAnimationRunning())
               {
                  if(_loc6_ = _loc2_.value as InputAxisData)
                  {
                     if(Math.abs(_loc6_.yvalue) > 0.8)
                     {
                        this._gamepadZoomValue = _loc6_.yvalue;
                     }
                  }
               }
               break;
            default:
               return;
         }
      }
      
      private function startSettingUserPin(param1:Point) : *
      {
         this._stagePositionForUserPin = param1;
         if(!this._snapTween1)
         {
            this._prevTimeOfPressedX = getTimer();
            this.startUserPinTimer();
         }
      }
      
      private function continueSettingUserPin() : Boolean
      {
         var _loc1_:int = 0;
         if(this._prevTimeOfPressedX > 0)
         {
            _loc1_ = getTimer();
            if(_loc1_ - this._prevTimeOfPressedX > this.USER_MAP_PIN_PANEL_DELAY)
            {
               this.enableUserPinPanel(true,this._stagePositionForUserPin);
               this._prevTimeOfPressedX = 0;
               return true;
            }
         }
         return false;
      }
      
      private function finishSettingUserPin() : *
      {
         var _loc1_:int = 0;
         if(this._prevTimeOfPressedX > 0)
         {
            _loc1_ = getTimer();
            if(_loc1_ - this._prevTimeOfPressedX > this.USER_MAP_PIN_PANEL_DELAY)
            {
               this.enableUserPinPanel(true,this._stagePositionForUserPin);
            }
            else
            {
               this.setUserMapPin(0,false);
            }
            this._prevTimeOfPressedX = 0;
            this.stopUserPinTimer();
         }
      }
      
      private function startUserPinTimer() : *
      {
         this.stopUserPinTimer();
         this._userPinTimer = new Timer(101);
         this._userPinTimer.addEventListener(TimerEvent.TIMER,this.handleUserPinTimer,false,0,true);
         this._userPinTimer.start();
      }
      
      private function stopUserPinTimer() : *
      {
         if(this._userPinTimer)
         {
            this._userPinTimer.stop();
            this._userPinTimer.removeEventListener(TimerEvent.TIMER,this.handleUserPinTimer);
            this._userPinTimer = null;
         }
      }
      
      private function handleUserPinTimer(param1:TimerEvent) : void
      {
         if(this.continueSettingUserPin())
         {
            this.stopUserPinTimer();
         }
      }
      
      private function handleAccelerationTimer(param1:TimerEvent) : void
      {
         this._ignoreSnapping = true;
         this._accelerationTimer.stop();
         this._accelerationTimer.removeEventListener(TimerEvent.TIMER,this.handleAccelerationTimer);
         this._accelerationTimer = null;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"worldmap.global.pins.static",[this.setPins]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"worldmap.global.pins.static.update",[this.updatePins]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"worldmap.global.pins.dynamic",[this.setDynamicPins]));
         this._scrollCoef = SCROLL_COEF_MIN;
         this.mcHubMapZoomContainer.mcHubMapContainer.mcLodContainer.alpha = 0;
         this.mcHubMapZoomContainer.mcHubMapContainer.mcGradientContainer.alpha = 0;
         this.mcHubMapPinContainer.alpha = 0;
      }
      
      public function setCurrentAreaId(param1:int) : *
      {
         this._currentAreaId = param1;
      }
      
      private function ResetKeyboardInput() : *
      {
         this._keyboardZoomIn = this._keyboardZoomOut = false;
         this._keyboardScrollUp = this._keyboardScrollDown = this._keyboardScrollLeft = this._keyboardScrollRight = false;
         this._gamepadZoomValue = 0;
         this._gamepadScrollX = this._gamepadScrollY = 0;
      }
      
      override public function CanProcessInput() : Boolean
      {
         if(Boolean(this._initialTimer) || Boolean(this._showMapTimer) || !this._fadingInCompleted)
         {
            return false;
         }
         return true;
      }
      
      override public function OnControllerChanged(param1:Boolean) : *
      {
         super.OnControllerChanged(param1);
         this.mcHubMapCrosshair.visible = param1;
         if(param1)
         {
            this.mcHubMapCrosshair.x = 0;
            this.mcHubMapCrosshair.y = 0;
         }
         this.updateMapSwitchHint();
      }
      
      public function OnMouseDoubleDown(param1:uint, param2:Point) : *
      {
         if(!this.CanProcessInput())
         {
            return;
         }
         this.UseSelectedPin();
      }
      
      public function OnMouseDown(param1:uint, param2:Point) : *
      {
         this.updateCursorPosition(param2);
         if(this.mcHubMapPreview.hitTestPoint(param2.x,param2.y))
         {
            if(param1 == MouseEventEx.LEFT_BUTTON)
            {
               this.mcHubMapPreview.SetLMBDown(true);
               this.centerOnPreviewPosition(param2);
            }
         }
         else if(param1 == MouseEventEx.RIGHT_BUTTON)
         {
            this.startSettingUserPin(param2);
         }
      }
      
      public function OnMouseUp(param1:uint, param2:Point) : *
      {
         if(param1 == MouseEventEx.LEFT_BUTTON)
         {
            this.mcHubMapPreview.SetLMBDown(false);
         }
         else if(param1 == MouseEventEx.RIGHT_BUTTON)
         {
            this.finishSettingUserPin();
         }
      }
      
      public function OnMouseMove(param1:Point) : *
      {
         if(this.mcHubMapPreview.IsLMBDown())
         {
            this.centerOnPreviewPosition(param1);
         }
         else
         {
            this.updateCursorPosition(param1);
            this.UpdateVisibilityAndPinPositions(false);
            this.UpdateSelectedMapPin(false);
         }
      }
      
      private function centerOnPreviewPosition(param1:Point) : *
      {
         var _loc2_:Point = this.mcHubMapPreview.GetWorldMapHitPoint(param1);
         var _loc3_:Number = -this.WorldXToMapX(_loc2_.x);
         var _loc4_:Number = -this.WorldYToMapY(_loc2_.y);
         this.CenterOnPosition(_loc3_,_loc4_);
      }
      
      public function centerOnWorldPosition(param1:Point, param2:Boolean) : *
      {
         var _loc3_:Number = -this.WorldXToMapX(param1.x);
         var _loc4_:Number = -this.WorldYToMapY(param1.y);
         this.CenterOnPosition(_loc3_,_loc4_,param2);
         this.UpdateSelectedMapPin(false);
      }
      
      public function showPinsFromCategory(param1:Array, param2:Boolean, param3:Boolean, param4:Boolean, param5:Dictionary, param6:Boolean) : *
      {
         var _loc7_:int = 0;
         var _loc8_:CategoryPinData = null;
         var _loc9_:StaticMapPinDescribed = null;
         var _loc10_:StaticMapPinData = null;
         var _loc11_:Boolean = false;
         var _loc12_:Dictionary = null;
         if(param1 == null)
         {
            _loc7_ = 0;
            while(_loc7_ < this._staticMapPins.length)
            {
               _loc10_ = (_loc9_ = this._staticMapPins[_loc7_]).data as StaticMapPinData;
               _loc11_ = true;
               if(_loc10_.isUserPin)
               {
                  if(!param5.hasOwnProperty(HubMapPinPanel.USER_PIN_TYPE))
                  {
                     _loc11_ = false;
                  }
               }
               else if(_loc10_.isQuest)
               {
                  if(!param5.hasOwnProperty(HubMapPinPanel.QUEST_PIN_TYPE))
                  {
                     _loc11_ = false;
                  }
               }
               else if(!param5.hasOwnProperty(_loc9_.data.type))
               {
                  _loc11_ = false;
               }
               else
               {
                  _loc11_ = true;
               }
               _loc9_.setHidden(_loc11_);
               _loc7_++;
            }
         }
         else
         {
            _loc12_ = new Dictionary();
            if(param1)
            {
               _loc7_ = 0;
               while(_loc7_ < param1.length)
               {
                  _loc8_ = param1[_loc7_] as CategoryPinData;
                  _loc12_[_loc8_._name] = 1;
                  _loc7_++;
               }
            }
            _loc7_ = 0;
            while(_loc7_ < this._staticMapPins.length)
            {
               if((_loc10_ = (_loc9_ = this._staticMapPins[_loc7_]).data as StaticMapPinData).isPlayer || _loc10_.isUserPin && param2 && !param5.hasOwnProperty(HubMapPinPanel.USER_PIN_TYPE) || _loc10_.isFastTravel && param3 || _loc10_.isQuest && param4 && !param5.hasOwnProperty(HubMapPinPanel.QUEST_PIN_TYPE) || _loc12_.hasOwnProperty(_loc10_.filteredType) && !param5.hasOwnProperty(_loc10_.filteredType))
               {
                  _loc9_.setHidden(false);
               }
               else
               {
                  _loc9_.setHidden(true);
               }
               _loc7_++;
            }
         }
         if(!param6)
         {
            this.UpdateVisibilityAndPinPositions(false);
            PinPointersManager.getInstance().updatePointersPosition();
            this.UpdateSelectedMapPin(false);
         }
      }
      
      public function setHighlightedMapPin(param1:uint) : *
      {
         var _loc2_:int = 0;
         var _loc3_:StaticMapPinData = null;
         _loc2_ = 0;
         while(_loc2_ < this._staticMapPins.length)
         {
            _loc3_ = this._staticMapPins[_loc2_].data as StaticMapPinData;
            if(_loc3_.isQuest)
            {
               if(_loc3_.id == param1)
               {
                  if(!_loc3_.highlighted)
                  {
                     _loc3_.highlighted = true;
                     this._staticMapPins[_loc2_].UpdateHighlighting();
                  }
               }
               else if(_loc3_.highlighted)
               {
                  _loc3_.highlighted = false;
                  this._staticMapPins[_loc2_].UpdateHighlighting();
               }
            }
            _loc2_++;
         }
         this.mcHubMapPreview.updateMapPinHighlighting();
      }
      
      public function updateCursorPosition(param1:Point) : *
      {
         var _loc2_:Point = globalToLocal(param1);
         this.mcHubMapCrosshair.x = _loc2_.x;
         this.mcHubMapCrosshair.y = _loc2_.y;
      }
      
      public function SetMenuAnimCompleted() : *
      {
         this._menuAnimCompleted = true;
         this.updatePreviewAnchorPosition();
      }
      
      public function setDefaultPosition(param1:Number, param2:Number) : void
      {
         this._defaultX = param1;
         this._defaultY = param2;
      }
      
      public function cleanup(param1:Boolean) : void
      {
         if(!param1)
         {
            this.UnselectPin();
            this.mcHubMapZoomContainer.mcHubMapContainer.HideAllTiles();
         }
         setActualScale(1,1);
         this.mcHubMapZoomContainer.setActualScale(this._maxZoom,this._maxZoom);
         this._scrollCoef = SCROLL_COEF_MIN;
         this.showMapSwitchHint(false);
      }
      
      public function GetZoomBoundaries() : Vector.<ZoomBoundary>
      {
         return this._zoomBoundaries;
      }
      
      public function SetMapZooms(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : *
      {
         var _loc6_:int = 0;
         this._minZoom = param1;
         this._maxZoom = param2;
         this._zoomBoundaries = new Vector.<ZoomBoundary>();
         this._zoomBoundaries[0] = new ZoomBoundary(-1,param3);
         this._zoomBoundaries[1] = new ZoomBoundary(param3,param4);
         this._zoomBoundaries[2] = new ZoomBoundary(param4,param5);
         this._zoomBoundaries[3] = new ZoomBoundary(param5,-1);
         _loc6_ = 0;
         while(_loc6_ < this._zoomBoundaries.length)
         {
            if(this._zoomBoundaries[_loc6_]._min < 0 && this._zoomBoundaries[_loc6_]._max > 0)
            {
               this._zoomBoundaries[_loc6_]._min = param1;
               break;
            }
            _loc6_++;
         }
         _loc6_ = int(this._zoomBoundaries.length - 1);
         while(_loc6_ >= 0)
         {
            if(this._zoomBoundaries[_loc6_]._max < 0 && this._zoomBoundaries[_loc6_]._min > 0)
            {
               this._zoomBoundaries[_loc6_]._max = param2;
               break;
            }
            _loc6_--;
         }
      }
      
      public function SetMapVisibilityBoundaries(param1:int, param2:int, param3:int, param4:int, param5:Number) : *
      {
         this._mapVisMinX = param1;
         this._mapVisMaxX = param2;
         this._mapVisMinY = param3;
         this._mapVisMaxY = param4;
         this.mcHubMapZoomContainer.mcHubMapContainer.SetMapVisibilityBoundaries(param1,param2,param3,param4,param5);
      }
      
      public function SetMapScrollingBoundaries(param1:int, param2:int, param3:int, param4:int) : *
      {
         this.mcHubMapZoomContainer.mcHubMapContainer.SetMapScrollingBoundaries(param1,param2,param3,param4);
      }
      
      public function SetMapSettings(param1:Number, param2:int, param3:int, param4:int, param5:int, param6:String, param7:MovieClip, param8:Boolean, param9:int) : *
      {
         this._textureSize = param3;
         this._mapSize = param1;
         this._tileCount = param2;
         this.UnselectPin();
         this.ClearPins();
         this.mcHubMapZoomContainer.mcHubMapContainer.SetMapSettings(param3,param4,param5,param6,param7);
         this.mcHubMapPreview.setMapSettings(param1,param3,param6,this.MapXToWorldX(this._mapVisMinX),this.MapXToWorldX(this._mapVisMaxX),this.MapYToWorldY(this._mapVisMinY),this.MapYToWorldY(this._mapVisMaxY),param8,param9);
         this.updatePreviewAnchorPosition();
      }
      
      private function updatePreviewAnchorPosition() : *
      {
         this.mcHubMapPreview.updateAnchorPosition(localToGlobal(new Point(this.mcHubMapPreviewAnchor.x,this.mcHubMapPreviewAnchor.y)));
      }
      
      public function ReinitializeMap() : *
      {
         setActualScale(1,1);
         this.mcHubMapZoomContainer.setActualScale(this._maxZoom,this._maxZoom);
         this.UpdateLod(false);
         this.setInitMapPosition();
      }
      
      public function EnableUnlimitedZoom(param1:Boolean) : *
      {
         this._unlimitedZoom = param1;
      }
      
      public function EnableManualLod(param1:Boolean) : *
      {
         this._manualLod = param1;
      }
      
      public function UpdateDebugBorders() : *
      {
         this.mcHubMapZoomContainer.mcHubMapContainer.UpdateDebugBorders();
      }
      
      private function setPins(param1:Object, param2:int) : *
      {
         if(param2 > -1)
         {
            return;
         }
         this._mapPinDataArray = param1 as Array;
         this._mapPinDataIndex = -1;
      }
      
      private function updatePins(param1:Object, param2:int) : *
      {
         if(param2 > -1)
         {
            return;
         }
         this._mapPinDataArray = param1 as Array;
         this._mapPinDataIndex = -1;
         this.initializeMapPinsProcessing();
         this.processMapPins(true);
         this.finalizeMapPinsProcessing(true);
      }
      
      private function setDynamicPins(param1:Object, param2:int) : *
      {
         var _loc3_:Array = null;
         var _loc4_:StaticMapPinData = null;
         var _loc5_:* = undefined;
         var _loc6_:int = 0;
         var _loc7_:Number = this.GetScale();
         if(param2 > -1)
         {
            return;
         }
         _loc3_ = param1 as Array;
         if(!_loc3_)
         {
            return;
         }
         _loc6_ = int(_loc3_.length);
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_ = _loc3_[_loc5_] as StaticMapPinData;
            this.CreatePin(_loc4_,this._staticMapPins.length,_loc7_);
            if(_loc4_.isQuest)
            {
               this.mcHubMapPreview.addPin(_loc4_);
            }
            else if(_loc4_.isPlayer)
            {
               this.mcHubMapPreview.addPin(_loc4_);
            }
            else if(_loc4_.isUserPin)
            {
               this.mcHubMapPreview.addPin(_loc4_);
            }
            if(this.funcAddPinToCategoryPanel != null)
            {
               this.funcAddPinToCategoryPanel(_loc4_);
            }
            _loc5_++;
         }
         if(this.funcUpdateCategoryPanel != null)
         {
            this.funcUpdateCategoryPanel();
         }
         var _loc8_:Boolean = this._ignoreSnapping;
         this._ignoreSnapping = false;
         this.UpdateVisibilityAndPinPositions();
         this._ignoreSnapping = _loc8_;
         PinPointersManager.getInstance().updatePointersPosition();
         this.UpdateSelectedMapPin(false);
      }
      
      private function initializeMapPinsProcessing() : *
      {
         this.UnselectPin();
         this._fastTravelPinExist = false;
         this._lonelyFastTravelPinIdx = -1;
         this._questMapPinIndices.length = 0;
         this._playerPinIdx = -1;
         this._initialFastTravelPinExist = false;
         this._initialLonelyFastTravelPinIdx = -1;
         this._initialPlayerPinIdx = -1;
         this._selectedMapPinIndex = -1;
         this._mapPinDataIndex = 0;
         PinPointersManager.getInstance().cleanup();
         this.ClearPins();
      }
      
      private function processMapPins(param1:Boolean = false) : Boolean
      {
         var _loc2_:StaticMapPinDescribed = null;
         var _loc3_:StaticMapPinData = null;
         var _loc5_:* = undefined;
         if(!this._mapPinDataArray)
         {
            return true;
         }
         var _loc4_:int = this._mapPinDataIndex;
         if(param1)
         {
            _loc5_ = this._mapPinDataArray.length;
         }
         else
         {
            _loc5_ = Math.min(this._mapPinDataIndex + MAX_PROCESSED_PIN_COUNT,this._mapPinDataArray.length);
         }
         var _loc6_:Number = this.GetScale();
         while(_loc4_ < _loc5_)
         {
            _loc3_ = this._mapPinDataArray[_loc4_] as StaticMapPinData;
            _loc2_ = this.CreatePin(_loc3_,_loc4_,_loc6_);
            if(_loc2_)
            {
               if(_loc3_.isFastTravel)
               {
                  if(_loc3_.journalAreaId == this._currentAreaId)
                  {
                     if(!this._initialFastTravelPinExist)
                     {
                        this._initialLonelyFastTravelPinIdx = _loc4_;
                        this._initialFastTravelPinExist = true;
                     }
                     else
                     {
                        this._initialLonelyFastTravelPinIdx = -1;
                     }
                  }
                  if(!this._fastTravelPinExist)
                  {
                     this._lonelyFastTravelPinIdx = _loc4_;
                     this._fastTravelPinExist = true;
                  }
                  else
                  {
                     this._lonelyFastTravelPinIdx = -1;
                  }
               }
               else if(_loc3_.isQuest)
               {
                  if(_loc3_.highlighted)
                  {
                     this._questMapPinIndices.unshift(_loc4_);
                  }
                  else
                  {
                     this._questMapPinIndices.push(_loc4_);
                  }
                  this.mcHubMapPreview.addPin(_loc3_);
               }
               else if(_loc3_.isPlayer)
               {
                  if(_loc3_.journalAreaId == this._currentAreaId)
                  {
                     this._initialPlayerPinIdx = _loc4_;
                  }
                  this._playerPinIdx = _loc4_;
                  this.mcHubMapPreview.addPin(_loc3_);
               }
               else if(_loc3_.isUserPin)
               {
                  this.mcHubMapPreview.addPin(_loc3_);
               }
               if(this.funcAddPinToCategoryPanel != null)
               {
                  this.funcAddPinToCategoryPanel(_loc3_);
               }
            }
            _loc4_++;
            ++this._mapPinDataIndex;
         }
         return this._mapPinDataIndex >= this._mapPinDataArray.length;
      }
      
      private function finalizeMapPinsProcessing(param1:Boolean = false) : *
      {
         if(this.funcInitializeCategoryPanel != null)
         {
            this.funcInitializeCategoryPanel();
         }
         if(!param1)
         {
            this.setInitMapPosition();
         }
         this.UpdateVisibilityAndPinPositions();
         this.UpdateSizeForAreaMapPins(this.GetComponentScale());
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function setInitMapPosition() : *
      {
         if(this._initialLonelyFastTravelPinIdx > -1)
         {
            this.CenterOnPin(this._initialLonelyFastTravelPinIdx,NaN,NaN,false);
         }
         else if(this._initialPlayerPinIdx > -1)
         {
            this.CenterOnPlayer();
         }
         else if(this._defaultX != -1 && this._defaultY != -1)
         {
            this.CenterOnPosition(this._defaultX,this._defaultY);
         }
         else
         {
            this.CenterOnTheMiddleOfTheMap();
         }
      }
      
      protected function ClearPins() : void
      {
         var _loc2_:StaticMapPinDescribed = null;
         this._questMapPinIndices.length = 0;
         this._playerPinIdx = -1;
         var _loc1_:int = 0;
         while(_loc1_ < this._staticMapPins.length)
         {
            _loc2_ = this._staticMapPins[_loc1_];
            this.removePinChild(_loc2_);
            _loc1_++;
         }
         this._staticMapPins.length = 0;
         this.mcHubMapPreview.clearPins();
         if(this.funcClearCategoryPanel != null)
         {
            this.funcClearCategoryPanel();
         }
      }
      
      private function GetScale() : Number
      {
         return this.mcHubMapZoomContainer.actualScaleX;
      }
      
      private function GetComponentScale() : Number
      {
         return 1 / this.mcHubMapZoomContainer.actualScaleX;
      }
      
      protected function handleSpeedTimer(param1:TimerEvent) : void
      {
         if(this._inScroll && this._applyAcceleration)
         {
            this._inScroll = false;
            if(this._scrollCoef < SCROLL_COEF_MAX)
            {
               this._scrollCoef += SCROLL_COEF_ACCELERATION;
            }
         }
         else
         {
            this._scrollCoef = SCROLL_COEF_MIN;
         }
      }
      
      private function handleScrollAndZoomTimer(param1:TimerEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(!IsEnabled())
         {
            return;
         }
         if(this._gamepadZoomValue != 0)
         {
            this._isZooming = this.zoomMap(this._gamepadZoomValue > 0);
            this._gamepadZoomValue = 0;
         }
         else
         {
            this._isZooming = false;
         }
         if(this._isZooming)
         {
            return;
         }
         if(Math.abs(this._gamepadScrollX) > 0 || Math.abs(this._gamepadScrollY) > 0)
         {
            this._isScrolling = this.scrollMap(this._gamepadScrollX,this._gamepadScrollY);
            this._gamepadScrollX = 0;
            this._gamepadScrollY = 0;
         }
         else
         {
            this._isScrolling = false;
         }
         if(this._keyboardZoomIn)
         {
            this._isZooming = this.zoomMap(true);
         }
         else if(this._keyboardZoomOut)
         {
            this._isZooming = this.zoomMap(false);
         }
         else
         {
            this._isZooming = false;
         }
         if(this._isZooming)
         {
            return;
         }
         if(this._keyboardScrollUp || this._keyboardScrollDown || this._keyboardScrollLeft || this._keyboardScrollRight)
         {
            _loc2_ = 0;
            _loc3_ = 0;
            if(this._keyboardScrollUp)
            {
               _loc2_ = KEYBOARD_SCROLL_SPEED;
            }
            else if(this._keyboardScrollDown)
            {
               _loc2_ = -KEYBOARD_SCROLL_SPEED;
            }
            if(this._keyboardScrollLeft)
            {
               _loc3_ = KEYBOARD_SCROLL_SPEED;
            }
            else if(this._keyboardScrollRight)
            {
               _loc3_ = -KEYBOARD_SCROLL_SPEED;
            }
            this._isScrolling = this.scrollMap(_loc3_,_loc2_);
         }
         else
         {
            this._isScrolling = false;
         }
         PinPointersManager.getInstance().updatePointersPosition();
      }
      
      public function zoomMap(param1:Boolean) : Boolean
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         PinPointersManager.getInstance().updatePointersPosition();
         if(_transitionTween)
         {
            return false;
         }
         if(this._snapTween2)
         {
            return false;
         }
         if(this._unlimitedZoom)
         {
            if(param1)
            {
               _loc2_ = this.mcHubMapZoomContainer.actualScaleX * this.ZOOM_SPEED;
               _loc3_ = this.mcHubMapZoomContainer.actualScaleY * this.ZOOM_SPEED;
            }
            else
            {
               _loc2_ = this.mcHubMapZoomContainer.actualScaleX / this.ZOOM_SPEED;
               _loc3_ = this.mcHubMapZoomContainer.actualScaleY / this.ZOOM_SPEED;
            }
         }
         else if(param1)
         {
            _loc2_ = Math.min(this.mcHubMapZoomContainer.actualScaleX * this.ZOOM_SPEED,this._maxZoom);
            _loc3_ = Math.min(this.mcHubMapZoomContainer.actualScaleY * this.ZOOM_SPEED,this._maxZoom);
         }
         else
         {
            _loc2_ = Math.max(this.mcHubMapZoomContainer.actualScaleX / this.ZOOM_SPEED,this._minZoom);
            _loc3_ = Math.max(this.mcHubMapZoomContainer.actualScaleY / this.ZOOM_SPEED,this._minZoom);
         }
         if(Math.abs(this.mcHubMapZoomContainer.scaleX - _loc2_) < 0.001 && Math.abs(this.mcHubMapZoomContainer.scaleY - _loc3_) < 0.001)
         {
            return false;
         }
         this.mcHubMapZoomContainer.scaleX = _loc2_;
         this.mcHubMapZoomContainer.scaleY = _loc3_;
         this.mcHubMapPinContainer.x = this.mcHubMapZoomContainer.mcHubMapContainer.x * this.GetScale();
         this.mcHubMapPinContainer.y = this.mcHubMapZoomContainer.mcHubMapContainer.y * this.GetScale();
         this.UpdateVisibilityAndPinPositions();
         this.UpdateSizeForAreaMapPins(this.GetComponentScale());
         this.UpdateSelectedMapPin(false);
         this.updateMapSwitchHint(false);
         this.UpdateLod();
         PinPointersManager.getInstance().updatePointersPosition();
         return true;
      }
      
      public function scrollMap(param1:Number, param2:Number) : Boolean
      {
         if(this._snapTween1)
         {
            return false;
         }
         if(this.mcHubMapPreview.IsLMBDown())
         {
            return false;
         }
         var _loc3_:Number = this.GetScale();
         var _loc4_:Number = param1 / _loc3_;
         var _loc5_:Number = param2 / _loc3_;
         this._bufPosX += _loc4_;
         this._bufPosY += _loc5_;
         var _loc7_:*;
         var _loc6_:Number;
         if((_loc7_ = (_loc6_ = Math.sqrt(this._bufPosX * this._bufPosX + this._bufPosY * this._bufPosY)) > SNAP_FREE_LIMIT / _loc3_) || this._selectedMapPinIndex == -1 || this._ignoreSnapping)
         {
            this.mcHubMapZoomContainer.mcHubMapContainer.scrollMap(this._bufPosX,this._bufPosY,this._selectedMapPinIndex != -1);
            this.OnPositionChanged();
            this.UpdateSelectedMapPin(true);
            this._bufPosX = 0;
            this._bufPosY = 0;
         }
         this._inScroll = true;
         PinPointersManager.getInstance().updatePointersPosition();
         return true;
      }
      
      protected function UpdateLod(param1:Boolean = true) : *
      {
         var _loc2_:int = 0;
         if(!this._manualLod)
         {
            _loc2_ = this.GetRequiredLod(this.mcHubMapZoomContainer.actualScaleX);
            if(_loc2_ > 0)
            {
               this.mcHubMapZoomContainer.mcHubMapContainer.SwitchToLod(_loc2_,param1);
            }
            else if(param1)
            {
               this.mcHubMapZoomContainer.mcHubMapContainer.ShowTilesFromCurrentLod();
            }
         }
         else
         {
            this.mcHubMapZoomContainer.mcHubMapContainer.ShowTilesFromCurrentLod();
         }
      }
      
      protected function GetRequiredLod(param1:Number) : int
      {
         var _loc2_:int = -1;
         var _loc3_:int = this.mcHubMapZoomContainer.mcHubMapContainer.GetCurrentLod();
         var _loc4_:int = 0;
         while(_loc4_ < this._zoomBoundaries.length)
         {
            if(this._zoomBoundaries[_loc4_].IsValid() && this._zoomBoundaries[_loc4_].IsInside(param1))
            {
               _loc2_ = _loc4_ + 1;
               break;
            }
            _loc4_++;
         }
         if(_loc2_ == -1)
         {
            return -1;
         }
         if(_loc2_ == _loc3_)
         {
            return -1;
         }
         return _loc2_;
      }
      
      protected function updateMapSwitchHint(param1:Boolean = false) : *
      {
      }
      
      protected function showMapSwitchHint(param1:Boolean) : void
      {
         if(this.showGotoWorldHint != null)
         {
            this.showGotoWorldHint(param1);
         }
      }
      
      public function IsMinZoom() : Boolean
      {
         return Math.abs(this.mcHubMapZoomContainer.scaleX - this._minZoom) < 0.001 && Math.abs(this.mcHubMapZoomContainer.scaleY - this._minZoom) < 0.001;
      }
      
      private function UpdateSizeForAreaMapPins(param1:Number) : *
      {
         var _loc2_:StaticMapPinDescribed = null;
         var _loc4_:Number = NaN;
         var _loc3_:uint = 0;
         while(_loc3_ < this.mcHubMapPinContainer._areaCanvas.numChildren)
         {
            _loc2_ = this.mcHubMapPinContainer._areaCanvas.getChildAt(_loc3_) as StaticMapPinDescribed;
            if(_loc2_ && _loc2_.data && _loc2_.data.radius > 0)
            {
               _loc4_ = _loc2_.data.radius / param1 * (270 / this._mapSize);
               _loc2_.mcIcon.mcPinRadius.scaleX = _loc4_;
               _loc2_.mcIcon.mcPinRadius.scaleY = _loc4_;
            }
            _loc3_++;
         }
      }
      
      private function UpdateSizeOfPinAvatar(param1:Number) : *
      {
         var _loc3_:StaticMapPinData = null;
         var _loc4_:Number = NaN;
         var _loc2_:Number = 1.4;
         if(this._selectedPinAvatar)
         {
            _loc3_ = this._selectedPinAvatar.data as StaticMapPinData;
            if(!_loc3_.isPlayer)
            {
               this._selectedPinAvatar.scaleX = _loc2_;
               this._selectedPinAvatar.scaleY = _loc2_;
               if(_loc3_.radius > 0)
               {
                  _loc4_ = _loc3_.radius / param1 * (270 / this._mapSize) / _loc2_;
                  this._selectedPinAvatar.mcIcon.mcPinRadius.scaleX = _loc4_;
                  this._selectedPinAvatar.mcIcon.mcPinRadius.scaleY = _loc4_;
               }
            }
            this._selectedPinAvatar.addChild(this._selectedPinAvatar.mcDescription);
         }
      }
      
      private function UpdateSelectedMapPin(param1:Boolean = true, param2:Boolean = true) : *
      {
         var _loc3_:StaticMapPinDescribed = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Point = null;
         if(this.isAnimationRunning())
         {
            return;
         }
         if(this._closestPinIndex > -1)
         {
            if(this._selectedMapPinIndex != this._closestPinIndex)
            {
               if(this._selectedMapPinIndex > -1)
               {
                  _loc6_ = this._staticMapPins[this._selectedMapPinIndex].GetWorldPosition();
                  _loc4_ = this.WorldXToMapX(_loc6_.x);
                  _loc5_ = this.WorldYToMapY(_loc6_.y);
                  this.UnselectPin();
               }
               this.SelectPin(this._closestPinIndex);
               this.mcHubMapCrosshair.capturedState = true;
               if(param2)
               {
                  if(MapMenu.IsUsingGamepad())
                  {
                     this.CenterOnPin(this._closestPinIndex,_loc4_,_loc5_,param1);
                  }
               }
            }
         }
         else if(this._selectedMapPinIndex > -1)
         {
            this.UnselectPin();
         }
      }
      
      private function GetPinIndexByType(param1:String) : int
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._staticMapPins.length)
         {
            if(this._staticMapPins[_loc2_].data.type == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      private function SelectPin(param1:int) : void
      {
         if(this._selectedMapPinIndex == param1)
         {
            return;
         }
         if(param1 < 0 || param1 >= this._staticMapPins.length)
         {
            return;
         }
         this.UnselectPin(false);
         this._selectedMapPinIndex = param1;
         this._bufPosX = 0;
         this._bufPosY = 0;
         var _loc2_:StaticMapPinDescribed = this._staticMapPins[this._selectedMapPinIndex];
         var _loc3_:StaticMapPinData = _loc2_.data as StaticMapPinData;
         this.mcHubMapCrosshair.showLabel(_loc3_.label,true);
         _loc2_.mcIcon.visible = false;
         _loc2_.tfLabel.visible = false;
         var _loc4_:Number = this.GetComponentScale();
         this._selectedPinAvatar = new this._mapPinClass() as StaticMapPinDescribed;
         this._selectedPinAvatar.isAvatar = true;
         this._selectedPinAvatar.SetWorldPosition(_loc3_.posX,_loc3_.posY);
         this._selectedPinAvatar.setData(_loc3_);
         this._selectedPinAvatar.validateNow();
         this.UpdatePositionOfPinAvatar(this.GetScale());
         this.UpdateSizeOfPinAvatar(this.GetComponentScale());
         this._selectedPinAvatar.UpdateHighlighting();
         this._selectedPinAvatar.filters = [new GlowFilter(0,0.8,6,6,2,BitmapFilterQuality.HIGH)];
         if(_loc3_.rotation)
         {
            this._selectedPinAvatar.mcIcon.rotation = _loc3_.rotation;
         }
         else
         {
            this._selectedPinAvatar.mcIcon.rotation = 0;
         }
         this.mcHubMapPinContainer._selectedCanvas.addChild(this._selectedPinAvatar);
         var _loc5_:MapContextEvent;
         (_loc5_ = new MapContextEvent(MapContextEvent.CONTEXT_CHANGE)).active = true;
         _loc5_.mapppinData = _loc3_;
         var _loc6_:Object;
         (_loc6_ = {}).title = _loc3_.label;
         _loc6_.description = _loc3_.description;
         _loc6_.tracked = _loc3_.tracked;
         _loc5_.tooltipData = _loc6_;
         dispatchEvent(_loc5_);
      }
      
      private function UnselectPin(param1:Boolean = true) : *
      {
         var _loc2_:StaticMapPinDescribed = null;
         var _loc3_:MapContextEvent = null;
         if(this._selectedPinAvatar)
         {
            GTweener.removeTweens(this._selectedPinAvatar);
            this.mcHubMapPinContainer._selectedCanvas.removeChild(this._selectedPinAvatar);
            this._selectedPinAvatar = null;
         }
         this.mcHubMapCrosshair.hideLabel(true);
         if(this._selectedMapPinIndex >= 0 && this._selectedMapPinIndex < this._staticMapPins.length)
         {
            _loc2_ = this._staticMapPins[this._selectedMapPinIndex];
            _loc2_.mcIcon.visible = true;
            _loc2_.tfLabel.visible = true;
         }
         this._selectedMapPinIndex = -1;
         this._scrollCoef = SCROLL_COEF_MIN;
         if(param1)
         {
            _loc3_ = new MapContextEvent(MapContextEvent.CONTEXT_CHANGE);
            _loc3_.active = false;
            dispatchEvent(_loc3_);
         }
      }
      
      private function MapXToWorldX(param1:Number) : Number
      {
         var _loc2_:Number = 2 * this._textureSize / this._mapSize;
         return param1 / _loc2_;
      }
      
      private function MapYToWorldY(param1:Number) : Number
      {
         var _loc2_:Number = 2 * this._textureSize / this._mapSize;
         return -param1 / _loc2_;
      }
      
      private function WorldXToMapX(param1:Number) : Number
      {
         var _loc2_:Number = 2 * this._textureSize / this._mapSize;
         return param1 * _loc2_;
      }
      
      private function WorldYToMapY(param1:Number) : Number
      {
         var _loc2_:Number = 2 * this._textureSize / this._mapSize;
         return -param1 * _loc2_;
      }
      
      private function CreatePin(param1:StaticMapPinData, param2:int, param3:Number) : StaticMapPinDescribed
      {
         if(param1.type == "")
         {
            return null;
         }
         var _loc4_:StaticMapPinDescribed = new this._mapPinClass();
         this.setupRenderer(_loc4_);
         _loc4_.SetWorldPosition(param1.posX,param1.posY);
         _loc4_.UpdateMapPosition2(this.WorldXToMapX(param1.posX) * param3,this.WorldYToMapY(param1.posY) * param3);
         _loc4_.setData(param1);
         _loc4_.InitPingAnimation();
         _loc4_.UpdateHighlighting();
         this._staticMapPins[param2] = _loc4_;
         _loc4_.validateNow();
         this.addPinChild(_loc4_);
         if(param1.rotation)
         {
            _loc4_.mcIcon.rotation = param1.rotation;
         }
         else
         {
            _loc4_.mcIcon.rotation = 0;
         }
         return _loc4_;
      }
      
      public function UseSelectedPin() : *
      {
         var _loc1_:StaticMapPinDescribed = null;
         var _loc2_:int = 0;
         if(this._selectedMapPinIndex > -1)
         {
            _loc1_ = this._staticMapPins[this._selectedMapPinIndex];
            if(_loc1_)
            {
               if(_loc1_.data.isFastTravel)
               {
                  _loc2_ = !!_loc1_.data.areaId ? int(_loc1_.data.areaId) : -1;
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnStaticMapPinUsed",[_loc1_.data.id,_loc2_]));
               }
            }
         }
      }
      
      private function addPinChild(param1:StaticMapPinDescribed) : void
      {
         var _loc2_:StaticMapPinData = null;
         var _loc3_:Sprite = null;
         if(param1)
         {
            _loc2_ = param1.data as StaticMapPinData;
            _loc3_ = this.mcHubMapPinContainer.getPinCanvas(_loc2_);
            _loc3_.addChild(param1);
         }
      }
      
      private function removePinChild(param1:StaticMapPinDescribed) : void
      {
         var _loc2_:StaticMapPinData = null;
         var _loc3_:Sprite = null;
         if(param1)
         {
            _loc2_ = param1.data as StaticMapPinData;
            _loc3_ = this.mcHubMapPinContainer.getPinCanvas(_loc2_);
            _loc3_.removeChild(param1);
         }
      }
      
      public function RemoveUserMapPin(param1:uint) : *
      {
         var _loc2_:int = int(this._staticMapPins.length - 1);
         while(_loc2_ >= 0)
         {
            if(this._staticMapPins[_loc2_].data.isUserPin)
            {
               if(this._staticMapPins[_loc2_].data.id == param1)
               {
                  this.mcHubMapPreview.removePin(param1);
                  this.UnselectPin();
                  this.removePinChild(this._staticMapPins[_loc2_]);
                  this._staticMapPins.splice(_loc2_,1);
                  this.UpdateVisibilityAndPinPositions(false);
                  this.UpdateSelectedMapPin(false);
                  return;
               }
            }
            _loc2_--;
         }
      }
      
      private function CenterOnPosition(param1:Number, param2:Number, param3:Boolean = false) : *
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(this.isAnimationRunning())
         {
            return;
         }
         if(param3)
         {
            _loc4_ = Number(this.mcHubMapZoomContainer.mcHubMapContainer.GetRestrictedX(param1));
            _loc5_ = Number(this.mcHubMapZoomContainer.mcHubMapContainer.GetRestrictedY(param2));
            this._animationTween = GTweener.to(this.mcHubMapZoomContainer.mcHubMapContainer,this.ANIMATION_INTERVAL,{
               "x":_loc4_,
               "y":_loc5_
            },{
               "ease":Sine.easeInOut,
               "onChange":this.handleTransitionChange,
               "onComplete":this.handleTransitionComplete
            });
         }
         else
         {
            this.mcHubMapZoomContainer.mcHubMapContainer.setImmediatePosition(param1,param2);
         }
         this.OnPositionChanged();
         this.mcHubMapZoomContainer.mcHubMapContainer.ShowTilesFromCurrentLod();
      }
      
      protected function handleTransitionChange(param1:GTween) : *
      {
         this.OnPositionChanged();
         this.mcHubMapZoomContainer.mcHubMapContainer.ShowTilesFromCurrentLod();
      }
      
      protected function handleTransitionComplete(param1:GTween) : *
      {
         this.OnPositionChanged();
         this.mcHubMapZoomContainer.mcHubMapContainer.ShowTilesFromCurrentLod();
         this._animationTween.end();
         this._animationTween = null;
         this.UpdateSelectedMapPin(true,false);
      }
      
      public function isAnimationRunning() : Boolean
      {
         return this._animationTween != null;
      }
      
      private function CenterOnTheMiddleOfTheMap() : *
      {
         this.mcHubMapZoomContainer.mcHubMapContainer.x = 0;
         this.mcHubMapZoomContainer.mcHubMapContainer.y = 0;
         this.OnPositionChanged();
         this.mcHubMapZoomContainer.mcHubMapContainer.ShowTilesFromCurrentLod();
      }
      
      public function IsPlayerPinExist() : Boolean
      {
         return this._playerPinIdx > -1;
      }
      
      public function IsCenteredOnPlayerPin() : Boolean
      {
         if(this._playerPinIdx > -1)
         {
            return this.IsCenteredOnPin(this._playerPinIdx);
         }
         return false;
      }
      
      public function CenterOnPlayer(param1:Boolean = false, param2:Boolean = false) : Boolean
      {
         if(this._playerPinIdx > -1)
         {
            this.CenterOnPin(this._playerPinIdx,NaN,NaN,param1,param2);
            return true;
         }
         return false;
      }
      
      public function IsQuestPinExist() : Boolean
      {
         return this._questMapPinIndices.length > 0;
      }
      
      public function IsCenteredOnQuestPin() : Boolean
      {
         if(this._questMapPinIndices.length > 0)
         {
            return this.IsCenteredOnPin(this._questMapPinIndices[0]);
         }
         return false;
      }
      
      public function CenterOnQuest(param1:Boolean = false, param2:Boolean = false) : Boolean
      {
         if(this._questMapPinIndices.length > 0)
         {
            this.CenterOnPin(this._questMapPinIndices[0],NaN,NaN,param1,param2);
            return true;
         }
         return false;
      }
      
      private function IsCenteredOnPin(param1:int) : Boolean
      {
         if(param1 < 0 || param1 >= this._staticMapPins.length)
         {
            return false;
         }
         var _loc2_:Point = this._staticMapPins[param1].GetWorldPosition();
         var _loc3_:Number = -this.WorldXToMapX(_loc2_.x);
         var _loc4_:Number = -this.WorldYToMapY(_loc2_.y);
         var _loc5_:Number = this.mcHubMapZoomContainer.mcHubMapContainer.x;
         var _loc6_:Number = this.mcHubMapZoomContainer.mcHubMapContainer.y;
         return Math.pow(_loc5_ - _loc3_,2) + Math.pow(_loc6_ - _loc4_,2) < 0.01;
      }
      
      public function CenterOnPin(param1:int, param2:Number = NaN, param3:Number = NaN, param4:Boolean = true, param5:Boolean = false) : *
      {
         if(param1 < 0 || param1 >= this._staticMapPins.length)
         {
            return;
         }
         var _loc6_:Point = this._staticMapPins[param1].GetWorldPosition();
         var _loc7_:* = -this.WorldXToMapX(_loc6_.x);
         var _loc8_:* = -this.WorldYToMapY(_loc6_.y);
         if(!isNaN(param2) && !isNaN(param3))
         {
            this.mcHubMapZoomContainer.mcHubMapContainer.x = -param2;
            this.mcHubMapZoomContainer.mcHubMapContainer.y = -param3;
            this.OnPositionChanged();
         }
         if(param4)
         {
            this.mcHubMapCrosshair.capturedState = false;
            if(!this._ignoreSnapping)
            {
               GTweener.removeTweens(this.mcHubMapZoomContainer.mcHubMapContainer);
               this._snapTween1 = GTweener.to(this.mcHubMapZoomContainer.mcHubMapContainer,0.3,{
                  "x":_loc7_,
                  "y":_loc8_
               },{
                  "onComplete":this.handleSnapTween1Complete,
                  "data":{"pinIdx":param1}
               });
               GTweener.removeTweens(this.mcHubMapPinContainer);
               this._snapTween2 = GTweener.to(this.mcHubMapPinContainer,0.3,{
                  "x":_loc7_ * this.GetScale(),
                  "y":_loc8_ * this.GetScale()
               },{"onComplete":this.handleSnap2TweenComplete});
            }
            else
            {
               this.mcHubMapZoomContainer.mcHubMapContainer.x = _loc7_;
               this.mcHubMapZoomContainer.mcHubMapContainer.y = _loc8_;
               this.handleSnapTween1Complete(new GTween(null,1,null,{"data":{"pinIdx":param1}}));
               this.mcHubMapPinContainer.mcHubMapContainer.x = _loc7_;
               this.mcHubMapPinContainer.mcHubMapContainer.y = _loc8_;
               this.handleSnap2TweenComplete();
            }
         }
         else
         {
            this.mcHubMapZoomContainer.mcHubMapContainer.x = _loc7_;
            this.mcHubMapZoomContainer.mcHubMapContainer.y = _loc8_;
            this.OnPositionChanged();
            if(this._menuAnimCompleted)
            {
               this.mcHubMapZoomContainer.mcHubMapContainer.ShowTilesFromCurrentLod();
            }
            if(this._selectedMapPinIndex != -1)
            {
               this.UnselectPin();
            }
            if(!param5)
            {
               this.SelectPin(param1);
            }
         }
         this._scrollCoef = SCROLL_COEF_MIN;
      }
      
      protected function handleSnapTween1Complete(param1:GTween) : void
      {
         this.SelectPin(param1.data.pinIdx);
         this._snapTween1 = null;
         this._snapTween2 = null;
         this.OnPositionChanged();
         this.mcHubMapZoomContainer.mcHubMapContainer.ShowTilesFromCurrentLod();
      }
      
      protected function handleSnap2TweenComplete(param1:GTween = null) : void
      {
         this._snapTween2 = null;
      }
      
      protected function setupRenderer(param1:IListItemRenderer) : *
      {
         param1.owner = this;
         param1.focusTarget = this;
         param1.tabEnabled = false;
         param1.doubleClickEnabled = true;
         UIComponent(param1).visible = true;
      }
      
      protected function cleanUpRenderer(param1:IListItemRenderer) : *
      {
         param1.owner = null;
         param1.focusTarget = null;
         param1.doubleClickEnabled = false;
      }
      
      private function StartInitialTimer() : *
      {
         this.StopInitialTimer();
         this._initialTimer = new Timer(20);
         this._initialTimer.addEventListener(TimerEvent.TIMER,this.handleInitialTimer,false,0,true);
         this._initialTimer.start();
         this._mapPinDataIndex = -1;
      }
      
      private function StopInitialTimer() : *
      {
         if(this._initialTimer)
         {
            this._initialTimer.removeEventListener(TimerEvent.TIMER,this.handleInitialTimer);
            this._initialTimer.stop();
            this._initialTimer = null;
         }
      }
      
      protected function handleInitialTimer(param1:TimerEvent) : void
      {
         if(this._menuAnimCompleted)
         {
            if(this._mapPinDataIndex == -1)
            {
               this.initializeMapPinsProcessing();
            }
            if(this.processMapPins())
            {
               this.finalizeMapPinsProcessing();
               this.StopInitialTimer();
               this.StartShowTimer();
               this.StartUpdateTexturesTimer();
               this.UpdateVisibilityAndPinPositions();
               this.mcHubMapZoomContainer.mcHubMapContainer.ShowTilesFromCurrentLod();
            }
         }
      }
      
      private function StartShowTimer() : *
      {
         this.StopShowTimer();
         this._showMapTimer = new Timer(SHOW_INTERVAL);
         this._showMapTimer.addEventListener(TimerEvent.TIMER,this.handleShowTimer,false,0,true);
         this._showMapTimer.start();
      }
      
      private function StopShowTimer() : *
      {
         if(this._showMapTimer)
         {
            this._showMapTimer.removeEventListener(TimerEvent.TIMER,this.handleShowTimer);
            this._showMapTimer.stop();
            this._showMapTimer = null;
         }
      }
      
      private function handleShowTimer(param1:TimerEvent) : void
      {
         this.StopShowTimer();
         this._fadingInCompleted = false;
         this.mcHubMapZoomContainer.mcHubMapContainer.mcGradientContainer.alpha = 0;
         GTweener.removeTweens(this.mcHubMapZoomContainer.mcHubMapContainer.mcGradientContainer);
         GTweener.to(this.mcHubMapZoomContainer.mcHubMapContainer.mcGradientContainer,FADING_GRADIENT_DURATION,{"alpha":1},{"ease":Sine.easeIn});
         this.mcHubMapZoomContainer.mcHubMapContainer.mcLodContainer.alpha = 0;
         GTweener.removeTweens(this.mcHubMapZoomContainer.mcHubMapContainer.mcLodContainer);
         GTweener.to(this.mcHubMapZoomContainer.mcHubMapContainer.mcLodContainer,FADING_TEXTURES_DURATION,{"alpha":1},{
            "ease":Sine.easeIn,
            "onComplete":this.handleFadingInEnded
         });
         this.mcHubMapPinContainer.alpha = 0;
         GTweener.removeTweens(this.mcHubMapPinContainer);
         GTweener.to(this.mcHubMapPinContainer,FADING_GRADIENT_DURATION,{"alpha":1},{"ease":Sine.easeIn});
      }
      
      protected function handleFadingInEnded(param1:GTween = null) : void
      {
         this._fadingInCompleted = true;
         if(this.funcEnableCategoryPanel != null)
         {
            this.funcEnableCategoryPanel(true);
         }
         if(this.funcEnableQuestTracker != null)
         {
            this.funcEnableQuestTracker(true);
         }
      }
      
      private function StartUpdateTexturesTimer() : *
      {
         this.StopUpdateTexturesTimer();
         this.handleUpdateTexturesTimer(null);
         this._updateTexturesTimer = new Timer(UPDATE_HUB_TEXTURES_INTERVAL,0);
         this._updateTexturesTimer.addEventListener(TimerEvent.TIMER,this.handleUpdateTexturesTimer,false,0,true);
         this._updateTexturesTimer.start();
      }
      
      private function StopUpdateTexturesTimer() : *
      {
         if(this._updateTexturesTimer)
         {
            this._updateTexturesTimer.removeEventListener(TimerEvent.TIMER,this.handleUpdateTexturesTimer);
            this._updateTexturesTimer.stop();
            this._updateTexturesTimer = null;
         }
      }
      
      protected function handleUpdateTexturesTimer(param1:TimerEvent) : void
      {
         this.mcHubMapZoomContainer.mcHubMapContainer.ProcessHidingTiles(UPDATE_HUB_TEXTURES_INTERVAL);
      }
      
      private function OnPositionChanged() : *
      {
         this.mcHubMapPinContainer.x = this.mcHubMapZoomContainer.mcHubMapContainer.x * this.GetScale();
         this.mcHubMapPinContainer.y = this.mcHubMapZoomContainer.mcHubMapContainer.y * this.GetScale();
         this.UpdateVisibilityAndPinPositions(false);
         this.UpdateSizeForAreaMapPins(this.GetComponentScale());
         this.UpdateGotoButton(false);
      }
      
      public function UpdateGotoButton(param1:*) : *
      {
         var _loc3_:String = null;
         if(!param1)
         {
            if(MapMenu.IsUsingGamepad())
            {
               return;
            }
         }
         var _loc2_:int = this.GetNextPinIndexToShow();
         if(_loc2_ == -1)
         {
            this.showGotoPlayerPin(false);
            this.showGotoQuestPin(false);
            InputFeedbackManager.updateButtons(this);
         }
         else
         {
            _loc3_ = String(this._staticMapPins[_loc2_].data.type);
            if(_loc3_ == "Player")
            {
               this.showGotoPlayerPin(true);
               this.showGotoQuestPin(false);
               InputFeedbackManager.updateButtons(this);
            }
            else
            {
               this.showGotoPlayerPin(false);
               this.showGotoQuestPin(true);
               InputFeedbackManager.updateButtons(this);
            }
         }
      }
      
      private function UpdateVisibilityAndPinPositions(param1:Boolean = true) : *
      {
         var _loc2_:StaticMapPinDescribed = null;
         var _loc3_:Point = null;
         var _loc5_:* = undefined;
         var _loc6_:Point = null;
         var _loc7_:Number = NaN;
         var _loc4_:* = this.GetScale();
         this.mcHubMapZoomContainer.mcHubMapContainer.UpdateVisibileArea();
         this._worldLeftBottom.x = this.MapXToWorldX(this.mcHubMapZoomContainer.mcHubMapContainer.GetVisibleAreaLocalLeftBottomPos().x);
         this._worldLeftBottom.y = this.MapYToWorldY(this.mcHubMapZoomContainer.mcHubMapContainer.GetVisibleAreaLocalLeftBottomPos().y);
         this._worldRightTop.x = this.MapXToWorldX(this.mcHubMapZoomContainer.mcHubMapContainer.GetVisibleAreaLocalRightTopPos().x);
         this._worldRightTop.y = this.MapYToWorldY(this.mcHubMapZoomContainer.mcHubMapContainer.GetVisibleAreaLocalRightTopPos().y);
         if(MapMenu.IsUsingGamepad())
         {
            _loc5_ = localToGlobal(POINT_0_0);
         }
         else
         {
            _loc5_ = MapMenu.GetCurrGlobalMousePos();
         }
         var _loc8_:Number = 1000000;
         this._closestPinIndex = -1;
         var _loc9_:int = int(this._staticMapPins.length - 1);
         while(_loc9_ >= 0)
         {
            _loc2_ = this._staticMapPins[_loc9_] as StaticMapPinDescribed;
            if(_loc2_)
            {
               _loc3_ = _loc2_.GetWorldPosition();
               if(param1)
               {
                  _loc2_.UpdateMapPosition2(this.WorldXToMapX(_loc3_.x) * _loc4_,this.WorldYToMapY(_loc3_.y) * _loc4_);
               }
               if(_loc3_.x >= this._worldLeftBottom.x && _loc3_.x <= this._worldRightTop.x && _loc3_.y >= this._worldLeftBottom.y && _loc3_.y <= this._worldRightTop.y)
               {
                  _loc2_.SetVisibleInArea(true);
                  _loc6_ = _loc2_.localToGlobal(POINT_0_0);
                  _loc7_ = Math2.getSquaredSegmentLength(_loc5_,_loc6_);
                  if(!_loc2_.isHidden())
                  {
                     if(this._closestPinIndex == -1 || _loc8_ > _loc7_ || _loc8_ == _loc7_ && _loc2_.data.isFastTravel)
                     {
                        if(_loc7_ < SNAP_DISTANCE_SQUARED && !this._ignoreSnapping)
                        {
                           this._closestPinIndex = _loc9_;
                           _loc8_ = _loc7_;
                        }
                     }
                  }
               }
               else
               {
                  _loc2_.SetVisibleInArea(false);
               }
            }
            _loc9_--;
         }
         this.UpdatePositionOfPinAvatar(_loc4_);
         this.UpdateSizeOfPinAvatar(this.GetComponentScale());
         if(this.mcHubMapPreview.CanBeToggled())
         {
            this.mcHubMapPreview.updateVisibleFramePosition(this._worldLeftBottom,this._worldRightTop);
         }
      }
      
      private function UpdatePositionOfPinAvatar(param1:Number) : *
      {
         var _loc2_:Point = null;
         if(this._selectedPinAvatar)
         {
            _loc2_ = this._selectedPinAvatar.GetWorldPosition();
            this._selectedPinAvatar.UpdateMapPosition2(this.WorldXToMapX(_loc2_.x) * param1,this.WorldYToMapY(_loc2_.y) * param1);
         }
      }
      
      public function setUserMapPin(param1:int, param2:Boolean) : *
      {
         var _loc3_:Point = this.getWorldPositionFromCursor();
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnUserMapPinSet",[_loc3_.x,_loc3_.y,param1,param2]));
      }
      
      public function getWorldPositionFromCursor() : Point
      {
         var _loc2_:Point = null;
         if(this._selectedMapPinIndex > 0)
         {
            _loc2_ = this._staticMapPins[this._selectedMapPinIndex].GetWorldPosition();
            return new Point(_loc2_.x,_loc2_.y);
         }
         var _loc1_:Point = new Point(-this.mcHubMapZoomContainer.mcHubMapContainer.x + this.mcHubMapCrosshair.x / this.GetScale(),-this.mcHubMapZoomContainer.mcHubMapContainer.y + this.mcHubMapCrosshair.y / this.GetScale());
         return new Point(this.MapXToWorldX(_loc1_.x),this.MapYToWorldY(_loc1_.y));
      }
      
      private function CenterBetweenQuestAndPlayer() : *
      {
         var _loc1_:int = -1;
         _loc1_ = this.GetNextPinIndexToShow();
         if(_loc1_ != -1)
         {
            this.CenterOnPin(_loc1_,NaN,NaN,false,false);
            if(!MapMenu.IsUsingGamepad())
            {
               this.UpdateSelectedMapPin(false);
            }
         }
      }
      
      private function GetNextPinIndexToShow() : int
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Point = null;
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         var _loc9_:Point = null;
         var _loc3_:Vector.<int> = new Vector.<int>();
         var _loc4_:int = -1;
         _loc1_ = 0;
         while(_loc1_ < this._questMapPinIndices.length)
         {
            _loc5_ = this._questMapPinIndices[_loc1_];
            _loc6_ = this._staticMapPins[_loc5_].GetWorldPosition();
            _loc7_ = false;
            _loc2_ = 0;
            while(_loc2_ < _loc3_.length)
            {
               _loc8_ = _loc3_[_loc2_];
               _loc9_ = this._staticMapPins[_loc8_].GetWorldPosition();
               if(_loc6_.equals(_loc9_))
               {
                  _loc7_ = true;
                  break;
               }
               _loc2_++;
            }
            if(!_loc7_)
            {
               _loc3_[_loc3_.length] = this._questMapPinIndices[_loc1_];
            }
            _loc1_++;
         }
         if(this._playerPinIdx != -1)
         {
            _loc3_.unshift(this._playerPinIdx);
         }
         if(MapMenu.IsUsingGamepad())
         {
            _loc1_ = 0;
            while(_loc1_ < _loc3_.length)
            {
               if(_loc3_[_loc1_] == this._selectedMapPinIndex)
               {
                  _loc4_ = _loc1_;
                  break;
               }
               _loc1_++;
            }
            if(_loc4_ == -1)
            {
               if(_loc3_.length > 0)
               {
                  _loc4_ = _loc3_[0];
               }
            }
            else
            {
               _loc4_ = _loc3_[(_loc4_ + 1) % _loc3_.length];
            }
         }
         else
         {
            _loc1_ = 0;
            while(_loc1_ < _loc3_.length)
            {
               if(this.IsCenteredOnPin(_loc3_[_loc1_]))
               {
                  _loc4_ = _loc1_;
                  break;
               }
               _loc1_++;
            }
            if(_loc4_ == -1)
            {
               if(_loc3_.length > 0)
               {
                  _loc4_ = _loc3_[0];
               }
            }
            else
            {
               _loc4_ = _loc3_[(_loc4_ + 1) % _loc3_.length];
            }
         }
         return _loc4_;
      }
   }
}
