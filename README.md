ndoch-trademark-challenge
=========================

Applications built for the National Day of Civic Hacking's USPTO Trademarks Challenge


---
##Setup

#### 1. Create a new EC2 Security Group

- [Amazon has a great walkthrough][1]
- Port 7474 should be open (Neo4j access)
    - In production you might want to change this! 
- Port 22 should be open (SSH Access)

#### 2. Create and download an EC2 keypair
	
- You can only download this once, and instances are locked to a key, be careful!

#### 3. Install Ansible on your local machine

- Use your package manager or [download directly from Ansible][2]

#### 4. Install the Neography gem

> sudo gem install neography

##Launch and Configure Server

#### 1. Launch an EC2 instance

- We used a 64 Bit Ubuntu 13.04 (ami-c30360aa), with a size of m1.large

#### 2. Set IP to target in Ansible

>etc/ansible/hosts
 
- Add the following lines

    >[neo4j]               
    >YOUR_EC2_INSTANCE_IP

#### 3. Run Ansible
	
>ansible-playbook deploy/deploy_neo4j.yml -vv --private-key=/path/to/ec2/pri/key

##Load Data into Neo4j
#### 1. Configure the helper script
	
>rosetta/neo4j_helper.rb
	
- Set config.server to the EC2 instance's IP 

#### 2. Run the loading script
	
>ruby rosetta/load.rb

---

####Quick fixes
- Make sure the EC2 private key has permissions for only the current user!

[1]: http://docs.aws.amazon.com/gettingstarted/latest/wah/getting-started-security-group.html
[2]: http://ansible.cc/

