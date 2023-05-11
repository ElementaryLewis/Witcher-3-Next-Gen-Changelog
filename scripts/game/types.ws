/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/



enum EActorImmortalityMode
{
	AIM_None,
	AIM_Immortal,				
	AIM_Invulnerable,			
	AIM_Unconscious				
}

enum EActorImmortalityChanel
{
	
	AIC_Default = 1,
	AIC_Combat = 2,
	AIC_Scene = 4,
	AIC_Mutation11 = 8,
	AIC_Fistfight = 16,
	AIC_SyncedAnim = 32,
	AIC_WhiteRaffardsPotion = 64,
	AIC_IsAttackableByPlayer = 128
	
}










enum ETerrainType
{
	TT_Normal,
	TT_Rough,
	TT_Swamp,
	TT_Water
}





enum EZoneName
{
	ZN_Undefined,
	ZN_NML_CrowPerch,
	ZN_NML_SpitfireBluff,
	ZN_NML_TheMire,
	ZN_NML_Mudplough,
	ZN_NML_Grayrocks,
	ZN_NML_TheDescent,
	ZN_NML_CrookbackBog,
	ZN_NML_BaldMountain,
	ZN_NML_Novigrad,
	ZN_NML_Homestead,
	ZN_NML_Gustfields,
	ZN_NML_Oxenfurt,
	
}

function ZoneNameToType( lName : name ) : EZoneName
{
	switch( lName )
	{
		case 'CrowPerch':
			return 	ZN_NML_CrowPerch;
		case 'SpitfireBluff':
			return 	ZN_NML_SpitfireBluff;
		case 'TheMire':
			return 	ZN_NML_TheMire;
		case 'Mudplough':
			return 	ZN_NML_Mudplough;
		case 'Grayrocks':
			return 	ZN_NML_Grayrocks;
		case 'TheDescent':
			return 	ZN_NML_TheDescent;
		case 'CrookbackBog':
			return 	ZN_NML_CrookbackBog;
		case 'BaldMountain':
			return 	ZN_NML_BaldMountain;
		case 'Novigrad':
			return 	ZN_NML_Novigrad;
		case 'Homestead':
			return 	ZN_NML_Homestead;
		case 'Gustfields':
			return 	ZN_NML_Gustfields;
		case 'Oxenfurt':
			return 	ZN_NML_Oxenfurt;
		default:
			return 	ZN_Undefined;
	}
}
	
function ZoneTypeToName( type : EZoneName ) : name
{
	switch( type )
	{
		case ZN_NML_CrowPerch:
			return 	'CrowPerch';
		case ZN_NML_SpitfireBluff:
			return 	'SpitfireBluff';
		case ZN_NML_TheMire:
			return 	'TheMire';
		case ZN_NML_Mudplough:
			return 	'Mudplough';
		case ZN_NML_Grayrocks:
			return 	'Grayrocks';
		case ZN_NML_TheDescent:
			return 	'TheDescent';
		case ZN_NML_CrookbackBog:
			return 	'CrookbackBog';
		case ZN_NML_BaldMountain:
			return 	'BaldMountain';
		case ZN_NML_Novigrad:
			return 	'Novigrad';
		case ZN_NML_Homestead:
			return 	'Homestead';
		case ZN_NML_Gustfields:
			return 	'Gustfields';
		case ZN_NML_Oxenfurt:
			return 	'Oxenfurt';
		default:
			return 	'';
	}
}







function MinDiffMode(a, b : EDifficultyMode) : EDifficultyMode
{
	if(a == EDM_NotSet)
		return b;
	else if(b == EDM_NotSet)
		return a;
	else
		return Min( (int)a, (int)b );
	
	

}


function GetDifficultyTagForMode(d : EDifficultyMode) : name
{
	switch(d)
	{
		case EDM_Easy : 		return theGame.params.DIFFICULTY_TAG_EASY;
		case EDM_Medium : 		return theGame.params.DIFFICULTY_TAG_MEDIUM;
		case EDM_Hard : 		return theGame.params.DIFFICULTY_TAG_HARD;
		case EDM_Hardcore : 	return theGame.params.DIFFICULTY_TAG_HARDCORE;
		default : 				return '';
	}
}








struct SCombatParams
{
	var goalId : int;



};

struct SAttackEventData
{
	var animData : CPreAttackEventData;
	var weaponId : SItemUniqueId;				
	var parriedBy : array<CActor>;				
};

enum EHitReactionType
{
	EHRT_None,
	EHRT_Light,
	EHRT_Heavy,
	EHRT_Igni,
	EHRT_Reflect,
	EHRT_LightClose
}

function ModifyHitSeverityReaction(target : CActor, type : EHitReactionType) : EHitReactionType
{
	var severityReduction, severity : int;

	severityReduction = RoundMath(CalculateAttributeValue(target.GetAttributeValue('hit_severity')));
	if(severityReduction == 0 || type == EHRT_Igni)
		return type;
		
	
	switch(type)
	{
		case EHRT_Heavy :
			severity = 2;
			break;
		case EHRT_Light :
		case EHRT_LightClose :
			severity = 1; 
			break;
		default :
			severity = 0;
			break;
	}
	
	
	severity -= severityReduction;
	
	
	switch(severity)
	{
		case 2:		return EHRT_Heavy;
		case 1:		return EHRT_Light;
		default :	return EHRT_None;
	}
}



