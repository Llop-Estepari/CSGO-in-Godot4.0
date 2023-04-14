extends Node

signal weapon_changed(name, mag_ammo : int, all_ammo : int, max_mag_ammo : int)
signal weapon_ammo_changed(cur_ammo : int, max_ammo : int, reload : bool)
signal health_changed(hp : int, ap : int)
