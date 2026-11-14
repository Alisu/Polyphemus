highlighting
sendMatchedCodeOf: anActivation

	"Code compiled here that makes the file's sends in the file's order, though its bytes may
	differ: enough to place a pc, never to read slots (#4, #6)."

	| host fileCode candidate |
	host := self hostCompilationOf: anActivation.
	host ifNil: [ ^ nil ].
	fileCode := [ anActivation compiledCode ] on: PolyphemusError do: [ :e | nil ].
	fileCode ifNil: [ ^ nil ].
	candidate := ([ anActivation isBlockContext ] on: PolyphemusError do: [ :e | false ])
		             ifTrue: [ self hostBlockFor: anActivation in: host ]
		             ifFalse: [ host ].
	candidate ifNil: [ ^ nil ].
	^ ([
	   (SendSequence of: candidate) selectors asArray
	   = (SendSequence of: fileCode) selectors asArray ]
		   on: PolyphemusError
		   do: [ :e | false ])
		  ifTrue: [ candidate ]
		  ifFalse: [ nil ]
