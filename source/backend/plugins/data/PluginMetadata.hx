package backend.plugins.data;

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
}
