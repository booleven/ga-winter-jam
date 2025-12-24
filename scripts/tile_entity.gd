class_name TileEntity extends RefCounted

var name: String
var texture: Texture2D
var cost: int
var pfx: Array[EffectResource]
var afx: Array[EffectResource]

func _init(tr: TileResource = null) -> void:
	if tr:
		self.name = tr.name
		self.texture = tr.texture
		self.cost = tr.cost
		self.pfx = tr.pfx.duplicate()
		self.afx = tr.afx.duplicate()
