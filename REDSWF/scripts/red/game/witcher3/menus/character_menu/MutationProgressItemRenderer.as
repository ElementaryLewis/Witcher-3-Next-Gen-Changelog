package red.game.witcher3.menus.character_menu
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.clik.controls.ListItemRenderer;
   import scaleform.clik.controls.StatusIndicator;
   import scaleform.clik.events.InputEvent;
   
   public class MutationProgressItemRenderer extends ListItemRenderer
   {
       
      
      public var mcHitArea:MovieClip;
      
      public var mcProgressbar:StatusIndicator;
      
      public var mcIcon:MovieClip;
      
      public var mcCompleteIcon:MovieClip;
      
      public var tfProgress:TextField;
      
      public function MutationProgressItemRenderer()
      {
         super();
         preventAutosizing = constraintsDisabled = true;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         visible = false;
         selectable = false;
      }
      
      override protected function draw() : void
      {
         super.draw();
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         super.setData(param1);
         if(param1)
         {
            preventAutosizing = constraintsDisabled = true;
            visible = true;
            selectable = true;
            _loc2_ = Number(_data.used);
            _loc3_ = Number(_data.required);
            this.mcProgressbar.maximum = _loc3_;
            if(_loc2_ >= _loc3_)
            {
               this.mcProgressbar.visible = false;
               this.mcCompleteIcon.visible = true;
            }
            else
            {
               this.mcProgressbar.value = _loc2_;
               this.mcProgressbar.visible = true;
               this.mcCompleteIcon.visible = false;
            }
            this.mcIcon.gotoAndStop(_data.type + 1);
            this.tfProgress.text = _loc2_ + "/" + _loc3_;
            this.mcProgressbar.validateNow();
         }
         else
         {
            visible = false;
            selectable = false;
         }
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
      }
   }
}
