describing
vmMakerStepsOf: anException

	"The methods of VMMaker an error was raised under, outermost first and each once in a row,
	from below the simulator's set-up where that is on the stack: for a refusal to say where."

	| steps context |
	steps := OrderedCollection new.
	context := anException signalerContext.
	[ context notNil ] whileTrue: [
		| package |
		package := context method methodClass package name.
		(((package beginsWith: 'VMMaker') or: [ package beginsWith: 'Slang' ]) and: [
			 steps isEmpty or: [ steps first ~= context method selector ] ]) ifTrue: [ steps addFirst: context method selector ].
		context := context sender ].
	(steps indexOf: #initializeInterpreter:) in: [ :index | index > 0 ifTrue: [ steps := steps allButFirst: index ] ].
	^ steps
