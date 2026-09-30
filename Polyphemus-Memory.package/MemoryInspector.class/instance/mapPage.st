initialization
mapPage

	"Drawn when its tab is opened (#68)."

	^ (SpNotebookPage
		   title: 'Memory map'
		   icon: (self iconNamed: #nautilusIcon)
		   provider: [
			   (MemoryMapPresenter on: interpreter objectMemory)
				   reifiedMemory: reifiedMemory;
				   yourself ])
		  beCloseable;
		  yourself
