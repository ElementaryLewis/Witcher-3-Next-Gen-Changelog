package red.game.witcher3.menus.blacksmith
{
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Sine;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.text.TextField;
   import red.core.CoreMenu;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.managers.InputFeedbackManager;
   import red.game.witcher3.menus.common.DropdownEnchantmentsFilterMode;
   import red.game.witcher3.menus.common.EnchantmentListItemRenderer;
   import red.game.witcher3.menus.common.InventoryListItemRenderer;
   import red.game.witcher3.menus.common.ItemDataStub;
   import red.game.witcher3.tooltips.TooltipInventory;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.events.ButtonEvent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.clik.managers.InputDelegate;
   import scaleform.clik.ui.InputDetails;
   
   public class EnchantingMenu extends CoreMenu
   {
       
      
      public var mcItemsList:EnchantingItemsListModule;
      
      public var mcEnchantmentsList:EnchantingItemsListModule;
      
      public var mcIngredientsList:RequiredIngredientsListModule;
      
      public var mcTooltipAnchor:MovieClip;
      
      public var mcFiltersMode:DropdownEnchantmentsFilterMode;
      
      public var moduleMerchantInfo:ModuleMerchantInfo;
      
      public var mcActionEnchant:PaidAction;
      
      public var mcActionRemoveEnchantment:PaidAction;
      
      public var txtActiveFiltersTitle:TextField;
      
      public var txtActiveFiltersList:TextField;
      
      public var mcFilterAnchor:MovieClip;
      
      private var _enchantmentEnabled:Boolean = false;
      
      private var _removeEnchantmentEnabled:Boolean = false;
      
      private var _isInProgress:Boolean;
      
      private var _selectedItemRenderer:InventoryListItemRenderer;
      
      private var _selectedEnchantmentRenderer:EnchantmentListItemRenderer;
      
      private var _selectedItemData:Object;
      
      private var _selectedEnchantmentData:Object;
      
      private var _filterLocStr_hasIngredients:String;
      
      private var _filterLocStr_missingIngredients:String;
      
      private var _filterLocStr_level1:String;
      
      private var _filterLocStr_level2:String;
      
      private var _filterLocStr_level3:String;
      
      private var _filter_hasIngredients:Boolean = true;
      
      private var _filter_missingIngredients:Boolean = true;
      
      private var _filter_level1:Boolean = true;
      
      private var _filter_level2:Boolean = true;
      
      private var _filter_level3:Boolean = true;
      
      private var _lastFilteredList:Array;
      
      private var _addSocketMode:Boolean = false;
      
      private var _notEnoughMoneyToApply:Boolean = false;
      
      private var _notEnoughMoneyToRemove:Boolean = false;
      
      private var _cachedEnchantmentIdx:int = -1;
      
      private var _pinnedTag:uint = 0;
      
      private var _inputSymbolIDA:int = -1;
      
      private var _inputSymbolIDX:int = -1;
      
      internal const listDefaultPos = 740;
      
      internal const listAnimPos = 745;
      
      internal const ingredientsDefaultPos = 1340;
      
      internal const ingredientsAnimPos = 1343;
      
      public function EnchantingMenu()
      {
         super();
         if(this.mcFiltersMode)
         {
            this.mcFiltersMode.closeCB = this.filterModeClosed;
            this.mcFiltersMode.disallowCloseOnNoCheck = true;
         }
         TooltipInventory.ingnoreSafeRect = true;
         this.mcEnchantmentsList.filterFunction = this.applyFilters;
         this.txtActiveFiltersTitle.text = "[[gui_active_filters_title]]";
         this.mcItemsList.addEventListener(ListEvent.INDEX_CHANGE,this.handleItemSelected,false,0,true);
         this.mcEnchantmentsList.addEventListener(FocusEvent.FOCUS_OUT,this.handleEnchantmentsUnfocus,false,0,true);
         this.mcIngredientsList.active = false;
         this.mcActionEnchant.visible = false;
         this.mcActionEnchant.btnAction.label = "[[input_enchant_item]]";
         this.mcActionEnchant.btnAction.setDataFromStage(NavigationCode.GAMEPAD_A,KeyCode.E);
         this.mcActionEnchant.btnAction.addEventListener(ButtonEvent.CLICK,this.handleEnchantClick,false,0,true);
         this.mcActionRemoveEnchantment.visible = false;
         this.mcActionRemoveEnchantment.btnAction.label = "[[input_remove_enchant]]";
         this.mcActionRemoveEnchantment.btnAction.setDataFromStage(NavigationCode.GAMEPAD_Y,KeyCode.DELETE);
         this.mcActionRemoveEnchantment.btnAction.addEventListener(ButtonEvent.CLICK,this.handleRemoveEnchantmentClick,false,0,true);
         InputDelegate.getInstance().addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
         this.__setProp_mcEnchantmentsList_Scene1_EnchantmentsList_0();
         this.__setProp_mcItemsList_Scene1_ItemsList_0();
      }
      
      public function setPinnedRecipe(param1:uint) : void
      {
         this._pinnedTag = param1;
         EnchantmentListItemRenderer.setCurrentPinnedTag(stage,param1);
      }
      
      public function selectFirstEnchantment() : void
      {
         this.mcIngredientsList.focused = 1;
         removeEventListener(Event.ENTER_FRAME,this.pendedSelectFirstEnchantment,false);
         addEventListener(Event.ENTER_FRAME,this.pendedSelectFirstEnchantment,false,0,true);
      }
      
      protected function pendedSelectFirstEnchantment(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.pendedSelectFirstEnchantment,false);
         this.currentModuleIdx = 1;
      }
      
      public function enableEnchantment(param1:Boolean, param2:Number, param3:Boolean) : void
      {
         this._notEnoughMoneyToApply = param3;
         this._enchantmentEnabled = param1;
         this.mcActionEnchant.visible = param1;
         this.mcActionEnchant.price = param2;
         this.mcActionEnchant.tfPriceValue.textColor = this._notEnoughMoneyToApply ? 16711680 : 11963977;
         this.updateActionsView();
      }
      
      public function enableRemovingEnchantment(param1:Boolean, param2:Number, param3:Boolean) : void
      {
         this._removeEnchantmentEnabled = param1;
         this._notEnoughMoneyToRemove = param3;
         this.mcActionRemoveEnchantment.visible = param1;
         this.mcActionRemoveEnchantment.price = param2;
         this.mcActionRemoveEnchantment.tfPriceValue.textColor = this._notEnoughMoneyToRemove ? 16711680 : 11963977;
         this.updateActionsView();
      }
      
      private function updateActionsView() : void
      {
         var _loc1_:Number = 910;
         var _loc2_:Number = 961;
         if(this.mcActionEnchant.visible || this.mcActionRemoveEnchantment.visible)
         {
            this.mcActionRemoveEnchantment.y = this.mcActionEnchant.visible ? _loc2_ : _loc1_;
         }
      }
      
      public function handleEnchantmentsUnfocus(param1:Event = null) : void
      {
         this.resetSelection();
      }
      
      override public function set currentModuleIdx(param1:int) : void
      {
         super.currentModuleIdx = param1;
         if(this.mcEnchantmentsList.focused < 1)
         {
            this.resetSelection();
         }
         else
         {
            this.handleEnchantmentSelected();
         }
         if(this.mcItemsList.focused > 0)
         {
            this.handleItemSelected();
         }
      }
      
      override protected function get menuName() : String
      {
         return "EnchantingMenu";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"populate.items",[this.populateItemsList]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"populate.enchantments",[this.populateEnchantmentsList]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"populate.ingredients",[this.populateIngredientsList]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"blacksmith.merchant.info",[this.setMerchantInfo]));
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         _contextMgr.addGridEventsTooltipHolder(stage,false);
         _contextMgr.defaultAnchor = this.mcTooltipAnchor;
         selectTargetModule(this.mcItemsList);
         InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_LSTICK_HOLD,KeyCode.F,"panel_common_filters");
         InputFeedbackManager.updateButtons(this);
      }
      
      private function resetSelection() : void
      {
         GTweener.removeTweens(this.mcIngredientsList);
         GTweener.to(this.mcIngredientsList,0.5,{
            "x":this.ingredientsDefaultPos,
            "alpha":0
         },{"ease":Sine.easeOut});
         this._selectedItemRenderer = this.mcItemsList.mcScrollingList.getSelectedRenderer() as InventoryListItemRenderer;
         if(Boolean(this._selectedItemRenderer) && this._isInProgress)
         {
            this._selectedItemRenderer.resetProgress();
            this._isInProgress = false;
         }
         this.enableEnchantment(false,0,false);
         this.mcIngredientsList.active = false;
         this.updatePinInputFeedback();
      }
      
      private function handleItemSelected(param1:ListEvent = null) : void
      {
         var _loc4_:Object = null;
         var _loc2_:InventoryListItemRenderer = this.mcItemsList.mcScrollingList.getSelectedRenderer() as InventoryListItemRenderer;
         var _loc3_:uint = 0;
         this._addSocketMode = false;
         if(_loc2_)
         {
            _loc4_ = _loc2_.data;
            this.resetSelection();
            if(Boolean(_loc4_) && Boolean(_loc4_.id))
            {
               this._selectedItemData = _loc4_;
               this._selectedItemRenderer = _loc2_;
               removeEventListener(Event.ENTER_FRAME,this.pendedItemSelection,false);
               addEventListener(Event.ENTER_FRAME,this.pendedItemSelection,false,0,true);
               _loc3_ = uint(this._selectedItemData.enchantmentId);
               if(this._selectedItemData.isNotEnoughSockets)
               {
                  this._addSocketMode = true;
               }
            }
         }
         if(this._addSocketMode)
         {
         }
         EnchantmentListItemRenderer.DISABLE_ACTION = this._addSocketMode;
         EnchantmentListItemRenderer.APPLIED_ENCHANTMENT = _loc3_;
      }
      
      private function pendedItemSelection(param1:Event = null) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.pendedItemSelection,false);
         if(this._selectedItemData)
         {
            if(this._selectedItemData.userData as String == "ShowAll")
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnShowAllEnchantments",[]));
            }
            else
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnSelectItem",[this._selectedItemData.id]));
            }
         }
      }
      
      private function handleEnchantmentSelected(param1:ListEvent = null) : void
      {
         var _loc3_:Object = null;
         var _loc2_:EnchantmentListItemRenderer = this.mcEnchantmentsList.mcScrollingList.getSelectedRenderer() as EnchantmentListItemRenderer;
         if(_loc2_)
         {
            _loc3_ = _loc2_.data;
            if(this.mcEnchantmentsList.focused < 1)
            {
               this.updatePinInputFeedback();
               return;
            }
            if(Boolean(this._selectedItemRenderer) && this._isInProgress)
            {
               this._selectedItemRenderer.resetProgress();
               this._isInProgress = false;
            }
            if(Boolean(_loc3_) && Boolean(_loc3_.name))
            {
               this._selectedEnchantmentData = _loc3_;
               this._selectedEnchantmentRenderer = _loc2_;
               removeEventListener(Event.ENTER_FRAME,this.pendedEnchantmentSelection,false);
               addEventListener(Event.ENTER_FRAME,this.pendedEnchantmentSelection,false,0,true);
               this.mcIngredientsList.active = true;
            }
            else
            {
               this._selectedEnchantmentData = null;
            }
            this.updatePinInputFeedback();
         }
      }
      
      private function pendedEnchantmentSelection(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.pendedEnchantmentSelection,false);
         if(this._selectedEnchantmentData)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnSelectEnchantment",[uint(this._selectedEnchantmentData.name)]));
         }
      }
      
      private function populateItemsList(param1:Object) : void
      {
         var _loc2_:int = this.mcItemsList.mcScrollingList.selectedIndex;
         var _loc3_:Array = param1 as Array;
         _loc2_ = _loc2_ > -1 ? _loc2_ : 0;
         _loc3_.sortOn(["isNotEnoughSockets","isEquipped"],[0,Array.DESCENDING]);
         var _loc4_:ItemDataStub;
         (_loc4_ = new ItemDataStub()).itemName = "[[panel_enchanting_show_all]]";
         _loc4_.userData = "ShowAll";
         _loc4_.id = 1;
         _loc3_.unshift(_loc4_);
         this.mcItemsList.data = _loc3_;
         this.mcItemsList.mcScrollingList.validateNow();
         this.mcItemsList.validateNow();
         this.mcItemsList.mcScrollingList.selectedIndex = _loc2_;
         this.mcItemsList.mcScrollingList.validateNow();
         this.handleItemSelected();
      }
      
      private function populateEnchantmentsList(param1:Object) : void
      {
         var _loc2_:Array = param1 as Array;
         var _loc3_:Number = this._cachedEnchantmentIdx;
         this._cachedEnchantmentIdx = -1;
         this.mcEnchantmentsList.removeEventListener(ListEvent.INDEX_CHANGE,this.handleEnchantmentSelected);
         _loc2_.sortOn(["type","level"],Array.DESCENDING);
         this.mcEnchantmentsList.data = _loc2_;
         this.mcEnchantmentsList.alpha = 0;
         this.mcEnchantmentsList.x = this.listAnimPos;
         this.mcEnchantmentsList.validateNow();
         GTweener.removeTweens(this.mcEnchantmentsList);
         GTweener.to(this.mcEnchantmentsList,0.5,{
            "x":this.listDefaultPos,
            "alpha":1
         },{"ease":Sine.easeIn});
         if(!_loc2_ || _loc2_.length < 1)
         {
            this.mcEnchantmentsList.enabled = false;
            this.mcIngredientsList.active = false;
         }
         else
         {
            this.mcEnchantmentsList.enabled = true;
            this.mcEnchantmentsList.addEventListener(ListEvent.INDEX_CHANGE,this.handleEnchantmentSelected,false,0,true);
         }
         if(this.mcEnchantmentsList.focused)
         {
            _loc3_ = _loc3_ > -1 ? _loc3_ : 0;
            this.mcEnchantmentsList.mcScrollingList.selectedIndex = _loc3_;
            this.mcEnchantmentsList.mcScrollingList.validateNow();
         }
      }
      
      private function populateIngredientsList(param1:Object) : void
      {
         var _loc2_:Object = param1;
         this.mcIngredientsList.data = _loc2_;
         GTweener.removeTweens(this.mcIngredientsList);
         if(_loc2_)
         {
            GTweener.to(this.mcIngredientsList,0.5,{
               "x":this.ingredientsDefaultPos,
               "alpha":1
            },{"ease":Sine.easeIn});
         }
         else
         {
            GTweener.to(this.mcIngredientsList,0.5,{
               "x":this.ingredientsAnimPos,
               "alpha":0
            },{"ease":Sine.easeOut});
         }
      }
      
      private function enchantItem() : void
      {
         if(this._addSocketMode)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnNotEnoughSockets",[]));
            return;
         }
         if(!this._enchantmentEnabled)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnUnexpectedError",[]));
            return;
         }
         if(this._notEnoughMoneyToApply)
         {
            this.mcActionEnchant.mcCoinIcon.gotoAndPlay("error");
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnNotEnoughMoney",[]));
            return;
         }
         if(!this._isInProgress && this._selectedItemRenderer && Boolean(this._selectedItemData))
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfrimAction",[uint(this._selectedItemData.id),this.mcActionEnchant.price,false]));
         }
      }
      
      public function startEnchanting() : void
      {
         if(!this._isInProgress && Boolean(this._selectedItemRenderer))
         {
            this._isInProgress = true;
            this._selectedItemRenderer = this.mcItemsList.mcScrollingList.getSelectedRenderer() as InventoryListItemRenderer;
            this._selectedItemRenderer.showProgress(false,this.callEnchantItem,this.callSoundTrigger);
         }
      }
      
      private function callSoundTrigger(param1:Boolean) : void
      {
         if(param1)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnPlayEnchantSound",[true]));
         }
         else
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnPlayEnchantSound",[false]));
         }
      }
      
      private function removeEnchantmentItem() : void
      {
         if(!this._removeEnchantmentEnabled)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnUnexpectedError",[]));
            return;
         }
         if(this._notEnoughMoneyToRemove)
         {
            this.mcActionRemoveEnchantment.mcCoinIcon.gotoAndPlay("error");
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnNotEnoughMoney",[]));
            return;
         }
         if(!this._isInProgress && this._selectedItemRenderer && Boolean(this._selectedItemData))
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfrimAction",[uint(this._selectedItemData.id),this.mcActionRemoveEnchantment.price,true]));
         }
      }
      
      public function startRemovingEnchantments() : void
      {
         this._isInProgress = true;
         this._selectedItemRenderer = this.mcItemsList.mcScrollingList.getSelectedRenderer() as InventoryListItemRenderer;
         this._selectedItemRenderer.showProgress(true,this.callRemoveEnchantmentItem,this.callSoundTrigger);
      }
      
      private function callEnchantItem() : void
      {
         if(Boolean(this._selectedEnchantmentData) && Boolean(this._selectedItemData))
         {
            this._cachedEnchantmentIdx = this.mcEnchantmentsList.mcScrollingList.selectedIndex;
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnEnchantItem",[uint(this._selectedItemData.id),uint(this._selectedEnchantmentData.name)]));
            this._isInProgress = false;
         }
      }
      
      private function callRemoveEnchantmentItem() : void
      {
         if(this._selectedItemData)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnRemoveEnchantment",[uint(this._selectedItemData.id)]));
            this._isInProgress = false;
         }
      }
      
      private function handleEnchantClick(param1:ButtonEvent) : void
      {
         this.enchantItem();
      }
      
      private function handleRemoveEnchantmentClick(param1:ButtonEvent) : void
      {
         this.removeEnchantmentItem();
      }
      
      public function updatePinInputFeedback() : void
      {
         if(this._inputSymbolIDX != -1)
         {
            InputFeedbackManager.removeButton(this,this._inputSymbolIDX);
            this._inputSymbolIDX = -1;
         }
         if(this._selectedEnchantmentData != null && this.mcEnchantmentsList.focused > 0)
         {
            if(this._selectedEnchantmentData.name == this._pinnedTag)
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
      
      private function togglePinOnSelectedRecipe() : void
      {
         var _loc1_:uint = 0;
         if(this._selectedEnchantmentData != null && this.mcEnchantmentsList.focused > 0)
         {
            if(this._inputSymbolIDX != -1)
            {
               InputFeedbackManager.removeButton(this,this._inputSymbolIDX);
               this._inputSymbolIDX = -1;
            }
            if(this._pinnedTag == this._selectedEnchantmentData.name)
            {
               _loc1_ = 0;
               this._inputSymbolIDX = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_X,KeyCode.Q,"inputfeedback_pin_recipe");
            }
            else
            {
               _loc1_ = uint(this._selectedEnchantmentData.name);
               this._inputSymbolIDX = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_X,KeyCode.Q,"inputfeedback_unpin_recipe");
            }
            InputFeedbackManager.updateButtons(this);
            this._pinnedTag = _loc1_;
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnChangePinnedRecipe",[_loc1_]));
            EnchantmentListItemRenderer.setCurrentPinnedTag(stage,this._pinnedTag);
         }
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         super.handleInput(param1);
         var _loc2_:InputDetails = param1.details;
         if(_loc2_.value != InputValue.KEY_UP || this.mcFiltersMode.visible || param1.handled)
         {
            return;
         }
         switch(_loc2_.navEquivalent)
         {
            case NavigationCode.GAMEPAD_Y:
               this.removeEnchantmentItem();
               return;
            case NavigationCode.GAMEPAD_A:
            case NavigationCode.ENTER:
               this.enchantItem();
               return;
            case NavigationCode.GAMEPAD_X:
               this.togglePinOnSelectedRecipe();
               return;
            default:
               switch(_loc2_.code)
               {
                  case KeyCode.DELETE:
                     this.removeEnchantmentItem();
                     return;
                  case KeyCode.E:
                     this.enchantItem();
                     return;
                  case KeyCode.Q:
                     this.togglePinOnSelectedRecipe();
                     return;
                  default:
                     return;
               }
         }
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
            if(!this.mcFiltersMode.visible && (_loc2_.code == KeyCode.F || _loc2_.navEquivalent == NavigationCode.GAMEPAD_L3))
            {
               this.showFilterMode();
            }
         }
      }
      
      override protected function onLastMoveStatusChanged() : *
      {
         if(this.mcFiltersMode)
         {
            this.mcFiltersMode.lastMoveWasMouse = _lastMoveWasMouse;
         }
      }
      
      public function setLocalization(param1:String, param2:String, param3:String, param4:String, param5:String) : void
      {
         trace("GFX setLocalization ",param1,param2,param3);
         this._filterLocStr_hasIngredients = param1;
         this._filterLocStr_missingIngredients = param2;
         this._filterLocStr_level1 = param3;
         this._filterLocStr_level2 = param4;
         this._filterLocStr_level3 = param5;
      }
      
      public function setFiltersData(param1:Boolean, param2:Boolean, param3:Boolean, param4:Boolean, param5:Boolean) : void
      {
         var _loc6_:Array = null;
         _loc6_ = [{
            "key":"HasIngredients",
            "label":this._filterLocStr_hasIngredients,
            "isChecked":param1
         },{
            "key":"MissingIngredients",
            "label":this._filterLocStr_missingIngredients,
            "isChecked":param2
         },{
            "key":"Level1",
            "label":this._filterLocStr_level1,
            "isChecked":param3
         },{
            "key":"Level2",
            "label":this._filterLocStr_level2,
            "isChecked":param4
         },{
            "key":"Level3",
            "label":this._filterLocStr_level3,
            "isChecked":param5
         }];
         this.mcFiltersMode.setData(_loc6_);
         this.mcFiltersMode.validateNow();
         if(this._lastFilteredList != null)
         {
            this.mcEnchantmentsList.data = this._lastFilteredList;
         }
         this.updateFiltersText();
      }
      
      private function showFilterMode() : void
      {
         this.mcFiltersMode.show();
      }
      
      private function updateFiltersText() : void
      {
         var _loc6_:* = null;
         var _loc1_:Boolean = this.mcFiltersMode.isBoxChecked("HasIngredients");
         var _loc2_:Boolean = this.mcFiltersMode.isBoxChecked("MissingIngredients");
         var _loc3_:Boolean = this.mcFiltersMode.isBoxChecked("Level1");
         var _loc4_:Boolean = this.mcFiltersMode.isBoxChecked("Level2");
         var _loc5_:Boolean = this.mcFiltersMode.isBoxChecked("Level3");
         _loc6_ = "";
         if(_loc1_ && _loc2_ && _loc3_ && _loc4_ && _loc5_)
         {
            this.txtActiveFiltersList.text = "";
            this.txtActiveFiltersTitle.visible = false;
            return;
         }
         this.txtActiveFiltersTitle.visible = false;
         if(!_loc1_)
         {
            _loc6_ = this._filterLocStr_hasIngredients;
         }
         if(!_loc2_)
         {
            if(_loc6_ != "")
            {
               _loc6_ += ", ";
            }
            _loc6_ += this._filterLocStr_missingIngredients;
         }
         if(!_loc3_)
         {
            if(_loc6_ != "")
            {
               _loc6_ += ", ";
            }
            _loc6_ += this._filterLocStr_level1;
         }
         if(!_loc4_)
         {
            if(_loc6_ != "")
            {
               _loc6_ += ", ";
            }
            _loc6_ += this._filterLocStr_level2;
         }
         if(!_loc5_)
         {
            if(_loc6_ != "")
            {
               _loc6_ += ", ";
            }
            _loc6_ += this._filterLocStr_level3;
         }
         this.txtActiveFiltersList.text = _loc6_;
         this.txtActiveFiltersList.height = this.txtActiveFiltersList.textHeight + CommonConstants.SAFE_TEXT_PADDING;
         this.txtActiveFiltersList.y = this.mcFilterAnchor.y + this.mcFilterAnchor.height - this.txtActiveFiltersList.height;
      }
      
      private function applyFilters(param1:Array) : Array
      {
         var _loc8_:int = 0;
         var _loc9_:Object = null;
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc12_:Boolean = false;
         var _loc13_:Boolean = false;
         var _loc14_:Boolean = false;
         this._lastFilteredList = param1;
         var _loc2_:Array = new Array();
         var _loc3_:Boolean = this.mcFiltersMode.isBoxChecked("HasIngredients");
         var _loc4_:Boolean = this.mcFiltersMode.isBoxChecked("MissingIngredients");
         var _loc5_:Boolean = this.mcFiltersMode.isBoxChecked("Level1");
         var _loc6_:Boolean = this.mcFiltersMode.isBoxChecked("Level2");
         var _loc7_:Boolean = this.mcFiltersMode.isBoxChecked("Level3");
         _loc8_ = 0;
         while(_loc8_ < param1.length)
         {
            _loc10_ = Boolean((_loc9_ = param1[_loc8_]).canApply) || _loc4_;
            _loc11_ = !_loc9_.canApply || _loc3_;
            _loc12_ = _loc9_.level != 1 || _loc5_;
            _loc13_ = _loc9_.level != 2 || _loc6_;
            _loc14_ = _loc9_.level != 3 || _loc7_;
            if(_loc10_ && _loc11_ && _loc12_ && _loc13_ && _loc14_)
            {
               _loc2_.push(_loc9_);
            }
            _loc8_++;
         }
         return _loc2_;
      }
      
      private function filterModeClosed(param1:Boolean) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         if(param1)
         {
            if(this._lastFilteredList != null)
            {
               this.mcEnchantmentsList.data = this._lastFilteredList;
               this.mcEnchantmentsList.validateNow();
            }
            _loc2_ = this.mcFiltersMode.isBoxChecked("HasIngredients");
            _loc3_ = this.mcFiltersMode.isBoxChecked("MissingIngredients");
            _loc4_ = this.mcFiltersMode.isBoxChecked("Level1");
            _loc5_ = this.mcFiltersMode.isBoxChecked("Level2");
            _loc6_ = this.mcFiltersMode.isBoxChecked("Level3");
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnFiltersChanged",[_loc2_,_loc3_,_loc4_,_loc5_,_loc6_]));
            this.updateFiltersText();
         }
      }
      
      private function setMerchantInfo(param1:Object) : void
      {
         this.moduleMerchantInfo.data = param1;
      }
      
      internal function __setProp_mcEnchantmentsList_Scene1_EnchantmentsList_0() : *
      {
         try
         {
            this.mcEnchantmentsList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcEnchantmentsList.enabled = true;
         this.mcEnchantmentsList.enableInitCallback = false;
         this.mcEnchantmentsList.itemRendererClassName = "EnchantmentItemRendererRef";
         this.mcEnchantmentsList.visible = true;
         try
         {
            this.mcEnchantmentsList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcItemsList_Scene1_ItemsList_0() : *
      {
         try
         {
            this.mcItemsList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcItemsList.enabled = true;
         this.mcItemsList.enableInitCallback = false;
         this.mcItemsList.itemRendererClassName = "InventoryItemRendererRef";
         this.mcItemsList.visible = true;
         try
         {
            this.mcItemsList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
