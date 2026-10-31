holding
holdWithin: aDuration

	"Interrupt the image and hold it, with what it is busy with -- the process running when it
	was stopped to be interrupted -- in its own debugger. Refused by name without a watcher, and
	let go again when its Pharo is not one the edition reads."

	self holdWithin: aDuration unless: [ false ]