enum EFocusHitReaction
{
	EFHR_None,
	EFHR_Type1,
	EFHR_Type2,
	EFHR_Type3,
	EFHR_Type4,
	EFHR_Type5
}

enum EAttackSwingType
{
	AST_Horizontal,
	AST_Vertical,
	AST_DiagonalUp,
	AST_DiagonalDown,
	AST_Jab,
	AST_NotSet
}

enum EAttackSwingDirection
{
	ASD_UpDown,
	ASD_DownUp,
	ASD_LeftRight,
	ASD_RightLeft,
	ASD_NotSet
}

enum EManageGravity
{
	EMG_DisableGravity,
	EMG_EnableGravity,
	EMG_SwitchGravity
}

enum ECounterAttackSwitch
{
	CAS_Disabled,
	CAS_Enabled
}

import struct CPreAttackEventData
{
    import var attackName           : name;                    		   
    import var weaponSlot           : name;              			   
    import var hitReactionType    	: int; 
    import var swingDir            	: int; 
    import var swingType            : int; 
	import var rangeName			: name;							   
	import var hitFX				: name;			
	import var hitBackFX			: name;			
	import var hitParriedFX			: name;			
	import var hitBackParriedFX		: name;			
	import var Damage_Friendly : bool;				
	import var Damage_Neutral : bool;				
	import var Damage_Hostile : bool;				
	import var Can_Parry_Attack : bool;				
	import var canBeDodged : bool;					
	
	import var soundAttackType 		: name;			
};



enum EAttitudeGroupPriority
{
	AGP_Default,
	AGP_SpawnTree,
	AGP_Axii,
	AGP_Fistfight,
	AGP_Scenes
}

function IsBasicAttack(attackName : name) : bool
{
	switch(attackName)
	{
		case theGame.params.ATTACK_NAME_LIGHT: 
		case theGame.params.ATTACK_NAME_HEAVY:
		case theGame.params.ATTACK_NAME_SUPERHEAVY:
		case theGame.params.ATTACK_NAME_SPEED_BASED:
			return true;
		default : 
			return false;
	}
}

enum ETimescaleSource
{
	ETS_None,
	ETS_PotionBlizzard,
	ETS_SlowMoTask,
	ETS_HeavyAttack,
	ETS_ThrowingAim,
	ETS_RadialMenu,
	ETS_CFM_PlayAnim,
	ETS_CFM_On,
	ETS_DebugInput,
	ETS_SkillFrenzy,
	ETS_RaceSlowMo,
	ETS_HorseMelee,
	ETS_FinisherInput,
	ETS_TutorialFight,
	ETS_InstantKill
}


struct STimescaleSource
{
	var sourceName : name;
	var sourceType : ETimescaleSource;
	var sourcePriority : int;			
};


struct SDroppedItem
{
	var entity : CEntity;
	var itemName : name;
};


enum EMonsterCategory
{
	MC_NotSet,
	MC_Relic,
	MC_Necrophage,
	MC_Cursed,
	MC_Beast,
	MC_Insectoid,
	MC_Vampire,
	MC_Specter,
	MC_Draconide,
	MC_Hybrid,
	MC_Troll,
	MC_Human,
MC_Unused,
	MC_Magicals,
	MC_Animal
}





function MonsterCategoryIsMonster(type : EMonsterCategory) : bool
{
	if( type == MC_NotSet || type == MC_Unused || type == MC_Human || type == MC_Animal || type == MC_Beast )
		return false;
	
	return true;
}


