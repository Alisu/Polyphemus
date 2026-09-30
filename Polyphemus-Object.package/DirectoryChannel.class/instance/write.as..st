private
write: aString as: aName

	"Under another name first, so the other end never reads it half written."

	| file |
	PolyphemusEdition ensureDirectory: directory.
	file := directory / (aName , '.tmp').
	file ensureDelete.
	file writeStreamDo: [ :stream | stream nextPutAll: aString ].
	file renameTo: aName
