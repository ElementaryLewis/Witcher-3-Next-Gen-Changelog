package red.game.witcher3.controls
{
   import fl.transitions.easing.Strong;
   import flash.display.MovieClip;
   import red.game.witcher3.utils.motion.TweenEx;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class W3GamepadButton extends GamepadButton
   {
      
      private static const ICON_GROW_DURATION = 200;
       
      
      public var mcIcon:MovieClip;
      
      public var index:int = -1;
      
      public function W3GamepadButton()
      {
         super();
      }
      
      override public function set navigationCode(param1:String) : void
      {
         var _loc2_:MovieClip = null;
         super.navigationCode = param1;
         if(this.mcIcon)
         {
            this.mcIcon.gotoAndStop(param1);
            if(this.mcIcon.getChildByName("mcIconText") != null)
            {
               _loc2_ = MovieClip(this.mcIcon.getChildByName("mcIconText"));
               _loc2_.gotoAndStop(param1);
            }
            invalidateData();
         }
      }
      
      override public function set label(param1:String) : void
      {
         if(_label == param1)
         {
            return;
         }
         _label = param1;
         this.updateText();
      }
      
      override protected function updateText() : void
      {
         if(_label != null && textField != null)
         {
            textField.text = _label;
         }
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc2_:InputDetails = null;
         if(enabled)
         {
            _loc2_ = param1.details;
            if(_loc2_.navEquivalent == navigationCode)
            {
               if(_loc2_.value == InputValue.KEY_DOWN)
               {
                  TweenEx.pauseTweenOn(this.mcIcon);
                  TweenEx.to(ICON_GROW_DURATION,this.mcIcon,{
                     "scaleX":0.8,
                     "scaleY":0.8
                  },{
                     "paused":false,
                     "ease":Strong.easeOut
                  });
               }
               else if(_loc2_.value == InputValue.KEY_UP)
               {
                  TweenEx.pauseTweenOn(this.mcIcon);
                  TweenEx.to(ICON_GROW_DURATION,this.mcIcon,{
                     "scaleX":1,
                     "scaleY":1
                  },{
                     "paused":false,
                     "ease":Strong.easeOut
                  });
               }
               super.handleInput(param1);
            }
         }
      }
      
      override protected function updateAfterStateChange() : void
      {
         super.updateAfterStateChange();
      }
      
      public function setStateExternal(param1:String) : void
      {
         setState(param1);
      }
   }
}
