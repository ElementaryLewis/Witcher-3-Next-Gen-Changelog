/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/











import abstract class CActor extends CGameplayEntity
{
	
	import 				var isAttackableByPlayer 		: bool;
	editable saved		var isTargatebleByPlayer		: bool; default isTargatebleByPlayer = true;
	editable saved		var isUsingTooltip				: bool; default isUsingTooltip 		= true;
	public				var slideTarget					: CGameplayEntity;
	public				var parryTypeTable				: array< array< EParryType > >;
	public 				var lastAttacker 				: CActor;
	public				var counterAttackAnimTable		: array< name >;
	private				var bIsGuarded					: bool;
	private				var bParryEnabled				: bool;
	protected			var bCanPerformCounter			: bool;
	private				var lastParryType				: EParryType;
	private 			var	useAdditiveHits				: bool;
	private				var oneTimeAdditiveHit			: bool;
	private				var useAdditiveCriticalStateAnim: bool;
	private 			var criticalCancelAdditiveHit	: bool;
	private				var lastAttackRangeName			: name;						
	protected 			var attackActionName			: name;						
	protected 			var hitTargets 					: array<CGameplayEntity>;	
	private 			var droppedItems				: array<SDroppedItem>;		
	private 			var wasDefeatedFromFistFight	: bool;						
	protected			var isCurrentlyDodging			: bool;						
	private				var combatStartTime				: float;					
	private				var combatPartStartTime			: float;					
	private				var collisionDamageTimestamp  	: float;					
	private				var	lastWasAttackedTime			: float;
	private				var lastWasHitTime				: float;
	private				var lowerGuardTime				: float;
	private 			var knockedUncounscious			: bool;
	private 			var isGameplayVisible			: bool;
	private				var lastBreathTime				: float;
	protected 			var isRecoveringFromKnockdown   : bool;
	
	private 			var hitCounter 					: int;		default hitCounter = 0;
	private 			var totalHitCounter 			: int;		default totalHitCounter = 0;
	public 				var customHits 					: bool;		default customHits = false;
	
	private 			var defendCounter 				: int;		default defendCounter = 0;
	private 			var totalDefendCounter 			: int;		default totalDefendCounter = 0;
	
	default bIsGuarded 							= false;
	default bParryEnabled 						= false;
	default collisionDamageTimestamp			= 0.0;

	
	private var		bIsPlayerCurrentTarget				: bool;
	
	
	protected saved var buffImmunities : array<SBuffImmunity>;			
	protected saved var buffRemovedImmunities : array<SBuffImmunity>;		
	protected saved var newRequestedCS : CBaseGameplayEffect;			
	
	private var criticalStateCounter 					: int;
	private var	totalCriticalStateCounter 				: int;

	
	public saved var isDead				: bool;
	
	
	protected var		canPlayHitAnim 				: bool;			default canPlayHitAnim 				= true;

	
	
	
	
	private editable var damageDistanceNotReducing	: float;		default	damageDistanceNotReducing	= 7.0f; 	
	private editable var deathDistNotReducing		: float;		default	deathDistNotReducing		= 9.0f; 	
	private editable var damageDistanceReducing		: float;		default	damageDistanceReducing		= 12.0f;	
	private editable var deathDistanceReducing		: float; 		default	deathDistanceReducing		= 15.0f;	
	private editable var fallDamageMinHealthPerc	: float; 		default	fallDamageMinHealthPerc		= 0.05f;	
	
	
	
	public var isPlayerFollower : bool;
	
	private var MAC : CMovingPhysicalAgentComponent;
	
	saved var immortalityFlags : int;
	default immortalityFlags = 0;

	saved var abilityManager : W3AbilityManager;		
	
	private var effectsUpdateTicking : bool;		default effectsUpdateTicking = false;
	
	public function GetIgnoreImmortalDodge() : bool
	{
		
		return false;
	}	

	
	
	public function SetTatgetableByPlayer(isTargetAble : bool)
	{
		isTargatebleByPlayer = isTargetAble;
	}
	
	public function IsTargetableByPlayer() : bool
	{
		if ( thePlayer.playerMode.GetForceCombatMode() )
		{
			if ( this.GetAttitude( thePlayer ) == AIA_Friendly )
				return false;
		}
		return isTargatebleByPlayer;
	}
	
	public function  IsUsingTooltip() : bool
	{
		return isUsingTooltip;
	}
	
	public function SetIsUsingTooltip (hasTooltip : bool)
	{
		isUsingTooltip = hasTooltip;
	}
	
	
	
	public function GetTotalWeaponDamage(weaponId : SItemUniqueId, damageTypeName : name, crossbowId : SItemUniqueId) : float
	{
		var excessiveDamage : SAbilityAttributeValue;
		var i : int;
		var weapons : array<SItemUniqueId>;
		var inv : CInventoryComponent;
		var n : name;		
		var damage : float;
		
		excessiveDamage = GetAttributeValue(damageTypeName);		
		inv = GetInventory();
		weapons = inv.GetAllWeapons();
		
		for(i=0; i<weapons.Size(); i+=1)
		{
			n = inv.GetItemName(weapons[i]);		
			
			if(!inv.IsItemHeld(weapons[i]))
				continue;
				
			
			if(weapons[i] == weaponId)
				continue;
				
			
			if(inv.IsItemBolt(weaponId) && weapons[i] == crossbowId)
				continue;
			
			excessiveDamage -= inv.GetItemAttributeValue(weapons[i], damageTypeName);
		}
		
		
		
		
		
		if(!inv.IsItemHeld(weaponId) && !inv.IsItemBolt(weaponId))
		{
			excessiveDamage += inv.GetItemAttributeValue(weaponId, damageTypeName);
		}
		
		damage = CalculateAttributeValue(excessiveDamage);
		
		return damage;		
	}

	public function GetAttributeValue(attributeName : name, optional tags : array<name>, optional ignoreDeath : bool) : SAbilityAttributeValue
	{
		var null : SAbilityAttributeValue;
	
		if(abilityManager && abilityManager.IsInitialized() && (ignoreDeath || IsAlive()) )
			return abilityManager.GetAttributeValue(attributeName,tags);
			
		null.valueBase = -1;
		null.valueAdditive = -1;
		null.valueMultiplicative = 0;		
		return null;
	}
	
	
	public function GetAbilityAttributeValue(abilityName : name, attributeName : name) : SAbilityAttributeValue
	{
		var null : SAbilityAttributeValue;
	
		if(abilityManager && abilityManager.IsInitialized())
			return abilityManager.GetAbilityAttributeValue(abilityName, attributeName);
			
		null.valueBase = -1;
		null.valueAdditive = -1;
		null.valueMultiplicative = 0;		
		return null;
	}

	
	function CanAddAttribute( attributeName : name, abilityName : name ) : bool
	{
		if ( attributeName == 'vitality' && UsesEssence())
		{
			return false;
		}
		else if ( attributeName == 'essence' && UsesVitality())
		{
			return false;
		}
		
		return true;
	}
	
	event OnAbilityAdded( abilityName : name)
	{
		if(abilityManager && abilityManager.IsInitialized())
			abilityManager.OnAbilityAdded(abilityName);
	}
	
	event OnAbilityRemoved( abilityName : name)
	{
		if(abilityManager && abilityManager.IsInitialized())
			abilityManager.OnAbilityRemoved(abilityName);
	}

	public final function IsAbilityBlocked(abilityName : name) : bool											{return abilityManager.IsAbilityBlocked(abilityName);}
	public final function BlockAbility(abilityName : name, block : bool, optional cooldown : float) : bool		{return abilityManager.BlockAbility(abilityName, block, cooldown);}
	
	import public function MuteHeadAudio( mute: bool );
	import public function CanPush( canPush: bool );


	
	import public function ApplyItemAbilities( itemId : SItemUniqueId ) : bool;

	
	import public function RemoveItemAbilities( itemId : SItemUniqueId ) : bool;

	
	import public function GetCharacterStatsParam(abilities : array<name>);
	
	
	import public function ReportDeathToSpawnSystems();
	
	
	import public function ForceSoundAppearanceUpdate();

	saved var immortalityFlagsCopy : int;
	default immortalityFlagsCopy = 0;

	
	private function GetPureImmortalityFlags() : int
	{
		var mask : int;
		
		
		mask = 16777215;
		
		return ( immortalityFlags & mask );
	}
	public function WillBeUnconscious() : bool
	{
		var pureImmortalityFlags : int;
		pureImmortalityFlags = GetPureImmortalityFlags();
		
		return pureImmortalityFlags > 0 && pureImmortalityFlags < 256;
	}
	
	public function IsImmortal() : bool
	{
		var pureImmortalityFlags : int;
		pureImmortalityFlags = GetPureImmortalityFlags();
		
		return pureImmortalityFlags >= 256 && pureImmortalityFlags < 65536;
	}
	
	public function IsInvulnerable() : bool
	{
		var pureImmortalityFlags : int;
		pureImmortalityFlags = GetPureImmortalityFlags();
		
		return pureImmortalityFlags >= 65536;
	}
	
	public function IsVulnerable() : bool
	{
		var pureImmortalityFlags : int;
		pureImmortalityFlags = GetPureImmortalityFlags();
		
		return pureImmortalityFlags == 0;
	}
	public function GetImmortalityMode() : EActorImmortalityMode
	{	
		if ( WillBeUnconscious() )		{ return AIM_Unconscious; }
		else if( IsInvulnerable() ) 	{ return AIM_Invulnerable; }
		else if( IsImmortal() ) 		{ return AIM_Immortal; }
		
		return AIM_None;
	}	
	
	public function LogAllAbilities()
	{
		var attributes : array< name >;
		var i : int;
		var res : string;
		
		GetWitcherPlayer().GetCharacterStats().GetAllAttributesNames( attributes );
		for ( i = 1; i< attributes.Size(); i+=1 )
		{
			res =  NameToString( attributes[i] ) + " ("+ GetLocStringByKeyExt( NameToString( attributes[i] ) ) + ") : " + FloatToString( CalculateAttributeValue( GetAttributeValue( attributes[i] ) ) );
			LogStats( res );
		}
	}
	
	public function ForceVulnerable() 
	{ 
		var oldMode : EActorImmortalityMode;
		if( immortalityFlags > 0 )
		{			
			oldMode = GetImmortalityMode();
			LogChannel('Stats', "Actor <<" + this + ">> forces to vulnerable from <<" + oldMode + ">>");
		}
		immortalityFlags = 0;
	}
	
	public function ForceVulnerableImmortalityMode() 
	{ 
		immortalityFlagsCopy = immortalityFlags;
		immortalityFlags = 0;
	}
	
	public function RestoreImmortalityMode()
	{
		immortalityFlags = immortalityFlagsCopy;
	}
	
	public function GetImmortalityModeChannels( mode : EActorImmortalityMode) : array< EActorImmortalityChanel >
	{
		var numImmortalityChannels : int;
		var result : array< EActorImmortalityChanel >;
		var i : int;
		var modeOffset : int;
		var mask : int;
		var channel : int;
		var _shift8, _shift16 : int;
		
		_shift8 = 256; 			
		_shift16 = 65536;		
		
		modeOffset = 1; 
		if ( mode == AIM_Immortal )
		{
			modeOffset = _shift8;
		}
		else if ( mode == AIM_Invulnerable)
		{			
			modeOffset = _shift16;
		}
		
		numImmortalityChannels = 8;
		if( mode != AIM_None )
		{
			for( i = 0; i < numImmortalityChannels; i += 1 )
			{
				channel = (int) PowF( 2, i );
				mask = modeOffset * channel;
				if( ( immortalityFlags & mask ) > 0 )
				{
					result.PushBack( channel );
				}
			}
		}
		else
		{
			for( i = 0; i < numImmortalityChannels; i += 1 )
			{
				channel = (int) PowF( 2, i );
				if( ( channel & immortalityFlags ) == 0 &&					
					( ( channel * _shift8 ) & immortalityFlags ) == 0 &&	
					( ( channel * _shift16 ) & immortalityFlags ) == 0 )	
				{
					result.PushBack( channel );
				}
			}
		}
		
		return result;
	}
	
	public function SetImmortalityMode( mode : EActorImmortalityMode, channel : EActorImmortalityChanel, optional lockMode : bool )			
	{
		var oldMode : EActorImmortalityMode;
		var channelInt : int;
		var _shift8, _shift16, _shift24 : int;
		
		channelInt = channel;
		
		
		_shift8 = 256;
		
		_shift16 = 65536;
		
		_shift24 = 16777216;
		
		if ( !lockMode && ( ( immortalityFlags & ( channelInt * _shift24 ) ) != 0 ) )
			return;
		
		oldMode = GetImmortalityMode();
		
		if ( mode == AIM_Unconscious )
		{
			immortalityFlags = immortalityFlags | ( channelInt );					
			immortalityFlags = immortalityFlags & ( ~( channelInt *  _shift8 ) );  	
			immortalityFlags = immortalityFlags & ( ~( channelInt *  _shift16 ) );  
		}
		else if ( mode == AIM_Immortal )
		{
			immortalityFlags = immortalityFlags | ( channelInt *  _shift8 ); 		
			immortalityFlags = immortalityFlags & ( ~channelInt ); 					
			immortalityFlags = immortalityFlags & ( ~( channelInt *  _shift16 ) );  
		}
		else if ( mode == AIM_Invulnerable)
		{			
			immortalityFlags = immortalityFlags | ( channelInt *  _shift16 );		
			immortalityFlags = immortalityFlags & ( ~channelInt ); 					
			immortalityFlags = immortalityFlags & ( ~( channelInt *  _shift8 ) );  	
		}
		else if ( mode == AIM_None )
		{
			immortalityFlags = immortalityFlags & ( ~channelInt ); 					
			immortalityFlags = immortalityFlags & ( ~( channelInt *  _shift8 ) );  	
			immortalityFlags = immortalityFlags & ( ~( channelInt *  _shift16 ) );  
		}
		if ( lockMode )
		{
			immortalityFlags = immortalityFlags | ( channelInt *  _shift24 );  		
		}
		
		if ( oldMode == mode )
			return;	
		
		LogChannel('Stats', "Actor <<" + this + ">> changes immortality mode from <<" + oldMode + ">> to <<" + mode + ">>");
	}
	

	
	protected			var isSwimming : bool;
	
	
	protected saved var usedVehicleHandle			: EntityHandle ;
	protected var usedVehicle						: CGameplayEntity;
	
	
	protected saved var effectManager				: W3EffectManager;
	
	private var traverser : CScriptedExplorationTraverser;
	function GetTraverser() : CScriptedExplorationTraverser
	{
		return traverser;
	}
	timer function UpdateTraverser( time : float , id : int)
	{
		if( traverser )
		{
			traverser.Update( time );
		}
	}
	
	
	event OnStartTraversingExploration( t : CScriptedExplorationTraverser )
	{
		SetInteractionPriority(IP_Max_Unpushable);
		traverser = t;
		return true;
	}
	
	event OnFinishTraversingExploration()
	{
		RestoreOriginalInteractionPriority();
		traverser = NULL;
		return true;
	}
				
	
	private saved var nextFreeAnimMultCauserId : int;							
		default nextFreeAnimMultCauserId = 0;
	
	private var animationMultiplierCausers : array< SAnimMultiplyCauser >;		
				
	import final function GetAutoEffects( out effects : array< name > );
	
	import final function SignalGameplayEvent( eventName : CName );
	
	import final function SignalGameplayEventParamCName( eventName : CName, param : CName );
	import final function SignalGameplayEventParamInt( eventName : CName, param : int );
	import final function SignalGameplayEventParamFloat( eventName : CName, param : float );
	import final function SignalGameplayEventParamObject( eventName : CName, param : IScriptable );
	
	import final function SignalGameplayEventReturnCName( eventName : CName, defaultVal : CName ) : CName;
	import final function SignalGameplayEventReturnInt( eventName : CName, defaultVal : int ) : int;
	import final function SignalGameplayEventReturnFloat( eventName : CName, defaultVal : float ) : float;
	
	import final function SignalGameplayDamageEvent( eventName : CName, data : CDamageData );
	
	import final function GetScriptStorageObject( storageItemName : CName ) : IScriptable;
	
	import final function ForceAIUpdate();
	
	
	import final function GetTarget() : CActor;
	
	
	
	
	import final function IsDangerous( actor : CActor ) : bool;
	
	
	import final function GetAttitude( actor : CActor ) : EAIAttitude;
	import final function SetAttitude( actor : CActor , attitude : EAIAttitude );
	import final function ResetAttitude( actor : CActor );
	import final function HasAttitudeTowards( actor : CActor ) : bool;
	import final function ClearAttitudes( hostile, neutral, friendly : bool );

	
	import final function GetAttitudeGroup() : CName;
	import final function GetBaseAttitudeGroup() : CName;
	import final function SetBaseAttitudeGroup( groupName : CName );
	import final function ResetBaseAttitudeGroup();	
	import final function SetTemporaryAttitudeGroup( groupName : CName, priority : EAttitudeGroupPriority );
	import final function ResetTemporaryAttitudeGroup( priority : EAttitudeGroupPriority );
	
	
	
	import final function IsInCombat() : bool;
	
	
	public function SetCombatStartTime()
	{
		combatStartTime = theGame.GetEngineTimeAsSeconds();
	}
	
	public function GetCombatStartTime() : float
	{
		return combatStartTime;
	}
	
	public function ResetCombatStartTime()
	{
		combatStartTime = 0;
	}
	
	public function SetCombatPartStartTime()
	{
		combatPartStartTime = theGame.GetEngineTimeAsSeconds();
	}
	
	public function ResetCombatPartStartTime()
	{
		combatPartStartTime = 0;
	}
	
	public function GetCombatTime() : float
	{
		var time : float;
		
		if( combatStartTime )
		{
			time = theGame.GetEngineTimeAsSeconds() - combatStartTime;
			return time;
		}
		else
		{
			return 0;
		}
	}
	
	public function GetCombatPartTime() : float
	{
		var time : float;
		
		if( combatPartStartTime )
		{
			time = theGame.GetEngineTimeAsSeconds() - combatPartStartTime;
			return time;
		}
		else
		{
			return 0;
		}
	}
	
	
	protected function OnCombatModeSet( toggle : bool )
	{
		var movingAgent : CMovingAgentComponent = GetMovingAgentComponent();
		
		if ( movingAgent )
		{
			movingAgent.EnableCombatMode( toggle );
			movingAgent.SetVirtualRadius( 'testRadius' );
				
			if ( toggle )
			{
				movingAgent.SetVirtualRadius( 'CombatCharacterRadius' );
			}
			else 
			{
				movingAgent.ResetVirtualRadius();
			}
		}
	}
	
	public function HasHitTarget() : bool
	{
		return hitTargets.Size() != 0;
	}
	
	

	public function WasDefeatedFromFistFight() : bool
	{
		return this.wasDefeatedFromFistFight;
	}
	
	import private var isInFFMiniGame : bool;
	
	event OnStartFistfightMinigame()
	{
		PauseHPRegenEffects('FistFightMinigame', -1);
		isInFFMiniGame = true;
	}
	
	event OnEndFistfightMinigame()
	{
		ResumeHPRegenEffects('FistFightMinigame');
		isInFFMiniGame = false;
	}
	
	public function IsInFistFightMiniGame() : bool
	{
		return isInFFMiniGame;
	}
	
	import final function SetDebugAttackRange(rangeName : name);
	import final function EnableDebugARTraceDraw( enable : bool );
	
	
	import final function IsReadyForNewAction() : bool;
	
	
	import final function ActionCancelAll();
	
	import final function IsCurrentActionInProgress() : bool;
	import final function IsCurrentActionSucceded() : bool;
	import final function IsCurrentActionFailed() : bool;
	
	import final function IsInNonGameplayCutscene() : bool;
	import final function IsInGameplayScene() : bool;
	
	import final function PlayScene( input : string ) : bool;
	import final function StopAllScenes();
	
	import final function GetCurrentActionPriority() : int;

	import final function GetCurrentActionType() : EActorActionType;
	
	import final function IsDoingSomethingMoreImportant( priority : int ) : bool;

	import final function CanPlayQuestScene() : bool;
	import final function HasInteractionScene() : bool;
	import final function CanTalk( optional ignoreCurrentSpeech : bool ) : bool;
	
	import final function GetActorAnimState() : int;
	
	
	import final function IsInView() : bool;
	
	
	import final function IsUsingExploration() : bool;
	
	import final function GetAnimCombatSlots( animSlotName : name, out outSlots : array< Matrix >,
												slotsNum : int, mainEnemyMatrix : Matrix ) : bool;
												
	import final function GetHeadBoneIndex() : int;
	import final function GetTorsoBoneIndex() : int;
	
	var isInAir 	: bool;			default isInAir 	= false;	
	public function IsInAir() : bool			{return isInAir;}
	
	public function SetIsInAir(b : bool)
	{
		var critical : CBaseGameplayEffect;
		
		if ( b != isInAir )
		{
			isInAir = b;
			SetBehaviorVariable( 'IsInAir', (int)isInAir);
			
			critical = GetCurrentlyAnimatedCS();
			if(critical)
			{
				if ( isInAir )
					this.SignalGameplayEvent('DisableFinisher');
				else
					this.SignalGameplayEvent('EnableFinisher');
			}
		}
	}
	
	public var ragdollPullingStartPosition : Vector;
	
	public function GetRagdollPullingStartPosition() : Vector
	{
		return ragdollPullingStartPosition;
	}
	
	event OnRagdollPullingStarts( ragdollPos, entityPos : Vector )
	{
		ragdollPullingStartPosition = ragdollPos;
		SignalGameplayEvent( 'OnRagdollPullingStart' );
	}

	public var isInCutsceneIntro : bool;

	public function IsInCutsceneIntro() : bool
	{
		return this.isInCutsceneIntro;
	}

	public function SetIsInCutsceneIntro( b : bool )
	{
		this.isInCutsceneIntro = b;
	}
	
	
	
	
	import final latent function ActionMoveToNode( target : CNode, optional moveType : EMoveType, optional absSpeed : float, optional radius : float, optional failureAction : EMoveFailureAction ) : bool;	
	
	import final function ActionMoveToNodeAsync( target : CNode, optional moveType : EMoveType, optional absSpeed : float, optional radius : float, optional failureAction : EMoveFailureAction ) : bool;	
	
	
	import final latent function ActionMoveToNodeWithHeading( target : CNode, optional moveType : EMoveType, optional absSpeed : float, optional radius : float, optional failureAction : EMoveFailureAction ) : bool;	
	
	import final function ActionMoveToNodeWithHeadingAsync( target : CNode, optional moveType : EMoveType, optional absSpeed : float, optional radius : float, optional failureAction : EMoveFailureAction ) : bool;	
	
	
	import final latent function ActionMoveTo( target : Vector, optional moveType : EMoveType, optional absSpeed : float, optional radius : float, optional failureAction : EMoveFailureAction ) : bool;	
	
	import final function ActionMoveToAsync( target : Vector, optional moveType : EMoveType, optional absSpeed : float, optional radius : float, optional failureAction : EMoveFailureAction ) : bool;	

	
	import final latent function ActionMoveToWithHeading( target : Vector, heading : float, optional moveType : EMoveType, optional absSpeed : float, optional radius : float, optional failureAction : EMoveFailureAction ) : bool;	
	
	import final function ActionMoveToWithHeadingAsync( target : Vector, heading : float, optional moveType : EMoveType, optional absSpeed : float, optional radius : float, optional failureAction : EMoveFailureAction ) : bool;	
	
	
	import final latent function ActionMoveToDynamicNode( target : CNode, moveType : EMoveType, absSpeed : float, range : float, optional keepDistance : bool, optional failureAction : EMoveFailureAction ) : bool;	
	
	import final function ActionMoveToDynamicNodeAsync( target : CNode, moveType : EMoveType, absSpeed : float, range : float, optional keepDistance : bool, optional failureAction : EMoveFailureAction ) : bool;	
	
	
	import final latent function ActionMoveCustom( targeter : CMoveTRGScript ) : bool;	
	
	import final function ActionMoveCustomAsync( targeter : CMoveTRGScript ) : bool;	
	
	
	import final latent function ActionSlideThrough( explorationAreaToUse : CActionAreaComponent ) : bool;	
	
	import final function ActionSlideThroughAsync( explorationAreaToUse : CActionAreaComponent ) : bool;	
	
	
	import final latent function ActionSlideTo( target : Vector, duration : float ) : bool;	
	
	import final function ActionSlideToAsync( target : Vector, duration : float ) : bool;	
	
	
	import final latent function ActionMoveOnCurveTo( target : Vector, duration : float, rightShift : bool ) : bool;	
	
	import final function ActionMoveOnCurveToAsync( target : Vector, duration : float, rightShift : bool ) : bool;	

	
	import final latent function ActionSlideToWithHeading( target : Vector, heading : float, duration : float, optional rotation : ESlideRotation  ) : bool;	
	
	import final function ActionSlideToWithHeadingAsync( target : Vector, heading : float, duration : float, optional rotation : ESlideRotation  ) : bool;
	
	
	import final latent function ActionMoveAwayFromNode( position : CNode, distance : float, optional moveType : EMoveType, optional absSpeed : float, optional radius : float, optional failureAction : EMoveFailureAction ) : bool;	
	
	import final function ActionMoveAwayFromNodeAsync( position : CNode, distance : float, optional moveType : EMoveType, optional absSpeed : float, optional radius : float, optional failureAction : EMoveFailureAction ) : bool;	
	
	
	
	import final latent function ActionMoveAwayFromLine( positionA : Vector, positionB : Vector, distance : float, makeMinimalMovement : bool, optional moveType : EMoveType, optional absSpeed : float, optional radius : float, optional failureAction : EMoveFailureAction ) : bool;	
	
	
	import final function ActionMoveAwayFromLineAsync( positionA : Vector, positionB : Vector, distance : float, makeMinimalMovement : bool, optional moveType : EMoveType, optional absSpeed : float, optional radius : float, optional failureAction : EMoveFailureAction ) : bool;	
	
	
	import final latent function ActionRotateTo( target : Vector ) : bool;	
	
	import final function ActionRotateToAsync( target : Vector ) : bool;
	
	
	import final latent function ActionSetOrientation( orientation : float ) : bool;	

	
	import final latent function ActionPlaySlotAnimation( slotName : name, animationName : name, optional blendIn : float, optional blendOut : float, optional continuePlaying : bool ) : bool;
	import final function ActionPlaySlotAnimationAsync( slotName : name, animationName : name, optional blendIn : float, optional blendOut : float, optional continuePlaying : bool ) : bool;
	
	
	import final latent function ActionExitWork( optional fast : bool ) : bool;
	
	import final function ActionExitWorkAsync( optional fast : bool ) : bool;
	
	
	
	
	
	
	
	
	import final latent function ActionExploration( exploration : SExplorationQueryToken, optional listener : IScriptable, optional steeringGraphTargetNode : CNode ) : bool;
	
	import final latent function ActionAnimatedSlideToStatic( settings : SAnimatedSlideSettings, target : Vector, heading : float, translation : bool, rotation : bool ) : bool;
	import final latent function ActionAnimatedSlideTo( settings : SAnimatedSlideSettings, target : CNode, translation : bool, rotation : bool ) : bool;	
	
	import final function ActionAnimatedSlideToStaticAsync( settings : SAnimatedSlideSettings, target : Vector, heading : float, translation : bool, rotation : bool ) : bool;	
	import final function ActionAnimatedSlideToAsync( settings : SAnimatedSlideSettings, target : CNode, translation : bool, rotation : bool ) : bool;
	import final function ActionAnimatedSlideToStaticAsync_P( settings : SAnimatedSlideSettings, target : Vector, heading : float, translation : bool, rotation : bool, out animProxy : CActionMoveAnimationProxy ) : bool;	
	import final function ActionAnimatedSlideToAsync_P( settings : SAnimatedSlideSettings, target : CNode, translation : bool, rotation : bool, out animProxy : CActionMoveAnimationProxy ) : bool;
	
	import final latent function ActionMatchTo( settings : SAnimatedSlideSettings, target : SActionMatchToTarget ) : bool;
	import final function ActionMatchToAsync( settings : SActionMatchToSettings, target : SActionMatchToTarget ) : bool;	
	import final function ActionMatchToAsync_P( settings : SActionMatchToSettings, target : SActionMatchToTarget, out animProxy : CActionMoveAnimationProxy ) : bool;
	
	
	
	import final function GetSkeletonType() : ESkeletonType;
	
	import final function GetFallTauntEvent() : string;
	
	
	latent function RotateTo( target : Vector, optional duration : float ) : bool
	{
		var vec, pos : Vector;
		var heading : float;
		var res : bool;
		
		if( duration <= 0.0 )
			duration = 0.2;
		
		pos = GetWorldPosition();
		vec = target - GetWorldPosition();
		heading = VecHeading( vec );
		res = ActionSlideToWithHeading( pos, heading, duration );
		return res;
	}
	
	
	latent function RotateToNode( node : CNode, optional duration : float ) : bool
	{
		var res : bool;
		res = RotateTo( node.GetWorldPosition(), duration );
		return res;
	}
	
	
	
	import final function SetErrorState( description : string );
	
	
	import final function GetRadius() : float;
	
	
	import final function GetVisualDebug() : CVisualDebug;
	
	
	event OnBehTreeEnded(){}

	
	import final function PlayVoiceset( priority : int, voiceset : string, optional breakCurrentSpeach : bool ) : bool;
	
	
	import final function StopAllVoicesets( optional cleanupQueue : bool );
	
	import final function HasVoiceset( voiceset : string ) : EAsyncCheckResult;
	
	
	import final function IsRotatedTowards( node : CNode, optional maxAngle : float  ) : bool;
	
	
	import final function IsRotatedTowardsPoint( point : Vector, optional maxAngle : float  ) : bool;
	

	
	import protected final function GetAliveFlag() : bool;
	
	public final function IsAlive() : bool
	{
		
		return GetAliveFlag();
	}
	
	
	public function Heal(amount : float)
	{
		if(amount <= 0)
			return;
			
		if(UsesVitality())
			GainStat(BCS_Vitality, amount);
		else if (UsesEssence())
			GainStat(BCS_Essence, amount);
	}
	
	public function SetHealthPerc( amount : float )
	{
		var stat		: EBaseCharacterStats;
		var maxHealth	: float;
		if(amount < 0)
			return;
			
		if(UsesVitality())
			stat = BCS_Vitality;
		else if (UsesEssence())
			stat = BCS_Essence;
		
		maxHealth = GetMaxHealth();
		
		ForceSetStat( stat, amount * maxHealth );
	}
	
	public function SetHealth( amount : float )
	{
		var stat		: EBaseCharacterStats;
		
		if(amount < 0)
			return;
			
		if(UsesVitality())
			stat = BCS_Vitality;
		else if (UsesEssence())
			stat = BCS_Essence;
		
		ForceSetStat( stat, amount );
	}
	
	
	import final function SetAlive( flag : bool );
	
	
	import final function IsExternalyControlled() : bool;
	
	
	import final function IsMoving() : bool;
	
	
	import final function GetMoveDestination() : Vector;
	
	
	import final function GetPositionOrMoveDestination() : Vector;
	
	import final function GetVoicetag() : name;
	
	
	import final function EnableCollisions( val : bool );
	
	
	

	
	import final function PredictWorldPosition( inTime : float ) : Vector;
	
	
	import final function GetHeadAngleHorizontal() : float;
	
	
	import final function GetHeadAngleVertical() : float;
	
	import final function GetMovingAgentComponent() : CMovingAgentComponent;

	import final function GetMorphedMeshManagerComponent() : CMorphedMeshManagerComponent; 
	
	import final function EnablePathEngineAgent( flag : bool );
	
	import final function EnableCollisionInfoReportingForItem( itemId : SItemUniqueId, enable : bool );
	
	import final function EnablePhysicalMovement( enable : bool ) : bool;
	
	import final function EnableStaticCollisions( enable : bool ) : bool;
	
	import final function EnableDynamicCollisions( enable : bool ) : bool;
	
	import final function EnableCharacterCollisions( enable : bool ) : bool;
	
	import final function PushInDirection( pusherPos : Vector, direction : Vector, optional speed : float, optional playAnimation : bool, optional applyRotation : bool );
	
	import final function PushAway( pusher : CMovingAgentComponent, optional strength : float, optional speed : float );
	
	
	import final function IsRagdollObstacle() : bool;
	
	import final function ForceAIBehavior( tree : IAITree, forceLevel : EArbitratorPriorities, optional forceEventName : name ) : int;
	import final function CancelAIBehavior( forceActionId : int ) : bool;
	
	function IsFrozen() : bool
	{
		return HasBuff( EET_Frozen );
	}
	
	
	
	
	
	
	
	import final function ClearRotationTarget();
	
	
	import final function SetRotationTarget( node : CNode, optional clamping : bool  );
	
	
	import final function SetRotationTargetPos( position : Vector, optional clamping : bool  );
	
	final function SetRotationTargetWithTimeout( node : CNode, clamping : bool, optional timeout : float )
	{
		if( timeout == 0.0 )
		{
			timeout = 10.0;
		}
	
		SetRotationTarget( node, clamping );
		AddTimer('ClearRotationTargetTimer', timeout, false );
	}
	
	final function ClearRotationTargetWithTimeout()
	{
		ClearRotationTarget();
		RemoveTimer('ClearRotationTargetTimer');
	}
	
	timer function ClearRotationTargetTimer( td : float , id : int)
	{
		ClearRotationTarget();
	}

	
	
	
	import final function InAttackRange( target : CGameplayEntity, optional rangeName : name ) : bool;
	
	
	import final function GetNearestPointInPersonalSpace( position : Vector ) : Vector;
	
	
	import final function GetNearestPointInPersonalSpaceAt( myPosition : Vector, otherPosition : Vector ) : Vector;
	
	
	import final function GatherEntitiesInAttackRange( out entities : array< CGameplayEntity >, optional rangeName : name );
	
	
	function GetNearestPoint( position : Vector, distance : float ) : Vector
	{
		var vec : Vector;
		vec = GetWorldPosition() - position;
		return position + ( VecNormalize2D( vec ) ) * distance; 
	}
	
	
	function GetNearestPointInBothPersonalSpaces( position : Vector ) : Vector
	{
		return GetNearestPointInBothPersonalSpacesAt( this.GetWorldPosition(), position );
	}
	
	
	function GetNearestPointInBothPersonalSpacesAt( myPosition : Vector, otherPosition : Vector ) : Vector
	{
		var pos 			: Vector;
		var playerRadius 	: float;
		
		playerRadius = ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent()).GetCapsuleRadius();
		pos = playerRadius * VecNormalize2D( otherPosition - myPosition ) + this.GetNearestPointInPersonalSpaceAt( myPosition, otherPosition );
		
		return pos;
	}
	
	function GetVectorBetweenTwoNearestPoints( actorA, actorB : CActor ) : Vector
	{
		var actorANearestPoint	: Vector;
		var actorBNearestPoint	: Vector;
		
		actorANearestPoint = actorA.GetNearestPointInPersonalSpace( actorB.GetWorldPosition() );
		actorBNearestPoint = actorB.GetNearestPointInPersonalSpace( actorA.GetWorldPosition() );
		return actorBNearestPoint - actorANearestPoint;
	}
	
	public function IsOnGround() : bool
	{
		var distFromGround : float;
		
		distFromGround = GetDistanceFromGround(1.5);
		
		if( distFromGround < 0.15f ) 
		{
			return true;
		}
		else if ( distFromGround < 1.5 )
		{
			if ( !MAC )
			{
				MAC = (CMovingPhysicalAgentComponent)GetMovingAgentComponent();
			}
			
			if ( MAC )
			{
				return MAC.IsOnGround();
			}
		}
		
		return false;
	}
	
	public function IsFalling() : bool
	{
		if ( !MAC )
		{
			MAC = (CMovingPhysicalAgentComponent)GetMovingAgentComponent();
		}
		
		if ( MAC )
		{
			return MAC.IsFalling();
		}
		else 
		{
			return false;
		}
	}
	
	public  function GetDistanceFromGround( _MaxTestDistance : float, optional _CollisionGroupNames : array<name> ) : float
	{
		var l_pos, l_ground, l_normal 	: Vector;
		var l_groundZ					: float;
		var l_distance					: float;
		
		l_pos = GetWorldPosition();
		
		
		if ( theGame.GetWorld().NavigationComputeZ( l_pos, l_pos.Z - _MaxTestDistance, l_pos.Z + _MaxTestDistance, l_groundZ ) )
		{
			l_distance = l_pos.Z - l_groundZ;
			return l_distance;
		}
		
		return _MaxTestDistance;
	}

	
	
	
	import final function IsAttackableByPlayer() : bool;
	
	
	import final function SetAttackableByPlayerPersistent( flag : bool );
	
	
	import final function SetAttackableByPlayerRuntime( flag : bool, optional timeout : float  );
	
	
	
	
	import final function SetVisibility( isVisible : bool );
	import final function GetVisibility() : bool;
	
	public function SetGameplayVisibility( b : bool ) { isGameplayVisible = b; }
	public function GetGameplayVisibility(): bool 
	{ 
		if ( this.HasAbility( 'PersistentCameraLock' ) && thePlayer.GetTarget() == this && thePlayer.IsHardLockEnabled() )
			return true;
		else
			return isGameplayVisible; 
	}
	
	
	import final function SetAppearance( appearanceName : CName );
	
	
	import final function GetAppearance() : name;

	
	import final function GetAnimationTimeMultiplier() : float;
	
	import final function CanStealOtherActor( actor : CActor) : bool;
	import final function ResetClothAndDangleSimulation();
	
	
	
	
	
	import final function SetAnimationTimeMultiplier( mult : float );
		
	
	public function SetAnimationSpeedMultiplier( mul : float, optional overrideExistingId : int ) : int
	{
		var causer : SAnimMultiplyCauser;
		var finalMul : float;
		var i,size : int;

		if( overrideExistingId != -1 )
		{
			size = animationMultiplierCausers.Size();

			for( i = 0; i < size; i += 1 )
			{
				if( animationMultiplierCausers[i].id == overrideExistingId )
				{
					animationMultiplierCausers[i].mul = mul;
					SetAnimationTimeMultiplier( CalculateFinalAnimationSpeedMultiplier() );
					return animationMultiplierCausers[i].id;
				}
			}
		}
			
		
		causer.mul = mul;
		causer.id = nextFreeAnimMultCauserId;
		
		nextFreeAnimMultCauserId += 1;
		
		animationMultiplierCausers.PushBack( causer );
				
		
		SetAnimationTimeMultiplier( CalculateFinalAnimationSpeedMultiplier() );
		
		return causer.id;
	}
	
	
	private function CalculateFinalAnimationSpeedMultiplier() : float
	{
		if(animationMultiplierCausers.Size() > 0)
			return animationMultiplierCausers[animationMultiplierCausers.Size()-1].mul;
		
		return 1;
	}
	
	
	public function ResetAnimationSpeedMultiplier(id : int)
	{
		var i,size : int;
		
		size = animationMultiplierCausers.Size();
		if(size == 0)
			return;	
		
		for(i=0; i<size; i+=1)
			if(animationMultiplierCausers[i].id == id)
				animationMultiplierCausers.Remove(animationMultiplierCausers[i]);
				
		if(animationMultiplierCausers.Size()+1 != size)
		{
			LogAssert(false, "CAnimatedComponent.ResetAnimationMultiplier: invalid causer ID passed, nothing removed!");
			return;
		}
		
		SetAnimationTimeMultiplier(CalculateFinalAnimationSpeedMultiplier());
	}
	
	public function ClearAnimationSpeedMultipliers()
	{
		animationMultiplierCausers.Clear();
		SetAnimationTimeMultiplier( 1.0f );
	}
	
	
	import final function CalculateHeight() : float;
	
	
	import final function SetBehaviorMimicVariable( varName : name, varValue : float ) : bool;
	
	
	
	
	
	
	import final function 			DrawItems   ( instant : bool, itemId : SItemUniqueId, optional itemId2 : SItemUniqueId, optional itemId3 : SItemUniqueId ) : bool;
	import final function 			HolsterItems( instant : bool, itemId : SItemUniqueId, optional itemId2 : SItemUniqueId, optional itemId3 : SItemUniqueId ) : bool;
	
	import final latent function 	DrawItemsLatent	 ( itemId : SItemUniqueId, optional itemId2 : SItemUniqueId, optional itemId3 : SItemUniqueId ) : bool;
	import final latent function 	HolsterItemsLatent( itemId : SItemUniqueId, optional itemId2 : SItemUniqueId, optional itemId3 : SItemUniqueId ) : bool;
	
	import final latent function 	DrawWeaponAndAttackLatent( itemId : SItemUniqueId ) : bool;

	import latent function 			WaitForFinishedAllLatentItemActions() : bool;
	
	
	import final function			IssueRequiredItems( leftItem : name, rightItem : name );
	import final function			SetRequiredItems( leftItem : name, rightItem : name );
	
	import final function			IssueRequiredItemsGeneric( items : array<name>, slots : array<name> );
	import final function			SetRequiredItemsGeneric( items : array<name>, slots : array<name> );
	
	import final latent function	ProcessRequiredItems( optional instant : bool );
	
	import final latent function 	ActivateAndSyncBehaviorWithItemsParallel( names : name, optional timeout : float ) : bool;
	import final latent function 	ActivateAndSyncBehaviorWithItemsSequence( names : name, optional timeout : float ) : bool;
	
	
	import final function UseItem( itemId : SItemUniqueId ) : bool;
	
	
	import final function EmptyHands();
	
	
	
	import final function PlayLine( stringId : int, subtitle : bool );
	
	import final function PlayLineByStringKey( stringKey : string, subtitle : bool );
	
	import final function EndLine();
	
	import final function IsSpeaking( optional stringId : int ) : bool;

	import final function PlayMimicAnimationAsync( animation : name ) : bool;
	
	final latent function WaitForEndOfSpeach()
	{
		SleepOneFrame();
		
		while( IsSpeaking() )
		{
			Sleep(0.1f);
		}
	}
	
	
	import final function PlayPushAnimation( pushDirection : EPushingDirection );

	
	import final function SetInteractionPriority( priority : EInteractionPriority );
	
	
	import final function GetInteractionPriority() : EInteractionPriority;
	
	
	import final function SetUnpushableTarget( target : CActor ) : CActor;
	
	
	import final function SetOriginalInteractionPriority( priority : EInteractionPriority );
	
	
	import final function RestoreOriginalInteractionPriority();
	
	
	import final function GetOriginalInteractionPriority() : EInteractionPriority;
	
	
	import final function SetGroupShadows( flag : bool );
	
	
	
	
	
	
	public function GetAttackableNPCsAndPlayersInRange(range : float, optional maxResults : int, optional tag : name) : array <CActor>
	{
		if(maxResults <= 0)
			maxResults = 1000000;
			
		return GetNPCsAndPlayersInRange(range, maxResults, tag, FLAG_Attitude_Neutral + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors + FLAG_ExcludeTarget);
	}
	
	public function GetNPCsAndPlayersInRange(range : float, optional maxResults : int, optional tag : name, optional queryFlags : int) : array <CActor>
	{
		var i : int;
		var actors : array<CActor>;
		var entities : array<CGameplayEntity>;
		var actorEnt : CActor;
	
		
		if((queryFlags & FLAG_Attitude_Neutral) == 0 && (queryFlags & FLAG_Attitude_Hostile) == 0 && (queryFlags & FLAG_Attitude_Friendly) == 0)
			queryFlags = queryFlags | FLAG_Attitude_Neutral | FLAG_Attitude_Hostile | FLAG_Attitude_Friendly;

		
		if(maxResults <= 0)
			maxResults = 1000000;
			
		
		FindGameplayEntitiesInSphere(entities, GetWorldPosition(), range, maxResults, tag, queryFlags, this);
		
		
		for(i=0; i<entities.Size(); i+=1)
		{
			actorEnt = (CActor)entities[i];
			if(actorEnt)
				actors.PushBack(actorEnt);
		}
		
		return actors;
	}
	
	public function GetAttackableNPCsAndPlayersInCone(range : float, coneDir : float, coneAngle : float, optional maxResults : int, optional tag : name) : array <CActor>
	{
		if(maxResults <= 0)
			maxResults = 1000000;
			
		return GetNPCsAndPlayersInCone(range, coneDir, coneAngle, maxResults, tag, FLAG_Attitude_Neutral + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors + FLAG_ExcludeTarget);
	}
	
	public function GetNPCsAndPlayersInCone(range : float, coneDir : float, coneAngle : float, optional maxResults : int, optional tag : name, optional queryFlags : int) : array <CActor>
	{
		var i : int;
		var actors : array<CActor>;
		var entities : array<CGameplayEntity>;
		var actor : CActor;
		
		
		if((queryFlags & FLAG_Attitude_Neutral) == 0 && (queryFlags & FLAG_Attitude_Hostile) == 0 && (queryFlags & FLAG_Attitude_Friendly) == 0)
			queryFlags = queryFlags | FLAG_Attitude_Neutral | FLAG_Attitude_Hostile | FLAG_Attitude_Friendly;

		
		if(maxResults <= 0)
			maxResults = 1000000;

		
		FindGameplayEntitiesInCone(entities, GetWorldPosition(), coneDir, coneAngle, range, maxResults, tag, queryFlags, this);
				
		for(i=0; i<entities.Size(); i+=1)
		{
			actor = (CActor)entities[i];
			if(actor)
				actors.PushBack(actor);
		}
		
		return actors;
	}
	
	
	
	
	
	event OnSpawned( spawnData : SEntitySpawnData )
	{	
		super.OnSpawned(spawnData);
		
		AddAnimEventCallback( 'RotateEvent',		'OnAnimEvent_RotateEvent' );
		AddAnimEventCallback( 'RotateAwayEvent',	'OnAnimEvent_RotateAwayEvent' );
		
		AddAnimEventCallback( 'Shake0',				'OnAnimEvent_Shake0' );
		AddAnimEventCallback( 'Shake1',				'OnAnimEvent_Shake1' );
		AddAnimEventCallback( 'Shake2',				'OnAnimEvent_Shake2' );
		AddAnimEventCallback( 'Shake3',				'OnAnimEvent_Shake3' );
		AddAnimEventCallback( 'Shake4',				'OnAnimEvent_Shake4' );
		AddAnimEventCallback( 'Shake5',				'OnAnimEvent_Shake5' );
		AddAnimEventCallback( 'DropItem',			'OnAnimEvent_DropItem' );
		AddAnimEventCallback( 'OnGround',			'OnAnimEvent_OnGround' );
		AddAnimEventCallback( 'Death',				'OnAnimEvent_Death' );
		AddAnimEventCallback( 'MountHorseType',		'OnAnimEvent_MountHorseType' );
		AddAnimEventCallback( 'HorseRidingOn',		'OnAnimEvent_HorseRidingOn' ); 
		AddAnimEventCallback( 'item_track_hack_reading_book', 'OnAnimEvent_item_track_hack_reading_book' );
		AddAnimEventCallback( 'item_track_hack_reading_book_unmount', 'OnAnimEvent_item_track_hack_reading_book_unmount' );
	
		effectsUpdateTicking = false;
		SetBehaviorVariable( 'CriticalStateType', (int)ECST_None );		
			
		if(!spawnData.restored)
		{
			SetAbilityManager();		
			if(abilityManager)
				abilityManager.Init(this, GetCharacterStats(), false, theGame.GetSpawnDifficultyMode());
			
			SetEffectManager();			
		}
		else
		{
			if(abilityManager)
				abilityManager.Init(this, GetCharacterStats(), true, theGame.GetSpawnDifficultyMode());
				
			if(effectManager)
				effectManager.OnLoad(this);
			else
				SetEffectManager();		
		}
		
		if(abilityManager)
			abilityManager.PostInit();						
		
		ClearAnimationSpeedMultipliers();
		SetGameplayVisibility( true );
		
		MountHorseIfNeeded();
		
		
		if(effectManager)
			ResumeStaminaRegen( 'SignCast' );
	}
	
	protected function SetEffectManager()
	{
		effectManager = new W3EffectManager in this;
		effectManager.Initialize( this );
	}
	
	public function MountHorseIfNeeded()
	{
		var vehicle : CVehicleComponent;	
		if ( usedVehicle )
		{
			return;
		}
		
		usedVehicle = (CGameplayEntity)EntityHandleGet(usedVehicleHandle);
			
		if( usedVehicle )
		{
			
			if ( VecDistance2D( usedVehicle.GetWorldPosition(), this.GetWorldPosition() ) > 100 )
			{
				usedVehicle = NULL;
				EntityHandleSet( usedVehicleHandle, NULL );
			}
			else
			{
				vehicle = (CVehicleComponent)usedVehicle.GetComponentByClassName('CVehicleComponent');
				vehicle.Mount( this, VMT_ImmediateUse, EVS_driver_slot );					
			}		
		}		
	}
	
	public function UpdateSoundInfo()
	{
		var cr4HumanoidCombatComponent 	: CR4HumanoidCombatComponent;
		var defMapping 					: SSoundInfoMapping;
		
		if(IsHuman())
		{		
			cr4HumanoidCombatComponent = (CR4HumanoidCombatComponent)GetComponentByClassName( 'CR4HumanoidCombatComponent' );
			if( cr4HumanoidCombatComponent )
			{
				cr4HumanoidCombatComponent.UpdateSoundInfo();
				defMapping = cr4HumanoidCombatComponent.GetDefaultSoundInfoMapping();
				if(  defMapping.isDefault )
				{
					if( defMapping.soundTypeIdentification != 'default' && defMapping.soundTypeIdentification != '' )
					{
						SoundSwitch( "armour_type_movement", defMapping.soundTypeIdentification );	
					}
				}
			}
		}
	}
	
	timer function DelaySoundInfoUpdate(dt : float , id : int)
	{
		UpdateSoundInfo();
	}
	
	event OnForceUpdateSoundInfo()
	{
		UpdateSoundInfo();
	}
	
	event OnAppearanceChanged()
	{		
		AddTimer('DelaySoundInfoUpdate', 1);
	}
		
	public timer function RestoreOriginalInteractionPriorityTimer( optional deltaTime : float , id : int)
	{
		RestoreOriginalInteractionPriority();
	}
	
	
	public function CanBeTeleporting() : bool
	{
		var temp : EMonsterCategory;
		var temp2 : name;
		var temp3, temp4, teleports : bool;
		
		theGame.GetMonsterParamsForActor(this, temp, temp2, teleports, temp3, temp4);
		return teleports;
	}
	
	public function CanBeStrafed() : bool
	{
		var temp : CMonsterParam;
		
		theGame.GetMonsterParamForActor( this, temp );
		return temp.canBeStrafed;
	}
	
	public function CanBeTargeted() : bool
	{
		var temp : EMonsterCategory;
		var temp2 : name;
		var temp3, temp4, canBeTargeted : bool;
				
		if ( !IsTargetableByPlayer() )
			return false;
				
		theGame.GetMonsterParamsForActor(this, temp, temp2, temp3, canBeTargeted, temp4);
		return canBeTargeted;
	}
	
	private var cachedIsHuman : int;	default cachedIsHuman = -1;
	public function IsHuman() : bool
	{
		var monsterCategory : EMonsterCategory;
		var temp2 : name;
		var temp3, temp4, canBeTargeted : bool;
		
		if ( cachedIsHuman != -1 )
			return cachedIsHuman > 0;
		
		theGame.GetMonsterParamsForActor(this, monsterCategory, temp2, temp3, canBeTargeted, temp4);
		
		if ( monsterCategory == MC_Human )
			cachedIsHuman = 1;
		else
			cachedIsHuman = 0;
		
		return cachedIsHuman;
	}
	
	private var cachedIsWoman : int;	default cachedIsWoman = -1;
	public function IsWoman() : bool
	{
		if ( cachedIsWoman != -1 )
			return cachedIsWoman > 0;
			
		if ( GetMovingAgentComponent().GetName() == "woman_base" || GetMovingAgentComponent().GetName() == "noble_woman_base" )
			cachedIsWoman = 1;
		else
			cachedIsWoman = 0;
		
		return cachedIsWoman;
	}
	
	private var cachedIsMan : int;	default cachedIsMan = -1;
	public function IsMan() : bool
	{
		if ( cachedIsMan != -1 )
			return cachedIsMan > 0;
			
		if ( GetMovingAgentComponent().GetName() == "man_base" )
			cachedIsMan = 1;
		else
			cachedIsMan = 0;
		
		return cachedIsMan;
	}
	
	private var cachedIsMonster : int;	default cachedIsMonster = -1;
	public function IsMonster() : bool
	{
		var monsterCategory : EMonsterCategory;
		var temp2 : name;
		var temp3, temp4, canBeTargeted : bool;
		
		if ( cachedIsMonster != -1 )
			return cachedIsMonster > 0;
		
		theGame.GetMonsterParamsForActor(this, monsterCategory, temp2, temp3, canBeTargeted, temp4);
		
		if ( MonsterCategoryIsMonster( monsterCategory ) )
			cachedIsMonster = 1;
		else
			cachedIsMonster = 0;
		
		return cachedIsMonster;
	}
	
	private var cachedIsAnimal : int;	default cachedIsAnimal = -1;
	public function IsAnimal() : bool
	{
		var monsterCategory : EMonsterCategory;
		var tmpName : name;
		var tmpBool : bool;
		
		if ( cachedIsAnimal != -1 )
			return cachedIsAnimal > 0;
		
		theGame.GetMonsterParamsForActor(this, monsterCategory, tmpName, tmpBool, tmpBool, tmpBool);
		
		if ( monsterCategory == MC_Animal )
			cachedIsAnimal = 1;
		else
			cachedIsAnimal = 0;
		
		return cachedIsAnimal;
	}
	
	private var cachedIsVampire : int;	default cachedIsVampire = -1;
	public function IsVampire() : bool
	{
		var monsterCategory : EMonsterCategory;
		var tmpName : name;
		var tmpBool : bool;
		
		if ( cachedIsVampire != -1 )
			return cachedIsVampire > 0;
		
		theGame.GetMonsterParamsForActor(this, monsterCategory, tmpName, tmpBool, tmpBool, tmpBool);
		
		if ( monsterCategory == MC_Vampire )
			cachedIsVampire = 1;
		else
			cachedIsVampire = 0;
		
		return cachedIsVampire;
	}
	
	protected function SetAbilityManager();
	
	timer function CheckBlockedAbilities(dt : float, id : int)
	{
		var nextCallTime : float;
		
		nextCallTime = abilityManager.CheckBlockedAbilities(dt);		
		
		if(nextCallTime != -1)
			AddTimer('CheckBlockedAbilities', nextCallTime, , , , true);
	}
	
	protected function GetKillAction( source : name, optional ignoreImmortalityMode : bool, optional attacker : CGameplayEntity ) : W3DamageAction
	{
		var vit, ess : float;
		var action : W3DamageAction;
		var dmg : CDamageData;
	
		vit = abilityManager.GetStatMax(BCS_Vitality);
		ess = abilityManager.GetStatMax(BCS_Essence);
		
		if ( !IsNameValid(source) )
			source = 'Kill';
		
		action = new W3DamageAction in theGame.damageMgr;
		action.Initialize(attacker, this, theGame, source, EHRT_None, CPS_Undefined, false, false, false, true);
		action.AddDamage(theGame.params.DAMAGE_NAME_DIRECT, MaxF(vit,ess));
		action.SetIgnoreImmortalityMode(ignoreImmortalityMode);
		action.SetCanPlayHitParticle(false);
		action.SetSuppressHitSounds(true);
		return action;
	}
	
	function Kill(source : name, optional ignoreImmortalityMode : bool, optional attacker : CGameplayEntity)
	{
		var action : W3DamageAction;
		
		if ( theGame.CanLog() )
		{
			LogDMHits( "CActor.Kill: called for actor <<" + this + ">> with source <<" + source + ">>" );
		}
		
		action = GetKillAction( source, ignoreImmortalityMode, attacker );		
		
		theGame.damageMgr.ProcessAction( action );
		
		delete action;
	}
	
	
	private function InterfaceKill( force : bool, attacker : CActor )
	{
		Kill( 'From Code', force);
	}
	
	
	
	
	
	
	import function EnableStaticLookAt( point : Vector, duration : float );

	
	import function EnableDynamicLookAt( node : CNode, duration : float );
	
	
	import function DisableLookAt();
	
	
	import function SetLookAtMode( mode : ELookAtMode );
	
	
	import function ResetLookAtMode( mode : ELookAtMode );
	
	

	public function HasStaminaToParry( attActionName : name ) : bool
	{
		var multiplier : float;
	
		if( IsHeavyAttack( attActionName ) )
			multiplier = theGame.params.HEAVY_STRIKE_COST_MULTIPLIER;
			
		return HasStaminaToUseAction( ESAT_Parry, '', 0, multiplier );
	}
	
	public function CanParryAttack() : bool
	{
		return bParryEnabled && IsGuarded();
	}
	
	public function CanCounterParryAttack(attActionName : name ) : bool
	{
		return CanParryAttack() && CanPerformCounter() && HasStaminaToParry(attActionName);
	}
	
	public function FistFightCheck( target, attacker : CActor, out bothUsingFists : bool ) : bool
	{
		var i, j, size, size2					: int;
		var targetFists, attackerFists	: array<SItemUniqueId>;
		var targetInv, attackerInv : CInventoryComponent;
		
		targetInv = target.GetInventory();
		targetFists = targetInv.GetItemsByCategory( 'fist' );
		size = targetFists.Size();
		
		if ( size <= 0 )
			return true;
			
		attackerInv = attacker.GetInventory();
		attackerFists = attackerInv.GetItemsByCategory( 'fist' );
		size2 = attackerFists.Size();
		
		if ( size2 > 0 )		
		{
			for ( i = 0; i < size ; i += 1 )
			{
				if ( targetInv.IsItemHeld( targetFists[i] ) )
				{
					for ( j = 0; j < size2 ; j += 1 ) 
					{
						if ( attackerInv.IsItemHeld( attackerFists[j] ) )
						{
							bothUsingFists = true;
							return true;
						}
					}
					return false;
				}
			}
			return true;
		}
		else
		{
			for ( i = 0; i < size ; i += 1 )
			{
				if ( targetInv.IsItemHeld( targetFists[i] ) )
					return false;
			}		
			return true;		
		}
	}
	
	
	public function ProcessSwordOrFistHitReaction( target, attacker : CActor ) : float
	{
		var i, j, size					: int;
		var targetFists, attackerFists	: array<SItemUniqueId>;
		
		targetFists = target.GetInventory().GetItemsByCategory( 'fist' );
		size = targetFists.Size();
		
		if ( size > 0 )
		{
			attackerFists = attacker.GetInventory().GetItemsByCategory( 'fist' );
		
			for ( i = 0; i < size ; i += 1 )
			{
				if ( target.GetInventory().IsItemHeld( targetFists[i] ) )
				{
					for ( j = 0; j < attackerFists.Size() ; j += 1 ) 
					{
						if ( attacker.GetInventory().IsItemHeld( attackerFists[j] ) )
							return 1.f; 
					}
					
					return 0;
				}
			}
		}
		
		return 0.f;	
	}
	
	
	public function IsWeaponHeld( itemCategory : name ) : bool
	{
		var items : array <SItemUniqueId>;
		var i : int;
		var inv : CInventoryComponent;
		
		inv = GetInventory();
		items = inv.GetItemsByCategory( itemCategory );
		
		for( i = 0 ; i < items.Size(); i += 1 )
		{
			if( inv.IsItemHeld(items[i]) )
			{
				return true;
			}
		}
		return false;
	}
	
	
	public function IsAnyWeaponHeld() : bool
	{
		return IsWeaponHeld('silversword') || IsWeaponHeld('steelsword') || IsWeaponHeld('fist');
	}
	
	public function IsSecondaryWeaponHeld() : bool
	{
		var heldWeapons : array <SItemUniqueId>;
		var isSecondaryWeaponHeld : bool;
		var i : int;
		var inv : CInventoryComponent;
		
		inv = GetInventory();		
		heldWeapons = inv.GetHeldWeapons();
		for ( i = 0; i < heldWeapons.Size(); i += 1 )
		{
			isSecondaryWeaponHeld = inv.ItemHasTag( heldWeapons[i], 'SecondaryWeapon' );
			
			if ( isSecondaryWeaponHeld )
				break;
		}
		
		return isSecondaryWeaponHeld;
	}
	
	public function IsSwordWooden() : bool
	{
		var heldWeapons				: array<SItemUniqueId>;
		var i						: int;
		var isSwordWooden			: bool;
		var inv : CInventoryComponent;
	
		inv = GetInventory();		
		heldWeapons = inv.GetHeldWeapons();
	
		for ( i = 0; i < heldWeapons.Size(); i += 1 )
		{
			isSwordWooden = inv.ItemHasTag( heldWeapons[i], 'Wooden' );
			
			if ( isSwordWooden )
				break;
		}			
		
		return isSwordWooden;
	}
	
	public function IsDeadlySwordHeld() : bool
	{
		if ( IsSwordWooden() )
			return false;
			
		if ( IsSecondaryWeaponHeld() )
			return false;
		
		if ( IsWeaponHeld( 'fist' ) )
			return false;
	
		return true;
	}	
	
	public function SetIsCurrentlyDodging(b : bool, optional isRolling : bool)
	{
		isCurrentlyDodging = b;
		
		
		theGame.GetBehTreeReactionManager().CreateReactionEventIfPossible( this, 'MoveNoise', -1, 30.0f, -1.f, -1, true ); 
	}
	
	public final function IsCurrentlyDodging() : bool				{return isCurrentlyDodging;}
	
	public final function SetParryEnabled( flag : bool )
	{
		bParryEnabled = flag;
	}
	
	public final function GetLastAttackRangeName() : name
	{
		return lastAttackRangeName;
	}
	
	final function CanPerformCounter() : bool
	{
		return bCanPerformCounter;
	}
	
	
	public function IsGuarded() : bool
	{
		return bIsGuarded;
	}
	
	function SetGuarded( flag : bool )
	{
		if( bIsGuarded == true && flag == false )
		{
			lowerGuardTime = theGame.GetEngineTimeAsSeconds();
		}
		bIsGuarded = flag;
		SetBehaviorVariable( 'bIsGuarded', (int)bIsGuarded);
	}
	
	public final function CanGuard() : bool
	{
		var l_delayToWait   : float = CalculateAttributeValue( GetAttributeValue('delay_between_raise_guard') );		
		var l_currentDelay	: float;
		
		if( l_delayToWait <= 0 ) return true;
		
		l_currentDelay = theGame.GetEngineTimeAsSeconds() - lowerGuardTime;
		if( l_currentDelay >= l_delayToWait )
		{
			return true;
		}
		
		return false;
	}
	
	final function DisableHitAnimFor( time : float )
	{
		this.SetCanPlayHitAnim(false);
		AddTimer('EnableHitAnim', time, false, ,  ,true, true);
	}
	
	public final function UseAdditiveHit( ) : bool
	{
		return useAdditiveHits;
	}
	public final function SetUseAdditiveHit( _Flag : bool, optional _CriticalCancelAdditiveHit : bool, optional _OneTimeActivation : bool )
	{
		if ( _OneTimeActivation )
			oneTimeAdditiveHit 		= _OneTimeActivation;
		else
			useAdditiveHits 		= _Flag;
		criticalCancelAdditiveHit 	= _CriticalCancelAdditiveHit;
	}
	public final function UseAdditiveCriticalState() : bool
	{
		return useAdditiveCriticalStateAnim;
	}
	public final function SetUseAdditiveCriticalStateAnim( flag : bool )
	{
		useAdditiveCriticalStateAnim = flag;
	}
	function SetCanPlayHitAnim( flag : bool )
	{
		RemoveTimer('EnableHitAnim');
		canPlayHitAnim = flag;
	}
	final function CanPlayHitAnim() : bool
	{
		return canPlayHitAnim;
	}
	final function StopRotateEventAdjustments()
	{
		var movementAdjustor : CMovementAdjustor = GetMovingAgentComponent().GetMovementAdjustor();
		movementAdjustor.Cancel( movementAdjustor.GetRequest( 'RotateEvent' ) );
	}
	public function GetCriticalCancelAdditiveHit() : bool
	{
		return criticalCancelAdditiveHit;
	}
	
	
	
	
	public final function GetAbilityManager() : W3AbilityManager
	{
		return abilityManager;
	}
	
	
	
	
	
	
	public function DrainStamina(action : EStaminaActionType, optional fixedCost : float, optional fixedDelay : float, optional abilityName : name, optional dt : float, optional costMult : float)
	{
		if(abilityManager && abilityManager.IsInitialized() && IsAlive())
			abilityManager.DrainStamina(action, fixedCost, fixedDelay, abilityName, dt, costMult);
	}
	
	public function DrainAir( cost : float, optional regenDelay : float )
	{
		if(abilityManager && abilityManager.IsInitialized() && IsAlive())
			abilityManager.DrainAir(cost, regenDelay);
	}
	
	public function DrainSwimmingStamina( cost : float, optional regenDelay : float )
	{
		if(abilityManager && abilityManager.IsInitialized() && IsAlive())
			abilityManager.DrainSwimmingStamina(cost, regenDelay);
	}
	
	public function DrainMorale(amount : float)
	{
		if(abilityManager && abilityManager.IsInitialized() && IsAlive())
			abilityManager.DrainMorale(amount);
	}
	
	public function DrainVitality(amount : float)
	{
		if(abilityManager && abilityManager.IsInitialized() && IsAlive())
			abilityManager.DrainVitality(amount);
	}
	
	public function DrainEssence(amount : float)
	{
		if(abilityManager && abilityManager.IsInitialized() && IsAlive())
			abilityManager.DrainEssence(amount);
	}
	
	public function AddPanic( amount : float )
	{
		if(abilityManager && abilityManager.IsInitialized() && IsAlive())
			abilityManager.AddPanic( amount );
	}
	
	public function GainStat( stat : EBaseCharacterStats, amount : float )
	{
		if(abilityManager && abilityManager.IsInitialized() && IsAlive())
			abilityManager.GainStat(stat, amount);
	}
	
	public function UpdateStatMax(stat : EBaseCharacterStats)
	{
		if(abilityManager && abilityManager.IsInitialized() && IsAlive())
			abilityManager.UpdateStatMax(stat);
	}
	
	public function ForceSetStat(stat : EBaseCharacterStats, val : float)
	{		
		if(abilityManager && abilityManager.IsInitialized() && IsAlive())
			abilityManager.ForceSetStat(stat, val);
	}
	
	
	public function GetPowerStatValue(stat : ECharacterPowerStats, optional abilityName : name, optional ignoreDeath : bool) : SAbilityAttributeValue
	{
		var null : SAbilityAttributeValue;
		
		if(abilityManager && abilityManager.IsInitialized() && (ignoreDeath || IsAlive()) )
			return abilityManager.GetPowerStatValue(stat, abilityName);
		
		return null;
	}
	
	
	public function GetResistValue(stat : ECharacterDefenseStats, out points : float, out percents : float)
	{
		points = 0;
		percents = 0;
	
		if(abilityManager && abilityManager.IsInitialized() && IsAlive())
			abilityManager.GetResistValue(stat, points, percents);
	}
	
	public function ResumeEffects(type : EEffectType, sourceName : name)
	{
		if(effectManager && effectManager.IsReady())
			effectManager.ResumeEffects(type, sourceName);
	}
	
	
	
	
	public function PauseEffects(type : EEffectType, sourceName : name, optional singleLock : bool, optional duration : float, optional useMaxDuration : bool)
	{
		if(effectManager)
			effectManager.PauseEffects(type, sourceName, singleLock, duration, useMaxDuration);
	}
	
	public function HasDefaultAbilitySet() : bool
	{
		return GetCharacterStats().HasAbilityWithTag( theGame.params.BASE_ABILITY_TAG, true );
	}
	
	public function IgnoresDifficultySettings() : bool
	{
		if(abilityManager && abilityManager.IsInitialized())
			return abilityManager.IgnoresDifficultySettings();
			
		return true;
	}
	
	
	
	public function HasStaminaToUseAction( action : EStaminaActionType, optional abilityName : name, optional dt :float, optional multiplier : float ) : bool
	{
		var ret : bool;
		var cost : float;
		
		ret = false;
	
		if( abilityManager && abilityManager.IsInitialized() && IsAlive() )
		{
			if( multiplier == 0 )
				multiplier = 1;
				
			cost = multiplier * GetStaminaActionCost( action, abilityName, dt );
			ret = (GetStat(BCS_Stamina) >= cost);			
		}

		return ret;
	}
	
	
	public function GetStaminaActionCost(action : EStaminaActionType, optional abilityName : name, optional dt :float) : float
	{
		var cost, delay : float;
	
		if(abilityManager && abilityManager.IsInitialized() && IsAlive())
		{
			abilityManager.GetStaminaActionCost(action, cost, delay, 0, 0, abilityName, dt);
			return cost;
		}
		
		return -1;
	}
	
	
	public function GetStaminaActionDelay(action : EStaminaActionType, optional abilityName : name, optional dt :float) : float
	{
		var cost, delay : float;
	
		if(abilityManager && abilityManager.IsInitialized() && IsAlive())
		{
			abilityManager.GetStaminaActionCost(action, cost, delay, 0, 0, abilityName, dt);
			return delay;
		}
		
		return 0;
	}
	
	
	public function GetHealthPercents() : float
	{
		if( !abilityManager || !abilityManager.IsInitialized())
			return -1;
			
		if(UsesVitality())
			return abilityManager.GetStatPercents(BCS_Vitality);
		else if(UsesEssence())
			return abilityManager.GetStatPercents(BCS_Essence);
		else
			return -1;
	}
	
	public final function GetHealth() : float
	{
		if( !abilityManager || !abilityManager.IsInitialized())
			return -1;
			
		if(UsesVitality())
			return abilityManager.GetStat(BCS_Vitality);
		else if(UsesEssence())
			return abilityManager.GetStat(BCS_Essence);
		else
			return -1;
	}
	
	
	public function GetStaminaPercents() : float
	{
		if( !abilityManager || !abilityManager.IsInitialized())
			return -1;
			
		return abilityManager.GetStatPercents( BCS_Stamina );
	}
	
	
	public function GetMaxHealth() : float
	{
		var vit, ess : bool;
	
		vit = UsesVitality();
		ess = UsesEssence();
		
		if(vit && !ess)
			return GetStatMax(BCS_Vitality);
		else if(!vit && ess)
			return GetStatMax(BCS_Essence);
		else
			return -1;
	}
	
	public function GetCurrentHealth() : float
	{
		var vit, ess : bool;
	
		vit = UsesVitality();
		ess = UsesEssence();
		
		if(vit && !ess)
			return GetStat(BCS_Vitality);
		else if(!vit && ess)
			return GetStat(BCS_Essence);
		else
			return -1;
	}
			
	
	public final function UsesVitality() : bool
	{
		if(abilityManager )
			return abilityManager.UsedHPType() == BCS_Vitality;
			
		return false;
	}
	
	
	public function UsesEssence() : bool
	{
		if(abilityManager )
			return abilityManager.UsedHPType() == BCS_Essence;
			
		return false;
	}
	
	public function GetUsedHealthType() : EBaseCharacterStats
	{
		if(abilityManager && abilityManager.IsInitialized())
			return abilityManager.UsedHPType();
			
		return BCS_Undefined;
	}
	
	public function GetStat(stat : EBaseCharacterStats, optional ignoreLock : bool) : float
	{
		if(abilityManager && abilityManager.IsInitialized())
			return abilityManager.GetStat(stat, ignoreLock);
			
		return -1;
	}
	
	public function GetStatMax(stat : EBaseCharacterStats) : float
	{
		if(abilityManager && abilityManager.IsInitialized())
			return abilityManager.GetStatMax(stat);
			
		return -1;
	}

	public function GetStats(stat : EBaseCharacterStats, out curr : float, out max : float )
	{
		curr = -1;
		max  = -1;
		if ( abilityManager && abilityManager.IsInitialized() )
			abilityManager.GetStats( stat, curr, max );
	}
	
	
	public function GetStatPercents(stat : EBaseCharacterStats) : float
	{
		if(abilityManager && abilityManager.IsInitialized())
			return abilityManager.GetStatPercents(stat);
		
		return -1;
	}
	
	function GetThreatLevel() : int
	{
		return 0;
	}
	
	
	event OnTakeDamage( action : W3DamageAction )
	{		
		var playerAttacker : CPlayer;
		var attackName : name;
		var animatedComponent : CAnimatedComponent;
		var buff : W3Effect_Frozen;
		var buffs : array<CBaseGameplayEffect>;
		var i : int;
		var mutagen : CBaseGameplayEffect;
		var min, max : SAbilityAttributeValue;
		var lifeLeech, health, stamina : float;
		var wasAlive : bool;
		var hudModuleDamageType : EFloatingValueType;
		
		
		var dontShowDamage : bool;
		
		playerAttacker = (CPlayer)action.attacker;
		wasAlive = IsAlive();
		
		
		buffs = GetBuffs(EET_Frozen);
		for(i=0; i<buffs.Size(); i+=1)
		{
			buff = (W3Effect_Frozen)buffs[i];
			if(buff.KillOnHit())
			{
				action.processedDmg.vitalityDamage = GetStatMax(BCS_Vitality);
				action.processedDmg.essenceDamage = GetStatMax(BCS_Essence);
				if ( action.attacker == thePlayer )
				{
					ShowFloatingValue(EFVT_InstantDeath, 0, false);
				}
				break;
			}
		}
	
		if(action.processedDmg.vitalityDamage > 0 && UsesVitality())
		{
			
			if(this.HasAlternateQuen() && this.HasTag('mq1060_witcher'))
			{
				dontShowDamage = true;
			}
			else
			{
				DrainVitality(action.processedDmg.vitalityDamage);
				action.SetDealtDamage();
			}
			
		}
		if(action.processedDmg.essenceDamage > 0 && UsesEssence())
		{
			DrainEssence(action.processedDmg.essenceDamage);
			action.SetDealtDamage();
		}
		if(action.processedDmg.moraleDamage > 0)
			DrainMorale(action.processedDmg.moraleDamage);
		if(action.processedDmg.staminaDamage > 0)
			DrainStamina(ESAT_FixedValue, action.processedDmg.staminaDamage, 0);
			
		
		ShouldAttachArrowToPlayer( action );
		
		
		if( ((action.attacker && action.attacker == thePlayer) || (CBaseGameplayEffect)action.causer) && !action.GetUnderwaterDisplayDamageHack() )
		{
			if(action.GetInstantKillFloater())
			{
				hudModuleDamageType = EFVT_InstantDeath;
			}
			else if(action.IsCriticalHit())
			{
				hudModuleDamageType = EFVT_Critical;
			}
			else if(action.IsDoTDamage())
			{
				hudModuleDamageType = EFVT_DoT;
			}
			else
			{
				hudModuleDamageType = EFVT_None;
			}			
		
			
			if(!dontShowDamage)
				ShowFloatingValue(hudModuleDamageType, action.GetDamageDealt(), (hudModuleDamageType == EFVT_DoT) );
		}
		
		
		if(action.attacker && !action.IsDoTDamage() && wasAlive && action.GetDTCount() > 0 && !action.GetUnderwaterDisplayDamageHack())
		{
			theGame.witcherLog.CacheCombatDamageMessage(action.attacker, this, action.GetDamageDealt());
			theGame.witcherLog.AddCombatDamageMessage(action.DealtDamage());
		}
			
		
		if(playerAttacker)
		{
			if (thePlayer.HasBuff(EET_Mutagen07))
			{
				mutagen = thePlayer.GetBuff(EET_Mutagen07);
				theGame.GetDefinitionsManager().GetAbilityAttributeValue(mutagen.GetAbilityName(), 'lifeLeech', min, max);
				lifeLeech = CalculateAttributeValue(GetAttributeRandomizedValue(min, max));
				if (UsesVitality())
					lifeLeech = lifeLeech * action.processedDmg.vitalityDamage;
				else if (UsesEssence())
					lifeLeech = lifeLeech * action.processedDmg.essenceDamage;
				else
					lifeLeech = 0;
				
				thePlayer.GainStat(BCS_Vitality, lifeLeech);
			}			
		}
		
		
		if(playerAttacker && action.IsActionMelee())
		{
			attackName = ((W3Action_Attack)action).GetAttackName();
		
			
			if ( thePlayer.HasBuff(EET_Mutagen04) && action.DealsAnyDamage() && thePlayer.IsHeavyAttack(attackName) && thePlayer.GetStat(BCS_Stamina) > 0)
			{
				mutagen = thePlayer.GetBuff(EET_Mutagen04);
				theGame.GetDefinitionsManager().GetAbilityAttributeValue(mutagen.GetAbilityName(), 'staminaCostPerc', min, max);
				stamina = CalculateAttributeValue(GetAttributeRandomizedValue(min, max));
				stamina *= thePlayer.GetStat(BCS_Stamina);
				theGame.GetDefinitionsManager().GetAbilityAttributeValue(mutagen.GetAbilityName(), 'healthReductionPerc', min, max);
				health = CalculateAttributeValue(GetAttributeRandomizedValue(min, max));
				if (UsesVitality())
				{
					health *= GetStat(BCS_Vitality);
					DrainVitality(health);					
					thePlayer.DrainStamina(ESAT_FixedValue, stamina, 0.5f);
				}
				else if (UsesEssence())
				{
					health *= GetStat(BCS_Essence);
					DrainEssence(health);					
					thePlayer.DrainStamina(ESAT_FixedValue, stamina, 0.5f);
				}
				
				if(health > 0)
					action.SetDealtDamage();
			}
		}
		
		
		if( !IsAlive() )
		{
			
			
			
			
			
			
			OnDeath( action );
		}
		
		
		SignalGameplayDamageEvent('DamageTaken', action );
	}
	
	public function Revive()
	{
		var maxVitality, maxEssence : float;
		
		if ( !IsAlive() || IsKnockedUnconscious() )
		{			
			OnRevived();				
			
			if(effectManager)
				effectManager.OnOwnerRevived();
				
			abilityManager.OnOwnerRevived();
		}		
	}
	
	
	public function ApplyActionEffects( action : W3DamageAction ) : bool
	{
		if(effectManager)
			return effectManager.AddEffectsFromAction( action );
			
		return false;
	}
	
	
	public function GetHitCounter(optional total : bool) : int
	{
		if ( total )
			return totalHitCounter;
		return hitCounter;
	}
	
	public function IncHitCounter()
	{
		hitCounter += 1;
		totalHitCounter += 1;
		AddTimer('ResetHitCounter',2.0,false);
	}
	
	public timer function ResetHitCounter( deta : float , id : int)
	{
		hitCounter = 0;
	}
	
	
	public function GetDefendCounter(optional total : bool) : int
	{
		if ( total )
			return totalDefendCounter;
		return defendCounter;
	}
	
	public function IncDefendCounter()
	{
		defendCounter += 1;
		totalDefendCounter += 1;
		AddTimer('ResetDefendCounter',2.0,false);
	}
	
	public timer function ResetDefendCounter( deta : float , id : int)
	{
		defendCounter = 0;
	}
	
	
	public function ReactToReflectedAttack( target : CGameplayEntity)
	{
		var hp, dmg : float;
		var action : W3DamageAction;
		
		action = new W3DamageAction in this;
		action.Initialize(target,this,NULL,'',EHRT_Reflect,CPS_AttackPower,true,false,false,false);
		action.SetHitAnimationPlayType(EAHA_ForceYes);
		action.SetCannotReturnDamage( true );
		
		
		
		if( ((CActor) target).HasTag( 'scolopendromorph' ) )
		{
			((CActor) target).PlayEffect('heavy_hit_back');
		}
		else
		{
			((CActor) target).PlayEffectOnHeldWeapon('light_block');
		}
		
		theGame.damageMgr.ProcessAction( action );		
		delete action;	
	}

		
	public function ReactToBeingHit(damageAction : W3DamageAction, optional buffNotApplied : bool) : bool
	{
		var animType 				: EHitReactionType;
		var receivedAnyDamage 		: bool;
		var isParriedOrCountered, playHitAnim, criticalAllowsHit, immortalDebugHack	: bool;
		var hitAnimationPlayType 	: EActionHitAnim;		
		var animPlayed				: bool;			
		var attackAction			: W3Action_Attack;
		var hud : CR4ScriptedHud;
						
		
		OnReactToBeingHit( damageAction );
		
		
		hitAnimationPlayType = damageAction.GetHitAnimationPlayType();
		receivedAnyDamage = damageAction.DealtDamage();
		attackAction = (W3Action_Attack)damageAction;		
		animPlayed = false;
		
		if ( hitAnimationPlayType != EAHA_ForceNo)
		{					
			playHitAnim = false;
			
			
			if(GetImmortalityMode() == AIM_Invulnerable && this == thePlayer)
			{
				playHitAnim = false;
			}
			else if( HasTag( 'ethereal' ) && !HasAbility( 'EtherealActive' ) )
			{
				playHitAnim = false;
				ActivateEthereal( true );
			}
			else if(hitAnimationPlayType == EAHA_ForceYes)
			{
				playHitAnim = true;
			}
			else if(hitAnimationPlayType == EAHA_ForceYes)
			{
				playHitAnim = true;
			}
			else
			{
				if(effectManager)
					criticalAllowsHit = CriticalBuffIsHitAllowed(effectManager.GetCurrentlyAnimatedCS(), damageAction.GetHitReactionType());
					
				isParriedOrCountered = attackAction && ( attackAction.IsParried() || attackAction.IsCountered() || attackAction.WasDodged() );
				immortalDebugHack = (GetImmortalityMode() == AIM_Immortal && !isParriedOrCountered);
				
				if( HasAbility('IgnoreHitAnimFromSigns') )
				{
					playHitAnim = false;
				}
				
				
				
				else if ( damageAction.attacker == thePlayer && thePlayer.GetAttitude( this ) == AIA_Friendly && !HasBuff(EET_AxiiGuardMe) )
				{
					playHitAnim = false;
				}
				else if((receivedAnyDamage || immortalDebugHack) && CanPlayHitAnim() && criticalAllowsHit)
				{
					playHitAnim = true;
				}				
				else
				{
					if(buffNotApplied && damageAction.IsActionWitcherSign())
					{
						playHitAnim = true;
					}
					else if(CanPlayHitAnim())
					{
						if(receivedAnyDamage && ( useAdditiveHits || oneTimeAdditiveHit ) )
						{
							playHitAnim = true;
						}
						else if(!receivedAnyDamage && !isParriedOrCountered && criticalAllowsHit)
						{
							
							playHitAnim = true;
						}
					}
				}
			}
			
			
			if(playHitAnim)
			{
				
				
				if( ( useAdditiveHits || oneTimeAdditiveHit ) && !( criticalCancelAdditiveHit && damageAction.IsCriticalHit() ))
				{
					animType = ModifyHitSeverityReaction(this, damageAction.GetHitReactionType());
					if(animType != EHRT_None)
					{
						SetDetailedHitReaction(damageAction.GetSwingType(), damageAction.GetSwingDirection());
					}
					damageAction.additiveHitReactionAnimRequested = true;
					oneTimeAdditiveHit = false;
				}
				else if ( hitAnimationPlayType == EAHA_ForceYes || (CanPlayHitAnim() && hitAnimationPlayType == EAHA_Default))
				{
					animType = ModifyHitSeverityReaction(this, damageAction.GetHitReactionType());
					if(animType != EHRT_None)
					{
						PlayHitAnimation(damageAction, animType);
						animPlayed = true;
					}
				}
			}
		}
				
		lastWasHitTime 		= theGame.GetEngineTimeAsSeconds();
		lastWasAttackedTime = lastWasHitTime; 
		
		
		if(damageAction.DealsAnyDamage() && !damageAction.IsDoTDamage())
		{
			if ( !HasTag( 'NoHitFx' ) )
			{
				if ( theGame.GetWorld().GetWaterDepth( this.GetWorldPosition() ) > 0 )
				{
					if ( this.HasEffect( 'water_hit_blood' ) ) this.PlayEffect( 'water_hit_blood' );
				}
			}	
		}
		
		return animPlayed;
	}
	
	event OnFireHit(source : CGameplayEntity)
	{	
		RemoveAllBuffsOfType(EET_Frozen);
		super.OnFireHit(source);
	}
	
	
	public final function ProcessHitSound(damageAction : W3DamageAction, hitAnimPlayed : bool)
	{
		var noHitSound : bool;
		var playHitReactionSfx : bool;
		var playHitReactionSfxOverrides : bool;
		var npcVictim : CNewNPC;
		
		noHitSound = damageAction.SuppressHitSounds();
		if( !IsAlive() && ( damageAction.IsDoTDamage() || theGame.IsDialogOrCutscenePlaying() ) )
		{
			noHitSound = true;
		}

		if( noHitSound )
		{
			SoundSwitch( "opponent_weapon_type", 'empty');
			SoundSwitch("opponent_weapon_size", '');
			return;
		}
	
		
		SetHitSoundData(damageAction);
		
		npcVictim = (CNewNPC) damageAction.victim;
		
		
		
		if( !hitAnimPlayed || (npcVictim && !npcVictim.CanPlayHitAnim() ))
		{
			playHitReactionSfx = damageAction.DealtDamage() && !damageAction.IsDoTDamage() && damageAction.GetBuffSourceName() != "FallingDamage";
			playHitReactionSfxOverrides = ((W3Petard)damageAction.causer);
			if( playHitReactionSfx || playHitReactionSfxOverrides )
			{
				if (damageAction.GetHitReactionType() == EHRT_Heavy)
					SoundEvent("cmb_play_hit_heavy");
				else
					SoundEvent("cmb_play_hit_light");
			}
		}
	}
		
	
	public function SetHitSoundData(action : W3DamageAction)
	{
		var weaponMeshSoundTypeIdentification, soundMonsterName, weaponMeshSoundSizeIdentification, armourMeshSoundSizeIdentification : name;
		var victimWeaponMeshSoundTypeIdentification, victimWeaponMeshSoundSizeIdentification : name;
		var i, boneIndex : int;
		var weaponComponents : array<CComponent>;
		var victimWeaponComponents : array<CComponent>;
		var monsterCategory : EMonsterCategory;
		var isTeleporting : bool;
		var canBeTargeted : bool;
		var canBeHitByFists : bool;
		var category : name;
		var weaponEntity : CItemEntity;
		var victimWeapon : CItemEntity;
		var attackAction : W3Action_Attack;
		var weaponId : SItemUniqueId;
		var victimeWeaponId : SItemUniqueId;
		var nodeCauser : CNode;
		var isByArrow : bool;
		var cr4HumanoidCombatComponent : CR4HumanoidCombatComponent;
		var victimInv					: CInventoryComponent;
		var heldWeapons					: array<SItemUniqueId>;
		
		
		attackAction = (W3Action_Attack)action;
		isByArrow = (W3ArrowProjectile)action.causer;
		nodeCauser = (CNode)action.causer;
		
		if(attackAction && (attackAction.IsActionMelee() || isByArrow) )
		{
			weaponId = attackAction.GetWeaponId();
			weaponEntity = action.attacker.GetInventory().GetItemEntityUnsafe(weaponId);
			
			victimInv = action.victim.GetInventory();		
			heldWeapons = victimInv.GetHeldWeapons();			
			if( heldWeapons.Size() > 0 )
			{
				victimeWeaponId = heldWeapons[0];
				victimWeapon 	= victimInv.GetItemEntityUnsafe(victimeWeaponId);
			}
					
			category = action.attacker.GetInventory().GetItemCategory(weaponId);
					
			if(category == 'monster_weapon')
			{			
				theGame.GetMonsterParamsForActor( (CActor)action.attacker, monsterCategory, soundMonsterName, isTeleporting, canBeTargeted, canBeHitByFists);		
				
				
				SoundSwitch( "opponent_weapon_type", 'monster' );
				SoundSwitch( "opponent_weapon_size", soundMonsterName );
			}
			else if(category == 'fist')
			{
				SoundSwitch( "opponent_weapon_type", 'fist' );
				SoundSwitch( "opponent_weapon_size", '' );
			}
			else	
			{
				
				if(isByArrow)
				{
					SoundSwitch( "opponent_weapon_type", "arrow" );
				}
				else
				{
					weaponComponents = weaponEntity.GetComponentsByClassName('CMeshComponent');
					if( (weaponComponents.Size() > 0 ) && weaponComponents[ 0 ] )
					{
						weaponMeshSoundTypeIdentification = GetMeshSoundTypeIdentification( weaponComponents[0] );
						weaponMeshSoundSizeIdentification = GetMeshSoundSizeIdentification( weaponComponents[0] );
					}
					
					victimWeaponComponents = victimWeapon.GetComponentsByClassName('CMeshComponent');
					if( (victimWeaponComponents.Size() > 0 ) && victimWeaponComponents[ 0 ] )
					{
						victimWeaponMeshSoundTypeIdentification = GetMeshSoundTypeIdentification( victimWeaponComponents[0] );
						victimWeaponMeshSoundSizeIdentification = GetMeshSoundSizeIdentification( victimWeaponComponents[0] );

					}
					
					if(IsNameValid(weaponMeshSoundTypeIdentification))
					{
						SoundSwitch( "opponent_weapon_type", weaponMeshSoundTypeIdentification );
						SoundSwitch( "opponent_weapon_size", weaponMeshSoundSizeIdentification );
						action.attacker.SoundSwitch( "weapon_type", weaponMeshSoundTypeIdentification  );
						action.attacker.SoundSwitch( "weapon_size", weaponMeshSoundSizeIdentification );
					}
					
					if(IsNameValid(victimWeaponMeshSoundTypeIdentification))
					{
						action.attacker.SoundSwitch( "opponent_weapon_type", victimWeaponMeshSoundTypeIdentification );
						action.attacker.SoundSwitch( "opponent_weapon_size", victimWeaponMeshSoundSizeIdentification );
						SoundSwitch( "weapon_type", victimWeaponMeshSoundTypeIdentification );
						SoundSwitch( "weapon_size", victimWeaponMeshSoundSizeIdentification );						
					}
				}
			}
			
			boneIndex = attackAction.GetHitBoneIndex();
			
			
			if(boneIndex == GetHeadBoneIndex())
				SoundSwitch( "hit_location", "head" );
			else
				SoundSwitch( "hit_location", "body" );

			
			
			if(StrContains(action.attacker.GetName(), "kikimore") &&  soundMonsterName == 'Endriaga' && attackAction.GetSoundAttackType() == 'monster_medium_hit_heavy')
			{
				SoundSwitch(  "opponent_attack_type", 'monster_medium_hit_light' );
			}
			else
			{
				SoundSwitch(  "opponent_attack_type", attackAction.GetSoundAttackType() );
			}

			
			cr4HumanoidCombatComponent = (CR4HumanoidCombatComponent)GetComponentByClassName( 'CR4HumanoidCombatComponent' );
			if( cr4HumanoidCombatComponent )
			{
				armourMeshSoundSizeIdentification = cr4HumanoidCombatComponent.GetSoundTypeIdentificationForBone( boneIndex );
				if( armourMeshSoundSizeIdentification != 'default' && armourMeshSoundSizeIdentification != 'None' )
				{
					SoundSwitch( "armour_type", armourMeshSoundSizeIdentification );
				}
			}	
		}		
		
		else if(action.IsActionWitcherSign())
		{
			SetDamageActionMagicHitSound((CEntity)action.causer);
		}
		
		else if( (W3CiriPhantom)action.attacker )
		{
			SoundSwitch( "opponent_weapon_type", 'ciri_spec_ability' );
		}
		else if( (W3SnowballProjectile)action.causer || (nodeCauser && nodeCauser.HasTag('Snowball')) )
		{
			SoundSwitch( "opponent_weapon_type", 'snowball' );
		}
		else if( (W3Petard)action.causer )
		{
			SoundSwitch( "opponent_attack_type", ((W3Petard)action.causer).GetAudioImpactName() );
			
			weaponComponents = ((W3Petard)action.causer).GetComponentsByClassName('CMeshComponent');
			if( (weaponComponents.Size() > 0 ) && weaponComponents[ 0 ] )
			{
				weaponMeshSoundTypeIdentification = GetMeshSoundTypeIdentification( weaponComponents[0] );
				weaponMeshSoundSizeIdentification = GetMeshSoundSizeIdentification( weaponComponents[0] );
				SoundSwitch( "opponent_weapon_type", weaponMeshSoundTypeIdentification );
				SoundSwitch( "opponent_weapon_size", weaponMeshSoundSizeIdentification );
			}
		}
		else if( isByArrow )
		{
			SoundSwitch( "opponent_weapon_type", 'arrow' );
			SoundSwitch( "opponent_attack_type", 'wpn_arrow' );
		}		
	}
	
	protected function SetDamageActionMagicHitSound(causer : CEntity)
	{
		SoundSwitch( "opponent_weapon_type", 'magic' );
		
		if((W3IgniProjectile)causer)
			SoundSwitch( "opponent_weapon_size", 'magic_igni' );
		if((W3AardProjectile)causer)
			SoundSwitch( "opponent_weapon_size", 'magic_aard' );
		if((W3YrdenEntity)causer)
			SoundSwitch( "opponent_weapon_size", 'magic_yrden' );
		if((W3QuenEntity)causer)
			SoundSwitch( "opponent_weapon_size", 'magic_quen' );
	}
		
	
	public function PlayHitEffect(damageAction : W3DamageAction)
	{
		var effectName : name;
		var attackAction : W3Action_Attack;
		var actorAttacker : CActor;
		var fxEntity : CEntity;
		
		if(HasTag('NoHitFx'))
			return;
		
		
		attackAction = (W3Action_Attack)damageAction;
		actorAttacker = (CActor)damageAction.attacker;
		if(attackAction && actorAttacker && actorAttacker.GetInventory().ItemHasTag(attackAction.GetWeaponId(), 'Wooden'))
		{
			
			if(actorAttacker.IsHeavyAttack(attackAction.GetAttackName()))
			{
				effectName = 'wood_heavy_hit';
			}
			else
			{
				effectName = 'wood_light_hit';
			}
		}
		else if ( attackAction && actorAttacker && damageAction.DealsAnyDamage() 
			&& !actorAttacker.GetInventory().ItemHasTag(attackAction.GetWeaponId(), 'MagicWeaponFX') && actorAttacker.IsWeaponHeld('fist') )
		{
			effectName = 'fistfight_heavy_hit';
		}
		else
		{
			
			effectName = damageAction.GetHitEffect(IsAttackerAtBack(damageAction.attacker), !damageAction.DealsAnyDamage());
		}
		
		if(IsNameValid(effectName))
			PlayEffect(effectName);
			
		
		if( damageAction.IsCriticalHit() && damageAction.IsActionWitcherSign() && actorAttacker && IsAlive() && actorAttacker == thePlayer && GetWitcherPlayer().IsMutationActive( EPMT_Mutation2 ) )
		{
			fxEntity = CreateFXEntityAtPelvis( 'mutation2_critical', true );
			if( fxEntity )
			{
				switch( damageAction.GetSignSkill() )
				{
					case S_Magic_1 :
						fxEntity.PlayEffect( 'critical_aard' );
						break;
					case S_Magic_2 :
						fxEntity.PlayEffect( 'critical_igni' );
						break;
					case S_Magic_3 :
					case S_Magic_s03 :
						fxEntity.PlayEffect( 'critical_yrden' );
						break;
					case S_Magic_4 :
					case S_Magic_s04 :
					case S_Magic_s13 :
						fxEntity.PlayEffect( 'critical_quen' );
						break;
				}
			}
		}
		
		
		if( actorAttacker == thePlayer && damageAction.IsActionWitcherSign() && IsAlive() && GetWitcherPlayer().IsMutationActive( EPMT_Mutation1 ) )
		{
			fxEntity = CreateFXEntityAtPelvis( 'mutation1_hit', true ); 
			if( fxEntity )
			{
				switch( damageAction.GetSignType() )
				{
					case ST_Aard:
						effectName = 'mutation_1_hit_aard' ;
						break;
					case ST_Igni:
						effectName = 'mutation_1_hit_igni' ;
						break;
					case ST_Yrden:
						effectName = 'mutation_1_hit_yrden' ;
						break;
					case ST_Quen:
						effectName = 'mutation_1_hit_quen' ;
						break;
				}
				
				fxEntity.PlayEffect( effectName );
			}
		}
	}
		
	event OnReactToBeingHit( damageAction : W3DamageAction );	
	
	function InterruptCombatFocusMode();
	
	protected function PlayHitAnimation( damageAction : W3DamageAction, animType : EHitReactionType )
	{
		if ( IsNameValid( ( (CNewNPC)damageAction.attacker ).GetAbilityBuffStackedOnEnemyHitName() ) )
		{
			damageAction.attacker.AddAbility( ( (CNewNPC)damageAction.attacker ).GetAbilityBuffStackedOnEnemyHitName(), true );
		}
	}
	
	public function SetHitReactionDirection( attacker : CNode )
	{
		var victimToAttackerAngle : float = NodeToNodeAngleDistance(attacker, this);
		
		if( AbsF(victimToAttackerAngle) <= 90 )
		{
			
			this.SetBehaviorVariable( 'HitReactionDirection',(int)EHRD_Forward);
		}
		else if( AbsF(victimToAttackerAngle) > 90 )
		{
			
			this.SetBehaviorVariable( 'HitReactionDirection',(int)EHRD_Back);
		}
		
		
		if( victimToAttackerAngle > 45 && victimToAttackerAngle < 135 )
		{
			
			this.SetBehaviorVariable( 'HitReactionSide',(int)EHRS_Right);
		}
		else if( victimToAttackerAngle < -45 && victimToAttackerAngle > -135 )
		{
			
			this.SetBehaviorVariable( 'HitReactionSide',(int)EHRS_Left);
		}
		else
		{
			this.SetBehaviorVariable( 'HitReactionSide',(int)EHRS_None);
		}
	}
	
	function SetDetailedHitReaction(type : EAttackSwingType, dir : EAttackSwingDirection)
	{
		this.SetBehaviorVariable( 'HitSwingDirection',(int)dir);
		this.SetBehaviorVariable( 'HitSwingType',(int)type);
	}
	
	
	event OnPreSceneInvulnerability( val : bool ) 
	{
		if( val )
		{
			SetImmortalityMode( AIM_Invulnerable, AIC_Scene );
		}
		else		
		{
			SetImmortalityMode( AIM_None, AIC_Scene );
		}
	}
	
	event OnBlockingSceneStarted( scene: CStoryScene )
	{
		this.SetKinematic(true);
		SetIsInCutsceneIntro( false );
		SetImmortalityMode( AIM_Invulnerable, AIC_Scene );
		SetTemporaryAttitudeGroup( 'geralt_friendly', AGP_Scenes);	
	}

	event OnBlockingSceneStarted_OnIntroCutscene( scene: CStoryScene )
	{
		SetIsInCutsceneIntro( true ); 
		SetImmortalityMode( AIM_Invulnerable, AIC_Scene );
		SetTemporaryAttitudeGroup( 'geralt_friendly', AGP_Scenes);
	}
	
	event OnBlockingSceneEnded( optional output : CStorySceneOutput)
	{
		SetIsInCutsceneIntro( false );
		SetImmortalityMode( AIM_None, AIC_Scene );
		ResetTemporaryAttitudeGroup( AGP_Scenes );
	}	
	
	
	event OnDeath( damageAction : W3DamageAction  )
	{
		
		OnFocusModeSound( false, false );
		SetFocusModeSoundEffectType( FMSET_None );
		
		
		StopAllVoicesets();
		
		
		if(effectManager)
		{
			if ( this.WillBeUnconscious() )
				effectManager.OwnerHasEnteredUnconscious();
			else
				effectManager.OwnerHasDied();
		}
		
		
		SetFocusModeVisibility( FMV_None );
		
		
		this.GetMovingAgentComponent().SetEnabledFeetIK(false,0.5);
		
		
		if( HasTag( 'etherealTest' ) )
		{
			HACK_ManageEtherealSkills();
		}
		
		if( HasTag( 'ethereal' ) )
		{
			StopEffect( 'olgierd_energy_blast' );
			PlayEffect( 'ethereal_debuff' );
			ManageEtherealSkillsAndFXes();
		}
	}
	
	
	function OnRevived()
	{
		wasDefeatedFromFistFight 	= false;
		SignalGameplayEvent( 'OnRevive' );
		SetAlive(true);
		this.GetMovingAgentComponent().SetEnabledFeetIK(true,0.5);
	}
	
	event OnCombatActionEnd()
	{
		StopRotateEventAdjustments();
	}
	
	event OnCanFindPath( sender : CActor )
	{	
	}
	event OnCannotFindPath( sender : CActor )
	{	
	}
	event OnBecomeAwareAndCanAttack( sender : CActor )
	{	
	}
	event OnBecomeUnawareOrCannotAttack( sender : CActor )
	{
	}	
	event OnApproachAttack( sender : CActor )
	{
	}
	event OnApproachAttackEnd( sender : CActor )
	{
	}
	event OnAttack( sender : CActor )
	{
	}
	event OnAttackEnd( sender : CActor )
	{
	}
	
	event OnAxiied( attacker : CActor)
	{
		var i : int;
		var victimTags, attackerTags : array<name>;
		
		victimTags = GetTags();
		attackerTags = attacker.GetTags();
		
		AddHitFacts( victimTags, attackerTags, "_axii_hit" );
	}
	
	
	public function SetEffectsUpdateTicking( on : bool, optional dontCheckEffectsManager : bool  )
	{
		if( on )
		{
			if( !effectsUpdateTicking )
			{
				if( abilityManager && abilityManager.IsInitialized() && ( dontCheckEffectsManager || ( effectManager && effectManager.IsReady() ) ) )
				{
					effectsUpdateTicking = true;
					AddTimer( 'EffectsUpdate', 0.001, true );		
				}
			}
		}
		else if( effectsUpdateTicking && effectManager && effectManager.CanBeRemoved() )
		{
			effectsUpdateTicking = false;
			RemoveTimer( 'EffectsUpdate' );
		}
	}
	
	public function IsEffectsUpdateTicking() : bool
	{
		return effectsUpdateTicking;
	}
	
	public function StartVitalityRegen() : bool
	{
		if( effectManager )
		{
			return effectManager.StartVitalityRegen();
		}
		
		return false;
	}
	
	public function StopVitalityRegen()
	{
		if( effectManager )
		{
			effectManager.StopVitalityRegen();
		}
	}
	
	public function StartEssenceRegen() : bool
	{
		if( effectManager )
		{
			return effectManager.StartEssenceRegen();
		}
		
		return false;
	}
	
	public function StopEssenceRegen()
	{
		if( effectManager )
		{
			effectManager.StopEssenceRegen();
		}
	}
	
	public function StartStaminaRegen() : bool
	{
		if( effectManager )
		{
			return effectManager.StartStaminaRegen();
		}
		
		return false;
	}
	
	public function StopStaminaRegen()
	{
		if( effectManager )
		{
			effectManager.StopStaminaRegen();
		}
	}
	
	public function StartMoraleRegen() : bool
	{
		if( effectManager )
		{
			return effectManager.StartMoraleRegen();
		}
		
		return false;
	}
	
	public function StopMoraleRegen()
	{
		if( effectManager )
		{
			effectManager.StopMoraleRegen();
		}
	}
	
	public function StartPanicRegen() : bool
	{
		if( effectManager )
		{
			return effectManager.StartPanicRegen();
		}
		
		return false;
	}
	
	public function StopPanicRegen()
	{
		if( effectManager )
		{
			effectManager.StopPanicRegen();
		}
	}
	
	public function StartAirRegen() : bool
	{
		if( effectManager )
		{
			return effectManager.StartAirRegen();
		}
		
		return false;
	}
	
	public function StopAirRegen()
	{
		if( effectManager )
		{
			effectManager.StopAirRegen();
		}
	}
	
	public function StartSwimmingStaminaRegen() : bool
	{
		if( effectManager )
		{
			return effectManager.StartSwimmingStaminaRegen();
		}
		
		return false;
	}
	
	public function StopSwimmingStaminaRegen()
	{
		if( effectManager )
		{
			effectManager.StopSwimmingStaminaRegen();
		}
	}
	
	timer function EffectsUpdate( deltaTime : float , id : int)
	{
		if(effectManager)
			effectManager.PerformUpdate( deltaTime );
	}
	
	
	
	

	public function UpdateRequestedDirectionVariables( headingYawWS : float, orientationYawWS : float )
	{
		
		SetBehaviorVariable( 'requestedMovementDirection', AngleNormalize( headingYawWS ) );
		SetBehaviorVariable( 'requestedFacingDirection', AngleNormalize( orientationYawWS ) );
		SetBehaviorVariable( 'requestedMovementDirectionForOverlay', AngleNormalize( headingYawWS ) );
		SetBehaviorVariable( 'requestedFacingDirectionForOverlay', AngleNormalize( orientationYawWS ) );
	}

	
	
	
	public function UpdateLookAtVariables( lookAtTargetActive : float, lookAtTarget : Vector )
	{
		var sourceToTargetVector	: Vector;
		var pitch					: float;
		var sourcePos				: Vector;
		var headBoneIdx				: int;
		var angleDiff				: float;

		lookAtTarget.W = 1.0f;
	
		angleDiff = AngleDistance( VecHeading( lookAtTarget - GetWorldPosition() ), GetHeading() ) / 180.f;
		SetBehaviorVariable( 'lookatOn', lookAtTargetActive );
		SetBehaviorVectorVariable( 'lookAtTarget', lookAtTarget );
		SetBehaviorVectorVariable( 'lookAtTarget2', lookAtTarget );
		SetBehaviorVariable( 'lookatToHeadingDiffYaw', angleDiff );
		SetBehaviorVariable( 'lookatToHeadingDiffYawForOverlay', angleDiff );
		headBoneIdx = this.GetHeadBoneIndex();
		
		if ( headBoneIdx >= 0 )
			sourcePos = MatrixGetTranslation( this.GetBoneWorldMatrixByIndex( headBoneIdx ) );
		else
			sourcePos = GetWorldPosition();
			
		sourceToTargetVector = VecNormalize( lookAtTarget - sourcePos );
		pitch = Rad2Deg( AsinF( ClampF( sourceToTargetVector.Z, -1.0f, 1.0f ) ) );

		if ( lookAtTarget.X == sourcePos.X && lookAtTarget.Y == sourcePos.Y )
		{
			pitch = lookAtTarget.Z < sourcePos.Z? -90 : 90;
		}

		SetBehaviorVariable( 'lookatToHeadingDiffPitch', pitch/90 );
	}

	
	
	
	
	
	protected function CriticalBuffInformBehavior(buff : CBaseGameplayEffect);
	
	public function GetNewRequestedCS() : CBaseGameplayEffect			{return newRequestedCS;}
	public function SetNewRequestedCS(buff : CBaseGameplayEffect)		{newRequestedCS = buff;}
	
	
	public function StartCSAnim(buff : CBaseGameplayEffect) : bool
	{		
		LogCritical("Received request to start CS anim for <<" + GetBuffCriticalType(buff) + ">>");
		
		if(effectManager && effectManager.GetCurrentlyAnimatedCS() == buff)		
		{
			LogCritical("ASSERT: Trying to start anims for currently played critical state - aborting!");
			return false;
		}
		
		if(newRequestedCS == buff)
			return false;		
			
		
		
		if( this == thePlayer && IsUsingVehicle())
			return false;		
	
		if(GetCurrentStateName() == 'TraverseExploration')
			ActionCancelAll();
	
		newRequestedCS = buff;
		SetBehaviorVariable( 'CriticalStateType', (int)GetBuffCriticalType(buff) );
		SetBehaviorVariable( 'bCriticalState', 1);
		
		return true;
	}
		
	
	event OnCriticalStateAnimStart()
	{
		
		if(!newRequestedCS)
		{
			LogCritical("Aborting start of new CS - it got deleted in the meantime");
			return false;
		}
	
		LogCritical("Started anim of CS <<" + GetBuffCriticalType(newRequestedCS) + ">>");
		
		if(effectManager)
			effectManager.SetCurrentlyAnimatedCS(newRequestedCS);
			
		newRequestedCS = NULL;
				
		return true;
	}
			
	
	public function CriticalEffectAnimationInterrupted(reason : string) : bool
	{
		var buff : CBaseGameplayEffect;
	
		if(effectManager)
		{
			buff = effectManager.GetCurrentlyAnimatedCS();
			if(buff)
			{			
				
				if(CriticalBuffIsDestroyedOnInterrupt(buff))
					effectManager.RemoveEffect(effectManager.GetCurrentlyAnimatedCS(), true);
				
				effectManager.SetCurrentlyAnimatedCS(NULL);
				SetBehaviorVariable( 'bCriticalState', 0);
				SetBehaviorVariable( 'CriticalStateType', (int)ECST_None );			
				
				LogCritical("Critical effect animation gets interrupted, reason: " + reason);
				return true;
			}
		}
		
		return false;
	}
	
	public function RequestCriticalAnimStop(optional dontSetCriticalToStopped : bool)
	{
		var currentlyAnimatedCritical : CBaseGameplayEffect;
		var critType : ECriticalStateType;
		
		if(effectManager)
			currentlyAnimatedCritical = effectManager.GetCurrentlyAnimatedCS();
			
		critType = GetBuffCriticalType(currentlyAnimatedCritical);
		
		if(currentlyAnimatedCritical)
			LogCritical("Requesting CS anim stop for <<" + critType + ">>, time remaining = " + NoTrailZeros(currentlyAnimatedCritical.GetDurationLeft()) );
		else
			LogCritical("Requesting CS anim stop but there is no critical playing animation right now");
	
		
		if(!dontSetCriticalToStopped && IsAlive() )
			SetBehaviorVariable( 'bCriticalStopped', 1 );			
			
		this.SignalGameplayEvent('DisableFinisher');
			
		this.SignalGameplayEventParamInt('StoppingEffect', (int)critType);
	}
	
	
	public function CriticalStateAnimStopped(forceRemoveBuff : bool)
	{
		var buffToStop : CBaseGameplayEffect;
		var findNewBuff, buggedCS : bool;
		var buff : CBaseGameplayEffect;
		var csType : ECriticalStateType;
		
		if( !ChooseNextCriticalBuffForAnim() )
		{
			SetBehaviorVariable( 'CriticalStateType', (int)ECST_None );
		}
		
		if(effectManager)
			buff = effectManager.GetCurrentlyAnimatedCS();		
			
		if(buff)
		{
			csType = GetBuffCriticalType(buff);

			LogCritical("Stopping CS animation for <<" + csType + ">>");
		
			if(forceRemoveBuff || buff.GetDurationLeft() < 0 || !buff.IsActive() || CriticalBuffIsDestroyedOnInterrupt(buff))
			{
				LogCritical("Buff <<" + csType + ">> gets removed (CriticalStateAnimStopped)");
				effectManager.RemoveEffect(effectManager.GetCurrentlyAnimatedCS(), true);
			}
			else
			{
				LogCritical("Buff <<" + csType + ">> gets moved to background and won't be played now but isn't removed yet. Duration left = " + NoTrailZeros(buff.GetDurationLeft()) );
				effectManager.SetCurrentlyAnimatedCS(NULL);
			}
		}
		else
		{
			
		}
			
		
		
	}
	
	
	
	
	public function ChooseNextCriticalBuffForAnim() : CBaseGameplayEffect
	{
		var max, val, i : int;
		var eff : array<CBaseGameplayEffect>;
		var buff : CBaseGameplayEffect;
		
		if(!effectManager)
			return NULL;
			
		eff = effectManager.GetCriticalBuffs();
		eff.Remove(GetCurrentlyAnimatedCS());
		buff = NULL;
		
		for(i=0; i<eff.Size(); i+=1)
		{
			
			if(!eff[i].IsActive())
				continue;
				
			
			if(!CriticalEffectCanPlayAnimation(eff[i]))
				continue;
		
			val = CalculateCriticalStateTypePriority( GetBuffCriticalType(eff[i]) );
			if( val >= max )
			{
				max = val;					
				buff = eff[i];
			}
		}
		
		return buff;
	}
		
	public function ChooseCurrentCriticalBuffForAnim() : CBaseGameplayEffect
	{
		var tempType : ECriticalStateType;
		var max, val, i, size : int;
		var maxSet : bool;
		var eff : array<CBaseGameplayEffect>;
		var buff : CBaseGameplayEffect;
		
		if(!effectManager)
			return NULL;
		
		eff = effectManager.GetCurrentEffects();
		size = eff.Size();
		maxSet = false;
		buff = NULL;
		
		for(i=0; i<size; i+=1)
		{		
			tempType = GetBuffCriticalType(eff[i]);
			
			if(tempType == ECST_None)
				continue;

			if(eff[i].GetDurationLeft() <= 0 || !eff[i].IsActive())
			{
				
				effectManager.RemoveEffect(eff[i]);
				continue;		
			}			
				
			if(tempType != ECST_None)
			{
				
				if(!CriticalEffectCanPlayAnimation(eff[i]))
					continue;
			
				val = CalculateCriticalStateTypePriority(tempType);
				if(val > max || !maxSet)
				{
					max = val;
					maxSet = true;
					buff = eff[i];
				}
			}
		}

		return buff;
	}	
	
	public function GetCriticalBuffs() : array<CBaseGameplayEffect>
	{
		var null : array<CBaseGameplayEffect>;
		
		if(effectManager)
			return effectManager.GetCriticalBuffs();
			
		return null;
	}
	
	public final function IsCriticalTypeHigherThanAllCurrent(crit : ECriticalStateType) : bool
	{
		var i, askedPriority : int;
		var buffs : array<CBaseGameplayEffect>;
		
		askedPriority = CalculateCriticalStateTypePriority(crit);
		buffs = GetCriticalBuffs();
		for(i=0; i<buffs.Size(); i+=1)
		{
			if(buffs[i].IsActive() && CalculateCriticalStateTypePriority( GetBuffCriticalType(buffs[i]) ) >= askedPriority)
				return false;
		}
		
		return true;
	}
	
	
	
	
	
	public function RecalcEffectDurations()
	{
		if(effectManager)
			effectManager.RecalcEffectDurations();
	}
	
	public function AddEffectCustom(params : SCustomEffectParams) : EEffectInteract
	{
		if( effectManager && effectManager.IsReady())
			return effectManager.AddEffectCustom(params);
		
		LogAssert(false, "Actor.AddEffectCustom: <<" + this + ">> effect manager does not exist! Cannot add <<" + params.effectType + ">>");		
		return EI_Undefined;
	}
	
	public function AddEffectDefault(effectType : EEffectType, creat : CGameplayEntity, optional srcName : string, optional signEffect : bool) : EEffectInteract
	{
		if( effectManager && effectManager.IsReady() )
			return effectManager.AddEffectDefault(effectType,creat,srcName,signEffect);
			
		LogAssert(false, "Actor.AddEffectDefault: <<" + this + ">> effect manager does not exist! Cannot add <<" + effectType + ">>");			
		return EI_Undefined;
	}
	
	public function ProcessOnHitEffects(victim : CActor, silverSword : bool, steelSword : bool, sign : bool)
	{
		if(effectManager)
			effectManager.ProcessOnHitEffects(victim, silverSword, steelSword, sign);
	}
	
	public function RemoveBuff(effectType : EEffectType, optional csForcedRemove : bool, optional sourceName : string)
	{
		if( effectManager && effectManager.IsReady() )
			effectManager.RemoveEffect(effectManager.GetEffect(effectType, sourceName) , csForcedRemove );
	}
	
	public function RemoveEffect(effect : CBaseGameplayEffect, optional csForcedRemove : bool)
	{
		if( effectManager && effectManager.IsReady() )
			effectManager.RemoveEffect(effect, csForcedRemove );
	}
	
	public function RemoveAllNonAutoBuffs( optional removeOils : bool, optional skipPerk14 : bool )
	{
		if( effectManager && effectManager.IsReady() )
			effectManager.RemoveAllNonAutoEffects( removeOils, skipPerk14 );
	}
	
	public function RemoveAllBuffsOfType(effectType : EEffectType)
	{
		if( effectManager && effectManager.IsReady() )
			effectManager.RemoveAllEffectsOfType(effectType);
	}
	
	public function RemoveAllBuffsWithSource( source : string )
	{
		if( effectManager && effectManager.IsReady() )
			effectManager.RemoveAllBuffsWithSource( source );
	}
	
	
	public function HasBuff(effectType : EEffectType) : bool
	{
		if( effectManager && effectManager.IsReady() )
			return effectManager.HasEffect(effectType);
			
		return false;
	}
	
	public function GetBuffTimePercentageByType( effectType : EEffectType) : int
	{
		if ( effectManager && effectManager.IsReady() )
		{
			return effectManager.GetEffectTimePercentageByType( effectType );
		}
		return 0;
	}
	
	public function GetBuffTimePercentage( effect : CBaseGameplayEffect) : int
	{
		if ( effectManager && effectManager.IsReady() )
		{
			return effectManager.GetEffectTimePercentage( effect );
		}
		return 0;
	}
	
	public function GetCriticalBuffsCount() : int
	{
		if(effectManager)
			return effectManager.GetCriticalBuffsCount();
			
		return 0;
	}
	
	public function GetCurrentlyAnimatedCS() : CBaseGameplayEffect
	{
		if(effectManager)
			return effectManager.GetCurrentlyAnimatedCS();
			
		return NULL;
	}
	
	public function GetBuff(effectType : EEffectType, optional sourceName : string) : CBaseGameplayEffect
	{		
		if(effectManager)
			return effectManager.GetEffect(effectType, sourceName);
			
		return NULL;
	}
	
	public function GetBuffs(optional type : EEffectType, optional sourceName : string, optional partialSourceNameSearch : bool) : array<CBaseGameplayEffect>
	{
		var null : array<CBaseGameplayEffect>;
		
		if(effectManager)
			return effectManager.GetCurrentEffects(type, sourceName, partialSourceNameSearch);
			
		return null;
	}
	
	public final function HasPotionBuff() : bool
	{
		if(effectManager)
			return effectManager.HasPotionBuff();
			
		return false;
	}
	
	public final function IsImmuneToInstantKill() : bool
	{
		if( HasAbility( 'InstantKillImmune' ) || IsImmortal() || IsInvulnerable() || WillBeUnconscious() )
		{
			return true;
		}
		
		return false;
	}
	
	public function IsImmuneToBuff(effect : EEffectType) : bool
	{
		var immunes : CBuffImmunity;
		var i : int;
		var potion, positive, neutral, negative, immobilize, confuse, damage : bool;
		var criticalStatesToResist, resistCriticalStateChance, resistCriticalStateMultiplier : float;
		var mac : CMovingAgentComponent;
		
		mac = GetMovingAgentComponent();
		
		if ( mac && mac.IsEntityRepresentationForced() == 512 && !IsUsingVehicle() ) 
		{
			if( effect != EET_Snowstorm && effect != EET_SnowstormQ403 )
				return false;
		}
		
		if ( IsCriticalEffectType( effect ) && HasAbility( 'ResistCriticalStates' ) )
		{
			criticalStatesToResist = CalculateAttributeValue( GetAttributeValue( 'critical_states_to_raise_guard' ) );
			resistCriticalStateChance = CalculateAttributeValue( GetAttributeValue( 'resist_critical_state_chance' ) );
			resistCriticalStateMultiplier = CalculateAttributeValue( GetAttributeValue( 'resist_critical_state_chance_mult_per_hit' ) );
			
			criticalStateCounter = GetCriticalStateCounter();
			resistCriticalStateChance += criticalStateCounter * resistCriticalStateMultiplier;
			
			if ( criticalStateCounter >= criticalStatesToResist )
			{
				if( resistCriticalStateChance > RandRangeF( 1, 0 ) )
				{
					return true;
				}
			}
		}
		
		for(i=0; i<buffImmunities.Size(); i+=1)
		{
			if(buffImmunities[i].buffType == effect)
				return true;
		}
		
		for(i=0; i<buffRemovedImmunities.Size(); i+=1)
		{
			if(buffRemovedImmunities[i].buffType == effect)
				return false;
		}
		
		immunes = theGame.GetBuffImmunitiesForActor(this);
		if(immunes.immunityTo.Contains(effect))
			return true;
		
		theGame.effectMgr.GetEffectTypeFlags(effect, potion, positive, neutral, negative, immobilize, confuse, damage);
		if( (potion && immunes.potion) || (positive && immunes.positive) || (neutral && immunes.neutral) || (negative && ( isImmuneToNegativeBuffs || immunes.negative ) ) || (immobilize && immunes.immobilize) || (confuse && immunes.confuse) || (damage && immunes.damage) )
			return true;
			
		return false;
	}
	
	public function AddBuffImmunity_AllCritical(source : name, removeIfPresent : bool)
	{
		var i, size : int;
		
		size = (int)EET_EffectTypesSize;
		
		for( i=0; i<size; i+=1 )
		{
			if( IsCriticalEffectType(i) )
				AddBuffImmunity(i, source, removeIfPresent);
		}
	}
	
	protected saved var isImmuneToNegativeBuffs : bool;
	public function AddBuffImmunity_AllNegative(source : name, removeIfPresent : bool)
	{
		isImmuneToNegativeBuffs = true;
	}
		
	public function AddBuffImmunity(effect : EEffectType, source : name, removeBuffIfPresent : bool)
	{
		var i : int;
		var removed, immuneExists : bool;
		var immunity : SBuffImmunity;
	
		
		removed = false;
		for(i=0; i<buffRemovedImmunities.Size(); i+=1)
		{
			if(buffRemovedImmunities[i].buffType == effect && buffRemovedImmunities[i].sources.Contains(source))
			{
				buffRemovedImmunities[i].sources.Remove(source);
				if(buffRemovedImmunities[i].sources.Size() == 0)
					buffRemovedImmunities.Erase(i);
					
				removed = true;
				break;
			}
		}
		
		if(!removed)
		{
			
			immuneExists = false;
			for(i=0; i<buffImmunities.Size(); i+=1)
			{
				if(buffImmunities[i].buffType == effect)
				{
					if(!buffImmunities[i].sources.Contains(source))
					{
						buffImmunities[i].sources.PushBack(source);
					}
					immuneExists = true;
					break;
				}
			}
			
			if(!immuneExists)
			{
				immunity.buffType = effect;
				immunity.sources.PushBack(source);
				buffImmunities.PushBack(immunity);
			}
		}
		
		
		if(removeBuffIfPresent && effectManager)
			effectManager.RemoveAllEffectsOfType(effect);
	}
	
	public function RemoveBuffImmunity_AllCritical(optional source : name)
	{
		var i, size : int;
	
		
		size = (int)EET_EffectTypesSize;
		for(i=0; i<size; i+=1)
		{
			if(IsCriticalEffectType(i))
				RemoveBuffImmunity(i, source);
		}
	}
	
	public function RemoveBuffImmunity_AllNegative(optional source : name)
	{
		isImmuneToNegativeBuffs = false;
	}
	
	public function RemoveBuffImmunity(effect : EEffectType, optional source : name)
	{
		var immunes : CBuffImmunity;
		var i : int;
		var immunity : SBuffImmunity;
		
		
		for(i=0; i<buffImmunities.Size(); i+=1)
		{
			if(buffImmunities[i].buffType == effect && buffImmunities[i].sources.Contains(source))
			{
				buffImmunities[i].sources.Remove(source);
				if(buffImmunities[i].sources.Size() == 0)
					buffImmunities.Erase(i);
				break;
			}
		}
		
		
		if(!IsNameValid(source))
		{
			immunes = theGame.GetBuffImmunitiesForActor(this);
			
			if(immunes.immunityTo.Contains(effect))
			{
				for(i=0; i<buffRemovedImmunities.Size(); i+=1)
				{
					if(buffRemovedImmunities[i].buffType == effect)
					{
						if(!buffRemovedImmunities[i].sources.Contains(source))
						{
							buffRemovedImmunities[i].sources.PushBack(source);
						}
						return;
					}
				}
				
				
				immunity.buffType = effect;
				immunity.sources.PushBack(source);
				buffRemovedImmunities.PushBack(immunity);
			}
		}
	}
	
	public final function SetIsRecoveringFromKnockdown()
	{
		isRecoveringFromKnockdown = true;		
	}
	
	public final function GetIsRecoveringFromKnockdown() : bool
	{
		return isRecoveringFromKnockdown;
	}
	
	public function PauseHPRegenEffects(sourceName : name, optional duration : float)
	{
		if(effectManager && effectManager.IsReady())
			effectManager.PauseHPRegenEffects(sourceName, duration);			
	}
	
	public function ResumeHPRegenEffects( sourceName : name, optional forceAll : bool )
	{
		if(effectManager && effectManager.IsReady())
			effectManager.ResumeHPRegenEffects( sourceName, forceAll );			
	}
	
	public function PauseStaminaRegen( sourceName : name, optional duration : float )
	{
		if(effectManager && effectManager.IsReady())
			effectManager.PauseStaminaRegen(sourceName, duration );			
	}
	
	public function ResumeStaminaRegen(sourceName : name)
	{
		if(effectManager && effectManager.IsReady())
			effectManager.ResumeStaminaRegen(sourceName);			
	}
	
	
	public function GetCriticalStateCounter(optional total : bool) : int
	{
		if ( total )
			return totalCriticalStateCounter;
		return criticalStateCounter;
	}
	
	public function IncCriticalStateCounter()
	{
		criticalStateCounter += 1;
		totalCriticalStateCounter += 1;
		AddTimer('ResetCriticalStateCounter',5.0,false);
	}
	
	private timer function ResetCriticalStateCounter( deta : float , id : int)
	{
		criticalStateCounter = 0;
	}

	
	
	
	public function GetTotalSignSpellPower(signSkill : ESkill) : SAbilityAttributeValue;

	
		
	public timer function EnableHighlightTimer( time : float , id : int)
	{
		if ( bIsPlayerCurrentTarget && thePlayer.GetCurrentStateName() != 'Exploration' )
		{
			PlayEffect( 'select_character' );
		}
	}
	
	public function SetBIsPlayerCurrentTarget ( flag : bool )
	{
		bIsPlayerCurrentTarget = flag;
	}
	
	
	
	event OnSlideToTargetAnimEvent( animEventName : name, properties : SSlideToTargetEventProps, animEventType : EAnimationEventType, animEventDuration : float, animInfo : SAnimationEventAnimInfo )
	{
		
		ProcessSlideToTarget( animEventDuration, properties );
	}
	
	event OnSlideToTargetDistance( animEventName : name, properties : SMultiValue, animEventType : EAnimationEventType, animEventDuration : float, animInfo : SAnimationEventAnimInfo )
	{
		if ( animEventType == AET_DurationStart )
		{
			ProcessSlideToTargetDistance( animEventDuration, properties.floats[0] );
		}
	}
	
	
	public function SetRotationAdjustmentRotateTo( turnTowards : CNode, optional offsetHeading : float )
	{
		var movementAdjustor : CMovementAdjustor = GetMovingAgentComponent().GetMovementAdjustor();
		var ticket : SMovementAdjustmentRequestTicket = movementAdjustor.GetRequest( 'RotateEvent' );
		
		movementAdjustor.RotateTowards( ticket, turnTowards, offsetHeading );
	}
	
	
	public function SetRotationAdjustmentRotateToHeading( heading : float )
	{
		var movementAdjustor : CMovementAdjustor = GetMovingAgentComponent().GetMovementAdjustor();
		var ticket : SMovementAdjustmentRequestTicket = movementAdjustor.GetRequest( 'RotateEvent' );
		
		movementAdjustor.RotateTo(ticket,heading);
	}
	
	public function SuspendRotationAdjustment()
	{
		var movementAdjustor : CMovementAdjustor = GetMovingAgentComponent().GetMovementAdjustor();
		var ticket : SMovementAdjustmentRequestTicket = movementAdjustor.GetRequest( 'RotateEvent' );

		movementAdjustor.KeepRotationAdjustmentActive( ticket );
	}

	public function GetRotationRateFromAnimEvent( enumValue : int ) : ERotationRate
	{
		var hax : array<ERotationRate>;
		if ( enumValue < 0 )
		{
			return -1;
		}
		else if ( enumValue < 20 )
		{			
			
			hax.PushBack(RR_0);
			hax.PushBack(RR_30);
			hax.PushBack(RR_60);
			hax.PushBack(RR_90);
			hax.PushBack(RR_180);
			hax.PushBack(RR_360);
			hax.PushBack(RR_1080);
			hax.PushBack(RR_2160);			
			return hax[enumValue];
			
		}
		else
		{
			return enumValue;
		}
	}
	
	private function GetWoundNameFromDLCForAnim( animInfo : SAnimationEventAnimInfo ) : name
	{
		var i, size : int;
		
		var dlcFinishersLeftSide	: array< CR4FinisherDLC >;
		var dlcFinishersRightSide	: array< CR4FinisherDLC >;
	
		dlcFinishersLeftSide = theGame.GetSyncAnimManager().dlcFinishersLeftSide;	
		size = dlcFinishersLeftSide.Size();
		
		for( i = 0; i < size; i += 1 )
		{
			if( dlcFinishersLeftSide[i].IsFinisherForAnim( animInfo ) )
			{
				return dlcFinishersLeftSide[i].woundName;
			}
		}
		
		dlcFinishersRightSide = theGame.GetSyncAnimManager().dlcFinishersRightSide;	
		size = dlcFinishersRightSide.Size();
		
		for( i = 0; i < size; i += 1 )
		{
			if( dlcFinishersRightSide[i].IsFinisherForAnim( animInfo ) )
			{
				return dlcFinishersRightSide[i].woundName;
			}
		}
		
		return 'none';
	}
	
	event OnEnumAnimEvent( animEventName : name, variant : SEnumVariant, animEventType : EAnimationEventType, animEventDuration : float, animInfo : SAnimationEventAnimInfo )
	{
		var movementAdjustor 	: CMovementAdjustor;
		var ticket 				: SMovementAdjustmentRequestTicket;
		var rotationRate 		: ERotationRate;
		var loopShake			: bool;	
		var shakeStrength		: float;
		var animName			: name;	
		var	player				: CR4Player;
		var woundName			: name;
				
		switch( animEventName )
		{
			case 'RotateEvent':
			case 'RotateAwayEvent':
				
				rotationRate = GetRotationRateFromAnimEvent( variant.enumValue );
				movementAdjustor = GetMovingAgentComponent().GetMovementAdjustor();
				
				if ( animEventType == AET_DurationStart || animEventType == AET_DurationStartInTheMiddle )
				{
					movementAdjustor.Cancel( movementAdjustor.GetRequest( 'RotateEvent' ) );
					
					ticket = movementAdjustor.CreateNewRequest( 'RotateEvent' );
					
					movementAdjustor.Continuous( ticket );
					movementAdjustor.KeepActiveFor( ticket, animEventDuration );
					if ((int)rotationRate >= 0)
					{
						movementAdjustor.MaxRotationAdjustmentSpeed( ticket, (float)((int)rotationRate) );
					}
					movementAdjustor.MatchMoveRotation( ticket );
					movementAdjustor.UpdateSourceAnimation( ticket, animInfo );
					movementAdjustor.CancelIfSourceAnimationUpdateIsNotUpdated( ticket ); 
					movementAdjustor.SteeringMayOverrideMaxRotationAdjustmentSpeed( ticket ); 
					if ( (CNewNPC)this )
					{
						if ( animEventName == 'RotateAwayEvent' )
							SignalGameplayEvent( 'RotateAwayEventStart');
						else
							SignalGameplayEvent( 'RotateEventStart');
					}
				}
				else if ( animEventType == AET_DurationEnd )
				{
					
					SignalGameplayEvent( 'RotateEventEnd');
				}
				else
				{
					ticket = movementAdjustor.GetRequest( 'RotateEvent' );
					movementAdjustor.UpdateSourceAnimation( ticket, animInfo );
					SignalGameplayEvent( 'RotateEventSync');
				}
			break;
			
			case 'InteractionPriority':
				if ( animEventType == AET_DurationStart )
				{
					SetInteractionPriority( (EInteractionPriority) variant.enumValue );
					
					RemoveTimer( 'RestoreOriginalInteractionPriorityTimer' );
					AddTimer( 'RestoreOriginalInteractionPriorityTimer', animEventDuration, false, , , true ) ;
				}
			break;
			
			case 'Dismemberment':
				if ( animEventType == AET_DurationEnd )
				{
					if( variant.enumValue == DWT_DLC_Defined )
					{			
						woundName = GetWoundNameFromDLCForAnim( animInfo );			
					}
					else 
					{
						woundName = GetWoundNameFromWoundType( variant.enumValue );
					}
					SetDismembermentInfo( woundName, this.GetWorldPosition() - thePlayer.GetWorldPosition(), false );
					Dismember();
					DropItemFromSlot( 'r_weapon', true );
					DropItemFromSlot( 'l_weapon', true );
				}
			break;
			
			case 'Shake':
				if( animEventType == AET_Duration || animEventType == AET_DurationEnd )
				{
					return false;
				}
				loopShake = ( animEventType == AET_DurationStart );
				
				animName = '';
				if( loopShake )
				{
					animName = 'camera_shake_loop_lvl1_1';
					player = thePlayer;
					player.loopingCameraShakeAnimName = animName;
					thePlayer.AddTimer( 'RemoveQuestCameraShakeTimer', animEventDuration );
				}
				
				shakeStrength  	=  (int) variant.enumValue;
				shakeStrength	= ( shakeStrength / 10 ) * 1.9f + 0.1f ;
				GCameraShake( shakeStrength, true, this.GetWorldPosition(), 30.0f, loopShake, animName);
				
			break;
			
			default:
			break;
		}
	}
	
	function GetWoundNameFromWoundType( woundType : int ) : name
	{
		switch ( woundType )
		{
			case DWT_Head:				return 'cut_head';
			case DWT_Torso:				return 'cut_torso';
			case DWT_TorsoLeft:			return 'none';
			case DWT_TorsoRight:		return 'none';
			case DWT_ArmLeft:			return 'none';
			case DWT_ArmRight:			return 'cut_arm';
			case DWT_LegLeft:			return 'none';
			case DWT_LegRight:			return 'none';
			
			case DWT_Morph_Head:		return 'morph_cut_head';
			case DWT_Morph_Torso:		return 'morph_cut_torso';
			case DWT_Morph_TorsoLeft:	return 'none';
			case DWT_Morph_TorsoRight:	return 'none';
			case DWT_Morph_ArmLeft:		return 'none';
			case DWT_Morph_ArmRight:	return 'morph_cut_arm';
			case DWT_Morph_LegLeft:		return 'none';
			case DWT_Morph_LegRight:	return 'none';
			
			case DWT_DLC_Defined:		return 'none';			
		}
	}
	
	event OnAnimEvent_RotateEvent( animEventName : name, animEventType : EAnimationEventType, animInfo : SAnimationEventAnimInfo )
	{
		var variant 	: SEnumVariant;
		variant.enumValue = -1;
		
		OnEnumAnimEvent( animEventName, variant, animEventType, 10.0f, animInfo );
	}
	
	event OnAnimEvent_RotateAwayEvent( animEventName : name, animEventType : EAnimationEventType, animInfo : SAnimationEventAnimInfo )
	{
		var variant 	: SEnumVariant;
		variant.enumValue = -1;
		
		OnEnumAnimEvent( animEventName, variant, animEventType, 10.0f, animInfo );
	}
	
	event OnAnimEvent_DeathHitGround( animEventName : name, animEventType : EAnimationEventType, animInfo : SAnimationEventAnimInfo )
	{
		var effectName 	: name;
		
		
		if(effectManager)
		{
			if(effectManager.HasEffect(EET_Burning))
			{
				effectName = 'igni_death_hit';
				effectManager.RemoveAllEffectsOfType(EET_Burning, true);
			}
			else
			{
				effectName = '';
			}
			
			if(IsNameValid(effectName))
				PlayEffect(effectName);
		}
	}
	
	
	event OnAnimEvent_Shake0( animEventName : name, animEventType : EAnimationEventType, animInfo : SAnimationEventAnimInfo )
	{
		var loopShake	: bool = ( animEventType == AET_DurationStart );
		GCameraShake(0.1, true, this.GetWorldPosition(), 30.0f, loopShake);
	}
	event OnAnimEvent_Shake1( animEventName : name, animEventType : EAnimationEventType, animInfo : SAnimationEventAnimInfo )
	{
		var loopShake	: bool = ( animEventType == AET_DurationStart );
		GCameraShake(0.2, true, this.GetWorldPosition(), 30.0f, loopShake);
	}
	event OnAnimEvent_Shake2( animEventName : name, animEventType : EAnimationEventType, animInfo : SAnimationEventAnimInfo )
	{
		var loopShake	: bool = ( animEventType == AET_DurationStart );
		GCameraShake(0.4, true, this.GetWorldPosition(), 30.0f, loopShake);
	}
	event OnAnimEvent_Shake3( animEventName : name, animEventType : EAnimationEventType, animInfo : SAnimationEventAnimInfo )
	{
		var loopShake	: bool = ( animEventType == AET_DurationStart );
		GCameraShake(0.6, true, this.GetWorldPosition(), 30.0f, loopShake);
	}
	event OnAnimEvent_Shake4( animEventName : name, animEventType : EAnimationEventType, animInfo : SAnimationEventAnimInfo )
	{
		var loopShake	: bool = ( animEventType == AET_DurationStart );
		GCameraShake(0.8, true, this.GetWorldPosition(), 30.0f, loopShake);
	}
	event OnAnimEvent_Shake5( animEventName : name, animEventType : EAnimationEventType, animInfo : SAnimationEventAnimInfo )
	{
		var loopShake	: bool = ( animEventType == AET_DurationStart );
		GCameraShake(1.0, true, this.GetWorldPosition(), 40.0f, loopShake);
	}
	
	event OnAnimEvent_DropItem( animEventName : name, animEventType : EAnimationEventType, animInfo : SAnimationEventAnimInfo )
	{
		
		
		DropItemFromSlot( 'r_weapon' );
		DropItemFromSlot( 'l_weapon' );
		this.BreakAttachment();
	}
	
	event OnAnimEvent_OnGround( animEventName : name, animEventType : EAnimationEventType, animInfo : SAnimationEventAnimInfo )
	{
		
		if(animEventType != AET_DurationEnd )
			SetBehaviorVariable( 'ExplorationMode', 1 );
		else
			SetBehaviorVariable( 'ExplorationMode', 2 );
	}
	
	event OnAnimEvent_Death( animEventName : name, animEventType : EAnimationEventType, animInfo : SAnimationEventAnimInfo )
	{
		if(animEventType == AET_DurationEnd && effectManager)
			effectManager.OwnerHasFinishedDeathAnim();
	}
	
	event OnAnimEvent_MountHorseType( animEventName : name, animEventType : EAnimationEventType, animInfo : SAnimationEventAnimInfo )
	{
		SignalGameplayEventParamCName('MountHorseType',GetAnimNameFromEventAnimInfo(animInfo));
	}
	
	event OnAnimEvent_HorseRidingOn( animEventName : name, animEventType : EAnimationEventType, animInfo : SAnimationEventAnimInfo )
	{
		SignalGameplayEvent( 'HorseRidingOn' );
	}
	
	
	event OnAnimEvent_item_track_hack_reading_book( animEventName : name, animEventType : EAnimationEventType, animInfo : SAnimationEventAnimInfo )
	{
		var ids : array<SItemUniqueId>;
		
		ids = GetInventory().AddAnItem( 'bookshelf_book', 1, true, true, false );
		if( GetInventory().IsIdValid( ids[0] ) )
		{
			GetInventory().MountItem( ids[0], true, true );
		}
	}
	
	
	event OnAnimEvent_item_track_hack_reading_book_unmount( animEventName : name, animEventType : EAnimationEventType, animInfo : SAnimationEventAnimInfo )
	{
		var ids : array<SItemUniqueId>;		
		
		if( animEventType == AET_DurationEnd )
		{
			ids = GetInventory().GetItemsByName( 'bookshelf_book' );
			if( GetInventory().IsIdValid( ids[0] ) )
			{
				GetInventory().UnmountItem( ids[0], true );
				GetInventory().RemoveItemByName( 'bookshelf_book', -1 );
			}
		}
	}
	
	
	event OnDeathAnimFinished()
	{
		if(effectManager)
			effectManager.OwnerHasFinishedDeathAnim();
		
		if(CanBleed())
		{
			CreateBloodSpill();
			CreateBloodSpill();
			CreateBloodSpill();
		}
	}
	
	public function EnableFinishComponent( flag : bool )
	{
		var comp : CComponent;
		
		comp = GetComponent( "Finish" );
				
		if ( comp )
		{
			if ( flag && !theGame.GetWorld().NavigationLineTest( thePlayer.GetWorldPosition(), this.GetWorldPosition(), 0.4f ) )
				flag = false;
			
			comp.SetEnabled( flag );
			
			if ( flag )
			{
				thePlayer.ProcessIsHoldingDeadlySword();
				thePlayer.UpdateDisplayTarget( true );
			}
		}
	}	
	
	public final function CanBleed() : bool
	{
		var pts, perc : float;
		
		GetResistValue(CDS_BleedingRes, pts, perc);
		
		return perc < 1;
	}
	
	public final function CreateBloodSpill()
	{
		var bloodTemplate : CEntityTemplate;
	
		bloodTemplate = (CEntityTemplate)LoadResource("blood_0" + RandRange(4));
		theGame.CreateEntity(bloodTemplate, GetWorldPosition() + VecRingRand(0, 0.5) , EulerAngles(0, RandF() * 360, 0));
	}
	
	
	
	
	public function DropItemFromSlot( slotName : name, optional removeFromInv : bool )
	{
		var itemToDrop 		: SItemUniqueId;
		var inv 			: CInventoryComponent;
		var droppedWeapon 	: SDroppedItem;
		var itemEntity		: CItemEntity;
	
		inv = GetInventory();
		itemToDrop = inv.GetItemFromSlot(slotName); 
		if ( inv.IsIdValid( itemToDrop ) )
		{
			itemEntity = inv.GetItemEntityUnsafe( itemToDrop );
			AddDroppedItem( inv.GetItemName( itemToDrop ), itemEntity );
			
			
				
			
				inv.DropItem( itemToDrop, removeFromInv );		
		}
	}
	
	public function AddDroppedItem( itemName : name, entity : CEntity )
	{
		var droppedItem : SDroppedItem;

		droppedItem.itemName = itemName;
		droppedItem.entity = entity;
		droppedItems.PushBack( droppedItem );
	}
	
	public function RemoveDroppedItem( itemName : name, destroy : bool )
	{
		var i : int;
		
		i = 0;
		while ( i < droppedItems.Size() )
		{
			if ( droppedItems[i].itemName == itemName )
			{
				
				if ( destroy && droppedItems[i].entity )
				{
					droppedItems[i].entity.Destroy();
				}				
				droppedItems.Erase(i);
			}
			else
			{
				i += 1;
			}
		}
	}
	
	public function DropEquipment( tag : name, optional direction : Vector )
	{
		var dropPhysics : CDropPhysicsComponent;

		if ( tag == '' )
		{
			LogAssert( false, "CActor.DropEquipment: empty tag!" );
			return;
		}

		dropPhysics = (CDropPhysicsComponent)GetComponentByClassName( 'CDropPhysicsComponent' );
		if ( dropPhysics )
		{
			dropPhysics.DropMeshByTag( tag, direction );
		}
	}	
	
	public function SetWound( woundName : name, optional spawnEntity : bool, optional createParticles : bool,
										        optional dropEquipment : bool, optional playSound : bool,
										        optional direction : Vector, optional playedEffectsMask : int )
	{
		var dc : CDismembermentComponent;
		dc = (CDismembermentComponent)GetComponentByClassName( 'CDismembermentComponent' );
		if ( dc )
		{
			
			
			if ( dc.IsExplosionWound( woundName ) )
			{
				createParticles = false;
			}
			dc.SetVisibleWound( woundName, spawnEntity, createParticles, dropEquipment, playSound, direction, playedEffectsMask );
		}
	}
	
	public function IsCurrentWound( woundName : name ) : bool
	{
		var dc : CDismembermentComponent;
		dc = (CDismembermentComponent)GetComponentByClassName( 'CDismembermentComponent' );
		if ( dc )
		{
			return ( dc.GetVisibleWoundName() == woundName );
		}	
		return false;
	}

	public function IsWoundDefined( woundName : name ) : bool
	{
		var dc : CDismembermentComponent;
		dc = (CDismembermentComponent)GetComponentByClassName( 'CDismembermentComponent' );
		if ( dc )
		{
			return dc.IsWoundDefined( woundName );
		}	
		return false;
	}

	public function GetNearestWoundForBone( boneIndex : int, directionWS : Vector, woundTypeFlags : EWoundTypeFlags ) : name
	{
		var dc : CDismembermentComponent;
		dc = (CDismembermentComponent)GetComponentByClassName( 'CDismembermentComponent' );
		if ( dc )
		{
			return dc.GetNearestWoundNameForBone( boneIndex, directionWS, woundTypeFlags );
		}	
		return '';
	}
	
	private var woundToDismember 	: name;
	private var forwardVector		: Vector;
	private var dismemberForceRagdoll : bool;
	private var dismemberEffectsMask : int;
	public function SetDismembermentInfo( woundName : name, vec : Vector, forceRagoll : bool, optional playedEffectsMask : int ) 	
	{ 
		woundToDismember = woundName; 
		forwardVector = vec;
		dismemberForceRagdoll = forceRagoll;
		dismemberEffectsMask = playedEffectsMask;
	}
	
	public timer function DelayedDismemberTimer( time : float , id : int)
	{
		Dismember();
	}

	private function Dismember()
	{		
		SetWound( woundToDismember, true, true, true, true, forwardVector, dismemberEffectsMask );
		
		if(dismemberForceRagdoll && ((CMovingPhysicalAgentComponent)GetMovingAgentComponent()).HasRagdoll() )
		{
			TurnOnRagdoll();
		}
	}
	
	public function TurnOnRagdoll()
	{
		SetBehaviorVariable( 'Ragdoll_Weight', 1.f );
		RaiseEvent( 'Ragdoll' );
	}
	
		
	
	private function FindAttackTargets(preAttackData : CPreAttackEventData) : array<CGameplayEntity>
	{
		var targets : array<CGameplayEntity>;
		var i : int;
		var attitude : bool;
		var canLog : bool;
		
		canLog = theGame.CanLog();
		
		if(preAttackData.rangeName == '')
		{
			if ( canLog )
			{
				LogAssert(false, "CActor.FindAttackTargets: attack <<" + preAttackData.attackName + ">> of <<" + this + ">> has no range defined!!! Skipping hit!!!");
				LogDMHits("CActor.FindAttackTargets: attack <<" + preAttackData.attackName + ">> of <<" + this + ">> has no range defined!!! Skipping hit!!!");
			}
			return targets;
		}
		else
		{
			GatherEntitiesInAttackRange(targets, preAttackData.rangeName);			
		}
		
		
		for(i=targets.Size()-1; i>=0; i-=1)
		{
			if(!targets[i] || targets[i] == this)
			{
				
				targets.EraseFast(i);
			}
			else if( (W3SignEntity)targets[i] || (CProjectileTrajectory)targets[i] || (CDamageAreaEntity)targets[i] || (W3ToxicCloud)targets[i])
			{
				
				targets.EraseFast(i);
			}	
			else if(!targets[i].IsAlive())
			{
				
				targets.EraseFast(i);
			}
			else if( targets[i].HasTag( 'isHiddenUnderground' ) )
			{
				
				targets.EraseFast(i);
			}
			else
			{
				
				attitude = IsRequiredAttitudeBetween(this, targets[i], preAttackData.Damage_Hostile, preAttackData.Damage_Neutral, preAttackData.Damage_Friendly || ((CActor)targets[i]).HasBuff(EET_AxiiGuardMe) );
				if(!attitude)
				{
					if ( canLog )
					{
						LogDMHits("Attacker <<" + this + ">> is skipping target << " + targets[i] + ">> due to failed attitude check");
					}
					targets.EraseFast(i);
				}
			}
		}
		
		
		
							
		return targets;
	}
	
	public function IsSuperHeavyAttack(attackName : name) : bool
	{
		return theGame.GetDefinitionsManager().AbilityHasTag(attackName, theGame.params.ATTACK_NAME_SUPERHEAVY);
	}
	
	public function IsHeavyAttack(attackName : name) : bool
	{
		return theGame.GetDefinitionsManager().AbilityHasTag(attackName, theGame.params.ATTACK_NAME_HEAVY);
	}

	public function IsLightAttack(attackName : name) : bool
	{
		return theGame.GetDefinitionsManager().AbilityHasTag(attackName, theGame.params.ATTACK_NAME_LIGHT);
	}
	
	
	function BlinkWeapon(optional weaponId : SItemUniqueId) : bool
	{
		if ( GetInventory().IsIdValid(weaponId) )
			GetInventory().PlayItemEffect(weaponId,'flash_fx');
		else
		{
			return PlayEffectOnHeldWeapon('flash_fx');
		}
		
		return true;
	}
	
	function PlayEffectOnHeldWeapon( effectName : name, optional disable : bool ) : bool
	{
		var itemId : SItemUniqueId;
		var inv : CInventoryComponent;
		
		inv = GetInventory();		
		itemId = inv.GetItemFromSlot('r_weapon');
		
		if ( !inv.IsIdValid(itemId) )
		{
			itemId = inv.GetItemFromSlot('l_weapon');
			
			if ( !inv.IsIdValid(itemId) )
				return false;
		}
		if ( disable )
			inv.StopItemEffect(itemId,effectName);
		else
			inv.PlayItemEffect(itemId,effectName);
		
		return true;
	}
	
	
	protected function PerformCounterCheck(parryInfo: SParryInfo) : bool;
	
	
	function PerformParryCheck(parryInfo: SParryInfo) : bool;
	
	
	event OnPreAttackEvent(animEventName : name, animEventType : EAnimationEventType, data : CPreAttackEventData, animInfo : SAnimationEventAnimInfo )
	{		
		var parriedBy : array<CActor>;
		var weaponId : SItemUniqueId;
		var player : CR4Player = thePlayer;
		var parried, countered : bool;
	
		
		
		
		if(animEventType == AET_DurationStart)
		{
			ignoreAttack = false;
			SetAttackData(data);
			weaponId = GetInventory().GetItemFromSlot(data.weaponSlot);
			if ( this != thePlayer )
				BlinkWeapon(weaponId);
			
			SetCurrentAttackData(data, animInfo );
			if ( data.rangeName == 'useCollisionFromItem' )
			{
				lastAttackRangeName = data.rangeName;
			}
		}
		
		else if(animEventType == AET_DurationEnd)
		{
			attackEventInProgress = false;
			
			
			if ( ignoreAttack )
			{
				ignoreAttack = false;
				return true;
			}
			
			
			if ( this == thePlayer && ( GetEventEndsAtTimeFromEventAnimInfo(animInfo) - GetLocalAnimTimeFromEventAnimInfo(animInfo) > 0.06 ))
				return true;
			
			weaponId = GetInventory().GetItemFromSlot(data.weaponSlot);
			
			if(!GetInventory().IsIdValid(weaponId) || data.attackName == '')
			{
				LogAttackEvents("No valid attack data set - skipping hit!");
				LogAssert(false, "No valid attack data set - skipping hit!");
				return false;
			}
				
			hitTargets = FindAttackTargets(data);
			parriedBy = TestParryAndCounter(data, weaponId, parried, countered);
			
			if( data.attackName == 'attack_speed_based' && this == thePlayer )
				return false;
			
			lastAttackRangeName = data.rangeName;
			DoAttack(data, weaponId, parried, countered, parriedBy, GetAnimNameFromEventAnimInfo( animInfo ), GetLocalAnimTimeFromEventAnimInfo( animInfo ));
		}
	}
	
	private function PreAttackParry()
	{
		var data : CPreAttackEventData;
		var animInfo : SAnimationEventAnimInfo;
		var parriedBy : array<CActor>;
		var weaponId : SItemUniqueId;
		var parried, countered : bool;
		
		if ( !attackEventInProgress )
			return;
		
		GetCurrentAttackDataAndAnimInfo( data, animInfo);
		
		weaponId = GetInventory().GetItemFromSlot(data.weaponSlot);
		
		if(!GetInventory().IsIdValid(weaponId) || data.attackName == '')
		{
			LogAttackEvents("No valid attack data set - skipping hit!");
			LogAssert(false, "No valid attack data set - skipping hit!");
			return;
		}
		
		parriedBy = TestParryAndCounter(data, weaponId, parried, countered);
		if ( parried || countered )
		{
			DoAttack(data, weaponId, parried, countered, parriedBy, GetAnimNameFromEventAnimInfo( animInfo ), GetLocalAnimTimeFromEventAnimInfo( animInfo ));
			ignoreAttack = true;
		}
	}
	
	
	
	protected var attackEventInProgress : bool;
	private var ignoreAttack : bool;
	private var currentAttackData : CPreAttackEventData;
	private var currentAttackAnimInfo : SAnimationEventAnimInfo;
	private var ignoreTargetsForCurrentAttack : array<CGameplayEntity>;
	
	private function SetCurrentAttackData(data : CPreAttackEventData , animInfo : SAnimationEventAnimInfo)
	{
		currentAttackData = data;
		currentAttackAnimInfo = animInfo;
		ignoreTargetsForCurrentAttack.Clear();
		attackEventInProgress = true;
		SignalGameplayEvent('NewCurrentAttackData');
	}
	
	private function GetCurrentAttackDataAndAnimInfo(out data : CPreAttackEventData , out animInfo : SAnimationEventAnimInfo) : bool
	{
		if ( !attackEventInProgress )
			return false;
		
		data = currentAttackData;
		animInfo = currentAttackAnimInfo;
		
		return true;
	}
	
	public function GetCurrentAttackData( out data : CPreAttackEventData ) : bool
	{
		if ( !attackEventInProgress )
			return false;
		
		data = currentAttackData;
		
		return true;
	}
	
	
	
	event OnCollisionFromItem( collidedEntity : CGameplayEntity, optional itemEntity : CItemEntity )
	{
		var data 				: CPreAttackEventData;
		var animInfo 			: SAnimationEventAnimInfo;
		var parriedBy 			: array<CActor>;
		var weaponId 			: SItemUniqueId;
		var parried, countered 	: bool;
		var hasProperAttitude	: bool;
		var npc 				: CNewNPC;
		
		if ( !attackEventInProgress )
		{
			LogItemCollision("Item " + itemEntity + " collided with " + collidedEntity + " but Attack is not in progress");
			return false;
		}
		
		npc = (CNewNPC) this;
		if ( npc && !npc.IsAttacking() )
		{
			attackEventInProgress = false;
			if ( ignoreAttack )
			{
				ignoreAttack = false;
			}
			
			LogItemCollision("Item " + itemEntity + " collided with " + collidedEntity + " but npc is not attacking");
			return false;
		}
		
		if ( !collidedEntity )
		{
			LogItemCollision("Item " + itemEntity + " collided with NOT actor");
			return false;
		}
		
		if ( ignoreTargetsForCurrentAttack.Contains(collidedEntity) )
			return false;
		
		GetCurrentAttackDataAndAnimInfo( data, animInfo);
		
		if ( data.rangeName != 'useCollisionFromItem' )
			return false;
			
		hasProperAttitude = IsRequiredAttitudeBetween(this, collidedEntity, data.Damage_Hostile, data.Damage_Neutral, data.Damage_Friendly);
		if ( !hasProperAttitude )
		{
			return false;
		}
		
		weaponId = GetInventory().GetItemFromSlot(data.weaponSlot);
		
		GetInventory().GetItemEntityUnsafe(weaponId) == itemEntity;
		
		if(!GetInventory().IsIdValid(weaponId) || data.attackName == '' )
		{
			LogAttackEvents("No valid attack data set - skipping hit!");
			LogAssert(false, "No valid attack data set - skipping hit!");
			return false;
		}
		else if ( itemEntity && GetInventory().GetItemEntityUnsafe(weaponId) != itemEntity )
		{
			LogItemCollision("Item " + itemEntity + " collided with " + collidedEntity + " but Attack is for different item");
			return false;
		}
		
		
		
		if ( this.HasAbility( 'WildHunt_Imlerith' ) )
			data.canBeDodged = false;
		
		hitTargets.PushBack(collidedEntity);
		parriedBy = TestParryAndCounter(data, weaponId, parried, countered);
		
		DoAttack(data, weaponId, parried, countered, parriedBy, GetAnimNameFromEventAnimInfo( animInfo ), GetLocalAnimTimeFromEventAnimInfo( animInfo ));
		
		LogItemCollision("Item " + itemEntity + " collided with " + collidedEntity + " and Attack should deal dmg");
		
		ignoreTargetsForCurrentAttack.PushBack(collidedEntity);
		ignoreAttack = true;
		return true;
	}
	
	
	
	event OnCollisionFromGiantWeapon( collidedActor : CActor, optional itemEntity : CItemEntity )
	{
		var data 				: CPreAttackEventData;
		var animInfo 			: SAnimationEventAnimInfo;
		var parriedBy 			: array<CActor>;
		var weaponId 			: SItemUniqueId;
		var parried, countered 	: bool;
		var hasProperAttitude	: bool;
		var npc 				: CNewNPC;
		
		if ( !attackEventInProgress )
		{
			LogItemCollision("Item " + itemEntity + " collided with " + collidedActor + " but Attack is not in progress");
			return false;
		}
		
		npc = (CNewNPC) this;
		if ( npc && !npc.IsAttacking() )
		{
			attackEventInProgress = false;
			if ( ignoreAttack )
			{
				ignoreAttack = false;
			}
			
			LogItemCollision("Item " + itemEntity + " collided with " + collidedActor + " but npc is not attacking");
			return false;
		}
		
		if ( !collidedActor )
		{
			LogItemCollision("Item " + itemEntity + " collided with NOT actor");
			return false;
		}
		
		if ( ignoreTargetsForCurrentAttack.Contains(collidedActor) )
			return false;
		
		GetCurrentAttackDataAndAnimInfo( data, animInfo);
		
		if ( data.rangeName != 'useCollisionFromItem' )
			return false;
			
		hasProperAttitude = IsRequiredAttitudeBetween(this, collidedActor, data.Damage_Hostile, data.Damage_Neutral, data.Damage_Friendly);
		if ( !hasProperAttitude )
		{
		
		}
		
		weaponId = GetInventory().GetItemFromSlot(data.weaponSlot);
		
		GetInventory().GetItemEntityUnsafe(weaponId) == itemEntity;
		
		if(!GetInventory().IsIdValid(weaponId) || data.attackName == '' )
		{
			LogAttackEvents("No valid attack data set - skipping hit!");
			LogAssert(false, "No valid attack data set - skipping hit!");
			return false;
		}
		else if ( itemEntity && GetInventory().GetItemEntityUnsafe(weaponId) != itemEntity )
		{
			LogItemCollision("Item " + itemEntity + " collided with " + collidedActor + " but Attack is for different item");
			return false;
		}
		
		
		if ( collidedActor.HasAbility( 'CustomReactionToGiantWeapon' ) || collidedActor.HasTag( 'CustomReactionToGiantWeapon' ) )
		{	
			this.SignalGameplayEventParamObject( 'ReactionToGiantWeaponActor', collidedActor );
			this.SignalGameplayEventParamObject( 'ReactionToGiantWeaponItem', itemEntity );
		}
		else
		{
			return false;
		}
		
		return true;
	}
	
	
	
	
	public function SetAttackData(data : CPreAttackEventData)
	{
		var i : int;
		var targets : array<CGameplayEntity>;
		var npc 	: CNewNPC;
		var actor 	: CActor;
		
		
		if(!GetInventory().IsIdValid(GetInventory().GetItemFromSlot(data.weaponSlot)) )
		{
			if ( theGame.CanLog() )
			{
				LogAssert(false, "Attacker <<" + this + ">> has invalid weapon ID, no attack data set!!!");
				LogDMHits("Attacker <<" + this + ">> has invalid weapon ID, no attack data set!!!");
			}
			return;
		}
		
		
		SetDebugAttackRange(data.rangeName);
		
		
		if(!IsNameValid(attackActionName))
			attackActionName = data.attackName;
			
		
		npc = (CNewNPC)this;
		if(npc)
		{
			npc.SetCounterWindowStartTime(theGame.GetEngineTime());
			npc.SignalGameplayEventParamInt( 'swingType', data.swingType );
			npc.SignalGameplayEventParamInt( 'swingDir', data.swingDir );
			
			if((ShouldProcessTutorial('TutorialCounter') || ShouldProcessTutorial('TutorialDodge')) && GetTarget() == thePlayer && FactsQuerySum("tut_fight_use_slomo") > 0 && !thePlayer.IsCurrentlyDodging())
			{
				
				if(theGame.GetTutorialSystem().AreMessagesEnabled())
					theGame.SetTimeScale(0.001, theGame.GetTimescaleSource(ETS_TutorialFight), theGame.GetTimescalePriority(ETS_TutorialFight) );
					
				
				FactsAdd("tut_fight_slomo_ON");
			}
		}
		
		
		targets = FindAttackTargets(data);
				
		if ( targets.Size() == 0 && this == thePlayer && this.slideTarget)
			targets.PushBack(this.slideTarget);
		
		for(i=0; i<targets.Size(); i+=1)
		{			
			
			npc = (CNewNPC)targets[i];
			if( npc )
			{
				if ( !this.IsUsingHorse() ) 
				{
					
					if(data.hitReactionType == EHRT_Light)
						npc.SignalGameplayEventParamInt('Time2Dodge', (int)EDT_Attack_Light );
					else if(data.hitReactionType == EHRT_Heavy)
						npc.SignalGameplayEventParamInt('Time2Dodge', (int)EDT_Attack_Heavy );
					
					npc.SignalGameplayEventParamInt( 'swingType', data.swingType );
					npc.SignalGameplayEventParamInt( 'swingDir', data.swingDir );
				}
				
				if( ( npc.IsShielded(this) || npc.IsGuarded() ) && data.Can_Parry_Attack)
				{
					
					if(IsHeavyAttack(attackActionName))
					{
						npc.SignalGameplayEventParamInt('ParryStart',1);
						
					}
					else
					{
						npc.SignalGameplayEventParamInt('ParryStart',0);
						
					}
				}
			}
			
			actor = (CActor) targets[i];
			if ( actor )
			{
				
				actor.IsAttacked();
			}
		}
	}
		
	
	protected function TestParryAndCounter(data : CPreAttackEventData, weaponId : SItemUniqueId, out parried : bool, out countered : bool) : array<CActor>
	{
		var actor : CActor;
		var i : int;
		var parryInfo : SParryInfo;
		var parriedBy : array<CActor>;
		var npc : CNewNPC;
		var playerTarget : CR4Player;
		var levelDiff : int;
		var chanceToFailParry : float;
	
		
		
		SetDebugAttackRange(data.rangeName);
		RemoveTimer('PostAttackDebugRangeClear');		
		
		
		for(i=hitTargets.Size()-1; i>=0; i-=1)
		{
			actor = (CActor)hitTargets[i];
			if(!actor)
				continue;				
			
			parryInfo = ProcessParryInfo(this, actor, data.swingType, data.swingDir, attackActionName, weaponId, data.Can_Parry_Attack );
			playerTarget = (CR4Player)hitTargets[i];
			parried = false;
			countered = false;
			
			if( FactsQuerySum( "tut_fight_start" ) > 0 || actor.HasAbility( 'IgnoreLevelDiffForParryTest' ) )
				levelDiff = 0;
			else
				levelDiff = GetLevel() - actor.GetLevel();
			
			
			
			if( thePlayer.IsInFistFightMiniGame() || levelDiff < 100 && (!playerTarget || playerTarget.IsActionAllowed(EIAB_Counter)) )
			
				countered = actor.PerformCounterCheck(parryInfo);
				
			if(!countered)
			{
				
				
				if( thePlayer.IsInFistFightMiniGame() || levelDiff < 100 && (!playerTarget || playerTarget.IsActionAllowed(EIAB_Parry)) )
				
				{
					if ( !thePlayer.IsInFistFightMiniGame() && levelDiff >= theGame.params.LEVEL_DIFF_HIGH )
					{
						chanceToFailParry = CalculateAttributeValue(actor.GetAttributeValue('chance_to_fail_parry_per_level_diff'));
						if ( chanceToFailParry > 0 )
						{
							chanceToFailParry *= (levelDiff - theGame.params.LEVEL_DIFF_HIGH + 1);
							if( RandRange(100) < chanceToFailParry )
								parryInfo.canBeParried = false;
						}
					}

					parried = actor.PerformParryCheck(parryInfo);
				}
			}
			else if(playerTarget && data.Can_Parry_Attack)
			{
				FactsAdd("ach_counter", 1, 4 );
				theGame.GetGamerProfile().CheckLearningTheRopes();
			}
				
			
															
			
			
			if(countered || parried)
			{
				
				actor.SetDetailedHitReaction(data.swingType, data.swingDir);

				if ( theGame.CanLog() )
				{			
					
					LogAttackRangesDebug("");
					if(countered)
					{
						LogDMHits("Attack countered by <<" + actor + ">>");
						LogAttackRangesDebug("Attack countered by <<" + actor + ">>");
					}
					else if(parried)
					{
						LogDMHits("Attack parried by <<" + actor + ">>");
						LogAttackRangesDebug("Attack parried by <<" + actor + ">>");
					}
				}
			
				parriedBy.PushBack(actor);
			}
		}
		
		return parriedBy;
	}

	
	protected function DoAttack(animData : CPreAttackEventData, weaponId : SItemUniqueId, parried : bool, countered : bool, parriedBy : array<CActor>, attackAnimationName : name, hitTime : float)
	{
		var i : int;		
		var weaponEntity : CItemEntity;
		
		phantomStrike = false;
		weaponEntity = GetInventory().GetItemEntityUnsafe(weaponId);
		
		
		for(i=0; i<hitTargets.Size(); i+=1)
		{				
			Attack(hitTargets[i], animData, weaponId, parried, countered, parriedBy, attackAnimationName, hitTime, weaponEntity);
		}
		
		if( GetInventory().ItemHasTag( weaponId, 'PhantomWeapon' ) )
		{	
			if( this == thePlayer && IsLightAttack( attackActionName ) && hitTargets.Size() )
			{	
				thePlayer.GetPhantomWeaponMgr().IncrementHitCounter();
				attackActionName = '';
			}
			else if( IsHeavyAttack( attackActionName ) )
			{
				AddTimer('PhantomWeapon', 0.0);
				phantomWeaponHitTime = hitTime + 0.0;
				phantomWeaponAnimData = animData;
				phantomWeaponWeaponId = weaponId;
				phantomWeaponParried = parried;
				phantomWeaponCountered = countered;
				phantomWeaponParriedBy = parriedBy;
				phantomWeaponAttackAnimationName = attackAnimationName;
				phantomWeaponHitTargets = hitTargets;
			}
			else
			{
				attackActionName = '';
			}
		}
		else
		{		
			attackActionName = '';
		}
		
		
		hitTargets.Clear();
		AddTimer('PostAttackDebugRangeClear', 1);		
	}
	
	
	var phantomWeaponAnimData : CPreAttackEventData;
	var phantomWeaponWeaponId : SItemUniqueId;
	var phantomWeaponParried : bool;
	var phantomWeaponCountered : bool;
	var phantomWeaponParriedBy : array<CActor>;
	var phantomWeaponAttackAnimationName : name;
	var phantomWeaponHitTime : float;
	var phantomWeaponHitTargets : array<CGameplayEntity>;
	var phantomStrike : bool;
	
	timer function PhantomWeapon(dt : float, id : int)
	{
		var i : int;		
		var weaponEntity : CItemEntity;
		
		weaponEntity = GetInventory().GetItemEntityUnsafe(phantomWeaponWeaponId);
		
		if( this == thePlayer )
		{
			if( thePlayer.GetPhantomWeaponMgr().IsWeaponCharged() )
				phantomStrike = true;
		}
		else
		{
			phantomStrike = true;
		}
		
		
		for(i=0; i<phantomWeaponHitTargets.Size(); i+=1)
		{	
			
			phantomWeaponHitTargets[i].AddAbility( 'DisableFinishers', true );
			phantomWeaponHitTargets[i].AddAbility( 'DisableDismemberment', true );
			
			Attack(phantomWeaponHitTargets[i], phantomWeaponAnimData, phantomWeaponWeaponId, phantomWeaponParried, phantomWeaponCountered, phantomWeaponParriedBy, phantomWeaponAttackAnimationName, phantomWeaponHitTime, weaponEntity);
			
			phantomWeaponHitTargets[i].RemoveAbility( 'DisableFinishers' );
			phantomWeaponHitTargets[i].RemoveAbility( 'DisableDismemberment' );
		}
		
		if( !phantomWeaponCountered && phantomWeaponHitTargets.Size() && phantomWeaponParried )
			PlayEffectOnHeldWeapon( 'special_attack_block' );
		
		AddTimer('PostAttackDebugRangeClear', 1);
		attackActionName = '';
	}
	
	timer function PostAttackDebugRangeClear(dt : float, id : int)
	{
		SetDebugAttackRange('');
	}
	
	protected function Attack( hitTarget : CGameplayEntity, animData : CPreAttackEventData, weaponId : SItemUniqueId, parried : bool, countered : bool, parriedBy : array<CActor>, attackAnimationName : name, hitTime : float, weaponEntity : CItemEntity)
	{
		var action : W3Action_Attack;
		
		if(PrepareAttackAction(hitTarget, animData, weaponId, parried, countered, parriedBy, attackAnimationName, hitTime, weaponEntity, action))
		{
			theGame.damageMgr.ProcessAction(action);
			delete action;
		}
	}
	
	public function SetAttackActionName(nam : name)								
	{
		attackActionName = nam;
	}
	
	protected function PrepareAttackAction( hitTarget : CGameplayEntity, animData : CPreAttackEventData, weaponId : SItemUniqueId, parried : bool, countered : bool, parriedBy : array<CActor>, attackAnimationName : name, hitTime : float, weaponEntity : CItemEntity, out attackAction : W3Action_Attack) : bool
	{
		var actor : CActor;
	
		if(!hitTarget)
			return false;
			
		attackAction = new W3Action_Attack in theGame.damageMgr;
		
		if ( animData.hitFX == 'basedOnWeapon' )
			ChangeHitFxBasedOnWeapon(animData, weaponId);
			
		attackAction.Init( this, hitTarget, NULL, weaponId, animData.attackName, GetName(), animData.hitReactionType, animData.Can_Parry_Attack, animData.canBeDodged, attackActionName, animData.swingType, animData.swingDir, true, false, false, false, animData.hitFX, animData.hitBackFX, animData.hitParriedFX, animData.hitBackParriedFX);
		
		attackAction.SetAttackAnimName(attackAnimationName);
		attackAction.SetHitTime(hitTime);
		attackAction.SetWeaponEntity(weaponEntity);
		attackAction.SetWeaponSlot(animData.weaponSlot);
		attackAction.SetSoundAttackType(animData.soundAttackType);
		
		actor = (CActor)hitTarget;
		
		if(actor && parriedBy.Contains(actor))
		{
			if(parried)
			{
				attackAction.SetIsParried(true);
				SignalGameplayEvent('AttackParried');
			}
			else if(countered)
			{
				attackAction.SetIsCountered(true);
				SignalGameplayEvent('AttackCountered');
			}
		}
		
		
		if ( attackAction.IsParried() && attackAction.attacker.HasAbility('ReflectOnBeingParried') )
		{
			((CActor)attackAction.attacker).SetCanPlayHitAnim( true );
			ReactToReflectedAttack(attackAction.victim);
		}
		
		
		if(phantomStrike)
		{
			attackAction.SetIsParried(false);
			attackAction.SetHitAnimationPlayType(EAHA_ForceNo);
			
			if( attackAction.attacker == thePlayer )
			{
				thePlayer.GetPhantomWeaponMgr().DischargeWeapon( true );
				attackAction.AddEffectInfo( EET_HeavyKnockdown );
				
				if( ((CNewNPC)attackAction.victim).IsShielded( NULL ) )
					((CNewNPC)attackAction.victim).ProcessShieldDestruction();
			}
			else
			{
				if( parried )
				{				
					attackAction.AddEffectInfo( EET_Stagger );
					attackAction.ClearDamage();
				}
				else if( !parried && !countered )
				{
					attackAction.AddEffectInfo( EET_Knockdown );
				}
			}
		}
		
		return true;
	}
	
	protected function ChangeHitFxBasedOnWeapon( out animData : CPreAttackEventData , weaponId : SItemUniqueId)
	{
		var weaponName 	: name;
		
		weaponName = GetInventory().GetItemName(weaponId);
		
		if ( weaponName == 'fists' )
		{
			animData.hitFX 				= 'fistfight_hit';
			animData.hitBackFX 			= 'fistfight_hit_back';
		}
		else if (  weaponName == 'fists_lightning' )
		{
			animData.hitFX 				= 'hit_electric';
			animData.hitParriedFX 		= 'hit_electric';
			animData.hitBackFX 			= 'hit_electric';
			animData.hitBackParriedFX 	= 'hit_electric';
		}
		else if ( weaponName == 'fists_fire' )
		{
			animData.hitFX 				= 'fire_hit';
			animData.hitParriedFX 		= 'fire_hit';
			animData.hitBackFX 			= 'fire_hit';
			animData.hitBackParriedFX 	= 'fire_hit';
		}
		else if (  weaponName == 'fists_lightning_lynx' )
		{
			animData.hitFX 				= 'hit_electric_quen';
			animData.hitParriedFX 		= 'hit_electric_quen';
			animData.hitBackFX 			= 'hit_electric_quen';
			animData.hitBackParriedFX 	= 'hit_electric_quen';
		}
	}
	
	public function ReduceDamage( out damageData : W3DamageAction )
	{
		var actorAttacker 			: CActor;
		var id 						: SItemUniqueId;
		var attackAction 			: W3Action_Attack;
		var arrStr 					: array<string>;
		var l_percAboutToBeRemoved 	: float;
		var l_healthPerc			: float;
		var l_threshold				: float;
		var l_maxPercLossAllowed	: float;
		var l_maxDamageAllowed		: float;
		var l_maxHealth, mult		: float;
		var l_actorTarget			: CActor;
		var canLog					: bool;
		var hitsToKill				: SAbilityAttributeValue;
		var thisNPC					: CNewNPC;
		var minDamage				: float;
		var i						: int;
		var dmgTypes 				: array< SRawDamage >;
		var hasPoisonDamage			: bool;
		
		canLog = theGame.CanLog();
			
		
		
		
		if( damageData.victim == thePlayer && !damageData.IsDoTDamage() )
		{
			damageData.GetDTs( dmgTypes );
			
			
			for( i=0; i<dmgTypes.Size(); i+=1 )
			{
				if( dmgTypes[i].dmgType == theGame.params.DAMAGE_NAME_DIRECT )
				{
					dmgTypes.EraseFast( i );
					break;
				}
			}
			
			if( dmgTypes.Size() > 0 )
			{
				hasPoisonDamage = false;
				for( i=0; i<dmgTypes.Size(); i+=1 )
				{
					if( dmgTypes[ i ].dmgType == theGame.params.DAMAGE_NAME_POISON )
					{
						hasPoisonDamage = true;
						break;
					}
				}
			
				if( !( hasPoisonDamage && this == GetWitcherPlayer() && HasBuff( EET_GoldenOriole ) && GetWitcherPlayer().GetPotionBuffLevel( EET_GoldenOriole ) == 3) )
				{
					minDamage = 0;
					for( i=0; i<dmgTypes.Size(); i+=1 )
					{
						if( DamageHitsVitality( dmgTypes[ i ].dmgType ) )
						{
							minDamage += dmgTypes[ i ].dmgVal;
						}
					}
					minDamage *= 0.05;
					if(minDamage < 1)
					{
						minDamage = 1;
					}	
					if( damageData.processedDmg.vitalityDamage < minDamage )
					{
						damageData.processedDmg.vitalityDamage = minDamage;
					}
				}
			}
		}
		
		
		if(damageData.IsActionRanged() && damageData.attacker == thePlayer && (W3BoltProjectile)(damageData.causer) )
		{
			if(UsesEssence() && damageData.processedDmg.essenceDamage < 1)
			{
				damageData.processedDmg.essenceDamage = 1;
					
				if ( canLog )
				{
					LogDMHits("CActor.ReduceDamage: victim would take no damage but it's a bolt so we deal 1 pt of damage", damageData );
				}
			}
			else if(UsesVitality() && damageData.processedDmg.vitalityDamage < 1)
			{
				damageData.processedDmg.vitalityDamage = 1;
				
				if ( canLog )
				{
					LogDMHits("CActor.ReduceDamage: victim would take no damage but it's a bolt so we deal 1 pt of damage", damageData );
				}
			}
		}
		
		
		thisNPC = (CNewNPC)this;
		if( thisNPC && damageData.attacker == thePlayer && !HasBuff(EET_AxiiGuardMe) &&
			( GetAttitudeBetween( this, thePlayer ) == AIA_Friendly ||
			( GetAttitudeBetween( this, thePlayer ) == AIA_Neutral && thisNPC.GetNPCType() == ENGT_Guard ) ) )
		{
			if ( canLog )
			{
				LogDMHits("Player attacked friendly or neutral community npc - no damage dealt", damageData);
			}
			damageData.SetAllProcessedDamageAs(0);
			damageData.ClearEffects();
			return;
		}
		
		
		if( HasBuff(EET_AxiiGuardMe) && damageData.attacker != thePlayer )
		{
			damageData.processedDmg.vitalityDamage *= 0.1f;
			damageData.processedDmg.essenceDamage *= 0.1f;
		}
		
		
		
		if(damageData.IsActionMelee() && HasAbility( 'ReflectMeleeAttacks' ) )
		{
			if ( canLog )
			{
				LogDMHits("CActor.ReduceDamage: victim is heavily armored and attacker bounces of his armor", damageData );
			}
			damageData.SetAllProcessedDamageAs(0);
			((CActor)damageData.attacker).ReactToReflectedAttack( this );
			damageData.ClearEffects();
			return;
		}
		
		
		if(!damageData.DealsAnyDamage() && damageData.GetBuffSourceName() != "Mutation4")
			return;
		
		
		if(damageData.IsActionMelee() && HasAbility( 'CannotBeAttackedFromAllSides' ) )
		{
			if ( canLog )
			{
				LogDMHits("CActor.ReduceDamage: victim attacked from behind and immune to this type of strike - no damage will be done", damageData );
			}
			damageData.SetAllProcessedDamageAs(0);
			((CActor)damageData.attacker).ReactToReflectedAttack( this );
			damageData.ClearEffects();
			return;
		}
		
		
		if(damageData.IsActionMelee() && HasAbility( 'CannotBeAttackedFromBehind' ) && IsAttackerAtBack(damageData.attacker) )
		{
			if ( canLog )
			{
				LogDMHits("CActor.ReduceDamage: victim attacked from behind and immune to this type of strike - no damage will be done", damageData );
			}
			damageData.SetAllProcessedDamageAs(0);
			((CActor)damageData.attacker).ReactToReflectedAttack( this );
			damageData.ClearEffects();
			return;
		}
		
		
		if(damageData.IsActionMelee() && HasAbility( 'VulnerableFromFront' ) && !IsAttackerAtBack(damageData.attacker) )
		{
			if ( canLog )
			{
				LogDMHits("CActor.ReduceDamage: victim attacked from front and vulnerable to this type of strike - attack will ignor armor", damageData );
			}
			damageData.SetIgnoreArmor( true );
			damageData.SetPointResistIgnored( true );
			return;
		}
		
		
		
		if( this.HasAbility( 'EredinInvulnerable' ) && damageData.IsActionWitcherSign() )
		{
			if ( canLog )
			{
				LogDMHits("CActor.ReduceDamage: victim has EredinInvulnerable ability - no damage will be done", damageData );
			}
			damageData.SetAllProcessedDamageAs(0);
			return;
		}
		
		
		if(this != thePlayer && IsCurrentlyDodging() && damageData.CanBeDodged() && ( VecDistanceSquared(this.GetWorldPosition(),damageData.attacker.GetWorldPosition()) > 1.7 
			|| this.HasAbility( 'IgnoreDodgeMinimumDistance' ) ))
		{
			if ( canLog )
			{
				LogDMHits("Non-player character dodge - no damage dealt", damageData);
			}
			damageData.SetWasDodged();
			damageData.SetAllProcessedDamageAs(0);
			damageData.ClearEffects();
			damageData.SetHitAnimationPlayType(EAHA_ForceNo);
			return;
		}
		
		
		if(this != thePlayer && FactsDoesExist("debug_fact_weak"))
		{
			if ( canLog )
			{
				LogDMHits("CActor.ReduceDamage: using 'weak' cheat - all damage set to 0.001", damageData );
			}
			damageData.processedDmg.essenceDamage = MinF(0.001, damageData.processedDmg.essenceDamage);
			damageData.processedDmg.vitalityDamage = MinF(0.001, damageData.processedDmg.vitalityDamage);
			damageData.processedDmg.staminaDamage = MinF(0.001, damageData.processedDmg.staminaDamage);
			damageData.processedDmg.moraleDamage = MinF(0.001, damageData.processedDmg.moraleDamage);
		}
		
		
		
		
		if(damageData.IsParryStagger())
		{
			actorAttacker = (CActor)damageData.attacker;
			
			if ( ((CMovingPhysicalAgentComponent)( actorAttacker ).GetMovingAgentComponent()).GetCapsuleHeight() > 2.f )
				mult = theGame.params.PARRY_STAGGER_REDUCE_DAMAGE_LARGE;
			else if ( actorAttacker.GetRadius() > 0.6 )
				mult = theGame.params.PARRY_STAGGER_REDUCE_DAMAGE_LARGE;
			else if ( this == thePlayer && thePlayer.GetBossTag() != '' )	
				mult = theGame.params.PARRY_STAGGER_REDUCE_DAMAGE_LARGE;
			else if ( actorAttacker.HasAbility( 'mon_troll_base' ) )
				mult = theGame.params.PARRY_STAGGER_REDUCE_DAMAGE_LARGE;
			else
				mult = theGame.params.PARRY_STAGGER_REDUCE_DAMAGE_SMALL;
			
			damageData.MultiplyAllDamageBy(mult);
			
			if ( canLog )
			{
				LogDMHits("Stagger-Parry, reducing damage by " + NoTrailZeros((1-mult)*100) + "%");
			}
		}
		else
		{
			
			attackAction = (W3Action_Attack)damageData;
			if(attackAction && damageData.IsActionMelee() && attackAction.CanBeParried() && (attackAction.IsParried() || attackAction.IsCountered()))
			{
				arrStr.PushBack(GetDisplayName());
				if(attackAction.IsParried())
				{
					if ( canLog )
					{
						LogDMHits("Attack parried - no damage", damageData);
					}
					theGame.witcherLog.AddCombatMessage(GetLocStringByKeyExtWithParams("hud_combat_log_parries", , , arrStr), attackAction.attacker, this);
				}
				else
				{
					if ( canLog )
					{			
						LogDMHits("Attack countered - no damage", damageData);
					}
					theGame.witcherLog.AddCombatMessage(GetLocStringByKeyExtWithParams("hud_combat_log_counters", , , arrStr), attackAction.attacker, this);
				}
				
				damageData.SetAllProcessedDamageAs(0);
				return;
			}
		}
		
		actorAttacker = (CActor)damageData.attacker;
		
		
		if((CPlayer)actorAttacker && !((CPlayer)damageData.victim) && FactsQuerySum('player_is_the_boss') > 0)
		{
			if ( canLog )
			{			
				LogDMHits("Using 'like a boss' cheat - damage set to 40% of targets MAX health", damageData);
			}
			damageData.processedDmg.vitalityDamage = GetStatMax(BCS_Vitality) / 2.5;		
			damageData.processedDmg.essenceDamage = GetStatMax(BCS_Essence) / 2.5;		
		}	
		
		
		if(attackAction && actorAttacker == thePlayer && thePlayer.inv.IsItemBolt(attackAction.GetWeaponId()) )		
		{
			if(thePlayer.IsOnBoat())
			{
				hitsToKill = GetAttributeValue('extraDamageWhenPlayerOnBoat');
				if(hitsToKill.valueAdditive > 0)
				{
					damageData.processedDmg.vitalityDamage = CeilF(GetStatMax(BCS_Vitality) / hitsToKill.valueAdditive);	
					damageData.processedDmg.essenceDamage = CeilF(GetStatMax(BCS_Essence) / hitsToKill.valueAdditive);		
					
					if(theGame.CanLog())
					{
						LogDMHits("Target is getting killed by " + NoTrailZeros(hitsToKill.valueAdditive) + " hits when being shot from boat by default bolts", damageData);
						LogDMHits("Final hacked damage is now, vit: " + NoTrailZeros(damageData.processedDmg.vitalityDamage) + ", ess: " + NoTrailZeros(damageData.processedDmg.essenceDamage), damageData);
					}
				}
			}
		}		
		
		
		
		if( HasAbility( 'ShadowFormActive' ) )
		{
			if ( canLog )
			{
				LogDMHits("CActor.ReduceDamage: victim has ShadowFormActive ability - damage reduced to 10% of base", damageData );
			}
			damageData.processedDmg.vitalityDamage *= 0.1f;
			damageData.processedDmg.essenceDamage *= 0.1f;
			damageData.SetCanPlayHitParticle( false );
			theGame.witcherLog.CombatMessageAddGlobalDamageMult(0.1f);
		}

		
		
		if( actorAttacker && HasAbility( 'IceArmor' ) && !actorAttacker.HasAbility( 'Ciri_Rage' ) )
		{
			if ( theGame.GetDifficultyMode() == EDM_Easy )
			{
				if ( canLog )
				{
					LogDMHits("CActor.ReduceDamage: victim has IceArmor ability - damage reduced by 5%", damageData );
				}
				damageData.processedDmg.vitalityDamage *= 0.95f;
				damageData.processedDmg.essenceDamage *= 0.95f;
				theGame.witcherLog.CombatMessageAddGlobalDamageMult(0.95f);
			}
			else
			{
				if ( canLog )
				{
					LogDMHits("CActor.ReduceDamage: victim has IceArmor ability - damage reduced by 50%", damageData );
				}
				damageData.processedDmg.vitalityDamage *= 0.5f;
				damageData.processedDmg.essenceDamage *= 0.5f;
				theGame.witcherLog.CombatMessageAddGlobalDamageMult(0.5f);
			}
		}

		
		
		
		if( HasAbility( 'LastBreath' ) )
		{
			l_threshold 	= CalculateAttributeValue( GetAttributeValue('lastbreath_threshold') );
			if( l_threshold == 0 ) l_threshold = 0.25f;
			l_healthPerc 	= GetHealthPercents();
			
			
			if( theGame.GetEngineTimeAsSeconds() - lastBreathTime < 1 )
			{
				if( damageData.processedDmg.vitalityDamage > 0 ) 	damageData.processedDmg.vitalityDamage 	= 0;
				if( damageData.processedDmg.essenceDamage > 0 ) 	damageData.processedDmg.essenceDamage 	= 0;
				
				if ( canLog )
				{
					LogDMHits("CActor.ReduceDamage: victim just activated LastBreath ability - reducing damage" );
				}
			}
			else if( l_healthPerc > l_threshold )
			{
				l_maxHealth 			= GetMaxHealth();
				l_percAboutToBeRemoved 	= MaxF( damageData.processedDmg.vitalityDamage, damageData.processedDmg.essenceDamage ) / l_maxHealth;
				
				l_maxPercLossAllowed 	= l_healthPerc - l_threshold;
				
				if( l_percAboutToBeRemoved > l_maxPercLossAllowed )
				{
					
					l_maxDamageAllowed = l_maxPercLossAllowed * l_maxHealth;
					if( damageData.processedDmg.vitalityDamage > 0 ) 	damageData.processedDmg.vitalityDamage 	= l_maxDamageAllowed;
					if( damageData.processedDmg.essenceDamage > 0 ) 	damageData.processedDmg.essenceDamage 	= l_maxDamageAllowed;
					if ( canLog )
					{
						LogDMHits("CActor.ReduceDamage: victim has LastBreath ability - reducing damage", damageData );
					}
					
					SignalGameplayEvent('LastBreath');
					lastBreathTime = theGame.GetEngineTimeAsSeconds();					
					DisableHitAnimFor( 1 );
				}
			}
		}
		
		if(damageData.victim != thePlayer)
		{
			
			if(!damageData.GetIgnoreImmortalityMode())
			{
				if(!((W3PlayerWitcher)this))
					Log("");
				
				
				if( IsInvulnerable() )
				{
					if ( canLog )
					{
						LogDMHits("CActor.ReduceDamage: victim Invulnerable - no damage will be dealt", damageData );
					}
					damageData.SetAllProcessedDamageAs(0);
					return;
				}
				
				if(actorAttacker && damageData.DealsAnyDamage() )
					actorAttacker.SignalGameplayEventParamObject( 'DamageInstigated', damageData );
				
				
				if( IsImmortal() )
				{
					if ( canLog )
					{
						LogDMHits("CActor.ReduceDamage: victim is Immortal, clamping damage", damageData );
					}
					damageData.processedDmg.vitalityDamage = ClampF(damageData.processedDmg.vitalityDamage, 0, GetStat(BCS_Vitality)-1 );
					damageData.processedDmg.essenceDamage  = ClampF(damageData.processedDmg.essenceDamage, 0, GetStat(BCS_Essence)-1 );
					return;
				}
			}
			else
			{
				
				if(actorAttacker && damageData.DealsAnyDamage() )
					actorAttacker.SignalGameplayEventParamObject( 'DamageInstigated', damageData );
			}
		}
	}
	
	
	public function GetDelaySinceLastAttacked() : float
	{
		return theGame.GetEngineTimeAsSeconds() - lastWasAttackedTime;
	}
	
	public function GetDelaySinceLastHit() : float
	{
		return theGame.GetEngineTimeAsSeconds() - lastWasHitTime;
	}
	
	public function IsAttacked( optional byPlayer : bool ) : void
	{
		if( byPlayer ) 
			SignalGameplayEvent( 'AttackedByPlayer' );
			
		lastWasAttackedTime = theGame.GetEngineTimeAsSeconds();
	}
	
	function IsAttackerAtBack(attacker : CNode) : bool
	{
		var targetToSourceAngle	: float;
		
		if(!attacker)
			return false;
		
		targetToSourceAngle = AbsF( NodeToNodeAngleDistance(attacker, this) );		
		if( targetToSourceAngle > 90 )
			return true;
		
		return false;
	}
	
	
	function ProcessSlideToTarget( duration : float, slideProperties : SSlideToTargetEventProps )
	{
		var attackerWorldPos, targetWorldPos, slideToWorldPos, targetNearestPointWorldPos	: Vector;
		var attackerToTargetDist 															: float;
		var minSlideDistance 																: float; 
		var maxSlideDistance 																: float;
		var slideDuration																	: float;
		
		if(!slideTarget)
			return;
			
		slideDuration = duration;
		minSlideDistance = slideProperties.minSlideDist;
		maxSlideDistance = slideProperties.maxSlideDist;
		
		attackerWorldPos = GetWorldPosition();
		targetWorldPos = slideTarget.GetWorldPosition();
		
		if ( (CActor)slideTarget )
			targetNearestPointWorldPos = ( (CActor)slideTarget ).GetNearestPointInPersonalSpace( attackerWorldPos );
		else
			targetNearestPointWorldPos = slideTarget.GetWorldPosition();
			
		attackerToTargetDist = VecDistance( attackerWorldPos, targetWorldPos );
		
		if ( attackerToTargetDist > minSlideDistance && attackerToTargetDist < maxSlideDistance )
		{
			GetVisualDebug().AddSphere('NearestEnemyLoc', 0.2f, targetNearestPointWorldPos, true, Color(0,255,255), 0.1f );
			ActionSlideToAsync( targetNearestPointWorldPos, slideDuration ); 
		}
	}
	
	function ProcessSlideToTargetDistance ( duration : float, targetDist : float )
	{
		var targetPos				: Vector;
		var targetToPlayerVector 	: Vector;
		var slidePosition 			: Vector;
	
		targetPos = GetTarget().GetWorldPosition();
		targetToPlayerVector = VecNormalize( GetWorldPosition() - targetPos );
		slidePosition = targetPos + ( targetToPlayerVector * targetDist );
		GetVisualDebug().AddSphere('SyncLocation', 0.25f, slidePosition, true, Color(0,210,210), 60.0f );
		ActionSlideToAsync( slidePosition, duration );
	}
		
	
	function SetDetailedHitType ( hitType : EDetailedHitType )
	{
		SetBehaviorVariable( 'detailedHitType',(int)hitType);
	}			
	
	function ChooseDetailedHitType( parryInfo : SParryInfo ) : EDetailedHitType
	{
		switch ( parryInfo.attackSwingType )
		{
			case AST_Jab:
				return EDHT_Straight; 
			case AST_Vertical:
				return EDHT_Straight; 
			default:
				if ( parryInfo.attackSwingDir == ASD_RightLeft )
					return EDHT_RightLeft; 
				else if ( parryInfo.attackSwingDir == ASD_LeftRight )
					return EDHT_LeftRight; 
				else
					return EDHT_None;
		}
	}
	
	function ChooseParryTypeIndex( parryInfo : SParryInfo ) : float
	{
		var parryType : EParryType;
		var parryTypeIndex 	: float;
		
		parryType = thePlayer.parryTypeTable[parryInfo.attackSwingType][parryInfo.attackSwingDir];
		
		lastParryType = parryType;
		
		parryTypeIndex = (float)((int)parryType);
		return parryTypeIndex;
	}

	function ProcessParryInfo( attacker : CActor, target : CActor, attackSwingType : EAttackSwingType, attackSwingDir : EAttackSwingDirection, attActionName : name, attackerWeaponId : SItemUniqueId, canBeParried : bool ) : SParryInfo
	{
		var parryInfo : SParryInfo;

		parryInfo.attacker = attacker;
		parryInfo.target = target;
		parryInfo.attackActionName = attActionName;
		parryInfo.attackerWeaponId = attackerWeaponId;
		parryInfo.targetToAttackerAngleAbs = AbsF( NodeToNodeAngleDistance(attacker,target) );
		parryInfo.targetToAttackerDist = VecDistance( attacker.GetWorldPosition(), target.GetWorldPosition() );
		parryInfo.attackSwingType = attackSwingType;
		parryInfo.attackSwingDir = attackSwingDir;
		parryInfo.canBeParried = canBeParried;
		
		if( attacker.HasAbility( 'UnblockableAttacks' ) )
		{
			parryInfo.canBeParried = false;
		}
		
		target.SetDetailedHitType(ChooseDetailedHitType(parryInfo));
		
		return parryInfo;			
	}
	
	
	timer function DelayDodgeProjectileEventTimer( dt : float , id : int)
	{
		SignalGameplayEvent( 'Time2DodgeProjectileDelayed' );
	}
	
	timer function DelayDodgeBombEventTimer( dt : float , id : int)
	{
		SignalGameplayEvent( 'Time2DodgeBombDelayed' );
	}
	
	timer function DelayRepulseProjectileEventTimer( dt : float , id : int)
	{
		SignalGameplayEvent( 'Time2RepulseProjectileDelayed' );
	}
	
	timer function DelayRepulseBombEventTimer( dt : float , id : int)
	{
		SignalGameplayEvent( 'Time2RepulseBombDelayed' );
	}
	
	
	
	
	
	
	public function GetTotalArmor() : SAbilityAttributeValue
	{
		return GetAttributeValue(theGame.params.ARMOR_VALUE_NAME, , true);
	}
	
	
	public function HasWeaponDrawn(treatFistsAsWeapon : bool) : bool
	{
		var ids : array<SItemUniqueId>;
		var i : int;
		var fistsIds : array<SItemUniqueId>;
		var inv : CInventoryComponent;
		
		inv = GetInventory();
		ids = inv.GetAllWeapons();
		
		if ( treatFistsAsWeapon )
		{
			
			for(i=0; i<ids.Size(); i+=1)
				if(inv.IsItemHeld(ids[i]))
					return true;
		}
		else
		{
			
			fistsIds = inv.GetItemsByCategory('fist');			
			for(i=0; i<ids.Size(); i+=1)
				if( !fistsIds.Contains(ids[i]) && inv.IsItemHeld(ids[i]) )
						return true;
		}
		
		return false;
	}
	
	public function UnequipItem(item : SItemUniqueId) : bool
	{
		return GetInventory().UnmountItem(item, true);
	}
	
	public function EquipItem(item : SItemUniqueId, optional slot : EEquipmentSlots, optional toHand : bool) : bool
	{
		return GetInventory().MountItem(item, toHand);
	}
	
	function IsInAgony() : bool;
	function Agony();
	
	function IsKnockedUnconscious() : bool
	{
		return knockedUncounscious;
	}
	
	function EnterKnockedUnconscious()
	{
		knockedUncounscious = true;
	}
	
	function EndKnockedUnconscious()
	{
		knockedUncounscious = false;
	}
	
	private timer function EnableHitAnim( time : float , id : int)
	{
		SetCanPlayHitAnim(true);
	}

	public function SetUsedVehicle(ent : CGameplayEntity)
	{
		usedVehicle = ent;
		
		if( usedVehicle )
		{
			EntityHandleSet(usedVehicleHandle,usedVehicle);
			GetRootAnimatedComponent().UpdateByOtherAnimatedComponent( usedVehicle.GetRootAnimatedComponent() );
			GetMovingAgentComponent().SetUseEntityForPelvisOffset( usedVehicle );
		}
		else
		{
			EntityHandleSet(usedVehicleHandle, NULL); 
			GetRootAnimatedComponent().DontUpdateByOtherAnimatedComponent();
			GetMovingAgentComponent().SetUseEntityForPelvisOffset();
		}
	}
	
	public final function GetUsedVehicle() : CGameplayEntity
	{
		var vehicleFromHandle : CGameplayEntity;

		
		vehicleFromHandle = (CGameplayEntity)EntityHandleGet( usedVehicleHandle );
		if ( vehicleFromHandle )
		{
			return vehicleFromHandle;
		}
		return usedVehicle;	
	}
	
	public function IsUsingVehicle() : bool
	{
		
		if ( EntityHandleGet( usedVehicleHandle ) )
		{
			return true;
		}
		return usedVehicle;
	}
	
	
	public final function IsUsingHorse( optional ignoreMountInProgress : bool ) : bool
	
	{
	
		var horseComp 		: W3HorseComponent;
		var mountStatus 	: EVehicleMountStatus;
		
		horseComp = GetUsedHorseComponent();
		if(horseComp)
		{
			mountStatus = horseComp.riderSharedParams.mountStatus;
			
			if( ignoreMountInProgress )
			{
				return mountStatus == VMS_mounted;
			}
			else
			{
				return mountStatus == VMS_mounted || mountStatus == VMS_mountInProgress;
			}
		}
		return false;
	}
	
	public function IsUsingBoat() : bool
	{
		if( (W3Boat)GetUsedVehicle() )
		{
			return true;
		}
		return false;
	}
	
	public function GetUsedHorseComponent() : W3HorseComponent
	{
		var npc : CNewNPC;
		
		npc = (CNewNPC)GetUsedVehicle();
		
		if(npc)
			return npc.GetHorseComponent();
		
		return NULL;
	}
	
	public final function FindAndMountVehicle( optional mountType : EVehicleMountType, optional maxDistance : float ) : bool 
	{
		var vehicle : CVehicleComponent;
		
		
		
		LogChannel( 'Vehicles', "Doing mounting" );
			
		vehicle = FindTheNearestVehicle( maxDistance, true );
		LogChannel( 'Vehicles', "vehicle " + vehicle );
		if ( vehicle )
		{
			vehicle.StopTheVehicle();
			
			
			vehicle.Mount( this, mountType, EVS_driver_slot );
			return true;
		}
		return false;
	}
	
	public final function FindTheNearestVehicle( maxDistance : float, requireToBeMountable : bool ) : CVehicleComponent
	{
		
		var vehicle : CVehicleComponent;
		var nodes : array< CNode >;
		var vehicleEntity : CEntity;
		
		
		theGame.GetNodesByTag('vehicle', nodes);
		if ( nodes.Size() == 0 )
		{
			return NULL;
		}
		
		vehicleEntity = SelectTheNearestVehicles( nodes, maxDistance );
		if ( !vehicleEntity )
		{
			return NULL;
		}
		
		vehicle = (CVehicleComponent)vehicleEntity.GetComponentByClassName('CVehicleComponent');
		if ( requireToBeMountable && vehicle && !vehicle.CanBeUsedBy( this ) )
		{
			return NULL;
		}
		
		return vehicle;
	}
	
	private final function SelectTheNearestVehicles( nodes : array< CNode >, maxDistance : float ) : CEntity
	{
		var i, size : int;
		var bestEnt : CEntity;
		var curr, best : float;
		var posA, posB : Vector;
		
		bestEnt = NULL;
		size = nodes.Size();
		best = maxDistance * maxDistance;
		
		posB = this.GetWorldPosition();
		
		for ( i=0; i<size; i+=1 )
		{
			posA = nodes[ i ].GetWorldPosition();
			
			curr = VecDistanceSquared2D( posA, posB );
			if ( curr < best )
			{
				best = curr;
				bestEnt = (CEntity)nodes[i];
			}
		}
		
		return bestEnt;
	}
	
	public function GetCurrentEffects() : array< CBaseGameplayEffect > 
	{
		var null : array< CBaseGameplayEffect >;
		
		if(effectManager)
			return effectManager.GetCurrentEffects();
		
		return null;
	}
	
	
	public function GetNeedsToReduceFallingDamage( heightDiff : float ) : bool
	{
		return heightDiff >= damageDistanceNotReducing;
	}
	
	
	public function CanReduceFallDamage( heightDiff : float ) : bool
	{
		return heightDiff <= damageDistanceReducing;
	}
	
	
	function ApplyFallingDamage( heightDiff : float, optional reducing : bool ) : float
	{
		var forcedDeath		: bool;
		var action			: W3DamageAction;
		var dmgPerc			: float;
		var damageValue		: float;		
		var deathDistance	: float;
		var damageDistance	: float;
		var fallDamageCap 	: float; 
		
		var totalDamage		: float;
		
		forcedDeath			= !thePlayer.IsAlive();
		
		
		if( reducing )
		{
			deathDistance	= deathDistanceReducing;
			damageDistance	= damageDistanceReducing;
		}
		else
		{
			deathDistance	= deathDistNotReducing;
			damageDistance	= damageDistanceNotReducing;
		}
		
		
		if(IsMonster())
		{
			deathDistance = deathDistanceReducing;
		}
		
		
		
		if( heightDiff > deathDistance || forcedDeath )
		{
			dmgPerc	= 1.0f;	
			PlayEffect( 'heavy_hit' );
			PlayEffect( 'hit_screen' );	
			
			
			totalDamage	= GetMaxHealth();
		}
		
		
		else if( heightDiff < damageDistance )
		{
			return 0.0f;		
		}
		
		
		else
		{
			
			
			if ( GetCharacterStats().HasAbilityWithTag('Boss') || (W3MonsterHuntNPC)this )
			{
				fallDamageCap = 0.23f;
			}
			else
			{
				fallDamageCap = 0.85f;
			}
			
			dmgPerc	= MapF( heightDiff, damageDistance, deathDistance, 0.0f, fallDamageCap );
			
			
			
			if( dmgPerc < 1.0f && dmgPerc >= GetHealthPercents() - fallDamageMinHealthPerc )
			{
				totalDamage	= MaxF( 0.0f, GetHealthPercents() - fallDamageMinHealthPerc ) * GetMaxHealth();
			}
			else
			{			
				totalDamage	= dmgPerc * GetMaxHealth();
			}
		}				
		
		
		action = new W3DamageAction in this;
		action.Initialize(NULL, this, NULL, "FallingDamage", EHRT_None, CPS_Undefined, false, false, false, true);
		action.SetCanPlayHitParticle(false);
		damageValue	= totalDamage;
		action.AddDamage(theGame.params.DAMAGE_NAME_DIRECT, damageValue );
		
		theGame.damageMgr.ProcessAction( action );
		
		delete action;
		
		return dmgPerc;
	}
	
	
	
	
	
		
	event OnContactEvent( position : Vector, force : Vector, otherBody : CComponent, actorIndex : int, shapeIndex : int )
	{
		var mass, velocity, momentum : float;
		var damage : W3DamageAction;
		var damageVal : float;
		var hitReaction : EHitReactionType;
	
		if( this.collisionDamageTimestamp + 1.0 > theGame.GetEngineTimeAsSeconds())
			return false;

		if( otherBody.HasCollisionType('Ragdoll', actorIndex, shapeIndex) || otherBody.HasCollisionType('Weapon', actorIndex, shapeIndex) || otherBody.HasCollisionType('Corpse', actorIndex, shapeIndex) )
		{
			
			return false;
		}
		
		mass = otherBody.GetPhysicalObjectMass( actorIndex );
		velocity = VecLength( otherBody.GetPhysicalObjectLinearVelocity( actorIndex ) );
		momentum = mass * velocity;
		
		
		
		
		
		if( momentum < 50.0 || velocity < 3.5 )
			return false;
	
		
		
		
		hitReaction = EHRT_Light;
		
		
			
		
		
		
		
		
		damage = new W3DamageAction in this;
		damage.Initialize( (CGameplayEntity)( otherBody.GetEntity() ), this, theGame, "physical_object_damage", hitReaction, CPS_Undefined, false, false, false, true );
		damage.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, damageVal );
		theGame.damageMgr.ProcessAction( damage );
		
		this.collisionDamageTimestamp = theGame.GetEngineTimeAsSeconds();
		
		delete damage;
	}

	
	var customCameraStackIndex : int;
	event OnCustomCamera( eventName : name, properties : SMultiValue, animEventType : EAnimationEventType, animInfo : SAnimationEventAnimInfo )
	{		
		var customCameraParams : SCustomCameraParams;
		var player : CR4Player = thePlayer;
	
		if ( properties.enums[0].enumType != 'ECustomCameraType' )
			LogChannel( 'CustomCamera', "ERROR: Selected enum is not a custom camera!!!" );
		else
		{	
			if ( properties.enums[0].enumValue == CCT_None )
			{
				player.DisableCustomCamInStack( customCameraStackIndex );
			}
			else
			{
				customCameraParams.source = this;
				customCameraParams.cameraParams = properties;	
				customCameraParams.useCustomCamera = true;
				player.DisableCustomCamInStack( customCameraStackIndex );
				this.customCameraStackIndex = player.AddCustomCamToStack( customCameraParams );
				SignalGameplayEventParamInt('CameraIndex',customCameraStackIndex);
			}			
		}
	}
	
	event OnFrostHit(source : CGameplayEntity)
	{
		super.OnFrostHit(source);
		
		if((W3WhiteFrost)source)
			RemoveAllBuffsOfType(EET_Burning);
	}
	
	
	
	
	
	public function SetIsSwimming ( toggle : bool )		{ isSwimming = toggle;	}
	public function IsSwimming () : bool				{ return isSwimming;	}
	
	public final function IsDiving() : bool
	{
		if ( !MAC )
			MAC = (CMovingPhysicalAgentComponent)GetMovingAgentComponent();
			
		if(MAC)
			return MAC.IsDiving();
			
		return false;
	}
	
	
	final function GetSwordTipMovementFromAnimation( animation : name, time : float, deltaTime : float, hitWeapon : CItemEntity ) : Vector
	{
		var handBone : name;
		var handBoneIdx : int;
		var boneAtTimeMS : Matrix;
		var boneWithDeltaTimeMS : Matrix;
		var swordTipAtTime : Vector;
		var swordTipWithDeltaTime : Vector;
		var localToWorld : Matrix;
		var weaponSlotMatrixWS : Matrix;
		var handMatrixWS : Matrix;
		
		handBone = 'r_weapon';
		handBoneIdx = GetBoneIndex( handBone );

		
		hitWeapon.CalcEntitySlotMatrix( 'blood_fx_point', weaponSlotMatrixWS );
		handMatrixWS = GetBoneWorldMatrixByIndex( handBoneIdx );

		
		swordTipAtTime = MatrixGetTranslation( weaponSlotMatrixWS );
		swordTipAtTime = VecTransform( MatrixGetInverted( handMatrixWS ), swordTipAtTime );
		swordTipWithDeltaTime = swordTipAtTime;

		GetRootAnimatedComponent().GetBoneMatrixMovementModelSpaceInAnimation( handBoneIdx, animation, time, deltaTime, boneAtTimeMS, boneWithDeltaTimeMS );
		
		swordTipAtTime = VecTransform( boneAtTimeMS, swordTipAtTime );
		swordTipWithDeltaTime = VecTransform( boneWithDeltaTimeMS, swordTipWithDeltaTime );
		
		localToWorld = GetLocalToWorld();
		swordTipAtTime = VecTransform( localToWorld, swordTipAtTime );
		swordTipWithDeltaTime = VecTransform( localToWorld, swordTipWithDeltaTime );

		
		return swordTipWithDeltaTime - swordTipAtTime;
	}


	public function GetLyingDownFacingDirection() : float
	{
		var boneAngles	: EulerAngles;
		var pitch : float;
		boneAngles = MatrixGetRotation( GetBoneWorldMatrixByIndex( this.GetBoneIndex( 'torso3' ) ) );
		pitch = boneAngles.Pitch;
		
		return pitch;
	}
	
	
	function RegisterCollisionEventsListener()
	{
		var physicalComponent : CMovingPhysicalAgentComponent;
		physicalComponent = ((CMovingPhysicalAgentComponent)GetComponentByClassName('CMovingPhysicalAgentComponent'));
		if( physicalComponent )
		{
			physicalComponent.RegisterEventListener( this );
		}
	}
	
	public final function FreezeCloth( frozen : bool )
	{
		var comps : array< CComponent >;
		var cloth : CClothComponent;
		var i : int;
		
		comps = GetComponentsByClassName( 'CClothComponent' );
		for( i=0; i<comps.Size(); i+=1 )
		{
			cloth = ( CClothComponent ) comps[ i ];
			if( cloth )
			{
				cloth.SetFrozen( frozen );
			}
		}
	}
	
	public final function SetClothSimulation( b : bool )
	{
		var comps : array< CComponent >;
		var cloth : CClothComponent;
		var i : int;
		
		comps = GetComponentsByClassName( 'CClothComponent' );
		for( i=0; i<comps.Size(); i+=1 )
		{
			cloth = ( CClothComponent ) comps[ i ];
			if( cloth )
			{
				cloth.SetSimulated( b );
			}
		}
	}
	
	
	
	
	
	event OnRagdollOnGround();

	
	event OnRagdollInAir();

	
	event OnNoLongerInRagdoll();

	
	
	
	
	 event OnProcessActionPost(action : W3DamageAction)
	{
		var actorVictim : CActor;
		var bloodTrailParam : CBloodTrailEffect;
		var attackAction : W3Action_Attack;
		
		actorVictim = (CActor)action.victim;
		attackAction = (W3Action_Attack)action;
		
		
		if( attackAction && action.DealsAnyDamage() && actorVictim)
		{
			bloodTrailParam = (CBloodTrailEffect)actorVictim.GetGameplayEntityParam( 'CBloodTrailEffect' );
			if ( bloodTrailParam )
			{
				GetInventory().PlayItemEffect( attackAction.GetWeaponId(), bloodTrailParam.GetEffectName() );
			}
		}		
	}
	
	event OnHitActionReaction( attacker : CActor, weaponName : name )
	{
		
		if ( attacker.HasAbility( 'mon_cloud_giant' ) && weaponName == 'mon_q704_cloud_giant_ep2_weapon' )
		{
			SoundEvent( "monster_cloud_giant_cmb_weapon_hit_add", 'head' );
		}
		else if ( attacker.HasAbility( 'mon_knight_giant' ) && weaponName == 'mon_q701_giant_ep2_weapon' )
		{
			SoundEvent( "monster_knight_giant_cmb_weapon_hit_add", 'head' );
		}
	}
	
	
	public function GetCriticalHitDamageBonus(weaponId : SItemUniqueId, victimMonsterCategory : EMonsterCategory, isStrikeAtBack : bool) : SAbilityAttributeValue
	{
		return GetAttributeValue(theGame.params.CRITICAL_HIT_DAMAGE_BONUS);
	}
	
	
	public function HasAlternateQuen() : bool
	{
		return false;
	}
	
	public function FinishQuen( skipVisuals : bool, optional forceNoBearSetBonus : bool );
	
	public function UpdateStatsForDifficultyLevel(d : EDifficultyMode)
	{
		if(abilityManager && abilityManager.IsInitialized() && IsAlive())
			abilityManager.UpdateStatsForDifficultyLevel(d);
	}
	
	public function GetLevel() : int
	{
		return -1;
	}
	
	public function TestIsInSettlement() : bool
	{
		var ents : array<CEntity>;
		var trigger : CTriggerAreaComponent;
		var i : int;
		
		theGame.GetEntitiesByTag('settlement', ents);
		
		for(i=0; i<ents.Size(); i+=1)
		{
			trigger = (CTriggerAreaComponent)(ents[i].GetComponentByClassName('CTriggerAreaComponent'));
			if(trigger.TestEntityOverlap(this))
				return true;
		}
		
		return false;
	}
	
	event OnSpawnedEditor( spawnData : SEntitySpawnData )
	{
		var resource : CEntityTemplate;
		var resourceKey, itemName : name;
		var ent : CEntity;
		var i : int;
		var items, ids : array<SItemUniqueId>;
		var inv, geraltInv : CInventoryComponent;
		var definition : EPlayerPreviewInventory;
		
		
		
		buffImmunities.Clear();
		
		
		if ( this.GetVoicetag() != 'GERALT' )
		{
			return true;
		}
		
		definition = theGame.GetGameplayConfigEnumValue('playerPreviewInventory');
		
		
		switch(definition)
		{			
			case PPI_Bear_1 :
				resourceKey = 'preview_inventory_bear_1';
				break;
			case PPI_Bear_4 :
				resourceKey = 'preview_inventory_bear_4';
				break;
			case PPI_Lynx_1 :
				resourceKey = 'preview_inventory_lynx_1';
				break;
			case PPI_Lynx_4 :
				resourceKey = 'preview_inventory_lynx_4';
				break;
			case PPI_Gryphon_1 :
				resourceKey = 'preview_inventory_gryphon_1';
				break;
			case PPI_Gryphon_4 :
				resourceKey = 'preview_inventory_gryphon_4';
				break;
			case PPI_Common_1 :
				resourceKey = 'preview_inventory_common_1';
				break;
			case PPI_Naked :
				resourceKey = 'preview_inventory_naked';
				break;
			case PPI_Viper :
				resourceKey = 'preview_inventory_viper';
				break;
			case PPI_Red_Wolf_1 :
				resourceKey = 'preview_inventory_red_wolf_1';
				break;
				
			case PPI_default :
			default :
				resourceKey = 'preview_inventory_default';
				break;
		}
		
		resource = (CEntityTemplate)LoadResource(resourceKey);
		geraltInv = GetInventory();
		geraltInv.InitInvFromTemplate( resource );
	}
	
	event OnCutsceneDeath()
	{
		Kill( 'Quest', true );
	}
	
	
	
	
	
	public function ActivateEthereal( optional fromHit : bool )
	{
		AddAbility( 'EtherealActivating' );
		
		if( fromHit )
		{
			
			AddTimer( 'ActivateEtherealDelayed', 0.0 );
		}
		else
		{	
			
			SetBehaviorVariable( 'wakeUpType', 1.0 );
			AddTimer( 'ActivateEtherealDelayed', 2.15 ); 
			
			
		}
	}
	
	timer function ActivateEtherealDelayed( td : float, id : int )
	{
		AddAbility( 'EtherealActive' );
		RemoveBuffImmunity( EET_Stagger );
		RemoveBuffImmunity( EET_LongStagger );
	}
	
	private function ManageEtherealSkillsAndFXes()
	{
		var skills : array<name>;
		var actors : array<CGameplayEntity>;
		var i, j : int;
		
		skills.PushBack( 'EtherealSkill_1' );
		skills.PushBack( 'EtherealSkill_2' );
		skills.PushBack( 'EtherealSkill_3' );
		skills.PushBack( 'EtherealSkill_4' );
		skills.PushBack( 'EtherealSkill_5' );
		
		actors.Clear();
		FindGameplayEntitiesInRange( actors, this, 100, 10, 'ethereal', FLAG_OnlyAliveActors );
		thePlayer.IncrementEtherealCount();

		for( i = 0; i < actors.Size(); i += 1 )
		{
			actors[i].PlayEffect( 'ethereal_buff' );
				
			if( !actors[i].HasAbility( 'EtherealActive' ) )
			{
				actors[i].AddAbility( 'EtherealBuff' );
			}
			
			for( j = 0; j < thePlayer.GetEtherealCount(); j += 1 )
			{
				actors[i].AddAbility( skills[j] );
				
				if( j == 3 )
				{
					((CNewNPC)actors[i]).RaiseGuard();
					actors[i].AddAbility( 'EtherealMashingFix' );
				}
				else if( j == 4 )
				{
					actors[i].SetBehaviorVariable( 'hasSkill_5', 1.0 );
				}
			}
		}
	}

	public function ShouldAttachArrowToPlayer( action : W3DamageAction )
	{
		var arrow : W3ArrowProjectile;
		
		if( action.victim == thePlayer )
		{
			if( (W3ArrowProjectile)action.causer )
			{
				if( action.processedDmg.vitalityDamage == 0 )
				{
					arrow = (W3ArrowProjectile)action.causer;
					arrow.SetShouldBeAttachedToVictim( false );
				}
			}
		}
	}
	
	
	
	
	
	
	private final function CacheHudModuleHealFloater(heal : float)
	{
		cachedHeal += heal;
		
		if(!hudModuleHealScheduledUpdate)
		{
			hudModuleHealScheduledUpdate = true;
			AddTimer('HudModuleHealUpdate', 1.0f);
		}
	}
	var cachedHeal : float;
	var hudModuleHealScheduledUpdate : bool;
	
	timer function HudModuleHealUpdate(dt : float, id : int)
	{
		if(cachedHeal >= 1.0f)
		{
			ShowFloatingValue(EFVT_Heal, cachedHeal, false);
			cachedHeal = 0.f;
		}	
		
		hudModuleHealScheduledUpdate = false;
	}
	
	
	private final function CacheHudModuleDoTDamageFloater(dmg : float)
	{
		cachedDoTDamage += dmg;
		
		if(!hudModuleDoTScheduledUpdate)
		{
			hudModuleDoTScheduledUpdate = true;
			AddTimer('HudModuleDoTUpdate', 1.0f);
		}
	}
	var cachedDoTDamage : float;
	var hudModuleDoTScheduledUpdate : bool;
	
	timer function HudModuleDoTUpdate(dt : float, id : int)
	{
		if(cachedDoTDamage >= 1.0f)
		{
			ShowFloatingValue(EFVT_DoT, cachedDoTDamage, false);
			cachedDoTDamage = 0.f;
		}	
		
		hudModuleDoTScheduledUpdate = false;
	}
	
	public function ShowFloatingValue(type : EFloatingValueType, value : float, cache : bool, optional stringParam : string)
	{
		var hud : CR4ScriptedHud;
		var module : CR4HudModuleEnemyFocus;
		
		if(type == EFVT_Heal && cache)
		{
			CacheHudModuleHealFloater(value);
		}
		else if(type == EFVT_DoT && cache)
		{
			CacheHudModuleDoTDamageFloater(value);
		}
		else if(thePlayer.GetTarget() == this)
		{
			hud = (CR4ScriptedHud)theGame.GetHud();
			if(hud)
			{
				module = (CR4HudModuleEnemyFocus)hud.GetHudModule("EnemyFocusModule");
				if(module)
				{
					module.ShowDamageType(type, value, stringParam);
				}
			}
		}
	}
	
	public function IsHuge() : bool
	{
		return HasAbility( 'mon_type_huge' );
	}
	
	public function CreateFXEntityAtPelvis( resourceName : name, attach : bool ) : CEntity
	{
		var boneName : name;
		var boneIndex : int;
		
		boneName = 'pelvis';
		boneIndex = GetBoneIndex( boneName );		
		if( boneIndex == -1 )
		{
			boneName = 'k_pelvis_g';
		}
		
		return CreateFXEntityAtBone( resourceName, boneName, attach );
	}
	
	public function CreateFXEntityAtBone( resourceName : name, boneName : name, attach : bool ) : CEntity
	{
		var template : CEntityTemplate;
		var boneRotation : EulerAngles;
		var bonePosition : Vector;
		var boneIndex : int;
		var fxEnt : CEntity;
		
		
		boneIndex = GetBoneIndex( boneName );		
		if( boneIndex == -1 )
		{
			return fxEnt;
		}
		
		
		template = (CEntityTemplate)LoadResource( resourceName );		
		if( !template )
		{
			return fxEnt;
		}
		
		GetBoneWorldPositionAndRotationByIndex( boneIndex, bonePosition, boneRotation );
		fxEnt = theGame.CreateEntity( template, bonePosition, boneRotation );
		
		if( attach )
		{
			fxEnt.CreateAttachmentAtBoneWS( this, boneName, bonePosition, boneRotation );
		}
		
		return fxEnt;
	}
	
	
	
	
	
	
	
	public function OnSignCastPerformed(signType : ESignType, isAlternate : bool)
	{
		
	}
	
	timer function Runeword1DisableFireFX(dt : float, id : int)
	{
		
		if(IsEffectActive('critical_burning') && !HasBuff(EET_Burning))
			StopEffect('critical_burning');
	}
	
	
	
	
	
	public function Debug_GetUsedDifficultyMode() : EDifficultyMode
	{
		if(abilityManager && abilityManager.IsInitialized())
			return abilityManager.Debug_GetUsedDifficultyMode();
			
		return EDM_NotSet;
	}
	
	private function HACK_ManageEtherealSkills()
	{
		var ents : array<CGameplayEntity>;
		var i : int;
		var abilityName : name;
		
		ents.Clear();
		FindGameplayEntitiesInRange(ents, thePlayer, 50, 10, 'etherealTest', FLAG_Attitude_Hostile + FLAG_OnlyAliveActors ); 
		
		((CActor)ents[0]).ActivateEthereal();
	}
}

import function CPPForceActorLOD( enable : bool, optional LODIndex : int );
exec function ForceActorLOD( enable : bool, optional LODIndex : int )
{
	CPPForceActorLOD( enable, LODIndex );
}
