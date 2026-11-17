reading
linkOfSendAt: aReturnAddress

	"What the send whose call returns there is linked to, read from the call's target: a method,
	an inline cache of several classes, or a trampoline while unlinked (#95)."

	| target entry cogMethod type theCogit |
	theCogit := layout cogit.
	target := ForeignCode
		          askingVMMaker: [ theCogit backEnd callTargetFromReturnAddress: aReturnAddress ]
		          ifItFails: [ ^ nil ].
	(layout nameOfCodeAddress: target) ifNotNil: [ :name | ^ 'unlinked (' , name , ')' ].
	(layout raw isMachineCodeAddress: target) ifFalse: [ ^ 'calls 16r' , target printStringHex ].
	([ target < (layout raw vmVariables at: 'methodZoneBase') ] on: SpurCannotRead do: [ :unsaid | false ]) ifTrue: [
		^ 'unlinked (a trampoline at 16r' , target printStringHex , ')' ].
	entry := (theCogit class allInstVarNames anySatisfy: [ :each | each asString = 'cmEntryOffset' ]) ifTrue: [
		         theCogit instVarNamed: #cmEntryOffset ].
	entry ifNil: [ ^ 'calls 16r' , target printStringHex ].
	cogMethod := theCogit cogMethodSurrogateAt: target - entry.
	type := self nameOfMethodType: cogMethod cmType.
	type = 'a Method' ifTrue: [ ^ 'linked to ' , (layout objectAt: cogMethod methodObject) printString ].
	^ 'linked to ' , type , ' at 16r' , (target - entry) printStringHex
