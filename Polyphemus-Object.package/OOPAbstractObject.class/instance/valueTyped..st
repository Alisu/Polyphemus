editing
valueTyped: aString

	"What typed text stands for: nil, true, false, or an integer. Nothing else -- what is
	stored has to be in the image already."

	| text |
	text := aString asString trimBoth.
	text = 'nil' ifTrue: [ ^ memory reifiedNilObject ].
	text = 'true' ifTrue: [ ^ memory reifiedTrueObject ].
	text = 'false' ifTrue: [ ^ memory reifiedFalseObject ].
	(text matchesRegex: '-?[0-9]+') ifTrue: [ ^ text asInteger ].
	^ self error: 'type an integer, nil, true or false: ' , text , ' is not one'
