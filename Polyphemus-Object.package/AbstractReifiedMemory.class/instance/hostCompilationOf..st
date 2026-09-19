highlighting
hostCompilationOf: anActivation

	"The activation's method compiled here, identical to the file's or not."

	^ (self hostCompiledPairOf: anActivation) ifNotNil: [ :pair | pair first ]
