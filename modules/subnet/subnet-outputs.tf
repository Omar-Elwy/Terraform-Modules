// Outputs is like Exporting module attributes to be used from parent module.
// like return values

// This will output the whole object and we refernce it in the parent module with the name we gave to it (subnet)
// module.     (module name that we gave to the module in the parent)    .subent
// Name the output whatever we want..	 
output "subnet" {
    value = aws_subnet.myapp-subnet-1
}
