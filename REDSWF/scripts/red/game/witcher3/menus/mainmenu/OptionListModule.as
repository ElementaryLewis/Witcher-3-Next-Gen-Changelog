package red.game.witcher3.menus.mainmenu
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import red.core.CoreComponent;
   import red.core.CoreMenuModule;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.W3ScrollingList;
   import red.game.witcher3.menus.common.W3SubMenuListItemRenderer;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.controls.ScrollBar;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.clik.ui.InputDetails;
   import scaleform.gfx.MouseEventEx;
   
   public class OptionListModule extends CoreMenuModule
   {
      
      private static const ACTION_DOWNLOAD:uint = 66;
       
      
      public var mcPresetOption:MovieClip;
      
      public var mcOptionList:W3ScrollingList;
      
      public var mcOptionListItem1:W3SubMenuListItemRenderer;
      
      public var mcOptionListItem2:W3SubMenuListItemRenderer;
      
      public var mcOptionListItem3:W3SubMenuListItemRenderer;
      
      public var mcOptionListItem4:W3SubMenuListItemRenderer;
      
      public var mcOptionListItem5:W3SubMenuListItemRenderer;
      
      public var mcOptionListItem6:W3SubMenuListItemRenderer;
      
      public var mcOptionListItem7:W3SubMenuListItemRenderer;
      
      public var mcOptionListItem8:W3SubMenuListItemRenderer;
      
      public var mcOptionListItem9:W3SubMenuListItemRenderer;
      
      public var optionListItems:Array;
      
      protected var mcPresetList:W3ScrollingList;
      
      public var mcScrollingListItem1:W3MenuListItemRenderer;
      
      public var mcScrollingListItem2:W3MenuListItemRenderer;
      
      public var mcScrollingListItem3:W3MenuListItemRenderer;
      
      public var mcScrollingListItem4:W3MenuListItemRenderer;
      
      public var mcScrollingListItem5:W3MenuListItemRenderer;
      
      public var optionListData:Array;
      
      public var mcOptionScrollbar:ScrollBar;
      
      protected var txtPresetTitle:TextField;
      
      public var txtOptionDescription:TextField;
      
      protected var presetSelected:Boolean = false;
      
      protected var presetsEnabled:Boolean = false;
      
      protected var currentPresetGroupName:uint;
      
      protected var itemsX:Number;
      
      public var _lastMoveWasMouse:Boolean = false;
      
      protected var _lastMouseOveredPresetItem:int = -1;
      
      protected var _lastMouseOveredOptionItem:int = -1;
      
      public function OptionListModule()
      {
         super();
      }
      
      public function get lastMoveWasMouse() : Boolean
      {
         return this._lastMoveWasMouse;
      }
      
      public function set lastMoveWasMouse(param1:Boolean) : void
      {
         this._lastMoveWasMouse = param1;
         if(this._lastMoveWasMouse)
         {
            if(this._lastMouseOveredPresetItem != -1)
            {
               this.presetSelected = true;
               this.mcPresetList.selectedIndex = this._lastMouseOveredPresetItem;
               this.mcOptionList.selectedIndex = -1;
            }
            else if(this._lastMouseOveredOptionItem != -1)
            {
               this.presetSelected = false;
               this.mcPresetList.selectedIndex = -1;
               this.mcOptionList.selectedIndex = this.mcOptionList.getRendererAt(this._lastMouseOveredOptionItem,this.mcOptionList.scrollPosition).index;
            }
         }
         else if(this.mcOptionList.selectedIndex == -1 && this.mcPresetList.selectedIndex == -1)
         {
            this.presetSelected = false;
            this.mcOptionList.selectedIndex = 0;
         }
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.mcOptionList.bIsOptionList = true;
         this.optionListItems = new Array(this.mcOptionListItem1,this.mcOptionListItem2,this.mcOptionListItem3,this.mcOptionListItem4,this.mcOptionListItem5,this.mcOptionListItem6,this.mcOptionListItem7,this.mcOptionListItem8,this.mcOptionListItem9);
         this.itemsX = this.mcOptionListItem1.x;
         if(this.mcOptionList)
         {
            this.mcOptionList.focusable = false;
            this.mcOptionList.addEventListener(ListEvent.INDEX_CHANGE,this.onOptionSelectionChanged);
         }
         if(this.mcPresetOption)
         {
            this.mcPresetList = this.mcPresetOption.getChildByName("mcScrollingList") as W3ScrollingList;
            this.mcPresetList.focusable = false;
            this.txtPresetTitle = this.mcPresetOption.getChildByName("txtPresetTitle") as TextField;
            this.mcScrollingListItem1 = this.mcPresetOption.getChildByName("mcScrollingListItem1") as W3MenuListItemRenderer;
            this.setupPresetItemMouseEvents(this.mcScrollingListItem1);
            this.mcScrollingListItem2 = this.mcPresetOption.getChildByName("mcScrollingListItem2") as W3MenuListItemRenderer;
            this.setupPresetItemMouseEvents(this.mcScrollingListItem2);
            this.mcScrollingListItem3 = this.mcPresetOption.getChildByName("mcScrollingListItem3") as W3MenuListItemRenderer;
            this.setupPresetItemMouseEvents(this.mcScrollingListItem3);
            this.mcScrollingListItem4 = this.mcPresetOption.getChildByName("mcScrollingListItem4") as W3MenuListItemRenderer;
            this.setupPresetItemMouseEvents(this.mcScrollingListItem4);
            this.mcScrollingListItem5 = this.mcPresetOption.getChildByName("mcScrollingListItem5") as W3MenuListItemRenderer;
            this.setupPresetItemMouseEvents(this.mcScrollingListItem5);
            this.mcPresetList.addEventListener(ListEvent.INDEX_CHANGE,this.handlePresetIndexChanged,false,0,true);
            this.mcPresetList.PCUpAction = KeyCode.A;
            this.mcPresetList.PCDownAction = KeyCode.D;
         }
         this.txtOptionDescription = getChildByName("txtOptionDescription") as TextField;
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMove,false,0,true);
         if(this.mcOptionScrollbar)
         {
            this.mcOptionScrollbar.addEventListener(Event.SCROLL,this.handleOptionScroll,false,1,true);
         }
         visible = false;
         enabled = false;
         alpha = 0;
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"options.insert_entry",[this.onInsertOptionsEntry]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"options.remove_entry",[this.onRemoveOptionsEntry]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"options.update_disabled",[this.onUpdateDisabled]));
      }
      
      public function showWithData(param1:Array) : void
      {
         var _loc4_:int = 0;
         if(!this.mcOptionList)
         {
            return;
         }
         var _loc2_:IngameMenu = parent as IngameMenu;
         var _loc3_:Array = new Array();
         visible = true;
         enabled = true;
         this.mcOptionList.selectedIndex = -1;
         this.txtOptionDescription.text = "";
         GTweener.removeTweens(this);
         GTweener.to(this,0.2,{"alpha":1},{});
         this.presetSelected = false;
         _loc4_ = 0;
         while(_loc4_ < param1.length)
         {
            if(!param1[_loc4_].checkHardwareCursor || !_loc2_._hardwareCursorOn)
            {
               _loc3_.push(param1[_loc4_]);
            }
            _loc4_++;
         }
         this.optionListData = _loc3_;
         this.setupDataProviders(_loc3_);
         if(this.mcOptionList.selectedIndex == 0)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnPlaySoundEvent",["gui_global_highlight"]));
         }
         if(!this.lastMoveWasMouse)
         {
            this.mcOptionList.selectedIndex = 0;
            this.mcOptionList.dispatchEvent(new ListEvent(ListEvent.INDEX_CHANGE,false,false,0));
         }
         else
         {
            this.mcOptionList.selectedIndex = -1;
         }
      }
      
      public function updateData(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(Boolean(this.mcPresetList) && this.mcPresetList.visible)
         {
            _loc2_ = this.mcPresetList.selectedIndex;
         }
         _loc3_ = this.mcOptionList.selectedIndex;
         this.setupDataProviders(param1);
         this.mcPresetList.validateNow();
         this.mcOptionList.validateNow();
         if(Boolean(this.mcPresetList) && this.mcPresetList.visible)
         {
            this.mcPresetList.selectedIndex = _loc2_;
            this.mcPresetList.validateNow();
         }
         this.mcOptionList.selectedIndex = _loc3_;
         this.mcOptionList.validateNow();
      }
      
      internal function onOptionSelectionChanged(param1:ListEvent) : void
      {
         this.updateDescriptionText(param1.itemData);
      }
      
      public function updateDescriptionText(param1:Object) : void
      {
         var _loc2_:String = "";
         if(param1)
         {
            if(param1.description)
            {
               _loc2_ = String(param1.description);
            }
            else if(Boolean(param1.descriptionTrue) && param1.current == "true")
            {
               _loc2_ = String(param1.descriptionTrue);
            }
            else if(Boolean(param1.descriptionFalse) && param1.current == "false")
            {
               _loc2_ = String(param1.descriptionFalse);
            }
         }
         this.txtOptionDescription.htmlText = _loc2_;
      }
      
      protected function setupDataProviders(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:Array = new Array();
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            if(param1[_loc2_].id == "Presets")
            {
               _loc3_ = param1[_loc2_];
            }
            else
            {
               _loc4_.push(param1[_loc2_]);
            }
            _loc2_++;
         }
         this.setPresetData(_loc3_);
         this.mcOptionList.dataProvider = new DataProvider(_loc4_);
         this.mcOptionList.validateNow();
      }
      
      private function onUpdateDisabled(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.optionListData == null)
         {
            return;
         }
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = 0;
            while(_loc3_ < this.optionListData.length)
            {
               if(this.optionListData[_loc3_].tag == param1[_loc2_].tag)
               {
                  this.optionListData[_loc3_].disabled = param1[_loc2_].disabled;
                  break;
               }
               _loc3_++;
            }
            _loc2_++;
         }
         this.setupDataProviders(this.optionListData);
         this.mcOptionList.validateNow();
      }
      
      private function getOptionDataForScreenIndex(param1:int) : Object
      {
         var _loc2_:int = int(this.mcOptionList.scrollPosition);
         var _loc3_:int = param1 + _loc2_;
         if(_loc3_ < 0 || _loc3_ >= this.optionListData.length)
         {
            return null;
         }
         return this.optionListData[_loc3_];
      }
      
      private function getListItem(param1:int) : W3SubMenuListItemRenderer
      {
         if(param1 >= 0 && param1 < this.optionListItems.length)
         {
            return this.optionListItems[param1];
         }
         return null;
      }
      
      public function setPresetData(param1:Object) : void
      {
         if(!this.mcPresetOption)
         {
            return;
         }
         if(Boolean(param1) && Boolean(this.mcPresetList))
         {
            this.presetsEnabled = true;
            this.mcPresetOption.visible = true;
            this.mcPresetList.dataProvider = new DataProvider(param1.subElements);
            this.mcPresetList.validateNow();
            this.mcPresetList.selectedIndex = -1;
            this.currentPresetGroupName = param1.GroupName;
            if(this.txtPresetTitle)
            {
               if(CoreComponent.isArabicAligmentMode)
               {
                  this.txtPresetTitle.htmlText = "<p align=\"right\">" + param1.label + "</p>";
               }
               else
               {
                  this.txtPresetTitle.htmlText = param1.label;
               }
            }
         }
         else
         {
            this.presetsEnabled = false;
            this.mcPresetOption.visible = false;
         }
      }
      
      public function hide() : void
      {
         if(visible)
         {
            GTweener.removeTweens(this);
            enabled = false;
            (parent as IngameMenu).showApplyPresetInputFeedback(false);
            GTweener.to(this,0.2,{"alpha":0},{"onComplete":this.onHideComplete});
         }
      }
      
      protected function onHideComplete(param1:GTween) : void
      {
         visible = false;
      }
      
      protected function handleMouseMove(param1:MouseEvent) : void
      {
         if(!visible)
         {
            return;
         }
         var _loc2_:W3MenuListItemRenderer = this.getPresetUnderMouse(param1.stageX,param1.stageY);
         if(_loc2_)
         {
            this.mcPresetList.selectedIndex = _loc2_.index;
            this._lastMouseOveredPresetItem = _loc2_.index;
         }
         else
         {
            this.mcPresetList.selectedIndex = -1;
            this._lastMouseOveredPresetItem = -1;
         }
         var _loc3_:W3SubMenuListItemRenderer = this.getOptionUnderMouse(param1.stageX,param1.stageY);
         if(_loc3_)
         {
            this.mcOptionList.selectedIndex = _loc3_.index;
            this._lastMouseOveredOptionItem = _loc3_.index;
         }
         else
         {
            this.mcOptionList.selectedIndex = -1;
            this._lastMouseOveredOptionItem = -1;
         }
      }
      
      protected function getPresetUnderMouse(param1:int, param2:int) : W3MenuListItemRenderer
      {
         if(this.mcPresetList.dataProvider.length == 0)
         {
            return null;
         }
         if(this.mcScrollingListItem1.hitTestPoint(param1,param2))
         {
            return this.mcScrollingListItem1;
         }
         if(this.mcScrollingListItem2.hitTestPoint(param1,param2))
         {
            return this.mcScrollingListItem2;
         }
         if(this.mcScrollingListItem3.hitTestPoint(param1,param2))
         {
            return this.mcScrollingListItem3;
         }
         if(this.mcScrollingListItem4.hitTestPoint(param1,param2))
         {
            return this.mcScrollingListItem4;
         }
         if(this.mcScrollingListItem5.hitTestPoint(param1,param2))
         {
            return this.mcScrollingListItem5;
         }
         return null;
      }
      
      protected function getOptionUnderMouse(param1:int, param2:int) : W3SubMenuListItemRenderer
      {
         var _loc5_:* = undefined;
         var _loc6_:int = 0;
         var _loc3_:int = int(this.mcOptionList.scrollPosition);
         var _loc4_:int = 0;
         while(_loc4_ < this.optionListItems.length)
         {
            if((_loc5_ = this.optionListItems[_loc4_]).hitTestPoint(param1,param2))
            {
               _loc6_ = _loc3_ + _loc4_;
               if(this.optionListData && _loc6_ < this.optionListData.length && Boolean(this.optionListData[_loc6_].disabled))
               {
                  return null;
               }
               return _loc5_;
            }
            _loc4_++;
         }
         return null;
      }
      
      protected function setupPresetItemMouseEvents(param1:W3MenuListItemRenderer) : void
      {
         param1.addEventListener(MouseEvent.CLICK,this.onPresetItemClicked,false,0,true);
      }
      
      protected function onPresetItemClicked(param1:MouseEvent) : void
      {
         if(!visible)
         {
            return;
         }
         var _loc2_:MouseEventEx = param1 as MouseEventEx;
         if(_loc2_.buttonIdx == MouseEventEx.LEFT_BUTTON)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnPresetApplied",[this.currentPresetGroupName,this.mcPresetList.selectedIndex]));
            param1.stopImmediatePropagation();
         }
      }
      
      private function handleOptionScroll(param1:Event) : void
      {
         var _loc3_:W3SubMenuListItemRenderer = null;
         var _loc2_:IngameMenu = parent as IngameMenu;
         if(!visible || !this.lastMoveWasMouse)
         {
            return;
         }
         if(this._lastMouseOveredOptionItem != -1)
         {
            _loc3_ = this.mcOptionList.getRendererAt(this._lastMouseOveredOptionItem,this.mcOptionList.scrollPosition) as W3SubMenuListItemRenderer;
            if(_loc3_)
            {
               this.mcOptionList.selectedIndex = _loc3_.index;
            }
         }
      }
      
      public function handleInputNavigate(param1:InputEvent) : void
      {
         var _loc2_:InputDetails = null;
         var _loc3_:* = false;
         var _loc4_:W3SubMenuListItemRenderer = null;
         if(visible)
         {
            _loc2_ = param1.details;
            _loc3_ = _loc2_.value == InputValue.KEY_UP;
            _loc4_ = this.mcOptionList.getSelectedRenderer() as W3SubMenuListItemRenderer;
            if(this.presetSelected)
            {
               this.mcPresetList.handleInput(param1);
            }
            else
            {
               this.mcOptionList.handleInput(param1);
            }
            if(!param1.handled)
            {
               if(_loc3_ && _loc4_ && _loc2_.code == KeyCode.E)
               {
                  _loc4_.activate();
               }
               switch(_loc2_.navEquivalent)
               {
                  case NavigationCode.GAMEPAD_A:
                     if(_loc3_)
                     {
                        if(this.mcPresetList && this.mcPresetList.visible && this.mcPresetList.selectedIndex != -1)
                        {
                           dispatchEvent(new GameEvent(GameEvent.CALL,"OnPresetApplied",[this.currentPresetGroupName,this.mcPresetList.selectedIndex]));
                        }
                        else if(_loc4_)
                        {
                           _loc4_.activate();
                        }
                     }
                     break;
                  case NavigationCode.GAMEPAD_B:
                     if(_loc3_)
                     {
                        this.handleNavigateBack();
                     }
                     break;
                  case NavigationCode.UP:
                     if(!_loc3_ && this.presetsEnabled)
                     {
                        if(!this.presetSelected && this.mcPresetList.visible)
                        {
                           this.presetSelected = true;
                           this.mcPresetList.selectedIndex = 0;
                           this.mcOptionList.selectedIndex = -1;
                        }
                     }
                     break;
                  case NavigationCode.DOWN:
                     if(!_loc3_ && this.presetsEnabled)
                     {
                        if(this.presetSelected)
                        {
                           this.presetSelected = false;
                           this.mcPresetList.selectedIndex = -1;
                           this.mcOptionList.selectedIndex = -1;
                           this.mcOptionList.moveDown();
                        }
                     }
               }
            }
         }
      }
      
      public function onRightClick(param1:MouseEvent) : void
      {
         if(visible)
         {
            this.handleNavigateBack();
         }
      }
      
      public function handleNavigateBack() : void
      {
         dispatchEvent(new Event(IngameMenu.OnOptionPanelClosed,false,false));
         (parent as IngameMenu).mcInputFeedbackModule.removeButton(ACTION_DOWNLOAD,true);
      }
      
      protected function handlePresetIndexChanged(param1:ListEvent) : void
      {
         if(Boolean(this.mcPresetList) && this.mcPresetList.visible)
         {
            (parent as IngameMenu).showApplyPresetInputFeedback(param1.index != -1);
         }
      }
      
      private function onInsertOptionsEntry(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc7_:uint = 0;
         var _loc3_:int = -1;
         var _loc4_:DataProvider = this.mcOptionList.dataProvider as DataProvider;
         var _loc5_:Boolean = false;
         _loc7_ = 0;
         while(_loc7_ < _loc4_.length)
         {
            if(_loc4_[_loc7_].tag == param1.masterTag)
            {
               _loc3_ = int(_loc7_);
               break;
            }
            _loc7_++;
         }
         if(_loc3_ == -1 && param1.masterTag != 0)
         {
            return;
         }
         var _loc6_:uint = 0;
         while(_loc6_ < param1.list.length)
         {
            _loc5_ = false;
            _loc7_ = 0;
            while(_loc7_ < _loc4_.length)
            {
               if(_loc4_[_loc7_].tag == param1.list[_loc6_].tag)
               {
                  _loc5_ = true;
                  break;
               }
               _loc7_++;
            }
            if(!_loc5_)
            {
               _loc4_.splice(_loc3_ + 1,0,param1.list[_loc6_]);
               _loc3_ += 1;
            }
            _loc6_++;
         }
         this.mcOptionList.invalidateData();
      }
      
      private function onRemoveOptionsEntry(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc6_:uint = 0;
         var _loc3_:int = -1;
         var _loc4_:DataProvider = this.mcOptionList.dataProvider as DataProvider;
         var _loc5_:uint = 0;
         while(_loc5_ < param1.list.length)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc4_.length)
            {
               if(_loc4_[_loc6_].tag == param1.list[_loc5_].tag)
               {
                  _loc3_ = int(_loc6_);
                  break;
               }
               _loc6_++;
            }
            if(_loc3_ != -1)
            {
               _loc4_.splice(_loc3_,1);
               _loc3_ = -1;
            }
            _loc5_++;
         }
         this.mcOptionList.invalidateData();
      }
   }
}
