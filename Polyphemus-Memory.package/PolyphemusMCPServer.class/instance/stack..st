tools
stack: someArguments

	| image reified process number activations rows ends |
	image := self imageAt: someArguments.
	reified := self reifiedOf: image.
	number := someArguments at: 'process' ifAbsent: [ ToolCallFailed signal: 'stack needs the number of a process, as processes answers it' ].
	process := (self processesOf: image) at: number ifAbsent: [
		           ToolCallFailed signal: 'No process ' , number printString , ' in ' , (someArguments at: 'handle') , '; processes lists them' ].
	activations := reified activationsOfProcess: process.
	ends := reified stacks whyTheStack: activations endsForProcess: process.
	rows := ((activations first: (((someArguments at: 'depth' ifAbsent: [ 20 ]) max: 1) min: activations size)) withIndexCollect: [ :each :i |
		         self rowOfFrame: each numbered: i ]) asArray.
	^ self
		  text: (String lf join: (rows collect: [ :each | self lineOfFrame: each ])
				   , (ends ifNil: [ #(  ) ] ifNotNil: [ { ('the stack ends after frame ' , activations size printString , ': ' , ends) } ]))
		  structured: (Dictionary new
				   at: 'process' put: number;
				   at: 'depth' put: activations size;
				   at: 'frames' put: rows;
				   at: 'ends' put: ends;
				   yourself)
