// Modules are like functions in programming.
provider "aws" {
    region = "eu-west-3"
}

resource "aws_vpc" "myapp-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name = "${var.env_prefix}-vpc"
    }
}
# values are defind in .tfvars file > set as values in variables.tf file in root > values are passed to chide module as argument >
                                                                   # Via variables.tf file in the child module.
// Name the module whatever we want..
module "myapp-subnet" {
    // (.) means current directory.. then we specify the path.
    source = "./modules/subnet"
    subnet_cidr_block = var.subnet_cidr_block
    avail_zone = var.avail_zone
    env_prefix = var.env_prefix
    // We are refercing these two direct from the VPC resource cause they are together in the same config file.    
    vpc_id = aws_vpc.myapp-vpc.id
    default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
}
// Name the module whatever we want..
module "myapp-server" {
    source = "./modules/webserver"
    vpc_id = aws_vpc.myapp-vpc.id
    my_ip = var.my_ip
    env_prefix = var.env_prefix
    image_name = var.image_name
    public_key_location = var.public_key_location
    instance_type = var.instance_type
    // module.     (module name that we gave to the module in the parent)    .subent
    subnet_id = module.myapp-subnet.subnet.id
    avail_zone = var.avail_zone
}
