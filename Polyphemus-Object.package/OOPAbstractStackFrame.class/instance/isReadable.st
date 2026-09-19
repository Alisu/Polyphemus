testing
isReadable

	"A JIT frame is readable only by a reader that knows Cog's layout."

	^ self isMachineCodeFrame not or: [
		  [ self layout readsMachineCodeFrames ] on: Error do: [ :e | false ] ]
