helpers
methodArrayOf: aReifiedMethod

	"The address of the array of methods of the method's class, where a save points it at the new one."

	^ ((aReifiedMethod oopMethodClass reifiedSlotAt: 2) reifiedSlotAt: 2) address