function MonsterCategoryToAttackPowerBonus(type : EMonsterCategory) : name
{
	switch(type)
	{
		case MC_Beast :				return 'vsBeast_attack_power';
		case MC_Cursed :			return 'vsCursed_attack_power';
		case MC_Draconide :			return 'vsDraconide_attack_power';
		case MC_Human :				return 'vsHuman_attack_power';
		case MC_Hybrid :			return 'vsHybrid_attack_power';
		case MC_Insectoid :			return 'vsInsectoid_attack_power';
		case MC_Magicals :			return 'vsMagicals_attack_power';
		case MC_Necrophage :		return 'vsNecrophage_attack_power';
		case MC_Relic :				return 'vsRelic_attack_power';
		case MC_Specter :			return 'vsSpecter_attack_power';
		case MC_Troll :				return 'vsOgre_attack_power';
		case MC_Vampire :			return 'vsVampire_attack_power';
		
		default :				return '';
	}
}
function MonsterAttackPowerBonusToCategory( ap : name ) : EMonsterCategory
{
	switch(ap)
	{
		case 'vsBeast_attack_power': 		return MC_Beast;
		case 'vsCursed_attack_power': 		return MC_Cursed;
		case 'vsDraconide_attack_power': 	return MC_Draconide;
		case 'vsHuman_attack_power': 		return MC_Human;
		case 'vsHybrid_attack_power': 		return MC_Hybrid;
		case 'vsInsectoid_attack_power': 	return MC_Insectoid;
		case 'vsMagicals_attack_power': 	return MC_Magicals;
		case 'vsNecrophage_attack_power': 	return MC_Necrophage;
		case 'vsRelic_attack_power': 		return MC_Relic;
		case 'vsSpecter_attack_power':		return MC_Specter;
		case 'vsOgre_attack_power': 		return MC_Troll;
		case 'vsVampire_attack_power': 		return MC_Vampire;
		
		default :							return MC_NotSet;
	}
}
function MonsterCategoryToCriticalChanceBonus(type : EMonsterCategory) : name
{
	switch(type)
	{
		case MC_Beast :				return 'vsBeast_critical_hit_chance';
		case MC_Cursed :			return 'vsCursed_critical_hit_chance';
		case MC_Draconide :			return 'vsDraconide_critical_hit_chance';
		case MC_Human :				return 'vsHuman_critical_hit_chance';
		case MC_Hybrid :			return 'vsHybrid_critical_hit_chance';
		case MC_Insectoid :			return 'vsInsectoid_critical_hit_chance';
		case MC_Magicals :			return 'vsMagicals_critical_hit_chance';
		case MC_Necrophage :		return 'vsNecrophage_critical_hit_chance';
		case MC_Relic :				return 'vsRelic_critical_hit_chance';
		case MC_Specter :			return 'vsSpecter_critical_hit_chance';
		case MC_Troll :				return 'vsTroll_critical_hit_chance';
		case MC_Vampire :			return 'vsVampire_critical_hit_chance';
		
		default :				return '';
	}
}
function MonsterCategoryToCriticalDamageBonus(type : EMonsterCategory) : name
{
	switch(type)
	{
		case MC_Beast :				return 'vsBeast_critical_hit_damage_bonus';
		case MC_Cursed :			return 'vsCursed_critical_hit_damage_bonus';
		case MC_Draconide :			return 'vsDraconide_critical_hit_damage_bonus';
		case MC_Human :				return 'vsHuman_critical_hit_damage_bonus';
		case MC_Hybrid :			return 'vsHybrid_critical_hit_damage_bonus';
		case MC_Insectoid :			return 'vsInsectoid_critical_hit_damage_bonus';
		case MC_Magicals :			return 'vsMagicals_critical_hit_damage_bonus';
		case MC_Necrophage :		return 'vsNecrophage_critical_hit_damage_bonus';
		case MC_Relic :				return 'vsRelic_critical_hit_damage_bonus';
		case MC_Specter :			return 'vsSpecter_critical_hit_damage_bonus';
		case MC_Troll :				return 'vsTroll_critical_hit_damage_bonus';
		case MC_Vampire :			return 'vsVampire_critical_hit_damage_bonus';
		
		default :				return '';
	}
}
function MonsterCategoryToResistReduction(type : EMonsterCategory) : name
{
	switch(type)
	{
		case MC_Beast :				return 'vsBeast_resist_reduction';
		case MC_Cursed :			return 'vsCursed_resist_reduction';
		case MC_Draconide :			return 'vsDraconide_resist_reduction';
		case MC_Human :				return 'vsHuman_resist_reduction';
		case MC_Hybrid :			return 'vsHybrid_resist_reduction';
		case MC_Insectoid :			return 'vsInsectoid_resist_reduction';
		case MC_Magicals :			return 'vsMagicals_resist_reduction';
		case MC_Necrophage :		return 'vsNecrophage_resist_reduction';
		case MC_Relic :				return 'vsRelic_resist_reduction';
		case MC_Specter :			return 'vsSpecter_resist_reduction';
		case MC_Troll :				return 'vsTroll_resist_reduction';
		case MC_Vampire :			return 'vsVampire_resist_reduction';
		
		default :				return '';
	}
}

function MonsterCategoryToOilNames(monsterCategory : EMonsterCategory) : array<name>
{
	var oils : array<name>;
	
	switch(monsterCategory)
	{
		case MC_Beast:
			oils.PushBack('Beast Oil 3');
			oils.PushBack('Beast Oil 2');
			oils.PushBack('Beast Oil 1');
			return oils;
		case MC_Cursed:
			oils.PushBack('Cursed Oil 3');
			oils.PushBack('Cursed Oil 2');
			oils.PushBack('Cursed Oil 1');
			return oils;
		case MC_Draconide:
			oils.PushBack('Draconide Oil 3');
			oils.PushBack('Draconide Oil 2');
			oils.PushBack('Draconide Oil 1');
			return oils;
		case MC_Human:
			oils.PushBack('Hanged Man Venom 3');
			oils.PushBack('Hanged Man Venom 2');
			oils.PushBack('Hanged Man Venom 1');
			return oils;
		case MC_Hybrid:
			oils.PushBack('Hybrid Oil 3');
			oils.PushBack('Hybrid Oil 2');
			oils.PushBack('Hybrid Oil 1');
			return oils;
		case MC_Insectoid:
			oils.PushBack('Insectoid Oil 3');
			oils.PushBack('Insectoid Oil 2');
			oils.PushBack('Insectoid Oil 1');
			return oils;
		case MC_Magicals:
			oils.PushBack('Magicals Oil 3');
			oils.PushBack('Magicals Oil 2');
			oils.PushBack('Magicals Oil 1');
			return oils;			
		case MC_Necrophage:
			oils.PushBack('Necrophage Oil 3');
			oils.PushBack('Necrophage Oil 2');
			oils.PushBack('Necrophage Oil 1');
			return oils;	
		case MC_Troll:
			oils.PushBack('Ogre Oil 3');
			oils.PushBack('Ogre Oil 2');
			oils.PushBack('Ogre Oil 1');
			return oils;	
		case MC_Relic:
			oils.PushBack('Relic Oil 3');
			oils.PushBack('Relic Oil 2');
			oils.PushBack('Relic Oil 1');
			return oils;	
		case MC_Specter:
			oils.PushBack('Specter Oil 3');
			oils.PushBack('Specter Oil 2');
			oils.PushBack('Specter Oil 1');
			return oils;	
		case MC_Vampire:
			oils.PushBack('Vampire Oil 3');
			oils.PushBack('Vampire Oil 2');
			oils.PushBack('Vampire Oil 1');
			return oils;				
		
		default : return oils;
	}
}



