running
memoryReadThrough: aLayout

	"The reading as it reads, but for its layout."

	^ (DefectiveReadDouble of: reifiedMemory) when: #vmLayout answer: [ aLayout ]
