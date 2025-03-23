extends Control

var max_hearts = 4: set = set_max_hearts
var hearts = 4: set = set_hearts

@onready var heartUIFull = $HeartUIFull
@onready var heartUIEmpty = $HeartUIEmpty

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts) # hearts are never less than zero, and never greater than max hearts
	if heartUIFull != null:
		heartUIFull.size.x = hearts * 15 # 15 here because our texture is 15 pixels wide, so 15 pixels per heart
	
func set_max_hearts(value):
	max_hearts = max(value, 1) # never less than one
	if heartUIEmpty != null:
		heartUIEmpty.size.x = max_hearts * 15


func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", Callable(self, "set_hearts"))
	PlayerStats.connect("max_health_changed", Callable(self, "set_max_hearts"))
