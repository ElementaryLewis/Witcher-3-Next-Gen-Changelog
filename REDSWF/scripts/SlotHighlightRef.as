package
{
   import flash.display.MovieClip;
   
   public dynamic class SlotHighlightRef extends MovieClip
   {
       
      
      public function SlotHighlightRef()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         stop();
      }
   }
}
