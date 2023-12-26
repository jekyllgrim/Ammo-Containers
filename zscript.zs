version "4.10"

class AmmoOverflowHandler : EventHandler
{
	override void WorldThingSpawned(worldEvent e)
	{
		let am = Ammo(e.thing);
		if (am)
		{
			am.bAlwaysPickup = true;
		}

		PlayerPawn pmo = PlayerPawn(e.thing);
		if (pmo)
		{
			pmo.GiveInventory('AmmoOverFlowController', 1);
		}
	}
}

class AmmoOverFlowController : Inventory
{
	array<AmmoOverflowContainer> containers;

	Default
	{
		+Inventory.UNTOSSABLE
		+Inventory.PERSISTENTPOWER
	}

	override bool HandlePickup(Inventory item)
	{
		let ammoItem = Ammo(item);
		if (ammoItem)
		{
			class<Ammo> parentAmmo = ammoItem.GetParentAmmo();
			//Console.Printf("Processing \cD%s", parentAmmo.GetClassName());
			let owned = Ammo(owner.FindInventory(parentAmmo));
			if (!owned)
			{
				return false;
			}
			int receiveAmount = ammoItem.Amount;
			if (!ammoItem.bIgnoreSkill)
			{
				receiveAmount = int(receiveAmount * (G_SkillPropertyFloat(SKILLP_AmmoFactor) * sv_ammofactor));
			}
			int overflowAmount = owned.amount + receiveAmount - owned.maxamount;
			if (overflowAmount <= 0)
			{
				//Console.Printf("\cD%s\c- amount: %d | maxamount: %d | amount after pickup: %d", parentAmmo.GetClassName(), owned.amount, owned.maxamount, owned.amount + receiveAmount);
				return false;
			}

			AmmoOverflowContainer aoc;
			bool processed = false;
			for (int i = 0; i < containers.Size(); i++)
			{
				aoc = containers[i];
				if (aoc && aoc.ammoType == parentAmmo)
				{
					//Console.Printf("Found container for \cD%s\c-. Increasing amount by %d", parentAmmo.GetClassName(), ammoItem.amount);
					aoc.amount += overflowAmount;
					processed = true;
					break;
				}
			}
			if (!processed)
			{
				string containerName = String.Format("AmmoOverflowContainer%d", containers.Size());
				class<AmmoOverflowContainer> aocCls = containerName;
				if (!aocCls)
				{
					Console.Printf("\cD%s\c- is not a valid AmmoOverflowContainer class. Aborting.");
					return false;
				}
				aoc = AmmoOverflowContainer(Actor.Spawn(aocCls, owner.pos));
				aoc.amount = overflowAmount;
				aoc.icon = ammoItem.icon;
				aoc.ammoType = parentAmmo;
				//Console.Printf("Spawning an AmmoOverflowContainer for \cD%s\c- (amount: %d)", parentAmmo.GetClassName(), aoc.amount);
				aoc.AttachToOwner(owner);
				containers.Push(aoc);
				processed = true;
			}
			if (processed)
			{
				if (overflowAmount >= receiveAmount)
				{
					ammoItem.bPickupGood = true;
					ammoItem.GoAwayAndDie();
				}
			}
		}
		return false;
	}

	override void DoEffect()
	{
		if (!owner)
			return;
		
		let ctrlInv = owner.inv;
		class<AmmoOverFlowController> parent = 'AmmoOverFlowController';
		if (ctrlInv is parent)
			return;
		
		Inventory prevInv;
		while (!(ctrlInv is parent))
		{
			prevInv = ctrlInv;
			ctrlInv = ctrlInv.Inv;
		}
		prevInv.Inv = ctrlInv.Inv;
		ctrlInv.Inv = owner.Inv;
		owner.Inv = ctrlInv;
	}
}

class AmmoOverflowContainer : Inventory abstract
{
	class<Ammo> ammotype;
	
	Default
	{
		+Inventory.INVBAR
		+Inventory.PERSISTENTPOWER
		Inventory.amount 1;
		Inventory.maxAmount 100000;
	}

	override bool Use(bool pickup)
	{
		if (!owner)
			return false;

		let am = owner.FindInventory(ammoType);
		if (!am)
			return false;
		
		let diff = am.maxamount - am.amount;
		if (diff > 0)
		{
			uint toGive = min(diff, self.amount);
			am.amount += toGive;
			self.amount -= toGive;
			if (self.amount <= 0)
			{
				Destroy();
				return true;
			}
		}
		return false;
	}
}

class AmmoOverflowContainer0 : AmmoOverflowContainer {}
class AmmoOverflowContainer1 : AmmoOverflowContainer {}
class AmmoOverflowContainer2 : AmmoOverflowContainer {}
class AmmoOverflowContainer3 : AmmoOverflowContainer {}
class AmmoOverflowContainer4 : AmmoOverflowContainer {}
class AmmoOverflowContainer5 : AmmoOverflowContainer {}
class AmmoOverflowContainer6 : AmmoOverflowContainer {}
class AmmoOverflowContainer7 : AmmoOverflowContainer {}
class AmmoOverflowContainer8 : AmmoOverflowContainer {}
class AmmoOverflowContainer9 : AmmoOverflowContainer {}
class AmmoOverflowContainer10 : AmmoOverflowContainer {}
class AmmoOverflowContainer11 : AmmoOverflowContainer {}
class AmmoOverflowContainer12 : AmmoOverflowContainer {}
class AmmoOverflowContainer13 : AmmoOverflowContainer {}
class AmmoOverflowContainer14 : AmmoOverflowContainer {}
class AmmoOverflowContainer15 : AmmoOverflowContainer {}
class AmmoOverflowContainer16 : AmmoOverflowContainer {}
class AmmoOverflowContainer17 : AmmoOverflowContainer {}
class AmmoOverflowContainer18 : AmmoOverflowContainer {}
class AmmoOverflowContainer19 : AmmoOverflowContainer {}
class AmmoOverflowContainer20 : AmmoOverflowContainer {}