highlighting
hostTreeOf: anActivation

	"The syntax tree the method compiled here was produced from."

	^ (self hostCompiledPairOf: anActivation) ifNotNil: [ :pair | pair second ]
