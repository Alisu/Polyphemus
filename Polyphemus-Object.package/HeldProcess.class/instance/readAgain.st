private
readAgain

	"The first time a whole reading, seconds of it the class table; after that the same one
	refreshed, which a step leaves valid unless the heap grew or was compacted."

	dumped ifNotNil: [
		[
		reader whileStopped: [ dumped refresh ].
		reading forgetAllButClasses.
		^ self ]
			on: Error
			do: [ :error | dumped := nil ] ].
	reader whileStopped: [
		dumped := SpurDumpedMemory on: reader.
		dumped raw bytes ].
	reading := dumped reifiedMemory
