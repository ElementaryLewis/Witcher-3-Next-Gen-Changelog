package
{
   import flash.display.MovieClip;
   
   public dynamic class classMonsterNestDisabled extends MovieClip
   {
       
      
      public function classMonsterNestDisabled()
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
