reading
contextsOfTheProcess

	"The held process's stack from a new copy taken in one stop: its frames on the stack pages,
	which the copy holds, then its contexts in the heap (#215)."

	self readAgain.
	^ reading activationsOfProcess: (self heldIn: reading)
