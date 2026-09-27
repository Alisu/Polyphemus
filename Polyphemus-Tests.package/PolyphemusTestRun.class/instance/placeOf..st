printing
placeOf: anException

	"The innermost methods the exception was signalled in, and the statement running in the
	first of them past the assertion machinery: which of several alike assertions it was."

	| context names statement |
	context := anException signalerContext.
	names := OrderedCollection new.
	[ context notNil and: [ names size < 10 ] ] whileTrue: [
		names add: context method printString.
		(statement isNil and: [
			 (#( #TestAsserter #TestCase #Object #TestFailure #Exception #Error ) includes:
				  context method methodClass name) not ]) ifTrue: [
			statement := [ context sourceNodeExecuted sourceCode ] on: Error do: [ :e | nil ] ].
		context := context sender ].
	^ (' < ' join: names) , (statement ifNil: [ '' ] ifNotNil: [ ' | at: ' , statement ])
