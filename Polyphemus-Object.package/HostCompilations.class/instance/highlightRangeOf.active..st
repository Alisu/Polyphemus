highlighting
highlightRangeOf: anActivation active: contextIsActive

	"The activation's place in its source, as an interval, read at pc - 1 below the top (Pharo's
	rule). Identical code keeps the pc; same sends carry it over (#4); else nothing."

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
