
#key-pair for login

resource aws_key_pair my_key {
    key_name="ssh-terra-key"
    public_key=file("ssh-terra-key.pub")
  
}

#vpc & security group

resource aws_default_vpc default {

}

resource aws_security_group my_security_group{
    name="automate-sg"
    description="Allow SSH and HTTP"
    vpc_id=aws_default_vpc.default.id #interpolation syntax

# inbound rules
ingress{
    from_port=22
    to_port=22
    protocol="tcp"
    cidr_blocks=["0.0.0.0/0"]
    description="SSH access from anywhere"
}

# inbound rules

ingress{
    from_port=80
    to_port=80
    protocol="tcp"
    cidr_blocks=["0.0.0.0/0"]
    description="HTTP access from anywhere"
}

# inbound rules

ingress{
    from_port=8000
    to_port=8000
    protocol="tcp"
    cidr_blocks=["0.0.0.0/0"]
    description="Custom port access from anywhere"

}

#outbound rules

egress{
    from_port=0
    to_port=0
    protocol="-1"
    cidr_blocks=["0.0.0.0/0"]
    description="Allow all outbound traffic"
}

    tags={
        Name="automate-sg"
    }
}

#ec2 instance

resource aws_instance my_instance{

     for_each=tomap({
        automate-instance-1="automate-instance-1"
        automate-instance-2="automate-instance-2"
    })
    depends_on=[aws_security_group.my_security_group,aws_key_pair.my_key]
    key_name=aws_key_pair.my_key.key_name
   
    security_groups=[aws_security_group.my_security_group.name]
    instance_type=var.ec2_instance_type
    ami=var.ec2_ami_id
    user_data=file("install_nginx.sh")

    root_block_device{
        volume_size=var.env=="dev" ? 20 : var.ec2_default_root_storage_size
        volume_type="gp3"
        
    }
    tags={
        Name=each.key
    }
}
