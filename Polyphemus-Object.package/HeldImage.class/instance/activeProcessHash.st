private
activeProcessHash

	"The process running this moment, named by an identity hash in the stop that caught it. Call
	it stopped."

	^ HeldProcess identityHashOfObjectAt: self activeProcessAddress in: (SpurWritableProcess on: reader)
