enumerating
pharoProcesses

	"Every Pharo virtual machine running on this machine, as pid -> command line, so that
	someone choosing one has something to choose from."

	^ ('/proc' asFileReference directories
		  select: [ :each | each basename allSatisfy: [ :c | c isDigit ] ])
		 inject: OrderedCollection new
		 into: [ :found :each |
			 | reader |
			 reader := self unchecked: each basename.
			 (reader exists and: [ reader isPharoVirtualMachine ]) ifTrue: [
				 found add: each basename asNumber -> reader commandLine ].
			 found ]
