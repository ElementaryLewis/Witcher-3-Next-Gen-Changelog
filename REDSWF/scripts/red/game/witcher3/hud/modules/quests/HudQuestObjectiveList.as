package red.game.witcher3.hud.modules.quests
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.game.witcher3.controls.W3ScrollingList;
   import red.game.witcher3.utils.CommonUtils;
   
   public class HudQuestObjectiveList extends W3ScrollingList
   {
       
      
      public var tfQuestName:TextField;
      
      public var mcQuestTextShadow:MovieClip;
      
      public var mcTitleLineSeparator:MovieClip;
      
      public function HudQuestObjectiveList()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
      }
      
      public function onQuestNameSet(param1:String) : void
      {
         if(this.tfQuestName)
         {
            this.tfQuestName.wordWrap = true;
            this.tfQuestName.text = CommonUtils.toUpperCaseSafe(param1);
            this.mcQuestTextShadow.width = this.tfQuestName.textWidth + 10;
            this.mcQuestTextShadow.height = 32 + (this.tfQuestName.numLines - 1) * 22.65;
            this.mcTitleLineSeparator.y = 33 + (this.tfQuestName.numLines - 1) * 22.65;
         }
      }
      
      public function onQuestNameColorSet(param1:int) : void
      {
         if(this.tfQuestName)
         {
            this.tfQuestName.textColor = param1;
         }
      }
      
      public function repositionRenderers() : void
      {
         var _loc2_:HudQuestObjectiveListItem = null;
         var _loc1_:Number = this.mcTitleLineSeparator.y + 32;
         var _loc3_:uint = _renderers.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = getRendererAt(_loc4_) as HudQuestObjectiveListItem;
            if(_loc2_)
            {
               _loc2_.y = _loc1_;
               _loc1_ += _loc2_.tfObjective.height + 3;
            }
            _loc4_++;
         }
      }
   }
}
