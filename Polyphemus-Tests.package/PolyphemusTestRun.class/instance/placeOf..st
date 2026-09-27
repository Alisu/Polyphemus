printing
placeOf: anException

	"The innermost methods the exception was signalled in."

	| context names |
	context := anException signalerContext.
	names := OrderedCollection new.
	[ context notNil and: [ names size < 10 ] ] whileTrue: [
		names add: context method printString.
		context := context sender ].
	^ ' < ' join: names
