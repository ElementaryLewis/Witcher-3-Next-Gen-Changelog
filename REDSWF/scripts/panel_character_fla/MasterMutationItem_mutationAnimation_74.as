package panel_character_fla
{
   import flash.display.MovieClip;
   
   public dynamic class MasterMutationItem_mutationAnimation_74 extends MovieClip
   {
       
      
      public var mcAnimation:MovieClip;
      
      public function MasterMutationItem_mutationAnimation_74()
      {
         super();
         addFrameScript(6,this.frame7,15,this.frame16,24,this.frame25,35,this.frame36,43,this.frame44);
      }
      
      internal function frame7() : *
      {
         stop();
      }
      
      internal function frame16() : *
      {
         gotoAndPlay("state1");
      }
      
      internal function frame25() : *
      {
         gotoAndPlay("state2");
      }
      
      internal function frame36() : *
      {
         gotoAndPlay("state3");
      }
      
      internal function frame44() : *
      {
         gotoAndPlay("state4");
      }
   }
}
