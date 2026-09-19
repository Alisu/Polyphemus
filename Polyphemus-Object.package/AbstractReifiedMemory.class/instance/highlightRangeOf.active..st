highlighting
highlightRangeOf: anActivation active: contextIsActive

	"Where in the source the activation is, as an interval. Activations below the top are
	read at pc - 1, Pharo's own rule. Code compiled here identical to the file's is read at
	the same pc; code making the same sends has the pc carried over send for send (#4).
	Otherwise nothing is highlighted."

	| thePC code host fileCode mapped |
	thePC := ([ anActivation isDead ] on: Error do: [ :e | false ])
		         ifTrue: [ [ anActivation compiledCode endPC ] on: Error do: [ :e | anActivation pc ] ]
		         ifFalse: [ anActivation pc ].
	thePC ifNil: [ ^ 1 to: 0 ].
	contextIsActive ifFalse: [ thePC := thePC - 1 ].

	code := self faithfulCodeOf: anActivation.
	code ifNotNil: [ ^ self rangeIn: code at: thePC of: anActivation ].

	host := self sendMatchedCodeOf: anActivation.
	host ifNil: [ ^ 1 to: 0 ].
	fileCode := anActivation compiledCode.
	mapped := [
	          (SendSequence of: fileCode)
		          pcIn: (SendSequence of: host)
		          for: thePC - (self firstBytecodePCOf: fileCode) ] on: Error do: [ :e | nil ].
	mapped ifNil: [ ^ 1 to: 0 ].
	^ self rangeIn: host at: host initialPC + mapped of: anActivation
