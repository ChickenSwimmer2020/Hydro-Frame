package backend.macro;

#if macro
import haxe.macro.*;
import haxe.macro.Expr.ComplexType;
import haxe.macro.Expr.Field;
import haxe.macro.Expr.TypeDefinition;

class PreferencesMacro {
	public static function generate() {
		Context.onTypeNotFound((tnfv) -> {
			if (tnfv == 'backend.UPrefs') {
				var defaultPrefs:Dynamic = GlobalPrefs.DEFAULT_PREFERENCES;
				var fields:Array<Field> = [
					{
						pos: Context.currentPos(),
						name: 'currentSkin',
						access: [APublic, AStatic],
						/*
							I would do Null<Skin>, but using Skin means forcing
							the resolution of Skin and everything it needs, but
							since Import.hx isn't available at macro time, everything
							that would be auto imported is not available yet, and so 
							its imported types are missing. And even if we were to import
							everything in Skin, every import of Skin would also 
							need to be forcefully resolved so we'd have to import
							everything in all of those classes, and so on. It'd be
							an extremely tedious thing. In fact, if it were to ever import
							something from a library that doesnt have every file imported
							or resolvable at macro time, unless we explicitly shadow 
							the library, there's nothing we can do.

							For simplicities sake, I just used a Null<Dynamic>.
						 */
						kind: FVar(macro :Null<Dynamic>, null)
					}
				];
				for (prefName in Reflect.fields(defaultPrefs)) {
					var prefVal = Reflect.field(defaultPrefs, prefName);
					var valExpr:Expr = macro $v{prefVal};
					var inferredType:ComplexType = TypeTools.toComplexType(Context.typeof(valExpr));

					fields.push({
						pos: Context.currentPos(),
						name: 'get_$prefName',
						access: [APrivate, AStatic],
						kind: FFun({
							args: [],
							ret: inferredType,
							expr: macro {
								var val = backend.UPrefUtils.getFromFile($v{prefName});
								if (val == null)
									val = $v{prefVal};
								return val;
							}
						}),
					});
					fields.push({
						pos: Context.currentPos(),
						name: 'set_$prefName',
						access: [APrivate, AStatic],
						kind: FFun({
							args: [
								{
									name: 'val',
									type: inferredType
								}
							],
							ret: inferredType,
							expr: macro {
								return backend.UPrefUtils.writeToFile($v{prefName}, val);
							}
						}),
					});
					fields.push({
						pos: Context.currentPos(),
						name: prefName,
						access: [APublic, AStatic],
						kind: FProp('get', 'set', inferredType, null),
					});
				}
				var rDef:TypeDefinition = {
					pos: Context.currentPos(),
					pack: ['backend'],
					name: 'UPrefs',
					kind: TDClass(null, [], false, false, false),
					fields: fields,
					doc: 'The user\'s preferences.',
				}
				return rDef;
			}
			return null;
		});
	}
}
#end

class GlobalPrefs {
	/**
	 * Default Preferences
	 * * These get written to the UPrefs file if the file isnt found.
	 * @since 0.10.2
	 */
	public static final DEFAULT_PREFERENCES:Dynamic = {
		mainMenuMuted: false,
		#if debug
		debuggerVisible: true,
		#end
		// editor
		defaultPluginPermissions: ['FileReadAccess', 'FileWriteAccess'],
		undoType: ["DocumentLevel" => true, "ObjectLevel" => false],
		undoLevels: 100,
		autoRecovery: true,
		autoRecoveryTime: 10,
		uiTheme: ["Darkest" => false, "Dark" => true, "Light" => false, "Lightest" => false],
		uiAppearance: ["Comfortable" => true, "Compact" => false],
		enableShading: true,
		hideStageBorder: false,
		useOutlinesForPanning: false,
		autoCollapseIconPanels: true,
		seperateProjectsAndScriptWindows: false,
		useCustomColorsForHighlights: false,
		groupCustomColor: 0xFF1cbbb4,
		objectCustomColor: 0xFF00a8ff,
		otherCustomColor: 0xFF0066ff,
		perferredReference: ["Custom" => false, "WINUser" => false, "PCName" => false, "NOT SELECTED" => true],
		customReferenceName: "",
		inverseScrollDirection: false
	};
}
