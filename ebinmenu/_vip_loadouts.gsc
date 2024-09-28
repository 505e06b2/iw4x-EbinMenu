#include maps\mp\_utility;
#include ebinmenu\array_utils;

_getPlayerLoadout(guid) {
	found = level.ebinmenu.players.loadouts[guid];
	if(isDefined(found)) {
		return found;
	}

	return 0;
}

_setPlayerLoadout(guid, value) {
	level.ebinmenu.players.loadouts[guid] = value;
}

init() {
	level.ebinmenu.players.loadouts = [];

	level.ebinmenu.events.sync_menu_dvars = array_append(level.ebinmenu.events.sync_menu_dvars, ::syncDvar);

	level thread onPlayerConnect();
}

onPlayerConnect() {
	while(true) {
		self waittill("connected", player);

		player.isTurtle = false;
		player thread onPlayerChangedKit();
	}
}

_initCustomClass() {
	self disableWeaponSwitch();
	self disableOffhandWeapons();
	self disableUsability();

	self takeAllWeapons();
	self _clearPerks();
}

onPlayerChangedKit() {
	self endon("disconnect");

	while(true) {
		self waittill("changed_kit");

		self enableWeaponSwitch();
		self enableOffhandWeapons();
		self enableUsability();
		if(self.isTurtle) {
			self maps\mp\perks\_perkfunctions::unsetBackShield();
			self.isTurtle = false;
		}

		if(self ebinmenu\permissions::hasAccessToMenuItem(game["VIP"]["_required_permission_level"]) == false) {
			self updateLoadout(0);
			continue;
		}

		switch(_getPlayerLoadout(self.guid)) {
			case 0:
				self maps\mp\gametypes\_class::giveLoadout(self.pers["team"], self.curClass, false);
				break;

			case 1:
				self _initCustomClass();

				self giveWeapon("m79_mp", 0, true); //akimbo
				self setSpawnWeapon("m79_mp");

				self maps\mp\perks\_perks::givePerk("specialty_fastreload"); self maps\mp\perks\_perks::givePerk("specialty_quickdraw"); //sleight of hand pro
				self maps\mp\perks\_perks::givePerk("specialty_explosivedamage"); //danger close
				self maps\mp\perks\_perks::givePerk("specialty_localjammer"); //scrambler

				break;

			case 2:
				self _initCustomClass();

				self giveWeapon("defaultweapon_mp", 0, true);
				self setSpawnWeapon("defaultweapon_mp");
				self maps\mp\perks\_perks::givePerk("specialty_fastreload"); self maps\mp\perks\_perks::givePerk("specialty_quickdraw"); //sleight of hand pro
				self maps\mp\perks\_perks::givePerk("specialty_bulletdamage"); //stopping power
				self maps\mp\perks\_perks::givePerk("specialty_localjammer"); //scrambler

				break;

			case 3:
				self _initCustomClass();

				self giveWeapon("riotshield_mp", 0);
				self setSpawnWeapon("riotshield_mp");
				self maps\mp\perks\_perkfunctions::setBackShield();
				self.isTurtle = true;
				self maps\mp\perks\_perks::givePerk("specialty_marathon"); self maps\mp\perks\_perks::givePerk("specialty_fastmantle"); //marathon pro
				self maps\mp\perks\_perks::givePerk("specialty_lightweight"); self maps\mp\perks\_perks::givePerk("specialty_fastsprintrecovery"); //lightweight pro
				self maps\mp\perks\_perks::givePerk("specialty_extendedmelee"); self maps\mp\perks\_perks::givePerk("specialty_falldamage"); //commando pro

				break;
		}

		level notify("changed_kit");
		self thread onMenuClosedAfterKitChange();
	}
}

onMenuClosedAfterKitChange() {
	level endon("game_ended");
	self endon("disconnect");
	self endon("changed_kit");
	self endon("death");

	self waittill("ebinmenu/menu_close");
	self openMenu("perk_display");
}

syncDvar() {
	self setClientDvar("ui_ebinmenu_loadout", _getPlayerLoadout(self.guid));
}

updateLoadout(value) {
	value = int(value);
	self _setPlayerLoadout(self.guid, value);
	self syncDvar();
	self notify("changed_kit");
}
