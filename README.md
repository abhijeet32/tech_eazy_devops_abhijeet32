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
![Java_version](https://github.com/abhijeet32/tech_eazy_devops_abhijeet32/blob/main/images/java-version.png)

## Build Report
![Build_report](https://github.com/abhijeet32/tech_eazy_devops_abhijeet32/blob/main/images/build.png)

## Final result
![Final_result](https://github.com/abhijeet32/tech_eazy_devops_abhijeet32/blob/main/images/after_deployed.png)
