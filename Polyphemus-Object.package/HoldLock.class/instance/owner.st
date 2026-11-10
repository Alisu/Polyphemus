accessing
owner

	"The pid of the observer whose lock it is; nil when there is none, or none that reads."

	| file text |
	file := self lockDirectory / 'owner'.
	file exists ifFalse: [ ^ nil ].
	text := file contents trimBoth.
	^ (text notEmpty and: [ text isAllDigits ]) ifTrue: [ text asNumber ] ifFalse: [ nil ]
