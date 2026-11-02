tools
save: someArguments

	"Save a method's new source into the held image where the frame's method is, the frame
	restarted in it as Pharo's debugger does. Not saved, the failure says why."

	| session source save answer |
	session := self sessionAt: someArguments.
	source := someArguments at: 'source' ifAbsent: [ self error: 'save needs the method''s new source' ].
	save := (MethodSave of: source notifying: nil) ui: self; yourself.
	(session fixMethodOf: (self frame: (someArguments at: 'frame' ifAbsent: [ 1 ]) of: session) to: source with: save)
		ifFalse: [ self error: 'Not saved: ' , save told asString ].
	answer := self held: (someArguments at: 'handle') saying: (save told
			           ifNil: [ 'Saved, and its frame restarted in it.' ]
			           ifNotNil: [ :told | 'Saved, but not all of it: ' , told ]).
	(answer at: 'structuredContent')
		at: 'saved' put: true;
		at: 'told' put: save told.
	^ answer
