// Outputs is like Exporting module attributes to be used from parent module.
// like return values
output "ec2_public_ip" {
    value = module.myapp-server.instance.public_ip
}
