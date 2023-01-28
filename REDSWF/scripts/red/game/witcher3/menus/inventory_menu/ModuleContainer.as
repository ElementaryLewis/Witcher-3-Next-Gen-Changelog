package red.game.witcher3.menus.inventory_menu
{
   import flash.display.MovieClip;
   import red.core.events.GameEvent;
   import red.game.witcher3.interfaces.IDragTarget;
   import red.game.witcher3.interfaces.IDropTarget;
   import red.game.witcher3.interfaces.IInventorySlot;
   import red.game.witcher3.menus.common.ItemDataStub;
   import red.game.witcher3.slots.SlotBase;
   import red.game.witcher3.slots.SlotDragAvatar;
   import scaleform.clik.events.ListEvent;
   
   public class ModuleContainer extends ModulePlayerGrid implements IDropTarget
   {
       
      
      public var mcStateDropTarget:MovieClip;
      
      protected var _dropMode:int;
      
      protected var _dropSelection:Boolean;
      
      protected var _dropEnabled:Boolean;
      
      public function ModuleContainer()
      {
         super();
         dataBindingKey = "inventory.grid.container";
         filterEventName = "OnContainerFilterSelected";
         mcPlayerGrid.dropEnabled = false;
         this.mcStateDropTarget.visible = false;
      }
      
      override protected function handleDataSet(param1:Object, param2:int) : void
      {
         super.handleDataSet(param1,param2);
         mcPlayerGrid.validateNow();
      }
      
      override protected function initControls() : void
      {
         mcPlayerGrid.handleScrollBar = true;
         mcPlayerGrid.ignoreGridPosition = true;
         mcPlayerGrid.focusable = false;
         mcPlayerGrid.focused = 0;
         focused = 0;
         mcPlayerGrid.addEventListener(ListEvent.INDEX_CHANGE,handleSlotChanged,false,0,true);
      }
      
      override protected function updateActiveContext(param1:SlotBase) : void
      {
         if(focused)
         {
            super.updateActiveContext(param1);
         }
      }
      
      override public function toString() : String
      {
         return "[W3 ModuleContainer]";
      }
      
      public function get dropMode() : int
      {
         return this._dropMode;
      }
      
      public function set dropMode(param1:int) : void
      {
         this._dropMode = param1;
      }
      
      public function get dropSelection() : Boolean
      {
         return this._dropSelection;
      }
      
      public function set dropSelection(param1:Boolean) : void
      {
         this._dropSelection = param1;
      }
      
      public function get dropEnabled() : Boolean
      {
         return this._dropEnabled;
      }
      
      public function set dropEnabled(param1:Boolean) : void
      {
         this._dropEnabled = param1;
      }
      
      public function processOver(param1:SlotDragAvatar) : int
      {
         var _loc2_:* = false;
         if(param1)
         {
            _loc2_ = param1.getSourceContainer() == mcPlayerGrid;
            if(!_loc2_)
            {
               this.mcStateDropTarget.visible = this._dropSelection && Boolean(param1);
               return SlotDragAvatar.ACTION_DROP;
            }
            this.mcStateDropTarget.visible = false;
            return SlotDragAvatar.ACTION_NONE;
         }
         this.mcStateDropTarget.visible = false;
         return SlotDragAvatar.ACTION_NONE;
      }
      
      public function canDrop(param1:IDragTarget) : Boolean
      {
         var _loc2_:IInventorySlot = param1 as IInventorySlot;
         var _loc3_:* = _loc2_.owner == mcPlayerGrid;
         return !_loc3_;
      }
      
      public function applyDrop(param1:IDragTarget) : void
      {
         var _loc2_:ItemDataStub = param1.getDragData() as ItemDataStub;
         if(_loc2_)
         {
            if(this._dropMode == MenuInventory.IMS_Shop)
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnSellItem",[_loc2_.id,_loc2_.quantity]));
            }
            else if(this._dropMode == MenuInventory.IMS_Container)
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnTransferItem",[_loc2_.id,_loc2_.quantity,-1]));
            }
            else if(this._dropMode == MenuInventory.IMS_Stash)
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnMoveToStash",[_loc2_.id]));
            }
         }
      }
   }
}
