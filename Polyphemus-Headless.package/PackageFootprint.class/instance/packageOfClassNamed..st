accessing
packageOfClassNamed: aClassName

	^ packageOfClass at: aClassName ifAbsent: [ nil ]