struct SAttributeTooltip
{
	var originName	  : name;
	var attributeName : string;		
	var attributeColor: string;		
	var value : float;
	var percentageValue : bool;
	var primaryStat : bool; 
	default percentageValue = false;
};


struct SNotWorkingOutFunctionParametersHackStruct1
{
	var outValue : int;				
	var retValue : bool;			
};


enum EButtonStage
{
	BS_Released,
	BS_Pressed,
	BS_Hold,
}

import struct SAbilityAttributeValue
{
	import saved var valueAdditive : float;
	import saved var valueMultiplicative : float;
	import saved var valueBase : float;
}


function CalculateAttributeValue(att : SAbilityAttributeValue, optional disallowNegativeMult : bool) : float
{
	
	if(disallowNegativeMult && att.valueMultiplicative < 0)
		att.valueMultiplicative = 0.001;
		
	return att.valueBase * att.valueMultiplicative + att.valueAdditive;
}


function GetAttributeRandomizedValue(min, max : SAbilityAttributeValue) : SAbilityAttributeValue
{
	var ret : SAbilityAttributeValue;
	
	ret.valueBase = RandRangeF(max.valueBase, min.valueBase);
	ret.valueAdditive = RandRangeF(max.valueAdditive, min.valueAdditive);
	ret.valueMultiplicative = RandRangeF(max.valueMultiplicative, min.valueMultiplicative);
	
	return ret;
}


enum EStaminaActionType
{
	ESAT_Undefined,
	ESAT_LightAttack,
	ESAT_HeavyAttack,
	ESAT_SuperHeavyAttack,
	ESAT_Parry,
	ESAT_Counterattack,
	ESAT_Dodge,
	ESAT_Evade,
	ESAT_Swimming,
	ESAT_Sprint,
	ESAT_Jump,
	ESAT_UsableItem,
	ESAT_Ability,
	ESAT_FixedValue,
	ESAT_Roll,
	ESAT_LightSpecial,
	ESAT_HeavySpecial,
}

function StaminaActionTypeToName(action : EStaminaActionType) : name
{
	if(action == ESAT_LightAttack)				return 'LightAttack';
	else if(action == ESAT_HeavyAttack)			return 'HeavyAttack';
	else if(action == ESAT_SuperHeavyAttack)	return 'SuperHeavyAttack';
	else if(action == ESAT_Parry)				return 'Parry';
	else if(action == ESAT_Counterattack)		return 'Counterattack';
	else if(action == ESAT_Dodge)				return 'Dodge';
	else if(action == ESAT_Evade)				return 'Evade';
	else if(action == ESAT_Swimming)			return 'Swimming';
	else if(action == ESAT_Sprint)				return 'Sprint';
	else if(action == ESAT_Jump)				return 'Jump';
	else if(action == ESAT_UsableItem)			return 'UsableItem';
	else if(action == ESAT_Ability)				return 'Ability';
	else if(action == ESAT_FixedValue)			return 'FixedValue';
	else if(action == ESAT_Roll)				return 'Roll';
	else 										return '';
}

enum EFocusModeSoundEffectType
{
	FMSET_Gray, 
	FMSET_Red,
	FMSET_Green,
	FMSET_None,
}




struct SStatistic
{
	var statType : EStatistic;
	var registeredAchievements : array<SAchievement>;
};

enum EStatistic
{
	ES_Undefined,

	ES_BleedingBurnedPoisoned,				
	ES_FinesseKills,						
	ES_CharmedNPCKills,						
	ES_AardFallKills,						
	ES_EnvironmentKills,					
	ES_CounterattackChain,					
	ES_DragonsDreamTriggers,				
	ES_FundamentalsFirstKills,				
	ES_DestroyedNests,						
	ES_KnownPotionRecipes,					
	ES_KnownBombRecipes,					
	ES_ReadBooks,							
	ES_HeadShotKills,						
	ES_SelfArrowKills,						
	ES_ActivePotions,						
	ES_KilledCows,							
	ES_SlideTime							
}

