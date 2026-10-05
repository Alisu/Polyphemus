testing
isInACCall

	"Blocked in a system call other than the VM's wait for events: no interrupt reaches it."

	^ self systemCallName notNil and: [ self isWaitingForEvents not ]
