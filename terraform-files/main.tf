resource "aws_instance" "test-server" {
  ami = "ami-050cd642fd83388e4"
  instance_type = "t2.micro"
  key_name = "LinuxVM"
  vpc_security_group_ids = ["sg-054c1f15f491ba8e2"]
  connection {
     type = "ssh"
     user = "ec2-user"
     private_key = file("./LinuxVM.pem")
     host = self.public_ip
     }
  provisioner "remote-exec" {
     inline = ["echo 'wait to start the instance' "]
  }
  tags = {
     Name = "test-server"
     }
  provisioner "local-exec" {
     command = "echo ${aws_instance.test-server.public_ip} > inventory"
     }
  provisioner "local-exec" {
     command = "ansible-playbook /var/lib/jenkins/workspace/BankingProject/terraform-files/ansibleplaybook.yml"
     }
  }
