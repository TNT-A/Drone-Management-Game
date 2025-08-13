extends Node

#Pause Signals
signal pause_changed

#State Machine Signals
signal transitioned(node, state)

#Registration Signals
signal register_player(player)
signal register_drone_hub(drone_hub)
