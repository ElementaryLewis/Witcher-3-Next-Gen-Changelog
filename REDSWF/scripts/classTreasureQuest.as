package
{
   import flash.display.MovieClip;
   
   public dynamic class classTreasureQuest extends MovieClip
   {
       
      
      public var mcQuestNormal:MovieClip;
      
      public function classTreasureQuest()
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
