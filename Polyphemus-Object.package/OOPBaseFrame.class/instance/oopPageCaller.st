accessing
oopPageCaller

	"The context that called into this page, kept where other frames keep the saved IP. nil
	for the first activation of a process."

	^ memory objectAt:
		  (memory interpreter stackPages longAt: self offsetForCallerContext)
