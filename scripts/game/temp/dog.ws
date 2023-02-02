/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/
class W3TinyDog extends CNewNPC
{
	private var animComp : CAnimatedComponent;
	private var meshComp : CMeshComponent;

	event OnSpawned(spawnData : SEntitySpawnData)
	{
		super.OnSpawned(spawnData);
		
		animComp = (CAnimatedComponent)GetComponentByClassName('CAnimatedComponent');
		meshComp = (CMeshComponent)GetComponentByClassName('CMeshComponent');
		
		if(animComp)
			animComp.SetScale(Vector(0.5,0.5,0.5,0));
			
		if(meshComp)
			meshComp.SetScale(Vector(0.5,0.5,0.5,0));
	}
}