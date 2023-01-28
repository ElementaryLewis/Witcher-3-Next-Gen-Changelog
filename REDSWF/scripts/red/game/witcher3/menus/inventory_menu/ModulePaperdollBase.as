package red.game.witcher3.menus.inventory_menu
{
   import flash.geom.Point;
   import red.core.CoreMenuModule;
   import red.core.events.GameEvent;
   import red.game.witcher3.constants.DebugDataProvider;
   import red.game.witcher3.constants.InventorySlotType;
   import red.game.witcher3.interfaces.IAbstractItemContainerModule;
   import red.game.witcher3.menus.common.ItemDataStub;
   import red.game.witcher3.slots.SlotBase;
   import red.game.witcher3.slots.SlotPaperdoll;
   import red.game.witcher3.slots.SlotsListPaperdoll;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.gfx.Extensions;
   
   public class ModulePaperdollBase extends CoreMenuModule implements IAbstractItemContainerModule
   {
       
      
      public var mcPaperdoll:SlotsListPaperdoll;
      
      public function ModulePaperdollBase()
      {
         super();
         dataBindingKey = "inventory.paperdoll";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.mcPaperdoll.focusable = false;
         this.mcPaperdoll.activeSelectionVisible = false;
         stage.addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
         this.mcPaperdoll.addEventListener(ListEvent.INDEX_CHANGE,this.handleSlotChanged,false,0,true);
         if(!Extensions.isScaleform)
         {
            this.initDebugMode();
         }
      }
      
      public function paperdollRemoveItem(param1:uint) : void
      {
         if(enabled)
         {
            this.mcPaperdoll.removeItem(param1);
            invalidate(INVALIDATE_CONTEXT);
         }
      }
      
      public function handlePaperdollUpdateItem(param1:Object) : void
      {
         if(enabled)
         {
            this.mcPaperdoll.updateItemData(param1);
            invalidate(INVALIDATE_CONTEXT);
         }
      }
      
      public function handlePaperdollUpdateItems(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(enabled && Boolean(param1))
         {
            _loc2_ = int(param1.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               this.mcPaperdoll.updateItemData(param1[_loc3_]);
               _loc3_++;
            }
            invalidate(INVALIDATE_CONTEXT);
         }
      }
      
      protected function handlePaperdollDataSet(param1:Object, param2:int) : void
      {
         if(enabled)
         {
            this.mcPaperdoll.data = param1 as Array;
         }
      }
      
      override protected function handleModuleSelected() : void
      {
         super.handleModuleSelected();
         if(this.mcPaperdoll.selectedIndex < 0)
         {
            this.mcPaperdoll.selectedIndex = 0;
         }
         invalidate(INVALIDATE_CONTEXT);
      }
      
      protected function handleSlotChanged(param1:ListEvent) : void
      {
         if(enabled)
         {
            this.updateActiveContext(param1.itemRenderer as SlotPaperdoll);
         }
         dispatchEvent(param1);
      }
      
      public function forceSelectPaperdollSlot(param1:int) : void
      {
         this.mcPaperdoll.selectedIndex = this.mcPaperdoll.getIndexForSlotType(param1);
      }
      
      protected function updateActiveContext(param1:SlotPaperdoll) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:Point = null;
         var _loc5_:ItemDataStub = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         if(focused > 0)
         {
            _loc2_ = 0;
            _loc3_ = -1;
            _loc4_ = new Point();
            if(param1)
            {
               if(_loc5_ = param1.data as ItemDataStub)
               {
                  _loc2_ = _loc5_.id;
               }
               _loc6_ = param1.x + param1.getSlotRect().width;
               _loc7_ = param1.y + param1.getSlotRect().height;
               _loc4_ = param1.parent.localToGlobal(new Point(_loc6_,_loc7_));
               _loc3_ = param1.slotType;
            }
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnSelectPaperdollItem",[_loc2_,_loc3_,_loc4_.x,_loc4_.y]));
         }
      }
      
      override protected function draw() : void
      {
         var _loc1_:int = 0;
         var _loc2_:SlotPaperdoll = null;
         super.draw();
         if(isInvalid(INVALIDATE_CONTEXT))
         {
            if(this.mcPaperdoll.selectedIndex > -1)
            {
               _loc1_ = this.mcPaperdoll.selectedIndex;
               _loc2_ = this.mcPaperdoll.getRendererAt(_loc1_) as SlotPaperdoll;
               if(_loc2_)
               {
                  this.updateActiveContext(_loc2_);
               }
            }
         }
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         if(!focused)
         {
            return;
         }
         if(!param1.handled)
         {
            this.mcPaperdoll.handleInputPreset(param1);
         }
      }
      
      override public function set focused(param1:Number) : void
      {
         var _loc2_:SlotPaperdoll = null;
         super.focused = param1;
         if(param1 > 0)
         {
            this.unbindInventory();
            _loc2_ = this.mcPaperdoll.getRendererAt(this.mcPaperdoll.selectedIndex) as SlotPaperdoll;
            if(_loc2_)
            {
               this.updateActiveContext(_loc2_);
            }
         }
         this.mcPaperdoll.activeSelectionVisible = param1 != 0;
         if(this.mcPaperdoll.getSelectedRenderer() != null)
         {
            if(focused != 0)
            {
               (this.mcPaperdoll.getSelectedRenderer() as SlotBase).showTooltip();
            }
            else
            {
               (this.mcPaperdoll.getSelectedRenderer() as SlotBase).hideTooltip();
            }
         }
      }
      
      protected function unbindInventory() : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnSetCurrentPlayerGrid",["inventory.grid.player"]));
      }
      
      public function get CurrentItemDataStub() : ItemDataStub
      {
         return null;
      }
      
      private function initDebugMode() : void
      {
         this.handlePaperdollDataSet(DebugDataProvider.GetPaperdollData(),-1);
      }
      
      override public function toString() : String
      {
         return "[W3 ModulePaperdollBase]";
      }
      
      public function startSelectModeWithValidSlots(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:SlotPaperdoll = null;
         var _loc5_:Boolean = false;
         _loc2_ = 0;
         while(_loc2_ < this.mcPaperdoll.getRenderersLength())
         {
            _loc4_ = this.mcPaperdoll.getRendererAt(_loc2_) as SlotPaperdoll;
            _loc5_ = false;
            if(_loc4_)
            {
               _loc3_ = 0;
               while(_loc3_ < param1.length)
               {
                  if(_loc4_.CheckSlotsType(param1[_loc3_]))
                  {
                     _loc5_ = true;
                     break;
                  }
                  _loc3_++;
               }
               if(!_loc5_)
               {
                  _loc4_.selectable = false;
               }
               _loc4_.selectionMode = true;
            }
            _loc2_++;
         }
         this.mcPaperdoll.ReselectIndexIfInvalid(this.mcPaperdoll.selectedIndex);
      }
      
      public function endSelectionMode() : void
      {
         var _loc1_:int = 0;
         var _loc2_:SlotPaperdoll = null;
         _loc1_ = 0;
         while(_loc1_ < this.mcPaperdoll.getRenderersLength())
         {
            _loc2_ = this.mcPaperdoll.getRendererAt(_loc1_) as SlotPaperdoll;
            if(_loc2_)
            {
               _loc2_.selectable = true;
               _loc2_.selectionMode = false;
            }
            _loc1_++;
         }
      }
      
      private function isHorseSlot(param1:SlotPaperdoll) : Boolean
      {
         return param1.CheckSlotsType(InventorySlotType.HorseBag) || param1.CheckSlotsType(InventorySlotType.HorseBlinders) || param1.CheckSlotsType(InventorySlotType.HorseSaddle) || param1.CheckSlotsType(InventorySlotType.HorseTrophy);
      }
   }
}
