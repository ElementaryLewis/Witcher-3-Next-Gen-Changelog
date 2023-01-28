package
{
   import flash.display.MovieClip;
   
   public dynamic class classEnchanter extends MovieClip
   {
       
      
      public function classEnchanter()
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
