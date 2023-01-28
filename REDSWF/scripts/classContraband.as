package
{
   import flash.display.MovieClip;
   
   public dynamic class classContraband extends MovieClip
   {
       
      
      public function classContraband()
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
