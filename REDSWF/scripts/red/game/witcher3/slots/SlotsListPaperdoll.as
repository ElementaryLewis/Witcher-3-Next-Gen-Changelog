package red.game.witcher3.slots
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import red.game.witcher3.constants.InventorySlotType;
   import red.game.witcher3.interfaces.IBaseSlot;
   import red.game.witcher3.interfaces.IPaperdollSlot;
   import red.game.witcher3.menus.common.ItemDataStub;
   
   public class SlotsListPaperdoll extends SlotsListBase
   {
       
      
      protected var _slotTypeToIndexMap:Vector.<int>;
      
      protected var _equipSlotToIndexMap:Vector.<int>;
      
      public function SlotsListPaperdoll()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
      }
      
      private function initializeSlots() : void
      {
         var _loc3_:IPaperdollSlot = null;
         var _loc4_:int = 0;
         this._slotTypeToIndexMap = new Vector.<int>(InventorySlotType._COUNT,true);
         this._equipSlotToIndexMap = new Vector.<int>(InventorySlotType._COUNT,true);
         this._slotTypeToIndexMap[InventorySlotType.InvalidSlot] = -1;
         var _loc1_:uint = _renderers.length;
         var _loc2_:uint = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = IPaperdollSlot(_renderers[_loc2_]);
            _loc4_ = IPaperdollSlot(_loc3_).slotType;
            this.setupRenderer(_loc3_);
            _loc3_.index = _loc2_;
            this._slotTypeToIndexMap[_loc4_] = _loc2_;
            this._equipSlotToIndexMap[_loc3_.equipID] = _loc2_;
            _loc2_++;
         }
      }
      
      public function set slotList(param1:Vector.<IBaseSlot>) : *
      {
         _renderers = param1;
      }
      
      public function set slotsInstanceName(param1:String) : void
      {
         var _loc4_:IBaseSlot = null;
         if(param1 == null || param1 == "" || parent == null)
         {
            throw new Error("Slot instance name is not defined");
         }
         var _loc2_:uint = 0;
         var _loc3_:Vector.<IBaseSlot> = new Vector.<IBaseSlot>();
         while(++_loc2_)
         {
            if((_loc4_ = parent.getChildByName(param1 + _loc2_) as IBaseSlot) == null)
            {
               if(_loc2_ != 0)
               {
                  break;
               }
            }
            else
            {
               _loc3_.push(_loc4_);
            }
         }
         this.slotList = _loc3_;
      }
      
      public function hasItemInSlot(param1:int) : Boolean
      {
         var _loc2_:IBaseSlot = null;
         var _loc3_:ItemDataStub = null;
         var _loc4_:int = 0;
         if(this.IsQuickSlotBySlotType(param1))
         {
            _loc4_ = InventorySlotType.Quickslot1;
            while(_loc4_ <= InventorySlotType.Quickslot2)
            {
               _loc2_ = this.getRendererForSlotType(_loc4_);
               _loc3_ = !!_loc2_ ? _loc2_.data as ItemDataStub : null;
               if(Boolean(_loc3_))
               {
                  return true;
               }
               _loc4_++;
            }
            return false;
         }
         _loc2_ = this.getRendererForSlotType(param1);
         _loc3_ = !!_loc2_ ? _loc2_.data as ItemDataStub : null;
         return Boolean(_loc3_);
      }
      
      public function getRendererForSlotType(param1:int) : IBaseSlot
      {
         return getRendererAt(this.getIndexForSlotType(param1)) as IBaseSlot;
      }
      
      public function getIndexForSlotType(param1:int) : int
      {
         if(this._slotTypeToIndexMap.length > 0)
         {
            if(this._slotTypeToIndexMap[param1] > -1)
            {
               return this._slotTypeToIndexMap[param1];
            }
            return -1;
         }
         return -1;
      }
      
      override public function updateItemData(param1:Object) : void
      {
         var _loc4_:IBaseSlot = null;
         var _loc5_:SlotBase = null;
         var _loc2_:ItemDataStub = param1 as ItemDataStub;
         var _loc3_:int = this.getDataIndex(_loc2_);
         if(!_loc2_.groupId)
         {
            this.removeItem(_loc2_.id);
         }
         else
         {
            this.removeGroupItem(_loc2_.id,_loc2_.groupId);
         }
         if(_loc3_ > -1)
         {
            (_loc4_ = _renderers[_loc3_]).data = _loc2_;
            if(_loc5_ = _loc4_ as SlotBase)
            {
               _loc5_.showTooltip();
            }
         }
      }
      
      public function removeGroupItem(param1:uint, param2:int) : void
      {
         var _loc4_:IBaseSlot = null;
         var _loc5_:SlotBase = null;
         var _loc3_:int = getIdIndex(param1,param2);
         if(_loc3_ > -1)
         {
            (_loc4_ = _renderers[_loc3_]).cleanup();
            if(_loc5_ = _loc4_ as SlotBase)
            {
               _loc5_.showTooltip();
            }
         }
      }
      
      override public function removeItem(param1:uint, param2:Boolean = false) : void
      {
         var _loc4_:IBaseSlot = null;
         var _loc5_:SlotBase = null;
         var _loc3_:int = getIdIndex(param1);
         if(_loc3_ > -1)
         {
            (_loc4_ = _renderers[_loc3_]).cleanup();
            if(_loc5_ = _loc4_ as SlotBase)
            {
               _loc5_.showTooltip();
            }
         }
      }
      
      override protected function populateData() : void
      {
         var _loc2_:SlotPaperdoll = null;
         var _loc5_:ItemDataStub = null;
         var _loc6_:int = 0;
         super.populateData();
         if(!data)
         {
            return;
         }
         var _loc1_:Array = new Array();
         var _loc3_:int = int(_renderers.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _renderers[_loc4_].cleanup();
            _loc4_++;
         }
         this.initializeSlots();
         _renderersCount = _renderers.length;
         for each(_loc5_ in data)
         {
            _loc6_ = this.getDataIndex(_loc5_);
            _loc1_.push(_loc6_);
            _loc2_ = getRendererAt(_loc6_) as SlotPaperdoll;
            if(_loc2_.equipID == _loc5_.equipped)
            {
               if(_loc2_)
               {
                  _loc2_.data = _loc5_;
               }
            }
         }
         if(selectedIndex == -1)
         {
            findSelection();
         }
      }
      
      override protected function getDataIndex(param1:ItemDataStub) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = param1.slotType;
         if(param1.equipped)
         {
            return this._equipSlotToIndexMap[param1.equipped];
         }
         _loc2_ = _loc3_;
         return this.getIndexForSlotType(_loc2_);
      }
      
      override protected function setupRenderer(param1:IBaseSlot) : void
      {
         var _loc2_:IPaperdollSlot = param1 as IPaperdollSlot;
         if(_loc2_)
         {
            _loc2_.owner = this;
            _loc2_.enabled = enabled;
            (_loc2_.getHitArea() as MovieClip).addEventListener(MouseEvent.MOUSE_DOWN,this.handleItemClick,false,0,true);
            (_loc2_.getHitArea() as MovieClip).addEventListener(MouseEvent.MOUSE_UP,handleItemMouseUp,false,0,true);
         }
      }
      
      override protected function cleanUpRenderer(param1:IBaseSlot) : void
      {
         var _loc2_:IPaperdollSlot = param1 as IPaperdollSlot;
         if(_loc2_)
         {
            _loc2_.owner = null;
            (_loc2_.getHitArea() as MovieClip).removeEventListener(MouseEvent.MOUSE_DOWN,this.handleItemClick);
            (_loc2_.getHitArea() as MovieClip).removeEventListener(MouseEvent.MOUSE_UP,handleItemMouseUp);
         }
      }
      
      override protected function handleItemClick(param1:MouseEvent) : void
      {
         super.handleItemClick(param1);
      }
      
      protected function CheckIfNeedUpdate(param1:Array, param2:int) : *
      {
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_] == param2)
            {
               param1.splice(_loc3_,1);
               return false;
            }
            _loc3_++;
         }
         return true;
      }
      
      private function IsQuickSlotBySlotType(param1:uint) : Boolean
      {
         switch(param1)
         {
            case InventorySlotType.Quickslot1:
            case InventorySlotType.Quickslot2:
               return true;
            default:
               return false;
         }
      }
      
      private function IsPotionSlotBySlotType(param1:uint) : Boolean
      {
         switch(param1)
         {
            case InventorySlotType.Potion1:
            case InventorySlotType.Potion2:
               return true;
            default:
               return false;
         }
      }
      
      private function IsPetardSlotBySlotType(param1:uint) : Boolean
      {
         switch(param1)
         {
            case InventorySlotType.Petard1:
            case InventorySlotType.Petard2:
               return true;
            default:
               return false;
         }
      }
      
      override public function toString() : String
      {
         return "[SlotsListPaperdoll " + name + "]";
      }
   }
}
