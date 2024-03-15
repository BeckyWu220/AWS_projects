# Analyze Cloudfront Access Log with EMR

### Objectives
1. Launch a Hadoop cluster using EMR.
2. Write HiveQL script to process log data stored in S3 bucket, and write results to another S3 bucket.

### Data
Sample Cloudfront Access Log. 

A log record looks like:
```
2014-07-05	20:00:00	LHR3	4260	10.0.0.15	GET	eabcd12345678.cloudfront.net	/test-image-1.jpeg	200	-	Mozilla/5.0%20(MacOS;%20U;%20Windows%20NT%205.1;%20en-US;%20rv:1.9.0.9)%20Gecko/2009040821%20IE/3.0.9
```
The record contains creation date, timestamp, payload size, viewer IP, request method, etc.

### Prerequisites
1. Sample Cloudfront Access Log is stored in a S3 bucket, referred as "Source Bucket" the context below.
2. Another S3 bucket created to store processed data, which is referred as "Target Bucket".

### Key Steps
#### Create a Hadoop Cluster
1. Create a Cluster in EMR with Custom Application bundle, where Hadoop, Hive, Hue and Pig is installed.

2. Configure the Cluster with "Uniform Instance Groups" and choose an EC2 instance type for Primary, Core and Task nodes. 
	
	Here I selected "m4.large" for all nodes and made the group with size of 1. 
	
3. Configure VPC, Subnet and Security Groups for the Cluster, and EC2 key pair for SSH to the Cluster.

4. Set IAM for EMR Service Role, and Instance Profile for EC2 instances in the Cluster.

#### Write Hive Script
```
-- Summary: This sample shows you how to analyze CloudFront logs stored in S3 using Hive

-- Create table using sample data in S3.  Note: you can replace this S3 path with your own.
CREATE EXTERNAL TABLE IF NOT EXISTS cloudfront_logs (
  DateObject Date,
  Time STRING,
  Location STRING,
  Bytes INT,
  RequestIP STRING,
  Method STRING,
  Host STRING,
  Uri STRING,
  Status INT,
  Referrer STRING,
  OS String,
  Browser String,
  BrowserVersion String
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
WITH SERDEPROPERTIES (
  "input.regex" = "^(?!#)([^ ]+)\\s+([^ ]+)\\s+([^ ]+)\\s+([^ ]+)\\s+([^ ]+)\\s+([^ ]+)\\s+([^ ]+)\\s+([^ ]+)\\s+([^ ]+)\\s+([^ ]+)\\s+[^\(]+[\(]([^\;]+).*\%20([^\/]+)[\/](.*)$"
) LOCATION '${INPUT}/cloudfront/data';

-- Total requests per operating system for a given time frame
INSERT OVERWRITE DIRECTORY '${OUTPUT}/os_requests/' SELECT os, COUNT(*) count FROM cloudfront_logs WHERE dateobject BETWEEN '2014-07-05' AND '2014-08-05' GROUP BY os;
```
- Creates a Hive table named “cloudfront_logs”
- Reads the log files from source bucket and parses the files using the regular expression Serializer/Deserializer(RegEx SerDe) to extract the necessary fields. 
- Writes the parsed results to the Hive table. 
- Submits a HiveQL against the data to retrieve the total number of requests grouped by OS for a given time frame.
- Writes the query results to target bucket as output.

Upload the Hive Script to S3 and get the S3 location of your Hive script.

#### Add a Step for the Cluster to process log data with Hive script.
1. Add a Step of Hive Program Type, fill in the Hive script location, source bucket location and target bucket location. 
2. Wait for the Step to finish its executing. Check target bucket for outputs. 
	Since the Hive script written in last step queried the number of requests grouped by OS of a given time frame. The results look like:
	
	```
	Linux 813
	MacOS 852
	OSX 799
	iOS 794
	Android 855
	Windows 883
	```

 