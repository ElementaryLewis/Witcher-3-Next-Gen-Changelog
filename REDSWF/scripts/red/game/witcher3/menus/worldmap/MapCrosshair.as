package red.game.witcher3.menus.worldmap
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Exponential;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import scaleform.clik.controls.Label;
   
   public class MapCrosshair extends MovieClip
   {
       
      
      private const LABEL_SNAP:String = "snap";
      
      private const LABEL_NORMAl:String = "normal";
      
      private const ANIM_DURATION:Number = 1;
      
      private const DESC_PADDING:Number = 60;
      
      private var _capturedState:Boolean;
      
      private var _label:String;
      
      public var mcDescription:Label;
      
      public function MapCrosshair()
      {
         super();
         this.mcDescription.visible = false;
      }
      
      public function get capturedState() : Boolean
      {
         return this._capturedState;
      }
      
      public function set capturedState(param1:Boolean) : void
      {
         this._capturedState = param1;
         gotoAndPlay(this._capturedState ? this.LABEL_SNAP : this.LABEL_NORMAl);
      }
      
      public function showLabel(param1:String, param2:Boolean = false) : void
      {
         this._label = param1;
         this.mcDescription.visible = true;
         this.mcDescription.htmlText = this._label;
         this.mcDescription.validateNow();
         var _loc3_:Sprite = this.mcDescription["background"] as Sprite;
         _loc3_.width = this.mcDescription.textField.textWidth + this.DESC_PADDING;
         if(param2)
         {
            this.mcDescription.alpha = 1;
         }
         else
         {
            this.mcDescription.alpha = 0;
            GTweener.removeTweens(this.mcDescription);
            GTweener.to(this.mcDescription,this.ANIM_DURATION,{"alpha":1},{"ease":Exponential.easeOut});
         }
      }
      
      public function hideLabel(param1:Boolean = false) : void
      {
         if(param1)
         {
            this.handleLabelHidden();
         }
         else
         {
            GTweener.removeTweens(this.mcDescription);
            GTweener.to(this.mcDescription,this.ANIM_DURATION,{"alpha":0},{
               "ease":Exponential.easeOut,
               "onComplete":this.handleLabelHidden
            });
         }
      }
      
      protected function handleLabelHidden(param1:GTween = null) : void
      {
         this.mcDescription.visible = false;
      }
   }
}
