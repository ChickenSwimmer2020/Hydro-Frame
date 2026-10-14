package backend.ui;

class HDropdownOption {
	public var text(default, null):String = 'seperator';
	public var func(default, null):HButton->Void = null;
	public var keys(default, null):Null<Array<Null<Int>>> = null;
	public var closeOnClick(default, null):Null<Bool> = null;
	public var closeFullDropdown(default, null):Null<Bool> = null;
	public var disabled(default, null):Null<Bool> = null;

	public function new(text:String, func:HButton->Void) {
		this.text = text;
		this.func = func;
	}

	public function set_closeOnClick(closeOnClick = true):HDropdownOption {
		this.closeOnClick = closeOnClick;
		return this;
	}

	public function set_closeFullDropdown(closeFullDropdown = false):HDropdownOption {
		this.closeFullDropdown = closeFullDropdown;
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
