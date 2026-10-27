package backend.plugins.api.permission;

class Requester {
	public static function requestDefaultFrom(permissions:Array<PluginPermission>):Array<PluginPermission> {
		var finalPerms = [];
		for (defaultPerm in UPrefs.defaultPluginPermissions)
			if (permissions.contains(defaultPerm))
				finalPerms.push(defaultPerm);
		return finalPerms;
	}
}
