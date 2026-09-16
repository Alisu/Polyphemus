instance creation
onSelf

	"This very image. `/proc/self` is the kernel's name for whoever is asking, so no process
	id is needed -- and reading yourself is always allowed, whatever Yama says."

	^ self on: #self
