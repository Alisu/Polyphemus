contexts
contextSenderSlot

	"VMMaker calls this one SenderIndex and indexes it from zero. In a snapshot it
	holds a context or nil: the VM divorced every frame before writing the image. A
	small integer here is a frame pointer, which only a live memory can resolve."

	^ 1
