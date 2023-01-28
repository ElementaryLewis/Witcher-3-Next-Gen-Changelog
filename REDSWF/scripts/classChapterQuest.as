package
{
   import flash.display.MovieClip;
   
   public dynamic class classChapterQuest extends MovieClip
   {
       
      
      public var mcQuestNormal:MovieClip;
      
      public function classChapterQuest()
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
