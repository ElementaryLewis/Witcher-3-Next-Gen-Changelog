package red.game.witcher3.menus.worldmap
{
   import flash.display.MovieClip;
   import red.game.witcher3.controls.BaseListItem;
   
   public class UserPinItemRenderer extends BaseListItem
   {
       
      
      public var mcIcon:MovieClip;
      
      public function UserPinItemRenderer()
      {
         super();
      }
      
      override public function setData(param1:Object) : void
      {
         super.setData(param1);
         if(Boolean(this.mcIcon) && Boolean(param1))
         {
            this.mcIcon.gotoAndStop(param1.pinId);
         }
      }
   }
}
