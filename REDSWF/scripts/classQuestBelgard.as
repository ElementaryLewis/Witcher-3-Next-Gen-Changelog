package
{
   import flash.display.MovieClip;
   
   public dynamic class classQuestBelgard extends MovieClip
   {
       
      
      public var mcQuestNormal:MovieClip;
      
      public function classQuestBelgard()
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
