class_name SAVES extends Resource

var GAME_VERSION : float = 0.003
const SAVE_PATH = "res://res/saves/game.save"
enum LvlState {CLEAR, PLAYED, UNLOCKED, LOCKED}
enum StoryState {VIEWED, UNVIEW}
enum SaveStatus {NEW, OK, ERROR, OUTDATED}

func createSave() -> Dictionary :
	return {
		"version" : GAME_VERSION,
		"ch0" : [
			{"state" : LvlState.UNLOCKED, "star" : 2, "story" : StoryState.UNVIEW }, #1
			{"state" : LvlState.LOCKED, "star" : 0, "story" : StoryState.UNVIEW }, #2
			{"state" : LvlState.LOCKED, "star" : 0, "story" : StoryState.UNVIEW }, #3
			{"state" : LvlState.LOCKED, "star" : 0, "story" : StoryState.UNVIEW }, #4
			{"state" : LvlState.LOCKED, "star" : 0, "story" : StoryState.UNVIEW }, #5
			{"state" : LvlState.LOCKED, "star" : 0, "story" : StoryState.UNVIEW }, #6
			{"state" : LvlState.LOCKED, "star" : 0, "story" : StoryState.UNVIEW }, #7
			{"state" : LvlState.LOCKED, "star" : 0, "story" : StoryState.UNVIEW }, #8
			{"state" : LvlState.LOCKED, "star" : 0, "story" : StoryState.UNVIEW }, #9
			{"state" : LvlState.LOCKED, "star" : 0, "story" : StoryState.UNVIEW }, #10
		],
		"ch1" : [
			{"state" : LvlState.LOCKED, "star" : 0, "story" : StoryState.UNVIEW }, #1
		],
	}

func saveData(data = null, stage = null, status = true, star = 0) :
	var saveFile;
	if stage == null:
		saveFile =  FileAccess.open(SAVE_PATH, FileAccess.WRITE)
		saveFile.store_line(JSON.stringify(data))
		saveFile.close()
	else:
		saveFile  = FileAccess.open(SAVE_PATH, FileAccess.READ_WRITE)
		var jsonData = JSON.parse_string(saveFile.get_as_text());
		print(saveFile.get_as_text(), jsonData)
		jsonData["ch0"][stage].state = LvlState.CLEAR;
		jsonData["ch0"][stage].star = star;
		jsonData["ch0"][stage + 1].state = LvlState.UNLOCKED;
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
