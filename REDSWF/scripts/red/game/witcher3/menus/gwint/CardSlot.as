package red.game.witcher3.menus.gwint
{
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.PixelSnapping;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import red.core.constants.KeyCode;
   import red.game.witcher3.controls.W3TextArea;
   import red.game.witcher3.interfaces.IInventorySlot;
   import red.game.witcher3.slots.SlotBase;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.events.InputEvent;
   import scaleform.gfx.MouseEventEx;
   
   public class CardSlot extends SlotBase implements IInventorySlot
   {
      
      public static const CardMouseOver:String = "CardMouseOver";
      
      public static const CardMouseOut:String = "CardMouseOut";
      
      public static const CardMouseLeftClick:String = "CardMouseLeftClick";
      
      public static const CardMouseRightClick:String = "CardMouseRightClick";
      
      public static const CardMouseDoubleClick:String = "CardMouseDoubleClick";
      
      public static const STATE_DECK:String = "deckBuilder";
      
      public static const STATE_BOARD:String = "Board";
      
      public static const STATE_CAROUSEL:String = "Carousel";
      
      public static const CARD_ORIGIN_HEIGHT:int = 584;
      
      public static const CARD_ORIGIN_WIDTH:int = 309;
      
      public static const CARD_BOARD_HEIGHT:int = 120;
      
      public static const CARD_BOARD_WIDTH:int = 90;
      
      public static const CARD_CAROUSEL_HEIGHT:int = 584;
      
      public static const TYPE_ICON_OFFSET_Y:int = 167.5;
      
      public static const TYPE_ICON_OFFSET_X:int = 68.5;
      
      public static const TYPE_ICON_BOARD_SCALE:Number = 0.36;
      
      public static const POWER_ICON_BOARD_SCALE:Number = 0.36;
      
      public static const FACTION_BANNER_OFFSET_X:int = 6;
      
      public static const FACTION_BANNER_OFFSET_Y:int = 17;
      
      public static const EFFECT_OFFSET_X:int = 43.5;
      
      public static const EFFECT_OFFSET_Y:int = 0;
      
      public static const BOARD_EFFECT_OFFSET_X:int = 0;
      
      public static const BOARD_EFFECT_OFFSET_Y:int = -18;
      
      public static const DESCRIPTION_WIDTH:int = 243;
      
      public static const DESCRIPTION_HEIGHT:int = 114;
      
      public static const BOARD_SELECTED_Y_OFFSET:int = -15;
      
      public static var g_neutral_cards:Vector.<CardSlot> = new Vector.<CardSlot>();
      
      public static var g_current_faction:int = CardTemplate.FactionId_Nilfgaard;
       
      
      public var mcHitBox:MovieClip;
      
      public var mcCopyCount:MovieClip;
      
      public var mcLockedIcon:MovieClip;
      
      public var mcPowerIndicator:MovieClip;
      
      public var mcTypeIcon:MovieClip;
      
      public var mcTitle:MovieClip;
      
      public var mcDesc:MovieClip;
      
      public var mcFactionBanner:MovieClip;
      
      public var mcEffectIcon1:MovieClip;
      
      public var mcSmallImageMask:MovieClip;
      
      public var mcSmallImageContainer:MovieClip;
      
      public var mcCardImageContainer:MovieClip;
      
      public var mcCardHighlight:MovieClip;
      
      protected var imageLoaded:Boolean = false;
      
      protected var cardElementHolder:MovieClip;
      
      private var _cardIndex:int;
      
      private var _instanceId:int;
      
      private var _cardState:String;
      
      protected var cardInstanceRef:CardInstance = null;
      
      private var _activateEnabled:Boolean = true;
      
      private const shadowMax:Number = 90;
      
      private const shadowDelta:Number = 4;
      
      private var _lastShadowRotation:Number = 0;
      
      public function CardSlot()
      {
         super();
         this._instanceId = -1;
         this._cardIndex = -1;
         this.visible = false;
         this._cardState = STATE_DECK;
         if(this.mcCardHighlight)
         {
            this.mcCardHighlight.visible = false;
         }
         if(this.mcCopyCount)
         {
            this.mcCopyCount.visible = false;
         }
         if(this.mcLockedIcon)
         {
            this.mcLockedIcon.visible = false;
         }
      }
      
      public static function updateDefaultFaction(factionIdx:int) : void
      {
         var curSlot:CardSlot = null;
         g_current_faction = factionIdx;
         var factionFrameName:String = CardTemplate.getFactionStringFromId(g_current_faction);
         for each(curSlot in g_neutral_cards)
         {
            if(curSlot.mcFactionBanner)
            {
               curSlot.mcFactionBanner.gotoAndStop(factionFrameName);
            }
         }
      }
      
      protected function get adjCardHeight() : int
      {
         if(this._cardState == STATE_BOARD)
         {
            return CARD_BOARD_HEIGHT;
         }
         if(this._cardState == STATE_DECK)
         {
            return 355;
         }
         if(this._cardState == STATE_CAROUSEL)
         {
            return CARD_CAROUSEL_HEIGHT;
         }
         return CARD_ORIGIN_HEIGHT;
      }
      
      protected function get adjCardWidth() : int
      {
         if(this._cardState == STATE_BOARD)
         {
            return CARD_BOARD_WIDTH;
         }
         if(this._cardState == STATE_DECK)
         {
            return 188;
         }
         if(this._cardState == STATE_CAROUSEL)
         {
            return 309;
         }
         return CARD_ORIGIN_WIDTH;
      }
      
      public function get cardIndex() : int
      {
         return this._cardIndex;
      }
      
      public function set cardIndex(value:int) : void
      {
         if(value != this._cardIndex)
         {
            this._cardIndex = value;
            if(this._cardIndex != -1)
            {
               this.updateCardData();
            }
         }
      }
      
      public function get instanceId() : int
      {
         return this._instanceId;
      }
      
      public function set instanceId(value:int) : void
      {
         this.cardInstanceRef = null;
         this._instanceId = value;
         if(this._instanceId != -1)
         {
            this._cardIndex = this.cardInstance.templateId;
            this.updateCardData();
         }
      }
      
      public function updateTemplate(cardTemplate:CardTemplate) : void
      {
         this.setupCardWithTemplate(cardTemplate);
      }
      
      public function get cardState() : String
      {
         return this._cardState;
      }
      
      public function set cardState(value:String) : void
      {
         if(Boolean(value) && this._cardState != value)
         {
            this._cardState = value;
            this.updateCardSetup();
            this.updateSelectedVisual();
         }
      }
      
      public function get cardInstance() : CardInstance
      {
         if(this._instanceId != -1 && this.cardInstanceRef == null)
         {
            this.cardInstanceRef = CardManager.getInstance().getCardInstance(this.instanceId);
         }
         return this.cardInstanceRef;
      }
      
      public function get activateEnabled() : Boolean
      {
         return this._activateEnabled;
      }
      
      public function set activateEnabled(value:Boolean) : void
      {
         this._activateEnabled = value;
         this.mcLockedIcon.visible = !this._activateEnabled;
      }
      
      override protected function configUI() : void
      {
         var textField:TextField = null;
         super.configUI();
         this.setupCardElementHolder();
         if(this.mcCardHighlight)
         {
            _indicators.push(this.mcCardHighlight);
            this.mcCardHighlight.visible = false;
            this.mcCardHighlight.mouseEnabled = false;
            this.mcCardHighlight.mouseChildren = false;
         }
         if(this.mcCopyCount)
         {
            textField = this.mcCopyCount.getChildByName("mcCountText") as TextField;
            if(Boolean(textField) && data != null)
            {
               this.mcCopyCount.visible = true;
               textField.text = "x" + data.numCopies.toString();
            }
            else
            {
               this.mcCopyCount.visible = false;
            }
         }
         if(this.mcHitBox)
         {
            hitArea = this.mcHitBox;
            this.mcHitBox.doubleClickEnabled = true;
            this.mcHitBox.addEventListener(MouseEvent.DOUBLE_CLICK,this.handleHitDoubleClick,false,0,true);
            this.mcHitBox.addEventListener(MouseEvent.CLICK,this.handleHitClick,false,0,true);
            this.mcHitBox.addEventListener(MouseEvent.MOUSE_OVER,this.handleHitMouseOver,false,0,true);
            this.mcHitBox.addEventListener(MouseEvent.MOUSE_OUT,this.handleHitMouseOut,false,0,true);
         }
      }
      
      override public function canDrag() : Boolean
      {
         return false;
      }
      
      protected function setupCardElementHolder() : *
      {
         this.cardElementHolder = new MovieClip();
         this.addChild(this.cardElementHolder);
         if(this.mcHitBox)
         {
            this.addChild(this.mcHitBox);
            this.mcHitBox.x = 0;
            this.mcHitBox.y = 0;
         }
         this.cardElementHolder.x = 0;
         this.cardElementHolder.y = 0;
         if(this.mcSmallImageContainer)
         {
            this.cardElementHolder.addChild(this.mcSmallImageContainer);
         }
         if(this.mcSmallImageMask)
         {
            this.cardElementHolder.addChild(this.mcSmallImageMask);
         }
         if(this.mcDesc)
         {
            this.cardElementHolder.addChild(this.mcDesc);
         }
         if(this.mcTitle)
         {
            this.cardElementHolder.addChild(this.mcTitle);
         }
         if(this.mcFactionBanner)
         {
            this.cardElementHolder.addChild(this.mcFactionBanner);
         }
         if(this.mcEffectIcon1)
         {
            this.cardElementHolder.addChild(this.mcEffectIcon1);
         }
         if(this.mcPowerIndicator)
         {
            this.cardElementHolder.addChild(this.mcPowerIndicator);
         }
         if(this.mcTypeIcon)
         {
            this.cardElementHolder.addChild(this.mcTypeIcon);
         }
         if(this.mcCopyCount)
         {
            this.cardElementHolder.addChild(this.mcCopyCount);
         }
         if(mcSlotOverlays)
         {
            this.cardElementHolder.addChild(mcSlotOverlays);
         }
         if(this.mcCardHighlight)
         {
            this.cardElementHolder.addChild(this.mcCardHighlight);
         }
         if(Boolean(this.mcSmallImageContainer) && Boolean(this.mcSmallImageMask))
         {
            this.mcSmallImageContainer.mask = this.mcSmallImageMask;
         }
      }
      
      override protected function updateData() : *
      {
         if(data)
         {
            this.cardIndex = data.cardID;
         }
      }
      
      override public function setData(value:Object) : void
      {
         var textField:TextField = null;
         super.setData(value);
         if(data != null)
         {
            trace("GFX - CardSlot setData called with cardID: " + data.cardID + ", and copy count: " + data.numCopies);
            this.cardIndex = data.cardID;
            if(this.mcCopyCount)
            {
               textField = this.mcCopyCount.getChildByName("mcCountText") as TextField;
               if(textField)
               {
                  this.mcCopyCount.visible = true;
                  textField.text = "x" + data.numCopies.toString();
               }
            }
            else
            {
               this.mcCopyCount.visible = false;
            }
         }
      }
      
      public function setCardSource(instance:CardInstance) : *
      {
         this.instanceId = instance.instanceId;
      }
      
      protected function updateCardData() : void
      {
         var cardInstance:CardInstance = null;
         var cardManager:CardManager = CardManager.getInstance();
         if(this._instanceId != -1)
         {
            cardInstance = cardManager.getCardInstance(this._instanceId);
            if(cardInstance)
            {
               this.setupCardWithTemplate(cardInstance.templateRef);
            }
            else
            {
               trace("GFX ---- [ERROR ] ---- tried to get card instance for id: " + this._instanceId + ", but could not find it?!");
            }
         }
         else if(this._cardIndex != -1)
         {
            if(cardManager.getCardTemplate(this._cardIndex) != null)
            {
               this.setupCardWithTemplate(cardManager.getCardTemplate(this._cardIndex));
            }
            else
            {
               cardManager.addEventListener(CardManager.cardTemplatesLoaded,this.onCardTemplatesLoaded,false,0,true);
            }
         }
      }
      
      public function setCallbacksToCardInstance(cardInstance:CardInstance) : void
      {
         cardInstance.powerChangeCallback = this.onCardPowerChanged;
      }
      
      protected function setupCardWithTemplate(cardTemplate:CardTemplate) : void
      {
         var typeString:* = undefined;
         var childTextField:W3TextArea = null;
         var placementTypeString:String = null;
         var childTF:TextField = null;
         var cardManager:CardManager = null;
         var cardInstance:CardInstance = null;
         trace("GFX - CardSlot setting card up with cardID: " + this.cardIndex + ", and template: " + cardTemplate);
         if(cardTemplate)
         {
            typeString = cardTemplate.getTypeString();
            loadIcon("icons/gwint/" + cardTemplate.imageLoc + ".png");
            if(this.mcPowerIndicator)
            {
               if(cardTemplate.index >= 1000)
               {
                  this.mcPowerIndicator.visible = false;
               }
               else
               {
                  this.mcPowerIndicator.visible = true;
                  if(!CommonUtils.hasFrameLabel(this.mcPowerIndicator,typeString))
                  {
                     this.mcPowerIndicator.gotoAndStop("Default");
                  }
                  else
                  {
                     this.mcPowerIndicator.gotoAndStop(typeString);
                  }
                  this.mcPowerIndicator.addEventListener(Event.ENTER_FRAME,this.onPowerEnteredFrame,false,0,true);
                  this.updateCardPowerText();
               }
            }
            if(this.mcTypeIcon)
            {
               placementTypeString = cardTemplate.getPlacementTypeString();
               if(!CommonUtils.hasFrameLabel(this.mcTypeIcon,placementTypeString))
               {
                  this.mcTypeIcon.gotoAndStop("None");
               }
               else
               {
                  this.mcTypeIcon.gotoAndStop(placementTypeString);
               }
            }
            if(this.mcTitle)
            {
               childTF = this.mcTitle.getChildByName("txtTitle") as TextField;
               if(childTF)
               {
                  childTF.htmlText = cardTemplate.title;
               }
               childTF = this.mcTitle.getChildByName("txtDesc") as TextField;
               if(childTF)
               {
                  childTF.htmlText = cardTemplate.description;
               }
            }
            if(this.mcDesc)
            {
               if(!CommonUtils.hasFrameLabel(this.mcDesc,typeString))
               {
                  this.mcDesc.gotoAndStop("Default");
               }
               else
               {
                  this.mcDesc.gotoAndStop(typeString);
               }
            }
            if(this.mcFactionBanner)
            {
               if(cardTemplate.factionIdx == CardTemplate.FactionId_Neutral)
               {
                  g_neutral_cards.push(this);
                  if(this._instanceId != -1)
                  {
                     cardManager = CardManager.getInstance();
                     cardInstance = cardManager.getCardInstance(this._instanceId);
                     if(Boolean(cardInstance) && Boolean(cardManager))
                     {
                        this.mcFactionBanner.gotoAndStop(CardTemplate.getFactionStringFromId(cardManager.getSpawnedFaction(cardInstance)));
                     }
                  }
                  else
                  {
                     this.mcFactionBanner.gotoAndStop(CardTemplate.getFactionStringFromId(g_current_faction));
                  }
               }
               else if(!CommonUtils.hasFrameLabel(this.mcFactionBanner,cardTemplate.getFactionString()))
               {
                  this.mcFactionBanner.gotoAndStop("None");
               }
               else
               {
                  this.mcFactionBanner.gotoAndStop(cardTemplate.getFactionString());
               }
            }
            trace("GFX --- setting up card with effect: " + cardTemplate.getEffectString());
            if(this.mcEffectIcon1)
            {
               this.mcEffectIcon1.gotoAndStop(cardTemplate.getEffectString());
            }
            this.updateCardSetup();
            return;
         }
         throw new Error("GFX -- Tried to setup a card with an unknown template! --- ");
      }
      
      protected function onPowerEnteredFrame(event:Event) : void
      {
         this.updateCardPowerText();
         this.mcPowerIndicator.removeEventListener(Event.ENTER_FRAME,this.onPowerEnteredFrame);
      }
      
      protected function updateCardPowerText() : void
      {
         var cardInstance:CardInstance = null;
         var totalPower:int = 0;
         var cardTemplate:CardTemplate = CardManager.getInstance().getCardTemplate(this._cardIndex);
         var txtPowerValue:W3TextArea = this.mcPowerIndicator.getChildByName("txtPower") as W3TextArea;
         if(txtPowerValue)
         {
            if(this.instanceId != -1)
            {
               cardInstance = CardManager.getInstance().getCardInstance(this.instanceId);
               totalPower = cardInstance.getTotalPower();
               txtPowerValue.text = totalPower.toString();
            }
            else
            {
               txtPowerValue.text = cardTemplate.power.toString();
            }
            if(!cardTemplate.isType(CardTemplate.CardType_Creature))
            {
               txtPowerValue.visible = false;
            }
            else
            {
               txtPowerValue.visible = true;
               if(this.instanceId != -1 && cardInstance.templateRef.power < totalPower)
               {
                  txtPowerValue.setTextColor(2195475);
               }
               else if(this.instanceId != -1 && cardInstance.templateRef.power > totalPower)
               {
                  txtPowerValue.setTextColor(12648448);
               }
               else if(cardTemplate.isType(CardTemplate.CardType_Hero))
               {
                  txtPowerValue.setTextColor(16777215);
               }
               else
               {
                  txtPowerValue.setTextColor(0);
               }
            }
         }
      }
      
      protected function onCardPowerChanged() : void
      {
         if(this.mcPowerIndicator)
         {
            this.updateCardPowerText();
         }
      }
      
      protected function onCardTemplatesLoaded(event:Event) : void
      {
         CardManager.getInstance().removeEventListener(CardManager.cardTemplatesLoaded,this.onCardTemplatesLoaded,false);
         this.setupCardWithTemplate(CardManager.getInstance().getCardTemplate(this.cardIndex));
      }
      
      override protected function handleIconLoaded(event:Event) : void
      {
         var image:Bitmap = Bitmap(event.target.content);
         if(image)
         {
            image.smoothing = true;
            image.pixelSnapping = PixelSnapping.NEVER;
         }
         this.visible = true;
         this.imageLoaded = true;
         this.updateCardSetup();
      }
      
      protected function updateCardSetup() : void
      {
         var curTextField:TextField = null;
         if(!this.imageLoaded)
         {
            return;
         }
         var templateCard:CardTemplate = CardManager.getInstance().getCardTemplate(this._cardIndex);
         var adjustedCardHeight:int = this.adjCardHeight;
         var adjustedCardWidth:int = this.adjCardWidth;
         var halfAdjHeight:int = adjustedCardHeight / 2;
         var halfAdjWidth:int = adjustedCardWidth / 2;
         var relativeScale:* = adjustedCardHeight / CARD_CAROUSEL_HEIGHT;
         if(this.mcCopyCount)
         {
            this.mcCopyCount.x = 0;
            this.mcCopyCount.y = halfAdjHeight;
         }
         if(this.mcHitBox)
         {
            if(this._cardState == STATE_BOARD)
            {
               this.mcHitBox.width = CARD_BOARD_WIDTH;
               this.mcHitBox.height = CARD_BOARD_HEIGHT;
            }
            else
            {
               this.mcHitBox.width = adjustedCardWidth;
               this.mcHitBox.height = adjustedCardHeight;
            }
         }
         if(this.mcPowerIndicator)
         {
            if(this._cardState == STATE_BOARD)
            {
               this.mcPowerIndicator.scaleX = this.mcPowerIndicator.scaleY = POWER_ICON_BOARD_SCALE;
            }
            else
            {
               this.mcPowerIndicator.scaleX = this.mcPowerIndicator.scaleY = relativeScale;
            }
            this.mcPowerIndicator.x = -halfAdjWidth;
            this.mcPowerIndicator.y = -halfAdjHeight;
         }
         if(this.mcTypeIcon)
         {
            if(this._cardState == STATE_BOARD)
            {
               this.mcTypeIcon.x = 40;
               this.mcTypeIcon.y = 32;
               this.mcTypeIcon.scaleX = this.mcTypeIcon.scaleY = TYPE_ICON_BOARD_SCALE;
            }
            else
            {
               this.mcTypeIcon.x = -halfAdjWidth + TYPE_ICON_OFFSET_X * relativeScale;
               this.mcTypeIcon.y = -halfAdjHeight + TYPE_ICON_OFFSET_Y * relativeScale;
               this.mcTypeIcon.scaleX = this.mcTypeIcon.scaleY = relativeScale;
            }
         }
         if(this.mcFactionBanner)
         {
            if(this._cardState == STATE_BOARD || !this.mcPowerIndicator.visible)
            {
               this.mcFactionBanner.visible = false;
            }
            else
            {
               this.mcFactionBanner.visible = true;
               this.mcFactionBanner.scaleY = this.mcFactionBanner.scaleX = relativeScale;
               this.mcFactionBanner.x = -halfAdjWidth;
               this.mcFactionBanner.y = -halfAdjHeight;
            }
         }
         if(this.mcEffectIcon1)
         {
            if(this._cardState == STATE_BOARD)
            {
               this.mcEffectIcon1.scaleX = this.mcEffectIcon1.scaleY = TYPE_ICON_BOARD_SCALE;
               this.mcEffectIcon1.x = BOARD_EFFECT_OFFSET_X;
               this.mcEffectIcon1.y = halfAdjHeight + BOARD_EFFECT_OFFSET_Y;
            }
            else
            {
               this.mcEffectIcon1.scaleX = this.mcEffectIcon1.scaleY = relativeScale;
               this.mcEffectIcon1.x = -halfAdjWidth + EFFECT_OFFSET_X * relativeScale;
               this.mcEffectIcon1.y = EFFECT_OFFSET_Y * relativeScale;
            }
         }
         if(Boolean(this.mcDesc) && Boolean(this.mcTitle))
         {
            if(this._cardState == STATE_BOARD)
            {
               this.mcTitle.visible = false;
               this.mcDesc.visible = false;
            }
            else
            {
               this.mcTitle.visible = true;
               this.mcDesc.visible = true;
               curTextField = this.mcTitle.getChildByName("txtTitle") as TextField;
               if(curTextField)
               {
                  if(this._cardState == STATE_CAROUSEL)
                  {
                     if(Boolean(templateCard) && templateCard.typeArray == CardTemplate.CardType_None)
                     {
                        curTextField.x = -149;
                        curTextField.y = -137;
                        curTextField.width = 287;
                        curTextField.height = 79;
                     }
                     else
                     {
                        curTextField.x = -83;
                        curTextField.y = -137;
                        curTextField.width = 223;
                        curTextField.height = 79;
                     }
                  }
                  else if(this._cardState == STATE_DECK)
                  {
                     if(Boolean(templateCard) && templateCard.typeArray == CardTemplate.CardType_None)
                     {
                        curTextField.x = -96;
                        curTextField.y = -83;
                        curTextField.width = 178;
                        curTextField.height = 100;
                     }
                     else
                     {
                        curTextField.x = -53;
                        curTextField.y = -83;
                        curTextField.width = 140;
                        curTextField.height = 100;
                     }
                  }
               }
               curTextField = this.mcTitle.getChildByName("txtDesc") as TextField;
               if(curTextField)
               {
                  if(this._cardState == STATE_CAROUSEL)
                  {
                     curTextField.visible = true;
                     curTextField.x = -156;
                     curTextField.y = -65;
                     curTextField.width = 304;
                     curTextField.height = 70;
                  }
                  else if(this._cardState == STATE_DECK)
                  {
                     curTextField.visible = false;
                  }
               }
               this.mcDesc.scaleX = this.mcDesc.scaleY = relativeScale;
               this.mcDesc.x = 0;
               this.mcDesc.y = halfAdjHeight;
               this.mcTitle.x = 0;
               this.mcTitle.y = halfAdjHeight;
            }
         }
         if(this.mcCardHighlight)
         {
            this.mcCardHighlight.scaleX = adjustedCardWidth / 238;
            this.mcCardHighlight.scaleY = adjustedCardHeight / 450;
         }
         this.updateImagePosAndSize();
      }
      
      protected function updateImagePosAndSize() : void
      {
         if(!_imageLoader)
         {
            return;
         }
         var targetHeight:Number = this.adjCardHeight;
         var targetWidth:Number = this.adjCardWidth;
         if(this._cardState == STATE_BOARD)
         {
            targetHeight = 170;
            if(this.mcSmallImageContainer)
            {
               this.mcSmallImageContainer.addChild(_imageLoader);
            }
         }
         else if(this.mcCardImageContainer)
         {
            this.mcCardImageContainer.addChild(_imageLoader);
         }
         _imageLoader.scaleX = _imageLoader.scaleY = targetWidth / CARD_ORIGIN_WIDTH;
         _imageLoader.x = -(_imageLoader.width / 2);
         _imageLoader.y = -(targetHeight / 2);
      }
      
      override public function set selected(value:Boolean) : void
      {
         super.selected = value;
         this.updateSelectedVisual();
      }
      
      override protected function updateState() : void
      {
         super.updateState();
         this.updateSelectedVisual();
      }
      
      public function updateSelectedVisual() : *
      {
         if(this.mcCardHighlight)
         {
            if(selected && activeSelectionEnabled)
            {
               this.mcCardHighlight.visible = true;
            }
            else
            {
               this.mcCardHighlight.visible = false;
            }
         }
         if(this.cardElementHolder)
         {
            if(this._cardState == STATE_BOARD && selected && activeSelectionEnabled && this.cardInstance != null && this.cardInstance.inList != CardManager.CARD_LIST_LOC_GRAVEYARD)
            {
               this.cardElementHolder.y = BOARD_SELECTED_Y_OFFSET;
               this.mcHitBox.y = BOARD_SELECTED_Y_OFFSET;
               if(this._cardState == STATE_BOARD)
               {
                  this.mcHitBox.height = CARD_BOARD_HEIGHT + Math.abs(BOARD_SELECTED_Y_OFFSET);
               }
               else
               {
                  this.mcHitBox.height = this.adjCardHeight + Math.abs(BOARD_SELECTED_Y_OFFSET);
               }
            }
            else
            {
               this.cardElementHolder.y = 0;
               this.mcHitBox.y = 0;
               if(this._cardState == STATE_BOARD)
               {
                  this.mcHitBox.height = CARD_BOARD_HEIGHT;
               }
               else
               {
                  this.mcHitBox.height = this.adjCardHeight;
               }
            }
         }
      }
      
      override public function set activeSelectionEnabled(value:Boolean) : void
      {
         super.activeSelectionEnabled = value;
         this.updateSelectedVisual();
      }
      
      override protected function getTargetIndicator() : MovieClip
      {
         if(!_activeSelectionEnabled)
         {
            return null;
         }
         if(_selected)
         {
            return null;
         }
         return null;
      }
      
      override public function set rotationY(value:Number) : void
      {
         var curRotation:Number = NaN;
         super.rotationY = value;
         if(Math.abs(this._lastShadowRotation - value) > this.shadowDelta)
         {
            this._lastShadowRotation = value;
            curRotation = value;
            if(value > this.shadowMax)
            {
               curRotation -= this.shadowMax;
            }
            else if(value < -this.shadowMax)
            {
               curRotation += this.shadowMax;
            }
         }
      }
      
      public function get uplink() : IInventorySlot
      {
         return null;
      }
      
      public function set uplink(value:IInventorySlot) : void
      {
      }
      
      public function get highlight() : Boolean
      {
         return false;
      }
      
      public function set highlight(value:Boolean) : void
      {
      }
      
      override public function toString() : String
      {
         var cardInstance:CardInstance = CardManager.getInstance().getCardInstance(this._instanceId);
         var addInfo:* = "";
         if(cardInstance)
         {
            addInfo = cardInstance.templateRef.getTypeString() + " <" + cardInstance.templateRef.title + ">";
         }
         return "CardSlot [" + this.name + "]  " + addInfo;
      }
      
      protected function handleHitDoubleClick(event:MouseEvent) : void
      {
         var superMouseEvent:MouseEventEx = event as MouseEventEx;
         if(superMouseEvent.buttonIdx == MouseEventEx.LEFT_BUTTON)
         {
            dispatchEvent(new Event(CardMouseDoubleClick,true,false));
         }
      }
      
      protected function handleHitClick(event:MouseEvent) : void
      {
         var superMouseEvent:MouseEventEx = event as MouseEventEx;
         if(superMouseEvent.buttonIdx == MouseEventEx.LEFT_BUTTON)
         {
            dispatchEvent(new Event(CardMouseLeftClick,true,false));
         }
         else if(superMouseEvent.buttonIdx == MouseEventEx.RIGHT_BUTTON)
         {
            dispatchEvent(new Event(CardMouseRightClick,true,false));
         }
      }
      
      override protected function executeDefaultAction(keyCode:Number, event:InputEvent) : void
      {
         if(keyCode == KeyCode.ENTER)
         {
            return;
         }
         super.executeDefaultAction(keyCode,event);
      }
      
      protected function handleHitMouseOver(event:MouseEvent) : void
      {
         dispatchEvent(new Event(CardMouseOver,true,false));
      }
      
      protected function handleHitMouseOut(event:MouseEvent) : void
      {
         dispatchEvent(new Event(CardMouseOut,true,false));
      }
   }
}
