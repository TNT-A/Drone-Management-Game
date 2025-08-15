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

#Notifier Signals
signal minor_notif(text, length)
signal major_notif(text, length)

#Shop Signals
signal shop_opened
signal shop_closed

#Upgrade Signals
signal drone_upgraded
signal weight_upgraded
signal speed_upgraded
signal damage_upgraded
signal value_upgraded

#Game Win
signal win_game
