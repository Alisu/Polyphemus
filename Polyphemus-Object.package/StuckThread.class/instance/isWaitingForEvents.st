testing
isWaitingForEvents

	^ StuckReport eventWaits includes: self systemCallName
