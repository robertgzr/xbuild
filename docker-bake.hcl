variable "REPO" {
	default = "docker.io/robertgzr/xbuild"
}

group "default" {
	targets = ["arm", "aarch64"]
}

target "arm" {
	target = "arm"
	output = [ "type=docker" ]
	tags = [ "${REPO}:arm" ]
}

target "aarch64" {
	target = "aarch64"
	output = [ "type=docker" ]
	tags = [ "${REPO}:aarch64" ]
}
