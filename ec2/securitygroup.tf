

resource "aws_security_group" "scylladbSecurityGroup" {
    description = "scyla db security group"
    name        = var.security_group_name
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 7199
        protocol = "tcp"
        to_port = 7199
    }
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 7001
        protocol = "tcp"
        to_port = 7001
    }
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 22
        protocol = "tcp"
        to_port = 22
    }
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 19042
        protocol = "tcp"
        to_port = 19042
    }
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 10000
        protocol = "tcp"
        to_port = 10000
    }
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 9160
        protocol = "tcp"
        to_port = 9160
    }
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 7000
        protocol = "tcp"
        to_port = 7000
    }
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 0
        protocol = "tcp"
        to_port = 0
    }
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 9180
        protocol = "tcp"
        to_port = 9180
    }
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 9142
        protocol = "tcp"
        to_port = 9142
    }
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 9100
        protocol = "tcp"
        to_port = 9100
    }
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 19142
        protocol = "tcp"
        to_port = 19142
    }
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 9042
        protocol = "tcp"
        to_port = 9042
    }
    egress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 0
        protocol = "-1"
        to_port = 0
    }
}

