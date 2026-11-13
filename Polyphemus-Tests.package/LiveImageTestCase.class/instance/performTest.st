running
performTest

	"A target that ended under a test: the failure says what its log holds, a crash or nothing (#190)."

	^ self sayingHowTheTargetEnded: [ super performTest ]
