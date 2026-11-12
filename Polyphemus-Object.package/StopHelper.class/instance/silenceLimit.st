stopping
silenceLimit

	"How long a helper may say nothing before it is taken as never started."

	^ silenceLimit ifNil: [ 10 seconds ]
