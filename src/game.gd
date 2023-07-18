extends Node

var pausable : bool = true

func is_pausable() -> bool:
	if not pausable: 
		return false
	return true
