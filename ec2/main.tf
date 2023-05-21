resource "aws_instance" "scylladb" {
  ami           = var.scylla_ami_id
  instance_type = var.scylla_instance_type
  key_name      = var.scylla_key_name
  security_groups = [var.scylla_security_group]
  availability_zone = var.scylla_availability_zone
  count         = var.scylla_instance_count

  root_block_device {
    delete_on_termination = true
    volume_size           = var.scylla_root_volume_size
    volume_type           = var.scylla_root_volume_type
  }

  tags = merge(
    var.scylla_instance_tags,
    {
      Name = "scylla_node_${count.index}"
    }
  )
}

resource "aws_instance" "cassandradb" {
  ami                  = var.cassandra_ami_id
  instance_type        = var.cassandra_instance_type
  key_name             = var.cassandra_key_name
  security_groups      = [var.cassandra_security_group]
  availability_zone    = var.cassandra_availability_zone
  user_data_base64     = var.cassandra_user_data_base64
  count                = var.cassandra_instance_count

  root_block_device {
    delete_on_termination = true
    volume_size           = var.cassandra_root_volume_size
    volume_type           = var.cassandra_root_volume_type
  }

  tags = merge(
    var.cassandra_instance_tags,
    {
      Name = "cassandra_node_${count.index}"
    }
  )
}

resource "aws_instance" "benchmark_client" {
  ami                  = var.client_ami_id
  instance_type        = var.client_instance_type
  key_name             = var.client_key_name
  security_groups      = [var.client_security_group]
  availability_zone    = var.client_availability_zone
  user_data_base64     = var.client_user_data_base64

  root_block_device {
    delete_on_termination = true
    volume_size           = var.client_root_volume_size
    volume_type           = var.client_root_volume_type
  }

  tags = var.client_instance_tags
}


resource "aws_cloudwatch_log_group" "example" {
  name = var.log_group_name
}

resource "aws_cloudwatch_log_stream" "example" {
  name           = var.log_stream_name
  log_group_name = aws_cloudwatch_log_group.example.name
}

