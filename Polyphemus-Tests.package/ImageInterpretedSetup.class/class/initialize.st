class initialization
initialize
	"initialize is not looked up, can't factorize its code"

	"Deliberately empty. Resources used to be created here, so that *loading* the package
	downloaded images and ran the simulator on them -- which is slow, needs the network,
	and crashed in a way that aborted the load before Polyphemus-Builder was reached. SUnit
	creates a resource the first time a test asks for it, which is the right moment: the
	first test pays, and a load costs nothing."
