package red.game.witcher3.hud.modules.quests
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import red.game.witcher3.controls.BaseListItem;
   
   public class HudQuestObjectiveListItem extends BaseListItem
   {
      
      private static const ANIMATION_DURATION:Number = 500;
       
      
      public var tfObjective:TextField;
      
      public var mcHighlight:MovieClip;
      
      public var mcNewOverlay:MovieClip;
      
      public function HudQuestObjectiveListItem()
      {
         super();
         constraintsDisabled = true;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.tfObjective.wordWrap = true;
         this.tfObjective.autoSize = TextFieldAutoSize.CENTER;
         this.mcHighlight.visible = false;
         this.mcNewOverlay.alpha = 0;
      }
      
      override public function setActualSize(param1:Number, param2:Number) : void
      {
      }
      
      override public function setData(param1:Object) : void
      {
         visible = false;
         super.setData(param1);
         if(param1)
         {
            this.tfObjective.htmlText = param1.name;
            this.Highlight(param1.isHighlighted);
            this.ResizeElements();
            if(param1.isNew)
            {
               this.ShowNewFeedback();
               param1.isNew = false;
            }
            validateNow();
         }
      }
      
      public function ShowNewFeedback() : *
      {
         GTweener.removeTweens(this.mcNewOverlay);
         GTweener.to(this.mcNewOverlay,ANIMATION_DURATION / 1000,{"alpha":1},{"onComplete":this.handleNewFeedbackShowComplete});
      }
      
      protected function handleNewFeedbackShowComplete(param1:GTween) : void
      {
         GTweener.removeTweens(this.mcNewOverlay);
         GTweener.to(this.mcNewOverlay,ANIMATION_DURATION / 1000,{"alpha":0});
      }
      
      private function ResizeElements() : void
      {
         this.mcHighlight.width = this.tfObjective.textWidth + 10;
         this.mcHighlight.height = this.tfObjective.textHeight + 10;
         this.mcHighlight.y = this.tfObjective.y;
         this.mcNewOverlay.width = this.tfObjective.textWidth + 10;
         this.mcNewOverlay.height = this.tfObjective.textHeight + 10;
         this.mcNewOverlay.x = this.tfObjective.x + 141;
         this.mcNewOverlay.y = this.tfObjective.y + this.mcNewOverlay.height / 2;
      }
      
      public function Highlight(param1:Boolean) : *
      {
         if(!data)
         {
            return;
         }
         data.isHighlighted = param1;
         this.mcHighlight.visible = param1;
         if(data.isHighlighted)
         {
            this.tfObjective.textColor = 16777215;
         }
         else
         {
            this.tfObjective.textColor = 10066329;
         }
      }
   }
}
