package red.game.witcher3.menus.alchemy
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.external.ExternalInterface;
   import flash.text.TextField;
   import red.core.CoreMenu;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.events.GridEvent;
   import red.game.witcher3.managers.ContextInfoManager;
   import red.game.witcher3.managers.InputFeedbackManager;
   import red.game.witcher3.managers.PanelModuleManager;
   import red.game.witcher3.menus.common.CheckboxListMode;
   import red.game.witcher3.menus.common.DropdownListModuleBase;
   import red.game.witcher3.menus.common.ItemDataStub;
   import red.game.witcher3.menus.common.RecipeIconItemRenderer;
   import red.game.witcher3.menus.crafting.ItemCraftingModule;
   import red.game.witcher3.modules.ItemTooltipModule;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class AlchemyMenu extends CoreMenu
   {
       
      
      public var mcPanelModuleManager:PanelModuleManager;
      
      public var mcMainListModule:DropdownListModuleBase;
      
      public var mcCraftingModule:ItemCraftingModule;
      
      public var mcCraftingGlossaryModule:ItemCraftingModule;
      
      public var mcCraftedItemTooltipModule:ItemTooltipModule;
      
      public var mcFiltersMode:CheckboxListMode;
      
      public var txtActiveFiltersTitle:TextField;
      
      public var txtActiveFiltersList:TextField;
      
      protected var activeFiltersMaxWidth:Number = -1;
      
      protected var hasIngreLocString:String;
      
      protected var missingCompLocString:String;
      
      protected var alreadyCraftedLocString:String;
      
      public var mcAnchor_MODULE_Tooltip:MovieClip;
      
      public var mcAnchor_SelectedRecipe_Tooltip:MovieClip;
      
      private var _inputSymbolIDA:int = -1;
      
      private var _inputSymbolIDX:int = -1;
      
      protected var craftingEnabled:Boolean = false;
      
      protected var lastSelectedItem:RecipeIconItemRenderer;
      
      protected var pinnedTag:uint = 0;
      
      private var m_bUsingGamepad:Boolean = true;
      
      protected var setFilters:Boolean = false;
      
      protected var _lastFilteredList:Array;
      
      public function AlchemyMenu()
      {
         super();
         this.mcMainListModule.menuName = this.menuName;
         this.mcMainListModule.selectModuleOnClick = true;
         ContextInfoManager.TOOLTIPS_DELAY = 0;
         ContextInfoManager.TOOLTIPS_DELAY_MOUSE = 0;
         this.__setProp_mcCraftedItemTooltipModule_Scene1_mcCraftedItemTooltipModule_0();
         this.__setProp_mcMainListModule_Scene1_mcMainListModule_0();
      }
      
      override protected function get menuName() : String
      {
         return "AlchemyMenu";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         addEventListener(GridEvent.ITEM_CHANGE,this.onGridItemChange,false,0,true);
         _contextMgr.defaultAnchor = this.mcAnchor_MODULE_Tooltip;
         _contextMgr.addGridEventsTooltipHolder(stage);
         _contextMgr.enableInputFeedbackShowing(true);
         if(this.mcCraftingGlossaryModule)
         {
            this.mcCraftingGlossaryModule.hideEmptyDataHolders = true;
         }
         if(this.mcFiltersMode)
         {
            this.mcFiltersMode.closeCB = this.filterModeClosed;
            this.mcFiltersMode.disallowCloseOnNoCheck = true;
         }
         this.mcMainListModule.mcDropDownList.addEventListener(ListEvent.INDEX_CHANGE,this.handleSelectChange,false,0,true);
         this.mcMainListModule.mcDropDownList.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,this.handleItemDoubleClick,false,0,true);
         this.mcMainListModule.filterFunc = this.filterList;
         InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_RSTICK_HOLD,KeyCode.F,"panel_common_filters");
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"crafting.sublist.items",[this.updateIngredientsList]));
         stage.invalidate();
         validateNow();
         upToCloseEnabled = false;
         focused = 1;
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
      }
      
      public function updatePinInputFeedback() : void
      {
         if(this._inputSymbolIDX != -1)
         {
            InputFeedbackManager.removeButton(this,this._inputSymbolIDX);
            this._inputSymbolIDX = -1;
         }
         if(this.mcMainListModule.mcDropDownList.dataProvider.length > 0)
         {
            this.lastSelectedItem = null;
         }
         if(this.lastSelectedItem != null)
         {
            if(Boolean(this.lastSelectedItem.data) && this.lastSelectedItem.data.tag == this.pinnedTag)
            {
               this._inputSymbolIDX = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_X,KeyCode.Q,"inputfeedback_unpin_recipe");
            }
            else
            {
               this._inputSymbolIDX = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_X,KeyCode.Q,"inputfeedback_pin_recipe");
            }
         }
         InputFeedbackManager.updateButtons(this);
      }
      
      public function setPinnedRecipe(param1:uint) : void
      {
         this.pinnedTag = param1;
         RecipeIconItemRenderer.setCurrentPinnedTag(stage,param1);
      }
      
      public function hideContent(param1:Boolean) : void
      {
         if(this.craftingEnabled)
         {
            this.mcCraftingModule.active = param1;
         }
         else
         {
            this.mcCraftingGlossaryModule.active = param1;
         }
         this.mcCraftedItemTooltipModule.active = param1;
      }
      
      override public function ShowSecondaryModules(param1:Boolean) : *
      {
         super.ShowSecondaryModules(param1);
         if(param1)
         {
            if(this.craftingEnabled)
            {
               if(this.mcCraftingModule)
               {
                  this.mcCraftingModule.active = true;
               }
            }
            else if(this.mcCraftingGlossaryModule)
            {
               this.mcCraftingGlossaryModule.active = true;
            }
         }
         else
         {
            if(this.mcCraftingModule)
            {
               this.mcCraftingModule.active = false;
            }
            if(this.mcCraftingGlossaryModule)
            {
               this.mcCraftingGlossaryModule.active = false;
            }
         }
      }
      
      public function SetFiltersValue(param1:String, param2:Boolean, param3:String, param4:Boolean, param5:String, param6:Boolean) : void
      {
         var _loc7_:Array = null;
         if(this.mcFiltersMode)
         {
            this.setFilters = true;
            _loc7_ = [{
               "key":"HasIngredients",
               "label":param1,
               "isChecked":param2
            },{
               "key":"MissingIngredients",
               "label":param3,
               "isChecked":param4
            },{
               "key":"AlreadyCrafted",
               "label":param5,
               "isChecked":param6
            }];
            this.hasIngreLocString = param1;
            this.missingCompLocString = param3;
            this.alreadyCraftedLocString = param5;
            this.mcFiltersMode.setData(_loc7_);
            this.mcFiltersMode.validateNow();
            if(this._lastFilteredList != null)
            {
               selectTargetModule(this.mcMainListModule);
               this.mcMainListModule.handleListData(this._lastFilteredList,-1);
               this.mcMainListModule.validateNow();
               removeEventListener(Event.ENTER_FRAME,this.validateScrollPosition,false);
               addEventListener(Event.ENTER_FRAME,this.validateScrollPosition,false,0,true);
            }
            this.updateFiltersText();
            this.updatePinInputFeedback();
         }
      }
      
      protected function filterList(param1:Array) : Array
      {
         var _loc2_:Array = null;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         if(this.mcFiltersMode)
         {
            this._lastFilteredList = param1;
            if(!this.setFilters)
            {
               return null;
            }
            _loc2_ = new Array();
            _loc3_ = this.mcFiltersMode.isBoxChecked("HasIngredients");
            _loc4_ = this.mcFiltersMode.isBoxChecked("MissingIngredients");
            _loc5_ = this.mcFiltersMode.isBoxChecked("AlreadyCrafted");
            _loc6_ = 0;
            while(_loc6_ < param1.length)
            {
               if((_loc7_ = param1[_loc6_]).canCookStatusForFilter == RecipeIconItemRenderer.ECE_MissingIngredient || _loc7_.canCookStatusForFilter == RecipeIconItemRenderer.ECE_TooFewIngredients)
               {
                  if(_loc4_)
                  {
                     _loc2_.push(_loc7_);
                  }
               }
               else if(_loc7_.canCookStatusForFilter == RecipeIconItemRenderer.CannotCookMore)
               {
                  if(_loc5_)
                  {
                     _loc2_.push(_loc7_);
                  }
               }
               else if(_loc3_)
               {
                  _loc2_.push(_loc7_);
               }
               _loc6_++;
            }
            if(_loc2_.length == 0)
            {
               this.ShowSecondaryModules(false);
            }
            else
            {
               this.ShowSecondaryModules(true);
            }
            if(_loc2_.length == 0 && this._inputSymbolIDX != -1)
            {
               InputFeedbackManager.removeButton(this,this._inputSymbolIDX);
               this._inputSymbolIDX = -1;
               InputFeedbackManager.updateButtons(this);
            }
            return _loc2_;
         }
         return null;
      }
      
      protected function Update() : void
      {
      }
      
      public function setCraftingEnabled(param1:Boolean) : void
      {
         this.craftingEnabled = param1;
         if(!this.craftingEnabled)
         {
            this.setCraftingEnabledFeedback(false);
            if(this.mcCraftingModule)
            {
               this.mcCraftingModule.active = false;
            }
            if(this.mcCraftingGlossaryModule)
            {
               this.mcCraftingGlossaryModule.active = true;
            }
         }
         else
         {
            if(this.mcCraftingModule)
            {
               this.mcCraftingModule.active = true;
            }
            if(this.mcCraftingGlossaryModule)
            {
               this.mcCraftingGlossaryModule.active = false;
            }
            if(Boolean(this.lastSelectedItem) && this.lastSelectedItem.data.canCookStatus == RecipeIconItemRenderer.NoException)
            {
               this.setCraftingEnabledFeedback(true);
            }
            else
            {
               this.setCraftingEnabledFeedback(false);
            }
         }
      }
      
      protected function updateIngredientsList(param1:Array) : void
      {
         if(Boolean(this.mcCraftingModule) && this.mcCraftingModule.enabled)
         {
            this.mcCraftingModule.setIngredientItemData(param1);
         }
         if(Boolean(this.mcCraftingGlossaryModule) && this.mcCraftingGlossaryModule.enabled)
         {
            this.mcCraftingGlossaryModule.setIngredientItemData(param1);
         }
      }
      
      public function setCraftedItem(param1:uint, param2:String, param3:String, param4:Boolean, param5:int, param6:String) : void
      {
         if(Boolean(this.mcCraftingModule) && this.mcCraftingModule.enabled)
         {
            this.mcCraftingModule.setCraftedItemInfo(param1,param2,param3,param4,param5,param6);
         }
         if(Boolean(this.mcCraftingGlossaryModule) && this.mcCraftingGlossaryModule.enabled)
         {
            this.mcCraftingGlossaryModule.setCraftedItemInfo(param1,param2,param3,param4,param5,param6);
         }
      }
      
      public function handleSelectChange(param1:ListEvent) : void
      {
         if(this._inputSymbolIDX != -1)
         {
            InputFeedbackManager.removeButton(this,this._inputSymbolIDX);
            this._inputSymbolIDX = -1;
         }
         if(param1.itemRenderer is RecipeIconItemRenderer)
         {
            this.lastSelectedItem = param1.itemRenderer as RecipeIconItemRenderer;
            this.mcCraftingModule.setItemColorQuality(this.lastSelectedItem.data.rarity);
            this.mcCraftedItemTooltipModule.setItemColorQuality(this.lastSelectedItem.data.rarity);
            if(Boolean(this.lastSelectedItem.data) && this.lastSelectedItem.data.tag == this.pinnedTag)
            {
               this._inputSymbolIDX = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_X,KeyCode.Q,"inputfeedback_unpin_recipe");
            }
            else
            {
               this._inputSymbolIDX = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_X,KeyCode.Q,"inputfeedback_pin_recipe");
            }
            if(this.craftingEnabled && Boolean(param1.itemData))
            {
               if(param1.itemData.canCookStatus == RecipeIconItemRenderer.NoException)
               {
                  this.setCraftingEnabledFeedback(true);
               }
               else
               {
                  this.setCraftingEnabledFeedback(false);
               }
            }
         }
         else
         {
            this.lastSelectedItem = null;
         }
         InputFeedbackManager.updateButtons(this);
      }
      
      private function handleItemDoubleClick(param1:ListEvent) : void
      {
         if(param1.itemRenderer is RecipeIconItemRenderer)
         {
            this.mcCraftingModule.startCrafting();
         }
      }
      
      public function setCraftingEnabledFeedback(param1:Boolean) : void
      {
         if(param1)
         {
            if(this._inputSymbolIDA == -1)
            {
               this._inputSymbolIDA = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_A,-1,"panel_alchemy_craft_item");
            }
         }
         else if(this._inputSymbolIDA != -1)
         {
            InputFeedbackManager.removeButton(this,this._inputSymbolIDA);
            this._inputSymbolIDA = -1;
         }
         InputFeedbackManager.updateButtons(this);
      }
      
      override protected function handleInputNavigate(param1:InputEvent) : void
      {
         if(this.mcFiltersMode.visible)
         {
            return;
         }
         super.handleInputNavigate(param1);
         var _loc2_:InputDetails = param1.details;
         var _loc3_:Boolean = _loc2_.value == InputValue.KEY_UP && !param1.handled;
         if(_loc3_)
         {
            if(!this.mcFiltersMode.visible && (_loc2_.code == KeyCode.F || _loc2_.navEquivalent == NavigationCode.GAMEPAD_R3))
            {
               this.showFilterMode();
            }
            if(_loc2_.code == KeyCode.Q || _loc2_.navEquivalent == NavigationCode.GAMEPAD_X)
            {
               this.togglePinOnSelectedRecipe();
            }
         }
      }
      
      private function togglePinOnSelectedRecipe() : void
      {
         var _loc1_:uint = 0;
         if(this.lastSelectedItem != null && Boolean(this.lastSelectedItem.data))
         {
            if(this._inputSymbolIDX != -1)
            {
               InputFeedbackManager.removeButton(this,this._inputSymbolIDX);
               this._inputSymbolIDX = -1;
            }
            if(this.pinnedTag == this.lastSelectedItem.data.tag)
            {
               _loc1_ = 0;
               this._inputSymbolIDX = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_X,KeyCode.Q,"inputfeedback_pin_recipe");
            }
            else
            {
               _loc1_ = uint(this.lastSelectedItem.data.tag);
               this._inputSymbolIDX = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_X,KeyCode.Q,"inputfeedback_unpin_recipe");
            }
            InputFeedbackManager.updateButtons(this);
            this.pinnedTag = _loc1_;
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnChangePinnedRecipe",[_loc1_]));
            RecipeIconItemRenderer.setCurrentPinnedTag(stage,_loc1_);
         }
      }
      
      private function showFilterMode() : void
      {
         this.mcFiltersMode.show();
         this.mcMainListModule.inputEnabled = false;
      }
      
      private function filterModeClosed(param1:Boolean) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         this.mcMainListModule.inputEnabled = true;
         if(param1)
         {
            if(this._lastFilteredList != null)
            {
               this.lastSelectedItem = null;
               selectTargetModule(this.mcMainListModule);
               this.mcMainListModule.handleListData(this._lastFilteredList,-1);
               this.mcMainListModule.validateNow();
               removeEventListener(Event.ENTER_FRAME,this.validateScrollPosition,false);
               addEventListener(Event.ENTER_FRAME,this.validateScrollPosition,false,0,true);
            }
            this.updatePinInputFeedback();
            _loc2_ = this.mcFiltersMode.isBoxChecked("HasIngredients");
            _loc3_ = this.mcFiltersMode.isBoxChecked("MissingIngredients");
            _loc4_ = this.mcFiltersMode.isBoxChecked("AlreadyCrafted");
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnCraftingFiltersChanged",[_loc2_,_loc3_,_loc4_]));
            this.updateFiltersText();
         }
      }
      
      private function validateScrollPosition(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.validateScrollPosition,false);
         this.mcMainListModule.mcDropDownList.SetInitialSelection();
         this.mcMainListModule.mcDropDownList.scrollPosition = 0;
         this.mcMainListModule.mcDropDownList.validateNow();
      }
      
      private function updateFiltersText() : void
      {
         var _loc4_:* = null;
         if(this.activeFiltersMaxWidth == -1)
         {
            this.activeFiltersMaxWidth = this.txtActiveFiltersList.width;
            this.txtActiveFiltersTitle.text = "[[gui_active_filters_title]]";
            this.txtActiveFiltersList.x = this.txtActiveFiltersList.x + this.txtActiveFiltersTitle.textWidth + 10;
            this.txtActiveFiltersList.width = this.activeFiltersMaxWidth - this.txtActiveFiltersTitle.textWidth - 10;
         }
         var _loc1_:Boolean = this.mcFiltersMode.isBoxChecked("HasIngredients");
         var _loc2_:Boolean = this.mcFiltersMode.isBoxChecked("MissingIngredients");
         var _loc3_:Boolean = this.mcFiltersMode.isBoxChecked("AlreadyCrafted");
         _loc4_ = "";
         if(_loc1_)
         {
            _loc4_ = this.hasIngreLocString;
         }
         if(_loc2_)
         {
            if(_loc4_ != "")
            {
               _loc4_ += ", ";
            }
            _loc4_ += this.missingCompLocString;
         }
         if(_loc3_)
         {
            if(_loc4_ != "")
            {
               _loc4_ += ", ";
            }
            _loc4_ += this.alreadyCraftedLocString;
         }
         this.txtActiveFiltersList.text = _loc4_;
         this.txtActiveFiltersList.height = this.txtActiveFiltersList.textHeight + CommonConstants.SAFE_TEXT_PADDING;
         this.txtActiveFiltersList.y = this.txtActiveFiltersTitle.y + this.txtActiveFiltersTitle.height - this.txtActiveFiltersList.height;
         if(_loc4_ == "")
         {
            this.txtActiveFiltersTitle.text = "";
         }
         else
         {
            this.txtActiveFiltersTitle.text = "[[gui_active_filters_title]]";
         }
      }
      
      override protected function onLastMoveStatusChanged() : *
      {
         if(this.mcFiltersMode)
         {
            this.mcFiltersMode.lastMoveWasMouse = _lastMoveWasMouse;
         }
      }
      
      protected function onGridItemChange(param1:GridEvent) : void
      {
         var _loc3_:GridEvent = null;
         var _loc2_:ItemDataStub = param1.itemData as ItemDataStub;
         if(_loc2_)
         {
            if(_loc2_.id)
            {
               _loc3_ = new GridEvent(GridEvent.DISPLAY_TOOLTIP,true,false,0,-1,-1,null,_loc2_);
            }
            else
            {
               _loc3_ = new GridEvent(GridEvent.HIDE_TOOLTIP,true,false,0,-1,-1,null,_loc2_);
            }
         }
         else
         {
            _loc3_ = new GridEvent(GridEvent.HIDE_TOOLTIP,true,false,0,-1,-1,null,_loc2_);
         }
         dispatchEvent(_loc3_);
      }
      
      public function IsUsingGamepad() : Boolean
      {
         this.m_bUsingGamepad = ExternalInterface.call("isUsingPad");
         return this.m_bUsingGamepad;
      }
      
      internal function __setProp_mcCraftedItemTooltipModule_Scene1_mcCraftedItemTooltipModule_0() : *
      {
         try
         {
            this.mcCraftedItemTooltipModule["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcCraftedItemTooltipModule.enabled = true;
         this.mcCraftedItemTooltipModule.enableInitCallback = false;
         this.mcCraftedItemTooltipModule.tooltipInfoDataProvider = "alchemy.menu.crafted.item.tooltip";
         this.mcCraftedItemTooltipModule.visible = true;
         try
         {
            this.mcCraftedItemTooltipModule["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcMainListModule_Scene1_mcMainListModule_0() : *
      {
         try
         {
            this.mcMainListModule["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcMainListModule.DataBindingKey = "alchemy.list";
         this.mcMainListModule.DropDownItemRendererClass = "IconDropDownListItem";
         this.mcMainListModule.DropDownListClass = "DropDownList";
         this.mcMainListModule.enabled = true;
         this.mcMainListModule.enableInitCallback = false;
         this.mcMainListModule.ItemListClass = "W3ScrollingListNoBG";
         this.mcMainListModule.ItemRendererClass = "RecipeIconListItem";
         this.mcMainListModule.visible = true;
         try
         {
            this.mcMainListModule["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
