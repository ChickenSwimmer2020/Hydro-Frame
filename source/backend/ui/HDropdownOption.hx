package backend.ui;

class HDropdownOption {
	public var text(default, null):String = 'Bob';
	public var func(default, null):HButton->Void;
	public var keys(default, null):Array<Int> = null;
	public var closeOnClick(default, null):Bool = true;
	public var disabled(default, null):Bool = false;

	public function new(text:String, func:HButton->Void) {
		this.text = text;
		this.func = func;
	}

	public function set_closeOnClick(closeOnClick = true):HDropdownOption {
		this.closeOnClick = closeOnClick;
		return this;
	}

	public function set_keys(keys:Array<Int>):HDropdownOption {
		this.keys = keys;
		return this;
	}

	public function set_disabled(disabled = true):HDropdownOption {
		this.disabled = disabled;
		return this;
	}
}
