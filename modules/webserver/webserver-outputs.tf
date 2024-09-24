// Outputs is like Exporting module attributes to be used from parent module.
// like return value
output "instance" {
    value = aws_instance.myapp-server
}
