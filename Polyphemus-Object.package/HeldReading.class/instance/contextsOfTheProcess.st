reading
contextsOfTheProcess

	"The held process's stack from a new copy taken in one stop. The image must have moved its frames
	into contexts first: they live on stack pages, out of the heap copied."

	self readAgain.
	^ reading contextsOfProcess: (self heldIn: reading)
