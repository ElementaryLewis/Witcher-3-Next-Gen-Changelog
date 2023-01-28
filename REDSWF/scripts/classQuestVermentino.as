package
{
   import flash.display.MovieClip;
   
   public dynamic class classQuestVermentino extends MovieClip
   {
       
      
      public var mcQuestNormal:MovieClip;
      
      public function classQuestVermentino()
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
