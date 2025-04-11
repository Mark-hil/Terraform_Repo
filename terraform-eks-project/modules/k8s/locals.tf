#####################################
# Local Variables
#####################################
locals {
  # Standard ports
  ports = {
    # HTTP ports
    http = {
      container = 80
      service   = 80
    }
    # Application ports
    app = {
      container = 80
      service   = 80
    }
    # Health check ports
    health = {
      container = 80
      service   = 80
    }
  }
}
