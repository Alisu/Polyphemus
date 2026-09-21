installing
allocateLike: aReifiedMethod for: aCompilation

	"Room for the new code, in an object of the class the old method has."

	^ self
		  allocate: aCompilation
		  classIndex: (memory classIndexOf: aReifiedMethod address)
