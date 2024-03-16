resource "docker_image" "chefworkstation" {
  name = "chef/chefworkstation:dev"
  keep_locally = false
  build {
    context = "."
  }
}

resource "docker_container" "chefworkstation" {
  name = "chefworkstation"
  image = docker_image.chefworkstation.image_id
}

output "chefworkstation_container_name" {
    description = "Container Name"
    value = docker_container.chefworkstation.name
}
