tools
stack: someArguments

	| image reified process number activations rows |
	image := self imageAt: someArguments.
	reified := self reifiedOf: image.
	number := someArguments at: 'process' ifAbsent: [ self error: 'stack needs the number of a process, as processes answers it' ].
	process := (self processesOf: image) at: number ifAbsent: [
		           self error: 'No process ' , number printString , ' in ' , (someArguments at: 'handle') , '; processes lists them' ].
	activations := reified activationsOfProcess: process.
	rows := ((activations first: (((someArguments at: 'depth' ifAbsent: [ 20 ]) max: 1) min: activations size)) withIndexCollect: [ :each :i |
		         self rowOfFrame: each numbered: i ]) asArray.
	^ self
		  text: (String lf join: (rows collect: [ :each | self lineOfFrame: each ]))
		  structured: (Dictionary new
				   at: 'process' put: number;
				   at: 'depth' put: activations size;
				   at: 'frames' put: rows;
				   yourself)
