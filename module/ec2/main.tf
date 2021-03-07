
data "aws_ami" "amazon" {
  most_recent = true

  filter {
      name   = "name"
      values = var.ami_data_filter
  }
  owners = ["amazon"]
}



resource "aws_instance" "web" {
  ami             = data.aws_ami.amazon.id
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = var.ec2_security_groups
  count           = var.instance_count
  subnet_id       = "${element(var.subnet_id, count.index)}"
  
  connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = "${self.public_ip}"
      private_key = file("<key_name>.pem")
   }


  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras enable nginx1.12",
      "sudo yum -y install nginx ",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx",
    ]
  }
  tags = {
    Name = "${var.tags}-${count.index}"
  }
}

#resource "null_resource" "example_provisioner" {



#depends_on = [ aws_instance.web ]

#}



/*
#for loop instance creation
resource "aws_instance" "web_for" {
  ami           = data.aws_ami.amazon.id
  for_each  = {
    prod = "t2.small"
    dev = "t2.micro"
  }

  instance_type = each.value
  tags = {
    Name = "HelloWorld ${each.key}"
  }
}

#provider using alias
resource "aws_instance" "web_east" {
  provider      = aws.east
  ami           = data.aws_ami.amazon.id
  instance_type = var.instance_type
  count         = 1

  tags = {
    Name = "HelloWorld east"
  }
}

*/