function StatisticEnumToName(s : EStatistic) : name
{
	switch(s)
	{
		case ES_CharmedNPCKills:				return 'statistic_charmed_kills';
		case ES_AardFallKills:					return 'statistic_aardfall_kills';
		case ES_EnvironmentKills:				return 'statistic_environment_kills';
		case ES_BleedingBurnedPoisoned:			return 'statistic_bleed_burn_poison';
		case ES_CounterattackChain:				return 'statistic_counterattack_chain';
		case ES_DragonsDreamTriggers:			return 'statistic_burning_gas_triggers';
		case ES_KnownPotionRecipes:				return 'statistic_known_potions';
		case ES_KnownBombRecipes:				return 'statistic_known_bombs';
		case ES_ReadBooks:						return 'statistic_read_books';
		case ES_HeadShotKills:					return 'statistic_head_shot_kills';
		case ES_DestroyedNests:					return 'statistic_destroyed_nests';
		case ES_FundamentalsFirstKills:			return 'statistic_fundamentals_kills';
		case ES_FinesseKills:					return 'statistic_finesse_kills';
		case ES_SelfArrowKills:					return 'statistic_self_arrow_kills';
		case ES_ActivePotions:					return 'statistic_active_potions';
		case ES_KilledCows:						return 'statistic_killed_cows';
		case ES_SlideTime:						return 'statistic_slide_time';
		
		default:								return '';
	}
}

function StatisticNameToEnum(f : name) : EStatistic
{
	switch(f)
	{
		case 'statistic_charmed_kills':				return ES_CharmedNPCKills;
		case 'statistic_aardfall_kills':			return ES_AardFallKills;
		case 'statistic_environment_kills':			return ES_EnvironmentKills;
		case 'statistic_bleed_burn_poison':			return ES_BleedingBurnedPoisoned;
		case 'statistic_counterattack_chain':		return ES_CounterattackChain;
		case 'statistic_burning_gas_triggers':		return ES_DragonsDreamTriggers;
		case 'statistic_known_potions':				return ES_KnownPotionRecipes;
		case 'statistic_known_bombs':				return ES_KnownBombRecipes;
		case 'statistic_head_shot_kills':			return ES_HeadShotKills;
		case 'statistic_read_books':				return ES_ReadBooks;
		case 'statistic_destroyed_nests' :			return ES_DestroyedNests;
		case 'statistic_fundamentals_kills' : 		return ES_FundamentalsFirstKills;
		case 'statistic_finesse_kills' :			return ES_FinesseKills;
		case 'statistic_self_arrow_kills' : 		return ES_SelfArrowKills;
		case 'statistic_active_potions' :			return ES_ActivePotions;
		case 'statistic_killed_cows' :				return ES_KilledCows;
		case 'statistic_slide_time' : 				return ES_SlideTime;
		
		default:									return ES_Undefined;
	}
}


function GetBookReadFactName( bookName : name ) : string
{
	var bookFactName : string;
	bookFactName = "BookReadState_" + bookName;
	bookFactName = StrReplace( bookFactName, " ", "_" );
	return bookFactName;
}

struct SCachedCombatMessage
{
	var finalIncomingDamage : float;
	var resistPoints : float;
	var resistPercents : float;
	var finalDamage : float;
	var attacker : CGameplayEntity;
	var victim : CGameplayEntity;
};


struct SAchievement
{
	var type : EAchievement;
	var requiredValue : float;						
};

enum EAchievement
{
	EA_Undefined,
	
	
	EA_FoundYennefer,
	EA_FreedDandelion,
	EA_YenGetInfoAboutCiri,
	EA_FindBaronsFamily,
	EA_FindCiri,
	EA_ConvinceGeelsToBetrayEredin,
	EA_DefeatEredin,
	EA_FinishTheGameEasy,
	EA_FinishTheGameNormal,
	EA_FinishTheGameHard,
	EA_CompleteWitcherContracts,
	EA_CompleteSkelligeRaceForCrown,
	EA_CompleteWar,
	EA_CompleteKeiraMetz,
	EA_GetAllForKaerMorhenBattle,
	
	
	EA_Dendrology,									
	EA_EnemyOfMyFriend,								
	EA_FusSthSth,									
	EA_EnvironmentUnfriendly,						
	EA_TrainedInKaerMorhen,							
	EA_TheEvilestThing,								
	EA_TechnoProgress,								
	EA_LearningTheRopes,							
	EA_FundamentalsFirst,							
	EA_TrialOfGrasses,								
	EA_BreakingBad,									
	EA_Bombardier,									
	EA_Swank,										
	EA_Rage,										
	
	
	EA_GwintMaster,									
EA_Unused,
	EA_MonsterHuntFogling,							
	EA_MonsterHuntEkimma,							
	EA_MonsterHuntLamia,							
	EA_MonsterHuntFiend,							
	EA_MonsterHuntDao,								
	EA_MonsterHuntDoppler,							
	EA_BrawlMaster,									
	EA_NeedForSpeed,								
	EA_Brawler,										
	
	
	EA_Finesse,										
	EA_PowerOverwhelming,							
	EA_Cerberus,									
	EA_Bookworm,									
	EA_Immortal,									
	EA_FistOfTheSouthStar,							
	EA_Explorer,									
	EA_PestControl,									
	EA_FireInTheHole,								
	EA_FullyArmed,									
	EA_GwintCollector,								
	EA_Allin,										
	EA_GeraltandFriends,							
	
	
	
