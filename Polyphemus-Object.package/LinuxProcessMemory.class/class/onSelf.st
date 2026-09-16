instance creation
onSelf

	"This very image. `/proc/self` is the kernel's name for whoever is asking, and reading
	yourself is always allowed whatever Yama says."

	^ self new setPid: #self; yourself
