#include common_scripts\utility;
#include ebinmenu\array_utils;

NAME = "ADMIN";

init() {
	game[NAME] = [];
	game[NAME]["_required_permission_level"] = level.ebinmenu.constants.permissions["Admin"];

	game[NAME]["wallhack"] = ::wallhack;

	level.ebinmenu.events.sync_menu_dvars = array_append(level.ebinmenu.events.sync_menu_dvars, ::syncDvars);

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
		"ui_ebinmenu_wallhack", 0,
		"ui_ebinmenu_human_players", 0
	);

	self ThermalVisionFOFOverlayOff();
	self notify("ebinmenu/disable_wallhack");
}

syncDvars() {
	if(self ebinmenu\permissions::hasAccessToMenuItem(game[NAME]["_required_permission_level"]) == false) {
		self resetDvars();
		return;
	}

	self thread setHumanPlayers();
}

setHumanPlayers() {
	self endon("ebinmenu/menu_close");
	level endon("game_ended");

	while(!isDefined(level.players)) {
		wait 10/60;
	}

	while(true) {
		count = 0;
		foreach(player in level.players) {
			if(isDefined(player.pers["isBot"]) && player.pers["isBot"]) {
				continue;
			}
			count++;
		}

		self setClientDvar("ui_ebinmenu_human_players", count);
		wait 1;
	}
}

wallhack(state) {
	level endon("game_ended");
	self endon("disconnect");
	self endon("ebinmenu/disable_wallhack");

	if(state == "0") {
		self ThermalVisionFOFOverlayOff();
		self notify("ebinmenu/disable_wallhack");
		return;
	}

	while(true) {
		self ThermalVisionFOFOverlayOn();
		self waittill_any("spawned_player", "weapon_switch_started");
	}
}
