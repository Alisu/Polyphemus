reading
callerContextOf: aBaseFramePointer

	"Cog keeps a base frame's caller context above its own context, above the arguments."

	^ self callerContextAboveArgumentsOf: aBaseFramePointer
