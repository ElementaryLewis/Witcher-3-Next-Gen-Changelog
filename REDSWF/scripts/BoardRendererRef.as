package
{
   import red.game.witcher3.menus.gwint.GwintBoardRenderer;
   
   public dynamic class BoardRendererRef extends GwintBoardRenderer
   {
       
      
      public function BoardRendererRef()
      {
         super();
         this.__setProp_mcP1Hand_BoardRenderer_mcP1Hand_0();
         this.__setProp_mcP2Hand_BoardRenderer_mcP2Hand_0();
         this.__setProp_mcP1Graveyard_BoardRenderer_mcP1Graveyard_0();
         this.__setProp_mcP2Graveyard_BoardRenderer_mcP2Graveyard_0();
         this.__setProp_mcP1Deck_BoardRenderer_mcP1Deck_0();
         this.__setProp_mcP2Deck_BoardRenderer_mcP2Deck_0();
         this.__setProp_mcWeather_BoardRenderer_mcWeather_0();
         this.__setProp_mcP1Siege_BoardRenderer_mcP1Siege_0();
         this.__setProp_mcP1Range_BoardRenderer_mcP1Range_0();
         this.__setProp_mcP1Melee_BoardRenderer_mcP1Melee_0();
         this.__setProp_mcP2Melee_BoardRenderer_mcP2Melee_0();
         this.__setProp_mcP2Range_BoardRenderer_mcP2Range_0();
         this.__setProp_mcP2Siege_BoardRenderer_mcP2Siege_0();
         this.__setProp_mcP1SiegeModif_BoardRenderer_mcP1SiegeModif_0();
         this.__setProp_mcP1RangeModif_BoardRenderer_mcP1RangeModif_0();
         this.__setProp_mcP1MeleeModif_BoardRenderer_mcP1MeleeModif_0();
         this.__setProp_mcP2MeleeModif_BoardRenderer_mcP2MeleeModif_0();
         this.__setProp_mcP2RangeModif_BoardRenderer_mcP2RangeModif_0();
         this.__setProp_mcP2SiegeModif_BoardRenderer_mcP2SiegeModif_0();
         this.__setProp_mcP1LeaderHolder_BoardRenderer_mcP1LeaderHolder_0();
         this.__setProp_mcP2LeaderHolder_BoardRenderer_mcP2LeaderHolder_0();
      }
      
      internal function __setProp_mcP1Hand_BoardRenderer_mcP1Hand_0() : *
      {
         try
         {
            mcP1Hand["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcP1Hand.cardHolderID = 1;
         mcP1Hand.draggingEnabled = true;
         mcP1Hand.enabled = true;
         mcP1Hand.enableInitCallback = false;
         mcP1Hand.gridSize = 1;
         mcP1Hand.navigationDown = -1;
         mcP1Hand.navigationLeft = 19;
         mcP1Hand.navigationRight = 3;
         mcP1Hand.navigationUp = 10;
         mcP1Hand.playerID = 0;
         mcP1Hand.selectable = true;
         mcP1Hand.uniqueID = 11;
         mcP1Hand.visible = true;
         try
         {
            mcP1Hand["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcP2Hand_BoardRenderer_mcP2Hand_0() : *
      {
         try
         {
            mcP2Hand["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcP2Hand.cardHolderID = 1;
         mcP2Hand.draggingEnabled = true;
         mcP2Hand.enabled = true;
         mcP2Hand.enableInitCallback = false;
         mcP2Hand.gridSize = 1;
         mcP2Hand.navigationDown = 11;
         mcP2Hand.navigationLeft = 11;
         mcP2Hand.navigationRight = 11;
         mcP2Hand.navigationUp = 11;
         mcP2Hand.playerID = 1;
         mcP2Hand.selectable = false;
         mcP2Hand.uniqueID = 4;
         mcP2Hand.visible = true;
         try
         {
            mcP2Hand["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcP1Graveyard_BoardRenderer_mcP1Graveyard_0() : *
      {
         try
         {
            mcP1Graveyard["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcP1Graveyard.cardHolderID = 2;
         mcP1Graveyard.draggingEnabled = true;
         mcP1Graveyard.enabled = true;
         mcP1Graveyard.enableInitCallback = false;
         mcP1Graveyard.gridSize = 1;
         mcP1Graveyard.navigationDown = -1;
         mcP1Graveyard.navigationLeft = 11;
         mcP1Graveyard.navigationRight = -1;
         mcP1Graveyard.navigationUp = 10;
         mcP1Graveyard.playerID = 0;
         mcP1Graveyard.selectable = true;
         mcP1Graveyard.uniqueID = 3;
         mcP1Graveyard.visible = true;
         try
         {
            mcP1Graveyard["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcP2Graveyard_BoardRenderer_mcP2Graveyard_0() : *
      {
         try
         {
            mcP2Graveyard["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcP2Graveyard.cardHolderID = 2;
         mcP2Graveyard.draggingEnabled = true;
         mcP2Graveyard.enabled = true;
         mcP2Graveyard.enableInitCallback = false;
         mcP2Graveyard.gridSize = 1;
         mcP2Graveyard.navigationDown = 6;
         mcP2Graveyard.navigationLeft = 5;
         mcP2Graveyard.navigationRight = -1;
         mcP2Graveyard.navigationUp = -1;
         mcP2Graveyard.playerID = 1;
         mcP2Graveyard.selectable = true;
         mcP2Graveyard.uniqueID = 1;
         mcP2Graveyard.visible = true;
         try
         {
            mcP2Graveyard["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcP1Deck_BoardRenderer_mcP1Deck_0() : *
      {
         try
         {
            mcP1Deck["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcP1Deck.cardHolderID = 0;
         mcP1Deck.draggingEnabled = true;
         mcP1Deck.enabled = true;
         mcP1Deck.enableInitCallback = false;
         mcP1Deck.gridSize = 1;
         mcP1Deck.navigationDown = 0;
         mcP1Deck.navigationLeft = 0;
         mcP1Deck.navigationRight = 0;
         mcP1Deck.navigationUp = 0;
         mcP1Deck.playerID = 0;
         mcP1Deck.selectable = false;
         mcP1Deck.uniqueID = 2;
         mcP1Deck.visible = false;
         try
         {
            mcP1Deck["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcP2Deck_BoardRenderer_mcP2Deck_0() : *
      {
         try
         {
            mcP2Deck["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcP2Deck.cardHolderID = 0;
         mcP2Deck.draggingEnabled = true;
         mcP2Deck.enabled = true;
         mcP2Deck.enableInitCallback = false;
         mcP2Deck.gridSize = 1;
         mcP2Deck.navigationDown = 0;
         mcP2Deck.navigationLeft = 0;
         mcP2Deck.navigationRight = 0;
         mcP2Deck.navigationUp = 0;
         mcP2Deck.playerID = 1;
         mcP2Deck.selectable = false;
         mcP2Deck.uniqueID = 0;
         mcP2Deck.visible = false;
         try
         {
            mcP2Deck["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcWeather_BoardRenderer_mcWeather_0() : *
      {
         try
         {
            mcWeather["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcWeather.cardHolderID = 9;
         mcWeather.draggingEnabled = true;
         mcWeather.enabled = true;
         mcWeather.enableInitCallback = false;
         mcWeather.gridSize = 1;
         mcWeather.navigationDown = 19;
         mcWeather.navigationLeft = -1;
         mcWeather.navigationRight = 15;
         mcWeather.navigationUp = 20;
         mcWeather.paddingX = 3;
         mcWeather.paddingY = 5;
         mcWeather.playerID = -1;
         mcWeather.selectable = true;
         mcWeather.uniqueID = 18;
         mcWeather.visible = true;
         try
         {
            mcWeather["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcP1Siege_BoardRenderer_mcP1Siege_0() : *
      {
         try
         {
            mcP1Siege["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcP1Siege.cardHolderID = 3;
         mcP1Siege.draggingEnabled = true;
         mcP1Siege.enabled = true;
         mcP1Siege.enableInitCallback = false;
         mcP1Siege.gridSize = 1;
         mcP1Siege.navigationDown = 11;
         mcP1Siege.navigationLeft = 17;
         mcP1Siege.navigationRight = 3;
         mcP1Siege.navigationUp = 9;
         mcP1Siege.playerID = 0;
         mcP1Siege.selectable = true;
         mcP1Siege.uniqueID = 10;
         mcP1Siege.visible = true;
         try
         {
            mcP1Siege["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcP1Range_BoardRenderer_mcP1Range_0() : *
      {
         try
         {
            mcP1Range["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcP1Range.cardHolderID = 4;
         mcP1Range.draggingEnabled = true;
         mcP1Range.enabled = true;
         mcP1Range.enableInitCallback = false;
         mcP1Range.gridSize = 1;
         mcP1Range.navigationDown = 10;
         mcP1Range.navigationLeft = 16;
         mcP1Range.navigationRight = 3;
         mcP1Range.navigationUp = 8;
         mcP1Range.playerID = 0;
         mcP1Range.selectable = true;
         mcP1Range.uniqueID = 9;
         mcP1Range.visible = true;
         try
         {
            mcP1Range["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcP1Melee_BoardRenderer_mcP1Melee_0() : *
      {
         try
         {
            mcP1Melee["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcP1Melee.cardHolderID = 5;
         mcP1Melee.draggingEnabled = true;
         mcP1Melee.enabled = true;
         mcP1Melee.enableInitCallback = false;
         mcP1Melee.gridSize = 1;
         mcP1Melee.navigationDown = 9;
         mcP1Melee.navigationLeft = 15;
         mcP1Melee.navigationRight = 3;
         mcP1Melee.navigationUp = 7;
         mcP1Melee.playerID = 0;
         mcP1Melee.selectable = true;
         mcP1Melee.uniqueID = 8;
         mcP1Melee.visible = true;
         try
         {
            mcP1Melee["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcP2Melee_BoardRenderer_mcP2Melee_0() : *
      {
         try
         {
            mcP2Melee["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcP2Melee.cardHolderID = 5;
         mcP2Melee.draggingEnabled = true;
         mcP2Melee.enabled = true;
         mcP2Melee.enableInitCallback = false;
         mcP2Melee.gridSize = 1;
         mcP2Melee.navigationDown = 8;
         mcP2Melee.navigationLeft = 14;
         mcP2Melee.navigationRight = 1;
         mcP2Melee.navigationUp = 6;
         mcP2Melee.playerID = 1;
         mcP2Melee.selectable = true;
         mcP2Melee.uniqueID = 7;
         mcP2Melee.visible = true;
         try
         {
            mcP2Melee["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcP2Range_BoardRenderer_mcP2Range_0() : *
      {
         try
         {
            mcP2Range["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcP2Range.cardHolderID = 4;
         mcP2Range.draggingEnabled = true;
         mcP2Range.enabled = true;
         mcP2Range.enableInitCallback = false;
         mcP2Range.gridSize = 1;
         mcP2Range.navigationDown = 7;
         mcP2Range.navigationLeft = 13;
         mcP2Range.navigationRight = 1;
         mcP2Range.navigationUp = 5;
         mcP2Range.playerID = 1;
         mcP2Range.selectable = true;
         mcP2Range.uniqueID = 6;
         mcP2Range.visible = true;
         try
         {
            mcP2Range["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcP2Siege_BoardRenderer_mcP2Siege_0() : *
      {
         try
         {
            mcP2Siege["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcP2Siege.cardHolderID = 3;
         mcP2Siege.draggingEnabled = true;
         mcP2Siege.enabled = true;
         mcP2Siege.enableInitCallback = false;
         mcP2Siege.gridSize = 1;
         mcP2Siege.navigationDown = 6;
         mcP2Siege.navigationLeft = 12;
         mcP2Siege.navigationRight = 1;
         mcP2Siege.navigationUp = -1;
         mcP2Siege.playerID = 1;
         mcP2Siege.selectable = true;
         mcP2Siege.uniqueID = 5;
         mcP2Siege.visible = true;
         try
         {
            mcP2Siege["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcP1SiegeModif_BoardRenderer_mcP1SiegeModif_0() : *
      {
         try
         {
            mcP1SiegeModif["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcP1SiegeModif.cardHolderID = 6;
         mcP1SiegeModif.draggingEnabled = true;
         mcP1SiegeModif.enabled = true;
         mcP1SiegeModif.enableInitCallback = false;
         mcP1SiegeModif.gridSize = 1;
         mcP1SiegeModif.navigationDown = 11;
         mcP1SiegeModif.navigationLeft = 19;
         mcP1SiegeModif.navigationRight = 10;
         mcP1SiegeModif.navigationUp = 16;
         mcP1SiegeModif.playerID = 0;
         mcP1SiegeModif.selectable = true;
         mcP1SiegeModif.uniqueID = 17;
         mcP1SiegeModif.visible = true;
         try
         {
            mcP1SiegeModif["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcP1RangeModif_BoardRenderer_mcP1RangeModif_0() : *
      {
         try
         {
            mcP1RangeModif["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcP1RangeModif.cardHolderID = 7;
         mcP1RangeModif.draggingEnabled = true;
         mcP1RangeModif.enabled = true;
         mcP1RangeModif.enableInitCallback = false;
         mcP1RangeModif.gridSize = 1;
         mcP1RangeModif.navigationDown = 17;
         mcP1RangeModif.navigationLeft = 18;
         mcP1RangeModif.navigationRight = 9;
         mcP1RangeModif.navigationUp = 15;
         mcP1RangeModif.playerID = 0;
         mcP1RangeModif.selectable = true;
         mcP1RangeModif.uniqueID = 16;
         mcP1RangeModif.visible = true;
         try
         {
            mcP1RangeModif["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcP1MeleeModif_BoardRenderer_mcP1MeleeModif_0() : *
      {
         try
         {
            mcP1MeleeModif["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcP1MeleeModif.cardHolderID = 8;
         mcP1MeleeModif.draggingEnabled = true;
         mcP1MeleeModif.enabled = true;
         mcP1MeleeModif.enableInitCallback = false;
         mcP1MeleeModif.gridSize = 1;
         mcP1MeleeModif.navigationDown = 16;
         mcP1MeleeModif.navigationLeft = 18;
         mcP1MeleeModif.navigationRight = 8;
         mcP1MeleeModif.navigationUp = 14;
         mcP1MeleeModif.playerID = 0;
         mcP1MeleeModif.selectable = true;
         mcP1MeleeModif.uniqueID = 15;
         mcP1MeleeModif.visible = true;
         try
         {
            mcP1MeleeModif["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcP2MeleeModif_BoardRenderer_mcP2MeleeModif_0() : *
      {
         try
         {
            mcP2MeleeModif["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcP2MeleeModif.cardHolderID = 8;
         mcP2MeleeModif.draggingEnabled = true;
         mcP2MeleeModif.enabled = true;
         mcP2MeleeModif.enableInitCallback = false;
         mcP2MeleeModif.gridSize = 1;
         mcP2MeleeModif.navigationDown = 15;
         mcP2MeleeModif.navigationLeft = 20;
         mcP2MeleeModif.navigationRight = 7;
         mcP2MeleeModif.navigationUp = 13;
         mcP2MeleeModif.playerID = 1;
         mcP2MeleeModif.selectable = true;
         mcP2MeleeModif.uniqueID = 14;
         mcP2MeleeModif.visible = true;
         try
         {
            mcP2MeleeModif["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcP2RangeModif_BoardRenderer_mcP2RangeModif_0() : *
      {
         try
         {
            mcP2RangeModif["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcP2RangeModif.cardHolderID = 7;
         mcP2RangeModif.draggingEnabled = true;
         mcP2RangeModif.enabled = true;
         mcP2RangeModif.enableInitCallback = false;
         mcP2RangeModif.gridSize = 1;
         mcP2RangeModif.navigationDown = 14;
         mcP2RangeModif.navigationLeft = 20;
         mcP2RangeModif.navigationRight = 6;
         mcP2RangeModif.navigationUp = 12;
         mcP2RangeModif.playerID = 1;
         mcP2RangeModif.selectable = true;
         mcP2RangeModif.uniqueID = 13;
         mcP2RangeModif.visible = true;
         try
         {
            mcP2RangeModif["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcP2SiegeModif_BoardRenderer_mcP2SiegeModif_0() : *
      {
         try
         {
            mcP2SiegeModif["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcP2SiegeModif.cardHolderID = 6;
         mcP2SiegeModif.draggingEnabled = true;
         mcP2SiegeModif.enabled = true;
         mcP2SiegeModif.enableInitCallback = false;
         mcP2SiegeModif.gridSize = 1;
         mcP2SiegeModif.navigationDown = 13;
         mcP2SiegeModif.navigationLeft = 20;
         mcP2SiegeModif.navigationRight = 5;
         mcP2SiegeModif.navigationUp = -1;
         mcP2SiegeModif.playerID = 1;
         mcP2SiegeModif.selectable = true;
         mcP2SiegeModif.uniqueID = 12;
         mcP2SiegeModif.visible = true;
         try
         {
            mcP2SiegeModif["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcP1LeaderHolder_BoardRenderer_mcP1LeaderHolder_0() : *
      {
         try
         {
            mcP1LeaderHolder["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcP1LeaderHolder.cardHolderID = 10;
         mcP1LeaderHolder.draggingEnabled = true;
         mcP1LeaderHolder.enabled = true;
         mcP1LeaderHolder.enableInitCallback = false;
         mcP1LeaderHolder.gridSize = 1;
         mcP1LeaderHolder.navigationDown = 11;
         mcP1LeaderHolder.navigationLeft = -1;
         mcP1LeaderHolder.navigationRight = 11;
         mcP1LeaderHolder.navigationUp = 18;
         mcP1LeaderHolder.playerID = 0;
         mcP1LeaderHolder.selectable = true;
         mcP1LeaderHolder.uniqueID = 19;
         mcP1LeaderHolder.visible = true;
         try
         {
            mcP1LeaderHolder["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcP2LeaderHolder_BoardRenderer_mcP2LeaderHolder_0() : *
      {
         try
         {
            mcP2LeaderHolder["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcP2LeaderHolder.cardHolderID = 10;
         mcP2LeaderHolder.draggingEnabled = true;
         mcP2LeaderHolder.enabled = true;
         mcP2LeaderHolder.enableInitCallback = false;
         mcP2LeaderHolder.gridSize = 1;
         mcP2LeaderHolder.navigationDown = 18;
         mcP2LeaderHolder.navigationLeft = -1;
         mcP2LeaderHolder.navigationRight = 14;
         mcP2LeaderHolder.navigationUp = -1;
         mcP2LeaderHolder.playerID = 1;
         mcP2LeaderHolder.selectable = true;
         mcP2LeaderHolder.uniqueID = 20;
         mcP2LeaderHolder.visible = true;
         try
         {
            mcP2LeaderHolder["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
