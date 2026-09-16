testing
isPharoVirtualMachine

	"Whether this process is a Pharo virtual machine.

	Asked of the command line, which can be read even when the memory cannot -- so a process
	we are not allowed to look at is still refused for the right reason. It is a name and
	names can lie; the honest confirmation is that a Spur heap is found in it, which is what
	`SpurDumpedMemory` does afterwards and what the whole tool is built to check."

	| command |
	command := self commandLine asLowercase.
	^ (command includesSubstring: 'pharo') or: [
		  command includesSubstring: '.image' ]
