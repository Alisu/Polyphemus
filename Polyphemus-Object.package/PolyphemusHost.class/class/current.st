instance creation
current

	"The host this image runs on."

	^ self pharo: SystemVersion current major os: self currentOS cpu: self currentCPU
