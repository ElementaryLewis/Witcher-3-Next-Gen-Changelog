package red.game.witcher3.menus.inventory_menu
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   import flash.utils.getTimer;
   import red.core.CoreMenu;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.InputFeedbackButton;
   import red.game.witcher3.managers.ContextInfoManager;
   import red.game.witcher3.managers.InputFeedbackManager;
   import red.game.witcher3.menus.character_menu.CharacterModeBackground;
   import red.game.witcher3.menus.common.CheckboxListMode;
   import red.game.witcher3.menus.common.ModuleMerchantInfo;
   import red.game.witcher3.menus.common.PlayerStatsModule;
   import red.game.witcher3.slots.SlotBase;
   import red.game.witcher3.slots.SlotInventoryGrid;
   import red.game.witcher3.slots.SlotPaperdoll;
   import red.game.witcher3.slots.SlotsListGrid;
   import red.game.witcher3.slots.SlotsTransferManager;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.events.ButtonEvent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class MenuInventory extends CoreMenu
   {
      
      public static const STATE_CHARACTER:String = "CharacterInventory";
      
      public static const STATE_HORSE:String = "HorseInventory";
      
      public static const IMS_Player:int = 0;
      
      public static const IMS_Shop:int = 1;
      
      public static const IMS_Container:int = 2;
      
      public static const IMS_HorseInventory:int = 3;
      
      public static const IMS_Stash:int = 4;
      
      public static const INV_SORT_MODE_INVALID:int = -1;
      
      public static const INV_SORT_MODE_TYPE:int = 0;
      
      public static const INV_SORT_MODE_PRICE:int = 1;
      
      public static const INV_SORT_MODE_WEIGHT:int = 2;
      
      public static const INV_SORT_MODE_DURABILTIY:int = 3;
      
      public static const INV_SORT_MODE_RARITY:int = 4;
      
      protected static const HORSE_GRID_X:Number = 1293;
      
      protected static const CONTAINER_GRID_X:Number = 758;
       
      
      private var mcContainerGridModule:ModuleContainer;
      
      public var mcPlayerInventory:InventoryTabbedListModule;
      
      private var mcPaperDollModule:ModulePaperdoll;
      
      public var mcHorsePaperdollModule:ModuleHorsePaperdoll;
      
      public var mcPlayerStatistics:PlayerStatsModule;
      
      public var mcSortingMode:CheckboxListMode;
      
      public var pinnedCraftingModule:PinnedCraftingInfoModule;
      
      public var currentSortingMode:int;
      
      public var mcSelectionMode:CharacterModeBackground;
      
      public var moduleMerchantInfo:ModuleMerchantInfo;
      
      public var containerGrid:Sprite;
      
      public var mcOverburdened:MovieClip;
      
      public var tooltipLeftAnchor:DisplayObject;
      
      public var tooltipRightAnchor:DisplayObject;
      
      public var mcShopPaperdollAnchor:DisplayObject;
      
      public var mcHorseModelAnchor:MovieClip;
      
      public var mcCharacterModelAnchor:MovieClip;
      
      public var mcCharacterRenderer:MovieClip;
      
      public var mcShopBackground:MovieClip;
      
      public var mcStashBackground:MovieClip;
      
      public var mcContainerAnchor:MovieClip;
      
      public var mcPaperdollAnchor:MovieClip;
      
      public var btnSort:InputFeedbackButton;
      
      public var btnSortChange:InputFeedbackButton;
      
      public var dropSlot:InventoryDropArea;
      
      public var mcSelectionModeBackground:MovieClip;
      
      public var tooltipPaperdollAnchor:MovieClip;
      
      protected var _filteringMode:Boolean;
      
      private var _btn_stats_id:int = -1;
      
      private var _btn_sort_id:int = -1;
      
      private var _btn_switch_sections:int = -1;
      
      private var _defaultTabIdx:int = -1;
      
      public var mcVitalityStat:PlayerStatInfo;
      
      public var mcToxicityStat:PlayerStatInfo;
      
      public var mcPanelDetailedStats:PlayerDetailedStatsPanel;
      
      public var mcPanelGeneralStats:PlayerGeneralStatsPanel;
      
      private var _rendererController:CharacterRendererController;
      
      public var playerGridInitX:Number;
      
      public var playerGridXOffset:Number = 155;
      
      private const TICK_DELAY:int = 100;
      
      private var _timer:Timer;
      
      private var tickTimeDelta:int = 0;
      
      protected var _isTooltipHidden:Boolean = false;
      
      public function MenuInventory()
      {
         SlotBase.AUTO_SHOW_COLLAPSED_ICON = true;
         SlotBase.OPT_MODE = false;
         super();
         this.playerGridInitX = this.mcPlayerInventory.x;
         this._rendererController = new CharacterRendererController(this.mcCharacterRenderer,this);
         this._rendererController.setCenterAnchor(450,50);
         this._rendererController.setDefaultAnchor(this.mcCharacterModelAnchor.x,50);
         this._rendererController.addFadeOutComponent(this.mcPlayerInventory);
         this._rendererController.addFadeOutComponent(this.mcVitalityStat);
         this._rendererController.addFadeOutComponent(this.mcToxicityStat);
         this._rendererController.addFadeOutComponent(this.btnSort);
         this._rendererController.addFadeOutComponent(this.btnSortChange);
         this._rendererController.leftInfoPanel = this.mcPanelGeneralStats;
         this._rendererController.rightInfoPanel = this.mcPanelDetailedStats;
         this.mcVitalityStat.label = "[[vitality]]";
         this.mcVitalityStat.isPositive = true;
         this.mcVitalityStat.type = PlayerStatInfo.TYPE_VITALITY;
         this.mcVitalityStat.visible = false;
         this.mcVitalityStat.dangerLimit = 0.3;
         this.mcToxicityStat.label = "[[attribute_name_toxicity]]";
         this.mcToxicityStat.isPositive = false;
         this.mcToxicityStat.type = PlayerStatInfo.TYPE_TOXICITY;
         this.mcToxicityStat.visible = false;
         this.mcToxicityStat.dangerLimit = 0.7;
         this.mcToxicityStat.isPercentage = true;
         this.mcCharacterRenderer.addEventListener(Event.ACTIVATE,this.handleCharStatsShown,false,0,true);
         this.mcCharacterRenderer.addEventListener(Event.DEACTIVATE,this.handleCharStatHidden,false,0,true);
         this.mcPlayerInventory.tabsAutoAlign = true;
         this.mcPlayerInventory.gridMaskOffset = 0;
         this.mcPlayerInventory.noDelay = false;
         this.dropSlot.disabled = true;
         this.mcCharacterRenderer.mouseChildren = this.mcCharacterRenderer.mouseEnabled = false;
         this.mcSelectionModeBackground.mouseChildren = this.mcSelectionModeBackground.mouseEnabled = false;
         this.mcSelectionMode.mcBackground = this.mcSelectionModeBackground;
         this.mcSelectionModeBackground.alpha = 0;
      }
      
      override public function setCurrentModule(param1:int) : void
      {
         super.setCurrentModule(param1);
         if(param1 == 0)
         {
            this.mcPlayerInventory.focused = 1;
            this.mcPlayerInventory.mcPlayerGrid.scrollPosition = 0;
            this.mcPlayerInventory.mcPlayerGrid.selectedIndex = -1;
            this.mcPlayerInventory.mcPlayerGrid.validateNow();
         }
      }
      
      private function handleCharStatsShown(param1:Event) : void
      {
         if(_contextMgr)
         {
            _contextMgr.enableInputFeedbackShowing(false,true);
            _contextMgr.blockTooltips(true);
            _contextMgr.blockModeSwitching = true;
         }
         this.dropSlot.disabled = true;
         if(this._btn_sort_id != -1)
         {
            InputFeedbackManager.removeButton(this,this._btn_sort_id);
            this._btn_sort_id = -1;
         }
         if(this._btn_switch_sections != -1)
         {
            InputFeedbackManager.removeButton(this,this._btn_switch_sections);
            this._btn_switch_sections = -1;
         }
         this.mcPlayerInventory.enabled = false;
         this.mcPlayerInventory.refreshButtons();
      }
      
      private function handleCharStatHidden(param1:Event) : void
      {
         if(_contextMgr)
         {
            _contextMgr.enableInputFeedbackShowing(true,true);
            _contextMgr.blockTooltips(false);
            _contextMgr.blockModeSwitching = false;
         }
         this.dropSlot.disabled = false;
         if(this._btn_sort_id == -1)
         {
            this._btn_sort_id = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_RSTICK_HOLD,-1,"panel_button_common_sort_items");
         }
         if(this._btn_switch_sections == -1)
         {
            this._btn_switch_sections = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_R3,-1,"panel_button_common_jump_sections");
         }
         this.mcPlayerInventory.enabled = true;
         this.mcPlayerInventory.refreshButtons();
      }
      
      override protected function get menuName() : String
      {
         return "InventoryMenu";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         var _loc1_:Array = [];
         var _loc2_:GridTabSections = new GridTabSections();
         _loc2_.push(4,new ItemSectionData(0,0,3,"[[panel_inventory_tab_weapons]]"));
         _loc2_.push(4,new ItemSectionData(1,4,8,"[[panel_inventory_tab_armors]]"));
         _loc2_.push(3,new ItemSectionData(0,0,2,"[[panel_alchemy_tab_oils]]"));
         _loc2_.push(3,new ItemSectionData(1,3,5,"[[panel_alchemy_tab_potions]]"));
         _loc2_.push(3,new ItemSectionData(2,6,8,"[[panel_alchemy_tab_bombs]]"));
         _loc2_.push(2,new ItemSectionData(0,0,5,"[[item_category_edibles]]"));
         _loc2_.push(2,new ItemSectionData(1,6,8,"[[panel_inventory_tab_horse]]"));
         _loc2_.push(1,new ItemSectionData(0,0,3,"[[item_category_quest_items]]"));
         _loc2_.push(1,new ItemSectionData(1,4,8,"[[item_category_misc]]"));
         _loc2_.push(0,new ItemSectionData(0,0,4,"[[panel_inventory_tab_crafting]]"));
         _loc2_.push(0,new ItemSectionData(1,5,8,"[[panel_inventory_tab_alchemy]]"));
         this.mcPlayerInventory.setItemSections(_loc2_);
         this.initDataBindings();
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         this.initTooltips();
         this.mcSelectionMode.visible = false;
         this.mcSelectionMode.addEventListener(CharacterModeBackground.ACCEPT,this.handleSelectionModeAcceptClick,false,0,true);
         this.mcSelectionMode.addEventListener(CharacterModeBackground.CANCEL,this.handleSelectionModeCancelClick,false,0,true);
         if(this.mcSortingMode)
         {
            this.mcSortingMode.hideCB = this.sortingModeClosed;
            this.mcSortingMode.closeCB = this.sortingModeApply;
            this.mcSortingMode.mcTitle.text = "[[gui_panel_sort_by]]";
            this.mcSortingMode.disallowCloseOnNoCheck = true;
            this.mcSortingMode.allowUnchecking = false;
            this.mcSortingMode.exclusiveCheckList = true;
            this.mcSortingMode.extraCloseMode = true;
         }
         this.btnSort.label = "[[panel_button_common_quick_sort_items]]";
         this.btnSort.setDataFromStage("",KeyCode.Q);
         this.btnSort.addEventListener(ButtonEvent.CLICK,this.handleSortClick,false,0,true);
         this.btnSort.clickable = true;
         this.btnSort.validateNow();
         this.btnSortChange.label = "[[panel_button_common_sort_items]]";
         this.btnSortChange.setDataFromStage("",KeyCode.F);
         this.btnSortChange.addEventListener(ButtonEvent.CLICK,this.showSortingModeChange,false,0,true);
         this.btnSortChange.clickable = true;
         this.btnSortChange.x = this.btnSort.x + this.btnSort.actualWidth;
         this._btn_sort_id = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_RSTICK_HOLD,-1,"panel_button_common_sort_items");
         this._timer = new Timer(this.TICK_DELAY);
         this._timer.addEventListener(TimerEvent.TIMER,this.handleTickEvent,false,0,true);
         this._timer.start();
         this.tickTimeDelta = getTimer();
         if(this._btn_switch_sections == -1)
         {
            this._btn_switch_sections = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_R3,-1,"panel_button_common_jump_sections");
         }
      }
      
      private function handleTickEvent(param1:TimerEvent) : void
      {
         var _loc2_:int = getTimer();
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnTickEvent",[int(_loc2_ - this.tickTimeDelta)]));
         this.tickTimeDelta = _loc2_;
      }
      
      public function setPaperdollPreviewIcon(param1:int, param2:Boolean) : void
      {
         if(!this.mcPaperDollModule)
         {
            return;
         }
         var _loc3_:SlotPaperdoll = this.mcPaperDollModule.mcPaperdoll.getRendererForSlotType(param1) as SlotPaperdoll;
         if(Boolean(_loc3_) && Boolean(_loc3_.mcPreviewIcon))
         {
            _loc3_.mcPreviewIcon.visible = param2;
         }
      }
      
      override public function setMenuState(param1:String) : void
      {
         super.setMenuState(param1);
      }
      
      public function setSortingMode(param1:int, param2:String, param3:String, param4:String, param5:String, param6:String) : void
      {
         var _loc7_:Array = null;
         this.currentSortingMode = param1;
         _loc7_ = [{
            "key":"TypeSort",
            "label":param2,
            "isChecked":param1 == INV_SORT_MODE_TYPE
         },{
            "key":"PriceSort",
            "label":param3,
            "isChecked":param1 == INV_SORT_MODE_PRICE
         },{
            "key":"WeightSort",
            "label":param4,
            "isChecked":param1 == INV_SORT_MODE_WEIGHT
         },{
            "key":"DurabilitySort",
            "label":param5,
            "isChecked":param1 == INV_SORT_MODE_DURABILTIY
         },{
            "key":"RaritySort",
            "label":param6,
            "isChecked":param1 == INV_SORT_MODE_RARITY
         }];
         this.mcPlayerInventory.mcPlayerGrid.setCurrentSort(this.currentSortingMode);
         this.mcSortingMode.setData(_loc7_);
         this.mcSortingMode.validateNow();
      }
      
      protected function initTooltips() : void
      {
         _contextMgr.addGridEventsTooltipHolder(stage,false);
         _contextMgr.defaultAnchor = this.tooltipLeftAnchor;
         _contextMgr.overridedMouseDataSource = "OnGetItemDataForMouse";
         _contextMgr.enableInputFeedbackShowing(true);
         _contextMgr.saveScaleValue = true;
      }
      
      protected function initDataBindings() : void
      {
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"inventory.item.active",[this.setActiveItem]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"inventory.capacity.overburdened.text",[this.setIsOverburdenedText]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"inventory.capacity.overburdened.value",[this.setIsOverburdened]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"inventory.selection.mode.show",[this.showSelectionMode]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"inventory.merchant.info",[this.setMerchantInfo]));
      }
      
      private function handleSortClick(param1:ButtonEvent = null) : void
      {
         this.mcPlayerInventory.mcPlayerGrid.ignoreNextGridPosition = true;
         this.mcPlayerInventory.mcPlayerGrid.scrollPosition = 0;
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnSortingRequested"));
      }
      
      public function setNewFlagsForTabs(param1:Boolean, param2:Boolean, param3:Boolean, param4:Boolean, param5:Boolean, param6:Boolean) : void
      {
         var _loc7_:Array = new Array(param1,param2,param3,param4,param5,param6);
         this.mcPlayerInventory.setNewFlagsForTabs(_loc7_);
      }
      
      override protected function onLastMoveStatusChanged() : *
      {
         if(this.mcSortingMode)
         {
            this.mcSortingMode.lastMoveWasMouse = _lastMoveWasMouse;
         }
      }
      
      public function setPreviewMode(param1:Boolean) : void
      {
         if(this.mcPaperDollModule)
         {
            this.mcPaperDollModule.previewMode = param1;
         }
      }
      
      public function setVitality(param1:Number, param2:Number, param3:Number) : void
      {
         this.mcVitalityStat.setData(param1,param2,param3);
      }
      
      public function setToxicity(param1:Number, param2:Number, param3:Number) : void
      {
         this.mcToxicityStat.setData(param1,param2,param3);
      }
      
      public function setFilteringMode(param1:Boolean) : void
      {
         this._filteringMode = param1;
         if(this._filteringMode)
         {
            if(this.mcPaperDollModule)
            {
               this.mcPaperDollModule.visible = false;
               this.mcPaperDollModule.enabled = false;
            }
         }
         else if(Boolean(this.mcPaperDollModule) && this.mcPaperDollModule.active)
         {
            this.mcPaperDollModule.visible = true;
            this.mcPaperDollModule.enabled = true;
         }
      }
      
      public function paperdollRemoveItem(param1:uint) : void
      {
         if(this.mcPaperDollModule)
         {
            this.mcPaperDollModule.paperdollRemoveItem(param1);
         }
      }
      
      public function handlePaperdollUpdateItem(param1:Object) : void
      {
         if(this.mcPaperDollModule)
         {
            this.mcPaperDollModule.handlePaperdollUpdateItem(param1);
         }
      }
      
      public function forceSelectTab(param1:int) : void
      {
         this.mcPlayerInventory.onSetTabCalled(param1);
      }
      
      public function forceSelectItem(param1:int) : void
      {
         this.mcPlayerInventory.forceSelectItem(param1);
      }
      
      public function forceSelectPaperdollSlot(param1:int) : void
      {
         if(this.mcPaperDollModule)
         {
            this.mcPaperDollModule.forceSelectPaperdollSlot(param1);
         }
      }
      
      public function inventoryRemoveItem(param1:int, param2:Boolean = false) : void
      {
         this.mcPlayerInventory.inventoryRemoveItem(param1,param2);
      }
      
      public function shopRemoveItem(param1:int) : void
      {
         if(this.mcContainerGridModule)
         {
            this.mcContainerGridModule.handleItemRemoved(param1);
         }
      }
      
      public function CloseMenu() : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnCloseMenu"));
      }
      
      private function showSortingModeChange(param1:ButtonEvent = null) : void
      {
         this.mcSortingMode.show();
         this.mcPlayerInventory.enabled = false;
         this.mcPlayerInventory._inputEnabled = false;
         if(this.mcPaperDollModule)
         {
            this.mcPaperDollModule.enabled = false;
         }
         _contextMgr.blockTooltips(true);
         _contextMgr.blockModeSwitching = true;
         currentModuleIdx = 0;
         this.mcPlayerInventory.refreshButtons();
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnSortingIndexChoosingStart"));
      }
      
      private function sortingModeClosed() : void
      {
         this.mcPlayerInventory.enabled = true;
         this.mcPlayerInventory._inputEnabled = true;
         if(this.mcPaperDollModule)
         {
            this.mcPaperDollModule.enabled = true;
         }
         _contextMgr.blockTooltips(false);
         _contextMgr.blockModeSwitching = false;
         currentModuleIdx = 0;
         this.mcPlayerInventory.refreshButtons();
      }
      
      private function sortingModeApply(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         if(this.mcSortingMode.isBoxChecked("TypeSort"))
         {
            _loc2_ = 0;
         }
         else if(this.mcSortingMode.isBoxChecked("PriceSort"))
         {
            _loc2_ = 1;
         }
         else if(this.mcSortingMode.isBoxChecked("WeightSort"))
         {
            _loc2_ = 2;
         }
         else if(this.mcSortingMode.isBoxChecked("DurabilitySort"))
         {
            _loc2_ = 3;
         }
         else if(this.mcSortingMode.isBoxChecked("RaritySort"))
         {
            _loc2_ = 4;
         }
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnSortingIndexChosen",[_loc2_]));
         this.mcPlayerInventory.mcPlayerGrid.ignoreNextGridPosition = true;
         this.mcPlayerInventory.mcPlayerGrid.scrollPosition = 0;
         this.mcPlayerInventory.mcPlayerGrid.setCurrentSort(_loc2_);
         this.mcPlayerInventory.mcPlayerGrid.selectedIndex = -1;
         this.mcPlayerInventory.mcPlayerGrid.validateNow();
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnSortingRequested"));
      }
      
      public function setDefaultTab(param1:int) : void
      {
         this._defaultTabIdx = param1;
      }
      
      private function createPaperdollModule(param1:Boolean) : Boolean
      {
         var _loc2_:Class = null;
         if(!this.mcPaperDollModule)
         {
            _loc2_ = getDefinitionByName("PaperdollRef") as Class;
            this.mcPaperDollModule = new _loc2_() as ModulePaperdoll;
            if(!this.mcPaperDollModule)
            {
               return false;
            }
            addChild(this.mcPaperDollModule);
            swapChildren(this.mcPaperdollAnchor,this.mcPaperDollModule);
            this.mcPaperDollModule.validateNow();
         }
         this.mcPaperDollModule.active = param1;
         this._rendererController.addFadeOutComponent(this.mcPaperDollModule);
         this.mcPaperDollModule.addEventListener(CharacterModeBackground.ACCEPT,this.handleSelectionModeAcceptClick,false,0,true);
         this.mcPaperDollModule.x = 856;
         this.mcPaperDollModule.y = 107;
         initModuleDynamically(this.mcPaperDollModule);
         return true;
      }
      
      private function createContainerGridModule(param1:int) : Boolean
      {
         var _loc2_:Class = null;
         if(!this.mcContainerGridModule)
         {
            _loc2_ = getDefinitionByName("ContainerGrid") as Class;
            this.mcContainerGridModule = new _loc2_() as ModuleContainer;
            this.mcContainerGridModule.mcPlayerGrid.ignoreValidationOpt = true;
            addChild(this.mcContainerGridModule);
            this.mcContainerGridModule.validateNow();
            swapChildren(this.mcContainerAnchor,this.mcContainerGridModule);
         }
         this.mcContainerGridModule.active = true;
         this.mcContainerGridModule.x = 1046;
         this.mcContainerGridModule.y = 217;
         this.mcContainerGridModule.dropMode = param1;
         this.mcContainerGridModule.dropEnabled = true;
         initModuleDynamically(this.mcContainerGridModule);
         return true;
      }
      
      public function setInventoryMode(param1:int) : void
      {
         this.mcPlayerInventory.mcPlayerGrid.dropMode = param1;
         if(this._btn_stats_id != -1)
         {
            InputFeedbackManager.removeButton(this,this._btn_stats_id);
            this._btn_stats_id = -1;
         }
         switch(param1)
         {
            case IMS_Player:
               if(this._btn_stats_id == -1)
               {
                  this._btn_stats_id = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_R2,KeyCode.C,"panel_common_show_advanced_statistics");
               }
               this.mcSortingMode.x = 0;
               this.btnSort.x = 314.75;
               this.btnSortChange.x = 500.65;
               this.mcPlayerInventory.x = this.playerGridInitX;
               this.mcShopBackground.visible = false;
               this.mcStashBackground.visible = false;
               this.createPaperdollModule(!this._filteringMode);
               this.mcCharacterRenderer.x = this.mcCharacterModelAnchor.x;
               this.mcCharacterRenderer.y = this.mcCharacterModelAnchor.y;
               this._rendererController.enabled = true;
               registerRenderTarget("test_nopack",1024,1024);
               this.dropSlot.disabled = false;
               this.mcVitalityStat.visible = true;
               this.mcToxicityStat.visible = true;
               this.mcPlayerInventory.setTabData(new DataProvider([{
                  "icon":"INGREDIENTS",
                  "locKey":"[[panel_inventory_filter_type_ingredients]]"
               },{
                  "icon":"QUEST_ITEMS",
                  "locKey":"[[panel_inventory_filter_type_quest_items]]"
               },{
                  "icon":"DEFAULT",
                  "locKey":"[[panel_inventory_filter_type_default]]"
               },{
                  "icon":"POTIONS",
                  "locKey":"[[panel_inventory_filter_type_alchemy_items]]"
               },{
                  "icon":"WEAPONS",
                  "locKey":"[[item_category_equipement]]"
               }]));
               this.mcPlayerInventory.onSetTabCalled(4);
               break;
            case IMS_Stash:
               this.mcSortingMode.x = 170;
               this.mcPlayerInventory.x = this.playerGridInitX + this.playerGridXOffset;
               if(this.mcPlayerInventory.mcSlotList as SlotsListGrid)
               {
                  (this.mcPlayerInventory.mcSlotList as SlotsListGrid).updateRendererBounds();
               }
               this.btnSort.x = 422;
               this.btnSortChange.x = 608;
               this.mcShopBackground.visible = false;
               this.mcStashBackground.visible = true;
               this.createContainerGridModule(param1);
               this.mcContainerGridModule.mcPlayerGrid.ignoreGridPosition = true;
               this.mcCharacterRenderer.visible = false;
               this._rendererController.enabled = false;
               this.dropSlot.disabled = true;
               this.mcVitalityStat.visible = false;
               this.mcToxicityStat.visible = false;
               this.mcPlayerInventory.setTabData(new DataProvider([{
                  "icon":"INGREDIENTS",
                  "locKey":"[[panel_inventory_filter_type_ingredients]]"
               },{
                  "icon":"QUEST_ITEMS",
                  "locKey":"[[panel_inventory_filter_type_quest_items]]"
               },{
                  "icon":"DEFAULT",
                  "locKey":"[[panel_inventory_filter_type_default]]"
               },{
                  "icon":"POTIONS",
                  "locKey":"[[panel_inventory_filter_type_alchemy_items]]"
               },{
                  "icon":"WEAPONS",
                  "locKey":"[[item_category_equipement]]"
               }]));
               if(this._defaultTabIdx != -1)
               {
                  this.mcPlayerInventory.onSetTabCalled(this._defaultTabIdx);
               }
               break;
            case IMS_Shop:
            case IMS_Container:
               this.mcSortingMode.x = 170;
               this.mcPlayerInventory.x = this.playerGridInitX + this.playerGridXOffset;
               if(this.mcPlayerInventory.mcSlotList as SlotsListGrid)
               {
                  (this.mcPlayerInventory.mcSlotList as SlotsListGrid).updateRendererBounds();
               }
               this.btnSort.x = 422;
               this.btnSortChange.x = 608;
               this.mcShopBackground.visible = true;
               this.mcStashBackground.visible = false;
               this.createContainerGridModule(param1);
               this.mcContainerGridModule.mcPlayerGrid.ignoreGridPosition = true;
               this.mcCharacterRenderer.visible = false;
               this._rendererController.enabled = false;
               this.dropSlot.disabled = true;
               this.mcVitalityStat.visible = false;
               this.mcToxicityStat.visible = false;
               this.mcPlayerInventory.setTabData(new DataProvider([{
                  "icon":"INGREDIENTS",
                  "locKey":"[[panel_inventory_filter_type_ingredients]]"
               },{
                  "icon":"QUEST_ITEMS",
                  "locKey":"[[panel_inventory_filter_type_quest_items]]"
               },{
                  "icon":"DEFAULT",
                  "locKey":"[[panel_inventory_filter_type_default]]"
               },{
                  "icon":"POTIONS",
                  "locKey":"[[panel_inventory_filter_type_alchemy_items]]"
               },{
                  "icon":"WEAPONS",
                  "locKey":"[[item_category_equipement]]"
               }]));
               if(this._defaultTabIdx != -1)
               {
                  this.mcPlayerInventory.onSetTabCalled(this._defaultTabIdx);
               }
               break;
            case IMS_HorseInventory:
               this.mcSortingMode.x = 170;
               this.mcShopBackground.visible = false;
               this.mcStashBackground.visible = false;
               this.createContainerGridModule(param1);
               this.mcCharacterRenderer.x = this.mcHorseModelAnchor.x;
               this.mcCharacterRenderer.y = this.mcHorseModelAnchor.y;
               this._rendererController.enabled = false;
               this.dropSlot.disabled = true;
               this.mcVitalityStat.visible = false;
               this.mcToxicityStat.visible = false;
         }
         stage.dispatchEvent(new Event(CoreMenu.CURRENT_MODULE_INVALIDATE));
      }
      
      protected function setIsOverburdenedText(param1:String) : void
      {
         var _loc2_:TextField = null;
         if(this.mcOverburdened)
         {
            _loc2_ = (this.mcOverburdened.getChildByName("txtOverburdened") as MovieClip).getChildByName("txtOverburdened") as TextField;
            if(_loc2_)
            {
               _loc2_.text = param1;
            }
         }
      }
      
      protected function setIsOverburdened(param1:Boolean) : void
      {
         this.mcOverburdened.visible = param1;
         this.mcPlayerInventory.SetOverburdened(param1);
      }
      
      protected function setMerchantInfo(param1:Object) : void
      {
         this.moduleMerchantInfo.data = param1;
      }
      
      public function setActiveItem(param1:String) : void
      {
      }
      
      override protected function handleInputNavigate(param1:InputEvent) : void
      {
         var _loc2_:InputDetails = param1.details;
         var _loc3_:Boolean = _loc2_.value == InputValue.KEY_UP && !param1.handled;
         if(_loc3_)
         {
            switch(_loc2_.navEquivalent)
            {
               case NavigationCode.GAMEPAD_R2:
                  param1.handled = true;
                  break;
               case NavigationCode.GAMEPAD_B:
                  if(this.mcSelectionMode.isActive())
                  {
                     param1.handled = true;
                     param1.stopImmediatePropagation();
                     this.CancelSelectionMode();
                  }
                  break;
               case NavigationCode.GAMEPAD_A:
                  if(this.mcSelectionMode.isActive())
                  {
                     if(this.FinishSelectionMode())
                     {
                        param1.handled = true;
                        param1.stopImmediatePropagation();
                     }
                  }
            }
            if(_loc2_.code == KeyCode.C)
            {
               param1.handled = true;
            }
            else if(_loc2_.code == KeyCode.Q)
            {
               if(!this.mcSelectionMode.isActive() && !this._rendererController.isActive())
               {
                  param1.handled = true;
                  this.handleSortClick();
               }
            }
            else if(_loc2_.code == KeyCode.F || _loc2_.navEquivalent == NavigationCode.GAMEPAD_R3)
            {
               if(!this.mcSelectionMode.isActive() && !this._rendererController.isActive())
               {
                  if(!this.mcSortingMode.visible)
                  {
                     this.showSortingModeChange();
                  }
                  else
                  {
                     this.mcSortingMode.close();
                  }
               }
            }
            if(_loc2_.code == KeyCode.E)
            {
               if(this.mcSelectionMode.isActive())
               {
                  if(this.FinishSelectionMode())
                  {
                     param1.handled = true;
                     param1.stopImmediatePropagation();
                  }
               }
            }
         }
         super.handleInputNavigate(param1);
      }
      
      private function handleSelectionModeAcceptClick(param1:Event) : void
      {
         this.FinishSelectionMode();
      }
      
      private function handleSelectionModeCancelClick(param1:Event) : void
      {
         this.CancelSelectionMode();
      }
      
      private function FinishSelectionMode() : Boolean
      {
         if(!this.mcPaperDollModule)
         {
            return false;
         }
         var _loc1_:SlotPaperdoll = this.mcPaperDollModule.mcPaperdoll.getSelectedRenderer() as SlotPaperdoll;
         if(_loc1_)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnSelectionModeTargetChosen",[_loc1_.equipID]));
            return true;
         }
         throw new Error("GFX - failed to activate selected slot, selected index: " + this.mcPaperDollModule.mcPaperdoll.selectedIndex);
      }
      
      private function CancelSelectionMode() : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnSelectionModeCancelRequested"));
      }
      
      protected function showSelectionMode(param1:Object) : void
      {
         if(!this.mcPaperDollModule)
         {
            return;
         }
         var _loc2_:int = int(param1.sourceItem);
         var _loc3_:Array = param1.validSlots;
         var _loc4_:SlotInventoryGrid;
         if(!(_loc4_ = this.mcPlayerInventory.getSlotByID(_loc2_)))
         {
            this.mcPlayerInventory.mcPlayerGrid.traceGrid();
            throw new Error("GFX - was unable to find inventory slot with id: " + _loc2_);
         }
         this.mcSelectionMode.activate(_loc4_);
         this.mcPaperDollModule.startSelectModeWithValidSlots(_loc3_);
         this.mcPlayerInventory.enabled = false;
         this.mcPlayerInventory._inputEnabled = false;
         currentModuleIdx = 0;
         this._rendererController.inputDisabled = true;
         SlotsTransferManager.getInstance().disabled = true;
         this._isTooltipHidden = ContextInfoManager.getInstanse().isHidden();
         if(!this._isTooltipHidden && Boolean(param1.isDyeApplyingMode))
         {
            ContextInfoManager.getInstanse().setHiddenState(true);
         }
      }
      
      public function hideSelectionMode() : void
      {
         if(!this.mcPaperDollModule)
         {
            return;
         }
         this.mcSelectionMode.deactivate();
         this.mcPaperDollModule.endSelectionMode();
         this.mcPlayerInventory.enabled = true;
         this.mcPlayerInventory._inputEnabled = true;
         currentModuleIdx = 0;
         this._rendererController.inputDisabled = false;
         SlotsTransferManager.getInstance().disabled = false;
         if(!this._isTooltipHidden)
         {
            ContextInfoManager.getInstanse().setHiddenState(false);
         }
      }
   }
}
