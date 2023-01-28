package red.game.witcher3.menus.character_menu
{
   import flash.events.Event;
   import flash.geom.Point;
   import flash.text.TextField;
   import red.core.constants.KeyCode;
   import red.game.witcher3.controls.InputFeedbackButton;
   import red.game.witcher3.events.ControllerChangeEvent;
   import red.game.witcher3.managers.InputManager;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.controls.Button;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.events.ButtonEvent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class MutationResearch extends UIComponent
   {
       
      
      public var tooltipInstance:MutationTooltip;
      
      public var tfButtonLabel:TextField;
      
      public var btnResearch:InputFeedbackButton;
      
      public var btnResearchPC:Button;
      
      public var researchCallback:Function;
      
      public var closeCallback:Function;
      
      private var _selectedRes:MutationProgressItemRenderer;
      
      private var _resourcesList:MutationResourcesList;
      
      private var _attachedMutation:MutationItemRenderer;
      
      private var _anchorPoint:Point;
      
      private var _data:Object;
      
      private var _replica:Object;
      
      private var _changeList:Object;
      
      private var _researchProgress:Boolean = false;
      
      public function MutationResearch()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
      }
      
      public function getChangeList() : Object
      {
         return this._changeList;
      }
      
      public function getResearchProgress() : Boolean
      {
         return this._researchProgress;
      }
      
      public function getListComponent() : MutationResourcesList
      {
         return this._resourcesList;
      }
      
      public function attachTo(param1:MutationItemRenderer) : void
      {
      }
      
      public function detach() : void
      {
      }
      
      private function handleControllerChanged(param1:ControllerChangeEvent) : void
      {
         this.btnResearchPC.alpha = InputManager.getInstance().isGamepad() ? 0 : 1;
      }
      
      private function handleItemIndexChanged(param1:ListEvent) : void
      {
         var _loc2_:MutationProgressItemRenderer = param1.itemRenderer as MutationProgressItemRenderer;
         if(_loc2_)
         {
            this._selectedRes = _loc2_;
            this.updateSelectionInfo(this._selectedRes.data);
         }
      }
      
      private function handleItemDoubleClick(param1:ListEvent) : void
      {
         this.researchCurrent();
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc2_:InputDetails = param1.details;
         super.handleInput(param1);
         if(param1.handled)
         {
            return;
         }
         if(_loc2_.value == InputValue.KEY_UP)
         {
            switch(_loc2_.code)
            {
               case KeyCode.ENTER:
               case KeyCode.PAD_A_CROSS:
                  if(this._researchProgress)
                  {
                     this.confirmResearch();
                  }
                  break;
               case KeyCode.ESCAPE:
               case KeyCode.PAD_B_CIRCLE:
                  this.cancelResearch();
                  break;
               case KeyCode.E:
               case KeyCode.PAD_X_SQUARE:
               case KeyCode.SPACE:
                  this.researchCurrent();
            }
         }
         if(this._resourcesList.enabled && !param1.handled)
         {
            this._resourcesList.handleInput(param1);
         }
      }
      
      private function handleResearchClick(param1:ButtonEvent = null) : void
      {
         this.researchCurrent();
      }
      
      private function handleResourcesListActivated(param1:Event) : void
      {
      }
      
      private function handleResourcesListDeactivated(param1:Event) : void
      {
      }
      
      public function callResearch() : void
      {
         this.confirmResearch();
      }
      
      public function callCancelResearch() : void
      {
         this.cancelResearch();
      }
      
      private function researchCurrent() : void
      {
      }
      
      private function displayCurrentProgress() : void
      {
      }
      
      private function confirmResearch() : void
      {
      }
      
      private function cancelResearch() : void
      {
      }
      
      private function updateSelectionInfo(param1:Object) : void
      {
      }
   }
}
