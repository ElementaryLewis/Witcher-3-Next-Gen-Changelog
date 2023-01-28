package
{
   import red.game.witcher3.menus.journal.QuestListModule;
   
   public dynamic class MC_MODULE_QuestList extends QuestListModule
   {
       
      
      public function MC_MODULE_QuestList()
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
