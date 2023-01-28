package
{
   import red.game.witcher3.menus.character_menu.MutationConnector;
   
   public dynamic class mc_connector extends MutationConnector
   {
       
      
      public function mc_connector()
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
