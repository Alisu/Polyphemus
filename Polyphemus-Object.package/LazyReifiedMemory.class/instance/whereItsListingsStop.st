enumerating
whereItsListingsStop

	"The walk that damage ended when instances were last listed, or nil (SpurDumpedMemory, #211)."

	^ whole ifNotNil: [ whole whereItsListingsStop ]
