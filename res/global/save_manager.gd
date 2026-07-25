class_name SAVES extends Resource

var GAME_VERSION: float = 2.1
const SAVE_PATH = "user://game.save"

enum LvlState { CLEAR, PLAYED, UNLOCKED, LOCKED }
enum StoryState { VIEWED, UNVIEW }
enum SaveStatus { NEW, OK, ERROR, OUTDATED }

func createSave() -> Dictionary:
	var data = {
		"version": GAME_VERSION,
		"ch0": [
			{"state": LvlState.UNLOCKED, "star": 0, "story": StoryState.UNVIEW},
			{"state": LvlState.LOCKED, "star": 0, "story": StoryState.UNVIEW},
			{"state": LvlState.LOCKED, "star": 0, "story": StoryState.UNVIEW},
			{"state": LvlState.LOCKED, "star": 0, "story": StoryState.UNVIEW},
			{"state": LvlState.LOCKED, "star": 0, "story": StoryState.UNVIEW},
			{"state": LvlState.LOCKED, "star": 0, "story": StoryState.UNVIEW},
			{"state": LvlState.LOCKED, "star": 0, "story": StoryState.UNVIEW},
			{"state": LvlState.LOCKED, "star": 0, "story": StoryState.UNVIEW},
			{"state": LvlState.LOCKED, "star": 0, "story": StoryState.UNVIEW},
			{"state": LvlState.LOCKED, "star": 0, "story": StoryState.UNVIEW},
		],
		"ch1": [
			{"state": LvlState.LOCKED, "star": 0, "story": StoryState.UNVIEW},
		],
	}

	# ============================
	# CHEAT MODE
	# ============================
	for level in data["ch0"]:
		level["state"] = LvlState.UNLOCKED

	for level in data["ch1"]:
		level["state"] = LvlState.UNLOCKED

	return data


func saveData(data = null, stage = null, status = true, star = 0):
	if stage == null:
		var saveFile = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
		saveFile.store_line(JSON.stringify(data))
		saveFile.close()
		return

	var saveFile = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var jsonData = JSON.parse_string(saveFile.get_as_text())
	saveFile.close()

	jsonData["ch0"][stage]["state"] = LvlState.CLEAR
	jsonData["ch0"][stage]["star"] = star

	# Unlock level berikutnya
	if stage < jsonData["ch0"].size() - 1:
		jsonData["ch0"][stage + 1]["state"] = LvlState.UNLOCKED

	saveFile = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	saveFile.store_line(JSON.stringify(jsonData))
	saveFile.close()


func loadData() -> Dictionary:
	if !FileAccess.file_exists(SAVE_PATH):
		var defaultData = createSave()
		saveData(defaultData)
		return {
			"status": SaveStatus.NEW,
			"data": defaultData
		}

	var saveFile = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var jsonString = saveFile.get_line()
	saveFile.close()

	var json = JSON.new()
	var error = json.parse(jsonString)

	if error != OK:
		var defaultData = createSave()
		saveData(defaultData)
		return {
			"status": SaveStatus.ERROR,
			"data": defaultData
		}

	var data: Dictionary = json.get_data()

	if float(data.get("version", 0)) < GAME_VERSION:
		var defaultData = createSave()
		saveData(defaultData)
		return {
			"status": SaveStatus.OUTDATED,
			"data": defaultData
		}

	return {
		"status": SaveStatus.OK,
		"data": data
	}

func loadSave():
	return loadData()
