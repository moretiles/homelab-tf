variable "hosts" {
	type = set(string)
        default = ["hostpi", "oa", "ob"]
}

variable "logging_from" {
	type = set(string)
        default = ["node_exporter", "fluid_bit"]
}

variable "logging_to" {
	type = set(string)
        default = ["prometheus", "loki", "grafana"]
}
