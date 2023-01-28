package red.game.witcher3.controls
{
   import flash.display.MovieClip;
   import flash.utils.getDefinitionByName;
   import scaleform.clik.controls.OptionStepper;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.interfaces.IDataProvider;
   
   public class W3OptionStepper extends OptionStepper
   {
       
      
      private var _hideIndicator:Boolean;
      
      private var _indicators:Vector.<MovieClip>;
      
      public function W3OptionStepper()
      {
         this._indicators = new Vector.<MovieClip>();
         _constraintsDisabled = true;
         this._hideIndicator = false;
         super();
      }
      
      public function get hideIndicator() : Boolean
      {
         return this._hideIndicator;
      }
      
      public function set hideIndicator(param1:Boolean) : void
      {
         this._hideIndicator = param1;
         this.rebuild(dataProvider);
         this.updateSelectedItem();
      }
      
      override public function set dataProvider(param1:IDataProvider) : void
      {
         this.rebuild(param1);
         super.dataProvider = param1;
      }
      
      override protected function updateSelectedItem() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = (_dataProvider as DataProvider).length;
         _loc1_ = 0;
         while(_loc1_ < this._indicators.length)
         {
            this._indicators[_loc1_].visible = false;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < _loc2_ && this._indicators.length != 0)
         {
            this._indicators[_loc1_].visible = true;
            this._indicators[_loc1_].gotoAndStop("inactive");
            _loc1_++;
         }
         if(_selectedIndex < this._indicators.length && _selectedIndex >= 0)
         {
            this._indicators[selectedIndex].gotoAndStop("active");
         }
         if(_selectedIndex == 0)
         {
            prevBtn.enabled = false;
            nextBtn.enabled = true;
         }
         else if(_selectedIndex == (dataProvider as DataProvider).length - 1)
         {
            prevBtn.enabled = true;
            nextBtn.enabled = false;
         }
         else
         {
            prevBtn.enabled = true;
            nextBtn.enabled = true;
         }
         super.updateSelectedItem();
      }
      
      private function rebuild(param1:IDataProvider) : void
      {
         var _loc2_:uint = 0;
         var _loc4_:MovieClip = null;
         var _loc3_:Class = getDefinitionByName("StepperIndicator") as Class;
         var _loc5_:uint = (param1 as DataProvider).length;
         var _loc6_:uint = 140;
         var _loc7_:uint = 5;
         var _loc8_:uint = 5;
         if(_loc5_ > _loc8_ || this._hideIndicator)
         {
            _loc2_ = 0;
            while(_loc2_ < this._indicators.length)
            {
               removeChild(this._indicators[_loc2_]);
               _loc2_++;
            }
            this._indicators.length = 0;
         }
         else
         {
            _loc2_ = this._indicators.length;
            while(_loc2_ < _loc5_)
            {
               _loc4_ = new _loc3_() as MovieClip;
               addChild(_loc4_);
               this._indicators.push(_loc4_);
               _loc2_++;
            }
            _loc2_ = 0;
            while(_loc2_ < _loc5_ && this._indicators.length != 0)
            {
               this._indicators[_loc2_].x = _loc6_;
               this._indicators[_loc2_].y = -14;
               _loc6_ += this._indicators[_loc2_].width + _loc7_;
               _loc2_++;
            }
         }
         nextBtn.x = _loc6_ + nextBtn.width;
         this.width = nextBtn.x + nextBtn.width;
      }
   }
}
