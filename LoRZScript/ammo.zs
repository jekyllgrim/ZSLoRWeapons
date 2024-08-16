class JGP_FuelAmmoSmall : Cell replaces Cell
{
	Default
	{
		//$Category Ammunition
		Inventory.PickupMessage "$ID24_GOTFUELCAN";
		Tag "Fuel can";
	}
}

class JGP_FuelAmmoLarge : CellPack replaces CellPack
{
	Default
	{
		//$Category Ammunition
		Inventory.PickupMessage "$ID24_GOTFUELTANK";
		Tag "Fuel Tank";
	}
}