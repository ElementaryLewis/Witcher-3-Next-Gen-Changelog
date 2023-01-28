package
{
   import flash.display.MovieClip;
   
   public dynamic class classQuestCoronata extends MovieClip
   {
       
      
      public var mcQuestNormal:MovieClip;
      
      public function classQuestCoronata()
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
