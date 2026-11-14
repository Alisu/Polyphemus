building
damagesIn: aDump

	"What to overwrite in the copy, each as address -> word."

	^ { ((VMVariables on: aDump) addressOf: 'framePointer') -> 16r1000 }
