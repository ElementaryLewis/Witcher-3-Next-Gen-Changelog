package red.game.witcher3.menus.worldmap
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Exponential;
   import red.game.witcher3.events.MapAnimation;
   import scaleform.clik.core.UIComponent;
   
   public class BaseMap extends UIComponent
   {
       
      
      protected var _enabled:Boolean = false;
      
      protected var _transitionTween:GTween;
      
      protected var _defaultScale:Number = 1;
      
      protected const UNIVERSE_MAP_ZOOM = 0.9;
      
      public function BaseMap()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
      }
      
      public function CanProcessInput() : Boolean
      {
         return false;
      }
      
      public function Enable(param1:Boolean, param2:Boolean = false) : *
      {
         if(this._enabled == param1)
         {
            if(!param2)
            {
               return;
            }
         }
         this._enabled = param1;
         if(this._enabled)
         {
            this.showMap();
         }
         else
         {
            this.hideMap();
         }
      }
      
      protected function showMap(param1:Boolean = true) : void
      {
         GTweener.removeTweens(this);
         if(param1)
         {
            alpha = 0;
            scaleX = scaleY = 2;
            visible = true;
            GTweener.removeTweens(this);
            this._transitionTween = GTweener.to(this,1,{
               "scaleX":this.UNIVERSE_MAP_ZOOM,
               "scaleY":this.UNIVERSE_MAP_ZOOM,
               "alpha":1
            },{
               "ease":Exponential.easeOut,
               "onComplete":this.handleShowAnim
            });
         }
         else
         {
            this.handleShowAnim();
         }
      }
      
      protected function hideMap(param1:Boolean = true) : void
      {
         GTweener.removeTweens(this);
         if(param1)
         {
            visible = true;
            GTweener.removeTweens(this);
            this._transitionTween = GTweener.to(this,1,{
               "scaleX":2,
               "scaleY":2,
               "alpha":0
            },{
               "ease":Exponential.easeOut,
               "onComplete":this.handleHideAnim
            });
         }
         else
         {
            this.handleHideAnim();
         }
      }
      
      protected function handleShowAnim(param1:GTween = null) : void
      {
         visible = true;
         alpha = 1;
         scaleX = scaleY = this.UNIVERSE_MAP_ZOOM;
         this._transitionTween = null;
         dispatchEvent(new MapAnimation(MapAnimation.COMPLETE_SHOW,true));
      }
      
      protected function handleHideAnim(param1:GTween = null) : void
      {
         visible = false;
         this._transitionTween = null;
         dispatchEvent(new MapAnimation(MapAnimation.COMPLETE_HIDE,true));
      }
      
      public function OnControllerChanged(param1:Boolean) : *
      {
      }
      
      public function IsEnabled() : Boolean
      {
         return this._enabled;
      }
      
      override public function get scaleX() : Number
      {
         return super.actualScaleX;
      }
      
      override public function get scaleY() : Number
      {
         return super.actualScaleY;
      }
   }
}
