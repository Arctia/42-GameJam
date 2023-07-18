extends Node

var pausable : bool = true
var hard_mode : bool = false
var god_mode : bool = false

func is_pausable() -> bool:
	if not pausable: 
		return false
	return true
