
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

source "amazon-ebs" "ami_elk" {
  access_key           = "${var.aws_access_key}"
  secret_key           = "${var.aws_secret_key}"
  ami_name             = "ami_elk"
  instance_type        = "t2.medium"
  region               = "us-east-1"
  source_ami           = "ami-0aa2b7722dc1b5612"
  ssh_keypair_name     = "${var.keypair_name}"
  ssh_private_key_file = "${var.key_file}"
  ssh_username         = "ubuntu"
  launch_block_device_mappings {
    device_name = "/dev/sda1"
    volume_size = 15
    volume_type = "gp2"
    delete_on_termination = true
  }
  tags = {
    Name             = "ami_elk"
    Owner            = "julianooen"
    CustomerID       = "ILEGRA"
    Project          = "FinalDevOps"
    EC2_ECONOMIZATOR = true
  }
}

build {
  sources = ["source.amazon-ebs.ami_elk"]

  provisioner "file" {
    source      = "minikube/"
    destination = "/home/ubuntu"
  }

  provisioner "file" {
    source      = "ansible/"
    destination = "/home/ubuntu"
  }

  provisioner "shell" {
    inline = [
      "sudo apt-add-repository -y ppa:ansible/ansible",
      "sudo apt update -y",
      "sudo apt install ansible -y",
      "ansible-playbook /home/ubuntu/playbook.yml",
    ]
  }
}