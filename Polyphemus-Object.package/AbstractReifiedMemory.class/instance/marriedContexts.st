contexts
marriedContexts

	"Contexts whose remaining stack we cannot see, because they are married to a
	frame. Loading an image marries the running process' context, so expect one."

	^ (self allReifiedProcesses
		   inject: OrderedCollection new
		   into: [ :all :process | all addAll: (self contextsOfProcess: process); yourself ])
		  select: [ :context | self isMarriedContext: context ]
