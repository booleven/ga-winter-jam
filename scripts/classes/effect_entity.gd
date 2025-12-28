class_name EffectEntity extends RefCounted

var method: String
var args: Array
var urgency: int
var tile_index: int

func _init(er: EffectResource = null, i=-1) -> void:
	if not er:
		return
	
	self.method = er.method
	self.args = er.args
	self.urgency = er.urgency
	self.tile_index = i
