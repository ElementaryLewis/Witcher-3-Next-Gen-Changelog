package
{
   import flash.display.MovieClip;
   
   public dynamic class MapPinIco extends MovieClip
   {
       
      
      public var mcPinIcon:MovieClip;
      
      public var mcPingAnimation:MovieClip;
      
      public var mcPinGlow:PinGlow;
      
      public var mcPinRadius:MovieClip;
      
      public function MapPinIco()
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
