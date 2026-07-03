class_name SAVES extends Resource

var GAME_VERSION : float = 1.0
const SAVE_PATH = "user://game.save"
#const SAVE_PATH = "res://res/saves/game.save"
enum LvlState {CLEAR, PLAYED, UNLOCKED, LOCKED}
enum StoryState {VIEWED, UNVIEW}
enum SaveStatus {NEW, OK, ERROR, OUTDATED}

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

	for level in data["ch0"]:
		level["state"] = LvlState.UNLOCKED

	for level in data["ch1"]:
		level["state"] = LvlState.UNLOCKED

	return data

func saveData(data = null, stage = null, status = true, star = 0):
	var saveFile
	if stage == null:
		saveFile = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
		saveFile.store_line(JSON.stringify(data))
		saveFile.close()
	else:
		saveFile = FileAccess.open(SAVE_PATH, FileAccess.READ_WRITE)
		var jsonData = JSON.parse_string(saveFile.get_as_text())
		print(saveFile.get_as_text(), jsonData)

		jsonData["ch0"][stage].state = LvlState.CLEAR
		jsonData["ch0"][stage].star = star

		# mentok 5
		#if stage < 4:
		jsonData["ch0"][stage + 1].state = LvlState.UNLOCKED

		saveFile.store_line(JSON.stringify(jsonData))

	saveFile.close()

func loadData() :
	if !FileAccess.file_exists(SAVE_PATH) :
		var defaultData = createSave()
		saveData(defaultData)
		return {"status" : SaveStatus.NEW, "data" : defaultData}
		
	var saveFile = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var jsonString = saveFile.get_line()
	saveFile.close()
	
	var json = JSON.new()
	var ERROR = json.parse(jsonString)
	if ERROR != OK :
		var defaultData = createSave()
		saveData(defaultData)
		return {"status" : SaveStatus.ERROR, "data" : defaultData}
	
	var data : Dictionary = json.get_data()
	if  float(data.get("version", 0)) < GAME_VERSION:
		var defaultData = createSave()
		saveData(defaultData)
		return {"status" : SaveStatus.OUTDATED, "data" : defaultData}
	
	return {"status" : SaveStatus.OK, "data" : data}

func loadSave() :
	return loadData()
