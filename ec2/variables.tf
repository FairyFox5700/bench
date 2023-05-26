variable "scylla_ami_id" {
  description = "AMI ID for the ScyllaDB instances"
  default     = "ami-0e8a0f4016294654a"
}

variable "scylla_instance_type" {
  description = "Instance type for the ScyllaDB instances"
  default     = "i3.large"
}

variable "scylla_key_name" {
  description = "Key name for SSH access to the ScyllaDB instances"
  default     = "scalla-key"
}

variable "scylla_availability_zone" {
  description = "Availability zone for the ScyllaDB instances"
  default     = "eu-west-1c"
}

variable "scylla_instance_count" {
  description = "Number of ScyllaDB instances to create"
  default     = 3
}

variable "scylla_root_volume_size" {
  description = "Size of the root volume for the ScyllaDB instances"
  default     = 30
}

variable "scylla_root_volume_type" {
  description = "Type of the root volume for the ScyllaDB instances"
  default     = "gp2"
}

variable "scylla_instance_tags" {
  description = "Tags for the ScyllaDB instances"
  default     = {}
}

variable "cassandra_ami_id" {
  description = "AMI ID for the Cassandra instances"
  default     = "ami-00aa9d3df94c6c354"
}

variable "cassandra_instance_type" {
  description = "Instance type for the Cassandra instances"
  default     = "m3.large"
}

variable "cassandra_key_name" {
  description = "Key name for SSH access to the Cassandra instances"
  default     = "scalla-key"
}

variable "cassandra_availability_zone" {
  description = "Availability zone for the Cassandra instances"
  default     = "eu-west-1c"
}

variable "cassandra_instance_count" {
  description = "Number of Cassandra instances to create"
  default     = 3
}

variable "cassandra_root_volume_size" {
  description = "Size of the root volume for the Cassandra instances"
  default     = 128
}

variable "cassandra_root_volume_type" {
  description = "Type of the root volume for the Cassandra instances"
  default     = "gp2"
}

variable "cassandra_instance_tags" {
  description = "Tags for the Cassandra instances"
  default     = {}
}


variable "client_ami_id" {
  description = "AMI ID for the benchmark client instance"
  default     = "ami-00aa9d3df94c6c354"
}

variable "client_instance_type" {
  description = "Instance type for the benchmark client instance"
  default     = "t2.small"
}

variable "client_key_name" {
  description = "Key name for SSH access to the benchmark client instance"
  default     = "scalla-key"
}

variable "client_availability_zone" {
  description = "Availability zone for the benchmark client instance"
  default     = "eu-west-1c"
}

variable "client_root_volume_size" {
  description = "Size of the root volume for the benchmark client instance"
  default     = 16
}

variable "client_root_volume_type" {
  description = "Type of the root volume for the benchmark client instance"
  default     = "gp2"
}

variable "client_instance_tags" {
  description = "Tags for the benchmark client instance"
  default     = {
    Name = "benchmark client"
  }
}

variable "log_group_name" {
  description = "Name of the CloudWatch Log Group"
  default     = "example-logs"
}

variable "log_stream_name" {
  description = "Name of the CloudWatch Log Stream"
  default     = "example-stream"
}

variable "key_pair_name" {
  description = "Name of the key pair"
  default     = "scalla-key"
}

variable "private_key_algorithm" {
  description = "Algorithm for the private key"
  default     = "RSA"
}

variable "private_key_rsa_bits" {
  description = "Number of bits for the RSA private key"
  default     = 4096
}

variable "private_key_file_name" {
  description = "Filename for the private key file"
  default     = "scalla-key"
}

variable "security_group_name" {
  description = "Name for the security group"
  default     = "scylla-db-security-group"
}
