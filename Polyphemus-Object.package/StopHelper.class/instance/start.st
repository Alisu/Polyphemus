stopping
start

	"Answers whether it holds the process stopped, once another observer's stop has ended. A
	helper that says nothing within #silenceLimit never started, and is given up (#31)."

	| helper deadline silent |
	helper := program ifNil: [ self class helperFile ifNil: [ ^ false ] ].
	state := directory / (pid printString , '-' , UUID new asString , '.state').
	pipe := LibC
		        pipe: 'exec ''' , helper fullName , ''' ' , pid printString , ' ' , bound asSeconds printString , ' '''
			        , state fullName , ''''
		        mode: self class pipeMode.
	(pipe isNil or: [ pipe isNull ]) ifTrue: [
		pipe := nil.
		^ false ].
	deadline := DateAndTime now + bound + 10 seconds.
	silent := DateAndTime now + self silenceLimit.
	[
	| said |
	said := self said.
	(said = 'waiting' and: [ DateAndTime now <= deadline ]) or: [ said isEmpty and: [ DateAndTime now <= silent ] ] ]
		whileTrue: [ (Delay forMilliseconds: 2) wait ].
	self said = 'stopped' ifTrue: [ ^ true ].
	self end.
	^ false
