as a compilation scope

outerScope

	"A Behavior answers its environment here. The environment of a class in a snapshot is
	that image's own SystemDictionary, which is not a scope object of this image, so the
	walk stops here: names it does not know are answered by bindingOf:, which looks them
	up over there."

	^ nil
