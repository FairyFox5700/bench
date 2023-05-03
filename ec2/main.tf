resource "aws_instance" "scylladb" {
    ami =  "ami-0e8a0f4016294654a"
    instance_type = "i3.large"
    key_name = "scalla-key"
    security_groups = [aws_security_group.scylladbSecurityGroup.name]
    availability_zone = "eu-west-1c"
    count         = 3
    root_block_device {
      delete_on_termination = true
      volume_size  = 30
      volume_type  =  "gp2"
      
    }
    tags = {
        Name = "scylla_node_${count.index}"
    }
}

resource "aws_instance" "cassandradb" {
    ami =  "ami-00aa9d3df94c6c354"
    instance_type = "m3.large"
    key_name = "scalla-key"
    security_groups = [aws_security_group.scylladbSecurityGroup.name]
    availability_zone = "eu-west-1c"
    user_data_base64 = base64encode(file("./scripts/cassandra/cassandra-install.sh"))
    count         = 3
    root_block_device {
      delete_on_termination = true
      volume_size  = 128
      volume_type  =  "gp2"
      
    }
    tags = {
        Name = "cassandra_node_${count.index}"
    }
}

resource "aws_instance" "benchmark_client" {
    ami =  "ami-00aa9d3df94c6c354"
    instance_type = "t2.small"
    key_name = "scalla-key"
    security_groups = [aws_security_group.scylladbSecurityGroup.name]
    availability_zone = "eu-west-1c"
    user_data_base64 = base64encode(file("./scripts/client-setup.sh"))
    root_block_device {
      delete_on_termination = true
      volume_size  = 16
      volume_type  =  "gp2"
      
    }
    tags = {
        Name = "benchmark client"
    }
}


resource "aws_cloudwatch_log_group" "example" {
  name = "example-logs"
}

resource "aws_cloudwatch_log_stream" "example" {
  name           = "example-stream"
  log_group_name = aws_cloudwatch_log_group.example.name
}

