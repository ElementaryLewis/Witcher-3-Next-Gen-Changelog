package red.game.witcher3.menus.blacksmith
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.InputFeedbackButton;
   import red.game.witcher3.controls.W3UILoaderSlot;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.constants.InvalidationType;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.events.ButtonEvent;
   
   public class BlacksmithItemPanel extends UIComponent
   {
      
      private static const ICON_PADDING:Number = 0;
      
      private static const PRICE_COLOR_ENOUGH:Number = 16777215;
      
      private static const PRICE_COLOR_NOT_ENOUGH:Number = 15138816;
      
      private static const SOCKET_PADDING:Number = 2;
      
      private static const SOCKET_OFFSET:Number = -35;
      
      private static const SOCKET_REF:String = "SlotSocketRef";
       
      
      public var txtEquipped:TextField;
      
      public var txtPriceLabel:TextField;
      
      public var txtPriceValue:TextField;
      
      public var imageHolder:MovieClip;
      
      public var mcItemQuality:MovieClip;
      
      public var mcProgressBar:MovieClip;
      
      public var mcCoinIcon:Sprite;
      
      public var price_frame:MovieClip;
      
      protected var _imageLoader:W3UILoaderSlot;
      
      protected var _inProgress:Boolean;
      
      protected var _data:Object;
      
      protected var _playerMoney:int;
      
      protected var _itemCost:int;
      
      public var btnExecute:InputFeedbackButton;
      
      public var buttonCallback:Function;
      
      private var _slotsItems:Vector.<MovieClip>;
      
      public function BlacksmithItemPanel()
      {
         this._slotsItems = new Vector.<MovieClip>();
         super();
         if(this.txtEquipped)
         {
            this.txtEquipped.visible = false;
         }
         this.txtPriceLabel.text = "[[panel_inventory_item_price]]";
         this.txtPriceLabel.text = CommonUtils.toUpperCaseSafe(this.txtPriceLabel.text);
         this._playerMoney = int.MAX_VALUE;
         this._itemCost = 0;
         if(this.btnExecute)
         {
            this.btnExecute.visible = false;
            this.btnExecute.addEventListener(ButtonEvent.CLICK,this.handleButtonClick,false,0,true);
         }
         this.mcProgressBar.addEventListener(Event.COMPLETE,this.handleProgressComplete,false,0,true);
      }
      
      public function playErrorAnimation() : void
      {
      }
      
      public function setButtonData(param1:String, param2:String, param3:int) : void
      {
         if(this.btnExecute)
         {
            this.btnExecute.label = param1;
            this.btnExecute.setDataFromStage(param2,param3);
            this.btnExecute.visible = true;
            this.btnExecute.validateNow();
            invalidateSize();
         }
      }
      
      override protected function draw() : void
      {
         super.draw();
         if(isInvalid(InvalidationType.SIZE))
         {
            if(Boolean(this.imageHolder) && Boolean(this.btnExecute))
            {
            }
         }
      }
      
      public function get playerMoney() : int
      {
         return this._playerMoney;
      }
      
      public function set playerMoney(param1:int) : void
      {
         this._playerMoney = param1;
         this.txtPriceValue.textColor = this._playerMoney < this._itemCost ? uint(PRICE_COLOR_NOT_ENOUGH) : uint(PRICE_COLOR_ENOUGH);
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1;
         this.updateData();
      }
      
      public function cleanup() : void
      {
         this.cleanupView();
      }
      
      public function isInProgress() : Boolean
      {
         return this._inProgress;
      }
      
      public function showProcessAnimation() : void
      {
         this._inProgress = true;
         this.mcProgressBar.gotoAndPlay(2);
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnStartCrafting"));
      }
      
      public function stopProcess() : void
      {
         this._inProgress = false;
         this.mcProgressBar.gotoAndStop(1);
      }
      
      protected function updateData() : void
      {
         this.cleanupView();
         if(Boolean(this.mcItemQuality) && Boolean(this._data.quality))
         {
            this.mcItemQuality.gotoAndStop(this.data.quality);
         }
         if(Boolean(this._data.iconPath) && Boolean(this.imageHolder))
         {
            this._imageLoader = new W3UILoaderSlot();
            this._imageLoader.source = this._data.iconPath;
            this._imageLoader.addEventListener(Event.COMPLETE,this.handleImageLoaded,false,0,true);
            this.imageHolder.addChild(this._imageLoader);
         }
         if(this._data.actionPriceTotal)
         {
            this._itemCost = this._data.actionPriceTotal;
         }
         else
         {
            this._itemCost = this._data.actionPrice;
         }
         if(this._itemCost)
         {
            this.txtPriceLabel.visible = true;
            this.txtPriceValue.text = this._itemCost.toString();
            if(this.price_frame)
            {
               this.price_frame.visible = true;
            }
            this.txtPriceValue.textColor = this._playerMoney < this._itemCost ? uint(PRICE_COLOR_NOT_ENOUGH) : uint(PRICE_COLOR_ENOUGH);
            this.mcCoinIcon.visible = true;
         }
         if(!this.txtEquipped)
         {
         }
         visible = true;
      }
      
      protected function handleButtonClick(param1:ButtonEvent) : void
      {
         if(this.buttonCallback != null)
         {
            this.buttonCallback();
         }
      }
      
      protected function cleanupView() : void
      {
         if(this._imageLoader)
         {
            this._imageLoader.removeEventListener(Event.COMPLETE,this.handleImageLoaded);
            this._imageLoader.unload();
            this.imageHolder.removeChild(this._imageLoader);
         }
         if(!this.txtEquipped)
         {
         }
         if(this.price_frame)
         {
            this.price_frame.visible = false;
         }
         this.mcCoinIcon.visible = false;
         this.txtPriceValue.text = "";
         this.txtPriceLabel.visible = false;
         if(this.imageHolder)
         {
            this.updateSlots(0,this.imageHolder);
         }
      }
      
      private function handleProgressComplete(param1:Event) : void
      {
         dispatchEvent(param1);
         this._inProgress = false;
      }
      
      private function handleImageLoaded(param1:Event) : void
      {
         if(this._imageLoader)
         {
            this._imageLoader.x = -Math.round(this._imageLoader.actualWidth / 2);
            this._imageLoader.y = -Math.round(this._imageLoader.actualHeight / 2);
         }
      }
      
      public function updateSlots(param1:int, param2:MovieClip) : void
      {
         var _loc3_:int = 0;
         var _loc6_:MovieClip = null;
         if(isNaN(param1))
         {
            param1 = 0;
         }
         var _loc4_:Class = getDefinitionByName(SOCKET_REF) as Class;
         while(this._slotsItems.length > param1)
         {
            param2.removeChild(this._slotsItems.pop());
         }
         while(this._slotsItems.length < param1)
         {
            _loc6_ = new _loc4_() as MovieClip;
            param2.addChild(_loc6_);
            this._slotsItems.push(_loc6_);
         }
         var _loc5_:Number = parent.height;
         _loc3_ = 0;
         while(_loc3_ < param1)
         {
            this._slotsItems[_loc3_].x = SOCKET_OFFSET;
            this._slotsItems[_loc3_].y = (SOCKET_PADDING + this._slotsItems[_loc3_].height) * _loc3_ + SOCKET_OFFSET;
            _loc3_++;
         }
      }
   }
}
