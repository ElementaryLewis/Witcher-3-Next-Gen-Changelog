package red.game.witcher3.menus.common
{
   import flash.events.Event;
   import red.core.CoreMenu;
   import red.core.CoreMenuModule;
   import red.core.events.GameEvent;
   import red.game.witcher3.constants.DebugDataProvider;
   import red.game.witcher3.events.ItemDragEvent;
   import red.game.witcher3.interfaces.IAbstractItemContainerModule;
   import red.game.witcher3.slots.SlotBase;
   import red.game.witcher3.slots.SlotsListGrid;
   import red.game.witcher3.slots.SlotsTransferManager;
   import scaleform.clik.controls.ScrollBar;
   import scaleform.clik.events.InputEvent;
   import scaleform.gfx.Extensions;
   
   public class ModuleCommonPlayerGrid extends CoreMenuModule implements IAbstractItemContainerModule
   {
       
      
      public var mcPlayerGrid:SlotsListGrid;
      
      public var mcScrollBar:ScrollBar;
      
      public var autoGridFocus:Boolean = true;
      
      protected var _dragManager:SlotsTransferManager;
      
      protected var _moduleDisplayName:String = "";
      
      private var dataSetOnce:Boolean = false;
      
      protected var _resetSelectionOnNextHandleData:Boolean = false;
      
      public function ModuleCommonPlayerGrid()
      {
         super();
         dataBindingKey = "repair.grid.player";
      }
      
      override public function hasSelectableItems() : Boolean
      {
         if(this.mcPlayerGrid.getSelectedRenderer() == null || (this.mcPlayerGrid.getSelectedRenderer() as SlotBase).data == null)
         {
            return false;
         }
         return true;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         dispatchEvent(new GameEvent(GameEvent.REGISTER,dataBindingKey,[this.handleDataSet]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,dataBindingKey + ".itemUpdate",[this.handleItemUpdate]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,dataBindingKey + ".itemsUpdate",[this.handleItemsUpdate]));
         addEventListener(InputEvent.INPUT,handleInput,false,0,true);
         this.initControls();
      }
      
      protected function initControls() : void
      {
         if(!Extensions.isScaleform)
         {
            this.initDebugMode();
         }
         this.mcPlayerGrid.focusable = false;
         this._dragManager = SlotsTransferManager.getInstance();
         this._dragManager.addEventListener(ItemDragEvent.START_DRAG,this.handleStartDrag,false,0,true);
         this._dragManager.addEventListener(ItemDragEvent.STOP_DRAG,this.handleStopDrag,false,0,true);
      }
      
      protected function handleStopDrag(param1:ItemDragEvent) : void
      {
      }
      
      protected function handleStartDrag(param1:ItemDragEvent) : void
      {
      }
      
      public function inventoryRemoveItem(param1:int) : void
      {
         this.mcPlayerGrid.removeItem(param1);
      }
      
      protected function handleDataSet(param1:Object, param2:int) : void
      {
         var _loc4_:int = 0;
         if(param1)
         {
            _loc4_ = this.mcPlayerGrid.selectedIndex;
            this.mcPlayerGrid.data = param1 as Array;
            this.mcPlayerGrid.validateNow();
            if(!this._resetSelectionOnNextHandleData)
            {
               this.mcPlayerGrid.ReselectIndexIfInvalid(_loc4_);
            }
            this._resetSelectionOnNextHandleData = false;
            invalidate(INVALIDATE_CONTEXT);
         }
         if(!this.dataSetOnce || focused == 1 && (this.mcPlayerGrid.getSelectedRenderer() == null || (this.mcPlayerGrid.getSelectedRenderer() as SlotBase).data == null))
         {
            this.dataSetOnce = true;
            stage.dispatchEvent(new Event(CoreMenu.CURRENT_MODULE_INVALIDATE,false,false));
         }
         this.mcPlayerGrid.validateNow();
         var _loc3_:SlotBase = this.mcPlayerGrid.getSelectedRenderer() as SlotBase;
         if(_loc3_ != null && _loc3_.data != null)
         {
            _loc3_.activeSelectionEnabled = this.focused != 0;
         }
      }
      
      protected function updateActiveContext(param1:SlotBase) : void
      {
      }
      
      protected function handleItemUpdate(param1:Object) : void
      {
         var _loc2_:ItemDataStub = param1 as ItemDataStub;
         this.mcPlayerGrid.updateItemData(param1);
         invalidate(INVALIDATE_CONTEXT);
      }
      
      public function handleItemRemoved(param1:int) : void
      {
         this.mcPlayerGrid.removeItem(param1);
         invalidate(INVALIDATE_CONTEXT);
      }
      
      protected function handleItemsUpdate(param1:Array) : void
      {
         this.mcPlayerGrid.updateItems(param1);
         invalidate(INVALIDATE_CONTEXT);
      }
      
      protected function bindInventory() : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnSetCurrentPlayerGrid",[dataBindingKey]));
      }
      
      override public function set focused(param1:Number) : void
      {
         if(param1 > 0 && param1 != _focused)
         {
            this.bindInventory();
         }
         super.focused = param1;
         if(this.autoGridFocus)
         {
            this.mcPlayerGrid.focused = _focused;
         }
         else if(this.mcPlayerGrid.selectedIndex < 0)
         {
            this.mcPlayerGrid.findSelection();
         }
         var _loc2_:SlotBase = this.mcPlayerGrid.getSelectedRenderer() as SlotBase;
         if(_loc2_)
         {
            _loc2_.activeSelectionEnabled = param1 != 0;
         }
      }
      
      public function get CurrentItemDataStub() : ItemDataStub
      {
         return null;
      }
      
      private function initDebugMode() : void
      {
         this.handleDataSet(DebugDataProvider.GetGridDebugData(),0);
      }
      
      override public function toString() : String
      {
         return "[W3 ModuleCommonPlayerGrid]";
      }
   }
}
