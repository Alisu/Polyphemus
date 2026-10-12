running
setUp

	| corePath |
	super setUp.
	server := PolyphemusMCPServer new.
	target := self handleOf: (self call: 'open_image' with: (Dictionary new at: 'path' put: PharoImageAccessor pathToTargetImage; yourself)).
	pharo10 := self handleOf: (self call: 'open_image' with: (Dictionary new at: 'path' put: PharoImageAccessor pathToPharo10; yourself)).
	corePath := (OSEnvironment current at: 'POLYPHEMUS_CORE' ifAbsent: [ nil ])
		            ifNil: [ (FileLocator imageDirectory / 'pharo.core') fullName ].
	corePath asFileReference exists ifTrue: [
		core := self handleOf: (self call: 'open_core' with: (Dictionary new at: 'path' put: corePath; yourself)) ].
	{ target. pharo10. core } do: [ :each |
		each ifNotNil: [ self call: 'processes' with: (Dictionary new at: 'handle' put: each; yourself) ] ]
