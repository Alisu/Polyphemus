class initialization
initialize
	"initialize is not looked up, can't factorize its code"

	"Deliberately empty: resources made here made *loading* the package download images and run
	the simulator on them, slow, networked, and once aborting the load. SUnit makes a resource
	when a test first asks for it, so the first test pays and a load costs nothing."
