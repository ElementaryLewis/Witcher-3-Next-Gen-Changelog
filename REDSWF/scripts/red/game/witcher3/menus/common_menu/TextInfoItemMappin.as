package red.game.witcher3.menus.common_menu
{
   import flash.display.MovieClip;
   
   public class TextInfoItemMappin extends TextInfoItem
   {
       
      
      public var mcMappinIco:MovieClip;
      
      internal var iconPath:String;
      
      public function TextInfoItemMappin()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
      }
      
      public function SetEntryType(param1:String) : void
      {
         this.iconPath = param1;
         if(this.mcMappinIco)
         {
            this.mcMappinIco.gotoAndStop(param1);
         }
      }
   }
}
