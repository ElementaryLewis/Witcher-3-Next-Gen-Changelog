package
{
   import flash.display.MovieClip;
   
   public dynamic class MapPinRadius extends MovieClip
   {
       
      
      public var mcRadiusBelgard:MovieClip;
      
      public var mcRadiusCoronata:MovieClip;
      
      public var mcRadiusQuest:MovieClip;
      
      public var mcRadiusRegular:MovieClip;
      
      public var mcRadiusVermentino:MovieClip;
      
      public function MapPinRadius()
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