	EA_ToadPrince,									
	EA_PartyAnimal,									
	EA_Auctioneer,									
	EA_TheCompletePicture,							
	EA_HeartsOfStone,								
	EA_KillEtherals,								
	
	
	EA_FeatherStrongerThanSword,					
	EA_Thirst,										
	EA_DivineWhip,									
	EA_LatestFashion,								
	EA_WantedDeadOrBovine,							
	EA_Slide,										
	EA_KilledIt,									
	
	
	EA_BeauclairWelcomeTo,							
	EA_HeroOfBeauclair,								
	EA_BeauclairMostWanted,							
	EA_ChampionOfBeauclair,							
	EA_LikeAVirgin,									
	EA_HomeSweetHome,								
	EA_TurnedEveryStone,							
	EA_GotToHaveThemAll,							
	EA_BloodAndWine,								
	EA_ReadyToRoll,									
	EA_SchoolOfTheMutant,							
	EA_HastaLaVista,								
	EA_Goliath										
}


function AchievementNameToEnum(n : name) : EAchievement
{
	switch(n)
	{
		
		case 'FoundYennefer' :						return EA_FoundYennefer;
		case 'FreedDandelion' :						return EA_FreedDandelion;
		case 'YenGetInfoAboutCiri' :				return EA_YenGetInfoAboutCiri;
		case 'FindBaronsFamily' :					return EA_FindBaronsFamily;
		case 'FindCiri' :							return EA_FindCiri;
		case 'ConvinceGeelsToBetrayEredin' :		return EA_ConvinceGeelsToBetrayEredin;
		case 'DefeatEredin' :						return EA_DefeatEredin;
		case 'FinishTheGameEasy' :					return EA_FinishTheGameEasy;
		case 'FinishTheGameMedium' :				return EA_FinishTheGameNormal;
		case 'FinishTheGameHard' :					return EA_FinishTheGameHard;
		case 'CompleteWitcherContracts' :			return EA_CompleteWitcherContracts;
		case 'CompleteSkelligeRaceForCrown' :		return EA_CompleteSkelligeRaceForCrown;
		case 'CompleteWar' :						return EA_CompleteWar;
		case 'CompleteKeiraMetz' :					return EA_CompleteKeiraMetz;
		case 'GetAllForKaerMorhenBattle' :			return EA_GetAllForKaerMorhenBattle;
		case 'GwintOpponentsDefeated' :				return EA_GwintMaster;
		case 'MonsterHuntFogling' :					return EA_MonsterHuntFogling;
		case 'MonsterHuntEkimma' :					return EA_MonsterHuntEkimma;
		case 'MonsterHuntLamia' :					return EA_MonsterHuntLamia;
		case 'MonsterHuntFiend' :					return EA_MonsterHuntFiend;
		case 'MonsterHuntDao' :						return EA_MonsterHuntDao;
		case 'MonsterHuntDoppler' : 				return EA_MonsterHuntDoppler;
		case 'KillBossFists' :						return EA_Brawler;
		case 'WinFistFights' :						return EA_BrawlMaster;
		case 'WinRaces' :							return EA_NeedForSpeed;
		
		
		case 'Bookworm' :							return EA_Bookworm;
		case 'Cerberus' :							return EA_Cerberus;
		case 'TrailOfGrasses' :						return EA_TrialOfGrasses;
		case 'Dendrology' :							return EA_Dendrology;
		case 'EnemyOfMyFriend' :					return EA_EnemyOfMyFriend;
		case 'FusSomethingSomething' :				return EA_FusSthSth;
		case 'EnvironmentUnfriendly' :				return EA_EnvironmentUnfriendly;
		case 'FistOfTheSouthStar' :					return EA_FistOfTheSouthStar;
		case 'FullyArmed' :							return EA_FullyArmed;
		case 'Immortal' :							return EA_Immortal;
		case 'PestControl' :						return EA_PestControl;
		case 'TechnologicalProgress' :				return EA_TechnoProgress;
		case 'TrainedInKaerMorhen' :				return EA_TrainedInKaerMorhen;
		case 'TheEvilestThing' :					return EA_TheEvilestThing;
		case 'LearningTheRopes' :					return EA_LearningTheRopes;
		case 'PowerOverwhelming' : 					return EA_PowerOverwhelming;
		case 'Rage' :								return EA_Rage;
		case 'BreakingBad' :						return EA_BreakingBad;
		case 'Bombardier' : 						return EA_Bombardier;
		case 'Finesse' : 							return EA_Finesse;
		case 'Explorer' :							return EA_Explorer;
		case 'FireInTheHole' :						return EA_FireInTheHole;
		case 'FundamentalsFirst' :					return EA_FundamentalsFirst;
		case 'Allin' :								return EA_Allin;
		case 'GeraltandFriends' : 					return EA_GeraltandFriends;
		
		case 'FeatherStrongerThanSword' :			return EA_FeatherStrongerThanSword;
		case 'Thirst' :								return EA_Thirst;
		case 'WantedDeadOrBovine' :					return EA_WantedDeadOrBovine;
		case 'Slide' : 								return EA_Slide;
		case 'KilledIt' : 							return EA_KilledIt;
		case 'ToadPrince' :							return EA_ToadPrince;
		case 'PartyAnimal' : 						return EA_PartyAnimal;
		case 'Auctioneer' : 						return EA_Auctioneer;
		case 'TheCompletePicture' :					return EA_TheCompletePicture;
		case 'HeartsOfStone' :						return EA_HeartsOfStone;
		case 'KillEthreals' : 						return EA_KillEtherals;
		case 'DivineWhip' : 						return EA_DivineWhip;
		case 'LatestFashion' : 						return EA_LatestFashion;
		
		default :									return EA_Undefined;
	}
}

