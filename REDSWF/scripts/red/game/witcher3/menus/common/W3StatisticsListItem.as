package red.game.witcher3.menus.common
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.game.witcher3.controls.BaseListItem;
   
   public class W3StatisticsListItem extends BaseListItem
   {
       
      
      public var tfStatValue:TextField;
      
      protected var _statValue:String = "";
      
      private var _id:uint;
      
      public var mcStatInfo:MovieClip;
      
      protected var _statID:String = "";
      
      public function W3StatisticsListItem()
      {
         super();
         preventAutosizing = true;
         constraintsDisabled = true;
      }
      
      public function get statID() : String
      {
         return this._statID;
      }
      
      public function set statID(param1:String) : void
      {
         this._statID = param1;
      }
      
      override protected function configUI() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:TextField = null;
         if(this.mcStatInfo)
         {
            _loc1_ = this.mcStatInfo.getChildByName("txfStats") as MovieClip;
            if(_loc1_)
            {
               _loc2_ = _loc1_.getChildByName("textField") as TextField;
               if(_loc2_)
               {
                  textField = _loc2_;
               }
               _loc2_ = _loc1_.getChildByName("tfStatValue") as TextField;
               if(_loc2_)
               {
                  this.tfStatValue = _loc2_;
               }
            }
         }
         super.configUI();
      }
      
      override public function setData(param1:Object) : void
      {
         super.setData(param1);
         if(!param1)
         {
            return;
         }
         label = param1.name;
         this._statValue = param1.value as String;
         this._id = param1.id;
         this.tfStatValue.htmlText = this._statValue;
         if(Boolean(this.mcStatInfo) && param1.changedValue == true)
         {
            this.mcStatInfo.gotoAndPlay("Changed");
         }
      }
      
      override protected function updateText() : void
      {
         super.updateText();
         this.tfStatValue.htmlText = this._statValue;
      }
      
      protected function updateHighlightScale() : *
      {
         var _loc1_:MovieClip = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this.mcStatInfo && this.tfStatValue && Boolean(textField))
         {
            _loc1_ = this.mcStatInfo.getChildByName("mcChangedHighlight") as MovieClip;
            if(_loc1_)
            {
               _loc2_ = this.tfStatValue.x + this.tfStatValue.width - this.tfStatValue.textWidth;
               _loc3_ = textField.x + textField.textWidth;
               _loc2_ += this.mcStatInfo.x;
               _loc3_ += this.mcStatInfo.x;
               _loc1_.width = Math.abs(_loc3_ - _loc2_);
               _loc1_.x = _loc2_ + _loc1_.width / 2;
            }
         }
      }
      
      override protected function updateAfterStateChange() : void
      {
         if(!this.tfStatValue)
         {
         }
      }
      
      public function GetId() : int
      {
         return this._id;
      }
   }
}
