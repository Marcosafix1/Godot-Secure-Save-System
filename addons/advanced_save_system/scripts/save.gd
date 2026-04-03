extends Node

const BASE_PASSWORD = "Super_Secure_Base_Key_2026!@#"
const MAIN_SAVE_PATH = "user://game_data.dat"
const BACKUP_SAVE_PATH = "user://system_config.cfg"

var _data: Dictionary = {}

func _ready() -> void:
	_load_and_verify()

# --- حفظ مع الحفاظ على أنواع البيانات ---
func Save_game(group: String, name_key: String, value: Variant) -> void:
	if not _data.has(group):
		_data[group] = {}
	
	_data[group][name_key] = var_to_str(value)
	_full_secure_save()

func get_data(group: String, name_key: String, default_value: Variant = null) -> Variant:
	if _data.has(group) and _data[group].has(name_key):
		var result = str_to_var(_data[group][name_key])
		return result if result != null else default_value
	return default_value

# --- تنظيف ---
func clean_group(group: String) -> void:
	if _data.erase(group):
		_full_secure_save()

func clean_key(group: String, name_key: String) -> void:
	if _data.has(group) and _data[group].has(name_key):
		_data[group].erase(name_key)
		_full_secure_save()

func clean_All() -> void:
	_data.clear()
	_full_secure_save()

# --- تشفير مع توقيع رقمي ---
func _full_secure_save() -> void:
	var json_string = JSON.stringify(_data)
	_write_encrypted(MAIN_SAVE_PATH, json_string)
	_write_encrypted(BACKUP_SAVE_PATH, json_string)

func _write_encrypted(path: String, content: String) -> void:
	var password = (BASE_PASSWORD + OS.get_unique_id()).sha256_text()
	
	var data_with_hash = JSON.stringify({
		"data": content,
		"hash": content.sha256_text()
	})
	
	var file = FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE, password)
	if file:
		file.store_string(data_with_hash)
		file.close()

func _read_encrypted(path: String) -> String:
	if not FileAccess.file_exists(path): return ""
	var password = (BASE_PASSWORD + OS.get_unique_id()).sha256_text()
	var file = FileAccess.open_encrypted_with_pass(path, FileAccess.READ, password)
	if file:
		var content = file.get_as_text()
		file.close()
		
		var parsed = JSON.parse_string(content)
		if parsed and parsed.has("data") and parsed.has("hash"):
			if parsed.data.sha256_text() == parsed.hash:
				return parsed.data
	return ""

# --- تحميل وتحقق ---
func _load_and_verify() -> void:
	var main_content = _read_encrypted(MAIN_SAVE_PATH)
	var backup_content = _read_encrypted(BACKUP_SAVE_PATH)
	
	if main_content != "" and backup_content != "" and main_content == backup_content:
		_data = JSON.parse_string(main_content)
	elif backup_content != "":
		_data = JSON.parse_string(backup_content)
		_full_secure_save()
	elif main_content != "":
		_data = JSON.parse_string(main_content)
		_full_secure_save()
	else:
		_data = {}
