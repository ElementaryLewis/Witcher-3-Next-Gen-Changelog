package
{
   import red.game.witcher3.menus.character_menu.SkillSlotConnector;
   
   public dynamic class ConnectorLineRef extends SkillSlotConnector
   {
       
      
      public function ConnectorLineRef()
      {
         super();
         addFrameScript(0,this.frame1,5,this.frame6);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame6() : *
      {
         stop();
      }
   }
}
