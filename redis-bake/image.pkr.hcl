variable "aws_access_key" {
  type    = string
  default = ""
}

variable "aws_secret_key" {
  type    = string
  default = ""
}

variable "keypair_name" {
  type    = string
  default = ""
}

variable "key_file" {
  type    = string
  default = ""
}

source "amazon-ebs" "redis_image" {
  access_key           = "${var.aws_access_key}"
  secret_key           = "${var.aws_secret_key}"
  ami_name             = "redis_image"
  instance_type        = "t2.micro"
  region               = "us-east-1"
  source_ami           = "ami-0aa2b7722dc1b5612"
  ssh_keypair_name     = "${var.keypair_name}"
  ssh_private_key_file = "${var.key_file}"
  ssh_username         = "ubuntu"
  tags = {
    Name             = "redis_image"
    Owner            = "julianooen"
    CustomerID       = "ILEGRA"
    Project          = "Tema_final"
    EC2_ECONOMIZATOR = true
  }
}

build {
  sources = ["source.amazon-ebs.redis_image"]

  provisioner "file" {
    source      = "ansible"
    destination = "/home/ubuntu"
  }

  provisioner "shell" {
    inline = [
      "sudo apt-add-repository -y ppa:ansible/ansible",
      "sudo apt update -y",
      "sudo apt install ansible -y",
      "cd /home/ubuntu/ansible",
      "ansible-playbook playbook.yml"
    ]
  }
}