package
{
   import flash.display.MovieClip;
   
   public dynamic class SlotSocketRef extends MovieClip
   {
       
      
      public function SlotSocketRef()
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
