tests
testSchedulerAndActiveProcessAreTheRealClasses

	"The same structural walk that works on the candle bootstrap must work here,
	where the classes carry their usual names."

	self assert: reifiedMemory reifiedScheduler oopClassName equals: 'ProcessorScheduler'.
	self assert: reifiedMemory reifiedActiveProcess oopClassName equals: 'Process'
