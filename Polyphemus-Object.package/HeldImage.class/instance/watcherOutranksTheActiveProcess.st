private
watcherOutranksTheActiveProcess

	"Whether the process running this moment stays still under the agent; one whose priority
	does not read has nothing against it."

	^ self activeProcessPriority
		  ifNil: [ true ]
		  ifNotNil: [ :priority | priority < PolyphemusAgent watcherPriority ]
