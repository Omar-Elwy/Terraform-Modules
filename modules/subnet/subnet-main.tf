// Modules are like functions in programming.

// We parameratize all the the variables of VPC cause the VPC resource is in the main terraform config file
// So we are refecing the values from here..
resource "aws_subnet" "myapp-subnet-1" {
    vpc_id = var.vpc_id
    cidr_block = var.subnet_cidr_block
    availability_zone = var.avail_zone
    tags = {
        Name = "${var.env_prefix}-subnet-1"
    }
}

resource "aws_internet_gateway" "myapp-igw" {
    vpc_id = var.vpc_id
    tags = {
        Name = "${var.env_prefix}-igw"
    }
}

resource "aws_default_route_table" "main-rtb" {
    default_route_table_id = var.default_route_table_id

    route {
        cidr_block = "0.0.0.0/0"
        // we alrady have this resource availabe here so we dont need to parametarize it..
        gateway_id = aws_internet_gateway.myapp-igw.id  
    }
    tags = {
        Name = "${var.env_prefix}-main-rtb"
    }
}
