package red.game.witcher3.menus.common_menu
{
   import scaleform.clik.core.UIComponent;
   
   public class ItemsHistory extends UIComponent
   {
       
      
      public var mcItemInfo1:NewItemInfo;
      
      public var mcItemInfo2:NewItemInfo;
      
      public var mcItemInfo3:NewItemInfo;
      
      public function ItemsHistory()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.mcItemInfo1.visible = false;
         this.mcItemInfo1.visible = false;
         this.mcItemInfo1.visible = false;
      }
      
      public function handleDataSet(param1:Object, param2:int) : void
      {
         var _loc4_:NewItemInfo = null;
         var _loc3_:Array = param1 as Array;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.length)
         {
            (_loc4_ = this.GetItemInfoById(_loc5_)).SetItemIcon(_loc3_[_loc5_].iconName);
            _loc4_.SetItemName(_loc3_[_loc5_].itemName);
            _loc4_.SetItemType(_loc3_[_loc5_].category);
            _loc4_.visible = true;
            _loc5_++;
         }
         _loc5_ = int(_loc3_.length);
         while(_loc5_ < 3)
         {
            (_loc4_ = this.GetItemInfoById(_loc5_)).visible = false;
            _loc5_++;
         }
      }
      
      public function GetItemInfoById(param1:int) : NewItemInfo
      {
         if(param1 == 0)
         {
            return this.mcItemInfo1;
         }
         if(param1 == 1)
         {
            return this.mcItemInfo2;
         }
         if(param1 == 2)
         {
            return this.mcItemInfo3;
         }
         return null;
      }
      
      public function IsAnyItemToDisplay() : Boolean
      {
         return this.mcItemInfo1.visible || this.mcItemInfo2.visible || this.mcItemInfo3.visible;
      }
   }
}
