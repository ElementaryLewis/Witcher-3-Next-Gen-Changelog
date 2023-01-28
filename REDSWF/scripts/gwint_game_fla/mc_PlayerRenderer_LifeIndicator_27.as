package gwint_game_fla
{
   import flash.display.MovieClip;
   
   public dynamic class mc_PlayerRenderer_LifeIndicator_27 extends MovieClip
   {
       
      
      public var mcLifeGemAnim1:MovieClip;
      
      public var mcLifeGemAnim2:MovieClip;
      
      public function mc_PlayerRenderer_LifeIndicator_27()
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
