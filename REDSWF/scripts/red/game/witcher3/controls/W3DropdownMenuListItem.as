package red.game.witcher3.controls
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextFieldAutoSize;
   import flash.utils.getDefinitionByName;
   import red.core.CoreComponent;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.events.CategoryChangeEvent;
   import red.game.witcher3.menus.common.IconItemRenderer;
   import red.game.witcher3.slots.SlotsListBase;
   import red.game.witcher3.slots.SlotsListGrid;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.InvalidationType;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.controls.CoreList;
   import scaleform.clik.controls.DropdownMenu;
   import scaleform.clik.controls.ListItemRenderer;
   import scaleform.clik.controls.ScrollingList;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.data.ListData;
   import scaleform.clik.events.ButtonEvent;
   import scaleform.clik.events.ComponentEvent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.clik.interfaces.IListItemRenderer;
   import scaleform.clik.ui.InputDetails;
   
   public class W3DropdownMenuListItem extends DropdownMenu implements IListItemRenderer
   {
      
      public static var staticSortedFunction:Function;
       
      
      protected var _index:uint = 0;
      
      protected var _selectable:Boolean = true;
      
      protected var _handleKeyUpInput:Boolean;
      
      protected var dropDownData:Array;
      
      public var isColapsable:Boolean = true;
      
      public var mcOpenedState:MovieClip;
      
      private var categoryTag:uint;
      
      private var bOpenedByDefault:Boolean = false;
      
      private var categoryPostfix:String = "";
      
      protected var bLabelSortingEnabled:Boolean = true;
      
      public var selectionEventName:String = "OnEntrySelected";
      
      public var lastSelectedColumn:int = 0;
      
      private var _activeSelectionEnabled:Boolean = true;
      
      protected var _my_data:Object;
      
      public function W3DropdownMenuListItem()
      {
         super();
         menuRowsFixed = false;
         preventAutosizing = true;
         constraintsDisabled = true;
         this.CategoryTag = 0;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         addEventListener(ButtonEvent.CLICK,this.handleItemPress,false,0,true);
      }
      
      override public function toString() : String
      {
         return "[W3 W3DropdownMenuListItem: ]";
      }
      
      override public function get focusable() : Boolean
      {
         return _focusable;
      }
      
      override public function set focusable(param1:Boolean) : void
      {
      }
      
      public function get handleKeyUpInput() : Boolean
      {
         return this._handleKeyUpInput;
      }
      
      public function set handleKeyUpInput(param1:Boolean) : void
      {
         this._handleKeyUpInput = param1;
      }
      
      public function get index() : uint
      {
         return this._index;
      }
      
      public function set index(param1:uint) : void
      {
         this._index = param1;
      }
      
      public function get selectable() : Boolean
      {
         return this._selectable;
      }
      
      public function set selectable(param1:Boolean) : void
      {
         this._selectable = param1;
      }
      
      public function get CategoryTag() : uint
      {
         return this.categoryTag;
      }
      
      public function set CategoryTag(param1:uint) : void
      {
         this.categoryTag = param1;
      }
      
      public function setListData(param1:ListData) : void
      {
         this.index = param1.index;
         this.selected = param1.selected;
      }
      
      public function set activeSelectionEnabled(param1:Boolean) : void
      {
         var _loc2_:W3ScrollingList = null;
         var _loc3_:IconItemRenderer = null;
         var _loc4_:int = 0;
         this._activeSelectionEnabled = param1;
         if(Boolean(_dropdownRef) && _dropdownRef is W3ScrollingList)
         {
            _loc2_ = _dropdownRef as W3ScrollingList;
            _loc4_ = 0;
            while(_loc4_ < _loc2_.numRenderers)
            {
               _loc3_ = _loc2_.getRendererAt(_loc4_) as IconItemRenderer;
               if(_loc3_)
               {
                  _loc3_.activeSelectionEnabled = param1;
               }
               _loc4_++;
            }
         }
      }
      
      override public function get data() : Object
      {
         return this._my_data;
      }
      
      override public function set data(param1:Object) : void
      {
         this._my_data = param1;
      }
      
      public function setData(param1:Object) : void
      {
         var _loc2_:Array = null;
         if(param1)
         {
            this.data = param1;
            _loc2_ = param1 as Array;
            if(_loc2_)
            {
               if(_loc2_[0].dropDownTag != null)
               {
                  this.CategoryTag = _loc2_[0].dropDownTag;
               }
               if(_loc2_[0].dropDownOpened != null)
               {
                  this.bOpenedByDefault = _loc2_[0].dropDownOpened;
               }
               if(_loc2_[0].categoryPostfix)
               {
                  this.categoryPostfix = _loc2_[0].categoryPostfix;
               }
               else
               {
                  this.categoryPostfix = "";
               }
            }
         }
      }
      
      public function clearRenderers() : void
      {
         if(isOpen())
         {
            this.close();
         }
         validateNow();
      }
      
      override public function set label(param1:String) : void
      {
         _label = CommonUtils.toUpperCaseSafe(param1);
         this.updateText();
      }
      
      override public function get label() : String
      {
         return _label;
      }
      
      override protected function updateText() : void
      {
         if(_label != null && textField != null)
         {
            if(CoreComponent.isArabicAligmentMode)
            {
               textField.htmlText = "<p align=\"right\">" + _label + this.categoryPostfix + "</p>";
            }
            else
            {
               textField.htmlText = _label + this.categoryPostfix;
            }
         }
      }
      
      public function updateDropdownData(param1:Array) : void
      {
         this.dropDownData = param1;
         if(_dropdownRef as CoreList)
         {
            (_dropdownRef as CoreList).dataProvider = new DataProvider(param1);
         }
         else if(_dropdownRef as SlotsListBase)
         {
            (_dropdownRef as SlotsListBase).data = param1;
         }
      }
      
      public function setDropdownData(param1:Object) : void
      {
         this.dropDownData = param1 as Array;
      }
      
      public function updateDropdownDataSurgically(param1:Array) : void
      {
         var _loc3_:W3DropDownItemRenderer = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:W3ScrollingList = _dropdownRef as W3ScrollingList;
         if(_loc2_)
         {
            _loc4_ = 0;
            while(_loc4_ < param1.length)
            {
               _loc5_ = 0;
               while(_loc5_ < this.dropDownData.length)
               {
                  if(isOpen())
                  {
                     _loc3_ = _loc2_.getRendererAt(_loc5_) as W3DropDownItemRenderer;
                     if(_loc3_.data.tag == param1[_loc4_].tag)
                     {
                        _loc3_.setData(param1[_loc4_]);
                        _loc3_.validateNow();
                        _loc2_.dataProvider[_loc5_] = param1[_loc4_];
                        this.dropDownData[_loc5_] = param1[_loc4_];
                        break;
                     }
                  }
                  else if(this.dropDownData[_loc5_].tag == param1[_loc4_].tag)
                  {
                     this.dropDownData[_loc5_] = param1[_loc4_];
                  }
                  _loc5_++;
               }
               _loc4_++;
            }
         }
      }
      
      public function getDropDownData() : Array
      {
         return this.dropDownData;
      }
      
      public function HasInitialSelection() : Boolean
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.dropDownData.length)
         {
            if(this.dropDownData[_loc1_].selected)
            {
               selectedIndex = _loc1_;
               this.dropDownData[_loc1_].isNew = false;
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      public function IsOpenedByDefault() : Boolean
      {
         if(this.bOpenedByDefault)
         {
            return true;
         }
         return false;
      }
      
      public function GetDropdownListRef() : ScrollingList
      {
         return _dropdownRef as ScrollingList;
      }
      
      public function GetDropdownGridRef() : UIComponent
      {
         return _dropdownRef as UIComponent;
      }
      
      public function IsSubListItemSelected() : Boolean
      {
         if(_dropdownRef)
         {
            return _dropdownRef.selectedIndex > -1;
         }
         return false;
      }
      
      public function GetSubSelectedRenderer(param1:Boolean = false) : UIComponent
      {
         if(Boolean(_dropdownRef) && (selectedIndex != -1 || param1))
         {
            if(_dropdownRef is SlotsListBase)
            {
               return (_dropdownRef as SlotsListBase).getSelectedRenderer() as UIComponent;
            }
            if(_dropdownRef is ScrollingList)
            {
               return (_dropdownRef as ScrollingList).getSelectedRenderer() as UIComponent;
            }
         }
         return null;
      }
      
      public function SelectLastSubListItem() : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:ListItemRenderer = null;
         var _loc5_:IListItemRenderer = null;
         var _loc1_:SlotsListBase = _dropdownRef as SlotsListBase;
         if(_loc1_)
         {
            _loc2_ = _loc1_.getRenderersCount() - 1;
            if(_loc1_.numColumns <= 0 || _loc2_ < 0)
            {
               _dropdownRef.selectedIndex = _loc2_ - _loc1_.getColumn(_loc2_);
            }
            else
            {
               _loc3_ = _loc2_ % _loc1_.numColumns;
               if(this.lastSelectedColumn >= _loc3_)
               {
                  _dropdownRef.selectedIndex = _loc2_;
               }
               else
               {
                  _dropdownRef.selectedIndex = _loc2_ + this.lastSelectedColumn - _loc3_;
               }
            }
         }
         else
         {
            _dropdownRef.selectedIndex = _dropdownRef.dataProvider.length - 1;
         }
         if(_dropdownRef is W3ScrollingList)
         {
            _loc4_ = _dropdownRef.getRendererAt(_dropdownRef.selectedIndex) as ListItemRenderer;
            dispatchEvent(new ListEvent(ListEvent.INDEX_CHANGE,true,false,_dropdownRef.selectedIndex,-1,-1,_loc4_,!!_loc4_ ? _loc4_.data : null));
         }
         else if(_loc1_)
         {
            selectedIndex = _loc1_.selectedIndex;
            _loc5_ = _loc1_.getRendererAt(_loc1_.selectedIndex);
            dispatchEvent(new ListEvent(ListEvent.INDEX_CHANGE,true,false,_loc1_.selectedIndex,-1,-1,_loc5_,_loc1_));
         }
      }
      
      public function SelectSubListItem(param1:int) : void
      {
         this.changeFocus();
         _dropdownRef.selectedIndex = param1;
         selectedIndex = param1;
      }
      
      public function GetDropdownListHeight() : Number
      {
         var _loc2_:BaseListItem = null;
         var _loc3_:W3ScrollingList = null;
         var _loc4_:SlotsListBase = null;
         var _loc1_:Number = 0;
         if(_dropdownRef as W3ScrollingList)
         {
            _loc3_ = _dropdownRef as W3ScrollingList;
            _loc1_ = _loc3_.GetDropdownListHeight();
         }
         else if(_dropdownRef as SlotsListBase)
         {
            _loc1_ = (_loc4_ = _dropdownRef as SlotsListBase).GetDropdownListHeight();
         }
         return _loc1_;
      }
      
      public function SetDropdownListVerticalPosition(param1:Number) : void
      {
         _dropdownRef.y = param1;
      }
      
      override protected function updateLabel(param1:Object) : void
      {
         _label = this.data[0].label as String;
      }
      
      override protected function populateText(param1:Object) : void
      {
         this.updateLabel(param1);
      }
      
      override protected function updateAfterStateChange() : void
      {
      }
      
      override protected function draw() : void
      {
         if(isInvalid(InvalidationType.STATE))
         {
            if(_newFrame)
            {
               gotoAndPlay(_newFrame);
               _newFrame = null;
            }
            if(_newFocusIndicatorFrame)
            {
               focusIndicator.gotoAndPlay(_newFocusIndicatorFrame);
               _newFocusIndicatorFrame = null;
            }
            this.updateAfterStateChange();
            dispatchEvent(new ComponentEvent(ComponentEvent.STATE_CHANGE));
            invalidate(InvalidationType.DATA,InvalidationType.SIZE);
         }
         if(isInvalid(InvalidationType.DATA))
         {
            this.updateText();
            if(autoSize != TextFieldAutoSize.NONE)
            {
               invalidateSize();
            }
         }
      }
      
      override protected function showDropdown() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:Class = null;
         if(dropdown == null || _dropdownRef != null)
         {
            return;
         }
         if(dropdown is String && dropdown != "")
         {
            _loc2_ = getDefinitionByName(dropdown.toString()) as Class;
            if(_loc2_ != null)
            {
               _loc1_ = new _loc2_();
               if(_loc1_ as CoreList)
               {
                  this.CreateSubList(_loc1_);
               }
               else if(_loc1_ as SlotsListBase)
               {
                  this.CreateSubGrid(_loc1_);
               }
            }
         }
      }
      
      private function CreateSubList(param1:MovieClip) : void
      {
         var _loc3_:W3ScrollingList = null;
         var _loc4_:IconItemRenderer = null;
         var _loc5_:int = 0;
         if(itemRenderer is String && itemRenderer != "")
         {
            param1.itemRenderer = getDefinitionByName(itemRenderer.toString()) as Class;
         }
         else if(itemRenderer is Class)
         {
            param1.itemRenderer = itemRenderer as Class;
         }
         if(scrollBar is String && scrollBar != "")
         {
            param1.scrollBar = getDefinitionByName(scrollBar.toString()) as Class;
         }
         else if(scrollBar is Class)
         {
            param1.scrollBar = scrollBar as Class;
         }
         param1.selectedIndex = _selectedIndex;
         param1.width = menuWidth == -1 ? width + menuOffset.left + menuOffset.right : menuWidth;
         param1.ignoreHeightForRendererCreation = true;
         var _loc2_:DataProvider = new DataProvider(this.dropDownData);
         if(staticSortedFunction != null)
         {
            staticSortedFunction(_loc2_);
         }
         else if(this.bLabelSortingEnabled)
         {
            _loc2_.sortOn("label",Array.CASEINSENSITIVE);
         }
         param1.dataProvider = _loc2_;
         menuRowCount = this.dropDownData.length;
         param1.padding = menuPadding;
         param1.x += 12;
         param1.wrapping = menuWrapping;
         param1.margin = menuMargin;
         param1.thumbOffset = {
            "top":thumbOffsetTop,
            "bottom":thumbOffsetBottom
         };
         param1.focusTarget = this;
         param1.rowCount = menuRowCount;
         param1.labelField = _labelField;
         param1.labelFunction = _labelFunction;
         param1.addEventListener(ListEvent.ITEM_CLICK,this.handleMenuItemClick,false,0,true);
         param1.addEventListener(ListEvent.INDEX_CHANGE,this.handleSelectChange,false,10,true);
         param1.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,this.handleMenuItemDoubleClick,false,0,true);
         param1.addEventListener(ListEvent.ITEM_PRESS,this.handleMenuItemPress,false,0,true);
         param1.focusable = false;
         _dropdownRef = param1;
         parent.addChildAt(param1,0);
         if(Boolean(param1) && param1 is W3ScrollingList)
         {
            _loc3_ = param1 as W3ScrollingList;
            _loc3_.validateNow();
            _loc5_ = 0;
            while(_loc5_ < _loc3_.numRenderers)
            {
               if(_loc4_ = _loc3_.getRendererAt(_loc5_) as IconItemRenderer)
               {
                  _loc4_.activeSelectionEnabled = this._activeSelectionEnabled;
               }
               _loc5_++;
            }
         }
      }
      
      private function CreateSubGrid(param1:MovieClip) : void
      {
         if(itemRenderer is String && itemRenderer != "")
         {
            param1.slotRendererName = itemRenderer.toString();
         }
         else if(itemRenderer is Class)
         {
            param1.slotRenderer = itemRenderer as Class;
         }
         if(scrollBar is String && scrollBar != "")
         {
            param1.scrollBar = getDefinitionByName(scrollBar.toString()) as Class;
         }
         else if(scrollBar is Class)
         {
            param1.scrollBar = scrollBar as Class;
         }
         var _loc2_:SlotsListBase = param1 as SlotsListBase;
         var _loc3_:SlotsListGrid = _loc2_ as SlotsListGrid;
         if(_loc3_)
         {
            _loc3_.gridSquareSize = 64;
            _loc3_.elementGridSquareOffset = 0;
            _loc3_.ignoreGridPosition = true;
            _loc3_.initFindSelection = false;
            _loc3_.calculateColumnsAndRows(this.dropDownData.length);
         }
         _dropdownRef = _loc2_;
         parent.addChild(_loc2_);
         _loc2_.visible = true;
         _loc2_.validateNow();
         _loc2_.data = this.dropDownData;
         _loc2_.focusable = false;
         _loc2_.selectedIndex = _selectedIndex;
         _loc2_.addEventListener(ListEvent.ITEM_CLICK,this.handleMenuItemClick,false,0,true);
         _loc2_.addEventListener(ListEvent.INDEX_CHANGE,this.handleSelectChange,false,10,true);
         stage.dispatchEvent(new Event(W3ScrollingList.REPOSITION));
      }
      
      protected function handleSelectChange(param1:ListEvent) : *
      {
         dispatchEvent(param1);
      }
      
      protected function handleItemPress(param1:ButtonEvent) : *
      {
         W3DropDownList(parent).previousSelectedIndex = -3;
         W3DropDownList(parent).ResetPreviousDropdownSelection(W3DropDownList(parent).selectedIndex);
         W3DropDownList(parent).selectedIndex = this.index;
         if(!isOpen())
         {
            this.open();
         }
         else
         {
            this.close();
         }
      }
      
      override protected function handleClick(param1:uint = 0) : void
      {
      }
      
      private function StoreData() : *
      {
         var _loc1_:int = 0;
         var _loc2_:W3DropdownMenuListItem = null;
         if(!(_dropdownRef as SlotsListBase))
         {
            _loc1_ = 0;
            while(_loc1_ < dataProvider.length)
            {
               _loc2_ = _dropdownRef.getRendererAt(_loc1_) as W3DropdownMenuListItem;
               this.dropDownData[_loc1_] = _loc2_.getDropDownData();
               _loc1_++;
            }
         }
      }
      
      override public function open(param1:Boolean = true) : void
      {
         this.showDropdown();
         if(param1)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnPlaySoundEvent",["gui_global_dropdown_open"]));
         }
         if(this.isColapsable)
         {
            this.mcOpenedState.gotoAndStop("opened");
         }
         else
         {
            this.mcOpenedState.gotoAndStop("always_opened");
         }
         var _loc2_:CoreList = _dropdownRef as CoreList;
         if(_loc2_)
         {
            _loc2_.validateNow();
            _loc2_.selectedIndex = -1;
            _loc2_.validateNow();
         }
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnCategoryOpened",[this.CategoryTag,true]));
      }
      
      override public function close() : void
      {
         if(this.isColapsable)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnCategoryOpened",[this.CategoryTag,false]));
            this.StoreData();
            hideDropdown();
            selectedIndex = -1;
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnPlaySoundEvent",["gui_global_dropdown_close"]));
            this.mcOpenedState.gotoAndStop("closed");
            if(stage)
            {
               stage.dispatchEvent(new Event(W3ScrollingList.REPOSITION));
            }
         }
      }
      
      override protected function handleStageClick(param1:MouseEvent) : void
      {
      }
      
      override protected function handleMenuItemClick(param1:ListEvent) : void
      {
         var _loc2_:W3DropDownList = parent as W3DropDownList;
         if(_loc2_)
         {
            _loc2_.previousSelectedIndex = -3;
            if(_loc2_.selectedIndex != _loc2_.getRenderers().indexOf(this))
            {
               _loc2_.ResetPreviousDropdownSelection(_loc2_.selectedIndex);
            }
            _loc2_.selectedIndex = this.index;
         }
         if(_dropdownRef as SlotsListBase)
         {
            _dropdownRef.selectedIndex = param1.index;
         }
         else
         {
            selectedIndex = param1.index;
         }
      }
      
      protected function handleMenuItemDoubleClick(param1:ListEvent) : void
      {
      }
      
      protected function handleMenuItemPress(param1:ListEvent) : void
      {
      }
      
      override protected function changeFocus() : void
      {
         var _loc1_:String = null;
         if(!enabled)
         {
            return;
         }
         if(_focusIndicator == null)
         {
            if(Boolean(_focused) || _displayFocus)
            {
               if(Boolean(_dropdownRef) && _dropdownRef.selectedIndex != -1)
               {
                  setState("up");
               }
               else
               {
                  setState("over");
               }
            }
            else
            {
               setState("out");
            }
            if(_pressedByKeyboard && !_focused)
            {
               _pressedByKeyboard = false;
            }
         }
         else
         {
            if(_focusIndicator.totalframes == 1)
            {
               _focusIndicator.visible = _focused > 0;
            }
            else
            {
               _loc1_ = "state" + _focused;
               if(_focusIndicatorLabelHash[_loc1_])
               {
                  _newFocusIndicatorFrame = "state" + _focused;
               }
               else
               {
                  _newFocusIndicatorFrame = Boolean(_focused) || _displayFocus ? "show" : "hide";
               }
               invalidateState();
            }
            if(_pressedByKeyboard && !_focused)
            {
               setState("kb_release");
               _pressedByKeyboard = false;
            }
         }
      }
      
      override public function set selected(param1:Boolean) : void
      {
         var _loc2_:CategoryChangeEvent = null;
         if(param1 != _selected)
         {
            _loc2_ = new CategoryChangeEvent(CategoryChangeEvent.CATEGORY_CHANGED,true);
            _loc2_.categoryIdx = this.index;
            _loc2_.categoryItemRenderer = this;
            dispatchEvent(_loc2_);
         }
         super.selected = param1;
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc5_:SlotsListBase = null;
         var _loc7_:MovieClip = null;
         var _loc8_:IListItemRenderer = null;
         if(param1.handled || !_selected || !enabled)
         {
            return;
         }
         var _loc2_:InputDetails = param1.details;
         var _loc3_:Boolean = _loc2_.value == InputValue.KEY_DOWN || _loc2_.value == InputValue.KEY_HOLD;
         var _loc4_:String = _loc2_.navEquivalent;
         switch(_loc2_.code)
         {
            case KeyCode.W:
               _loc4_ = NavigationCode.UP;
               break;
            case KeyCode.S:
               _loc4_ = NavigationCode.DOWN;
               break;
            case KeyCode.E:
               _loc4_ = NavigationCode.GAMEPAD_A;
         }
         _loc5_ = _dropdownRef as SlotsListBase;
         var _loc6_:CoreList;
         if((Boolean(_loc6_ = _dropdownRef as CoreList)) && isOpen())
         {
            selectedIndex = _loc6_.selectedIndex;
            validateNow();
         }
         switch(_loc4_)
         {
            case NavigationCode.GAMEPAD_Y:
               if(selected && _loc2_.value == InputValue.KEY_DOWN)
               {
                  if(isOpen())
                  {
                     this.close();
                     if(_loc7_ = getChildByName("mcSelectionHighlight") as MovieClip)
                     {
                        _loc7_.visible = true;
                     }
                  }
               }
               param1.handled = true;
               break;
            case NavigationCode.GAMEPAD_A:
               if(selected && selectedIndex == -1 && _loc2_.value == InputValue.KEY_DOWN)
               {
                  if(isOpen())
                  {
                     if(_dropdownRef as SlotsListBase)
                     {
                        _dropdownRef.tryExecuteAction(param1);
                     }
                     else
                     {
                        _dropdownRef.handleInput(param1);
                     }
                     if(param1.handled)
                     {
                        return;
                     }
                     this.close();
                  }
                  else
                  {
                     this.open();
                  }
                  param1.handled = true;
               }
               break;
            case NavigationCode.UP:
               if(_loc3_)
               {
                  if(isOpen() && selected)
                  {
                     if(_loc5_)
                     {
                        if(_loc5_.selectedIndex <= -1)
                        {
                           param1.handled = false;
                           return;
                        }
                        if(_loc5_.selectedIndex < _loc5_.numColumns)
                        {
                           _loc5_.selectedIndex = -1;
                           selectedIndex = -1;
                           param1.handled = true;
                           dispatchEvent(new ListEvent(ListEvent.INDEX_CHANGE,true,false,_loc5_.selectedIndex,-1,-1,null,_loc5_));
                           return;
                        }
                     }
                     else if(_loc6_)
                     {
                        if(this.GetDropdownListRef().selectedIndex == 0)
                        {
                           this.GetDropdownListRef().selectedIndex = -1;
                           this.GetDropdownListRef().validateNow();
                           selectedIndex = -1;
                           param1.handled = true;
                           dispatchEvent(new ListEvent(ListEvent.INDEX_CHANGE,true,false,selectedIndex,-1,-1,this,this.data));
                           return;
                        }
                        if(this.GetDropdownListRef().selectedIndex == -1)
                        {
                           param1.handled = false;
                           return;
                        }
                     }
                  }
               }
               break;
            case NavigationCode.DOWN:
               if(_loc3_)
               {
                  if(isOpen() && selected)
                  {
                     if(Boolean(_loc5_) && _loc5_.selectedIndex < 0)
                     {
                        if(_loc5_.getRenderersCount() > this.lastSelectedColumn)
                        {
                           _loc5_.selectedIndex = this.lastSelectedColumn;
                        }
                        else
                        {
                           _loc5_.selectedIndex = _loc5_.getRenderersCount() > 0 ? _loc5_.getRenderersCount() - 1 : 0;
                        }
                        _loc8_ = _loc5_.getRendererAt(_loc5_.selectedIndex);
                        dispatchEvent(new ListEvent(ListEvent.INDEX_CHANGE,true,false,_loc5_.selectedIndex,-1,-1,_loc8_,_loc5_));
                        param1.handled = true;
                        return;
                     }
                  }
               }
               break;
            default:
               if(isOpen())
               {
                  if(_dropdownRef as SlotsListBase)
                  {
                     _dropdownRef.tryExecuteAction(param1);
                  }
               }
         }
         if(isOpen())
         {
            if(_dropdownRef is SlotsListBase)
            {
               _dropdownRef.handleInputNavSimple(param1);
               selectedIndex = (_dropdownRef as SlotsListBase).selectedIndex;
            }
            else if(_loc3_)
            {
               _dropdownRef.handleInput(param1);
            }
         }
      }
   }
}
