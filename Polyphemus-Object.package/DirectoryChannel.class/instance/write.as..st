private
write: aString as: aName

	"Under another name first, so the other end never reads it half written. In the agent's own
	directory: made here, it would be ours, and an agent run as another user could not use it."

	| file |
	file := directory / (aName , '.tmp').
	file ensureDelete.
	file writeStreamDo: [ :stream | stream nextPutAll: aString ].
	file renameTo: aName
