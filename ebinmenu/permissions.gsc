#include ebinmenu\array_utils;

_getEnum(value) {
	return level.ebinmenu.constants.permissions[value];
}

_getPlayerPermissions(guid) {
	return level.ebinmenu.players.permissions[guid];
}

_setPlayerPermissions(guid, int_value) {
	level.ebinmenu.players.permissions[guid] = int_value;
}

init() {
	//// if these change, ensure that ui_mp/ebinmenu_defines.inc is also updated
	level.ebinmenu.constants.permissions = array_create_enum(array_create(
		array_create("None", 0),
		array_create("Standard", 1),
		array_create("VIP", 5),
		array_create("Admin", 10),
		array_create("Host", 99)
	));

	level.ebinmenu.players.permissions = [];

	level.ebinmenu.events.sync_menu_dvars = array_append(level.ebinmenu.events.sync_menu_dvars, ::syncDvar);
}

getPermissionLevelInt() {
	if(self isHost()) {
		return _getEnum("Host");
	}

	found = _getPlayerPermissions(self getGuid());
	if(isDefined(found)) {
		return found;
	}

	_setPlayerPermissions(self getGuid(), _getEnum("Standard"));
	return _getPlayerPermissions(self getGuid());
}

syncDvar() {
	self setClientDvar("ui_ebinmenu_permission", self getPermissionLevelInt());
}

hasAccessToMenuItem(required_permission_level) {
	return self getPermissionLevelInt() >= required_permission_level;
}

setDvarIfAccessDenied(required_permission_level) {
	if(self hasAccessToMenuItem(required_permission_level) == false) {
		self syncDvar();
		return true;
	}

	return false;
}
