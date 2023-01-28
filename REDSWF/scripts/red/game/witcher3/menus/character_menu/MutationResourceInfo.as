package red.game.witcher3.menus.character_menu
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   import red.game.witcher3.constants.TextColor;
   import scaleform.clik.controls.UILoader;
   import scaleform.clik.core.UIComponent;
   
   public class MutationResourceInfo extends UIComponent
   {
       
      
      private const ICON_PADDING:Number = 5;
      
      public var mcFeedback:MovieClip;
      
      public var mcMissingIngredient:MovieClip;
      
      public var mcBackground:MovieClip;
      
      public var tfCounter:TextField;
      
      public var tfLabel:TextField;
      
      private var _iconLoader:UILoader;
      
      private var _data:Object;
      
      public function MutationResourceInfo()
      {
         super();
         visible = false;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1;
         if(this._data)
         {
            this.updateData(this._data);
         }
      }
      
      public function playFeedbackAnim() : void
      {
         if(Boolean(this.data) && this.data.avaliableResources < this.data.required)
         {
            this.mcFeedback.gotoAndPlay(2);
         }
      }
      
      private function updateData(param1:Object) : void
      {
         visible = true;
         if(this._iconLoader)
         {
            this._iconLoader.removeEventListener(Event.COMPLETE,this.handleImageLoaded);
            this._iconLoader.unload();
            removeChild(this._iconLoader);
            this._iconLoader = null;
         }
         if(param1.resourceIconPath)
         {
            this._iconLoader = new UILoader();
            this._iconLoader.source = param1.resourceIconPath;
            this._iconLoader.addEventListener(Event.COMPLETE,this.handleImageLoaded,false,0,true);
            this._iconLoader.x = this.mcBackground.x;
            this._iconLoader.y = this.mcBackground.y;
            addChild(this._iconLoader);
         }
         if(param1.avaliableResources >= param1.required)
         {
            this.mcMissingIngredient.visible = false;
            this.tfCounter.textColor = TextColor.AVAILABLE;
         }
         else
         {
            this.mcMissingIngredient.visible = true;
            this.tfCounter.textColor = TextColor.WRONG;
         }
         this.tfLabel.text = param1.resourceName;
         this.tfCounter.text = param1.avaliableResources + "/" + param1.required;
         this.tfLabel.y = this.mcBackground.y + (this.mcBackground.height - this.tfLabel.textHeight) / 2;
      }
      
      private function handleImageLoaded(param1:Event) : void
      {
         addChild(this.tfCounter);
      }
   }
}
