holding it still
wouldNotStop

	"Refuse to read: the process was asked to stop and did not, so nothing read of it would hold."

	^ (SpurCannotRead new level: #bytes reason: #itWouldNotStop) signal
