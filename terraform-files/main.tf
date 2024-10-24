resource "aws_instance" "project-server" {
  ami = "ami-00385a401487aefa4"
  instance_type = "t2.micro"
  key_name = "LinuxVM"
  vpc_security_group_ids = ["sg-0aff9e988488002e3"]
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
     Name = "project-server"
     }
  provisioner "local-exec" {
     command = "echo ${aws_instance.test-server.public_ip} > inventory"
     }
  provisioner "local-exec" {
     command = "ansiblePlaybook credentialsId: 'terraform-ansible', disableHostKeyChecking: true, installation: 'ansible', inventory: 'inventory', playbook: 'ansibleplaybook.yml', vaultTmpPath: ''"
     }
  }
