package red.game.witcher3.modules
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Sine;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.TabListItem;
   import red.game.witcher3.controls.W3DropDownList;
   import red.game.witcher3.managers.InputFeedbackManager;
   import red.game.witcher3.slots.SlotBase;
   import red.game.witcher3.slots.SlotsListBase;
   import red.game.witcher3.utils.CommonUtils;
   import red.game.witcher3.utils.FiniteStateMachine;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.constants.WrappingMode;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.clik.interfaces.IListItemRenderer;
   import scaleform.clik.ui.InputDetails;
   
   public class CollapsableTabbedListModule extends TabbedScrollingListModule
   {
      
      protected static const State_Colapsed:String = "collapsed";
      
      protected static const State_Open:String = "open";
      
      protected static const ClosedListAlpha:Number = 1;
      
      protected static const ClosedListScale:Number = 1;
       
      
      protected var stateMachine:FiniteStateMachine;
      
      public var _isFirstTabSelection:Boolean = true;
      
      public var mcListContainer:MovieClip;
      
      public var openedCallback:Function;
      
      public var closedCallback:Function;
      
      protected var _inputSymbolIDA:int = -1;
      
      protected var _inputSymbolIDB:int = -1;
      
      protected var lastSelection:int = -1;
      
      protected var _hideInputFeedback:Boolean;
      
      protected var bToCloseEnabled:Boolean = false;
      
      protected var _tabsAutoAlign:Boolean = false;
      
      protected var _handledItemClick:Boolean = false;
      
      protected var containerTweener:GTween;
      
      protected var _lastMoveWasMouse:Boolean = false;
      
      public function CollapsableTabbedListModule()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         this.setupStateMachine();
         super.configUI();
         this.addToListContainer(mcSlotList);
         this.addToListContainer(mcDropdownList);
         this.addToListContainer(mcScrollbar);
         this.addToListContainer(mcTabBackground);
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMove,false,100,true);
         if(mcTabList)
         {
            mcTabList.addEventListener(ListEvent.ITEM_CLICK,this.onTabListItemClick,false,1,true);
         }
      }
      
      public function get tabsAutoAlign() : Boolean
      {
         return this._tabsAutoAlign;
      }
      
      public function set tabsAutoAlign(param1:Boolean) : void
      {
         this._tabsAutoAlign = param1;
      }
      
      protected function addToListContainer(param1:MovieClip) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(Boolean(this.mcListContainer) && Boolean(param1))
         {
            _loc2_ = param1.x - this.mcListContainer.x;
            _loc3_ = param1.y - this.mcListContainer.y;
            this.mcListContainer.addChild(param1);
            param1.x = _loc2_;
            param1.y = _loc3_;
         }
      }
      
      protected function setupStateMachine() : void
      {
         this.stateMachine = new FiniteStateMachine();
         this.stateMachine.AddState(State_Colapsed,this.state_colapsed_begin,null,null);
         this.stateMachine.AddState(State_Open,this.state_Open_begin,null,null);
      }
      
      public function get isOpen() : Boolean
      {
         return this.stateMachine.currentState == State_Open;
      }
      
      public function open() : void
      {
         if(this.stateMachine.currentState != State_Open && (mcTabList.selectedIndex != -1 && subDataDictionary[mcTabList.selectedIndex] != null && subDataDictionary[mcTabList.selectedIndex].length > 0))
         {
            this.stateMachine.ChangeState(State_Open);
         }
      }
      
      public function forceOpen() : void
      {
         if(this.stateMachine.currentState != State_Open)
         {
            this.stateMachine.ChangeState(State_Open);
         }
      }
      
      public function close() : void
      {
         if(this.stateMachine.currentState != State_Colapsed)
         {
            this.stateMachine.ChangeState(State_Colapsed);
         }
      }
      
      protected function onTabListItemClick(param1:ListEvent) : void
      {
         this._handledItemClick = true;
         dispatchEvent(new Event(EVENT_MOUSE_FOCUSE));
      }
      
      override protected function onTabListItemSelected(param1:ListEvent) : void
      {
         super.onTabListItemSelected(param1);
         this.lastSelection = -1;
         if(!this.isOpen)
         {
            if(this._handledItemClick && !this._isFirstTabSelection)
            {
               this.open();
            }
            else if(mcTabBackground)
            {
               mcTabBackground.visible = true;
            }
         }
         this._isFirstTabSelection = false;
         this.updateSelectedTabSelection();
      }
      
      protected function handleContainerTweenComplete(param1:GTween) : void
      {
         this.containerTweener = null;
      }
      
      protected function state_colapsed_begin() : void
      {
         mcTabList.UpAction = 37;
         mcTabList.DownAction = 39;
         mcTabList.PCUpAction = KeyCode.A;
         mcTabList.PCDownAction = KeyCode.D;
         var _loc1_:UIComponent = getDataShowerForCurrentTab();
         if(_loc1_)
         {
            _loc1_.enabled = false;
         }
         if(mcLeftGamepadIcon)
         {
            mcLeftGamepadIcon.visible = false;
         }
         if(mcRightGamepadIcon)
         {
            mcRightGamepadIcon.visible = false;
         }
         var _loc2_:UIComponent = getDataShowerForCurrentTab();
         if(_loc2_)
         {
            if(_loc2_ is SlotsListBase)
            {
               this.lastSelection = (_loc2_ as SlotsListBase).selectedIndex;
               (_loc2_ as SlotsListBase).selectedIndex = -1;
            }
            else if(_loc2_ is W3DropDownList)
            {
               (_loc2_ as W3DropDownList).selectedIndex = -1;
            }
         }
         if(this.mcListContainer)
         {
            if(this.containerTweener)
            {
               this.containerTweener.paused = true;
               GTweener.removeTweens(this.mcListContainer);
            }
            this.containerTweener = GTweener.to(this.mcListContainer,0.2,{
               "alpha":ClosedListAlpha,
               "scaleX":ClosedListScale,
               "scaleY":ClosedListScale
            },{
               "onComplete":this.handleContainerTweenComplete,
               "ease":Sine.easeOut
            });
         }
         this.ApplyCloseAnimationToMask();
         this.updateInputFeedback();
         setAllowSelectionHighlight(false);
         mcTabList.wrapping = WrappingMode.NORMAL;
         this.updateSelectedTabSelection();
         if(this.closedCallback != null)
         {
            this.closedCallback();
         }
      }
      
      protected function state_Open_begin() : void
      {
         var _loc3_:SlotBase = null;
         mcTabList.UpAction = 107;
         mcTabList.DownAction = 109;
         mcTabList.PCUpAction = KeyCode.NUMPAD_4;
         mcTabList.PCDownAction = KeyCode.NUMPAD_6;
         var _loc1_:UIComponent = getDataShowerForCurrentTab();
         if(_loc1_)
         {
            _loc1_.enabled = true;
         }
         if(mcLeftGamepadIcon)
         {
            mcLeftGamepadIcon.visible = true;
         }
         if(mcRightGamepadIcon)
         {
            mcRightGamepadIcon.visible = true;
         }
         if(focused)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnPlaySoundEvent",["gui_global_highlight"]));
         }
         this.updateSelectedTabSelection();
         this.updateInputFeedback();
         mcTabList.wrapping = WrappingMode.WRAP;
         var _loc2_:UIComponent = getDataShowerForCurrentTab();
         if(_loc2_)
         {
            if(_loc2_ is SlotsListBase)
            {
               _loc3_ = (_loc2_ as SlotsListBase).getSelectedRenderer() as SlotBase;
               if(_loc3_)
               {
                  _loc3_.showTooltip();
               }
            }
            if(_loc2_ is SlotsListBase)
            {
               if(this.lastSelection != -1)
               {
                  (_loc2_ as SlotsListBase).selectedIndex = this.lastSelection;
                  _loc2_.validateNow();
               }
            }
            else if(_loc2_ is W3DropDownList)
            {
               (_loc2_ as W3DropDownList).SetInitialSelection();
            }
         }
         if(this.mcListContainer)
         {
            if(this.containerTweener)
            {
               this.containerTweener.paused = true;
               GTweener.removeTweens(this.mcListContainer);
            }
            if(this._handledItemClick)
            {
               this.mcListContainer.scaleX = this.mcListContainer.scaleY = 1;
               this.mcListContainer.alpha = 1;
               this._handledItemClick = false;
            }
            else
            {
               this.containerTweener = GTweener.to(this.mcListContainer,0.2,{
                  "alpha":1,
                  "scaleX":1,
                  "scaleY":1
               },{
                  "onComplete":this.handleContainerTweenComplete,
                  "ease":Sine.easeOut
               });
            }
         }
         this.ApplyOpenAnimationToMask();
         setAllowSelectionHighlight(focused != 0);
         if(this.openedCallback != null)
         {
            this.openedCallback();
         }
      }
      
      override public function removeDataSurgicallyInCurrentTab(param1:int, param2:Array) : void
      {
         super.removeDataSurgicallyInCurrentTab(param1,param2);
         this.closeIfEmpty();
      }
      
      protected function closeIfEmpty() : void
      {
         var _loc1_:Array = null;
         if(this.isOpen)
         {
            _loc1_ = subDataDictionary[mcTabList.selectedIndex];
            if(_loc1_ == null || _loc1_.length == 0)
            {
               this.close();
            }
         }
      }
      
      protected function ApplyCloseAnimationToMask() : *
      {
      }
      
      protected function ApplyOpenAnimationToMask() : *
      {
      }
      
      protected function updateSelectedTabSelection() : *
      {
         var _loc1_:TabListItem = mcTabList.getSelectedRenderer() as TabListItem;
         if(_loc1_)
         {
            if(this.stateMachine.currentState == State_Open)
            {
               _loc1_.setIsOpen(true);
            }
            else
            {
               _loc1_.setIsOpen(false);
            }
         }
      }
      
      override public function hasSelectableItems() : Boolean
      {
         return mcTabList != null && mcTabList.dataProvider.length > 0;
      }
      
      override protected function updateSubData(param1:int) : void
      {
         super.updateSubData(param1);
         var _loc2_:UIComponent = getDataShowerForCurrentTab();
         if(_loc2_)
         {
            if(this.stateMachine.currentState != State_Open)
            {
               if(focused)
               {
               }
            }
         }
         this.UpdateSelectionHighlight();
         if(subDataDictionary[param1] != null)
         {
            if(this.stateMachine.currentState == State_Colapsed && subDataDictionary[param1].length > 0 && this._lastMoveWasMouse)
            {
               this.open();
            }
            else
            {
               this.closeIfEmpty();
            }
         }
         this.updateInputFeedback();
      }
      
      override public function set focused(param1:Number) : void
      {
         var _loc2_:UIComponent = null;
         super.focused = param1;
         this.updateInputFeedback();
         if(this.stateMachine.currentState != State_Open)
         {
            _loc2_ = getDataShowerForCurrentTab();
         }
      }
      
      public function get hideInputFeedback() : Boolean
      {
         return this._hideInputFeedback;
      }
      
      public function set hideInputFeedback(param1:Boolean) : void
      {
         this._hideInputFeedback = param1;
         this.updateInputFeedback();
      }
      
      override protected function UpdateSelectionHighlight() : void
      {
         setAllowSelectionHighlight(this.isOpen && Boolean(focused));
      }
      
      override public function setTabData(param1:DataProvider) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Vector.<IListItemRenderer> = null;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:TabListItem = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         super.setTabData(param1);
         if(this._tabsAutoAlign)
         {
            _loc2_ = 11;
            _loc3_ = mcTabList.getRenderers();
            _loc4_ = 0;
            _loc5_ = 0;
            _loc6_ = 0;
            _loc7_ = -1;
            _loc5_ = int(_loc3_.length);
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               if((_loc8_ = _loc3_[_loc6_] as TabListItem) && _loc8_.visible && _loc8_.hasData())
               {
                  _loc4_++;
                  if(_loc7_ < 0)
                  {
                     _loc7_ = _loc8_.getRendererWidth();
                  }
               }
               _loc6_++;
            }
            _loc9_ = _loc4_ * _loc7_ + (_loc4_ - 1) * _loc2_;
            _loc11_ = _loc10_ = mcTabList.x - _loc9_ / 2;
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               if((_loc8_ = _loc3_[_loc6_] as TabListItem) && _loc8_.visible && _loc8_.hasData())
               {
                  _loc8_.x = _loc10_ + _loc7_ / 2;
                  _loc10_ += _loc7_ + _loc2_;
               }
               _loc6_++;
            }
         }
      }
      
      override protected function fireSelectedItemTooltip() : void
      {
         if(this.isOpen)
         {
            super.fireSelectedItemTooltip();
         }
      }
      
      protected function handleMouseMove(param1:MouseEvent) : void
      {
         if(!this._lastMoveWasMouse)
         {
            this._lastMoveWasMouse = true;
            this.open();
         }
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc2_:InputDetails = param1.details as InputDetails;
         CommonUtils.convertWASDCodeToNavEquivalent(_loc2_);
         if(_loc2_.navEquivalent == NavigationCode.UP || _loc2_.navEquivalent == NavigationCode.DOWN || _loc2_.navEquivalent == NavigationCode.LEFT || _loc2_.navEquivalent == NavigationCode.RIGHT)
         {
            this._lastMoveWasMouse = false;
         }
         if(param1.handled || !_inputEnabled)
         {
            return;
         }
         var _loc3_:Boolean = _loc2_.value == InputValue.KEY_HOLD || _loc2_.value == InputValue.KEY_DOWN;
         if(this.stateMachine.currentState == State_Colapsed)
         {
            if(_loc2_.value == InputValue.KEY_UP)
            {
               if(_loc2_.navEquivalent == NavigationCode.GAMEPAD_A && Boolean(focused))
               {
                  this.open();
                  param1.handled = true;
                  return;
               }
            }
            if(focused)
            {
               mcTabList.handleInput(param1);
               if(_loc3_ && (_loc2_.navEquivalent == NavigationCode.DOWN || _loc2_.code == KeyCode.S))
               {
                  this.open();
                  param1.handled = true;
                  return;
               }
               if(_loc2_.value == InputValue.KEY_DOWN)
               {
                  switch(_loc2_.navEquivalent)
                  {
                     case NavigationCode.RIGHT_STICK_DOWN:
                        this.open();
                        param1.handled = true;
                  }
               }
            }
         }
         else if(this.stateMachine.currentState == State_Open)
         {
            if(focused)
            {
               if(_loc2_.value == InputValue.KEY_UP)
               {
                  if(_loc2_.navEquivalent == NavigationCode.GAMEPAD_B && this.bToCloseEnabled)
                  {
                     this.close();
                     param1.handled = true;
                     return;
                  }
               }
               if(_loc2_.value == InputValue.KEY_DOWN)
               {
                  switch(_loc2_.navEquivalent)
                  {
                     case NavigationCode.RIGHT_STICK_UP:
                        this.close();
                        param1.handled = true;
                  }
               }
            }
            super.handleInput(param1);
            if(param1.handled == false && focused && _loc3_ && (_loc2_.navEquivalent == NavigationCode.UP || _loc2_.code == KeyCode.A))
            {
               this.close();
               param1.handled = true;
               return;
            }
         }
         else
         {
            super.handleInput(param1);
         }
      }
      
      protected function updateInputFeedbackButtons() : void
      {
         if(this._inputSymbolIDB != -1)
         {
            InputFeedbackManager.removeButton(this,this._inputSymbolIDB);
            this._inputSymbolIDB = -1;
         }
         if(this._inputSymbolIDA != -1)
         {
            InputFeedbackManager.removeButton(this,this._inputSymbolIDA);
            this._inputSymbolIDA = -1;
         }
         if(this._hideInputFeedback)
         {
            return;
         }
         if(this.stateMachine.currentState == State_Colapsed)
         {
            if(_focused && enabled && mcTabList.selectedIndex != -1 && subDataDictionary[mcTabList.selectedIndex] != null && subDataDictionary[mcTabList.selectedIndex].length > 0)
            {
               this._inputSymbolIDA = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_A,-1,"inputfeedback_common_open_grid");
            }
         }
         else if(this.stateMachine.currentState == State_Open)
         {
            this._inputSymbolIDB = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_B,-1,"inputfeedback_common_close_grid");
         }
      }
      
      override protected function tabListNavEnabled() : Boolean
      {
         return this.stateMachine.currentState == State_Colapsed;
      }
      
      protected function updateInputFeedback() : void
      {
         this.updateInputFeedbackButtons();
         InputFeedbackManager.updateButtons(this);
      }
      
      public function refreshButtons() : void
      {
         this.updateInputFeedback();
      }
   }
}
