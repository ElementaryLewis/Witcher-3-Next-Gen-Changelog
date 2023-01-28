package
{
   import flash.display.MovieClip;
   
   public dynamic class classStoryQuest extends MovieClip
   {
       
      
      public var mcQuestNormal:MovieClip;
      
      public function classStoryQuest()
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
