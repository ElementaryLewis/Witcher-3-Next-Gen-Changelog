package red.game.witcher3.modules
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Sine;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import red.core.CoreMenuModule;
   import red.core.events.GameEvent;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.controls.AdvancedTabListItem;
   import red.game.witcher3.controls.TabListItem;
   import red.game.witcher3.controls.W3DropDownList;
   import red.game.witcher3.controls.W3GamepadButton;
   import red.game.witcher3.controls.W3ScrollingList;
   import red.game.witcher3.events.ControllerChangeEvent;
   import red.game.witcher3.managers.InputManager;
   import red.game.witcher3.slots.SlotBase;
   import red.game.witcher3.slots.SlotsListBase;
   import red.game.witcher3.slots.SlotsListGrid;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.controls.ScrollBar;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   
   public class TabbedScrollingListModule extends CoreMenuModule
   {
       
      
      public var txtTitle:TextField;
      
      public var mcTabList:W3ScrollingList;
      
      public var mcTabListItem1:TabListItem;
      
      public var mcTabListItem2:TabListItem;
      
      public var mcTabListItem3:TabListItem;
      
      public var mcTabListItem4:TabListItem;
      
      public var mcTabListItem5:TabListItem;
      
      public var mcTabListItem6:TabListItem;
      
      public var mcTabListItem7:TabListItem;
      
      public var mcTabListItem8:TabListItem;
      
      public var mcLeftGamepadIcon:W3GamepadButton;
      
      public var mcRightGamepadIcon:W3GamepadButton;
      
      public var mcScrollbar:ScrollBar;
      
      public var mcSlotList:SlotsListBase;
      
      public var mcDropdownList:W3DropDownList;
      
      public var mcTabBackground:MovieClip;
      
      public var hideTabBackgroundWhenData:Boolean = false;
      
      public var _inputEnabled:Boolean = true;
      
      public var _pendingTabDataRequest:int = -1;
      
      protected var subDataDictionary:Dictionary;
      
      private var _callbacksSet:Boolean = false;
      
      public var noDelay:Boolean = true;
      
      protected var _initialSelectedIndex:int;
      
      protected var _subDataProvider:String = "INVALID_STRING_PARAM!";
      
      protected var _tabDataEventName:String = "OnTabDataRequested";
      
      protected var _setSelectedDataProvider:String = "OnTabSelectRequested";
      
      protected var _lastSetAllowSelectionHighlight:Boolean = true;
      
      private var _setTabDataProvider:DataProvider;
      
      private var _tabDataSet:Boolean = false;
      
      public var currentlySelectedTabIndex:int = -1;
      
      private var _updateTimer:Timer;
      
      protected var lastUpdatedSubDataIndex = -1;
      
      protected var subDataTweener:GTween;
      
      public function TabbedScrollingListModule()
      {
         this.subDataDictionary = new Dictionary();
         super();
      }
      
      override protected function configUI() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         super.configUI();
         this._initialSelectedIndex = 0;
         if(this.mcLeftGamepadIcon)
         {
            this.mcLeftGamepadIcon.navigationCode = NavigationCode.GAMEPAD_L1;
            this.mcLeftGamepadIcon.textField.text = "";
         }
         if(this.mcRightGamepadIcon)
         {
            this.mcRightGamepadIcon.navigationCode = NavigationCode.GAMEPAD_R1;
            this.mcRightGamepadIcon.textField.text = "";
         }
         if(!this._callbacksSet)
         {
            this._callbacksSet = true;
            if(this._subDataProvider != CommonConstants.INVALID_STRING_PARAM)
            {
               _loc1_ = new Array();
               _loc1_.push(this.handleTabDataSet1);
               _loc1_.push(this.handleTabDataSet2);
               _loc1_.push(this.handleTabDataSet3);
               _loc1_.push(this.handleTabDataSet4);
               _loc1_.push(this.handleTabDataSet5);
               _loc1_.push(this.handleTabDataSet6);
               _loc1_.push(this.handleTabDataSet7);
               _loc1_.push(this.handleTabDataSet8);
               _loc2_ = 0;
               while(_loc2_ < this.mcTabList.numRenderers)
               {
                  dispatchEvent(new GameEvent(GameEvent.REGISTER,this._subDataProvider + _loc2_.toString(),[_loc1_[_loc2_]]));
                  _loc2_++;
               }
            }
            if(this._setSelectedDataProvider != CommonConstants.INVALID_STRING_PARAM)
            {
               dispatchEvent(new GameEvent(GameEvent.REGISTER,this._setSelectedDataProvider,[this.onSetTabCalled]));
            }
         }
         InputManager.getInstance().addEventListener(ControllerChangeEvent.CONTROLLER_CHANGE,this.handleControllerChange,false,0,true);
         if(!InputManager.getInstance().isGamepad())
         {
            this.setAllowSelectionHighlight(focused != 0);
         }
         this.setupTabData();
         stage.addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
         if(this.mcDropdownList)
         {
            _inputHandlers.push(this.mcDropdownList);
         }
         else if(this.mcSlotList)
         {
            _inputHandlers.push(this.mcSlotList);
         }
      }
      
      public function get subDataProvider() : String
      {
         return this._subDataProvider;
      }
      
      public function set subDataProvider(param1:String) : void
      {
         this._subDataProvider = param1;
      }
      
      public function get tabDataEventName() : String
      {
         return this._tabDataEventName;
      }
      
      public function set tabDataEventName(param1:String) : void
      {
         this._tabDataEventName = param1;
      }
      
      public function get setSelectedTabDataProvider() : String
      {
         return this._setSelectedDataProvider;
      }
      
      public function set setSelectedTabDataProvider(param1:String) : void
      {
         this._setSelectedDataProvider = param1;
      }
      
      override public function set focused(param1:Number) : void
      {
         super.focused = param1;
         this.OnFocusedChanged();
         this.fireSelectedItemTooltip();
      }
      
      protected function OnFocusedChanged() : void
      {
         this.UpdateSelectionHighlight();
      }
      
      protected function UpdateSelectionHighlight() : void
      {
         this.setAllowSelectionHighlight(focused != 0);
      }
      
      protected function setAllowSelectionHighlight(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc3_:AdvancedTabListItem = null;
         if(this.mcTabList)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mcTabList.numRenderers)
            {
               _loc3_ = this.mcTabList.getRendererAt(_loc2_) as AdvancedTabListItem;
               if(_loc3_)
               {
                  _loc3_.selectionVisible = focused;
               }
               _loc2_++;
            }
         }
         this._lastSetAllowSelectionHighlight = param1;
         if(this.mcSlotList)
         {
            this.mcSlotList.activeSelectionVisible = param1 || !InputManager.getInstance().isGamepad();
         }
      }
      
      protected function handleControllerChange(param1:ControllerChangeEvent) : void
      {
         this.setAllowSelectionHighlight(this._lastSetAllowSelectionHighlight);
      }
      
      public function setNewFlagsForTabs(param1:Array) : void
      {
         var _loc2_:AdvancedTabListItem = null;
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < param1.length && _loc3_ < this.mcTabList.dataProvider.length)
         {
            _loc2_ = this.mcTabList.getRendererAt(_loc3_) as AdvancedTabListItem;
            if(_loc2_)
            {
               _loc2_.setNewFlag(param1[_loc3_]);
            }
            _loc3_++;
         }
      }
      
      protected function fireSelectedItemTooltip() : void
      {
         var _loc2_:SlotBase = null;
         var _loc1_:UIComponent = this.getDataShowerForCurrentTab();
         if(_loc1_ is SlotsListBase && enabled)
         {
            _loc2_ = (_loc1_ as SlotsListBase).getSelectedRenderer() as SlotBase;
            if(_loc2_)
            {
               _loc2_.showTooltip();
            }
         }
      }
      
      public function setTabData(param1:DataProvider) : void
      {
         var _loc2_:int = 0;
         this._setTabDataProvider = param1;
         this.setupTabData();
         this.subDataDictionary = new Dictionary();
         if(this.currentlySelectedTabIndex != -1)
         {
            this.updateSubData(this.currentlySelectedTabIndex);
         }
         else
         {
            this.mcTabList.selectedIndex = this._initialSelectedIndex;
            this.mcTabList.validateNow();
         }
      }
      
      public function onSetTabCalled(param1:int) : void
      {
         if(this.mcTabList)
         {
            this.mcTabList.selectedIndex = param1;
         }
      }
      
      override public function hasSelectableItems() : Boolean
      {
         if(this.mcTabList.selectedIndex == -1 || this.subDataDictionary[this.mcTabList.selectedIndex] != null && this.subDataDictionary[this.mcTabList.selectedIndex].length == 0)
         {
            return false;
         }
         return super.hasSelectableItems();
      }
      
      private function setupTabData() : *
      {
         if(!this._tabDataSet && this.mcTabList && Boolean(this._setTabDataProvider))
         {
            this._tabDataSet = true;
            this.mcTabList.dataProvider = this._setTabDataProvider;
            this.mcTabList.validateNow();
            this.mcTabList.ShowRenderers(true);
            this.mcTabList.tabEnabled = false;
            this.mcTabList.tabChildren = false;
            this.mcTabList.focusable = false;
            this.mcTabList.addEventListener(ListEvent.INDEX_CHANGE,this.onTabListItemSelected,false,0,true);
         }
      }
      
      protected function onTabListItemSelected(param1:ListEvent) : void
      {
         var _loc2_:TabListItem = null;
         if(param1.index != this.currentlySelectedTabIndex)
         {
            this.currentlySelectedTabIndex = param1.index;
            if(Boolean(param1.itemRenderer) && Boolean(this.txtTitle))
            {
               this.txtTitle.htmlText = (param1.itemRenderer as TabListItem).GetLocKey();
               this.txtTitle.htmlText = CommonUtils.toUpperCaseSafe(this.txtTitle.htmlText);
            }
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnTabChanged",[this.currentlySelectedTabIndex]));
            _loc2_ = this.mcTabList.getRendererAt(param1.index) as TabListItem;
            if(Boolean(this.mcTabBackground) && _loc2_.getIconData() != "")
            {
               this.mcTabBackground.gotoAndStop(_loc2_.getIconData());
            }
            if(!this.noDelay && InputManager.getInstance().isGamepad())
            {
               if(!this._updateTimer)
               {
                  this._updateTimer = new Timer(350,1);
                  this._updateTimer.addEventListener(TimerEvent.TIMER,this.OnUpdateTimer,false,0,true);
                  this._updateTimer.start();
               }
               else
               {
                  this._updateTimer.stop();
                  this._updateTimer.reset();
                  this._updateTimer.start();
               }
            }
            else
            {
               this.updateSubData(this.currentlySelectedTabIndex);
            }
         }
      }
      
      private function OnUpdateTimer(param1:TimerEvent) : void
      {
         this.updateSubData(this.currentlySelectedTabIndex);
      }
      
      protected function handleTweenComplete(param1:GTween) : void
      {
         this.subDataTweener = null;
      }
      
      protected function requestTabdata(param1:int) : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,this.tabDataEventName,[param1]));
      }
      
      protected function enterframe_pendingTabRequest(param1:Event) : void
      {
         if(this._pendingTabDataRequest != -1)
         {
            this.requestTabdata(this._pendingTabDataRequest);
            this._pendingTabDataRequest = -1;
         }
         removeEventListener(Event.ENTER_FRAME,this.enterframe_pendingTabRequest);
      }
      
      protected function updateSubData(param1:int) : void
      {
         var _loc2_:SlotBase = null;
         var _loc3_:SlotsListBase = null;
         var _loc4_:int = 0;
         var _loc5_:UIComponent = null;
         var _loc6_:Number = NaN;
         if(this.subDataDictionary[param1] == null)
         {
            this._pendingTabDataRequest = param1;
            addEventListener(Event.ENTER_FRAME,this.enterframe_pendingTabRequest,false,0,true);
         }
         else
         {
            if(this.lastUpdatedSubDataIndex != param1)
            {
               if(_loc5_ = this.getDataShowerForTab(this.lastUpdatedSubDataIndex))
               {
                  _loc5_.visible = false;
                  if(_loc5_ is SlotsListBase)
                  {
                     (_loc5_ as SlotsListBase).selectedIndex = -1;
                  }
               }
               this.lastUpdatedSubDataIndex = param1;
               if((_loc5_ = this.getDataShowerForTab(this.lastUpdatedSubDataIndex)) is W3DropDownList)
               {
                  (_loc5_ as W3DropDownList).updateData(this.subDataDictionary[param1]);
                  (_loc5_ as W3DropDownList).SetInitialSelection();
               }
               else if(_loc5_ is SlotsListBase)
               {
                  (_loc5_ as SlotsListBase).data = this.subDataDictionary[param1];
                  _loc5_.validateNow();
                  if(enabled)
                  {
                     (_loc5_ as SlotsListBase).findSelection();
                     _loc5_.validateNow();
                  }
                  if(_loc5_ is SlotsListGrid)
                  {
                     (_loc5_ as SlotsListGrid).offset = 0;
                  }
               }
               if(this.hideTabBackgroundWhenData && Boolean(this.mcTabBackground))
               {
               }
               if(_loc5_)
               {
                  _loc5_.visible = true;
                  _loc5_.validateNow();
                  if(this.subDataTweener)
                  {
                     this.subDataTweener.paused = true;
                     GTweener.removeTweens(_loc5_);
                  }
                  _loc5_.alpha = 0;
                  _loc6_ = 0.5;
                  this.subDataTweener = GTweener.to(_loc5_,_loc6_,{"alpha":1},{
                     "onComplete":this.handleTweenComplete,
                     "ease":Sine.easeOut
                  });
               }
            }
            else if((_loc5_ = this.getDataShowerForTab(this.lastUpdatedSubDataIndex)) is W3DropDownList)
            {
               (_loc5_ as W3DropDownList).updateData(this.subDataDictionary[param1]);
            }
            else if(_loc5_ is SlotsListBase)
            {
               _loc3_ = _loc5_ as SlotsListBase;
               _loc4_ = _loc3_.selectedIndex;
               _loc3_.data = this.subDataDictionary[param1];
               _loc3_.validateNow();
               _loc3_.ReselectIndexIfInvalid(_loc4_);
               _loc3_.validateNow();
               _loc2_ = _loc3_.getSelectedRenderer() as SlotBase;
            }
            this.UpdateSelectionHighlight();
         }
      }
      
      public function getDataShowerForCurrentTab() : UIComponent
      {
         return this.getDataShowerForTab(this.mcTabList.selectedIndex);
      }
      
      public function getDataShowerForTab(param1:int) : UIComponent
      {
         if(this.mcDropdownList)
         {
            return this.mcDropdownList;
         }
         if(this.mcSlotList)
         {
            return this.mcSlotList;
         }
         return null;
      }
      
      public function handleSetSubData(param1:Object) : void
      {
         var _loc2_:int = int(param1.tabIndex);
         var _loc3_:Array = param1.tabData;
         if(!_loc3_)
         {
            throw new Error("GFX - handleSetSubData called with invalid parameters: " + _loc2_ + ", data:" + _loc3_);
         }
         this.setSubData(_loc2_,_loc3_);
         if(this.currentlySelectedTabIndex == -1 && this.mcTabList.selectedIndex == -1 && this.mcTabList && this.mcTabList.dataProvider.length > 0)
         {
            this.mcTabList.selectedIndex = _loc2_;
            this.mcTabList.validateNow();
         }
         if(_loc2_ == this.currentlySelectedTabIndex)
         {
            this.updateSubData(_loc2_);
         }
      }
      
      public function updateDataSurgicallyInCurrentTab(param1:int, param2:Array) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:Boolean = false;
         if(this.subDataDictionary[param1] != null)
         {
            _loc5_ = this.subDataDictionary[param1];
            _loc4_ = 0;
            while(_loc4_ < param2.length)
            {
               _loc6_ = false;
               _loc3_ = 0;
               while(_loc3_ < _loc5_.length)
               {
                  if(param2[_loc4_].id == _loc5_[_loc3_].id)
                  {
                     _loc6_ = true;
                     _loc5_[_loc3_] = param2[_loc4_];
                     break;
                  }
                  _loc3_++;
               }
               if(!_loc6_)
               {
                  _loc5_.push(param2[_loc4_]);
               }
               _loc4_++;
            }
         }
      }
      
      public function removeDataSurgicallyInCurrentTab(param1:int, param2:Array) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:Boolean = false;
         if(this.subDataDictionary[param1] != null)
         {
            _loc5_ = this.subDataDictionary[param1];
            _loc4_ = 0;
            while(_loc4_ < param2.length)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc5_.length)
               {
                  if(param2[_loc4_] == _loc5_[_loc3_].id)
                  {
                     _loc5_.splice(_loc3_,1);
                     break;
                  }
                  _loc3_++;
               }
               _loc4_++;
            }
            return;
         }
         throw new Error("GFX - removeDataSurgicallyInCurrentTab called with invalid tabIndex:" + param1);
      }
      
      protected function setSubData(param1:int, param2:Array) : void
      {
         this.subDataDictionary[param1] = param2;
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc2_:UIComponent = null;
         if(param1.handled || !this._inputEnabled)
         {
            return;
         }
         if(this.mcTabList)
         {
            this.mcTabList.handleInput(param1);
         }
         if(!focused || param1.handled)
         {
            return;
         }
         for each(_loc2_ in _inputHandlers)
         {
            if(Boolean(_loc2_) && _loc2_.visible)
            {
               if(_loc2_ is SlotsListBase)
               {
                  (_loc2_ as SlotsListBase).handleInputNavSimple(param1);
               }
               else
               {
                  _loc2_.handleInput(param1);
               }
               if(param1.handled)
               {
                  return;
               }
            }
         }
      }
      
      protected function tabListNavEnabled() : Boolean
      {
         return true;
      }
      
      protected function handleTabDataSet1(param1:Object) : void
      {
         this.handleSetSubData(param1);
      }
      
      protected function handleTabDataSet2(param1:Object) : void
      {
         this.handleSetSubData(param1);
      }
      
      protected function handleTabDataSet3(param1:Object) : void
      {
         this.handleSetSubData(param1);
      }
      
      protected function handleTabDataSet4(param1:Object) : void
      {
         this.handleSetSubData(param1);
      }
      
      protected function handleTabDataSet5(param1:Object) : void
      {
         this.handleSetSubData(param1);
      }
      
      protected function handleTabDataSet6(param1:Object) : void
      {
         this.handleSetSubData(param1);
      }
      
      protected function handleTabDataSet7(param1:Object) : void
      {
         this.handleSetSubData(param1);
      }
      
      protected function handleTabDataSet8(param1:Object) : void
      {
         this.handleSetSubData(param1);
      }
   }
}
