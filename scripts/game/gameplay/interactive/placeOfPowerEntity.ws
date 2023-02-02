/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/
statemachine class CMajorPlaceOfPowerEntity extends CInteractiveEntity
{
	autobind interactionComponent : CInteractionComponent = "activationComponent";
	
	public editable var buffType : EShrineBuffs;
	public editable var buffUniqueName : string;
	public editable var fxOnIdle : name;
	public editable var fxOnChannel : name;
	public editable var fxOnSuccess : name;
	
	public var channelingTime : float;
	public var buffDuration : float;
	public var buffCooldown : GameTime;
	
	public saved var skillPointGranted : bool;
	public saved var isRecharging : bool;
	public saved var lastUsed : GameTime;
	public saved var isPlaceOfPowerInIdle : bool;
	
	saved var voicesetTimestamp : GameTime;
	saved var initialVoicesetPlayed	: bool;
	
	default initialVoicesetPlayed = false;
	
	default fxOnIdle = 'default';
	default fxOnChannel = 'use';
	default fxOnSuccess = 'use';
	
	default channelingTime = 2.5;
	default buffDuration = 1800.0; 
	default skillPointGranted = false;
	default isRecharging = false;
	default autoState = 'PlaceOfPower_Idle';
	
	event OnSpawned( spawnData : SEntitySpawnData )
	{
		if(spawnData.restored && isRecharging && (theGame.GetGameTime() < lastUsed + GetBuffCooldown()) )
		{
			buffCooldown = lastUsed + GetBuffCooldown() - theGame.GetGameTime();
			GotoState( 'PlaceOfPower_Recharging' );
		}
		else		
		{
			buffCooldown = GetBuffCooldown();

			GotoStateAuto();
		}
	}
	
	private final function GetBuffCooldown() : GameTime
	{	
			return GameTimeCreate( 0, 0, 0, CeilF(ConvertRealTimeSecondsToGameSeconds(60)) );	
	}

	event OnInteraction( actionName : string, activator : CEntity )
	{
		if( activator != thePlayer || !thePlayer.CanPerformPlayerAction())
			return false;
		
		thePlayer.OnEquipMeleeWeapon( PW_None, true );
		GotoState( 'PlaceOfPower_Channeling' );
	}
	
	event OnInteractionActivationTest( interactionComponentName : string, activator : CEntity )
	{
		if( isRecharging || GetCurrentStateName() != 'PlaceOfPower_Idle' )
			return false;
		else
			return true;
	}
	
	event OnAreaEnter( area : CTriggerAreaComponent, activator : CComponent )
	{
		var mapManager : CCommonMapManager = theGame.GetCommonMapManager();
		var vect : Vector;
		var tags : array< name >;
		
		if ( area == (CTriggerAreaComponent)this.GetComponent( "VoiceSetTrigger" ) &&  isPlaceOfPowerInIdle && !thePlayer.IsCombatMusicEnabled() && !thePlayer.IsInNonGameplayCutscene() )
		{
			theGame.VibrateController( 0, 0.3f, 1.0f ); 
			GetWitcherPlayer().GetMedallion().Activate( true, 5.0f );
			
			if ( CanPlayVoiceSet() )
			{
				thePlayer.PlayVoiceset( 100,'DetectPlaceOfPower' );
				voicesetTimestamp = theGame.GetGameTime();
				initialVoicesetPlayed = true;
			}
		}
		
		if( area == (CTriggerAreaComponent)this.GetComponent( "FirstDiscoveryTrigger" ) && activator.GetEntity() == thePlayer )
		{
			this.GetComponent( "FirstDiscoveryTrigger" ).SetEnabled( false );			
			mapManager.SetEntityMapPinDiscoveredScript( false, entityName, true );
		}
		
		
	}
	
	
	function CanPlayVoiceSet() : bool
	{
		if( thePlayer.IsSpeaking() )
			return false;
		else if( !initialVoicesetPlayed )
			return true;
		else if( theGame.GetGameTime() > voicesetTimestamp + GameTimeCreate( 0, 0, 0, CeilF( ConvertRealTimeSecondsToGameSeconds( 120 ) ) ) )
			return true;
		else
			return false;
	}
}

state PlaceOfPower_Idle in CMajorPlaceOfPowerEntity
{
	event OnEnterState( prevStateName : name )
	{	
		parent.isPlaceOfPowerInIdle = true;
		
		parent.PlayEffect( parent.fxOnIdle );
		if(thePlayer)
			thePlayer.PlayerStopAction( PEA_Meditation );
		parent.isRecharging = false;
		
		if ( !parent.skillPointGranted )
		{
			theGame.GetCommonMapManager().SetEntityMapPinDisabled( parent.entityName, false );
		}
	}
	
	event OnLeaveState( nextStateName : name )
	{
		
		parent.StopEffect( parent.fxOnIdle );
		parent.isPlaceOfPowerInIdle = false;
	}
}

