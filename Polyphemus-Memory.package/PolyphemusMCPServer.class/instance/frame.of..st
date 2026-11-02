tools
frame: aNumber of: aSession

	"The held process's context aNumber frames down, 1 being the top."

	| context |
	context := aSession interruptedContext.
	aNumber - 1 timesRepeat: [ context := context ifNotNil: [ context sender ] ].
	^ context ifNil: [ self error: 'No frame ' , aNumber printString , ' in the held process' ]
