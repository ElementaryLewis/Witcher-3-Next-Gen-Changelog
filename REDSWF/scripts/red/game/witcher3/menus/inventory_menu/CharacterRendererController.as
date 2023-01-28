package red.game.witcher3.menus.inventory_menu
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Sine;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import red.core.CoreMenu;
   import red.core.constants.KeyCode;
   import red.core.data.InputAxisData;
   import red.core.events.GameEvent;
   import red.game.witcher3.constants.CursorType;
   import red.game.witcher3.controls.InputFeedbackButton;
   import red.game.witcher3.managers.InputFeedbackManager;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.managers.InputDelegate;
   import scaleform.clik.ui.InputDetails;
   import scaleform.gfx.MouseEventEx;
   
   public class CharacterRendererController
   {
      
      protected static const DEFAULT_ANIMATION_DURATION:Number = 0.5;
      
      protected static const DEFAULT_ENTITY_POS_Y:Number = 1;
      
      protected static const DEFAULT_ENTITY_ROTATION_Y:Number = 190.71;
      
      protected static const DEFAULT_ENTITY_SCALE:Number = 3.35;
      
      protected static const CENTERED_ENTITY_POS_Y:Number = 1;
      
      protected static const CENTERED_ENTITY_ROTATION_Y:Number = 160;
      
      protected static const CENTERED_ENTITY_SCALE:Number = 3.35;
      
      protected static const MAX_SCALE:Number = 4;
      
      protected static const MIN_SCALE:Number = 3;
      
      protected static const MIN_PAN_Y:Number = 0.5;
      
      protected static const MAX_PAN_Y:Number = 1.5;
      
      protected static const AXIS_ROTATE_MULT:Number = 2;
      
      protected static const AXIS_SCALE_MULT:Number = 0.2;
      
      protected static const AXIS_MOVE_MULT:Number = 0.2;
      
      protected static const AXIS_DEAD_ZONE:Number = 0.05;
      
      protected static const HIDE_INFO_DELAY:Number = 100;
      
      protected static const SHOW_INFO_DELAY:Number = 600;
      
      protected static const FADE_OUT_ALPHA = 0.3;
      
      protected static const FADE_OUT_X_OFFSET = 5;
       
      
      protected var _rendererSprite:MovieClip;
      
      protected var _defaultPosition:Point;
      
      protected var _centerPosition:Point;
      
      protected var _animationTime:Number;
      
      protected var _fadeOutComponents:Vector.<MovieClip>;
      
      protected var _fadeInComponent:Vector.<MovieClip>;
      
      protected var _currentRotationY:Number = 0;
      
      protected var _currentPositionY:Number = 0;
      
      protected var _currentScale:Number = 1;
      
      protected var _targetRotationY:Number = 0;
      
      protected var _targetPositionY:Number = 0;
      
      protected var _targetScale:Number = 1;
      
      protected var _deltaRotationY:Number = 0;
      
      protected var _deltaPositionY:Number = 0;
      
      protected var _deltaScale:Number = 1;
      
      protected var _timeStamp:int;
      
      protected var _isCentered:Boolean = false;
      
      protected var _isInTransitionToCenter:Boolean = false;
      
      protected var _isInTransitionToDefault:Boolean = false;
      
      protected var _hideInfoTimer:Timer;
      
      protected var _showInfoTimer:Timer;
      
      protected var _leftInfoPanelX:Number = 0;
      
      protected var _rightInfoPanelX:Number = 1420;
      
      protected var _leftInfoPanel:PlayerGeneralStatsPanel;
      
      protected var _rightInfoPanel:PlayerDetailedStatsPanel;
      
      protected var _enabled:Boolean = true;
      
      private var _btn_navigate:int = -1;
      
      private var _btn_rotate_gamepad:int = -1;
      
      private var _btn_rotate_mouse:int = -1;
      
      private var _btn_zoom:int = -1;
      
      private var _btn_pan_gamepad:int = -1;
      
      private var _btn_pan_mouse:int = -1;
      
      private var _mouseHitArea:Sprite;
      
      private var _menuRef:CoreMenu;
      
      public var inputDisabled:Boolean;
      
      private var _holdReceived:Boolean = false;
      
      internal const M_DISTANCE_KOEFF = 0.08;
      
      internal const M_WHEEL_KOEFF = 0.2;
      
      private var isDraggingMode:Boolean = false;
      
      private var isPanningMode:Boolean = false;
      
      private var mouse_dx:Number;
      
      private var mouse_dy:Number;
      
      private var cached_mouse_x:Number;
      
      private var cached_mouse_y:Number;
      
      private var _cursorChanged:Boolean = false;
      
      internal var tmpK:int = 0;
      
      public function CharacterRendererController(param1:MovieClip, param2:CoreMenu)
      {
         super();
         this._fadeOutComponents = new Vector.<MovieClip>();
         this._menuRef = param2;
         this._animationTime = DEFAULT_ANIMATION_DURATION;
         this._currentRotationY = this._targetRotationY = DEFAULT_ENTITY_ROTATION_Y;
         this._currentPositionY = this._targetPositionY = DEFAULT_ENTITY_POS_Y;
         this._currentScale = this._targetScale = DEFAULT_ENTITY_SCALE;
         var _loc3_:InputDelegate = InputDelegate.getInstance();
         this._rendererSprite = param1;
         if(this._rendererSprite)
         {
            this._rendererSprite.stage.removeEventListener(InputEvent.INPUT,this.handleInput,false);
            this._rendererSprite.stage.addEventListener(InputEvent.INPUT,this.handleInput,false,9,true);
         }
         this._mouseHitArea = CommonUtils.createSolidColorSprite(new Rectangle(0,1,600,1080),16711680,0);
         this.addMouseEvents(this._mouseHitArea);
         this._rendererSprite.dispatchEvent(new GameEvent(GameEvent.REGISTER,"inventory.player.stats",[this.setPlayerStats]));
      }
      
      public function isActive() : Boolean
      {
         return this._isInTransitionToCenter || this._isInTransitionToDefault || this._isCentered;
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         if(this._enabled != param1)
         {
            this._enabled = param1;
            if(!this.enabled && this.isCentered())
            {
               this.moveToDefault();
            }
         }
      }
      
      public function get leftInfoPanel() : PlayerGeneralStatsPanel
      {
         return this._leftInfoPanel;
      }
      
      public function set leftInfoPanel(param1:PlayerGeneralStatsPanel) : *
      {
         this._leftInfoPanel = param1;
         if(this._leftInfoPanel)
         {
            this._leftInfoPanel.visible = false;
            this._leftInfoPanelX = this._leftInfoPanel.x;
            this._leftInfoPanel.x = this._leftInfoPanelX - FADE_OUT_X_OFFSET;
            this._leftInfoPanel.mcStatsList.bSkipFocusCheck = true;
            this._leftInfoPanel.mcStatsList.focusable = false;
            this._leftInfoPanel.mcStatsList.selectOnOver = true;
            if(this._rightInfoPanel)
            {
               this._leftInfoPanel.dataSetterDelegate = this._rightInfoPanel.setData;
            }
         }
      }
      
      public function get rightInfoPanel() : PlayerDetailedStatsPanel
      {
         return this._rightInfoPanel;
      }
      
      public function set rightInfoPanel(param1:PlayerDetailedStatsPanel) : *
      {
         this._rightInfoPanel = param1;
         if(this._rightInfoPanel)
         {
            this._rightInfoPanel.visible = false;
            this._rightInfoPanelX = this._rightInfoPanel.x;
            this._rightInfoPanel.x = this._rightInfoPanelX + FADE_OUT_X_OFFSET;
            if(this._leftInfoPanel)
            {
               this._leftInfoPanel.dataSetterDelegate = this._rightInfoPanel.setData;
            }
         }
      }
      
      private function addMouseEvents(param1:Sprite) : void
      {
         param1.doubleClickEnabled = true;
         param1.addEventListener(MouseEvent.DOUBLE_CLICK,this.handleMouseDoubleClick,false,0,true);
         param1.addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseDown,false,0,true);
         param1.addEventListener(MouseEvent.MOUSE_WHEEL,this.handleMouseWheel,false,0,true);
         param1.addEventListener(MouseEvent.ROLL_OUT,this.handleMouseRollOut,false,0,true);
         param1.addEventListener(MouseEvent.ROLL_OVER,this.handleMouseRollOver,false,0,true);
         this._rendererSprite.stage.addEventListener(MouseEvent.MOUSE_UP,this.handleMouseUp,false,0,true);
         this._rendererSprite.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMouse,false,0,true);
      }
      
      private function removeMouseEvents(param1:Sprite) : void
      {
         param1.removeEventListener(MouseEvent.DOUBLE_CLICK,this.handleMouseDoubleClick,false);
         param1.removeEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseDown,false);
         param1.removeEventListener(MouseEvent.MOUSE_WHEEL,this.handleMouseWheel,false);
         param1.removeEventListener(MouseEvent.ROLL_OUT,this.handleMouseRollOut,false);
         param1.removeEventListener(MouseEvent.ROLL_OVER,this.handleMouseRollOver,false);
         this._rendererSprite.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMouse,false);
         this._rendererSprite.stage.removeEventListener(MouseEvent.MOUSE_UP,this.handleMouseUp,false);
      }
      
      public function addFadeOutComponent(param1:Sprite) : void
      {
         this._fadeOutComponents.push(param1);
      }
      
      public function setDefaultAnchor(param1:Number, param2:Number) : void
      {
         this._defaultPosition = new Point(param1,param2);
      }
      
      public function setCenterAnchor(param1:Number, param2:Number) : void
      {
         this._centerPosition = new Point(param1,param2);
      }
      
      public function isCentered() : Boolean
      {
         return this._isCentered;
      }
      
      public function moveToCenter() : void
      {
         this._rendererSprite.dispatchEvent(new GameEvent(GameEvent.CALL,"OnRequestStatsData",[]));
      }
      
      private function setPlayerStats(param1:Object) : void
      {
         var _loc2_:Object = {
            "alpha":1,
            "x":this._centerPosition.x,
            "y":this._centerPosition.y
         };
         var _loc3_:Number = Math.abs(this._centerPosition.x - this._rendererSprite.x) * this._animationTime / 1000;
         this.resetsTweens();
         GTweener.removeTweens(this._rendererSprite);
         GTweener.to(this._rendererSprite,this._animationTime,_loc2_,{
            "onComplete":this.onFadeOutComplete,
            "ease":Sine.easeOut
         });
         GTweener.removeTweens(this._rightInfoPanel);
         GTweener.removeTweens(this._leftInfoPanel);
         GTweener.to(this._rightInfoPanel,this._animationTime,{
            "x":this._rightInfoPanelX,
            "alpha":1
         },{"ease":Sine.easeOut});
         GTweener.to(this._leftInfoPanel,this._animationTime,{
            "x":this._leftInfoPanelX,
            "alpha":1
         },{"ease":Sine.easeOut});
         this._rightInfoPanel.visible = true;
         this._leftInfoPanel.visible = true;
         this._fadeOutComponents.forEach(this.fadeOutObj);
         this._isInTransitionToDefault = false;
         this._isInTransitionToCenter = true;
         this.leftInfoPanel.data = param1.stats;
         this.leftInfoPanel.focused = 1;
         this.rightInfoPanel.setTimeData(param1.hoursPlayed,param1.minutesPlayed);
         this._rendererSprite.dispatchEvent(new GameEvent(GameEvent.CALL,"OnPlaySoundEvent",["gui_ep2_character_submenu_in"]));
      }
      
      public function moveToDefault() : void
      {
         this.resetsTweens();
         var _loc1_:Object = {
            "alpha":1,
            "x":this._defaultPosition.x,
            "y":this._defaultPosition.y
         };
         var _loc2_:Number = Math.abs(this._defaultPosition.x - this._rendererSprite.x) * this._animationTime / 1000;
         GTweener.removeTweens(this._rendererSprite);
         GTweener.to(this._rendererSprite,this._animationTime,_loc1_,{
            "onComplete":this.onFadeInComplete,
            "ease":Sine.easeOut
         });
         GTweener.removeTweens(this._rightInfoPanel);
         GTweener.removeTweens(this._leftInfoPanel);
         GTweener.to(this._rightInfoPanel,this._animationTime,{
            "x":this._rightInfoPanelX + FADE_OUT_X_OFFSET,
            "alpha":0
         },{"ease":Sine.easeOut});
         GTweener.to(this._leftInfoPanel,this._animationTime,{
            "x":this._leftInfoPanelX - FADE_OUT_X_OFFSET,
            "alpha":0
         },{"ease":Sine.easeOut});
         this._fadeOutComponents.forEach(this.fadeInObj);
         this._isInTransitionToDefault = true;
         this._isInTransitionToCenter = false;
         this._rendererSprite.dispatchEvent(new GameEvent(GameEvent.CALL,"OnResetPlayerPosition",[]));
         this.resetCursorType();
         this.isDraggingMode = false;
         this.isPanningMode = false;
         this._leftInfoPanel.enabled = this._leftInfoPanel.mouseChildren = this._leftInfoPanel.mouseEnabled = true;
         this._menuRef.setMouseCursorVisibility(true);
         this._rendererSprite.dispatchEvent(new GameEvent(GameEvent.CALL,"OnPlaySoundEvent",["gui_ep2_character_submenu_out"]));
      }
      
      private function onFadeOutComplete(param1:GTween = null) : void
      {
         this._holdReceived = false;
         this._isInTransitionToCenter = false;
         this._isInTransitionToDefault = false;
         this._isCentered = true;
         this._rendererSprite.dispatchEvent(new GameEvent(GameEvent.CALL,"OnPlayerStatsShown",[]));
         this._rendererSprite.parent.addChild(this._mouseHitArea);
         this._mouseHitArea.x = (CommonUtils.getScreenRect().width - this._mouseHitArea.width) / 2;
         this._mouseHitArea.y = 100;
      }
      
      private function onFadeInComplete(param1:GTween = null) : void
      {
         this._holdReceived = false;
         this._isInTransitionToCenter = false;
         this._isInTransitionToDefault = false;
         this._isCentered = false;
         this._rightInfoPanel.visible = false;
         this._leftInfoPanel.visible = false;
         this._rendererSprite.dispatchEvent(new GameEvent(GameEvent.CALL,"OnPlayerStatsHidden",[]));
         this._rendererSprite.parent.removeChild(this._mouseHitArea);
      }
      
      private function activate() : void
      {
         if(this._btn_navigate == -1)
         {
            this._btn_navigate = InputFeedbackManager.appendButton(this._rendererSprite,NavigationCode.GAMEPAD_L3,-1,"panel_button_common_navigation");
         }
         if(this._btn_rotate_gamepad == -1)
         {
            this._btn_rotate_gamepad = InputFeedbackManager.appendButton(this._rendererSprite,NavigationCode.GAMEPAD_RSTICK_TAB,-1,"panel_button_common_rotate");
         }
         if(this._btn_rotate_mouse == -1)
         {
            this._btn_rotate_mouse = InputFeedbackManager.appendButton(this._rendererSprite,"",KeyCode.LEFT_MOUSE,"panel_button_common_rotate",true);
         }
         if(this._btn_zoom == -1)
         {
            this._btn_zoom = InputFeedbackManager.appendButton(this._rendererSprite,NavigationCode.GAMEPAD_RSTICK_SCROLL,-1,"panel_button_common_zoom");
         }
         if(this._btn_pan_gamepad == -1)
         {
            this._btn_pan_gamepad = InputFeedbackManager.appendButton(this._rendererSprite,NavigationCode.DPAD_UP_DOWN,-1,"input_navigation_pan_model");
         }
         if(this._btn_pan_mouse == -1)
         {
            this._btn_pan_mouse = InputFeedbackManager.appendButton(this._rendererSprite,"",KeyCode.RIGHT_MOUSE,"input_navigation_pan_model",true);
         }
         this._rendererSprite.dispatchEvent(new Event(Event.ACTIVATE));
      }
      
      private function deactivate() : void
      {
         if(this._btn_rotate_gamepad != -1)
         {
            InputFeedbackManager.removeButton(this._rendererSprite,this._btn_rotate_gamepad);
         }
         if(this._btn_rotate_mouse != -1)
         {
            InputFeedbackManager.removeButton(this._rendererSprite,this._btn_rotate_mouse);
         }
         if(this._btn_navigate != -1)
         {
            InputFeedbackManager.removeButton(this._rendererSprite,this._btn_navigate);
         }
         if(this._btn_zoom != -1)
         {
            InputFeedbackManager.removeButton(this._rendererSprite,this._btn_zoom);
         }
         if(this._btn_pan_gamepad != -1)
         {
            InputFeedbackManager.removeButton(this._rendererSprite,this._btn_pan_gamepad);
         }
         if(this._btn_pan_mouse != -1)
         {
            InputFeedbackManager.removeButton(this._rendererSprite,this._btn_pan_mouse);
         }
         this._btn_rotate_gamepad = -1;
         this._btn_rotate_mouse = -1;
         this._btn_navigate = -1;
         this._btn_zoom = -1;
         this._btn_pan_gamepad = -1;
         this._btn_pan_mouse = -1;
         this._rendererSprite.dispatchEvent(new Event(Event.DEACTIVATE));
      }
      
      public function handleInput(param1:InputEvent) : void
      {
         var _loc3_:InputAxisData = null;
         var _loc7_:* = new Namespace("");
         var _loc8_:Boolean = false;
         var _loc2_:InputDetails = param1.details;
         var _loc4_:Boolean = true;
         var _loc5_:* = _loc2_.value == InputValue.KEY_UP;
         var _loc6_:* = _loc2_.value == InputValue.KEY_DOWN;
         if(param1.handled || !this.enabled || this.inputDisabled)
         {
            return;
         }
         if(_loc2_.navEquivalent == NavigationCode.GAMEPAD_R2 && _loc2_.value == InputValue.KEY_HOLD && !this._isInTransitionToCenter && !this._isCentered)
         {
            this._holdReceived = true;
            this.moveToCenter();
            this.activate();
         }
         else if(_loc2_.navEquivalent == NavigationCode.GAMEPAD_R2 && _loc5_ && this._holdReceived && (this._isCentered || this._isInTransitionToCenter))
         {
            this._holdReceived = false;
            this.moveToDefault();
            this.deactivate();
         }
         else if(_loc2_.navEquivalent == NavigationCode.GAMEPAD_R2 && _loc5_ && (this._isCentered || this._isInTransitionToCenter))
         {
            this._holdReceived = false;
            this.moveToDefault();
            this.deactivate();
         }
         else if(_loc2_.navEquivalent == NavigationCode.GAMEPAD_R2 && _loc5_ && (!this._isCentered || this._isInTransitionToDefault))
         {
            this._holdReceived = false;
            this.moveToCenter();
            this.activate();
         }
         else if(!this._isCentered && _loc5_ && _loc2_.code == KeyCode.C && !this._isInTransitionToCenter)
         {
            this._holdReceived = false;
            this.moveToCenter();
            this.activate();
         }
         else if(this._isCentered && _loc5_ && (_loc2_.code == KeyCode.C || _loc2_.navEquivalent == NavigationCode.GAMEPAD_B) && !this._isInTransitionToDefault)
         {
            this._holdReceived = false;
            this.moveToDefault();
            this.deactivate();
            param1.handled = true;
            param1.stopImmediatePropagation();
         }
         else if(!this._isCentered)
         {
            return;
         }
         if(!this._isInTransitionToDefault && !this._isInTransitionToCenter && this._isCentered)
         {
            _loc7_ = 1;
            _loc8_ = false;
            if(_loc2_.navEquivalent == NavigationCode.DPAD_UP && _loc6_)
            {
               this._rendererSprite.dispatchEvent(new GameEvent(GameEvent.CALL,"OnChangeCharRenderFocus",[false]));
               _loc8_ = true;
            }
            else if(_loc2_.navEquivalent == NavigationCode.DPAD_DOWN && _loc6_)
            {
               this._rendererSprite.dispatchEvent(new GameEvent(GameEvent.CALL,"OnChangeCharRenderFocus",[true]));
               _loc8_ = true;
            }
            else if(_loc2_.navEquivalent == NavigationCode.DPAD_LEFT)
            {
               this._rendererSprite.dispatchEvent(new GameEvent(GameEvent.CALL,"OnPlayAnimation",[0]));
               param1.handled = true;
               param1.stopImmediatePropagation();
            }
            else if(_loc2_.navEquivalent == NavigationCode.DPAD_RIGHT)
            {
               this._rendererSprite.dispatchEvent(new GameEvent(GameEvent.CALL,"OnPlayAnimation",[1]));
               param1.handled = true;
               param1.stopImmediatePropagation();
            }
            else if(_loc2_.code == KeyCode.PAD_RIGHT_STICK_AXIS)
            {
               _loc3_ = InputAxisData(_loc2_.value);
               if(Math.abs(_loc3_.yvalue) > AXIS_DEAD_ZONE)
               {
                  this._rendererSprite.dispatchEvent(new GameEvent(GameEvent.CALL,"OnScaleCharRenderer",[_loc3_.yvalue,true]));
                  _loc8_ = true;
               }
               if(Math.abs(_loc3_.xvalue) > AXIS_DEAD_ZONE)
               {
                  this._rendererSprite.dispatchEvent(new GameEvent(GameEvent.CALL,"OnRotateCharRenderer",[-_loc3_.xvalue]));
                  _loc8_ = true;
               }
            }
            else
            {
               if(_loc2_.fromJoystick)
               {
                  this.leftInfoPanel.mcStatsList.handleInput(param1);
               }
               param1.handled = true;
               param1.stopImmediatePropagation();
            }
            if(_loc8_)
            {
               param1.handled = true;
               param1.stopImmediatePropagation();
            }
         }
      }
      
      private function handleMouseRollOver(param1:MouseEvent) : void
      {
         if(!this._cursorChanged && this._isCentered && !this._isInTransitionToDefault && !this._isInTransitionToCenter)
         {
            this._menuRef.setMouseCursorType(CursorType.ROTATE);
            this._cursorChanged = true;
         }
      }
      
      private function handleMouseRollOut(param1:MouseEvent) : void
      {
         this.resetCursorType();
      }
      
      private function resetCursorType() : void
      {
         if(this._cursorChanged)
         {
            this._menuRef.setMouseCursorType(CursorType.DEFAULT);
            this._cursorChanged = false;
         }
      }
      
      private function handleMouseDown(param1:MouseEvent) : void
      {
         var _loc2_:MouseEventEx = null;
         var _loc3_:Boolean = false;
         var _loc4_:Rectangle = null;
         if(!this._isInTransitionToDefault && !this._isInTransitionToCenter && this._isCentered)
         {
            _loc2_ = param1 as MouseEventEx;
            _loc3_ = Boolean(_loc2_) && _loc2_.buttonIdx == MouseEventEx.RIGHT_BUTTON;
            this.isDraggingMode = !_loc3_;
            this.isPanningMode = _loc3_;
            this.mouse_dx = param1.stageX;
            this.mouse_dy = param1.stageY;
            this._leftInfoPanel.enabled = this._leftInfoPanel.mouseChildren = this._leftInfoPanel.mouseEnabled = false;
            this._menuRef.setMouseCursorVisibility(false);
            _loc4_ = CommonUtils.getScreenRect();
            this.cached_mouse_x = (param1.stageX + _loc4_.x) / _loc4_.width;
            this.cached_mouse_y = (param1.stageY + _loc4_.y) / _loc4_.height;
         }
      }
      
      private function handleMouseUp(param1:MouseEvent = null) : void
      {
         if(!this._isInTransitionToDefault && !this._isInTransitionToCenter && this._isCentered && (this.isDraggingMode || this.isPanningMode))
         {
            this.isDraggingMode = false;
            this.isPanningMode = false;
            this._leftInfoPanel.enabled = this._leftInfoPanel.mouseChildren = this._leftInfoPanel.mouseEnabled = true;
            this._menuRef.moveMouseCursor(this.cached_mouse_x,this.cached_mouse_y);
            this.tmpK = 2;
            this._menuRef.removeEventListener(Event.ENTER_FRAME,this.handleEnterMouseVisibilityValidation,false);
            this._menuRef.addEventListener(Event.ENTER_FRAME,this.handleEnterMouseVisibilityValidation,false,0,true);
         }
      }
      
      private function handleEnterMouseVisibilityValidation(param1:Event) : void
      {
         if(this.tmpK < 0)
         {
            this._menuRef.removeEventListener(Event.ENTER_FRAME,this.handleEnterMouseVisibilityValidation,false);
            this._menuRef.setMouseCursorVisibility(true);
         }
         --this.tmpK;
      }
      
      private function handleMouseMouse(param1:MouseEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         if(!this._isInTransitionToDefault && !this._isInTransitionToCenter && this._isCentered && (this.isDraggingMode || this.isPanningMode))
         {
            if(this.isDraggingMode)
            {
               _loc2_ = this.mouse_dx - param1.stageX;
               _loc3_ = 1;
               this._rendererSprite.dispatchEvent(new GameEvent(GameEvent.CALL,"OnRotateCharRenderer",[_loc3_ * _loc2_ * this.M_DISTANCE_KOEFF]));
            }
            else if(this.isPanningMode)
            {
               _loc2_ = this.mouse_dy - param1.stageY;
               _loc3_ = 1;
               this._rendererSprite.dispatchEvent(new GameEvent(GameEvent.CALL,"OnMoveCharRenderer",[_loc3_ * _loc2_ * this.M_DISTANCE_KOEFF]));
            }
            this.mouse_dx = param1.stageX;
            this.mouse_dy = param1.stageY;
         }
      }
      
      private function handleMouseWheel(param1:MouseEvent) : void
      {
         if(!this._isInTransitionToDefault && !this._isInTransitionToCenter && this._isCentered)
         {
            this._rendererSprite.dispatchEvent(new GameEvent(GameEvent.CALL,"OnScaleCharRenderer",[param1.delta * this.M_WHEEL_KOEFF,false]));
         }
      }
      
      private function handleMouseDoubleClick(param1:MouseEvent) : void
      {
         this._rendererSprite.dispatchEvent(new GameEvent(GameEvent.CALL,"OnResetPlayerPosition",[]));
      }
      
      private function resetsTweens() : void
      {
         GTweener.removeTweens(this._rendererSprite);
         this._fadeOutComponents.forEach(this.stopTweenOnObj);
      }
      
      private function stopTweenOnObj(param1:DisplayObject) : void
      {
         if(param1)
         {
            GTweener.removeTweens(param1);
         }
      }
      
      private function fadeOutObj(param1:DisplayObject) : void
      {
         var _loc2_:InputFeedbackButton = null;
         if(param1)
         {
            _loc2_ = param1 as InputFeedbackButton;
            if(_loc2_)
            {
               GTweener.to(param1,this._animationTime,{"alpha":0},{"ease":Sine.easeOut});
               _loc2_.enabled = false;
            }
            else
            {
               GTweener.to(param1,this._animationTime,{"alpha":0},{"ease":Sine.easeOut});
            }
         }
      }
      
      private function fadeInObj(param1:DisplayObject) : void
      {
         var _loc2_:InputFeedbackButton = null;
         if(param1)
         {
            _loc2_ = param1 as InputFeedbackButton;
            if(_loc2_)
            {
               GTweener.to(param1,this._animationTime,{"alpha":1},{});
               _loc2_.enabled = true;
            }
            else
            {
               GTweener.to(param1,this._animationTime,{"alpha":1},{});
            }
         }
      }
   }
}
