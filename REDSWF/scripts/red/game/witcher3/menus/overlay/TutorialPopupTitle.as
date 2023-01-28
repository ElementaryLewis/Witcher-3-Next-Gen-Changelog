package red.game.witcher3.menus.overlay
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.core.UIComponent;
   
   public class TutorialPopupTitle extends UIComponent
   {
      
      protected static const TITLE_TEXTFIELD_PADDING:Number = 10;
       
      
      public var txtTitle:TextField;
      
      public var background:MovieClip;
      
      private var _minWidth:Number;
      
      protected var _text:String;
      
      public function TutorialPopupTitle()
      {
         super();
         this._minWidth = this.width;
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function set text(param1:String) : void
      {
         var _loc2_:Number = NaN;
         if(param1)
         {
            this._text = param1;
            this.txtTitle.htmlText = this._text;
            this.txtTitle.htmlText = CommonUtils.toUpperCaseSafe(this.txtTitle.htmlText);
            this.txtTitle.width = this.txtTitle.textWidth + CommonConstants.SAFE_TEXT_PADDING;
            _loc2_ = Math.max(TITLE_TEXTFIELD_PADDING + this.txtTitle.width,this._minWidth);
            this.background.width = _loc2_;
            this.txtTitle.x = (this.background.width - this.txtTitle.width) / 2;
            visible = true;
         }
         else
         {
            visible = false;
         }
      }
   }
}
