testing
isPharoVirtualMachine

	"Whether this is a Pharo VM, asked of its command line, which reads even when memory does
	not. Names can lie: finding a Spur heap in it is the real confirmation."

	| command |
	command := self commandLine asLowercase.
	^ (command includesSubstring: 'pharo') or: [
		  command includesSubstring: '.image' ]
