package red.core
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Exponential;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.ui.Mouse;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.MouseCursor;
   import red.game.witcher3.events.ControllerChangeEvent;
   import red.game.witcher3.events.ItemDragEvent;
   import red.game.witcher3.managers.ContextInfoManager;
   import red.game.witcher3.managers.InputFeedbackManager;
   import red.game.witcher3.managers.RuntimeAssetsManager;
   import red.game.witcher3.slots.SlotsTransferManager;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.managers.InputDelegate;
   import scaleform.clik.ui.InputDetails;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.InteractiveObjectEx;
   
   public class CoreMenu extends CoreComponent
   {
      
      public static const CURRENT_MODULE_INVALIDATE:String = "Core.Menu.Current.Module.Invalidate";
      
      protected static var SHOW_ANIM_DURATION:Number = 0.8;
      
      protected static var SHOW_ANIM_OFFSET:Number = 500;
       
      
      protected var _modules:Vector.<CoreMenuModule>;
      
      protected var _mouseCursor:MouseCursor;
      
      protected var _dragCanvas:Sprite;
      
      protected var _dragManager:SlotsTransferManager;
      
      protected var _disableShowAnimation:Boolean;
      
      protected var _enableMouse:Boolean;
      
      protected var _overlayCanvas:MovieClip;
      
      protected var _contextMgr:ContextInfoManager;
      
      protected var _assetsMgr:RuntimeAssetsManager;
      
      protected var _currentModuleIdx:int;
      
      private var _currentModule:CoreMenuModule = null;
      
      protected var upToCloseEnabled:Boolean = false;
      
      protected var closingMenu:Boolean = false;
      
      public var _lastMoveWasMouse:Boolean = false;
      
      protected var _currentMenuState:String;
      
      protected var _restrictDirectClosing:Boolean;
      
      protected var actualModules:Vector.<CoreMenuModule>;
      
      public var mcBackground:MovieClip;
      
      protected var _inCombat:Boolean = false;
      
      private var _moduleChangeInputFeedback:int = -1;
      
      private var _initialPanelXOffset:int = 0;
      
      protected var _loadAssets:Boolean = true;
      
      private var _blackBackground:Sprite;
      
      public function CoreMenu()
      {
         this._modules = new Vector.<CoreMenuModule>();
         this.actualModules = new Vector.<CoreMenuModule>();
         super();
         this.initManagers();
         if(!this._disableShowAnimation)
         {
            visible = false;
         }
      }
      
      public function setInCombat(param1:Boolean) : void
      {
         this._inCombat = param1;
      }
      
      public function setMenuState(param1:String) : void
      {
         this._currentMenuState = param1;
      }
      
      public function setColorBlindMode(param1:Boolean) : void
      {
         isColorBlindMode = param1;
      }
      
      public function setRestrictDirectClosing(param1:Boolean) : void
      {
         this._restrictDirectClosing = param1;
      }
      
      public function setBackgroundEffect(param1:Boolean) : void
      {
         if(this._blackBackground)
         {
            removeChild(this._blackBackground);
            this._blackBackground = null;
         }
         if(param1)
         {
            this._blackBackground = CommonUtils.createFullscreenSprite(0,0.75);
            this.addChild(this._blackBackground);
         }
      }
      
      private function initManagers() : void
      {
         if(this._loadAssets)
         {
            this._assetsMgr = RuntimeAssetsManager.getInstanse();
            this._assetsMgr.loadLibrary();
         }
         this._contextMgr = ContextInfoManager.getInstanse();
      }
      
      override public function addChild(param1:DisplayObject) : DisplayObject
      {
         var _loc2_:DisplayObject = super.addChild(param1);
         if(param1 != this._overlayCanvas && param1 != this._blackBackground && Boolean(this._overlayCanvas))
         {
            super.addChild(this._overlayCanvas);
         }
         return _loc2_;
      }
      
      public function selectTargetModule(param1:CoreMenuModule) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         _loc3_ = int(this._modules.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this._modules[_loc2_] == param1)
            {
               this.currentModuleIdx = _loc2_;
               return;
            }
            _loc2_++;
         }
      }
      
      public function get currentModuleIdx() : int
      {
         return this._currentModuleIdx;
      }
      
      public function set currentModuleIdx(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc6_:CoreMenuModule = null;
         if(this._modules.length < 1)
         {
            return;
         }
         this.actualModules.length = 0;
         _loc2_ = 0;
         while(_loc2_ < this._modules.length)
         {
            if((_loc6_ = this._modules[_loc2_]).enabled && _loc6_.hasSelectableItems())
            {
               this.actualModules.push(_loc6_);
            }
            _loc2_++;
         }
         if(this.actualModules.length == 0)
         {
            this._currentModuleIdx = -1;
            if(this._currentModule != null)
            {
               this._currentModule.focused = 0;
               this._currentModule = null;
            }
            return;
         }
         var _loc3_:int = -1;
         var _loc4_:int = param1;
         _loc2_ = 0;
         while(_loc2_ < this.actualModules.length)
         {
            if(this.actualModules[_loc2_] == this._currentModule)
            {
               _loc3_ = _loc2_;
            }
            _loc2_++;
         }
         if(_loc3_ != this._currentModuleIdx && _loc3_ != -1)
         {
            if(param1 < this._currentModuleIdx)
            {
               _loc4_ = _loc3_ - 1;
            }
            else if(param1 > this._currentModuleIdx)
            {
               _loc4_ = _loc3_ + 1;
            }
         }
         _loc4_ = Math.max(0,Math.min(this.actualModules.length - 1,_loc4_));
         var _loc5_:CoreMenuModule;
         if((_loc5_ = this.actualModules[_loc4_]) != null && _loc5_ != this._currentModule)
         {
            if(this._currentModule != null)
            {
               this._currentModule.focused = 0;
            }
            if(_loc5_ != null)
            {
               _loc5_.focused = 1;
            }
            this._currentModule = _loc5_;
            this._currentModuleIdx = _loc4_;
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnModuleSelected",[this._currentModuleIdx,_loc5_.dataBindingKey]));
         }
      }
      
      override protected function onCoreInit() : void
      {
         this.registerMenu();
         this.initModules();
      }
      
      override protected function configUI() : void
      {
         if(this.mcBackground)
         {
            if(this.mcBackground.mcIcon)
            {
               this.mcBackground.mcIcon.gotoAndStop(this.menuName);
            }
         }
         super.configUI();
         this.ShowSecondaryModules(false);
         this._overlayCanvas = new MovieClip();
         this._overlayCanvas.mouseChildren = this._overlayCanvas.mouseEnabled = false;
         this.addChild(this._overlayCanvas);
         this._contextMgr.init(this._overlayCanvas,_inputMgr);
         this.initDragSurface();
         if(this._enableMouse)
         {
            this._mouseCursor = new MouseCursor(this._overlayCanvas);
         }
         tabEnabled = false;
         tabChildren = false;
         if(Extensions.isScaleform)
         {
            Mouse.hide();
         }
         InputDelegate.getInstance().addEventListener(InputEvent.INPUT,this.checkForNavType,false,100,true);
         stage.addEventListener(InputEvent.INPUT,this.handleInputNavigate,false,-10,true);
         stage.addEventListener(CURRENT_MODULE_INVALIDATE,this.handleInitialDataSet,false,0,true);
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMove,false,100,true);
         _inputMgr.addEventListener(ControllerChangeEvent.CONTROLLER_CHANGE,this.handleControllerChanged,false,0,true);
         addEventListener(Event.ENTER_FRAME,this.handleEnterFrame,false,0,true);
         if(!this._disableShowAnimation)
         {
            this.showAnimation();
         }
      }
      
      public function setTooltipState(param1:Boolean, param2:Boolean) : void
      {
         if(this._contextMgr)
         {
            this._contextMgr.setInitialState(param1,param2);
         }
      }
      
      public function ShowSecondaryModules(param1:Boolean) : *
      {
         if(this.mcBackground)
         {
            if(this.mcBackground.mcIcon)
            {
               this.mcBackground.mcIcon.visible = !param1;
            }
         }
      }
      
      protected function handleEnterFrame(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.handleEnterFrame);
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnMenuShown"));
      }
      
      protected function showAnimation() : void
      {
         visible = true;
         y = SHOW_ANIM_OFFSET;
         alpha = 0;
         GTweener.to(this,SHOW_ANIM_DURATION,{
            "y":0,
            "alpha":1
         },{
            "ease":Exponential.easeOut,
            "onComplete":this.handleShowAnimComplete
         });
      }
      
      protected function hideAnimation() : void
      {
         if(!this.closingMenu)
         {
            GTweener.removeTweens(this);
            GTweener.to(this,0.3,{
               "y":200,
               "alpha":0
            },{
               "ease":Exponential.easeOut,
               "onComplete":this.handleHideAnimComplete
            });
            this.closingMenu = true;
         }
      }
      
      protected function handleHideAnimComplete(param1:GTween) : void
      {
         this.closeMenu();
         this.closingMenu = false;
      }
      
      protected function handleShowAnimComplete(param1:GTween) : void
      {
         addEventListener(Event.ENTER_FRAME,this.handleEnterFrame,false,0,true);
      }
      
      public function SetInitialPanelXOffset(param1:int) : *
      {
         var _loc2_:MovieClip = null;
         this._initialPanelXOffset = param1;
         visible = true;
         var _loc3_:int = 0;
         while(_loc3_ < numChildren)
         {
            _loc2_ = getChildAt(_loc3_) as MovieClip;
            _loc2_.x += this._initialPanelXOffset;
            _loc3_++;
         }
         GTweener.removeTweens(this);
         GTweener.to(this,SHOW_ANIM_DURATION,{"alpha":1},{
            "ease":Exponential.easeOut,
            "onComplete":this.handleShowAnimComplete
         });
      }
      
      protected function initDragSurface() : void
      {
         this._dragCanvas = new Sprite();
         this.addChild(this._dragCanvas);
         InteractiveObjectEx.setTopmostLevel(this._dragCanvas,true);
         InteractiveObjectEx.setHitTestDisable(this._dragCanvas,true);
         this._dragManager = SlotsTransferManager.getInstance();
         this._dragManager.init(this._dragCanvas);
         this._dragManager.addEventListener(ItemDragEvent.START_DRAG,this.handleStartDrag,false,0,true);
         this._dragManager.addEventListener(ItemDragEvent.STOP_DRAG,this.handleStopDrag,false,0,true);
      }
      
      protected function handleStartDrag(param1:ItemDragEvent) : void
      {
         if(this._mouseCursor)
         {
            this._mouseCursor.visible = false;
         }
      }
      
      protected function handleStopDrag(param1:ItemDragEvent) : void
      {
         if(this._mouseCursor)
         {
            this._mouseCursor.visible = true;
         }
      }
      
      protected function handleControllerChanged(param1:ControllerChangeEvent) : void
      {
         var _loc2_:int = 0;
         if(!param1.isGamepad)
         {
            if(this._modules.length > 0 && Boolean(this._modules[0].mcHighlight))
            {
               this._modules[0].mcHighlight.highlighted = true;
            }
            _loc2_ = 1;
            while(_loc2_ < this._modules.length)
            {
               if(this._modules[_loc2_].mcHighlight)
               {
                  this._modules[_loc2_].mcHighlight.highlighted = false;
               }
               _loc2_++;
            }
         }
         if(this._lastMoveWasMouse && param1.isGamepad)
         {
            this._lastMoveWasMouse = false;
            this.onLastMoveStatusChanged();
         }
      }
      
      protected function handleInputNavigate(param1:InputEvent) : void
      {
         super.handleInput(param1);
         var _loc2_:InputDetails = param1.details;
         var _loc3_:Boolean = _loc2_.value == InputValue.KEY_DOWN || _loc2_.value == InputValue.KEY_HOLD;
         var _loc4_:* = _loc2_.value == InputValue.KEY_UP;
         if(!param1.handled)
         {
            if(_loc4_ && !this._restrictDirectClosing)
            {
               switch(_loc2_.navEquivalent)
               {
                  case NavigationCode.ESCAPE:
                  case NavigationCode.GAMEPAD_B:
                     if(!_enableInputValidation || (isNavEquivalentValid(_loc2_.navEquivalent) || isKeyCodeValid(_loc2_.code)))
                     {
                        this.hideAnimation();
                        param1.handled = true;
                        param1.stopImmediatePropagation();
                     }
                     return;
               }
            }
            if(_loc3_)
            {
               CommonUtils.convertWASDCodeToNavEquivalent(_loc2_);
               switch(_loc2_.navEquivalent)
               {
                  case NavigationCode.LEFT:
                     --this.currentModuleIdx;
                     break;
                  case NavigationCode.RIGHT:
                     ++this.currentModuleIdx;
                     break;
                  case NavigationCode.UP:
                     if(this.upToCloseEnabled && _loc2_.value != InputValue.KEY_HOLD)
                     {
                        param1.handled = true;
                        this.hideAnimation();
                        return;
                     }
               }
            }
            if(_loc2_.value == InputValue.KEY_DOWN)
            {
               switch(_loc2_.navEquivalent)
               {
                  case NavigationCode.RIGHT_STICK_LEFT:
                     --this.currentModuleIdx;
                     break;
                  case NavigationCode.RIGHT_STICK_RIGHT:
                     ++this.currentModuleIdx;
               }
            }
         }
      }
      
      protected function checkForNavType(param1:InputEvent) : void
      {
         var _loc2_:InputDetails = param1.details;
         CommonUtils.convertWASDCodeToNavEquivalent(_loc2_);
         if(this._lastMoveWasMouse && (_loc2_.navEquivalent == NavigationCode.LEFT || _loc2_.navEquivalent == NavigationCode.RIGHT || _loc2_.navEquivalent == NavigationCode.UP || _loc2_.navEquivalent == NavigationCode.DOWN))
         {
            this._lastMoveWasMouse = false;
            this.onLastMoveStatusChanged();
         }
      }
      
      protected function handleInitialDataSet(param1:Event) : void
      {
         this.currentModuleIdx = 0;
      }
      
      protected function closeMenu() : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnCloseMenu"));
      }
      
      public function moveMouseCursor(param1:Number, param2:Number) : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnMoveMouseTo",[param1,param2]));
      }
      
      public function setMouseCursorVisibility(param1:Boolean) : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnSetMouseCursorVisibility",[param1]));
      }
      
      public function setMouseCursorType(param1:int) : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnSetMouseCursorType",[param1]));
      }
      
      private function registerMenu() : void
      {
         if(Extensions.isScaleform)
         {
            ExternalInterface.call("registerMenu",this.menuName,this);
         }
      }
      
      private function initModules() : void
      {
         var _loc1_:int = numChildren;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            this.initModule(getChildAt(_loc2_) as CoreMenuModule);
            _loc2_++;
         }
         this._modules.sort(this.sortModules);
      }
      
      private function initModule(param1:CoreMenuModule) : *
      {
         if(!param1)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._modules.length)
         {
            if(this._modules[_loc2_] == param1)
            {
               return;
            }
            _loc2_++;
         }
         this._modules.push(param1);
         param1.addEventListener(Event.ACTIVATE,this.handleModuleActivated,false,0,true);
         param1.addEventListener(Event.DEACTIVATE,this.handleModuleDeactivated,false,0,true);
         param1.addEventListener(CoreMenuModule.EVENT_MOUSE_FOCUSE,this.handleModuleMouseFocuse,false,0,true);
      }
      
      public function initModuleDynamically(param1:CoreMenuModule) : *
      {
         this.initModule(param1);
         this._modules.sort(this.sortModules);
      }
      
      override public function setArabicAligmentMode(param1:Boolean) : void
      {
         super.setArabicAligmentMode(param1);
         this._contextMgr.isArabicAligmentMode = param1;
      }
      
      protected function handleModuleMouseFocuse(param1:Event) : void
      {
         var _loc2_:CoreMenuModule = param1.currentTarget as CoreMenuModule;
         if(_loc2_)
         {
            this.selectTargetModule(_loc2_);
         }
      }
      
      private function handleModuleActivated(param1:Event) : void
      {
      }
      
      private function handleModuleDeactivated(param1:Event) : void
      {
      }
      
      protected function updateModuleChangeInputFeedback() : void
      {
         var _loc1_:int = int(this._modules.length);
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            if(this._modules[_loc3_].enabled)
            {
               _loc2_++;
            }
            if(_loc2_ > 1)
            {
               if(this._moduleChangeInputFeedback < 0)
               {
                  this._moduleChangeInputFeedback = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_R3,-1,"panel_button_common_change_selection");
                  InputFeedbackManager.updateButtons(this);
                  return;
               }
            }
            _loc3_++;
         }
         if(this._moduleChangeInputFeedback > 0)
         {
            InputFeedbackManager.removeButton(this,this._moduleChangeInputFeedback);
            InputFeedbackManager.updateButtons(this);
            this._moduleChangeInputFeedback = -1;
         }
      }
      
      private function sortModules(param1:CoreMenuModule, param2:CoreMenuModule) : Number
      {
         return param1.x > param2.x ? 1 : -1;
      }
      
      public function getMenuName() : String
      {
         return this.menuName;
      }
      
      protected function get menuName() : String
      {
         throw new Error("Override this");
      }
      
      public function setCurrentModule(param1:int) : void
      {
         this.currentModuleIdx = param1;
      }
      
      override public function toString() : String
      {
         return "CoreMenu [ " + this.name + "; " + this.menuName + " ]";
      }
      
      protected function onLastMoveStatusChanged() : *
      {
      }
      
      protected function handleMouseMove(param1:MouseEvent) : void
      {
         if(!this._lastMoveWasMouse)
         {
            this._lastMoveWasMouse = true;
            this.onLastMoveStatusChanged();
         }
      }
      
      public function enableDebugInput() : *
      {
         InputDelegate.getInstance().addEventListener(InputEvent.INPUT,this.handleDebugInput,false,1000,true);
      }
      
      public function handleDebugInput(param1:InputEvent) : *
      {
      }
   }
}
