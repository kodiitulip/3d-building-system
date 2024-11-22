class_name GameState
extends Node

const STATE_LIVE: GlobalState = GlobalState.LIVE
const STATE_BUILD: GlobalState = GlobalState.BUILD
const STATE_DESTROY: GlobalState = GlobalState.DESTROY

enum GlobalState {
	LIVE,
	BUILD,
	DESTROY,
}

static var current_state: GlobalState = GlobalState.LIVE


static func change_state_to_build() -> void:
	current_state = STATE_BUILD


static func change_state_to_live() -> void:
	current_state = STATE_LIVE
