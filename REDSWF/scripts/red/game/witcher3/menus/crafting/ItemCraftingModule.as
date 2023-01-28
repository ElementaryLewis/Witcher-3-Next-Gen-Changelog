package red.game.witcher3.menus.crafting
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   import red.core.CoreMenuModule;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.InputFeedbackButton;
   import red.game.witcher3.controls.W3TextArea;
   import red.game.witcher3.controls.W3UILoader;
   import red.game.witcher3.events.ControllerChangeEvent;
   import red.game.witcher3.managers.InputManager;
   import red.game.witcher3.slots.SlotBase;
   import red.game.witcher3.slots.SlotCrafting;
   import red.game.witcher3.slots.SlotsListPreset;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.events.ButtonEvent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class ItemCraftingModule extends CoreMenuModule
   {
      
      private static const SOCKET_PADDING:Number = 2;
      
      private static const SOCKET_OFFSET:Number = -35;
      
      private static const SOCKET_REF:String = "SlotSocketRef";
       
      
      public var mcCanCraftFeedback:MovieClip;
      
      public var mcCraftingProgress:MovieClip;
      
      public var mcItemSlotsListPreset:SlotsListPreset;
      
      public var txtIngredients:TextField;
      
      public var txtCraftedItem:TextField;
      
      public var txtPrice:TextField;
      
      public var txtPricePrefix:TextField;
      
      public var mcPriceIcon:MovieClip;
      
      public var mcRecipeSlotItem1:SlotCrafting;
      
      public var mcRecipeSlotItem2:SlotCrafting;
      
      public var mcRecipeSlotItem3:SlotCrafting;
      
      public var mcRecipeSlotItem4:SlotCrafting;
      
      public var mcRecipeSlotItem5:SlotCrafting;
      
      public var mcRecipeSlotItem6:SlotCrafting;
      
      public var mcRecipeSlotItem7:SlotCrafting;
      
      public var mcCraftedItem:MovieClip;
      
      protected var recipeLinkList:Vector.<MovieClip>;
      
      protected var slotsList:Vector.<MovieClip>;
      
      private var _selectedItemTag:uint;
      
      public var hideEmptyDataHolders:Boolean = true;
      
      private var iconLoaderStartY:Number = Infinity;
      
      public var txtWarning:TextField;
      
      public var mcWarningBackgound:MovieClip;
      
      public var mcItemQuality:MovieClip;
      
      private var _autoAlignSlots:Boolean;
      
      protected var _canCraftItem:Boolean = false;
      
      private var _slotsItems:Vector.<MovieClip>;
      
      public function ItemCraftingModule()
      {
         var _loc1_:Number = NaN;
         this._slotsItems = new Vector.<MovieClip>();
         super();
         if(this.mcItemSlotsListPreset)
         {
            this.mcItemSlotsListPreset.sortData = true;
         }
         if(Boolean(this.txtWarning) && Boolean(this.mcWarningBackgound))
         {
            _loc1_ = 30;
            this.txtWarning.text = "[[panel_crafting_description]]";
            this.mcWarningBackgound.height = this.txtWarning.textHeight + _loc1_;
         }
         this.slotsList = new Vector.<MovieClip>();
         addChild(this.mcRecipeSlotItem7);
         addChild(this.mcRecipeSlotItem6);
         addChild(this.mcRecipeSlotItem5);
         addChild(this.mcRecipeSlotItem4);
         addChild(this.mcRecipeSlotItem3);
         addChild(this.mcRecipeSlotItem2);
         addChild(this.mcRecipeSlotItem1);
         this.slotsList.push(this.mcRecipeSlotItem1);
         this.slotsList.push(this.mcRecipeSlotItem2);
         this.slotsList.push(this.mcRecipeSlotItem3);
         this.slotsList.push(this.mcRecipeSlotItem4);
         this.slotsList.push(this.mcRecipeSlotItem5);
         this.slotsList.push(this.mcRecipeSlotItem6);
         this.slotsList.push(this.mcRecipeSlotItem7);
      }
      
      public function get autoAlignSlots() : Boolean
      {
         return this._autoAlignSlots;
      }
      
      public function set autoAlignSlots(param1:Boolean) : void
      {
         this._autoAlignSlots = param1;
      }
      
      public function get selectedItemTag() : uint
      {
         return this._selectedItemTag;
      }
      
      public function set selectedItemTag(param1:uint) : void
      {
         if(this._selectedItemTag != param1)
         {
            if(this.mcCraftingProgress)
            {
               this.mcCraftingProgress.gotoAndStop(1);
            }
            this._selectedItemTag = param1;
         }
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.setupRecipeLinks();
         this.setupCraftingButton();
         stage.addEventListener(InputEvent.INPUT,this.handleInput,false,-1,true);
         InputManager.getInstance().addEventListener(ControllerChangeEvent.CONTROLLER_CHANGE,this.updateCraftingButton,false,0,true);
         if(this.mcCraftingProgress)
         {
            this.mcCraftingProgress.addEventListener(Event.COMPLETE,this.handleProgressComplete,false,0,true);
         }
         if(this.mcItemSlotsListPreset)
         {
            this.mcItemSlotsListPreset.focusable = false;
         }
      }
      
      protected function setupRecipeLinks() : void
      {
         this.recipeLinkList = new Vector.<MovieClip>();
      }
      
      protected function setupCraftingButton() : void
      {
         var _loc1_:W3TextArea = null;
         var _loc2_:InputFeedbackButton = null;
         if(this.txtIngredients)
         {
            this.txtIngredients.htmlText = "[[panel_alchemy_required_ingridients]]";
            this.txtIngredients.htmlText = CommonUtils.toUpperCaseSafe(this.txtIngredients.htmlText);
         }
         if(this.mcCanCraftFeedback)
         {
            _loc1_ = this.mcCanCraftFeedback.getChildByName("txtCraft") as W3TextArea;
            if(_loc1_)
            {
               _loc1_.uppercase = true;
               _loc1_.htmlText = "[[panel_crafting_craft_item]]";
            }
            _loc2_ = this.mcCanCraftFeedback.getChildByName("mcButton") as InputFeedbackButton;
            if(_loc2_)
            {
               _loc2_.setDataFromStage(NavigationCode.GAMEPAD_A,KeyCode.E);
               _loc2_.addEventListener(ButtonEvent.CLICK,this.handleCraftClick,false,0,true);
            }
            this.updateCraftingButton();
         }
      }
      
      protected function updateCraftingButton(param1:ControllerChangeEvent = null) : void
      {
         var _loc5_:Boolean = false;
         var _loc6_:W3TextArea = null;
         var _loc7_:InputFeedbackButton = null;
         var _loc2_:Number = -20;
         var _loc3_:Number = 25;
         var _loc4_:Number = -25;
         if(this.mcCanCraftFeedback)
         {
            _loc5_ = InputManager.getInstance().isGamepad();
            if(_loc6_ = this.mcCanCraftFeedback.getChildByName("txtCraft") as W3TextArea)
            {
               _loc6_.visible = _loc5_;
            }
            if(_loc7_ = this.mcCanCraftFeedback.getChildByName("mcButton") as InputFeedbackButton)
            {
               if(_loc5_)
               {
                  _loc7_.label = "";
                  _loc7_.y = _loc3_;
                  _loc7_.x = _loc2_;
               }
               else
               {
                  _loc7_.label = "[[panel_crafting_craft_item]]";
                  _loc7_.validateNow();
                  _loc7_.y = _loc4_;
                  _loc7_.x = -_loc7_.getViewWidth() / 2;
               }
            }
         }
      }
      
      protected function handleCraftClick(param1:Event) : void
      {
         this.startCrafting();
      }
      
      public function setCraftedItemInfo(param1:uint, param2:String, param3:String, param4:Boolean, param5:int, param6:String, param7:int = 0, param8:int = 0) : void
      {
         var _loc9_:W3UILoader = null;
         this.selectedItemTag = param1;
         if(this.txtCraftedItem)
         {
            this.txtCraftedItem.htmlText = param2;
            this.txtCraftedItem.htmlText = CommonUtils.toUpperCaseSafe(this.txtCraftedItem.htmlText);
         }
         if(this.mcCraftedItem)
         {
            if(param4)
            {
               this.mcCraftedItem.gotoAndStop("Enabled");
            }
            else
            {
               this.mcCraftedItem.gotoAndStop("Disabled");
            }
            if(_loc9_ = this.mcCraftedItem.getChildByName("mcItem") as W3UILoader)
            {
               if(this.iconLoaderStartY == Number.POSITIVE_INFINITY)
               {
                  this.iconLoaderStartY = _loc9_.y;
               }
               _loc9_.source = "img://" + param3;
               _loc9_.GridSize = param5;
               if(param5 == 1)
               {
                  _loc9_.y = this.iconLoaderStartY;
               }
               else
               {
                  _loc9_.y = this.iconLoaderStartY - 32;
               }
            }
            this.updateSlots(param8,this.mcCraftedItem);
         }
         this._canCraftItem = param4;
         if(this.mcCanCraftFeedback)
         {
            if(param4)
            {
               this.mcCanCraftFeedback.gotoAndStop("Enabled");
               this.mcCanCraftFeedback.alpha = 1;
            }
            else
            {
               this.mcCanCraftFeedback.gotoAndStop("Disabled");
               this.mcCanCraftFeedback.alpha = 0.4;
            }
         }
         this.updateCraftingCost(param6);
      }
      
      public function updateSlots(param1:int, param2:MovieClip) : void
      {
         var _loc3_:int = 0;
         var _loc6_:MovieClip = null;
         if(isNaN(param1))
         {
            param1 = 0;
         }
         var _loc4_:Class = getDefinitionByName(SOCKET_REF) as Class;
         while(this._slotsItems.length > param1)
         {
            param2.removeChild(this._slotsItems.pop());
         }
         while(this._slotsItems.length < param1)
         {
            _loc6_ = new _loc4_() as MovieClip;
            param2.addChild(_loc6_);
            this._slotsItems.push(_loc6_);
         }
         var _loc5_:Number = parent.height;
         _loc3_ = 0;
         while(_loc3_ < param1)
         {
            this._slotsItems[_loc3_].x = SOCKET_OFFSET;
            this._slotsItems[_loc3_].y = (SOCKET_PADDING + this._slotsItems[_loc3_].height) * _loc3_ + SOCKET_OFFSET;
            _loc3_++;
         }
      }
      
      protected function updateCraftingCost(param1:String) : void
      {
         if(Boolean(this.txtPrice) && Boolean(this.txtPricePrefix) && Boolean(this.mcPriceIcon))
         {
            this.txtPricePrefix.htmlText = "[[panel_inventory_item_price]]";
            if(param1 == "")
            {
               param1 = "0";
            }
            this.txtPrice.htmlText = param1;
         }
      }
      
      public function setIngredientItemData(param1:Array) : void
      {
         if(this._autoAlignSlots)
         {
         }
         this.mcItemSlotsListPreset.data = param1;
         this.mcItemSlotsListPreset.validateNow();
         this.centerRenderers();
         this.updateRendererVisibility();
         this.updateLinkStates();
         this.updateSelectionState();
         this.mcItemSlotsListPreset.findSelection();
      }
      
      public function setItemColorQuality(param1:int) : *
      {
         if(this.mcItemQuality)
         {
            if(!isNaN(param1) && param1 != 0)
            {
               this.mcItemQuality.gotoAndStop(param1);
            }
            else
            {
               this.mcItemQuality.gotoAndStop(1);
            }
         }
      }
      
      protected function centerRenderers() : void
      {
         var _loc9_:MovieClip = null;
         var _loc1_:Number = 310;
         var _loc2_:Number = 80;
         var _loc3_:Number = 7;
         var _loc4_:int = this.mcItemSlotsListPreset.NumNonEmptyRenderers();
         var _loc5_:int = int(this.slotsList.length);
         var _loc6_:Number = _loc2_ * _loc4_ + _loc3_ * (_loc4_ - 1);
         var _loc7_:Number = _loc1_ - _loc6_ / 2;
         var _loc8_:int = 0;
         while(_loc8_ < _loc5_)
         {
            (_loc9_ = this.slotsList[_loc8_]).x = _loc7_ + _loc8_ * (_loc2_ + _loc3_);
            _loc8_++;
         }
      }
      
      protected function updateRendererVisibility() : void
      {
         var _loc1_:int = 0;
         var _loc2_:SlotBase = null;
         _loc1_ = 0;
         while(_loc1_ < this.mcItemSlotsListPreset.getRenderersLength())
         {
            _loc2_ = this.mcItemSlotsListPreset.getRendererAt(_loc1_) as SlotBase;
            if(_loc2_)
            {
               if(_loc2_.data == null && this.hideEmptyDataHolders)
               {
                  _loc2_.visible = false;
               }
               else
               {
                  _loc2_.visible = true;
               }
            }
            _loc1_++;
         }
      }
      
      protected function updateLinkStates() : void
      {
         var _loc2_:SlotCrafting = null;
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.recipeLinkList.length)
         {
            if(this.recipeLinkList[_loc1_])
            {
               _loc2_ = this.mcItemSlotsListPreset.getRendererAt(_loc1_) as SlotCrafting;
               if(_loc2_ && _loc2_.data && _loc2_.data.reqQuantity <= _loc2_.data.quantity)
               {
                  this.recipeLinkList[_loc1_].gotoAndStop("Enabled");
               }
               else
               {
                  this.recipeLinkList[_loc1_].gotoAndStop("Disabled");
               }
            }
            _loc1_++;
         }
      }
      
      public function cleanup() : void
      {
         visible = false;
         if(this.mcCraftingProgress)
         {
            this.mcCraftingProgress.gotoAndStop(1);
         }
      }
      
      override public function set focused(param1:Number) : void
      {
         super.focused = param1;
         this.updateSelectionState();
      }
      
      override public function set active(param1:Boolean) : void
      {
         super.active = param1;
         if(!active && Boolean(this.mcCraftingProgress))
         {
            this.mcCraftingProgress.gotoAndStop(1);
         }
      }
      
      protected function updateSelectionState() : void
      {
         var _loc1_:SlotBase = null;
         var _loc2_:int = 0;
         _loc1_ = this.mcItemSlotsListPreset.getSelectedRenderer() as SlotBase;
         if(this.mcItemSlotsListPreset.selectedIndex == -1 || _loc1_ == null)
         {
            this.mcItemSlotsListPreset.findSelection();
         }
         _loc2_ = 0;
         while(_loc2_ < this.mcItemSlotsListPreset.getRenderersLength())
         {
            _loc1_ = this.mcItemSlotsListPreset.getRendererAt(_loc2_) as SlotBase;
            if(_loc1_)
            {
               _loc1_.activeSelectionEnabled = focused != 0;
            }
            _loc2_++;
         }
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc3_:SlotCrafting = null;
         var _loc2_:InputDetails = param1.details as InputDetails;
         if(_loc2_.value == InputValue.KEY_DOWN)
         {
            if(_loc2_.navEquivalent == NavigationCode.GAMEPAD_A || _loc2_.code == KeyCode.E)
            {
               this.startCrafting();
               param1.handled = true;
            }
            else if(_loc2_.navEquivalent == NavigationCode.GAMEPAD_Y)
            {
               _loc3_ = this.mcItemSlotsListPreset.getSelectedRenderer() as SlotCrafting;
               if(_loc3_ && _loc3_.data && _loc3_.data.vendorQuantity > 0)
               {
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnBuyIngredient",[int(_loc3_.data.id),Boolean(_loc3_.data.reqQuantity - _loc3_.data.quantity == 1)]));
                  param1.handled = true;
               }
            }
         }
         if(param1.handled || !focused)
         {
            return;
         }
         if(this.mcItemSlotsListPreset)
         {
            this.mcItemSlotsListPreset.handleInputPreset(param1);
         }
      }
      
      public function startCrafting() : void
      {
         if(this.mcCraftingProgress)
         {
            if(this._canCraftItem)
            {
               this.mcCraftingProgress.gotoAndPlay("start");
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnStartCrafting"));
            }
            else
            {
               this.mcCraftingProgress.gotoAndPlay("CannotCraft");
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnCraftItem",[this.selectedItemTag]));
            }
         }
      }
      
      private function handleProgressComplete(param1:Event) : void
      {
         this.dispatchCraftingDone();
      }
      
      protected function dispatchCraftingDone() : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnCraftItem",[this.selectedItemTag]));
      }
   }
}
