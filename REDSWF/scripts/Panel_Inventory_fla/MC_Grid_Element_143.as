package Panel_Inventory_fla
{
   import flash.display.MovieClip;
   
   public dynamic class MC_Grid_Element_143 extends MovieClip
   {
       
      
      public function MC_Grid_Element_143()
      {
         super();
         addFrameScript(1,this.frame2,3,this.frame4,4,this.frame5);
      }
      
      internal function frame2() : *
      {
         stop();
      }
      
      internal function frame4() : *
      {
         gotoAndPlay("Overburdened");
      }
      
      internal function frame5() : *
      {
         stop();
      }
   }
}
