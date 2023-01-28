package
{
   import red.game.witcher3.menus.character_menu.SkillSlotConnector;
   
   public dynamic class SkillSlotConnectorRef extends SkillSlotConnector
   {
       
      
      public function SkillSlotConnectorRef()
      {
         super();
         addFrameScript(0,this.frame1,14,this.frame15);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame15() : *
      {
         stop();
      }
   }
}
