# kojitechs-vpc-module


## Usage
```hcl

module "vpc" {
  source = "" # github url

  vpc_cidr      = "10.0.0.0/16"
  public_cidr   = ["10.0.0.0/24", "10.0.2.0/24", "10.0.4.0/24"]
  private_cidr  = ["10.0.1.0/24", "10.0.3.0/24"]
  database_cidr = ["10.0.5.0/24", "10.0.7.0/24"]
  vpc_tags = {
    Name = "Kojitechs_vpc"
  }
}

```