telling
mark: aString

	"Said in front of the debugger's title for as long as it is open, whatever title Pharo gives it
	at each step and selection (#149)."

	marks ifNil: [ marks := OrderedCollection new ].
	(marks includes: aString) ifFalse: [ marks add: aString ]
