package red.game.witcher3.menus.mainmenu
{
   import red.game.witcher3.controls.BaseListItem;
   
   public class InstalledDLCMItemRenderer extends BaseListItem
   {
       
      
      public function InstalledDLCMItemRenderer()
      {
         super();
      }
      
      override public function setData(param1:Object) : void
      {
         super.setData(param1);
      }
      
      public function getDLCDescription() : String
      {
         if(data)
         {
            return data.desc;
         }
         return "";
      }
   }
}
