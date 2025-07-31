resource "aws_instance" "test_poc" {
  ami                         = "ami-02eb7a4783e7e9317"
  instance_type               = "t2.medium"
  key_name                    = "KEY-PAIR-POC"
  subnet_id                   = "subnet-0c10b167ed2ac1307"
  vpc_security_group_ids      = ["sg-02fbc5cfbc10f52ef"]
  associate_public_ip_address = true

  tags = {
    Name = "Test-POC"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for instance to become ready...'",
      "sleep 60",
      "echo 'Instance ready.'"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("./KEY-PAIR-POC.pem")
      host        = self.public_ip
    }
  }
}

output "test_server_ip" {
  description = "Public IP of the Test POC EC2 instance"
  value       = aws_instance.test_poc.public_ip
}
