package red.game.witcher3.menus.journal
{
   import red.game.witcher3.controls.BaseListItem;
   import red.game.witcher3.controls.W3DropDownList;
   import red.game.witcher3.controls.W3DropdownMenuListItem;
   
   public class QuestDropDownList extends W3DropDownList
   {
       
      
      public function QuestDropDownList()
      {
         super();
      }
      
      override public function SetInitialSelection() : *
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:W3DropdownMenuListItem = null;
         var _loc5_:BaseListItem = null;
         _loc3_ = false;
         _loc1_ = 0;
         while(_loc1_ < dataProvider.length)
         {
            if(_loc4_ = getRendererAt(_loc1_) as W3DropdownMenuListItem)
            {
               if(_loc4_.HasInitialSelection() && !_loc3_)
               {
                  _loc4_.open(false);
                  selectedIndex = _loc1_;
                  _loc3_ = true;
                  _loc4_.SelectSubListItem(0);
               }
               else if(_loc4_.IsOpenedByDefault())
               {
                  _loc4_.open(false);
               }
            }
            _loc1_++;
         }
      }
   }
}
