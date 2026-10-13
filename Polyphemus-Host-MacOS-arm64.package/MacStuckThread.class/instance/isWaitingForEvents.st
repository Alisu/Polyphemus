testing
isWaitingForEvents

	^ MacStuckReport eventWaits includes: self systemCallName
