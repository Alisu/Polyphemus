protocol
refuseArgumentsOfAnotherTypeIn: someArguments ofTool: aName

	"Refuse an argument that is not of the type the tool declares, naming it: failing deep in the
	tool, Pharo's own error would read as a defect of the server's (#180). One the tool does not
	declare is left to it."

	| declared |
	declared := ((self tools detect: [ :each | (each at: 'name') = aName ]) at: 'inputSchema') at: 'properties'.
	someArguments keysAndValuesDo: [ :key :value |
		| type |
		type := (declared at: key ifAbsent: [ Dictionary new ]) at: 'type' ifAbsent: [ nil ].
		(type = 'integer' and: [ value isInteger not ]) ifTrue: [
			^ ToolCallFailed signal: aName , ': ' , key , ' has to be a whole number, not ' , value printString ].
		(type = 'string' and: [ value isString not ]) ifTrue: [
			^ ToolCallFailed signal: aName , ': ' , key , ' has to be text, not ' , value printString ] ]
