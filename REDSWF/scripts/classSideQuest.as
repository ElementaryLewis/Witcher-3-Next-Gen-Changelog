package
{
   import flash.display.MovieClip;
   
   public dynamic class classSideQuest extends MovieClip
   {
       
      
      public var mcQuestNormal:MovieClip;
      
      public function classSideQuest()
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
