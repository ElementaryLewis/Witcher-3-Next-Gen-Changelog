package red.game.witcher3.menus.character_menu
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.core.CoreComponent;
   import red.game.witcher3.constants.CommonConstants;
   import scaleform.clik.core.UIComponent;
   
   public class MutationMasterRequirements extends UIComponent
   {
       
      
      private const LIST_PADDING:Number = 10;
      
      public var mcBackground:MovieClip;
      
      public var mcLockIcon:MovieClip;
      
      public var tfText:TextField;
      
      private var _text:String;
      
      public function MutationMasterRequirements()
      {
         super();
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function set text(param1:String) : void
      {
         this._text = param1;
         if(CoreComponent.isArabicAligmentMode)
         {
            this.tfText.htmlText = "<p align=\"right\">" + this._text + "</p>";
         }
         else
         {
            this.tfText.htmlText = this._text;
            this.tfText.height = this.tfText.textHeight + CommonConstants.SAFE_TEXT_PADDING;
         }
         this.mcBackground.height = this.tfText.height + this.LIST_PADDING;
         this.mcLockIcon.y = this.mcBackground.y + (this.mcBackground.height - this.mcLockIcon.height) / 2;
      }
   }
}
