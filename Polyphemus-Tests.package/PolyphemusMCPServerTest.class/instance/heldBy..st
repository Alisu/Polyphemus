running
heldBy: aSession

	"The handle of a held image whose debug session is aSession, a double."

	^ self server open: (PolyphemusMCPReading held: 1 session: aSession) as: 'held'