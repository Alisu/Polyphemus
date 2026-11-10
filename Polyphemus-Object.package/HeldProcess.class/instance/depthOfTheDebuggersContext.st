where
depthOfTheDebuggersContext

	"How far below the process's top the image's own debugger is. Asked again while the image says
	its debugger is not at a context of the process yet, as just after a hold (#168)."

	| answer |
	10 timesRepeat: [
		answer := self request: '| context wanted depth |
context := (self at: #process) suspendedContext.
wanted := (self at: #session) interruptedContext.
depth := 0.
[ context notNil and: [ context ~~ wanted ] ] whileTrue: [
	context := context sender.
	depth := depth + 1 ].
context
	ifNil: [ ''not on the process: '' , wanted printString , '' / '' , (self at: #process) suspendedContext printString ]
	ifNotNil: [ depth ]'.
		(answer notNil and: [ answer isAllDigits ]) ifTrue: [ ^ answer asNumber ].
		(Delay forMilliseconds: 100) wait ].
	^ NotInTheReading signal: 'the image''s debugger is not at a context of the held process: ' , answer asString
