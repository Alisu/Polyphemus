reading the map
mappedFiles

	"The files mapped into the process, listed once while it is stopped here: the copy and the
	reading of a stop both ask (#135). A running process may map more."

	self isStoppedHere ifFalse: [ ^ self listMappedFiles ].
	^ mappedFiles ifNil: [ mappedFiles := self listMappedFiles ]
