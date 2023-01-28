package
{
   import red.game.witcher3.menus.common.PlayerFullStatsModule;
   
   public dynamic class StatisticsFullRef extends PlayerFullStatsModule
   {
       
      
      public var __id2_:FullStatsItem;
      
      public var __id3_:FullStatsItem;
      
      public var __id0_:FullStatsItem;
      
      public var __id1_:FullStatsItem;
      
      public var __id6_:FullStatsItem;
      
      public var __id7_:FullStatsItem;
      
      public var __id4_:FullStatsItem;
      
      public var __id5_:FullStatsItem;
      
      public var __id8_:FullStatsItem;
      
      public function StatisticsFullRef()
      {
         super();
         this.__setProp_mcList_StatisticsFull_mcList_0();
         this.__setProp___id0__StatisticsFull_majorStatItems_0();
         this.__setProp___id1__StatisticsFull_majorStatItems_0();
         this.__setProp___id2__StatisticsFull_majorStatItems_0();
         this.__setProp___id3__StatisticsFull_majorStatItems_0();
         this.__setProp___id4__StatisticsFull_majorStatItems_0();
         this.__setProp___id5__StatisticsFull_majorStatItems_0();
         this.__setProp___id6__StatisticsFull_majorStatItems_0();
         this.__setProp___id7__StatisticsFull_majorStatItems_0();
         this.__setProp___id8__StatisticsFull_majorStatItems_0();
      }
      
      internal function __setProp_mcList_StatisticsFull_mcList_0() : *
      {
         try
         {
            mcList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcList.DownAction = 40;
         mcList.enabled = true;
         mcList.enableInitCallback = false;
         mcList.focusable = false;
         mcList.itemRendererName = "";
         mcList.itemRendererInstanceName = "mcAdaptiveStatsListItem";
         mcList.margin = 0;
         mcList.inspectablePadding = {
            "top":0,
            "right":0,
            "bottom":0,
            "left":0
         };
         mcList.PCDownAction = 83;
         mcList.PCUpAction = 87;
         mcList.rowHeight = 0;
         mcList.scrollBar = "mcScrollbar";
         mcList.UpAction = 38;
         mcList.visible = true;
         mcList.wrapping = "normal";
         try
         {
            mcList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp___id0__StatisticsFull_majorStatItems_0() : *
      {
         try
         {
            this.__id0_["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.__id0_.autoRepeat = false;
         this.__id0_.autoSize = "none";
         this.__id0_.data = "";
         this.__id0_.enabled = true;
         this.__id0_.enableInitCallback = false;
         this.__id0_.label = "";
         this.__id0_.selected = false;
         this.__id0_.statID = "majorStat1";
         this.__id0_.toggle = false;
         this.__id0_.visible = true;
         try
         {
            this.__id0_["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp___id1__StatisticsFull_majorStatItems_0() : *
      {
         try
         {
            this.__id1_["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.__id1_.autoRepeat = false;
         this.__id1_.autoSize = "none";
         this.__id1_.data = "";
         this.__id1_.enabled = true;
         this.__id1_.enableInitCallback = false;
         this.__id1_.label = "";
         this.__id1_.selected = false;
         this.__id1_.statID = "mainMagicStat";
         this.__id1_.toggle = false;
         this.__id1_.visible = true;
         try
         {
            this.__id1_["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp___id2__StatisticsFull_majorStatItems_0() : *
      {
         try
         {
            this.__id2_["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.__id2_.autoRepeat = false;
         this.__id2_.autoSize = "none";
         this.__id2_.data = "";
         this.__id2_.enabled = true;
         this.__id2_.enableInitCallback = false;
         this.__id2_.label = "";
         this.__id2_.selected = false;
         this.__id2_.statID = "mainSilverStat";
         this.__id2_.toggle = false;
         this.__id2_.visible = true;
         try
         {
            this.__id2_["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp___id3__StatisticsFull_majorStatItems_0() : *
      {
         try
         {
            this.__id3_["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.__id3_.autoRepeat = false;
         this.__id3_.autoSize = "none";
         this.__id3_.data = "";
         this.__id3_.enabled = true;
         this.__id3_.enableInitCallback = false;
         this.__id3_.label = "";
         this.__id3_.selected = false;
         this.__id3_.statID = "mainSteelStat";
         this.__id3_.toggle = false;
         this.__id3_.visible = true;
         try
         {
            this.__id3_["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp___id4__StatisticsFull_majorStatItems_0() : *
      {
         try
         {
            this.__id4_["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.__id4_.autoRepeat = false;
         this.__id4_.autoSize = "none";
         this.__id4_.data = "";
         this.__id4_.enabled = true;
         this.__id4_.enableInitCallback = false;
         this.__id4_.label = "";
         this.__id4_.selected = false;
         this.__id4_.statID = "mainResStat";
         this.__id4_.toggle = false;
         this.__id4_.visible = true;
         try
         {
            this.__id4_["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp___id5__StatisticsFull_majorStatItems_0() : *
      {
         try
         {
            this.__id5_["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.__id5_.autoRepeat = false;
         this.__id5_.autoSize = "none";
         this.__id5_.data = "";
         this.__id5_.enabled = true;
         this.__id5_.enableInitCallback = false;
         this.__id5_.label = "";
         this.__id5_.selected = false;
         this.__id5_.statID = "majorStat2";
         this.__id5_.toggle = false;
         this.__id5_.visible = true;
         try
         {
            this.__id5_["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp___id6__StatisticsFull_majorStatItems_0() : *
      {
         try
         {
            this.__id6_["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.__id6_.autoRepeat = false;
         this.__id6_.autoSize = "none";
         this.__id6_.data = "";
         this.__id6_.enabled = true;
         this.__id6_.enableInitCallback = false;
         this.__id6_.label = "";
         this.__id6_.selected = false;
         this.__id6_.statID = "majorStat3";
         this.__id6_.toggle = false;
         this.__id6_.visible = true;
         try
         {
            this.__id6_["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp___id7__StatisticsFull_majorStatItems_0() : *
      {
         try
         {
            this.__id7_["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.__id7_.autoRepeat = false;
         this.__id7_.autoSize = "none";
         this.__id7_.data = "";
         this.__id7_.enabled = true;
         this.__id7_.enableInitCallback = false;
         this.__id7_.label = "";
         this.__id7_.selected = false;
         this.__id7_.statID = "majorStat4";
         this.__id7_.toggle = false;
         this.__id7_.visible = true;
         try
         {
            this.__id7_["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp___id8__StatisticsFull_majorStatItems_0() : *
      {
         try
         {
            this.__id8_["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.__id8_.autoRepeat = false;
         this.__id8_.autoSize = "none";
         this.__id8_.data = "";
         this.__id8_.enabled = true;
         this.__id8_.enableInitCallback = false;
         this.__id8_.label = "";
         this.__id8_.selected = false;
         this.__id8_.statID = "majorStat5";
         this.__id8_.toggle = false;
         this.__id8_.visible = true;
         try
         {
            this.__id8_["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
