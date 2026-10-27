scheduler
processes

	"What this reading says of the image's processes, by slot (ReifiedProcesses)."

	^ processes ifNil: [ processes := ReifiedProcesses on: self ]
