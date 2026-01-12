@tool
extends Node

@export var animation_player: AnimationPlayer

@export var make_cubic := false:
	set(value):
		if value and animation_player:
			set_all_tracks_cubic(animation_player)
			make_cubic = false

func set_all_tracks_cubic(animation_player: AnimationPlayer):
	for anim_name in animation_player.get_animation_list():
		var animation: Animation = animation_player.get_animation(anim_name)
		if animation:
			for i in range(animation.get_track_count()):
				var track_type := animation.track_get_type(i)
				if track_type == Animation.TYPE_VALUE \
				or track_type == Animation.TYPE_POSITION_3D \
				or track_type == Animation.TYPE_ROTATION_3D \
				or track_type == Animation.TYPE_SCALE_3D:
					animation.track_set_interpolation_type(
						i,
						Animation.INTERPOLATION_CUBIC
					)
			print("Set all tracks in animation '%s' to cubic." % anim_name)
