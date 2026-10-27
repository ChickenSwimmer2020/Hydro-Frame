package backend.plugins.data;

import backend.plugins.api.permission.PluginPermission;

/**
 * Metadata for a `Plugin`.
 * 
 * @since 0.10.0
 */
typedef PluginMetadata = {
	/**
	 * The display name of the `Plugin`.
	 * 
	 * @since 0.10.0
	 */
	var displayName:String;

	/**
	 * The internal identifier of the `Plugin`.
	 * 
	 * @since 0.10.0
	 */
	var id:String;

	/**
	 * The name of the source folder for the `Plugin`.
	 * 
	 * @since 0.10.0
	 */
	var sourceFolder:String;

	/**
	 * The permissions the `Plugin` requests to use.
	 * 
	 * @since 0.10.2
	 */
	var requestedPermissions:Array<PluginPermission>;
}
