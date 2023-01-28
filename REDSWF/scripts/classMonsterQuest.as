package
{
   import flash.display.MovieClip;
   
   public dynamic class classMonsterQuest extends MovieClip
   {
       
      
      public var mcQuestNormal:MovieClip;
      
      public function classMonsterQuest()
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
