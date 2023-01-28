package red.game.witcher3.menus.meditation_menu
{
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Sine;
   import flash.display.Sprite;
   import scaleform.clik.core.UIComponent;
   
   public class DayQuarterIndicator extends UIComponent
   {
       
      
      public var fxIconN:Sprite;
      
      public var fxIconE:Sprite;
      
      public var fxIconS:Sprite;
      
      public var fxIconW:Sprite;
      
      protected var _currentTime:Number;
      
      protected var _selectedSprite:Sprite;
      
      public function DayQuarterIndicator()
      {
         super();
         this.fxIconN.alpha = 0;
         this.fxIconE.alpha = 0;
         this.fxIconS.alpha = 0;
         this.fxIconW.alpha = 0;
      }
      
      public function get currentTime() : Number
      {
         return this._currentTime;
      }
      
      public function set currentTime(param1:Number) : void
      {
         var _loc2_:Sprite = null;
         this._currentTime = param1;
         if(this._currentTime > 21 || this._currentTime <= 3)
         {
            _loc2_ = this.fxIconS;
         }
         else if(this._currentTime > 3 && this._currentTime <= 9)
         {
            _loc2_ = this.fxIconW;
         }
         else if(this._currentTime > 9 && this._currentTime <= 15)
         {
            _loc2_ = this.fxIconN;
         }
         else if(this._currentTime > 15 && this._currentTime < 21)
         {
            _loc2_ = this.fxIconE;
         }
         if(_loc2_ != this._selectedSprite)
         {
            if(this._selectedSprite)
            {
               GTweener.removeTweens(this._selectedSprite);
               GTweener.to(this._selectedSprite,1.5,{"alpha":0},{"ease":Sine.easeIn});
            }
            this._selectedSprite = _loc2_;
            GTweener.removeTweens(this._selectedSprite);
            GTweener.to(this._selectedSprite,1.5,{"alpha":1},{"ease":Sine.easeOut});
         }
      }
   }
}
