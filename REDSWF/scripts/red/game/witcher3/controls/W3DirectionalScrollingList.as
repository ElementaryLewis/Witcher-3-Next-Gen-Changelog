package red.game.witcher3.controls
{
   import red.game.witcher3.slots.SlotBase;
   import red.game.witcher3.slots.SlotsListPreset;
   
   public class W3DirectionalScrollingList extends SlotsListPreset
   {
       
      
      public function W3DirectionalScrollingList()
      {
         super();
      }
      
      override public function set focused(param1:Number) : void
      {
         super.focused = 1;
      }
      
      override public function SearchForNearestSelectableIndexInDirection(param1:String) : int
      {
         var _loc2_:Number = -1;
         var _loc3_:Number = -1;
         var _loc4_:Number = -1;
         var _loc5_:Number = -1;
         var _loc6_:SlotBase;
         if(!(_loc6_ = getSelectedRenderer() as SlotBase))
         {
            return -1;
         }
         var _loc7_:SlotBase = _loc6_;
         var _loc8_:SlotBase = null;
         var _loc9_:int = 0;
         while(_loc8_ == null && _loc7_ != null && _loc9_ != -1)
         {
            if((_loc9_ = _loc7_.GetNavigationIndex(param1)) != -1)
            {
               _loc7_ = _loc8_ = getRendererAt(_loc9_) as SlotBase;
            }
            if(Boolean(_loc8_) && !_loc8_.selectable)
            {
               _loc8_ = null;
            }
         }
         if(_loc8_ != null)
         {
            return _renderers.indexOf(_loc8_);
         }
         return super.SearchForNearestSelectableIndexInDirection(param1);
      }
   }
}
