package red.game.witcher3.menus.inventory_menu
{
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.text.TextField;
   import red.core.events.GameEvent;
   import red.game.witcher3.constants.InventoryFilterType;
   import red.game.witcher3.controls.TabListItem;
   import red.game.witcher3.controls.W3ScrollingList;
   import red.game.witcher3.events.ItemDragEvent;
   import red.game.witcher3.interfaces.IAbstractItemContainerModule;
   import red.game.witcher3.menus.common.ItemDataStub;
   import red.game.witcher3.menus.common.ModuleCommonPlayerGrid;
   import red.game.witcher3.slots.SlotBase;
   import red.game.witcher3.slots.SlotInventoryGrid;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   
   public class ModulePlayerGrid extends ModuleCommonPlayerGrid implements IAbstractItemContainerModule
   {
      
      private static const INVENTORY_FILTERS_ORDER:Vector.<int> = Vector.<int>([InventoryFilterType.WEAPONS,InventoryFilterType.POTIONS,InventoryFilterType.INGREDIENTS,InventoryFilterType.QUEST_ITEMS,InventoryFilterType.DEFAULT]);
      
      private static const INVENTORY_FILTERS_LOCALIZATION:Vector.<String> = Vector.<String>(["[[panel_inventory_filter_type_weapons]]","[[panel_inventory_filter_type_alchemy_items]]","[[panel_inventory_filter_type_ingredients]]","[[panel_inventory_filter_type_quest_items]]","[[panel_inventory_filter_type_default]]"]);
      
      private static const HORSE_FILTERS_ORDER:Vector.<int> = Vector.<int>([InventoryFilterType.PLAYER_ITEMS,InventoryFilterType.HORSE_ITEMS]);
      
      private static const HORSE_FILTERS_LOCALIZATION:Vector.<String> = Vector.<String>(["[[panel_inventory_filter_type_geralt]]","[[panel_inventory_filter_type_horse]]"]);
      
      protected static const INVALIDATE_FILTER:String = "invalidate_filter";
       
      
      public var mcTabList:W3ScrollingList;
      
      public var mcTabListItem1:TabListItem;
      
      public var mcTabListItem2:TabListItem;
      
      public var mcTabListItem3:TabListItem;
      
      public var mcTabListItem4:TabListItem;
      
      public var mcTabListItem5:TabListItem;
      
      public var mcHorseTabList:W3ScrollingList;
      
      public var mcHorseTabListItem1:TabListItem;
      
      public var mcHorseTabListItem2:TabListItem;
      
      public var maskClip:MovieClip;
      
      public var tfCurrentState:TextField;
      
      protected var _gridRenderHeight:int = 520;
      
      protected var m_defaultPosition:Number;
      
      protected var _currentInventoryFilterIndex:int = -1;
      
      protected var filterEventName:String = "OnInventoryFilterSelected";
      
      protected var _currentFiltersOrders:Vector.<int>;
      
      protected var _currentFiltersLocalization:Vector.<String>;
      
      protected var _currentFiltersControl:W3ScrollingList;
      
      protected var _currentState:String;
      
      protected var _disableFilters:Boolean;
      
      public function ModulePlayerGrid()
      {
         super();
         dataBindingKey = "inventory.grid.player";
         autoGridFocus = false;
      }
      
      public function disableFilters(param1:Boolean) : void
      {
         this._disableFilters = param1;
         if(this._disableFilters)
         {
            this.mcTabList.ShowRenderers(false);
            this.mcHorseTabList.ShowRenderers(false);
            this.mcTabList.removeEventListener(ListEvent.INDEX_CHANGE,this.onTabListItemClick);
            this.mcHorseTabList.removeEventListener(ListEvent.INDEX_CHANGE,this.onTabListItemClick);
         }
         else
         {
            this.applyCurrentState();
         }
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.maskClip = parent.getChildByName("mcGridMask") as MovieClip;
         if(this.maskClip)
         {
            this._gridRenderHeight = this.maskClip.height;
         }
         if(mcPlayerGrid)
         {
            this.m_defaultPosition = mcPlayerGrid.y;
            mcPlayerGrid.handlesRightJoystick = false;
         }
         dispatchEvent(new GameEvent(GameEvent.REGISTER,dataBindingKey + ".name",[this.handleGridNameSet]));
         stage.addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
         this.initControls();
      }
      
      override protected function initControls() : void
      {
         super.initControls();
         if(Boolean(this.mcTabList) && Boolean(this.mcHorseTabList))
         {
            this.mcTabList.dataProvider = new DataProvider([{"icon":"INGREDIENTS"},{"icon":"QUEST_ITEMS"},{"icon":"DEFAULT"},{"icon":"POTIONS"},{"icon":"WEAPONS"}]);
            this.mcHorseTabList.dataProvider = new DataProvider([{"icon":"HORSE_ITEMS"},{"icon":"PLAYER_ITEMS"}]);
            this.mcTabList.validateNow();
            this.mcHorseTabList.validateNow();
            this.mcTabList.ShowRenderers(false);
            this.mcHorseTabList.ShowRenderers(false);
         }
         mcPlayerGrid.addEventListener(ListEvent.INDEX_CHANGE,this.handleSlotChanged,false,0,true);
      }
      
      public function get currentState() : String
      {
         return this._currentState;
      }
      
      public function set currentState(param1:String) : void
      {
         if(this._currentState != param1)
         {
            this._currentInventoryFilterIndex = -1;
            this._currentState = param1;
            this.applyCurrentState();
         }
      }
      
      protected function applyCurrentState() : void
      {
         switch(this._currentState)
         {
            case MenuInventory.STATE_CHARACTER:
               mcPlayerGrid.ignoreGridPosition = false;
               this.setPlayerFiltrers();
               break;
            case MenuInventory.STATE_HORSE:
               mcPlayerGrid.ignoreGridPosition = true;
               this.setHorseFilters();
         }
      }
      
      protected function setPlayerFiltrers() : void
      {
         if(this._disableFilters)
         {
            return;
         }
         this.mcTabList.addEventListener(ListEvent.INDEX_CHANGE,this.onTabListItemClick,false,0,true);
         this.mcTabList.ShowRenderers(true);
         this.mcHorseTabList.ShowRenderers(false);
         this.mcHorseTabList.removeEventListener(ListEvent.INDEX_CHANGE,this.onTabListItemClick);
         this._currentFiltersControl = this.mcTabList;
         this._currentFiltersLocalization = INVENTORY_FILTERS_LOCALIZATION;
         this._currentFiltersOrders = INVENTORY_FILTERS_ORDER;
         this.mcTabList.selectedIndex = 0;
         this.selectInventoryFilterIndex(this.mcTabList.selectedIndex);
      }
      
      protected function setHorseFilters() : void
      {
         if(this._disableFilters)
         {
            return;
         }
         this.mcHorseTabList.ShowRenderers(true);
         this.mcHorseTabList.addEventListener(ListEvent.INDEX_CHANGE,this.onTabListItemClick,false,0,true);
         this.mcTabList.ShowRenderers(false);
         this.mcTabList.removeEventListener(ListEvent.INDEX_CHANGE,this.onTabListItemClick);
         this._currentFiltersControl = this.mcHorseTabList;
         this._currentFiltersLocalization = HORSE_FILTERS_LOCALIZATION;
         this._currentFiltersOrders = HORSE_FILTERS_ORDER;
         this.mcHorseTabList.selectedIndex = 0;
         this.selectInventoryFilterIndex(this.mcHorseTabList.selectedIndex);
      }
      
      public function SetOverburdened(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc3_:SlotInventoryGrid = null;
         _loc2_ = 0;
         while(_loc2_ < mcPlayerGrid.getRenderersLength())
         {
            _loc3_ = mcPlayerGrid.getRendererAt(_loc2_) as SlotInventoryGrid;
            if(_loc3_)
            {
               _loc3_.setOverburdened(param1);
            }
            _loc2_ += 1;
         }
      }
      
      protected function handleSlotChanged(param1:ListEvent) : void
      {
         var _loc2_:SlotBase = null;
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(focused > 0)
         {
            _loc2_ = param1.itemRenderer as SlotBase;
            invalidate(INVALIDATE_CONTEXT);
            if(_loc2_)
            {
               _loc3_ = Number(mcPlayerGrid.scrollBar.position);
               _loc4_ = _loc2_.y;
               _loc5_ = _loc2_.getSlotRect().height;
               if(_loc4_ + _loc5_ > this._gridRenderHeight + _loc3_)
               {
                  mcPlayerGrid.scrollBar.position = _loc4_ + _loc5_ - this._gridRenderHeight;
               }
               else if(_loc4_ < _loc3_)
               {
                  mcPlayerGrid.scrollBar.position = _loc4_;
               }
            }
         }
      }
      
      override public function set focused(param1:Number) : void
      {
         super.focused = param1;
         invalidate(INVALIDATE_CONTEXT);
      }
      
      override protected function handleModuleSelected() : void
      {
         super.handleModuleSelected();
         if(mcPlayerGrid.selectedIndex < 0)
         {
            mcPlayerGrid.findSelection();
         }
         invalidate(INVALIDATE_CONTEXT);
      }
      
      override protected function updateActiveContext(param1:SlotBase) : void
      {
         var _loc5_:ItemDataStub = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:Point = new Point();
         if(Boolean(param1) && enabled)
         {
            if(_loc5_ = param1.data as ItemDataStub)
            {
               _loc3_ = _loc5_.id;
               _loc2_ = uint(_loc5_.slotType);
            }
            _loc6_ = param1.x + param1.getSlotRect().width;
            _loc7_ = param1.y + param1.getSlotRect().height;
            _loc4_ = param1.parent.localToGlobal(new Point(_loc6_,_loc7_));
         }
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnSelectInventoryItem",[_loc3_,_loc2_,_loc4_.x,_loc4_.y]));
      }
      
      override protected function handleStartDrag(param1:ItemDragEvent) : void
      {
         var _loc2_:ItemDataStub = param1.targetItem.getDragData() as ItemDataStub;
         var _loc3_:SlotBase = param1.targetItem as SlotBase;
         if(Boolean(_loc3_) && _loc3_.owner != mcPlayerGrid)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnSetInventoryGridFilter",[_loc2_.id]));
         }
      }
      
      public function forceSelectTab(param1:int) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._currentFiltersOrders.length)
         {
            if(this._currentFiltersOrders[_loc2_] == param1)
            {
               this.selectInventoryFilterIndex(_loc2_);
            }
            _loc2_++;
         }
      }
      
      public function forceSelectItem(param1:int) : void
      {
         if(mcPlayerGrid)
         {
            mcPlayerGrid.selectedIndex = param1;
         }
      }
      
      protected function handleGridNameSet(param1:String) : void
      {
         if(this.tfCurrentState)
         {
            _moduleDisplayName = param1;
            this.tfCurrentState.htmlText = param1;
         }
      }
      
      protected function applyFilter(param1:int) : void
      {
         if(!this._disableFilters)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,this.filterEventName,[param1]));
            invalidate(INVALIDATE_CONTEXT);
         }
      }
      
      override protected function draw() : void
      {
         var _loc1_:SlotBase = null;
         super.draw();
         if(isInvalid(INVALIDATE_FILTER))
         {
            this.updateFilter();
         }
         if(isInvalid(INVALIDATE_CONTEXT))
         {
            _loc1_ = mcPlayerGrid.getRendererAt(mcPlayerGrid.selectedIndex) as SlotBase;
            this.updateActiveContext(_loc1_);
         }
      }
      
      private function onTabListItemClick(param1:ListEvent) : void
      {
         this._currentFiltersControl.selectedIndex = param1.index;
         this.selectInventoryFilterIndex(param1.index);
      }
      
      protected function selectInventoryFilterIndex(param1:int) : void
      {
         if(this._currentInventoryFilterIndex != param1)
         {
            _resetSelectionOnNextHandleData = true;
            this._currentInventoryFilterIndex = param1;
            invalidate(INVALIDATE_FILTER);
         }
      }
      
      protected function updateFilter() : void
      {
         var _loc1_:int = 0;
         if(this._currentInventoryFilterIndex > -1)
         {
            _loc1_ = this._currentFiltersOrders[this._currentInventoryFilterIndex];
            if(this.tfCurrentState)
            {
               this.tfCurrentState.htmlText = this._currentFiltersLocalization[this._currentInventoryFilterIndex];
               this.tfCurrentState.htmlText = CommonUtils.toUpperCaseSafe(this.tfCurrentState.htmlText);
            }
            this._currentInventoryFilterIndex = this._currentInventoryFilterIndex;
            if(this._currentFiltersControl)
            {
               this._currentFiltersControl.selectedIndex = this._currentInventoryFilterIndex;
            }
            this.applyFilter(_loc1_);
         }
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         if(param1.handled)
         {
            return;
         }
         if(this._currentFiltersControl)
         {
            this._currentFiltersControl.handleInput(param1);
         }
         if(!focused)
         {
            return;
         }
         if(!param1.handled)
         {
            mcPlayerGrid.handleInputNavSimple(param1);
         }
         if(!param1.handled)
         {
            super.handleInput(param1);
         }
      }
      
      override public function toString() : String
      {
         return "[W3 ModulePlayerGrid]";
      }
   }
}
