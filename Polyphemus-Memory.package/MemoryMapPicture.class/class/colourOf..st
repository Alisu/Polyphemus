colours
colourOf: aCategory

	^ ({
		   (#nothing -> (Color r: 0.93 g: 0.93 b: 0.93)).
		   (#free -> Color white).
		   (#virtualMachine -> (Color r: 0.45 g: 0.47 b: 0.52)).
		   (#pointers -> (Color r: 0.36 g: 0.56 b: 0.84)).
		   (#words -> (Color r: 0.2 g: 0.66 b: 0.62)).
		   (#bytes -> (Color r: 0.91 g: 0.76 b: 0.36)).
		   (#compiledCode -> (Color r: 0.55 g: 0.35 b: 0.72)).
		   (#pinned -> (Color r: 0.96 g: 0.52 b: 0.16)).
		   (#forwarder -> (Color r: 0.9 g: 0.2 b: 0.7)).
		   (#unreadable -> (Color r: 0.85 g: 0.1 b: 0.1)) } asDictionary) at: aCategory
