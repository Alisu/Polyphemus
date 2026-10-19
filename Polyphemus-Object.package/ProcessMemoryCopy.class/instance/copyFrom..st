initialization
copyFrom: aReader

	"Each region kept is a piece of its own, as the reader listed it: the raw heap takes old
	space's piece as it is instead of copying it again."

	| library kept |
	pid := aReader pid.
	processor := aReader processor.
	mappedFiles := aReader mappedFiles.
	threadRegisters := aReader threadRegisters.
	listed := aReader segments.
	library := mappedFiles select: [ :each | VMVariables isTheVMLibrary: each path ].
	kept := Dictionary new.
	aReader writableSegments do: [ :each | kept at: each address put: each ].
	listed do: [ :segment |
		(library anySatisfy: [ :file | segment address between: file start and: file stop - 1 ]) ifTrue: [
			kept at: segment address put: segment ] ].
	pieces := (((kept values asSortedCollection: [ :a :b | a address <= b address ]) asArray
		            collect: [ :each | self copyOf: each from: aReader ]) reject: [ :each | each isNil ])
