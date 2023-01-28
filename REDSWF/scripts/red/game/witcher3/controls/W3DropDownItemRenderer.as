package red.game.witcher3.controls
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.core.events.GameEvent;
   
   public class W3DropDownItemRenderer extends BaseListItem
   {
       
      
      public var mcFeedbackIcon:MovieClip;
      
      public var tfSecondLine:TextField;
      
      public var mcNewOverlay:MovieClip;
      
      protected var _isNew:Boolean = false;
      
      protected var readEventName:String = "OnEntryRead";
      
      public function W3DropDownItemRenderer()
      {
         super();
         if(this.mcNewOverlay)
         {
            this.mcNewOverlay.visible = false;
         }
         if(this.mcFeedbackIcon)
         {
            this.mcFeedbackIcon.visible = false;
         }
         preventAutosizing = true;
         constraintsDisabled = true;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         allowDeselect = false;
         toggle = false;
      }
      
      override public function toString() : String
      {
         return "[W3 W3DropDownItemRenderer]";
      }
      
      override public function setActualSize(param1:Number, param2:Number) : void
      {
      }
      
      override public function setData(param1:Object) : void
      {
         if(this.tfSecondLine)
         {
            this.tfSecondLine.htmlText = "";
         }
         if(this.mcFeedbackIcon)
         {
            this.mcFeedbackIcon.visible = false;
         }
         super.setData(param1);
         if(!param1)
         {
            return;
         }
         this._isNew = param1.isNew;
         this.UpdateIcons();
         updateText();
      }
      
      protected function SetReadState(param1:MovieClip) : *
      {
         if(param1)
         {
            if(this._isNew)
            {
               param1.visible = true;
            }
            else
            {
               param1.visible = false;
            }
         }
      }
      
      override public function set selected(param1:Boolean) : void
      {
         super.selected = param1;
         if(this._isNew && param1 && Boolean(data.tag))
         {
            this._isNew = false;
            data.isNew = this._isNew;
            this.UpdateIcons();
            dispatchEvent(new GameEvent(GameEvent.CALL,this.readEventName,[data.tag]));
         }
      }
      
      protected function UpdateIcons() : void
      {
         this.SetReadState(this.mcNewOverlay);
      }
      
      public function handleEntryPress() : void
      {
      }
   }
}
