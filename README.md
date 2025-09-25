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
![Java_version](/images/java-version.png)

## Build Report
![Build_report](/images/build.png)

## Final result
![Final_result](/images/after_deployed.png)

## Created IAM Role & S3 Bucket
+ For ReadOnly and uploading logs
+ A S3 bucket

## Automated log
![Automated_log](/images/automated_log.png)

## Generated and uploaded a log file
```sh
ssh -i demo_12.pem ec2-user@<EC2_PUBLIC_IP>
echo "This is a test log" > /tmp/test.log
aws s3 cp /tmp/test.log s3://<your_bucket_name>/logs/
```

## Uploaded result
![uploaded_log](/images\uploaded-log.png)