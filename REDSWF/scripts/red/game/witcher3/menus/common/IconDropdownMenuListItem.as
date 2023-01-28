package red.game.witcher3.menus.common
{
   import red.game.witcher3.controls.W3UILoader;
   
   public class IconDropdownMenuListItem extends FeedbackDropdownMenuListItem
   {
       
      
      public var mcIconLoader:W3UILoader;
      
      public function IconDropdownMenuListItem()
      {
         super();
         if(this.mcIconLoader)
         {
            this.mcIconLoader.fallbackIconPath = "icons/monsters/ICO_MonsterDefault.png";
         }
      }
      
      override protected function configUI() : void
      {
         super.configUI();
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc2_:Array = null;
         super.setData(param1);
         if(param1)
         {
            _loc2_ = param1 as Array;
            if(_loc2_)
            {
               if(Boolean(_loc2_[0].dropDownIcon) && Boolean(this.mcIconLoader))
               {
                  this.mcIconLoader.source = "img://" + _loc2_[0].dropDownIcon;
               }
            }
         }
      }
   }
}
