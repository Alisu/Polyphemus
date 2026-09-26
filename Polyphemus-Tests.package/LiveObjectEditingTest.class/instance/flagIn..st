helpers
flagIn: aSession

	"Reached as in an inspector, through the block timesRepeat: runs, which copied it."

	^ ((aSession interruptedContext findContextSuchThat: [ :each | each selector = #timesRepeat: ])
		   tempNamed: 'aBlock') reifiedSlotAt: 5
