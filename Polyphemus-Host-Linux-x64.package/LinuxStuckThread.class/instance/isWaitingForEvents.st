testing
isWaitingForEvents

	^ LinuxStuckReport eventWaits includes: self systemCallName
