initialization
copyFrom: aReader stretches: someStretches

	"Only the writable regions holding some of someStretches (start -> limit); the rest is read
	live from aReader, as its process is by then."

	pid := aReader pid.
	processor := aReader processor.
	mappedFiles := aReader mappedFiles.
	threadRegisters := aReader threadRegisters.
	listed := aReader segments.
	live := aReader.
	pieces := self
		          piecesOf: (aReader writableSegments select: [ :segment |
				           someStretches anySatisfy: [ :each |
					           each key < (segment address + segment sizeInMemory) and: [ each value > segment address ] ] ])
		          from: aReader
