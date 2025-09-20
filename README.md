# Deploying a Java Application On AWS EC2 Instance using Terraform 

## Terraform steps
```shell
cd Terraform
terraform init
terraform plan
terraform apply
terraform destroy
```

## Clone the Repo on EC2 Instance
```shell
git clone https://github.com/Trainings-TechEazy/test-repo-for-devops.git
```

## Install Java
```
sudo apt install openjdk-17-jre-headless
// Used 17 because dependencies in the pom.xml were accepting java-17 version.
```

## Build & Start it
```shell
mvn clean package
java -jar target/hellomvc-0.0.1-SNAPSHOT.jar
```

## Outputs
## Java Version
![Java_version](./images\java-version.png)

## Build Report
![Build_report](./images\build.png)

## Final result
![Final_result](./images\after_deployed.png)
