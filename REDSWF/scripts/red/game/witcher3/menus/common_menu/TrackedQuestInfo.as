package red.game.witcher3.menus.common_menu
{
   import flash.text.TextField;
   import scaleform.clik.core.UIComponent;
   
   public class TrackedQuestInfo extends UIComponent
   {
       
      
      public var tfQuest:TextField;
      
      public var tfObjective:TextField;
      
      private var _gap:Number;
      
      private var questIsTracked:Boolean = false;
      
      public function TrackedQuestInfo()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         this.tfQuest.htmlText = "";
         this.tfObjective.htmlText = "";
         this.tfQuest.text = "";
         this.tfObjective.text = "";
         this._gap = 10;
         super.configUI();
      }
      
      public function handleDataSet(param1:Object, param2:int) : void
      {
         var _loc3_:Array = param1 as Array;
         this.questIsTracked = false;
         if(_loc3_)
         {
            if(_loc3_[0].questName != "")
            {
               this.tfQuest.htmlText = _loc3_[0].questName;
               this.questIsTracked = true;
            }
            if(_loc3_[0].objectiveName != "")
            {
               this.questIsTracked = true;
               this.tfObjective.htmlText = _loc3_[0].objectiveName;
               this.tfObjective.y = this.tfQuest.y + this.tfQuest.textHeight + this._gap;
            }
         }
         else
         {
            this.tfQuest.htmlText = "";
            this.tfObjective.htmlText = "";
            this.tfQuest.text = "";
            this.tfObjective.text = "";
         }
      }
      
      public function IsAnyItemToDisplay() : Boolean
      {
         return this.questIsTracked;
      }
   }
}
