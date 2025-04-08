extends Node

# Names
var player_first_name: String = "Dax"
var player_last_name: String = "Sollis"
var player_name: String = player_first_name + player_last_name
var colony_name: String = "Eden"

# Progress Trackers
var resources: float = 0.0
var energy: int = 0
const WIN_ENERGY: int = 10000

# NPC Trackers
var gunsmith_unlocked: bool = false
var tech_expert_unlocked: bool = false
var bouny_hunter_unlocked: bool = false

# Building Trackers
var reactor_unlockd: bool = false
