package red.game.witcher3.controls
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import flash.display.MovieClip;
   import scaleform.clik.core.UIComponent;
   
   public class W3Background extends UIComponent
   {
       
      
      public var mcFogEffect1:MovieClip;
      
      public var mcFogEffect2:MovieClip;
      
      protected var _fogStartX:int = 2147483647;
      
      protected var _fogEndX:int = 2147483647;
      
      protected var _forceVisible:Boolean = false;
      
      protected var _backgroundVisible:Boolean = true;
      
      protected var _lastVisiblityApplied:Boolean = false;
      
      public function W3Background()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.startBackgroundFogTween();
      }
      
      public function forceHide() : void
      {
         this._backgroundVisible = false;
         alpha = 0;
         visible = false;
      }
      
      protected function handleBackgroundFogTweener1Complete(param1:GTween) : void
      {
         if(this.mcFogEffect1)
         {
            GTweener.removeTweens(this.mcFogEffect1);
            this.mcFogEffect1.x = this._fogStartX;
            GTweener.to(this.mcFogEffect1,60,{"x":this._fogEndX},{"onComplete":this.handleBackgroundFogTweener1Complete});
         }
      }
      
      protected function handleBackgroundFogTweener2Complete(param1:GTween) : void
      {
         if(this.mcFogEffect2)
         {
            GTweener.removeTweens(this.mcFogEffect2);
            this.mcFogEffect2.x = this._fogEndX;
            GTweener.to(this.mcFogEffect2,100,{"x":this._fogStartX},{"onComplete":this.handleBackgroundFogTweener1Complete});
         }
      }
      
      protected function startBackgroundFogTween() : void
      {
         if(Boolean(this.mcFogEffect1) && Boolean(this.mcFogEffect2))
         {
            if(this._fogStartX == int.MAX_VALUE)
            {
               this._fogStartX = this.mcFogEffect1.x;
            }
            if(this._fogEndX == int.MAX_VALUE)
            {
               this._fogEndX = this.mcFogEffect2.x;
            }
            this.mcFogEffect1.x = this._fogStartX;
            this.mcFogEffect1.alpha = 0.8;
            GTweener.to(this.mcFogEffect1,60,{"x":this._fogEndX},{"onComplete":this.handleBackgroundFogTweener1Complete});
            this.mcFogEffect2.x = this._fogEndX;
            GTweener.to(this.mcFogEffect2,100,{"x":this._fogStartX},{"onComplete":this.handleBackgroundFogTweener2Complete});
         }
      }
      
      public function set backgroundForceVisible(param1:Boolean) : void
      {
         if(this._forceVisible != param1)
         {
            this._forceVisible = param1;
            if(this._forceVisible)
            {
               this.applyVisibility(true);
            }
            else
            {
               this.applyVisibility(this._backgroundVisible);
            }
         }
      }
      
      public function set backgroundVisible(param1:Boolean) : void
      {
         if(param1 != this._backgroundVisible)
         {
            this._backgroundVisible = param1;
            GTweener.removeTweens(this);
            if(!this._forceVisible)
            {
               this.applyVisibility(param1);
            }
         }
      }
      
      protected function applyVisibility(param1:Boolean) : void
      {
         if(this._lastVisiblityApplied != param1)
         {
            this._lastVisiblityApplied = param1;
            if(param1)
            {
               visible = true;
               GTweener.to(this,0.2,{"alpha":1},{});
            }
            else
            {
               GTweener.to(this,0.2,{"alpha":0},{"onComplete":this.handleBackgroundHideComplete});
            }
         }
      }
      
      protected function handleBackgroundHideComplete(param1:GTween) : void
      {
         visible = false;
      }
   }
}
