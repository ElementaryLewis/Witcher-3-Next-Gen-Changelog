package red.game.witcher3.controls
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class KeyboardButtonIcon extends MovieClip
   {
      
      protected static const TEXT_OFFSET:Number = 5;
      
      protected static const MIN_SIZE:Number = 42;
      
      protected static const POS_LEFT_X:Number = 5;
      
      protected static const POS_LEFT_X_BIG:Number = 10;
       
      
      public var mcBackground:Sprite;
      
      public var textField:TextField;
      
      protected var _label:String;
      
      protected var _backgroundVisibility:Boolean;
      
      public function KeyboardButtonIcon()
      {
         super();
      }
      
      public function get label() : String
      {
         return this._label;
      }
      
      public function set label(param1:String) : void
      {
         this._label = param1;
         this.textField.text = this._label;
         var _loc2_:Number = this.textField.textWidth + TEXT_OFFSET;
         this.textField.width = _loc2_;
         if(POS_LEFT_X_BIG + _loc2_ > MIN_SIZE)
         {
            this.mcBackground.width = _loc2_ + POS_LEFT_X_BIG;
            this.textField.x = POS_LEFT_X;
         }
         else
         {
            this.mcBackground.width = MIN_SIZE;
            this.textField.x = (this.mcBackground.width - _loc2_) / 2;
         }
      }
      
      public function get backgroundVisibility() : Boolean
      {
         return this._backgroundVisibility;
      }
      
      public function set backgroundVisibility(param1:Boolean) : void
      {
         this._backgroundVisibility = param1;
         this.mcBackground.visible = this._backgroundVisibility;
      }
   }
}
