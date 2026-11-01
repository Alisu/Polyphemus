stopping
start

	"Answers whether it holds the process stopped, once another observer's stop has ended."

	| helper deadline |
	helper := self class helperFile ifNil: [ ^ false ].
	state := directory / (pid printString , '-' , UUID new asString , '.state').
	pipe := LibC
		        pipe: 'exec ''' , helper fullName , ''' ' , pid printString , ' ' , bound asSeconds printString , ' '''
			        , state fullName , ''''
		        mode: self class pipeMode.
	(pipe isNil or: [ pipe isNull ]) ifTrue: [
		pipe := nil.
		^ false ].
	deadline := DateAndTime now + bound + 10 seconds.
	[ state exists or: [ DateAndTime now > deadline ] ] whileFalse: [ (Delay forMilliseconds: 2) wait ].
	self said = 'stopped' ifTrue: [ ^ true ].
	self end.
	^ false
