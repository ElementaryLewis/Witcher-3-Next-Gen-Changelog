package red.game.witcher3.managers
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Exponential;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.data.TooltipData;
   import red.game.witcher3.events.ControllerChangeEvent;
   import red.game.witcher3.events.GridEvent;
   import red.game.witcher3.tooltips.TooltipBase;
   import red.game.witcher3.tooltips.TooltipInventory;
   import red.game.witcher3.tooltips.TooltipStatistic;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.managers.InputDelegate;
   import scaleform.clik.ui.InputDetails;
   import scaleform.gfx.MouseEventEx;
   
   public class ContextInfoManager extends EventDispatcher
   {
      
      public static const EVENT_TOOLTIP_HIDDEN:String = "EVENT_TOOLTIP_HIDDEN";
      
      public static const EVENT_TOOLTIP_SHOWN:String = "EVENT_TOOLTIP_SHOWN";
      
      private static const COLLAPSED_TOOLTIP_ICON_REF:String = "IcoTooltipCollapsedRef";
      
      public static var TOOLTIPS_DELAY:Number = 450;
      
      public static var TOOLTIPS_DELAY_MOUSE:Number = 450;
      
      public static const TOOLTIP_SHOW_ERROR:String = "FailedToSetTooltip";
      
      protected static const SHOW_ANIM_DURATION:Number = 0.8;
      
      protected static const HIDE_ANIM_DURATION:Number = 0.8;
      
      protected static var _instanse:ContextInfoManager;
       
      
      protected var _holdTriggered:Boolean = false;
      
      protected var _upscaleMePlease:Boolean = false;
      
      public const MAX_ZOOM:Number = 1.3;
      
      public const NORMAL_SCALE:Number = 1;
      
      public var saveScaleValue:Boolean = true;
      
      public var blockModeSwitching:Boolean = false;
      
      public var isArabicAligmentMode:Boolean;
      
      public var _DBG_LOCK_MOUSE_TOOLTIP:Boolean = true;
      
      public var dataSetterCallback:Function;
      
      public var handleTooltipVisibilityToggled:Function;
      
      private var _rootCanvas:Sprite;
      
      private var _tooltipTimer:Timer;
      
      protected var _tooltip:TooltipBase;
      
      protected var _data:TooltipData;
      
      protected var _pospondedData:TooltipData;
      
      protected var _pospondedKeyValue:Array;
      
      protected var _initialized:Boolean;
      
      protected var _inputMgr:InputManager;
      
      protected var _defaultAnchor:DisplayObject;
      
      protected var _comparisonMode:Boolean;
      
      protected var _overridedMouseDataSource:String;
      
      private var _blocked:Boolean;
      
      private var _isHiddenState:Boolean;
      
      private var _enableInputFeedback:Boolean;
      
      private var _btn_zoom_tooltip_kb:int = -1;
      
      private var _btn_zoom_tooltip_gp:int = -1;
      
      private var _btn_show_tooltip:int = -1;
      
      private var _btn_hide_tooltip:int = -1;
      
      protected var _gridEventsMouseOnly:Boolean;
      
      protected var bufGridEvent:GridEvent;
      
      public function ContextInfoManager()
      {
         super();
      }
      
      public static function getInstanse() : ContextInfoManager
      {
         if(!_instanse)
         {
            _instanse = new ContextInfoManager();
         }
         return _instanse;
      }
      
      public function blockTooltips(param1:Boolean, param2:Boolean = false) : void
      {
         if(this._blocked != param1)
         {
            this._blocked = param1;
            if(this._tooltip)
            {
               if(param2)
               {
                  this.removeCurrentTooltip();
               }
               else
               {
                  this._tooltip.visible = !param1;
               }
            }
         }
      }
      
      public function enableInputFeedbackShowing(param1:Boolean, param2:Boolean = false) : void
      {
         this._enableInputFeedback = param1;
         this.handleTooltipToggled(param2);
      }
      
      public function isHidden() : Boolean
      {
         return this._isHiddenState;
      }
      
      public function setHiddenState(param1:Boolean) : void
      {
         if(this._isHiddenState != param1)
         {
            this._isHiddenState = param1;
            this.handleTooltipToggled();
            if(this._tooltip)
            {
               this._tooltip.setVisibility(!param1);
            }
            if(this.handleTooltipVisibilityToggled != null)
            {
               this.handleTooltipVisibilityToggled(!this._isHiddenState);
            }
            if(this._isHiddenState)
            {
               dispatchEvent(new Event(ContextInfoManager.EVENT_TOOLTIP_HIDDEN));
            }
            else
            {
               dispatchEvent(new Event(ContextInfoManager.EVENT_TOOLTIP_SHOWN));
            }
         }
      }
      
      public function init(param1:Sprite, param2:InputManager) : void
      {
         this._inputMgr = param2;
         this._inputMgr.addEventListener(ControllerChangeEvent.CONTROLLER_CHANGE,this.handleControllerChange,false,0,true);
         InputDelegate.getInstance().addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
         this._rootCanvas = param1;
         this._rootCanvas.dispatchEvent(new GameEvent(GameEvent.REGISTER,"context.tooltip.data",[this.dataReceiver]));
         this._rootCanvas.dispatchEvent(new GameEvent(GameEvent.REGISTER,"statistic.tooltip.data",[this.dataReceiverStat]));
         this._rootCanvas.addEventListener(Event.ENTER_FRAME,this.handleCanvasTick,false,0,true);
         this._rootCanvas.stage.addEventListener(MouseEvent.CLICK,this.handleMouseClick,false,0,true);
         this.handleTooltipToggled();
      }
      
      public function get defaultAnchor() : DisplayObject
      {
         return this._defaultAnchor;
      }
      
      public function set defaultAnchor(param1:DisplayObject) : void
      {
         this._defaultAnchor = param1;
      }
      
      public function get comparisonMode() : Boolean
      {
         return this._comparisonMode;
      }
      
      public function set comparisonMode(param1:Boolean) : void
      {
         if(this._comparisonMode != param1)
         {
            this._comparisonMode = param1;
            this.updateComparisonMode();
         }
      }
      
      public function get overridedMouseDataSource() : String
      {
         return this._overridedMouseDataSource;
      }
      
      public function set overridedMouseDataSource(param1:String) : void
      {
         this._overridedMouseDataSource = param1;
      }
      
      protected function updateComparisonMode() : void
      {
         var _loc1_:TooltipInventory = this._tooltip as TooltipInventory;
         if(_loc1_)
         {
            _loc1_.showEquippedTooltip(this.comparisonMode);
         }
      }
      
      protected function handleCanvasTick(param1:Event) : void
      {
         this._initialized = true;
         this._rootCanvas.removeEventListener(Event.ENTER_FRAME,this.handleCanvasTick);
         if(Boolean(this._pospondedData) && Boolean(this._pospondedKeyValue))
         {
            this.showTooltip(this._pospondedKeyValue,this._pospondedData);
            this._pospondedData = null;
            this._pospondedKeyValue = null;
         }
      }
      
      public function handleTooltipToggled(param1:Boolean = false) : void
      {
         if(!this._rootCanvas)
         {
            return;
         }
         if(this._enableInputFeedback)
         {
            if(!this._isHiddenState)
            {
               if(this._btn_show_tooltip == -1)
               {
                  this._btn_show_tooltip = InputFeedbackManager.appendButton(this._rootCanvas,NavigationCode.GAMEPAD_LSTICK_HOLD,-1,"input_tooltip_hide");
               }
               if(this._btn_hide_tooltip != -1)
               {
                  InputFeedbackManager.removeButton(this._rootCanvas,this._btn_hide_tooltip);
                  this._btn_hide_tooltip = -1;
               }
            }
            else
            {
               if(this._btn_hide_tooltip == -1)
               {
                  this._btn_hide_tooltip = InputFeedbackManager.appendButton(this._rootCanvas,NavigationCode.GAMEPAD_LSTICK_HOLD,-1,"input_tooltip_show");
               }
               if(this._btn_show_tooltip != -1)
               {
                  InputFeedbackManager.removeButton(this._rootCanvas,this._btn_show_tooltip);
                  this._btn_show_tooltip = -1;
               }
            }
            if(this._btn_zoom_tooltip_gp == -1)
            {
               this._btn_zoom_tooltip_gp = InputFeedbackManager.appendButton(this._rootCanvas,NavigationCode.GAMEPAD_LSTICK_HOLD,-1,"input_tooltip_zoom",true);
            }
            if(this._btn_zoom_tooltip_kb == -1)
            {
               this._btn_zoom_tooltip_kb = InputFeedbackManager.appendButton(this._rootCanvas,"",KeyCode.MIDDLE_MOUSE,"input_tooltip_zoom");
            }
         }
         else
         {
            if(this._btn_zoom_tooltip_kb != -1)
            {
               InputFeedbackManager.removeButton(this._rootCanvas,this._btn_zoom_tooltip_kb);
               this._btn_zoom_tooltip_kb = -1;
            }
            if(this._btn_zoom_tooltip_gp != -1)
            {
               InputFeedbackManager.removeButton(this._rootCanvas,this._btn_zoom_tooltip_gp);
               this._btn_zoom_tooltip_gp = -1;
            }
            if(this._btn_show_tooltip != -1)
            {
               InputFeedbackManager.removeButton(this._rootCanvas,this._btn_show_tooltip);
               this._btn_show_tooltip = -1;
            }
            if(this._btn_hide_tooltip != -1)
            {
               InputFeedbackManager.removeButton(this._rootCanvas,this._btn_hide_tooltip);
               this._btn_hide_tooltip = -1;
            }
         }
         if(!param1)
         {
            InputFeedbackManager.updateButtons(this._rootCanvas);
         }
      }
      
      public function dataReceiverStat(param1:Object) : void
      {
         if(this._tooltip as TooltipStatistic)
         {
            this._tooltip.data = param1;
         }
      }
      
      public function dataReceiver(param1:Object) : void
      {
         if(this._tooltip)
         {
            this._tooltip.data = param1;
            this._tooltip.validateNow();
            this.updateComparisonMode();
         }
         else
         {
            dispatchEvent(new Event(ContextInfoManager.TOOLTIP_SHOW_ERROR,true,false));
         }
         if(this.dataSetterCallback != null)
         {
            this.dataSetterCallback(param1);
         }
      }
      
      public function addGridEventsTooltipHolder(param1:EventDispatcher, param2:Boolean = false) : void
      {
         this._gridEventsMouseOnly = param2;
         param1.addEventListener(GridEvent.DISPLAY_TOOLTIP,this.pospondedTooltipShow,false,0,true);
         param1.addEventListener(GridEvent.HIDE_TOOLTIP,this.handleTooltipHideEvent,false,0,true);
      }
      
      public function removeGridEventsTooltipHolder(param1:EventDispatcher) : void
      {
         param1.removeEventListener(GridEvent.DISPLAY_TOOLTIP,this.pospondedTooltipShow);
         param1.removeEventListener(GridEvent.HIDE_TOOLTIP,this.handleTooltipHideEvent);
      }
      
      protected function handleControllerChange(param1:ControllerChangeEvent) : void
      {
         if(!param1.isGamepad)
         {
            this.setHiddenState(false);
         }
         this.removeCurrentTooltip();
      }
      
      protected function pospondedTooltipShow(param1:GridEvent) : void
      {
         var _loc2_:Boolean = this._inputMgr.isGamepad();
         if(!this._gridEventsMouseOnly || !_loc2_)
         {
            this.bufGridEvent = param1;
            this.handleTooltipHideEvent();
            this._tooltipTimer = new Timer(_loc2_ ? TOOLTIPS_DELAY : TOOLTIPS_DELAY_MOUSE,1);
            this._tooltipTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.showTooltipTimerEnded);
            this._tooltipTimer.start();
         }
      }
      
      protected function showTooltipTimerEnded(param1:TimerEvent) : void
      {
         this.handleTooltipShowEvent(this.bufGridEvent);
      }
      
      protected function handleTooltipShowEvent(param1:GridEvent) : void
      {
         var _loc3_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc2_:Object = param1.itemData as Object;
         var _loc4_:TooltipData = new TooltipData();
         if(this._gridEventsMouseOnly && this._inputMgr.isGamepad())
         {
            return;
         }
         if(_loc2_ != null)
         {
            if(param1.directData == false)
            {
               if(_loc2_.equipped == 0)
               {
                  _loc3_ = int(_loc2_.slotType);
               }
               else
               {
                  _loc3_ = -1;
               }
            }
         }
         else if(!param1.tooltipCustomArgs)
         {
            this.handleHideTooltip();
            return;
         }
         _loc4_.alignment = param1.tooltipAlignment;
         _loc4_.isMouseTooltip = param1.isMouseTooltip;
         _loc4_.anchorRect = param1.anchorRect;
         _loc4_.directData = param1.directData;
         _loc4_.defaultAnchorName = param1.defaultAnchor;
         if(param1.directData == true)
         {
            _loc4_.description = _loc2_.description;
            _loc4_.label = _loc2_.label;
         }
         _loc4_.dataSource = !!param1.tooltipDataSource ? param1.tooltipDataSource : "OnGetItemData";
         _loc4_.anchor = this._defaultAnchor;
         if(param1.isMouseTooltip)
         {
            _loc6_ = !!param1.tooltipMouseContentRef ? param1.tooltipMouseContentRef : param1.tooltipContentRef;
            if(Boolean(this.overridedMouseDataSource) && !param1.tooltipForceSetDataSource)
            {
               _loc4_.dataSource = this.overridedMouseDataSource;
            }
         }
         else
         {
            _loc6_ = param1.tooltipContentRef;
         }
         _loc6_ = !!param1.tooltipMouseContentRef ? param1.tooltipMouseContentRef : param1.tooltipContentRef;
         _loc4_.viewerClass = !!_loc6_ ? _loc6_ : "ItemTooltipRef";
         if(param1.tooltipCustomArgs)
         {
            _loc5_ = param1.tooltipCustomArgs;
         }
         else if(param1.directData == false)
         {
            _loc5_ = [uint(_loc2_.id),_loc3_];
         }
         this.showTooltip(_loc5_,_loc4_);
         param1.stopImmediatePropagation();
      }
      
      protected function handleTooltipHideEvent(param1:GridEvent = null) : void
      {
         if(this._tooltipTimer)
         {
            this._tooltipTimer.stop();
         }
         this.removeCurrentTooltip();
      }
      
      protected function showTooltip(param1:Array, param2:TooltipData) : void
      {
         var _loc4_:Rectangle = null;
         var _loc5_:MovieClip = null;
         this.removeCurrentTooltip();
         if(this._blocked)
         {
            return;
         }
         if(this._initialized && param2.directData == false)
         {
            this._rootCanvas.dispatchEvent(new GameEvent(GameEvent.CALL,param2.dataSource,param1));
         }
         else
         {
            this._pospondedData = param2;
            this._pospondedKeyValue = param1;
         }
         var _loc3_:TooltipBase = this.getDefinition(param2.viewerClass) as TooltipBase;
         if(this._DBG_LOCK_MOUSE_TOOLTIP || param2.viewerClass == "ItemTooltipRef_mouse" || param2.viewerClass == "ItemTooltipRef")
         {
            _loc3_.isMouseTooltip = true;
            _loc3_.backgroundVisibility = true;
            _loc3_.tooltipAlignment = param2.alignment;
         }
         if(param2.isMouseTooltip)
         {
            _loc3_.anchorRect = param2.anchorRect;
            _loc3_.isMouseTooltip = true;
            _loc3_.backgroundVisibility = true;
         }
         else
         {
            _loc4_ = param2.anchorRect;
            if(param2.defaultAnchorName)
            {
               if(!(_loc5_ = this._rootCanvas.parent.getChildByName(param2.defaultAnchorName) as MovieClip))
               {
               }
            }
            if(!this._DBG_LOCK_MOUSE_TOOLTIP && param2.viewerClass != "ItemTooltipRef_mouse" && param2.viewerClass != "ItemTooltipRef")
            {
               _loc3_.anchorRect = new Rectangle(this._defaultAnchor.x,this._defaultAnchor.y,0,0);
            }
            else
            {
               _loc3_.anchorRect = _loc4_;
            }
         }
         if(param2.directData == true)
         {
            _loc3_.data = param2;
            this.updateComparisonMode();
         }
         _loc3_.addEventListener(Event.ADDED_TO_STAGE,this.handleTooltipOnStage,false,0,true);
         if(_loc3_ as TooltipInventory)
         {
            _loc3_.addEventListener(Event.ACTIVATE,this.handleTooltipResized,false,0,true);
         }
         else
         {
            this.handleTooltipResized();
         }
         this._rootCanvas.addChild(_loc3_);
         this._tooltip = _loc3_;
         this._tooltip.setVisibility(!this._isHiddenState);
         this._data = param2;
      }
      
      protected function handleTooltipOnStage(param1:Event) : void
      {
      }
      
      protected function handleTooltipResized(param1:Event = null) : void
      {
         this._rootCanvas.removeEventListener(Event.ENTER_FRAME,this.handleScaleEnterFrame,false);
         this._rootCanvas.addEventListener(Event.ENTER_FRAME,this.handleScaleEnterFrame,false,0,true);
      }
      
      protected function handleScaleEnterFrame(param1:Event) : void
      {
         this._rootCanvas.removeEventListener(Event.ENTER_FRAME,this.handleScaleEnterFrame,false);
         if(this._upscaleMePlease && Boolean(this._tooltip))
         {
            this._tooltip.scaleX = this._tooltip.scaleY = this.getMaxScale(this._tooltip);
         }
      }
      
      protected function handleHideTooltip(param1:Event = null) : void
      {
         if(!this._tooltip)
         {
            return;
         }
         if(InputManager.getInstance().isGamepad())
         {
            this._rootCanvas.removeChild(this._tooltip);
         }
         else
         {
            this.removeCurrentTooltip();
         }
      }
      
      protected function subscribeOn(param1:EventDispatcher, param2:Array, param3:Function) : void
      {
         var _loc4_:String = null;
         if(param1 && param2 && param3 != null)
         {
            for each(_loc4_ in param2)
            {
               param1.addEventListener(_loc4_,param3,false,0,true);
            }
         }
      }
      
      protected function getDefinition(param1:String) : DisplayObject
      {
         var _loc2_:RuntimeAssetsManager = RuntimeAssetsManager.getInstanse();
         return _loc2_.getAsset(param1);
      }
      
      protected function removeCurrentTooltip() : void
      {
         if(this._tooltip)
         {
            GTweener.removeTweens(this._tooltip);
            GTweener.to(this._tooltip,HIDE_ANIM_DURATION,{"alpha":0},{
               "ease":Exponential.easeOut,
               "onComplete":this.handleTooltipHidden
            });
            this._tooltip = null;
            this._data = null;
         }
      }
      
      protected function handleTooltipHidden(param1:GTween) : void
      {
         this._rootCanvas.removeChild(param1.target as DisplayObject);
      }
      
      public function setInitialState(param1:Boolean, param2:Boolean) : void
      {
         this._upscaleMePlease = param1;
      }
      
      protected function handleInput(param1:InputEvent) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Point = null;
         var _loc5_:Number = NaN;
         var _loc2_:InputDetails = param1.details;
         if(!param1.handled)
         {
            if(_loc2_.navEquivalent == NavigationCode.GAMEPAD_L2 || _loc2_.code == KeyCode.SHIFT_LEFT || _loc2_.code == KeyCode.SHIFT_RIGHT)
            {
               if(_loc2_.value == InputValue.KEY_UP)
               {
                  this.comparisonMode = false;
               }
               else
               {
                  this.comparisonMode = true;
               }
            }
            else if(_loc2_.navEquivalent == NavigationCode.GAMEPAD_L3 && _loc2_.value == InputValue.KEY_UP && this._enableInputFeedback)
            {
               if(this.blockModeSwitching)
               {
                  return;
               }
               if(this._holdTriggered)
               {
                  this._holdTriggered = false;
                  return;
               }
               this.setHiddenState(!this._isHiddenState);
            }
            if(_loc2_.navEquivalent == NavigationCode.GAMEPAD_L3 && _loc2_.value == InputValue.KEY_HOLD && !this._holdTriggered && this._enableInputFeedback)
            {
               if(this.blockModeSwitching)
               {
                  return;
               }
               this._holdTriggered = true;
               if(Boolean(this._tooltip) && this._upscaleMePlease)
               {
                  _loc3_ = {
                     "scaleX":this.NORMAL_SCALE,
                     "scaleY":this.NORMAL_SCALE
                  };
                  if(_loc4_ = this._tooltip.getPositionAfterScale(this.NORMAL_SCALE))
                  {
                     _loc3_.x = _loc4_.x;
                     _loc3_.y = _loc4_.y;
                  }
                  this._tooltip.stopSafeRectCheck(true);
                  GTweener.removeTweens(this._tooltip);
                  GTweener.to(this._tooltip,0.5,_loc3_,{
                     "ease":Exponential.easeOut,
                     "onComplete":this.handleTooltipUnzoomed
                  });
                  this._upscaleMePlease = false;
               }
               else if(this._tooltip && !this._upscaleMePlease && this._enableInputFeedback)
               {
                  _loc5_ = this.getMaxScale(this._tooltip);
                  _loc3_ = {
                     "scaleX":_loc5_,
                     "scaleY":_loc5_
                  };
                  if(_loc4_ = this._tooltip.getPositionAfterScale(_loc5_))
                  {
                     _loc3_.x = _loc4_.x;
                     _loc3_.y = _loc4_.y;
                  }
                  this._tooltip.stopSafeRectCheck(true);
                  GTweener.removeTweens(this._tooltip);
                  GTweener.to(this._tooltip,0.5,_loc3_,{
                     "ease":Exponential.easeOut,
                     "onComplete":this.handleTooltipZoomed
                  });
                  this._upscaleMePlease = true;
               }
            }
         }
      }
      
      private function handleTooltipZoomed(param1:GTween) : void
      {
         if(this._tooltip)
         {
            this._tooltip.stopSafeRectCheck(false);
         }
         if(this.saveScaleValue)
         {
            this._rootCanvas.dispatchEvent(new GameEvent(GameEvent.CALL,"OnTooltipScaleStateSave",[true]));
         }
      }
      
      private function handleTooltipUnzoomed(param1:GTween) : void
      {
         if(this._tooltip)
         {
            this._tooltip.stopSafeRectCheck(false);
         }
         if(this.saveScaleValue)
         {
            this._rootCanvas.dispatchEvent(new GameEvent(GameEvent.CALL,"OnTooltipScaleStateSave",[false]));
         }
      }
      
      private function handleMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:MouseEventEx = param1 as MouseEventEx;
         if(Boolean(_loc2_) && _loc2_.buttonIdx == MouseEventEx.MIDDLE_BUTTON)
         {
            this._upscaleMePlease = !this._upscaleMePlease;
            if(this._upscaleMePlease)
            {
               this._tooltip.scaleX = this._tooltip.scaleY = this.getMaxScale(this._tooltip);
            }
            else
            {
               this._tooltip.scaleX = this._tooltip.scaleY = 1;
            }
            if(this.saveScaleValue)
            {
               this._rootCanvas.dispatchEvent(new GameEvent(GameEvent.CALL,"OnTooltipScaleStateSave",[this._upscaleMePlease]));
            }
            this._tooltip.updateSafeRectCheck();
         }
      }
      
      private function getMaxScale(param1:UIComponent) : Number
      {
         var _loc3_:MovieClip = null;
         var _loc4_:Number = NaN;
         var _loc5_:Rectangle = null;
         var _loc2_:Number = 1070;
         if(param1)
         {
            param1.validateNow();
            _loc3_ = param1["mcBackground"] as MovieClip;
            if(_loc3_)
            {
               _loc4_ = (_loc5_ = _loc3_.getBounds(this._rootCanvas)).height;
            }
            else
            {
               _loc4_ = param1.actualHeight;
            }
            if(_loc4_ * this.MAX_ZOOM > _loc2_)
            {
               return _loc2_ / _loc4_;
            }
            return this.MAX_ZOOM;
         }
         return this.MAX_ZOOM;
      }
   }
}
