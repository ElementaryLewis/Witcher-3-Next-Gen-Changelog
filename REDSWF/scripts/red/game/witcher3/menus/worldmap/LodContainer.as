package red.game.witcher3.menus.worldmap
{
   import flash.utils.getDefinitionByName;
   import scaleform.clik.core.UIComponent;
   
   public class LodContainer extends UIComponent
   {
       
      
      private var _backgroundContainer:ImageContainer;
      
      private var _imageContainer:Vector.<ImageContainer>;
      
      private var _currentLod:int = -1;
      
      private var _minLod:int;
      
      private var _maxLod:int;
      
      public function LodContainer()
      {
         super();
      }
      
      public function GetContainer(param1:int) : ImageContainer
      {
         if(param1 >= 0 && param1 < this._imageContainer.length)
         {
            return this._imageContainer[param1];
         }
         return null;
      }
      
      public function GetCurrentContainer() : ImageContainer
      {
         return this.GetContainer(this._currentLod);
      }
      
      public function GetMinLod() : int
      {
         return this._minLod;
      }
      
      public function GetMaxLod() : int
      {
         return this._maxLod;
      }
      
      public function GetCurrentLod() : int
      {
         return this._currentLod;
      }
      
      public function SetCurrentLod(param1:int, param2:Boolean) : *
      {
         if(param2)
         {
            addChild(this._imageContainer[this._currentLod]);
         }
         this._currentLod = param1;
      }
      
      public function CreateLods(param1:int, param2:int, param3:int, param4:String, param5:int, param6:int, param7:int, param8:int) : *
      {
         var _loc11_:ImageContainer = null;
         this.DeleteLods();
         this._minLod = param2;
         this._maxLod = param3;
         this._imageContainer = new Vector.<ImageContainer>();
         var _loc9_:Class = getDefinitionByName("ImageContainer") as Class;
         this._backgroundContainer = new _loc9_();
         this._backgroundContainer.CreateLod(param1,0,param4,param5,param6,param7,param8);
         this._backgroundContainer.ShowAllTiles();
         addChild(this._backgroundContainer);
         var _loc10_:* = 0;
         while(_loc10_ <= param3)
         {
            if(_loc10_ < param2)
            {
               this._imageContainer[_loc10_] = null;
            }
            else
            {
               _loc11_ = new _loc9_();
               addChild(_loc11_);
               _loc11_.CreateLod(param1,_loc10_,param4,param5,param6,param7,param8);
               this._imageContainer[_loc10_] = _loc11_;
            }
            _loc10_++;
         }
         this.SetCurrentLod(param3,false);
      }
      
      private function DeleteLods() : *
      {
         var _loc1_:int = 0;
         var _loc2_:ImageContainer = null;
         if(this._backgroundContainer)
         {
            this._backgroundContainer.DeleteTiles();
            removeChild(this._backgroundContainer);
            this._backgroundContainer = null;
         }
         if(this._imageContainer)
         {
            _loc1_ = 0;
            while(_loc1_ < this._imageContainer.length)
            {
               _loc2_ = this._imageContainer[_loc1_];
               if(_loc2_)
               {
                  _loc2_.DeleteTiles();
                  removeChild(_loc2_);
               }
               _loc1_++;
            }
            this._imageContainer = null;
         }
      }
      
      public function UpdateDebugBorders() : *
      {
         var _loc1_:ImageContainer = this.GetCurrentContainer();
         if(_loc1_)
         {
            _loc1_.UpdateDebugBorders();
         }
      }
   }
}
