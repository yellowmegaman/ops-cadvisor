job "cadvisor" {
  datacenters = ["[[env "DC"]]"]
  type = "system"
  group "cadvisor" {
    task "cadvisor" {
      artifact {
        source = "https://github.com/google/cadvisor/releases/download/v[[.cadvisor.version]]/cadvisor"
        options {
          archive = false
        }
      }
      driver = "raw_exec"
      config {
        command = "cadvisor"
        args    = ["-port", "[[.cadvisor.port]]"]
      }
      resources {
        cpu    = [[.cadvisor.cpu]]
        memory = [[.cadvisor.ram]]
        network {
          mbits = 10
          port "healthcheck" { static = [[.cadvisor.port]] }
        }
      }
      service {
        name = "cadvisor"
        tags = ["[[.cadvisor.version]]"]
        port = "healthcheck"
        check {
          name     = "alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
