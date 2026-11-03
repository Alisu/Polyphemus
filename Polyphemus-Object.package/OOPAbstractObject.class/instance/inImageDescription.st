inspection
inImageDescription

	"nil, true and false by name, anything else by its class, with an article as Pharo prints it."

	| name |
	name := self oopClassName asString.
	name = 'UndefinedObject' ifTrue: [ ^ 'nil' ].
	name = 'True' ifTrue: [ ^ 'true' ].
	name = 'False' ifTrue: [ ^ 'false' ].
	^ (name first isVowel ifTrue: [ 'an ' ] ifFalse: [ 'a ' ]) , name
