package backend.plugins.api.permission;

enum abstract PluginPermission(String) from String to String {
	var FileReadAccess = 'FileReadAccess';
	var FileWriteAccess = 'FileWriteAccess';
	var ProcessAccess = 'ProcessAccess';
}
