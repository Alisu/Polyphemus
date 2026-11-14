tests
testAContextWhoseReceiverPointsNowhereIsDescribedSoAndItsStackGoesOn

	"#118: read through the handler of its description."

	| contexts damaged |
	contexts := self contextsOf: 'AtomicSharedQueue>>waitForNewItems'.
	damaged := contexts at: 3.

	self should: [ damaged receiver ] raise: NotInTheReading.
	self assert: (reifiedMemory descriptionOfContext: damaged) equals: 'an unreadable object>>privateNextTask'.
	self assert: (reifiedMemory stacks stackDescriptionOfProcess:
			 (DamagedPharoImageResource process: 'AtomicSharedQueue>>waitForNewItems' in: reifiedMemory)) size equals: 8.
	self assert: (reifiedMemory descriptionOfContext: (contexts at: 4)) equals: 'TKTWorkerProcess>>workerLoop [block]'
