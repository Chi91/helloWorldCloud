variable "region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = "eu-central-1"
}

variable "name" {
  description = "VPC Name"
  type        = string
  default     = "my-vpc"
}

variable "cidr" {
  description = "VPC CIDR Block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "asz" {
  description = "A list of availability zones names"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b"]
}

variable "public_subnets" {
  description = "A list of public subnets inside VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "A list of private subnets inside VPC"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateways for each private subnets"
  type        = bool
  default     = true
}

variable "create_igw" {
  description = "Controls if an Internet Gateway is created for public subnets and the related routes that connect them"
  type        = bool
  default     = true
}
variable "map_public_ip_on_launch" {
  description = "Assign a public IP address for instances launched into the Public subnet "
  type        = bool
  default     = true
}

variable "cluster_name" {
  description = "Cluster name"
  type        = string
  default     = "cluster"
}

variable "ami_type" {
  description = "Defining the operating system, application server, and other software configurations of EC2 instance"
  type        = string
  default     = "ami-08ec94f928cf25a9d"
}

variable "instance_types" {
  description = "Define the compute capacity of an EC2 instance"
  type        = list(string)
  default     = ["t2.micro"]
}