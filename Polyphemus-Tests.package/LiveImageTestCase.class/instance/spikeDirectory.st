helpers
spikeDirectory

	"A directory of this class's own for what the target leaves behind, emptied when it is
	launched."

	^ PolyphemusEdition current scratch / ('polyphemus-target-' , self class name)
