initialization
computeCaller: aCogStackPage

	caller := OOPAbstractStackFrame
		          newFrameBelow: self
		          starting: (self layout wordAt: framePointer)
		          from: aCogStackPage
		          on: memory
