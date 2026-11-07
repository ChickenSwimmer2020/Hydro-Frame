package backend.plugins.api.permission;

enum abstract PluginPermission(String) from String to String {
	var FileReadAccess = 'FileReadAccess';
	var FileWriteAccess = 'FileWriteAccess';
	var ProcessAccess = 'ProcessAccess';
}

//TODO: Allow plugins to request permissions via a window popup
//TODO: (continued) And give the permission X calls before 
//TODO: (continued) restricting the permission once again. 