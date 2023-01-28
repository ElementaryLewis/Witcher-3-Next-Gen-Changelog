package red.game.witcher3.menus.worldmap
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Exponential;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   import red.game.witcher3.events.MapAnimation;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.core.UIComponent;
   
   public class UniverseMapContainer extends UIComponent
   {
      
      protected static const SCROLL_ANIM_DURATION:Number = 0.1;
      
      protected static const DARK_INTENSITY:Number = 0.8;
       
      
      public var mcUniverseMapImage:MovieClip;
      
      public var mcKaerMorhen:UniverseArea;
      
      public var mcSkellige:UniverseArea;
      
      public var mcWyzima:UniverseArea;
      
      public var mcNovigrad:UniverseArea;
      
      public var mcPrologVillage:UniverseArea;
      
      public var mcNoMansLand:UniverseArea;
      
      public var mcToussaint:UniverseArea;
      
      public var mcKaerMorhen_mask:MovieClip;
      
      public var mcSkellige_mask:MovieClip;
      
      public var mcWyzima_mask:MovieClip;
      
      public var mcNovigrad_mask:MovieClip;
      
      public var mcPrologVillage_mask:MovieClip;
      
      public var mcNoMansLand_mask:MovieClip;
      
      public var mcToussaint_mask:MovieClip;
      
      protected var m_hubs:Vector.<UniverseArea>;
      
      private const m_scale = 1;
      
      private var currentArea:UniverseArea;
      
      private var _scrollTween:GTween;
      
      private var _mapCopy:MovieClip;
      
      private var _mapCopyMask:MovieClip;
      
      private var _areaContainer:Sprite;
      
      private var _currentAreaMask:Sprite;
      
      private var _darkOverlay:Sprite;
      
      public function UniverseMapContainer()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.m_hubs = new Vector.<UniverseArea>();
         this.m_hubs.push(this.mcKaerMorhen);
         this.m_hubs.push(this.mcSkellige);
         this.m_hubs.push(this.mcWyzima);
         this.m_hubs.push(this.mcNovigrad);
         this.m_hubs.push(this.mcPrologVillage);
         this.m_hubs.push(this.mcNoMansLand);
         this.m_hubs.push(this.mcToussaint);
         this._areaContainer = new Sprite();
         addChild(this._areaContainer);
         this.mcKaerMorhen_mask.visible = false;
         this.mcSkellige_mask.visible = false;
         this.mcWyzima_mask.visible = false;
         this.mcNovigrad_mask.visible = false;
         this.mcPrologVillage_mask.visible = false;
         this.mcNoMansLand_mask.visible = false;
         this.mcToussaint_mask.visible = false;
         this.mcNovigrad.SetWorldName("novigrad");
         this.mcSkellige.SetWorldName("skellige");
         this.mcKaerMorhen.SetWorldName("kaer_morhen");
         this.mcPrologVillage.SetWorldName("prolog_village");
         this.mcWyzima.SetWorldName("wyzima_castle");
         this.mcNoMansLand.SetWorldName("no_mans_land","novigrad");
         this.mcToussaint.SetWorldName("bob");
         this.mcNovigrad.recLevel = 10;
         this.mcSkellige.recLevel = 16;
         this.mcKaerMorhen.recLevel = 19;
         this.mcPrologVillage.recLevel = 1;
         this.mcWyzima.recLevel = 2;
         this.mcNoMansLand.recLevel = 5;
         this.mcToussaint.recLevel = 35;
         scaleX = actualScaleX * this.m_scale;
         scaleY = actualScaleY * this.m_scale;
         this._darkOverlay = CommonUtils.createSolidColorSprite(getRect(this.mcUniverseMapImage),0,0.3);
         this._darkOverlay.x = this.mcUniverseMapImage.x;
         this._darkOverlay.y = this.mcUniverseMapImage.y;
         this._darkOverlay.visible = false;
      }
      
      private function setupAreas(param1:UniverseArea, param2:int, param3:Vector.<UniverseArea>) : *
      {
         this._areaContainer.addChild(param1);
      }
      
      public function highlightArea(param1:MovieClip) : void
      {
         this.removeHiglighting();
         var _loc2_:Class = getDefinitionByName("UniverseMapImageRef") as Class;
         this._mapCopy = new _loc2_() as MovieClip;
         this._mapCopy.x = this.mcUniverseMapImage.x;
         this._mapCopy.y = this.mcUniverseMapImage.y;
         this._mapCopy.scaleX = this.mcUniverseMapImage.scaleX;
         this._mapCopy.scaleY = this.mcUniverseMapImage.scaleY;
         this._currentAreaMask = getChildByName(param1.name + "_mask") as Sprite;
         this._currentAreaMask.visible = true;
         addChild(this._darkOverlay);
         addChild(this._mapCopy);
         addChild(param1);
         this._mapCopy.mask = this._currentAreaMask;
         GTweener.removeTweens(this._darkOverlay);
         GTweener.to(this._darkOverlay,1,{"alpha":1},{"ease":Exponential.easeOut});
         this._darkOverlay.visible = true;
         this._darkOverlay.alpha = 0;
      }
      
      public function removeHiglighting() : void
      {
         if(this._mapCopy)
         {
            this._mapCopy.mask = null;
            removeChild(this._mapCopy);
            this._mapCopy = null;
         }
         if(this._currentAreaMask)
         {
            this._currentAreaMask.visible = false;
            this._currentAreaMask = null;
         }
         this.mcUniverseMapImage.filters = [];
         GTweener.removeTweens(this._darkOverlay);
         GTweener.to(this._darkOverlay,1,{"alpha":0},{
            "ease":Exponential.easeOut,
            "onComplete":this.handleDarkOverlayHidden
         });
      }
      
      private function handleDarkOverlayHidden(param1:GTween) : void
      {
         this._darkOverlay.visible = false;
      }
      
      private function getDarkFilter(param1:Number) : ColorMatrixFilter
      {
         var _loc2_:Array = new Array();
         _loc2_ = _loc2_.concat([param1,0,0,0,0]);
         _loc2_ = _loc2_.concat([0,param1,0,0,0]);
         _loc2_ = _loc2_.concat([0,0,param1,0,0]);
         _loc2_ = _loc2_.concat([0,0,0,1,0]);
         return new ColorMatrixFilter(_loc2_);
      }
      
      public function centerArea(param1:UniverseArea, param2:Boolean = true, param3:Number = 0.1) : void
      {
         var _loc6_:Number = NaN;
         var _loc4_:Point;
         var _loc5_:Number = -(_loc4_ = globalToLocal(param1.GetCenterPosition())).x * scaleX;
         _loc6_ = -_loc4_.y * scaleY;
         if(param2)
         {
            GTweener.removeTweens(this);
            this._scrollTween = GTweener.to(this,param3,{
               "x":_loc5_,
               "y":_loc6_
            },{"onComplete":this.handleScrollAnim});
         }
         else
         {
            x = _loc5_;
            y = _loc6_;
         }
      }
      
      protected function handleScrollAnim(param1:GTween) : void
      {
         dispatchEvent(new MapAnimation(MapAnimation.AREA_CHANGED,true));
         this._scrollTween = null;
      }
      
      public function centerCurrentArea(param1:Boolean = true, param2:Number = 0.1) : void
      {
         if(this.currentArea)
         {
            this.centerArea(this.currentArea,param1,param2);
         }
      }
      
      public function setCurrentArea(param1:String) : void
      {
         var _loc4_:UniverseArea = null;
         var _loc2_:int = int(this.m_hubs.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if((_loc4_ = this.m_hubs[_loc3_]).GetWorldName() == param1)
            {
               _loc4_.isCurrentArea = true;
               x = -_loc4_.x;
               y = -_loc4_.y;
               this.currentArea = _loc4_;
            }
            else
            {
               _loc4_.isCurrentArea = false;
            }
            _loc3_++;
         }
      }
      
      public function setQuestAreas(param1:Object) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:UniverseArea = null;
         var _loc6_:String = null;
         _loc4_ = int(this.m_hubs.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            (_loc5_ = this.m_hubs[_loc3_]).hasQuest = false;
            _loc3_++;
         }
         if(param1)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               _loc6_ = param1[_loc2_].area as String;
               _loc3_ = 0;
               while(_loc3_ < _loc4_)
               {
                  if((_loc5_ = this.m_hubs[_loc3_]).GetWorldName() == _loc6_)
                  {
                     _loc5_.hasQuest = true;
                  }
                  _loc3_++;
               }
               _loc2_++;
            }
         }
      }
      
      public function ScrollMap(param1:Number, param2:Number) : *
      {
         if(this._scrollTween)
         {
            return;
         }
         x += param1;
         y += param2;
         if(x < -680)
         {
            x = -680;
         }
         else if(x > 530)
         {
            x = 530;
         }
         if(y < -700)
         {
            y = -700;
         }
         else if(y > 570)
         {
            y = 570;
         }
      }
      
      public function GetOveredHub(param1:Point) : UniverseArea
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.m_hubs.length)
         {
            if(this.m_hubs[_loc2_].enabled)
            {
               if(this.m_hubs[_loc2_].mcCenterPosition.hitTestPoint(param1.x,param1.y,true))
               {
                  return this.m_hubs[_loc2_];
               }
            }
            _loc2_++;
         }
         return null;
      }
      
      public function GetHubMapByName(param1:String) : UniverseArea
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.m_hubs.length)
         {
            if(param1 == this.m_hubs[_loc2_].GetWorldName())
            {
               return this.m_hubs[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function GetHubMapAtPoint(param1:Point) : UniverseArea
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.m_hubs.length)
         {
            if(this.m_hubs[_loc2_].mcCenterPosition.hitTestPoint(param1.x,param1.y,true))
            {
               return this.m_hubs[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
   }
}
