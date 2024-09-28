#include common_scripts\utility;
#include ebinmenu\array_utils;

NAME = "VIP";

init() {
	game[NAME] = [];
	game[NAME]["_required_permission_level"] = level.ebinmenu.constants.permissions["VIP"];

	game[NAME]["loadout"] = ebinmenu\_vip_loadouts::updateLoadout;
	game[NAME]["infinite_ammo"] = ::infiniteAmmo;
	game[NAME]["care_package_bullets"] = ::carePackageBullets;

	level.ebinmenu.events.sync_menu_dvars = array_append(level.ebinmenu.events.sync_menu_dvars, ::syncDvars);

	ebinmenu\_vip_loadouts::init();

	level thread onPlayerConnected();

	return NAME;
}

onPlayerConnected() {
	level endon("game_ended");

	while(true) {
		self waittill("connected", player);

		player resetDvars();
	}
}

resetDvars() {
	self setClientDvars(
		"ui_ebinmenu_infinite_ammo", 0,
		"ui_ebinmenu_care_package_bullets", 0
	);

	self notify("ebinmenu/disable_infinite_ammo");
	self notify("ebinmenu/disable_care_package_bullets");
}

syncDvars() {
	if(self ebinmenu\permissions::hasAccessToMenuItem(game[NAME]["_required_permission_level"]) == false) {
		self resetDvars();
		return;
	}
}

//should really do checks in these functions for permissions, but easier not to for now
infiniteAmmo(state) {
	level endon("game_ended");
	self endon("disconnect");
	self endon("ebinmenu/disable_infinite_ammo");

	if(state == "0") {
		self notify("ebinmenu/disable_infinite_ammo");
		return;
	}

	while(true) {
		weapon_name = self getCurrentWeapon();
		if(weapon_name != "none") {
			self giveMaxAmmo(weapon_name);
		}
		wait 1/60;
	}
}

_removeCarePackageBullets(package_array, max_count) {
	for(i = 0; i < package_array.size; i++) { //first pass to remove already picked up
		if(isDefined(package_array[i]) == false) {
			package_array = array_remove_at(package_array, i);
			i--;
		}
	}

	while(package_array.size > max_count) { //keep deleting until correct size
		if(isDefined(package_array[0])) { //may have been already been picked up or deleted by maps\mp\killstreaks\_airdrop::dropTimeOut
			package_array[0] notify("physics_finished"); //stop physicsWaiter thread
			wait 4/60;
			if(isDefined(package_array[0])) {
				package_array[0] maps\mp\killstreaks\_airdrop::deleteCrate();
			}
			package_array[0] notify("death"); //kill listening scripts
		}
		package_array = array_remove_at(package_array, 0);
	}

	return package_array;
}

carePackageBullets(state) {
	level endon("game_ended");
	self endon("disconnect");
	self endon("ebinmenu/disable_care_package_bullets");

	if(isDefined(self.care_package_array) == false) {
		self.care_package_array = [];
	}

	if(state == "0") {
		self.care_package_array = _removeCarePackageBullets(self.care_package_array, 0);
		self notify("ebinmenu/disable_care_package_bullets");
		return;
	}

	while(true) {
		self waittill("weapon_fired");
		self.care_package_array = _removeCarePackageBullets(self.care_package_array, 3); //allow 4, but remove oldest before adding a new one

		player_angles = self getPlayerAngles();
		player_facing = anglesToForward(player_angles);
		object_offset = vector_multiply(player_facing, 100);
		object_destination = bulletTrace(self getEye(), self getEye() + object_offset, false, self)["position"];

		drop_type = "airdrop";
		package_killstreak = maps\mp\killstreaks\_airdrop::getRandomCrateType(drop_type);

		package = maps\mp\killstreaks\_airdrop::createAirDropCrate(self, drop_type, package_killstreak, object_destination);
		package.angles = (player_angles[0]+90, player_angles[1], player_angles[2]); //roll, yaw, pitch

		package thread maps\mp\killstreaks\_airdrop::physicsWaiter(drop_type, package_killstreak);
		package physicsLaunchServer((0,0,0), vector_multiply(player_facing, 800));

		self.care_package_array = array_append(self.care_package_array, package);
	}
}
