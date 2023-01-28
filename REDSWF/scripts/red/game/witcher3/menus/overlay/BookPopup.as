package red.game.witcher3.menus.overlay
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Sine;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import red.core.CoreComponent;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.ConditionalButton;
   import red.game.witcher3.controls.W3ScrollingList;
   import red.game.witcher3.controls.W3TextArea;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.controls.UILoader;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.clik.interfaces.IListItemRenderer;
   import scaleform.clik.managers.InputDelegate;
   import scaleform.clik.ui.InputDetails;
   
   public class BookPopup extends BasePopup
   {
       
      
      internal const ANIM_OFFSET:Number = 100;
      
      internal const ANIM_DURATION:Number = 0.5;
      
      internal const BTN_DISABLED_ALPHA:Number = 0.3;
      
      public var txtMessage:W3TextArea;
      
      public var txtTitle:TextField;
      
      public var txtCounter:TextField;
      
      public var btnPrior:ConditionalButton;
      
      public var btnNext:ConditionalButton;
      
      public var mcBooksList:W3ScrollingList;
      
      public var mcBookBackground:MovieClip;
      
      public var mcBookRenderer1:BookItemRenderer;
      
      public var mcBookRenderer2:BookItemRenderer;
      
      public var mcBookRenderer3:BookItemRenderer;
      
      public var mcBookRenderer4:BookItemRenderer;
      
      public var mcBookRenderer5:BookItemRenderer;
      
      public var mcBookRenderer6:BookItemRenderer;
      
      protected var _imageLoader:UILoader;
      
      protected var _selectedBookId:int = 0;
      
      protected var _booksCount:int = 0;
      
      protected var _booksList:Array;
      
      protected var _title:String;
      
      protected var _isFirstInit:Boolean = true;
      
      protected var _renderersCanvas:Sprite;
      
      public function BookPopup()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this._isFirstInit = true;
         tabChildren = false;
         this.mcBooksList.addEventListener(ListEvent.INDEX_CHANGE,this.handleIndexChanged,false,0,true);
         this.btnPrior.addEventListener(MouseEvent.CLICK,this.handlePriorClick,false,0,true);
         this.btnNext.addEventListener(MouseEvent.CLICK,this.handleNextClick,false,0,true);
         InputDelegate.getInstance().addEventListener(InputEvent.INPUT,this.handleInput,false,1000,true);
      }
      
      override protected function populateData() : void
      {
         super.populateData();
         removeEventListener(Event.ENTER_FRAME,this.validateDataPopulation,false);
         addEventListener(Event.ENTER_FRAME,this.validateDataPopulation,false,0,true);
      }
      
      protected function validateDataPopulation(param1:Event = null) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Vector.<IListItemRenderer> = null;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:Rectangle = null;
         var _loc7_:* = new Namespace("");
         var _loc8_:BookItemRenderer = null;
         removeEventListener(Event.ENTER_FRAME,this.validateDataPopulation,false);
         mcInpuFeedback.handleSetupButtons(_data.ButtonsList);
         this.txtMessage.focused = 1;
         this._booksList = _data.newBooksList as Array;
         if(Boolean(this._booksList) && this._booksList.length > 0)
         {
            this._booksList.sortOn("isQuestItem",Array.DESCENDING);
            _loc2_ = {};
            if(_data.iconPath)
            {
               _loc2_.itemId = _data.itemId;
               _loc2_.iconPath = _data.iconPath;
               _loc2_.isNewItem = _data.isNewItem;
               _loc2_.isQuestItem = _data.isQuestItem;
               _loc2_.TextTitle = _data.TextTitle;
               _loc2_.TextContent = _data.TextContent;
               _loc2_.isNewItem = _data.isNewItem;
               _loc2_.questTag = _data.questTag;
               this._booksList.unshift(_loc2_);
            }
         }
         if(Boolean(this._booksList) && Boolean(this._booksList.length))
         {
            this._booksCount = this._booksList.length;
            this.mcBooksList.dataProvider = new DataProvider(this._booksList);
            this.mcBooksList.selectedIndex = 0;
            this.txtCounter.visible = true;
            this.txtCounter.text = "0/" + this._booksCount;
            if(this._booksCount < 6)
            {
               _loc3_ = this.mcBooksList.getRenderers();
               this._renderersCanvas = new Sprite();
               addChild(this._renderersCanvas);
               _loc4_ = 0;
               while(_loc4_ < this._booksCount && _loc4_ < _loc3_.length)
               {
                  if(_loc8_ = _loc3_[_loc4_] as BookItemRenderer)
                  {
                     this._renderersCanvas.addChild(_loc8_);
                  }
                  _loc4_++;
               }
               _loc5_ = this.mcBookRenderer1.x;
               _loc6_ = this._renderersCanvas.getBounds(this);
               this._renderersCanvas.x = this.mcBookBackground.x + (this.mcBookBackground.width - this._renderersCanvas.width) / 2 - _loc5_;
               _loc7_ = 20;
               if(this._booksCount > 1)
               {
                  this.btnPrior.x = this._renderersCanvas.x + _loc5_ - _loc7_;
                  this.btnNext.x = this._renderersCanvas.x + this._renderersCanvas.width + _loc5_ + _loc7_;
               }
               else
               {
                  this.btnPrior.alpha = 0;
                  this.btnNext.alpha = 0;
               }
            }
            this.populateSingleBookData(this._booksList[0],false);
         }
         else
         {
            this._booksCount = 0;
            this.btnPrior.alpha = 0;
            this.btnNext.alpha = 0;
            this.txtCounter.visible = false;
            if(_data.iconPath)
            {
               this._imageLoader = new UILoader();
               this._imageLoader.source = _data.iconPath;
               this._imageLoader.x = this.mcBooksList.x + (this.mcBooksList.width - 64) / 2;
               this._imageLoader.y = this.mcBooksList.y;
               addChild(this._imageLoader);
            }
            this.populateSingleBookData(_data,false);
         }
      }
      
      protected function populateSingleBookData(param1:Object, param2:Boolean = false) : void
      {
         if(CoreComponent.isArabicAligmentMode)
         {
            this.txtMessage.htmlText = "<p align=\"right\">" + param1.TextContent + "</p>";
         }
         else
         {
            this.txtMessage.htmlText = param1.TextContent;
         }
         this._title = param1.TextTitle;
         GTweener.removeTweens(this.txtTitle);
         GTweener.removeTweens(this.txtMessage);
         if(!this._isFirstInit)
         {
            GTweener.to(this.txtTitle,this.ANIM_DURATION / 2,{"alpha":0},{
               "ease":Sine.easeIn,
               "onComplete":this.onTitleHidden
            });
            GTweener.to(this.txtMessage,this.ANIM_DURATION / 2,{"alpha":0},{
               "ease":Sine.easeIn,
               "onComplete":this.onTitleHidden
            });
         }
         else
         {
            this._isFirstInit = false;
            this.txtTitle.htmlText = CommonUtils.toUpperCaseSafe(this._title);
            this.txtTitle.alpha = 1;
         }
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnBookRead",[uint(param1.itemId)]));
      }
      
      private function handleIndexChanged(param1:ListEvent) : void
      {
         if(param1.itemData)
         {
            param1.itemData.isNewItem = false;
            this.populateSingleBookData(param1.itemData);
         }
         if(param1.itemRenderer)
         {
            param1.itemRenderer["mcNewIcon"].visible = false;
         }
         this.txtCounter.text = param1.index + 1 + "/" + this._booksCount;
         this.btnPrior.alpha = param1.index > 0 ? 1 : this.BTN_DISABLED_ALPHA;
         this.btnNext.alpha = param1.index < this._booksCount - 1 ? 1 : this.BTN_DISABLED_ALPHA;
      }
      
      private function onTitleHidden(param1:GTween) : void
      {
         this.txtTitle.htmlText = CommonUtils.toUpperCaseSafe(this._title);
         GTweener.to(this.txtTitle,this.ANIM_DURATION / 2,{"alpha":1},{"ease":Sine.easeOut});
         GTweener.to(this.txtMessage,this.ANIM_DURATION / 2,{"alpha":1},{"ease":Sine.easeOut});
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         super.handleInput(param1);
         var _loc2_:InputDetails = param1.details;
         if(this._booksCount < 1 || param1.handled || _loc2_.value == InputValue.KEY_UP)
         {
            return;
         }
         switch(_loc2_.navEquivalent)
         {
            case NavigationCode.LEFT:
               this.selectPriorBook();
               param1.handled = true;
               break;
            case NavigationCode.RIGHT:
               this.selectNextBook();
               param1.handled = true;
         }
         if(!param1.handled)
         {
            switch(_loc2_.code)
            {
               case KeyCode.A:
                  this.selectPriorBook();
                  param1.handled = true;
                  break;
               case KeyCode.D:
                  this.selectNextBook();
                  param1.handled = true;
            }
         }
      }
      
      private function handleNextClick(param1:MouseEvent) : void
      {
         this.selectNextBook();
      }
      
      private function handlePriorClick(param1:MouseEvent) : void
      {
         this.selectPriorBook();
      }
      
      private function selectNextBook() : void
      {
         if(this.mcBooksList.selectedIndex < this._booksCount - 1)
         {
            ++this.mcBooksList.selectedIndex;
         }
      }
      
      private function selectPriorBook() : void
      {
         if(this.mcBooksList.selectedIndex > 0)
         {
            --this.mcBooksList.selectedIndex;
         }
      }
   }
}
