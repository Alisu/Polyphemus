tools
held: aHandle saying: aString

	"The frames of the process a held image's debugger is on, top first, after aString."

	| context rows |
	context := ((self images at: aHandle) at: #session) interruptedContext.
	rows := OrderedCollection new.
	[ context notNil and: [ rows size < 20 ] ] whileTrue: [
		rows add: (self rowOfFrame: context numbered: rows size + 1).
		context := context sender ].
	^ self
		  text: aString , String lf , (String lf join: (rows collect: [ :each | self lineOfFrame: each ]))
		  structured: (Dictionary new
				   at: 'handle' put: aHandle;
				   at: 'pid' put: ((self images at: aHandle) at: #pid);
				   at: 'frames' put: rows asArray;
				   yourself)
