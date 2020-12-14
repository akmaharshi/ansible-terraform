variable "ami" {
    default = "ami-0470e33cd681b2476"
}

variable "vpc_id" {
    default = "vpc-3c893657"
}

variable "subnet1" {
    default = "subnet-8c56f1e7"
}

variable "subnet2" {
    default = "subnet-854e0ac9"
}
variable "subnet3" {
    default = "subnet-0abba670"
}

variable "instance_type" {
  default = "t2.micro"
}



variable "availability_zone" {
    type = "list"
    default = ["ap-south-1a",
                "ap-south-1b",
                "ap-south-1c"
            ]
  
}


variable "myprofile" {
  description = "MyProfile Information"
  default     = "task"
}

variable "aws_region" {
  default = "us-east-2"
}
