package red.game.witcher3.menus.blacksmith
{
   import red.game.witcher3.slots.SlotPaperdoll;
   import red.game.witcher3.utils.CommonUtils;
   
   public class ItemDisassembleInfo extends BlacksmithItemPanel
   {
       
      
      private const MAX_SOCKETS_COUNT:int = 3;
      
      private const SLOTS_COUNT:int = 7;
      
      public var mcSlot1:SlotPaperdoll;
      
      public var mcSlot2:SlotPaperdoll;
      
      public var mcSlot3:SlotPaperdoll;
      
      public var mcSlot4:SlotPaperdoll;
      
      public var mcSlot5:SlotPaperdoll;
      
      public var mcSlot6:SlotPaperdoll;
      
      public var mcSlot7:SlotPaperdoll;
      
      private var _slotsList:Vector.<SlotPaperdoll>;
      
      public var mcRuneSlot1:SlotPaperdoll;
      
      public var mcRuneSlot2:SlotPaperdoll;
      
      public var mcRuneSlot3:SlotPaperdoll;
      
      public function ItemDisassembleInfo()
      {
         var _loc2_:SlotPaperdoll = null;
         super();
         this._slotsList = new Vector.<SlotPaperdoll>();
         var _loc1_:int = 0;
         while(_loc1_ < this.SLOTS_COUNT)
         {
            _loc2_ = getChildByName("mcSlot" + _loc1_) as SlotPaperdoll;
            if(_loc2_)
            {
               _loc2_.darkUnselectable = false;
               _loc2_.selectable = false;
               _loc2_.draggingEnabled = false;
               this._slotsList.push(_loc2_);
            }
            _loc1_++;
         }
         this.mcRuneSlot1.enabled = false;
         this.mcRuneSlot1.darkUnselectable = false;
         this.mcRuneSlot1.selectable = false;
         this.mcRuneSlot1.visible = false;
         this.mcRuneSlot2.enabled = false;
         this.mcRuneSlot2.darkUnselectable = false;
         this.mcRuneSlot2.selectable = false;
         this.mcRuneSlot2.visible = false;
         this.mcRuneSlot3.enabled = false;
         this.mcRuneSlot3.darkUnselectable = false;
         this.mcRuneSlot3.selectable = false;
         this.mcRuneSlot3.visible = false;
      }
      
      override protected function cleanupView() : void
      {
         super.cleanupView();
         this.cleanupSlots();
      }
      
      override protected function updateData() : void
      {
         super.updateData();
         this.cleanupSlots();
         this.populateData();
         this.populateSocketsData();
         if(_data.disableAction)
         {
            filters = [CommonUtils.getDesaturateFilter()];
            alpha = 0.4;
         }
         else
         {
            filters = [];
            alpha = 1;
         }
      }
      
      private function cleanupSlots() : void
      {
         var _loc1_:int = int(this._slotsList.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            this._slotsList[_loc2_].tfSlotName.text = "";
            this._slotsList[_loc2_].cleanup();
            _loc2_++;
         }
      }
      
      private function populateData() : void
      {
         var _loc2_:int = 0;
         var _loc3_:Vector.<SlotPaperdoll> = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc1_:Array = _data.partList as Array;
         if(_loc1_)
         {
            _loc2_ = Math.min(this._slotsList.length,_loc1_.length);
            _loc3_ = new Vector.<SlotPaperdoll>();
            if(_loc2_ == 1)
            {
               _loc3_.push(this.mcSlot1);
            }
            else if(_loc2_ == 2)
            {
               _loc3_.push(this.mcSlot1);
               _loc3_.push(this.mcSlot2);
            }
            else if(_loc2_ == 3)
            {
               _loc3_.push(this.mcSlot1);
               _loc3_.push(this.mcSlot2);
               _loc3_.push(this.mcSlot3);
            }
            else if(_loc2_ == 4)
            {
               _loc3_.push(this.mcSlot1);
               _loc3_.push(this.mcSlot2);
               _loc3_.push(this.mcSlot3);
               _loc3_.push(this.mcSlot4);
            }
            else
            {
               _loc3_.push(this.mcSlot1);
               _loc3_.push(this.mcSlot2);
               _loc3_.push(this.mcSlot3);
               _loc3_.push(this.mcSlot4);
               _loc3_.push(this.mcSlot5);
            }
            _loc4_ = 0;
            while(_loc4_ < this._slotsList.length)
            {
               this._slotsList[_loc4_].visible = false;
               _loc4_++;
            }
            _loc5_ = int(_loc3_.length);
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc3_[_loc6_].data = _loc1_[_loc6_];
               _loc3_[_loc6_].tfSlotName.text = _loc1_[_loc6_].name;
               _loc3_[_loc6_].visible = true;
               _loc6_++;
            }
         }
      }
      
      private function populateSocketsData() : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc7_:SlotPaperdoll = null;
         var _loc1_:Array = _data.socketsData;
         var _loc2_:int = !!_data.socketsCount ? int(_data.socketsCount) : 0;
         var _loc3_:int = 0;
         this.mcRuneSlot1.visible = false;
         this.mcRuneSlot2.visible = false;
         this.mcRuneSlot3.visible = false;
         this.mcRuneSlot1.enabled = false;
         this.mcRuneSlot2.enabled = false;
         this.mcRuneSlot3.enabled = false;
         _loc2_ = Math.min(_loc2_,this.MAX_SOCKETS_COUNT);
         if(_loc1_)
         {
            _loc4_ = Math.min(_loc1_.length,this.MAX_SOCKETS_COUNT);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc6_ = _loc1_[_loc5_];
               if(_loc7_ = getChildByName("mcRuneSlot" + (_loc5_ + 1)) as SlotPaperdoll)
               {
                  _loc7_.visible = true;
                  _loc7_.enabled = true;
                  _loc7_.data = _loc6_;
                  _loc7_.tfSlotName.text = _loc6_.name;
                  _loc3_++;
               }
               _loc5_++;
            }
            switch(_loc3_)
            {
               case 1:
               case 2:
               case 3:
            }
         }
      }
   }
}
