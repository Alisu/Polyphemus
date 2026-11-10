accessing
heartbeatEvery

	"Well under the agent's silence limit (#163)."

	^ HeartbeatEvery ifNil: [ 5 seconds ]
