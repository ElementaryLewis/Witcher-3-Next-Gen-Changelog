package red.game.witcher3.slots
{
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   
   public class SlotsListSkillSockets extends SlotsListPreset
   {
       
      
      private var _slotContainer:MovieClip;
      
      public function SlotsListSkillSockets()
      {
         super();
      }
      
      override protected function initRenderers() : void
      {
         super.initRenderers();
      }
      
      override protected function populateData() : void
      {
         var _loc3_:Object = null;
         var _loc4_:SlotSkillSocket = null;
         super.populateData();
         if(!_renderers || !_renderers.length)
         {
            return;
         }
         var _loc1_:int = int(_data.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = _data[_loc2_];
            if(_loc4_ = this.getRendererById(_loc3_.slotId))
            {
               _loc3_.gridSize = 1;
               _loc4_.data = _loc3_;
            }
            _loc2_++;
         }
      }
      
      override protected function cleanupRenderers() : void
      {
         var _loc3_:SlotSkillSocket = null;
         var _loc1_:int = int(_renderers.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = _renderers[_loc2_] as SlotSkillSocket;
            if(_loc3_)
            {
               _loc3_.cleanup();
            }
            _loc2_++;
         }
      }
      
      public function hasSkillWithType(param1:int) : Boolean
      {
         var _loc4_:SlotSkillSocket = null;
         var _loc2_:int = int(_renderers.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if((_loc4_ = _renderers[_loc3_] as SlotSkillSocket) && _loc4_.data && _loc4_.data.skillType == param1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      protected function getRendererById(param1:int) : SlotSkillSocket
      {
         var _loc3_:SlotSkillSocket = null;
         var _loc2_:int = int(_renderers.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = _renderers[_loc4_] as SlotSkillSocket;
            if(Boolean(_loc3_) && _loc3_.slotId == param1)
            {
               return _loc3_;
            }
            _loc4_++;
         }
         return null;
      }
      
      public function updateSpecificData(param1:Object) : void
      {
         var _loc2_:SlotSkillSocket = this.getRendererById(param1.slotId);
         if(_loc2_)
         {
            param1.gridSize = 1;
            _loc2_.data = param1;
         }
      }
      
      public function clearSkillSlot(param1:int) : void
      {
         var _loc2_:Object = null;
         var _loc3_:SlotSkillSocket = this.getRendererById(param1);
         if(Boolean(_loc3_) && _loc3_.data)
         {
            _loc2_ = _loc3_.data;
            _loc2_.id = 0;
            _loc2_.skillTypeId = 0;
            _loc2_.skillType = 0;
            _loc2_.skillPath = SlotSkillSocket.NULL_SKILL;
            _loc2_.maxLevel = 0;
            _loc2_.iconPath = "";
            _loc2_.color = 0;
            _loc2_.isEquipped = false;
            _loc3_.data = _loc2_;
         }
      }
      
      public function get slotContainer() : MovieClip
      {
         return this._slotContainer;
      }
      
      public function set slotContainer(param1:MovieClip) : void
      {
         if(this._slotContainer != param1 && param1 != null)
         {
            this._slotContainer = param1;
            this.initRenderers();
            this.populateData();
         }
      }
      
      override protected function getSlotsContainer() : DisplayObjectContainer
      {
         return this._slotContainer;
      }
      
      override public function toString() : String
      {
         return "SlotsListSkillSockets [" + this.name + "]";
      }
   }
}