state PlaceOfPower_Channeling in CMajorPlaceOfPowerEntity
{
	var channelingStartTime : float;

	event OnEnterState( prevStateName : name )
	{	
		parent.PlayEffect( parent.fxOnChannel );
		
		channelingStartTime = theGame.GetEngineTimeAsSeconds();
		theGame.GetGuiManager().EnableHudHoldIndicator(IK_Pad_A_CROSS, IK_E, "InteractHold", parent.channelingTime, 'PlaceOfPower');
		PlaceOfPower_Channel();
	}
	
	entry function PlaceOfPower_Channel()
	{	
		var test : name; 
		var channelPerc : float;
		
		thePlayer.PlayerStartAction( PEA_Meditation );
		while( true )
		{
			SleepOneFrame();
			
			if( theInput.IsActionPressed( 'InteractHold' ) && !thePlayer.GetIsWalking() && !thePlayer.GetIsSprinting())
			{
				if( channelingStartTime + parent.channelingTime > theGame.GetEngineTimeAsSeconds() )
				{
					channelPerc = (theGame.GetEngineTimeAsSeconds() - channelingStartTime) / parent.channelingTime;
					theGame.VibrateController(channelPerc, channelPerc, 0.0001); 
					
					continue;
				}
				else
				{
					parent.GotoState( 'PlaceOfPower_Activated' );
				}
			}
			else
			{
				test = theInput.GetContext();
				parent.GotoState( 'PlaceOfPower_Idle' );
			}
		}
	}
	
	event OnLeaveState( nextStateName : name )
	{
		theGame.GetGuiManager().DisableHudHoldIndicator();
		parent.StopEffect( parent.fxOnChannel );
	}
}

state PlaceOfPower_Activated in CMajorPlaceOfPowerEntity
{
	event OnEnterState( prevStateName : name )
	{	
		parent.PlayEffect( parent.fxOnSuccess );
		
		GrantSkillPointIfPossible();
		GrantBuff();
		thePlayer.PlayerStopAction( PEA_Meditation );
		theGame.GetCommonMapManager().SetEntityMapPinDisabled( parent.entityName, true );

		parent.GotoState( 'PlaceOfPower_Recharging' );
	}
	
	private function GrantSkillPointIfPossible()
	{	
		if( !parent.skillPointGranted )
		{
			GetWitcherPlayer().AddPoints( ESkillPoint, 1, true );
			GetWitcherPlayer().DisplayHudMessage(GetLocStringByKeyExt("panel_hud_message_pop_skillpoint"));
			parent.skillPointGranted = true;
		}
	}
	
	private function GrantBuff()
	{
		var params : SCustomEffectParams;
	
		
		if( GetWitcherPlayer().CanUseSkill( S_Perk_14 ) )
		{
			thePlayer.RemoveAllBuffsOfType( EET_ShrineAard );
			thePlayer.RemoveAllBuffsOfType( EET_ShrineAxii );
			thePlayer.RemoveAllBuffsOfType( EET_ShrineIgni );
			thePlayer.RemoveAllBuffsOfType( EET_ShrineQuen );
			thePlayer.RemoveAllBuffsOfType( EET_ShrineYrden );
		}
	
		params.effectType = GetStatFromEnum( parent.buffType );
		params.creator = parent;
		params.sourceName = parent.buffUniqueName;
		params.duration = parent.buffDuration;
		
		thePlayer.AddEffectCustom( params );
		
		switch(parent.buffType)
		{
			case ESB_Aard:
				GetWitcherPlayer().DisplayHudMessage( GetLocStringByKeyExt("panel_hud_message_pop_buff_aard") );
				break;
				
			case ESB_Axii:
				GetWitcherPlayer().DisplayHudMessage( GetLocStringByKeyExt("panel_hud_message_pop_buff_axii") );
				break;
				
			case ESB_Igni:
				GetWitcherPlayer().DisplayHudMessage( GetLocStringByKeyExt("panel_hud_message_pop_buff_igni") );
				break;
				
			case ESB_Quen:
				GetWitcherPlayer().DisplayHudMessage( GetLocStringByKeyExt("panel_hud_message_pop_buff_quen") );
				break;
				
			case ESB_Yrden:
				GetWitcherPlayer().DisplayHudMessage( GetLocStringByKeyExt("panel_hud_message_pop_buff_yrden") );
				break;
		}
	}
	
	private function GetStatFromEnum( statName : EShrineBuffs ) : EEffectType
	{
		switch( statName )
		{
			case ESB_Aard: return EET_ShrineAard;
			case ESB_Axii: return EET_ShrineAxii;
			case ESB_Igni: return EET_ShrineIgni;
			case ESB_Quen: return EET_ShrineQuen;
			case ESB_Yrden: return EET_ShrineYrden;
		}
	}
}

state PlaceOfPower_Recharging in CMajorPlaceOfPowerEntity
{
	event OnEnterState( prevStateName : name )
	{	
		parent.AddGameTimeTimer( 'Recharge', parent.buffCooldown, false,,,,true );
		parent.isRecharging = true;
		parent.lastUsed = theGame.GetGameTime();
	}
	
	timer function Recharge( timeDelta : GameTime , id : int )
	{
		parent.GotoState( 'PlaceOfPower_Idle' );
	}
}

enum EShrineBuffs
{
	ESB_Aard,
	ESB_Axii,
	ESB_Igni,
	ESB_Quen,
	ESB_Yrden
}
