serving
serveFrom: anInputStream to: anOutputStream

	"One message per line until the input ends; each answer on a line of its own, flushed at once.
	When it ends, however it ends, what is held is let go (#180)."

	| line |
	[
	[ (line := anInputStream nextLine) notNil ] whileTrue: [
		line isEmpty ifFalse: [
			(self answer: line) ifNotNil: [ :answer |
				anOutputStream
					nextPutAll: answer;
					lf;
					flush ] ] ] ] ensure: [ self letGoOfWhatIsHeld ]
