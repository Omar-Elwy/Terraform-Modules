// Modules are like functions in programming.
// We parameratize all the the variables of VPC cause the VPC resource is in the main terraform config file
// So we are refecing the values from here..

resource "aws_default_security_group" "default-sg" {
    vpc_id = var.vpc_id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.my_ip]
    }

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        prefix_list_ids = []
    }

    tags = {
        Name = "${var.env_prefix}-default-sg"
    }
}

data "aws_ami" "latest-amazon-linux-image" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = [var.image_name]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}

resource "aws_key_pair" "ssh-key" {
    key_name = "server-key"
    public_key = file(var.public_key_location)
}

resource "aws_instance" "myapp-server" {
     // we alrady have this resource availabe here so we dont need to parametarize it..
    ami = data.aws_ami.latest-amazon-linux-image.id   
    instance_type = var.instance_type

    subnet_id = var.subnet_id
   // we alrady have this resource availabe here so we dont need to parametarize it..
    vpc_security_group_ids = [aws_default_security_group.default-sg.id]
    availability_zone = var.avail_zone

    associate_public_ip_address = true
   // we alrady have this resource availabe here so we dont need to parametarize it..
    key_name = aws_key_pair.ssh-key.key_name

    user_data = file("entry-script.sh")

    tags = {
        Name = "${var.env_prefix}-server"
    }
}
