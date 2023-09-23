extends Node

var pausable : bool = true
var hard_mode : bool = false
var god_mode : bool = false

func is_pausable() -> bool:
	if not pausable: 
		return false
	return true

func _ready():
	_load()

# ---------------------------------------------------------------------------- #
# --- Data File stuff

var savedata = {
	"path": "user://savedata",
	"best_times": {
		"normal": 999999,
		"hard": 999999,
		"god": 999999
	},
	"mode_unlocked": 0
}

func _load() -> void:
	if not FileAccess.file_exists(savedata.path):
		return
	var file = FileAccess.open(savedata.path, FileAccess.READ)
	savedata = file.get_var()
	print("[DATA  ]: load successfull")

func _save() -> void:
	var file = FileAccess.open(savedata.path, FileAccess.WRITE)
	file.store_var(savedata)
	print("[DATA  ]: save success")

func beat_game(mode:String, secs:int) -> bool:
	if not savedata.mode_unlocked > 1:
		if mode == "hard": savedata.mode_unlocked = 2
		elif mode == "normal": savedata.mode_unlocked = 1
	if savedata.best_times[mode] > secs:
		savedata.best_times[mode] = secs
		return true
	return false

func _beat_game_record(time_in_secs:int=999999) -> bool:
	var mode:String = "normal"
	if hard_mode: mode = "hard"
	if god_mode: mode = "god"
	print("[GAME END]: " + mode + " mode in " + str(time_in_secs) + " secs")
	var record:bool = beat_game(mode, time_in_secs)
	_save()
	return record

func get_unlocks() -> int:
	return savedata.mode_unlocked
