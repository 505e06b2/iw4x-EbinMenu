#include common_scripts\utility;
#include ebinmenu\array_utils;

NAME = "HOST";

init() {
	game[NAME] = [];
	game[NAME]["_required_permission_level"] = level.ebinmenu.constants.permissions["Host"];

	game[NAME]["aimbot"] = ::aimbot;
	game[NAME]["god"] = ::god;

	level.ebinmenu.events.sync_menu_dvars = array_append(level.ebinmenu.events.sync_menu_dvars, ::syncDvars);

	level.ebinmenu.players.god = [];

	level thread onPlayerConnected();

	level.ebinmenu.constants.callbackPlayerDamage = level.callbackPlayerDamage;
	level.callbackPlayerDamage = ::onPlayerDamage;

	return NAME;
}

onPlayerConnected() {
	level endon("game_ended");

	while(true) {
		self waittill("connected", player);

		player resetDvars();
	}
}

onPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset) {
	god_enabled = level.ebinmenu.players.god[self.guid];
	if(isDefined(god_enabled) && god_enabled) return;

	[[level.ebinmenu.constants.callbackPlayerDamage]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset);
}

resetDvars() {
	self setClientDvars(
		"ui_ebinmenu_god", 0,
		"ui_ebinmenu_aimbot", 0
	);

	level.ebinmenu.players.god[self.guid] = false;
	self notify("ebinmenu/disable_aimbot");
}

syncDvars() {
	if(self ebinmenu\permissions::hasAccessToMenuItem(game[NAME]["_required_permission_level"]) == false) {
		self resetDvars();
		return;
	}
}

god(state) {
	level endon("game_ended");
	self endon("disconnect");

	if(state == "0") {
		self notify("ebinmenu/disable_god");
		level.ebinmenu.players.god[self.guid] = false;
		return;
	}

	level.ebinmenu.players.god[self.guid] = true;
}

aimbot(state) {
	level endon("game_ended");
	self endon("disconnect");
	self endon("ebinmenu/disable_aimbot");

	if(state == "0") {
		self notify("ebinmenu/disable_aimbot");
		return;
	}

	while(true) {
		self waittill("weapon_fired");
		valid_players = [];
		foreach(player in level.players) {
			if(player != self && isAlive(player) && (level.teamBased == false || self.pers["team"] != player.pers["team"])) {
				valid_players = array_append(valid_players, player);
			}
		}

		if(valid_players.size <= 0) continue;

		target = random(valid_players);

		target thread [[level.callbackPlayerDamage]](self, self, 1000, 0, "MOD_HEAD_SHOT", self getCurrentWeapon(), target getTagOrigin("j_head"), (0,0,0), "head", 0);
	}
}
