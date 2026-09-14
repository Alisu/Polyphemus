"Build warm.image: dev.image with the interpreted fixture already in place, so test
 processes skip loading a 60MB image into the simulator (~20s per class that needs it)."
[ | t |
  t := StackPageReificationTest new.
  StackPageReificationTest currentImage availableFor: t.
  ('fixture ready: ', StackPageReificationTest currentImage name) traceCr ]
	on: Error
	do: [ :e | ('WARM ERR ', e class name, ' :: ', e messageText asString) traceCr ].
Smalltalk snapshot: true andQuit: true
