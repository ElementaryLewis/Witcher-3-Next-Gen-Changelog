package red.game.witcher3.menus.character_menu
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFormatAlign;
   import red.core.CoreComponent;
   import red.game.witcher3.controls.RenderersList;
   import scaleform.clik.core.UIComponent;
   
   public class MutationRequirements extends UIComponent
   {
       
      
      private const LIST_PADDING:Number = 0;
      
      private const LIST_PADDING_AR:Number = 5;
      
      public var mcRequitementsList:RenderersList;
      
      public var mcBackground:MovieClip;
      
      public var mcLockIcon:MovieClip;
      
      public var tfLabelRequirements:TextField;
      
      private var _textValue:String;
      
      private var _data:Array;
      
      public function MutationRequirements()
      {
         super();
      }
      
      public function setData(param1:Array) : void
      {
         this._data = param1;
         if(CoreComponent.isArabicAligmentMode)
         {
            this.mcRequitementsList.alignment = TextFormatAlign.RIGHT;
            this.tfLabelRequirements.htmlText = "<p align=\"right\">" + this._textValue + "</p>";
         }
         else
         {
            this.tfLabelRequirements.text = this._textValue;
         }
         this.mcRequitementsList.dataList = this._data;
         this.mcRequitementsList.validateNow();
         this.tfLabelRequirements.text = "[[mutation_tooltip_requirements]]";
         this._textValue = this.tfLabelRequirements.text;
         this.mcBackground.height = this.mcRequitementsList.y + this.mcRequitementsList.actualHeight + this.LIST_PADDING;
         if(CoreComponent.isArabicAligmentMode)
         {
            this.mcLockIcon.x = this.mcBackground.x + this.mcBackground.width - this.mcLockIcon.width;
            this.tfLabelRequirements.x = this.mcLockIcon.x - this.tfLabelRequirements.width - this.LIST_PADDING_AR;
            this.mcRequitementsList.x = this.mcLockIcon.x - this.LIST_PADDING_AR;
         }
         this.mcLockIcon.y = (this.mcBackground.height - this.mcLockIcon.height) / 2;
      }
   }
}
