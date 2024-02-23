This is a learning project with backend deployed to EKS, frontend to Cloudfront and DB to EC2 with an AMI image prepared by packer.


# Travel Guide Website

This project is for learning purposes, demonstrating the use of various DevOps tools in action. It is a small website that serves as a travel guide, displaying a list of countries, cities, and must-see places for travelers.

## Technologies Used

- **Frontend**: Hosted on AWS S3, deployed to CloudFront
- **Backend**: Python, deployed to an EKS cluster on AWS
- **Database**: PostgreSQL, deployed to an EC2 instance

## Features

- Browse through a curated list of countries, cities, and their top attractions.
- Search for specific countries or cities to find detailed information.
- User-friendly interface for travelers to plan their trips.

## Deployment

### Frontend
The frontend files are hosted on AWS S3 and deployed to CloudFront for fast content delivery.
- **AWS S3 Bucket**: `s3://your-frontend-bucket`
- **CloudFront Distribution**: `https://your-cloudfront-url.com`

### Backend
The backend is written in Python and deployed to an EKS cluster on AWS.
- **EKS Cluster**: `your-eks-cluster`
- **API Endpoint**: `https://your-api-endpoint.com`

### Database
The PostgreSQL database is deployed to an EC2 instance on AWS.
- **EC2 Instance**: `ec2-db`
- **Database Name**: `postgres`

## Installation and Setup

1. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/travel-guide.git
   cd travel-guide/


Repository Setup
1. git clone the repository and push it to your own github repository
2. create the following GitHub secrets in your GitHub repository:
Settings -> Secrets and Variables -> Actions -> Repository Secrets

AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
POSTGRES_ROOT_PASS
POSTGRES_ROOT_USER