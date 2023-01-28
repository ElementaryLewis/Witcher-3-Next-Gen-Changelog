package red.game.witcher3.menus.mainmenu
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.game.witcher3.controls.BaseListItem;
   import scaleform.clik.controls.UILoader;
   
   public class W3AchievementListItemRenderer extends BaseListItem
   {
       
      
      public var tfCurrentValue:TextField;
      
      public var tfDescription:TextField;
      
      public var mcIconLoader:UILoader;
      
      public var mcHitArea:MovieClip;
      
      private var _currentValue:String = "";
      
      private var _IconName:String = "";
      
      public function W3AchievementListItemRenderer()
      {
         super();
         preventAutosizing = true;
         mouseChildren = mouseEnabled = true;
         hitArea = this.mcHitArea;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
      }
      
      override public function setData(param1:Object) : void
      {
         super.setData(param1);
         if(!param1)
         {
            return;
         }
         label = param1.label;
         this._currentValue = param1.current as String;
         if(!this._currentValue)
         {
            if(param1.current)
            {
               this._currentValue = param1.current.toString();
            }
         }
         this.tfDescription.htmlText = param1.description as String;
         this._IconName = param1.iconPath as String;
         this.updateIcon();
      }
      
      private function updateIcon() : void
      {
         if(Boolean(this._IconName) && this._IconName != "")
         {
            this.mcIconLoader.source = "img://" + this._IconName;
         }
      }
      
      override protected function updateText() : void
      {
         super.updateText();
         this.updateCurrentValue();
      }
      
      protected function updateCurrentValue() : void
      {
         this.tfCurrentValue.htmlText = this._currentValue;
      }
      
      override protected function updateAfterStateChange() : void
      {
      }
   }
}
