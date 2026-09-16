instance creation
virtualMachineChildOf: aPid

	"A Pharo virtual machine among this process's children, or nil. The kernel lists them in
	`/proc/<pid>/task/<pid>/children`."

	| children |
	children := [
	            ('/proc/' , aPid asString , '/task/' , aPid asString , '/children')
		            asFileReference contents substrings: ' ' ]
		            on: Error
		            do: [ :e | #(  ) ].
	^ (children collect: [ :each | each asNumber ])
		  detect: [ :each | (self unchecked: each) isPharoVirtualMachine ]
		  ifNone: [ nil ]
