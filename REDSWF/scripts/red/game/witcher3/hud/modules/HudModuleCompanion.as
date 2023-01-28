package red.game.witcher3.hud.modules
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.W3UILoader;
   import red.game.witcher3.hud.modules.wolfHead.W3StatIndicator;
   
   public class HudModuleCompanion extends HudModuleBase
   {
       
      
      public var __setPropDict:Dictionary;
      
      public var textField:TextField;
      
      public var mcLoader:W3UILoader;
      
      public var mcHealthBar:W3StatIndicator;
      
      public var textField2:TextField;
      
      public var mcLoader2:W3UILoader;
      
      public var mcHealthBar2:W3StatIndicator;
      
      public var mcGraphicPortrait2:MovieClip;
      
      public function HudModuleCompanion()
      {
         this.__setPropDict = new Dictionary(true);
         addFrameScript(0,this.frame1,1,this.frame2);
         super();
         this.__setProp_mcHealthBar_Scene1_mcHealthBar_0();
      }
      
      override public function get moduleName() : String
      {
         return "CompanionModule";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         alpha = 0;
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
      }
      
      public function setVitality(param1:Number) : *
      {
         if(this.mcHealthBar)
         {
            this.mcHealthBar.value = param1 * 100;
         }
      }
      
      public function setName(param1:String) : *
      {
         this.textField.htmlText = param1;
      }
      
      public function setPortrait(param1:String) : *
      {
         if(param1.charAt(0) == "\\")
         {
            param1 = param1.slice(1,param1.length);
         }
         this.mcLoader.source = "img://" + param1;
      }
      
      public function setVitality2(param1:Number) : *
      {
         if(this.mcHealthBar2)
         {
            this.mcHealthBar2.value = param1 * 100;
         }
      }
      
      public function setName2(param1:String) : *
      {
         this.textField2.htmlText = param1;
      }
      
      public function setPortrait2(param1:String) : *
      {
         if(param1 == "")
         {
            gotoAndStop("one");
            return;
         }
         gotoAndStop("two");
         this.mcLoader2 = this.getChildByName("mcLoader2") as W3UILoader;
         this.textField2 = this.getChildByName("textField2") as TextField;
         this.mcHealthBar2 = this.getChildByName("mcHealthBar2") as W3StatIndicator;
         if(param1.charAt(0) == "\\")
         {
            param1 = param1.slice(1,param1.length);
         }
         this.mcLoader2.source = "img://" + param1;
      }
      
      internal function __setProp_mcHealthBar_Scene1_mcHealthBar_0() : *
      {
         try
         {
            this.mcHealthBar["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcHealthBar.enabled = true;
         this.mcHealthBar.enableInitCallback = false;
         this.mcHealthBar.maximum = 100;
         this.mcHealthBar.minimum = 0;
         this.mcHealthBar.value = 50;
         this.mcHealthBar.visible = true;
         try
         {
            this.mcHealthBar["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcHealthBar2_Scene1_mcHealthBar_1() : *
      {
         if(this.__setPropDict[this.mcHealthBar2] == undefined || int(this.__setPropDict[this.mcHealthBar2]) != 2)
         {
            this.__setPropDict[this.mcHealthBar2] = 2;
            try
            {
               this.mcHealthBar2["componentInspectorSetting"] = true;
            }
            catch(e:Error)
            {
            }
            this.mcHealthBar2.enabled = true;
            this.mcHealthBar2.enableInitCallback = false;
            this.mcHealthBar2.maximum = 100;
            this.mcHealthBar2.minimum = 0;
            this.mcHealthBar2.value = 50;
            this.mcHealthBar2.visible = true;
            try
            {
               this.mcHealthBar2["componentInspectorSetting"] = false;
            }
            catch(e:Error)
            {
            }
         }
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         this.__setProp_mcHealthBar2_Scene1_mcHealthBar_1();
         stop();
      }
   }
}
