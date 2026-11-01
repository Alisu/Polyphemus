accessing
pipeMode

	"Close-on-exec where popen takes it: a child started later must not keep the pipe open."

	^ OSPlatform current isMacOS ifTrue: [ 'w' ] ifFalse: [ 'we' ]
