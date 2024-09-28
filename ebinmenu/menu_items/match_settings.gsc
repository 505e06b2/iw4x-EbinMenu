#include ebinmenu\array_utils;

NAME = "MATCH_SETTINGS";

_timelimitDvarStr() {
	return "scr_" + level.gameType + "_timelimit";
}

init() {
	game[NAME]["_required_permission_level"] = level.ebinmenu.constants.permissions["Admin"];

	game[NAME]["timeleft"] = ::timeLeft;
	game[NAME]["bots"] = ::bots;
	game[NAME]["playercollision"] = ::collision;

	level thread _resetTimeLeft(getDvar(_timelimitDvarStr()));

	level.ebinmenu.events.sync_menu_dvars = array_append(level.ebinmenu.events.sync_menu_dvars, ::syncDvars);

	return NAME;
}

syncDvars() {
	if(self ebinmenu\permissions::hasAccessToMenuItem(game[NAME]["_required_permission_level"]) == false) {
		return;
	}

	self setClientDvars(
		"ui_ebinmenu_time_left", 100, //reset back to unchanged
		"ui_ebinmenu_player_count", getDvar("bots_manage_fill"),
		"ui_ebinmenu_player_collision", !getDvarInt("bg_playerCollision"),
		"ui_ebinmenu_match_time_elapsed", 0
	);

	self thread _updateMatchTimeElapsed();
}

_updateMatchTimeElapsed() {
	self endon("ebinmenu/menu_close");

	while(true) {
		if(isDefined(level.startTime) == false) {
			wait 1;
			continue;
		}

		self setClientDvar("ui_ebinmenu_match_time_elapsed", maps\mp\_utility::getTimePassed() / 1000);
		wait 1;
	}
}

_resetTimeLeft(previous_value) {
	self waittill("game_ended");

	setDvar(_timelimitDvarStr(), previous_value);
}

timeLeft(half_minutes) {
	//check ui_mp/scriptmenus/ebin.menu for data
	if(isDefined(level.startTime) == false) {
		return;
	}

	time_s = int(half_minutes) * 30; //if not an int, becomes 0

	if(time_s == 0) { //avoid rounding errors
		setDvar(_timelimitDvarStr(), 0);
		return;
	}

	elapsed_time_s = maps\mp\_utility::getTimePassed() / 1000;

	setDvar(_timelimitDvarStr(), ((elapsed_time_s + time_s) / 60));
}

bots(count) {
	count = int(count);
	setDvar("bots_manage_fill", count);

	if(count > 0) {
		setDvar("bots_manage_fill_mode", 4);
	} else {
		setDvar("bots_manage_fill_mode", 0);
	}
}

collision(state) {
	setDvar("bg_playerCollision", state);
	setDvar("bg_playerEjection", state);
}
