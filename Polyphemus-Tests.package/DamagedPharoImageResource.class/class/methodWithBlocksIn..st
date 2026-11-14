building
methodWithBlocksIn: aReading

	"The method around the block the delay scheduler's process runs."

	^ ((aReading contextsOfProcess: (self process: 'DelaySemaphoreScheduler>>suspendAtTimingPriority' in: aReading))
		   detect: [ :each | (aReading descriptionOfContext: each) = 'DelaySemaphoreScheduler>>runBackendLoopAtTimingPriority [block]' ])
		  homeMethod
