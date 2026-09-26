private
write: aString as: aName

	"Under another name first, so the other end never reads it half written; then rung for."

	| file |
	directory ensureCreateDirectory.
	file := directory / (aName , '.tmp').
	file ensureDelete.
	file writeStreamDo: [ :stream | stream nextPutAll: aString ].
	file renameTo: aName.
	bell ifNotNil: [ bell value ]
