package Panel_Inventory_fla
{
   import flash.display.MovieClip;
   
   public dynamic class PlayerStatInfo_ico_animation_51 extends MovieClip
   {
       
      
      public var mcIcon:MovieClip;
      
      public function PlayerStatInfo_ico_animation_51()
      {
         super();
         addFrameScript(0,this.frame1,15,this.frame16);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame16() : *
      {
         gotoAndPlay("start");
      }
   }
}
