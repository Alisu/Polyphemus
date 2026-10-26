targets
pulse

	"A process of the target's own writing how many times it woke to the file pulse, every 50 ms:
	whether the image as a whole runs on, not only what a test held. Not the VM's heartbeat."

	^ '[ | b | b := 0.
  [ b := b + 1.
    ' , (self writing: 'b' as: 'pulse') , '
    (Delay forMilliseconds: 50) wait ] repeat ] forkAt: 40.
'
