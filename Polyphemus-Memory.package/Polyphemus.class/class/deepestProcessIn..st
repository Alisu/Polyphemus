tools
deepestProcessIn: aReifiedMemory

	"The process with the most to show. Most processes are a single context waiting on a
	semaphore, and the one that was running when a dump was taken has no contexts at all --
	its stack was frames -- so picking one at random usually shows nothing."

	^ aReifiedMemory allReifiedProcesses detectMax: [ :each |
		  ([ aReifiedMemory contextsOfProcess: each ]
			   on: Error
			   do: [ :e | #(  ) ]) size ]
