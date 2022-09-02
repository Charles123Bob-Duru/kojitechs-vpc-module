variable "vpc_cidr" {
  description = "vpc_cidr"
  type        = string

}

variable "public_cidr" {
  description = "cidr for public subnet"
  type        = list(any)
}

variable "private_cidr" {
  description = "cidr for private subnet"
  type        = list(any)
}

variable "database_cidr" {
  description = "cidr for database subnet"
  type        = list(any) # array
} 

# Optional
variable "vpc_tags" {
    description = "vpc tag"
    type = map(string) # map(dict)
    default = {}
}