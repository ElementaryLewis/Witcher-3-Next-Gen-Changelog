package red.game.witcher3.menus.common
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   import red.core.CoreMenuModule;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.W3DropDownList;
   import red.game.witcher3.controls.W3DropdownMenuListItem;
   import red.game.witcher3.events.CategoryChangeEvent;
   import red.game.witcher3.managers.InputFeedbackManager;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.constants.WrappingMode;
   import scaleform.clik.controls.ScrollBar;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   
   public class DropdownListModuleBase extends CoreMenuModule
   {
       
      
      public var mcScrollBar:ScrollBar;
      
      public var mcDropDownList:W3DropDownList;
      
      public var tfCurrentState:TextField;
      
      public var mcDropDownMask:MovieClip;
      
      protected var _dataBindingKey:String = "journal.quest.list";
      
      protected var _moduleDisplayName:String = "";
      
      protected var _itemInputFeedbackLabel:String;
      
      protected var _toggleInputFeedback:int = -1;
      
      protected var _itemInputFeedback:int = -1;
      
      protected var _selectModuleOnClick:Boolean = false;
      
      public var itemRenderer:String;
      
      public var _dropDownListClass:String = "DropDownList";
      
      public var _dropDownItemRendererClass:String = "DropDownListItem";
      
      public var _itemListClass:String = "W3ScrollingListNoBG";
      
      public var _itemRendererClass:String = "W3BaseListItem";
      
      public var menuName:String;
      
      public var currentDataArrayRef:Array;
      
      public var inputEnabled:Boolean = true;
      
      public var filterFunc:Function;
      
      public var sortFunc:Function;
      
      private var _initCategoryChange:Boolean = true;
      
      public function DropdownListModuleBase()
      {
         super();
         dataBindingKey = this._dataBindingKey;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         dispatchEvent(new GameEvent(GameEvent.REGISTER,this._dataBindingKey + ".category",[this.updateCategoryData]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,this._dataBindingKey + ".name",[this.handleModuleNameSet]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,this._dataBindingKey,[this.handleListData]));
         stage.addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
         if(!this.mcDropDownList)
         {
            this.CreateDropDownList();
         }
         if(this.mcDropDownList)
         {
            this.mcDropDownList.activeSelectionEnabled = focused != 0;
            if(!this.mcDropDownList.mcMask)
            {
               this.mcDropDownList.setMask(this.mcDropDownMask);
            }
            this.mcDropDownList.focusable = false;
            this.mcDropDownList.menuName = this.menuName;
            _inputHandlers.push(this.mcDropDownList);
         }
      }
      
      public function set DropDownListClass(param1:String) : *
      {
         this._dropDownListClass = param1;
         if(!this.mcDropDownList)
         {
            this.CreateDropDownList();
         }
         else
         {
            this.mcDropDownList.addEventListener(ListEvent.INDEX_CHANGE,this.handleDropdownIndexChange,false,0,true);
            this.mcDropDownList.addEventListener(CategoryChangeEvent.CATEGORY_CHANGED,this.handleDropdownCategoryChanged,false,0,true);
         }
      }
      
      public function get itemInputFeedbackLabel() : String
      {
         return this._itemInputFeedbackLabel;
      }
      
      public function set itemInputFeedbackLabel(param1:String) : void
      {
         this._itemInputFeedbackLabel = param1;
      }
      
      public function get selectModuleOnClick() : Boolean
      {
         return this._selectModuleOnClick;
      }
      
      public function set selectModuleOnClick(param1:Boolean) : void
      {
         this._selectModuleOnClick = param1;
      }
      
      protected function CreateDropDownList() : *
      {
         var _loc1_:Class = getDefinitionByName(this._dropDownListClass) as Class;
         if(_loc1_ != null)
         {
            this.mcDropDownList = new _loc1_() as W3DropDownList;
         }
         this.mcDropDownList.x = 62;
         this.mcDropDownList.y = 20;
         this.mcDropDownList.itemRenderer = getDefinitionByName(this._dropDownItemRendererClass) as Class;
         this.mcDropDownList.enabled = true;
         this.mcDropDownList.wrapping = WrappingMode.WRAP;
         this.mcDropDownList.setMask(this.mcDropDownMask);
         this.mcDropDownList.scrollBar = this.mcScrollBar;
         this.mcDropDownList.menuName = this.menuName;
         this.mcDropDownList.dropdownMenuScrollingList = this._itemListClass;
         this.mcDropDownList.dropdownMenuItemRenderer = this._itemRendererClass;
         this.mcDropDownList.addEventListener(MouseEvent.CLICK,this.handleItemClick,false,0,true);
         this.mcDropDownList.addEventListener(ListEvent.INDEX_CHANGE,this.handleDropdownIndexChange,false,0,true);
         this.mcDropDownList.addEventListener(CategoryChangeEvent.CATEGORY_CHANGED,this.handleDropdownCategoryChanged,false,0,true);
         addChild(this.mcDropDownList);
      }
      
      public function set DropDownItemRendererClass(param1:String) : *
      {
         this._dropDownItemRendererClass = param1;
      }
      
      public function set ItemListClass(param1:String) : *
      {
         this._itemListClass = param1;
         this.mcDropDownList.dropdownMenuScrollingList = this._itemListClass;
      }
      
      public function set ItemRendererClass(param1:String) : *
      {
         this._itemRendererClass = param1;
         this.mcDropDownList.dropdownMenuItemRenderer = this._itemRendererClass;
      }
      
      public function set DataBindingKey(param1:String) : *
      {
         this._dataBindingKey = param1;
      }
      
      public function updateCategoryData(param1:Object) : void
      {
         this.validateItemItemFeedback();
         this.mcDropDownList.updateCategoryData(param1);
         this.mcDropDownList.validateNow();
      }
      
      public function handleListData(param1:Object, param2:int) : void
      {
         this.validateItemItemFeedback();
         if(param2 > -1)
         {
            this.mcDropDownList.updateItemData(param1);
            dispatchEvent(new Event(Event.CHANGE));
            return;
         }
         var _loc3_:* = param1 as Array;
         if(this.filterFunc != null)
         {
            _loc3_ = this.filterFunc(_loc3_);
         }
         if(_loc3_ && _loc3_.length > 0)
         {
            if(this.sortFunc != null)
            {
               this.sortFunc(_loc3_);
            }
            else
            {
               this.sortData(_loc3_);
            }
            this.mcDropDownList.updateData(_loc3_);
            this.mcDropDownList.focused = focused;
         }
         else
         {
            this.mcDropDownList.clearDataProvider();
         }
         this.currentDataArrayRef = _loc3_;
         this.mcDropDownList.activeSelectionEnabled = focused != 0;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      protected function sortData(param1:Array) : void
      {
         param1.sortOn("dropDownLabel");
      }
      
      protected function filterList(param1:*, param2:*) : int
      {
         var _loc3_:RegExp = /\b\S+$/;
         var _loc4_:* = param1.dropDownLabel.match(_loc3_);
         var _loc5_:* = param2.dropDownLabel.match(_loc3_);
         if(param1.dropDownLabel != param2.dropDownLabel)
         {
            if(_loc4_ < _loc5_)
            {
               return -1;
            }
            if(_loc4_ > _loc5_)
            {
               return 1;
            }
            return 0;
         }
         return 0;
      }
      
      protected function handleModuleNameSet(param1:String) : void
      {
         if(this.tfCurrentState)
         {
            this._moduleDisplayName = param1;
            this.tfCurrentState.htmlText = param1;
         }
      }
      
      protected function handleDropdownCategoryChanged(param1:CategoryChangeEvent) : void
      {
         if(!this._initCategoryChange)
         {
            this.validateItemItemFeedback();
         }
         else
         {
            this._initCategoryChange = false;
         }
      }
      
      protected function handleDropdownIndexChange(param1:ListEvent) : void
      {
         this.validateItemItemFeedback();
      }
      
      protected function canShowSubItemInputFeedback(param1:W3DropdownMenuListItem) : Boolean
      {
         return true;
      }
      
      protected function handleItemClick(param1:Event) : void
      {
         if(this.selectModuleOnClick && focused < 1)
         {
            dispatchEvent(new Event(EVENT_MOUSE_FOCUSE));
         }
      }
      
      protected function validateItemItemFeedback() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.handleValidateItemItemFeedback,false);
         addEventListener(Event.ENTER_FRAME,this.handleValidateItemItemFeedback,false,0,true);
      }
      
      protected function handleValidateItemItemFeedback(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.handleValidateItemItemFeedback,false);
         this.updateItemInputFeedback();
      }
      
      public function updateItemInputFeedback() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc3_:W3DropdownMenuListItem = this.mcDropDownList.getRendererAt(this.mcDropDownList.selectedIndex) as W3DropdownMenuListItem;
         if(_loc3_ && _loc3_.isOpen() && _loc3_.IsSubListItemSelected())
         {
            _loc1_ = _focused && visible && enabled && this.canShowSubItemInputFeedback(_loc3_) && Boolean(this._itemInputFeedbackLabel);
         }
         _loc2_ = _focused && !_loc1_ && Boolean(_loc3_) && (!_loc3_.isOpen() || !_loc3_.IsSubListItemSelected());
         if(_loc1_ && this._itemInputFeedback < 0)
         {
            this._itemInputFeedback = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_A,KeyCode.SPACE,this._itemInputFeedbackLabel);
            InputFeedbackManager.updateButtons(this);
         }
         else if(!_loc1_ && this._itemInputFeedback >= 0)
         {
            InputFeedbackManager.removeButton(this,this._itemInputFeedback);
            InputFeedbackManager.updateButtons(this);
            this._itemInputFeedback = -1;
         }
         if(_loc2_ && this._toggleInputFeedback < 0)
         {
            this._toggleInputFeedback = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_A,KeyCode.SPACE,"panel_common_toggle_filters");
            InputFeedbackManager.updateButtons(this);
         }
         else if(!_loc2_ && this._toggleInputFeedback >= 0)
         {
            InputFeedbackManager.removeButton(this,this._toggleInputFeedback);
            InputFeedbackManager.updateButtons(this);
            this._toggleInputFeedback = -1;
         }
      }
      
      override public function set focused(param1:Number) : void
      {
         var _loc2_:W3DropdownMenuListItem = null;
         if(param1 == _focused || !_focusable)
         {
            return;
         }
         super.focused = param1;
         this.mcDropDownList.activeSelectionEnabled = focused != 0;
         if(_focused)
         {
            this.SetAsActiveContainer(true);
         }
         else
         {
            this.SetAsActiveContainer(false);
         }
         if(this.mcDropDownList)
         {
            this.validateItemItemFeedback();
         }
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         if(!this.mcDropDownList)
         {
            return;
         }
         this.validateItemItemFeedback();
      }
      
      public function SetAsActiveContainer(param1:Boolean) : *
      {
         if(this.tfCurrentState)
         {
            this.tfCurrentState.htmlText = this._moduleDisplayName;
         }
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc2_:UIComponent = null;
         if(param1.handled || !focused || !enabled || !visible || !this.inputEnabled)
         {
            return;
         }
         for each(_loc2_ in _inputHandlers)
         {
            _loc2_.handleInput(param1);
            if(param1.handled)
            {
               param1.stopImmediatePropagation();
               return;
            }
         }
      }
   }
}
