accessing
stacksOf: aMemory

	"Every process of this memory as its name -> how many activations its stack holds. A bag:
	an image holds several processes of the same name, and a dump more."

	^ aMemory allReifiedProcesses
		  inject: Bag new
		  into: [ :all :process |
			  all
				  add: ([ (process reifiedSlotAt: 5) asString ] on: Error do: [ :e | 'unnamed' ])
					  -> ([ (aMemory activationsOfProcess: process) size ] on: Error do: [ :e | -1 ]);
				  yourself ]
