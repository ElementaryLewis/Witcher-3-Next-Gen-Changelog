package red.game.witcher3.menus.loading
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Quadratic;
   import red.core.overlay.LoadingScreen;
   
   public class LoadingMenu extends LoadingScreen
   {
      
      private static const SLIDE_ANIM_TIME:Number = 30;
       
      
      public function LoadingMenu()
      {
         addFrameScript(0,this.frame1);
         super();
      }
      
      override protected function registerLoadingScreen() : void
      {
         super.registerLoadingScreen();
         if(mcImage)
         {
            this.onStartRightTween();
         }
      }
      
      protected function onStartRightTween(param1:GTween = null) : void
      {
         GTweener.removeTweens(mcImage);
         mcImage.x = -740;
         GTweener.to(mcImage,SLIDE_ANIM_TIME,{"x":-320},{
            "ease":Quadratic.easeInOut,
            "onComplete":this.onStartLeftTween
         });
      }
      
      private function onStartLeftTween(param1:GTween) : void
      {
         GTweener.removeTweens(mcImage);
         mcImage.x = -320;
         GTweener.to(mcImage,SLIDE_ANIM_TIME,{"x":-740},{
            "ease":Quadratic.easeInOut,
            "onComplete":this.onStartRightTween
         });
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
