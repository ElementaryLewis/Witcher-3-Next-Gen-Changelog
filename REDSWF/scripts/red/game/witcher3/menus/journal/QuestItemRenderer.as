package red.game.witcher3.menus.journal
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   import red.core.CoreComponent;
   import red.core.events.GameEvent;
   import red.game.witcher3.menus.common.IconItemRenderer;
   
   public class QuestItemRenderer extends IconItemRenderer
   {
      
      public static var UNTRACK:String = "UNTRACK WHOLE LIST";
       
      
      public var mcFeedbackIconSecond:MovieClip;
      
      protected var questStatusColorMain:String = "<font color=\'#ffcc00\'>";
      
      protected var questStatusColorSide:String = "<font color=\'#bb8237\'>";
      
      protected var questStatusColorMinor:String = "<font color=\'#d5d5d5\'>";
      
      protected var questStatusColorEnd:String = "</font>";
      
      protected var _Title:String = "";
      
      public var tfLevel:TextField;
      
      public var trackedBackground:MovieClip;
      
      protected var _tracked:Boolean = false;
      
      public function QuestItemRenderer()
      {
         super();
         if(this.tfLevel)
         {
            this.tfLevel.htmlText = "";
         }
      }
      
      override public function toString() : String
      {
         return "[W3 QuestItemRenderer " + this.name + "]";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.AddEventListeners();
      }
      
      public function AddEventListeners() : *
      {
         stage.addEventListener(QuestItemRenderer.UNTRACK,this.handleUntrackItem,false,0,true);
      }
      
      override public function setData(param1:Object) : void
      {
         if(this.mcFeedbackIconSecond)
         {
            this.mcFeedbackIconSecond.visible = false;
         }
         if(!param1)
         {
            return;
         }
         if(param1.label)
         {
            this._Title = String(param1.label);
         }
         this._tracked = param1.tracked;
         super.setData(param1);
         this.UpdateQuestStatusText();
         this.updateText();
      }
      
      override public function handleEntryPress() : void
      {
         if(data.status < 2)
         {
            if(!this.Tracked)
            {
               stage.dispatchEvent(new Event(QuestItemRenderer.UNTRACK));
               this.Tracked = true;
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnTrackQuest",[data.tag]));
            }
         }
      }
      
      protected function UpdateQuestStatusText() : void
      {
         var _loc1_:* = null;
         if(tfSecondLine)
         {
            if(data)
            {
               _loc1_ = this.GetQuestStatusColor();
               if(CoreComponent.isArabicAligmentMode)
               {
                  _loc1_ = "<p align=\"right\">" + _loc1_ + "</p>";
               }
               tfSecondLine.htmlText = _loc1_;
               return;
            }
            tfSecondLine.htmlText = "";
         }
      }
      
      override protected function updateText() : void
      {
         if(!data)
         {
            textField.htmlText = "";
            return;
         }
         if(this._tracked)
         {
            _label = "<font color=\'#FFFFFF\'>" + this._Title + this.questStatusColorEnd;
         }
         else if(data.status == 2)
         {
            _label = "<font color=\'#209226\'>" + this._Title + this.questStatusColorEnd;
         }
         else if(data.status == 3)
         {
            _label = "<font color=\'#9c1509\'>" + this._Title + this.questStatusColorEnd;
         }
         else if(data.epIndex == 0)
         {
            _label = "<font color=\'#B0A99F\'>" + this._Title + this.questStatusColorEnd;
         }
         else if(data.epIndex == 1)
         {
            _label = "<font color=\'#3e9ddf\'>" + this._Title + this.questStatusColorEnd;
         }
         else
         {
            _label = "<font color=\'#E18168\'>" + this._Title + this.questStatusColorEnd;
         }
         if(this.tfLevel)
         {
            this.tfLevel.htmlText = data.area;
         }
         super.updateText();
      }
      
      override protected function UpdateIcons() : void
      {
         mcFeedbackIcon.visible = false;
         this.mcFeedbackIconSecond.visible = false;
         mcFeedbackIcon.gotoAndStop("none");
         this.mcFeedbackIconSecond.gotoAndStop("none");
         if(this.trackedBackground)
         {
            this.trackedBackground.visible = false;
         }
         if(this._tracked)
         {
            mcFeedbackIcon.visible = true;
            if(this.trackedBackground)
            {
               this.trackedBackground.visible = true;
            }
            mcFeedbackIcon.gotoAndStop("tracked");
            SetReadState(this.mcFeedbackIconSecond);
         }
         else if(data.status == 2)
         {
            mcFeedbackIcon.visible = true;
            mcFeedbackIcon.gotoAndStop("succed");
            SetReadState(this.mcFeedbackIconSecond);
         }
         else if(data.status == 3)
         {
            mcFeedbackIcon.visible = true;
            mcFeedbackIcon.gotoAndStop("failed");
            SetReadState(this.mcFeedbackIconSecond);
         }
         else
         {
            SetReadState(mcFeedbackIcon);
         }
      }
      
      protected function IsStory() : Boolean
      {
         return data.isStory;
      }
      
      private function GetQuestStatusColor() : *
      {
         return data.secondLabel;
      }
      
      override protected function updateAfterStateChange() : void
      {
         this.UpdateQuestStatusText();
      }
      
      public function set Tracked(param1:Boolean) : void
      {
         if(this._tracked != param1 && data.status < 2)
         {
            this._tracked = param1;
            data.tracked = this._tracked;
            this.UpdateIcons();
            this.updateText();
         }
      }
      
      public function get Tracked() : Boolean
      {
         return this._tracked;
      }
      
      public function handleUntrackItem(param1:Event) : *
      {
         if(param1.currentTarget != this && this.Tracked)
         {
            this.Tracked = false;
         }
      }
   }
}
