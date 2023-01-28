package red.game.witcher3.menus.common_menu
{
   import scaleform.clik.core.UIComponent;
   
   public class TextInfoContainer extends UIComponent
   {
       
      
      public var mcTextInfoItem1:TextInfoItem;
      
      public var mcTextInfoItem2:TextInfoItem;
      
      public var mcTextInfoItem3:TextInfoItem;
      
      public function TextInfoContainer()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.mcTextInfoItem1.visible = false;
         this.mcTextInfoItem2.visible = false;
         this.mcTextInfoItem3.visible = false;
      }
      
      public function handleDataSet(param1:Object, param2:int) : void
      {
         var _loc4_:TextInfoItem = null;
         var _loc3_:Array = param1 as Array;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.length)
         {
            (_loc4_ = this.GetTextInfoById(_loc5_)).SetEntryTopText(_loc3_[_loc5_].topText);
            _loc4_.SetEntryBottomText(_loc3_[_loc5_].bottomText);
            _loc4_.visible = true;
            _loc5_++;
         }
         _loc5_ = int(_loc3_.length);
         while(_loc5_ < 3)
         {
            (_loc4_ = this.GetTextInfoById(_loc5_)).visible = false;
            _loc5_++;
         }
      }
      
      public function GetTextInfoById(param1:int) : TextInfoItem
      {
         if(param1 == 0)
         {
            return this.mcTextInfoItem1;
         }
         if(param1 == 1)
         {
            return this.mcTextInfoItem2;
         }
         if(param1 == 2)
         {
            return this.mcTextInfoItem3;
         }
         return null;
      }
      
      public function IsAnyItemToDisplay() : Boolean
      {
         return this.mcTextInfoItem1.visible || this.mcTextInfoItem2.visible || this.mcTextInfoItem3.visible;
      }
   }
}
