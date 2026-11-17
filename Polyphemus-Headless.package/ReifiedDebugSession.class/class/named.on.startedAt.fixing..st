instance creation
named: aString on: aProcess startedAt: aContext fixing: aMethodFix

	"A session on a stack that is being read, which can also write what is accepted."

	^ (self named: aString on: aProcess startedAt: aContext)
		  fix: aMethodFix;
		  yourself
