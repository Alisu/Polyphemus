as a compilation scope

outerScope

	"A Behavior answers its environment here; a snapshot's class lives in that image's own
	SystemDictionary, no scope of this image, so the walk stops: names it does not know are
	answered by bindingOf:, which looks them up over there."

	^ nil
