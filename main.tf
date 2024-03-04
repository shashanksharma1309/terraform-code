/* #add user in aws 
resource "aws_iam_user" "this_iam" {
  name = "terraform-one"
  path = "/" 
  */

/*  #add tag to the user
  tags = {
    name = "this user is created with the help of terraform"
  }

} */

/* #Add the access key to the User
resource "aws_iam_access_key" "this_iam_access_key" {
  user = aws_iam_user.this_iam.name

} */


/* #Create the Group
resource "aws_iam_group" "this_group" {
  name = "terraform-group-one"

}
 */

/* #Add User & group in Group-Membership 
resource "aws_iam_group_membership" "terraformgroup" {
  name = "terraform-testing-group-memebership"

  users = [
    aws_iam_user.this_iam.name
  ]

  group = aws_iam_group.this_group.name
} */

#creating ec2 instamce in terraform

resource "aws_instance" "this_instance" {
  ami                    = "ami-07d9b9ddc6cd8dd30"
  instance_type          = "t2.micro"
  key_name               = "shank-key"
  vpc_security_group_ids = ["sg-054928d3c08d54dd8"]
  availability_zone      = "us-east-1"
  root_block_device {
    volume_size = 8
  }
  //user_data_base64 = "True" #for bulioan value yes or no

  user_data = <<-EOF
            #!/bin/bash
    sudo -i
    sudo yum update –y
    sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
    sudo yum upgrade
    # Add required dependencies for the jenkins package
    sudo dnf install java-17-amazon-corretto -y
    sudo apt install default-jre -y
    sudo apt install default-jdk -y
    sudo yum install jenkins -y
    sudo systemctl enable jenkins
    systemctl start jenkins
            EOF 
  tags = {
    name = "terraform_shank_new" #instance name
  }
}

#creating security group and adding port no. inbound(ingress) outbound(egress)

resource "aws_security_group" "this_security_group" {
  ingress {
    from_port   = 80 #refer from the terraform doc
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#data block terraform 