function AchievementEnumToName(a : EAchievement) : name
{
	switch(a)
	{
		case EA_FoundYennefer : return 'EA_FoundYennefer'; break;
		case EA_FreedDandelion : return 'EA_FreedDandelion'; break;
		case EA_YenGetInfoAboutCiri : return 'EA_YenGetInfoAboutCiri'; break;
		case EA_FindBaronsFamily : return 'EA_FindBaronsFamily'; break;
		case EA_FindCiri : return 'EA_FindCiri'; break;
		case EA_ConvinceGeelsToBetrayEredin : return 'EA_ConvinceGeelsToBetrayEredin'; break;
		case EA_DefeatEredin : return 'EA_DefeatEredin'; break;
		case EA_FinishTheGameEasy : return 'EA_FinishTheGameEasy'; break;
		case EA_FinishTheGameNormal : return 'EA_FinishTheGameNormal'; break;
		case EA_FinishTheGameHard : return 'EA_FinishTheGameHard'; break;
		case EA_CompleteWitcherContracts : return 'EA_CompleteWitcherContracts'; break;
		case EA_CompleteSkelligeRaceForCrown : return 'EA_CompleteSkelligeRaceForCrown'; break;
		case EA_CompleteWar : return 'EA_CompleteWar'; break;
		case EA_CompleteKeiraMetz : return 'EA_CompleteKeiraMetz'; break;
		case EA_GetAllForKaerMorhenBattle : return 'EA_GetAllForKaerMorhenBattle'; break;
		case EA_Dendrology : return 'EA_Dendrology'; break;
		case EA_EnemyOfMyFriend : return 'EA_EnemyOfMyFriend'; break;
		case EA_FusSthSth : return 'EA_FusSthSth'; break;
		case EA_EnvironmentUnfriendly : return 'EA_EnvironmentUnfriendly'; break;
		case EA_TrainedInKaerMorhen : return 'EA_TrainedInKaerMorhen'; break;
		case EA_TheEvilestThing : return 'EA_TheEvilestThing'; break;
		case EA_TechnoProgress : return 'EA_TechnoProgress'; break;
		case EA_LearningTheRopes : return 'EA_LearningTheRopes'; break;
		case EA_FundamentalsFirst : return 'EA_FundamentalsFirst'; break;
		case EA_TrialOfGrasses : return 'EA_TrialOfGrasses'; break;
		case EA_BreakingBad : return 'EA_BreakingBad'; break;
		case EA_Bombardier : return 'EA_Bombardier'; break;
		case EA_Swank : return 'EA_Swank'; break;
		case EA_Rage : return 'EA_Rage'; break;
		case EA_GwintMaster : return 'EA_GwintMaster'; break;
		case EA_MonsterHuntFogling : return 'EA_MonsterHuntFogling'; break;
		case EA_MonsterHuntEkimma : return 'EA_MonsterHuntEkimma'; break;
		case EA_MonsterHuntLamia : return 'EA_MonsterHuntLamia'; break;
		case EA_MonsterHuntFiend : return 'EA_MonsterHuntFiend'; break;
		case EA_MonsterHuntDao : return 'EA_MonsterHuntDao'; break;
		case EA_MonsterHuntDoppler : return 'EA_MonsterHuntDoppler'; break;
		case EA_Allin : return 'EA_Allin'; break;
		case EA_GeraltandFriends : return 'EA_GeraltandFriends'; break;
		case EA_BrawlMaster : return 'EA_BrawlMaster'; break;
		case EA_NeedForSpeed : return 'EA_NeedForSpeed'; break;
		case EA_Brawler : return 'EA_Brawler'; break;
		case EA_Finesse : return 'EA_Finesse'; break;
		case EA_PowerOverwhelming : return 'EA_PowerOverwhelming'; break;
		case EA_Cerberus : return 'EA_Cerberus'; break;
		case EA_Bookworm : return 'EA_Bookworm'; break;
		case EA_Immortal : return 'EA_Immortal'; break;
		case EA_FistOfTheSouthStar : return 'EA_FistOfTheSouthStar'; break;
		case EA_Explorer : return 'EA_Explorer'; break;
		case EA_PestControl : return 'EA_PestControl'; break;
		case EA_FireInTheHole : return 'EA_FireInTheHole'; break;
		case EA_FullyArmed : return 'EA_FullyArmed'; break;
		case EA_GwintCollector : return 'EA_GwintCollector'; break;
				
		
		case EA_Thirst : return 'EA_Thirst'; break;
		case EA_WantedDeadOrBovine : return 'EA_WantedDeadOrBovine'; break;
		case EA_Slide : return 'EA_Slide'; break;
		case EA_KilledIt : return 'EA_KilledIt'; break;
		case EA_FeatherStrongerThanSword : return 'EA_FeatherStrongerThanSword'; break;
		case EA_ToadPrince : return 'EA_ToadPrince'; break;
		case EA_PartyAnimal : return 'EA_PartyAnimal'; break;
		case EA_Auctioneer : return 'EA_Auctioneer'; break;
		case EA_TheCompletePicture : return 'EA_TheCompletePicture'; break;
		case EA_HeartsOfStone : return 'EA_HeartsOfStone'; break;
		case EA_KillEtherals : return 'EA_KillEtherals'; break;
		case EA_DivineWhip : return 'EA_DivineWhip'; break;
		case EA_LatestFashion : return 'EA_LatestFashion'; break;
		
		
		case EA_BeauclairWelcomeTo : return 'EA_BeauclairWelcomeTo'; break;
		case EA_HeroOfBeauclair : return 'EA_HeroOfBeauclair'; break;
		case EA_BeauclairMostWanted : return 'EA_BeauclairMostWanted'; break;
		case EA_ChampionOfBeauclair : return 'EA_ChampionOfBeauclair'; break;
		case EA_LikeAVirgin : return 'EA_LikeAVirgin'; break;
		case EA_HomeSweetHome : return 'EA_HomeSweetHome'; break;
		case EA_TurnedEveryStone : return 'EA_TurnedEveryStone'; break;
		case EA_GotToHaveThemAll : return 'EA_GotToHaveThemAll'; break;
		case EA_BloodAndWine : return 'EA_BloodAndWine'; break;
		case EA_ReadyToRoll : return 'EA_ReadyToRoll'; break;
		case EA_SchoolOfTheMutant : return 'EA_SchoolOfTheMutant'; break;
		case EA_HastaLaVista : return 'EA_HastaLaVista'; break;
		
		case EA_Goliath : return 'EA_Goliath'; break;

		case EA_Undefined :
		case EA_Unused :
		default:
			return '';
	}
	
	return '';
}





