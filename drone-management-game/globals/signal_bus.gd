extends Node

#Pause Signals
signal pause_changed

#State Machine Signals
signal transitioned(node, state)

#Registration Signals
signal register_player(player)
signal register_drone_hub(drone_hub)

#Drone Dropoff Signals
signal dropoff(drop_zone)
signal submit_resource(resource)
