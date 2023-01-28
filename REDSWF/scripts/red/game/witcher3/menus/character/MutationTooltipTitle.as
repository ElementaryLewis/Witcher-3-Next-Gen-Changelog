package red.game.witcher3.menus.character
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.core.CoreComponent;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.core.UIComponent;
   
   public class MutationTooltipTitle extends UIComponent
   {
       
      
      public var mcBackground:MovieClip;
      
      public var tfMutationName:TextField;
      
      private const TEXT_PADDING = 4;
      
      public function MutationTooltipTitle()
      {
         super();
      }
      
      public function setText(param1:String) : void
      {
         if(CoreComponent.isArabicAligmentMode)
         {
            this.tfMutationName.htmlText = "<p align=\"right\">" + param1 + "</p>";
         }
         else
         {
            this.tfMutationName.text = param1;
            this.tfMutationName.text = CommonUtils.toUpperCaseSafe(this.tfMutationName.text);
         }
         this.tfMutationName.width = this.tfMutationName.textWidth + CommonConstants.SAFE_TEXT_PADDING;
         this.mcBackground.width = this.tfMutationName.x * 2 + this.tfMutationName.textWidth + this.TEXT_PADDING;
      }
   }
}
