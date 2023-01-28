package red.game.witcher3.menus.common
{
   import com.gskinner.motion.GTweener;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   import red.game.witcher3.controls.W3ScrollingList;
   import red.game.witcher3.menus.overlay.BasePopup;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.controls.ScrollBar;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.managers.InputDelegate;
   import scaleform.clik.ui.InputDetails;
   
   public class PlayerFullStatsModule extends BasePopup
   {
       
      
      public var txtTitle:TextField;
      
      public var txtMagicTitle:TextField;
      
      public var txtDamageTitle:TextField;
      
      public var txtResistanceTitle:TextField;
      
      private var statDictionary:Dictionary;
      
      public var mcList:W3ScrollingList;
      
      public var mcAdaptiveStatsListItem1:AdaptiveStatsListItem;
      
      public var mcAdaptiveStatsListItem2:AdaptiveStatsListItem;
      
      public var mcAdaptiveStatsListItem3:AdaptiveStatsListItem;
      
      public var mcAdaptiveStatsListItem4:AdaptiveStatsListItem;
      
      public var mcAdaptiveStatsListItem5:AdaptiveStatsListItem;
      
      public var mcAdaptiveStatsListItem6:AdaptiveStatsListItem;
      
      public var mcAdaptiveStatsListItem7:AdaptiveStatsListItem;
      
      public var mcAdaptiveStatsListItem8:AdaptiveStatsListItem;
      
      public var mcAdaptiveStatsListItem9:AdaptiveStatsListItem;
      
      public var mcAdaptiveStatsListItem10:AdaptiveStatsListItem;
      
      public var mcAdaptiveStatsListItem11:AdaptiveStatsListItem;
      
      public var mcAdaptiveStatsListItem12:AdaptiveStatsListItem;
      
      public var mcAdaptiveStatsListItem13:AdaptiveStatsListItem;
      
      public var mcAdaptiveStatsListItem14:AdaptiveStatsListItem;
      
      public var mcScrollbar:ScrollBar;
      
      public function PlayerFullStatsModule()
      {
         super();
      }
      
      protected function get popupName() : String
      {
         return "CharacterStatsPopup";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         alpha = 0;
         visible = false;
         this.SetupStatDictionary();
         if(_data != null)
         {
            this.show();
         }
         InputDelegate.getInstance().addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
         stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.onScroll,true,0,true);
         this.focused = 1;
      }
      
      override public function set data(param1:Object) : void
      {
         _data = param1;
         if(this.statDictionary != null)
         {
            this.show();
         }
      }
      
      public function show() : void
      {
         visible = true;
         GTweener.removeTweens(this);
         GTweener.to(this,0.2,{"alpha":1},{});
         this.fillStatsData(_data.stats as Array);
         mcInpuFeedback.handleSetupButtons(_data.ButtonsList);
      }
      
      public function hide() : void
      {
         if(visible)
         {
            GTweener.removeTweens(this);
            enabled = false;
            GTweener.to(this,0.2,{"alpha":0},{});
         }
      }
      
      protected function SetupStatDictionary() : void
      {
         var _loc1_:int = 0;
         var _loc2_:W3StatisticsListItem = null;
         this.statDictionary = new Dictionary();
         _loc1_ = 0;
         while(_loc1_ < numChildren)
         {
            _loc2_ = getChildAt(_loc1_) as W3StatisticsListItem;
            if(Boolean(_loc2_) && _loc2_.statID != "")
            {
               this.statDictionary[_loc2_.statID] = _loc2_;
            }
            _loc1_++;
         }
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc2_:InputDetails = param1.details;
         var _loc3_:Boolean = _loc2_.value == InputValue.KEY_DOWN || _loc2_.value == InputValue.KEY_HOLD;
         CommonUtils.convertWASDCodeToNavEquivalent(_loc2_);
         if(_loc3_)
         {
            switch(_loc2_.navEquivalent)
            {
               case NavigationCode.DOWN:
               case NavigationCode.RIGHT_STICK_DOWN:
                  ++this.mcScrollbar.position;
                  break;
               case NavigationCode.UP:
               case NavigationCode.RIGHT_STICK_UP:
                  --this.mcScrollbar.position;
            }
         }
      }
      
      protected function onScroll(param1:MouseEvent) : void
      {
         if(param1.delta > 0)
         {
            --this.mcScrollbar.position;
         }
         else
         {
            ++this.mcScrollbar.position;
         }
         param1.stopImmediatePropagation();
      }
      
      protected function fillStatsData(param1:Array) : void
      {
         var _loc2_:W3StatisticsListItem = null;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:W3StatisticsListItem = null;
         if(!param1)
         {
            throw new Error("GFX - Invalid data array sent to popup");
         }
         for each(_loc2_ in this.statDictionary)
         {
            _loc2_.visible = false;
         }
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1[_loc3_];
            if((_loc5_ = this.statDictionary[_loc4_.tag]) != null)
            {
               _loc5_.visible = true;
               _loc5_.setData(_loc4_);
               param1.splice(_loc3_,1);
            }
            else
            {
               _loc3_++;
            }
         }
         this.mcList.dataProvider = new DataProvider(param1);
      }
   }
}
