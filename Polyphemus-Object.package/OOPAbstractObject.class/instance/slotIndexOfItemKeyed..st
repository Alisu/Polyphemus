editing
slotIndexOfItemKeyed: aKey

	"The slot a row of containedInspectionItems shows, counted from one."

	| key |
	key := aKey asString.
	(key beginsWith: 'slot ') ifTrue: [ ^ (key allButFirst: 5) asNumber ].
	(key beginsWith: '(') ifTrue: [ ^ (key copyFrom: 2 to: (key indexOf: $)) - 1) asNumber ].
	^ self error: key , ' is not a slot'
