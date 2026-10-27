package backend.plugins.api.permission;

class Enforcer {
	private static final permissionMap:Map<String, Map<String, Array<PluginPermission>>> = [
		'backend.plugins.api.io.PluginFileHelper' => [
			'getContent' => [PluginPermission.FileReadAccess],
			'getBytes' => [PluginPermission.FileReadAccess],
			'saveContent' => [PluginPermission.FileWriteAccess],
			'saveBytes' => [PluginPermission.FileWriteAccess],
			'appendContent' => [PluginPermission.FileWriteAccess],
			'appendBytes' => [PluginPermission.FileWriteAccess],
			'copy' => [PluginPermission.FileWriteAccess]
		],
		'backend.plugins.api.io.PluginFSHelper' => [
			'createDirectory' => [PluginPermission.FileWriteAccess],
			'deleteDirectory' => [PluginPermission.FileWriteAccess],
			'deleteFile' => [PluginPermission.FileWriteAccess],
			'exists' => [PluginPermission.FileReadAccess],
			'isDirectory' => [PluginPermission.FileReadAccess],
			'readDirectory' => [PluginPermission.FileReadAccess]
		],
		'backend.plugins.api.process.PluginProcessHelper' => ['createProcess' => [PluginPermission.ProcessAccess]]
	];

	private static final nameMap:Map<String, String> = [
		'backend.plugins.api.io.PluginFileHelper' => 'File',
		'backend.plugins.api.io.PluginFSHelper' => 'FileSystem',
		'backend.plugins.api.process.PluginProcessHelper' => 'ProcessHelper'
	];

	public static function enforce(api:PluginAPI, ?posInfos:PosInfos):Bool {
		var className = posInfos?.className;
		var methodName = posInfos?.methodName;
		if (className == null || methodName == null)
			return false;

		var permissions = permissionMap.get(className)?.get(methodName);
		if (permissions == null)
			return false;

		for (permission in permissions) {
			if (!api.permissions.contains(permission)) {
				trace('WARNING:Plugin "${api.data.meta.displayName}" attempted to use api call ${nameMap.get(className)}.${methodName}() without the required "${permission}" permission. The call has been blocked.');
				return false;
			}
		}
		return true;
	}
}
