package
{
   import red.game.witcher3.menus.common_menu.TextInfoContainerMap;
   
   public dynamic class TextInfoContainerMap extends red.game.witcher3.menus.common_menu.TextInfoContainerMap
   {
       
      
      public function TextInfoContainerMap()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