struct STutorialMessage
{
	editable saved var type : ETutorialMessageType;			

	editable saved var tutorialScriptTag : name;			
	editable saved var journalEntryName : name;				
	editable saved var canBeShownInMenus : bool;
	editable saved var canBeShownInDialogs : bool;	
	editable saved var glossaryLink : bool;					
	editable saved var enableAcceptButton : bool;			
	editable saved var force : bool;						
	editable saved var disableHorizontalResize : bool;		
	editable saved var forceToQueueFront : bool;
	
	editable saved var hintPositionType : ETutorialHintPositionType;		
	editable saved var hintPosX : float;					
	editable saved var hintPosY : float;					
	editable saved var hintDuration : float;				
	editable saved var hintCloseOnFactExist : string;		
	
	editable saved var highlightAreas : array<STutorialHighlight>;		
	editable saved var disabledPanelsExceptions : array<name>;			
	
	
	editable saved var hintPromptScriptTag : name;			
	editable saved var hintPromptPosX : float;				
	editable saved var hintPromptPosY : float;				
	editable saved var hintPromptDuration : float;			
	editable saved var hintPromptCloseFact : string;		
	
	editable saved var markAsSeenOnShow : bool;				
	
	editable saved var isHUDTutorial : bool;				
	editable saved var hintDurationType : ETutorialHintDurationType;	
	
	editable saved var blockInput : bool;
	editable saved var pauseGame : bool;
	editable saved var fullscreen : bool;
	
	
	editable saved var minDuration : float;					
	saved var remainingMinDuration : float;					
	saved var hideOnMinDurationEnd : bool;					
	editable saved var factOnFinishedDisplay : string;		
};

enum ETutorialHintDurationType
{
	ETHDT_NotSet,
	ETHDT_Short,
	ETHDT_Long,
	ETHDT_Infinite,
	ETHDT_Custom,
	ETHDT_Input
}

enum ETutorialHintPositionType
{
	ETHPT_DefaultGlobal,
	ETHPT_DefaultDialog,
	ETHPT_DefaultCombat,
	ETHPT_Custom,
	ETHPT_DefaultUI,
	ETHPT_DefaultRadialMenu
}

struct STutorialHighlight
{
	editable saved var x, y, width, height : float;			
};




import class CGameplayFXSurfacePost extends IGameSystem
{
	
	
	import final function AddSurfacePostFXGroup( position : Vector, fadeInTime : float, activeTime : float, fadeOutTime : float, range : float, type : int );
	import final function IsActive() : bool;
}

struct SFXSurfacePostParams
{
	editable var fxFadeInTime 		: float;
	editable var fxLastingTime		: float;	
	editable var fxFadeOutTime 		: float;
	editable var fxRadius 			: float;
	editable var fxType 			: int;
			
		hint fxType = "-1 - not used, 0 - frost, 1 - burn";
		
		default fxType = -1;
};





enum ESpeedType
{
	EST_Undefined,
	EST_Stopped,
	EST_SlowWalk,		
	EST_Walk,
	EST_Run,			
	EST_FastRun,		
	EST_Sprint			
}




struct SSwarmVictim
{
	var actor : CActor;
	var timeInSwarm : float;
	var inTrigger : bool;
};


enum EBloodType
{
	BT_Undefined,
	BT_Red,
	BT_Yellow,
	BT_Black,
	BT_Green
}