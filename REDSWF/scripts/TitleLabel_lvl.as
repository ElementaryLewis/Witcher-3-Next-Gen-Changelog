package
{
   import red.game.witcher3.controls.W3Label;
   
   public dynamic class TitleLabel_lvl extends W3Label
   {
       
      
      public function TitleLabel_lvl()
      {
         super();
         addFrameScript(8,this.frame9,19,this.frame20);
      }
      
      internal function frame9() : *
      {
         stop();
      }
      
      internal function frame20() : *
      {
         stop();
      }
   }
}