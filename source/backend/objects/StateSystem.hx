package backend.objects;

/**
 * the starting state of everything, this is initilized in Main
 * @since 0.0.0
 */
class StateSystem extends HBasic {
	/**
	 * the currently loaded state, as a string!
	 * (Used for debugging)
	 * @since 0.0.1
	 */
	public var currentState:String = "UNKNOWN!!";

	/**
	 * the currently loaded state
	 * @since 0.0.0
	 */
	public var state:HState;

	/**
	 * The formula used to create the current state. Used in `restartState`.
	 * 
	 * @since 0.8.0
	 */
	public var stateFormula:{clazz:Class<HState>, args:Array<Dynamic>} = null;

	/**
	 * initilize the state system
	 * @param initState what state to load (can be null)
	 * @since 0.0.0
	 */
	public function new(?initState:Null<Class<HState>>, ?args:Array<Dynamic>) {
		super(0, 0);
		state = initState == null ? new HState() : switchState(initState, args);
	}

	/**
	 * switch to a new state
	 * @param newState state to switch to
	 * @param args optional arguments
	 * @return the new state
	 * @since 0.0.0
	 */
	public function switchState(newState:Class<HState>, ?args:Array<Dynamic>):HState {
		// clean up old state
		if (state != null) {
			state.destroy();
			if (contains(state))
				removeChild(state);
			state = null; // let GC collect it
		}

		// create and add new state
		state = Type.createInstance(newState, args ?? []);
		addChild(state);
		stateFormula = {clazz: newState, args: args};
		currentState = state.toString().replace("[", "").replace(']', "").replace('object', "").trim();

		state.create();
		return state;
	}

	/**
	 * Restarts the current state. Does nothing if the `stateFormula` wasn't set.
	 * `stateFormula` is set automatically when `switchState` is called.
	 * 
	 * @since 0.8.0
	 */
	public function resetState() {
		if (stateFormula == null)
			return;
		switchState(stateFormula.clazz, stateFormula.args);
	}
}
