package red.game.witcher3.controls
{
   import com.gskinner.motion.GTween;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import red.core.constants.KeyCode;
   import red.game.witcher3.constants.GwintInputFeedback;
   import red.game.witcher3.managers.InputFeedbackManager;
   import red.game.witcher3.menus.gwint.CardInstance;
   import red.game.witcher3.menus.gwint.CardManager;
   import red.game.witcher3.menus.gwint.CardSlot;
   import red.game.witcher3.menus.gwint.CardTemplate;
   import red.game.witcher3.menus.gwint.GwintTutorial;
   import red.game.witcher3.slots.SlotsListCarousel;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.clik.managers.InputDelegate;
   import scaleform.clik.ui.InputDetails;
   import scaleform.gfx.MouseEventEx;
   
   public class W3ChoiceDialog extends UIComponent
   {
       
      
      public var txtCarouselMessage:TextField;
      
      public var mcCarouselMsgBackground:MovieClip;
      
      public var cardsCarousel:SlotsListCarousel;
      
      public var mcTooltip:MovieClip;
      
      public var mcBackground:Sprite;
      
      private var _choices:Array;
      
      private var _sourceList:Array;
      
      private var _acceptCallback:Function;
      
      private var _declineCallback:Function;
      
      private var _shown:Boolean;
      
      public var ignoreNextRightClick:Boolean = false;
      
      protected var _inputEnabled:Boolean = true;
      
      public function W3ChoiceDialog()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.txtCarouselMessage.text = "";
         InputDelegate.getInstance().addEventListener(InputEvent.INPUT,this.handleInputCustom,false,0,true);
         this.cardsCarousel.addEventListener(ListEvent.INDEX_CHANGE,this.onCarouselSelectionChanged,false,0,true);
         stage.addEventListener(MouseEvent.CLICK,this.handleStageClick,false,1,true);
         stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.OnMouseWheel,false,0,true);
         this.cardsCarousel.addEventListener(CardSlot.CardMouseDoubleClick,this.OnCardMouseDoubleClick,false,0,true);
      }
      
      public function showDialogCardInstances(sourceList:Vector.<CardInstance>, acceptCallback:Function, declineCallback:Function, messageText:String) : void
      {
         var i:int = 0;
         var convertedArray:Array = new Array();
         for(i = 0; i < sourceList.length; i++)
         {
            convertedArray.push(sourceList[i]);
         }
         this.showDialog(convertedArray,acceptCallback,declineCallback,messageText);
      }
      
      public function showDialogCardTemplates(sourceList:Vector.<int>, acceptCallback:Function, declineCallback:Function, messageText:String) : void
      {
         var i:int = 0;
         var convertedArray:Array = new Array();
         for(i = 0; i < sourceList.length; i++)
         {
            convertedArray.push(sourceList[i]);
         }
         this.showDialog(convertedArray,acceptCallback,declineCallback,messageText);
      }
      
      public function showDialog(sourceList:Array, acceptCallback:Function, declineCallback:Function, messageText:String) : void
      {
         if(!this._shown)
         {
            this._shown = true;
            enabled = this.visible = true;
         }
         this._acceptCallback = acceptCallback;
         this._declineCallback = declineCallback;
         this._sourceList = sourceList;
         this.cardsCarousel.data = this._sourceList;
         this.cardsCarousel.focused = 1;
         this.cardsCarousel.validateNow();
         if(this.cardsCarousel.selectedIndex == -1)
         {
            this.cardsCarousel.selectedIndex = 0;
         }
         else if(this.cardsCarousel.selectedIndex > sourceList.length)
         {
            this.cardsCarousel.selectedIndex = sourceList.length - 1;
         }
         this.cardsCarousel.validateNow();
         this.updateTooltip(this.cardsCarousel.getSelectedRenderer() as CardSlot);
         this.updateDialogText(messageText);
         this.updateInputFeedback();
         this.inputEnabled = true;
      }
      
      public function set inputEnabled(value:Boolean) : void
      {
         this._inputEnabled = value;
         this.cardsCarousel.inputEnabled = value;
      }
      
      public function updateDialogText(messageText:String) : void
      {
         if(this.txtCarouselMessage)
         {
            this.txtCarouselMessage.text = messageText;
         }
         if(this.txtCarouselMessage.text == "")
         {
            this.mcCarouselMsgBackground.visible = false;
         }
         else
         {
            this.mcCarouselMsgBackground.visible = true;
         }
      }
      
      public function appendDialogText(textToAppend:String) : void
      {
         if(this.txtCarouselMessage)
         {
            this.txtCarouselMessage.appendText(textToAppend);
         }
         if(this.txtCarouselMessage.text == "")
         {
            this.mcCarouselMsgBackground.visible = false;
         }
         else
         {
            this.mcCarouselMsgBackground.visible = true;
         }
      }
      
      public function hideDialog() : void
      {
         if(this._shown)
         {
            this._shown = false;
            this.cardsCarousel.focused = 0;
            enabled = this.visible = false;
            this.txtCarouselMessage.text = "";
         }
         InputFeedbackManager.removeButtonById(GwintInputFeedback.apply);
         InputFeedbackManager.removeButtonById(GwintInputFeedback.cancel);
      }
      
      override public function set visible(value:Boolean) : void
      {
         super.visible = value;
         mouseEnabled = value;
         mouseChildren = value;
      }
      
      public function replaceCard(sourceInstance:CardInstance, newInstance:CardInstance) : void
      {
         this.cardsCarousel.replaceItem(sourceInstance,newInstance);
         this.updateTooltip(this.cardsCarousel.getSelectedRenderer() as CardSlot);
      }
      
      private function handleDialogShown(tweenInstance:GTween) : void
      {
      }
      
      private function handleDialogHidden(tweenInstance:GTween) : void
      {
         enabled = this.visible = false;
      }
      
      public function isShown() : Boolean
      {
         return this._shown;
      }
      
      private function handleInputCustom(event:InputEvent) : void
      {
         if(!this._inputEnabled)
         {
            return;
         }
         super.handleInput(event);
         if(event.handled || !this._shown)
         {
            return;
         }
         var details:InputDetails = event.details;
         var keyPress:* = details.value == InputValue.KEY_UP;
         if(keyPress)
         {
            switch(details.navEquivalent)
            {
               case NavigationCode.GAMEPAD_A:
                  this.applyChoice();
                  event.handled = true;
                  break;
               case NavigationCode.GAMEPAD_B:
                  this.cancelChoice();
                  event.handled = true;
            }
         }
      }
      
      private function applyChoice() : void
      {
         var curRenderer:CardSlot = null;
         if(this._shown && this._acceptCallback != null)
         {
            this.cardsCarousel.validateNow();
            curRenderer = this.cardsCarousel.getRendererAt(this.cardsCarousel.selectedIndex) as CardSlot;
            if(Boolean(curRenderer) && curRenderer.activateEnabled)
            {
               if(curRenderer.instanceId != -1)
               {
                  this._acceptCallback(curRenderer.instanceId);
               }
               else
               {
                  this._acceptCallback(curRenderer.cardIndex);
               }
            }
         }
      }
      
      private function cancelChoice() : void
      {
         if(this._declineCallback != null)
         {
            this._declineCallback();
         }
      }
      
      protected function onCarouselSelectionChanged(event:ListEvent) : void
      {
         var selectedItem:CardSlot = this.cardsCarousel.getRendererAt(event.index) as CardSlot;
         this.updateTooltip(selectedItem);
         this.updateInputFeedback();
      }
      
      protected function updateInputFeedback() : void
      {
         var acceptAvailable:* = this._acceptCallback != null;
         var currentSelection:CardSlot = this.cardsCarousel.getSelectedRenderer() as CardSlot;
         if(currentSelection && acceptAvailable && !currentSelection.activateEnabled)
         {
            acceptAvailable = false;
         }
         if(acceptAvailable)
         {
            InputFeedbackManager.appendButtonById(GwintInputFeedback.apply,NavigationCode.GAMEPAD_A,KeyCode.ENTER,"panel_button_common_select");
         }
         else
         {
            InputFeedbackManager.removeButtonById(GwintInputFeedback.apply);
         }
         if(this._declineCallback != null)
         {
            InputFeedbackManager.appendButtonById(GwintInputFeedback.cancel,NavigationCode.GAMEPAD_B,KeyCode.ESCAPE,"panel_common_cancel");
         }
         else
         {
            InputFeedbackManager.removeButtonById(GwintInputFeedback.cancel);
         }
      }
      
      protected function updateTooltip(selectedItem:CardSlot) : void
      {
         var tooltipString:String = null;
         var titleText:TextField = null;
         var descText:TextField = null;
         var tooltipIcon:MovieClip = null;
         var cardManager:CardManager = CardManager.getInstance();
         var cardTemplate:CardTemplate = null;
         if(selectedItem)
         {
            cardTemplate = cardManager.getCardTemplate(selectedItem.cardIndex);
         }
         else if(this.cardsCarousel.data.length > 0)
         {
            if(this.cardsCarousel.data[0] is CardInstance)
            {
               cardTemplate = (this.cardsCarousel.data[0] as CardInstance).templateRef;
            }
            else if(this.cardsCarousel.data[0] is int)
            {
               cardTemplate = cardManager.getCardTemplate(this.cardsCarousel.data[0]);
            }
         }
         if(cardTemplate)
         {
            if(Boolean(this.mcTooltip) && Boolean(cardManager))
            {
               tooltipString = cardTemplate.tooltipString;
               titleText = this.mcTooltip.getChildByName("txtTooltipTitle") as TextField;
               descText = this.mcTooltip.getChildByName("txtTooltip") as TextField;
               if(tooltipString == "" || !titleText || !descText)
               {
                  this.mcTooltip.visible = false;
               }
               else
               {
                  this.mcTooltip.visible = true;
                  if(cardTemplate.index >= 1000)
                  {
                     titleText.text = "[[gwint_leader_ability]]";
                  }
                  else
                  {
                     titleText.text = "[[" + tooltipString + "_title]]";
                  }
                  if(cardTemplate.index == 524)
                  {
                     descText.text = "[[gwint_card_tooltip_scorch_creature]]";
                  }
                  else
                  {
                     descText.text = "[[" + tooltipString + "]]";
                  }
                  tooltipIcon = this.mcTooltip.getChildByName("mcTooltipIcon") as MovieClip;
                  if(tooltipIcon)
                  {
                     tooltipIcon.gotoAndStop(cardTemplate.tooltipIcon);
                  }
               }
            }
         }
         else
         {
            this.mcTooltip.visible = false;
         }
      }
      
      protected function handleStageClick(e:MouseEvent) : void
      {
         if(!this._shown)
         {
            return;
         }
         var superMouseEvent:MouseEventEx = e as MouseEventEx;
         if(superMouseEvent.buttonIdx == MouseEventEx.RIGHT_BUTTON && !GwintTutorial.mSingleton.active)
         {
            if(!this.ignoreNextRightClick)
            {
               this.cancelChoice();
            }
            else
            {
               this.ignoreNextRightClick = false;
            }
         }
      }
      
      public function OnMouseWheel(event:MouseEvent) : *
      {
         if(!this._shown)
         {
            return;
         }
         if(event.delta > 0)
         {
            this.cardsCarousel.navigateLeft();
         }
         else
         {
            this.cardsCarousel.navigateRight();
         }
      }
      
      public function OnCardMouseDoubleClick(event:Event) : *
      {
         this.applyChoice();
      }
   }
}
