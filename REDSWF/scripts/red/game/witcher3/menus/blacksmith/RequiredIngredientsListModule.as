package red.game.witcher3.menus.blacksmith
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   import red.core.CoreComponent;
   import red.core.CoreMenuModule;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.menus.inventory_menu.PinnedCraftingItemInfo;
   import red.game.witcher3.utils.CommonUtils;
   
   public class RequiredIngredientsListModule extends CoreMenuModule
   {
       
      
      private const RENDERER_CLASS_NAME:String = "IngredientRef";
      
      private const BLOCK_PADDING:Number = 5;
      
      private const ROW_PADDING:Number = 20;
      
      public var mcListAnchor:MovieClip;
      
      public var tfName:TextField;
      
      public var tfType:TextField;
      
      public var tfDescription:TextField;
      
      public var tfLevel:TextField;
      
      public var tfIngredientsTitle:TextField;
      
      public var tfHint:TextField;
      
      private var _textValue:String;
      
      private var _canvas:Sprite;
      
      private var _ingredientsList:Vector.<PinnedCraftingItemInfo>;
      
      private var _data:Object;
      
      public function RequiredIngredientsListModule()
      {
         super();
         this._ingredientsList = new Vector.<PinnedCraftingItemInfo>();
         this._canvas = new Sprite();
         this._canvas.x = this.mcListAnchor.x;
         this._canvas.y = this.mcListAnchor.y;
         addChild(this._canvas);
         visible = false;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1;
         this.populateData();
      }
      
      protected function populateData() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:uint = 0;
         var _loc3_:Class = null;
         var _loc4_:int = 0;
         var _loc5_:PinnedCraftingItemInfo = null;
         if(this.data)
         {
            _loc1_ = 0;
            this.cleanupContent();
            this._textValue = this._data.localizedName;
            this.tfName.htmlText = this._textValue;
            this.tfName.htmlText = CommonUtils.toUpperCaseSafe(this._textValue);
            if(CoreComponent.isArabicAligmentMode)
            {
               this.tfName.htmlText = "<p align=\"right\">" + this._textValue + "</p>";
            }
            this._textValue = !!this._data.type ? "[[panel_enchanting_filter_runeword]]" : "[[panel_enchanting_filter_glyphword ]]";
            this.tfType.htmlText = this._textValue;
            if(CoreComponent.isArabicAligmentMode)
            {
               this.tfType.htmlText = "<p align=\"right\">" + this._textValue + "</p>";
            }
            this._textValue = this._data.description;
            this.tfDescription.htmlText = this._textValue;
            if(CoreComponent.isArabicAligmentMode)
            {
               this.tfDescription.htmlText = "<p align=\"right\">" + this._textValue + "</p>";
            }
            this._textValue = this._data.levelName;
            this.tfLevel.text = this._textValue;
            if(CoreComponent.isArabicAligmentMode)
            {
               this.tfLevel.htmlText = "<p align=\"right\">" + this._textValue + "</p>";
            }
            this._textValue = "[[panel_alchemy_required_ingridients]]";
            this.tfIngredientsTitle.htmlText = this._textValue;
            this.tfIngredientsTitle.htmlText = CommonUtils.toUpperCaseSafe(this._textValue);
            if(CoreComponent.isArabicAligmentMode)
            {
               this.tfIngredientsTitle.htmlText = "<p align=\"right\">" + this._textValue + "</p>";
            }
            this._textValue = "[[panel_enchanting_message_warning  ]]";
            this.tfHint.htmlText = this._textValue;
            if(CoreComponent.isArabicAligmentMode)
            {
               this.tfHint.htmlText = "<p align=\"right\">" + this._textValue + "</p>";
            }
            this.tfDescription.height = this.tfDescription.textHeight + CommonConstants.SAFE_TEXT_PADDING;
            _loc1_ = this.tfDescription.y + this.tfDescription.height + this.BLOCK_PADDING;
            _loc1_ += this.ROW_PADDING;
            this.tfIngredientsTitle.y = _loc1_;
            _loc1_ += this.tfIngredientsTitle.textHeight + this.ROW_PADDING;
            this._canvas.y = _loc1_ + this.BLOCK_PADDING;
            if(this.data.ingredientsList)
            {
               _loc2_ = uint(this.data.ingredientsList.length);
               _loc3_ = getDefinitionByName(this.RENDERER_CLASS_NAME) as Class;
               _loc4_ = 0;
               while(_loc4_ < _loc2_)
               {
                  (_loc5_ = new _loc3_() as PinnedCraftingItemInfo).y = this._canvas.height;
                  this._canvas.addChild(_loc5_);
                  _loc5_.validateNow();
                  _loc5_.setItemData(this.data.ingredientsList[_loc4_]);
                  this._ingredientsList.push(_loc5_);
                  _loc4_++;
               }
               _loc1_ += this._canvas.height + this.BLOCK_PADDING;
               this.tfHint.y = _loc1_;
            }
            visible = true;
         }
         else
         {
            visible = false;
         }
      }
      
      protected function cleanupContent() : void
      {
         while(this._ingredientsList.length)
         {
            this._canvas.removeChild(this._ingredientsList.pop());
         }
      }
      
      override public function hasSelectableItems() : Boolean
      {
         return false;
      }
   }
}
