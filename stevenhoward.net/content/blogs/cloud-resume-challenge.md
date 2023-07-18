---
title: "Cloud Resume Challenge"
date: 2023-07-10T15:20:15+09:00
draft: false
author: Steven Howard
image: /images/cloud-resume-diagram.png
tags:
    - "AWS"
    - "Terraform"
    - "IaC"
    - "CI/CD"
    - "Python"
    - "Javascript"
    - "HTML/CSS"
---
## Introduction

The Cloud. It’s the future of IT infrastructure, and the future is now. But as a guy who's spent most of his career in on-prem networks, my understanding of the Cloud was limited to "someone else's computer," or the place where my iPhone photos are backed up. In the IT industry, you must always be learning and as technology evolves, so should you. My goal: Demystify the Cloud.

I began my cloud journey with the AWS Cloud Practitioner Certification. Suddenly, I found myself drowning in a sea of cloud services with names like Kinesis, DynamoDB, and Aurora. It felt like deciphering a secret language. But amidst the confusion, I realized the immense power of the Cloud. I could build an entire enterprise infrastructure on someone else's hardware with just a few lines of code. Mind. Blown.

Cloud Engineering. DevOps. Call it what you want. I wanted to replace the endless clicking and configuring in various GUIs with the elegance of code. Seven years ago, my journey into tech began on the path of web development. Circumstances led me in a different direction: IT Support. Now, with widespread cloud adoption and remote work becoming more prevalent, I see a new opportunity to merge my passion for IT infrastructure and automation.

Enter the [Cloud Resume Challenge](https://cloudresumechallenge.dev/docs/the-challenge/aws/), a brainchild of renowned internet man Forrest Brazeal. It's a project that puts your Cloud engineering skills to the test. As I embarked on this challenge while studying for my AWS Solutions Architect Associate Certification, I encountered my fair share of struggles and triumphs. This article is a firsthand account of my journey, sharing the moments of frustration and the joy when everything finally fell into place.

Join me as I dive into the Cloud Resume Challenge, exploring the fascinating world of Cloud Engineering and recounting the obstacles I faced along the way.

## Project Overview (TLDR Edition)

The Cloud Resume Challenge tasks its participants with creating a basic HTML version of their resume and hosting it on AWS using a variety of cloud services, focusing on serverless architecture. That infrastructure should then be converted to code and deployed using a CI/CD pipeline with integrated testing. Here’s a quick run-down of how I interpreted these prompts, and the technologies I used to accomplish each phase of the project:

**Front-End**

- *Portfolio Website*
  - Created using Hugo, a popular static site generator built on Google’s Go language.
  - Hugo Theme – Modified version of Hugo Profile
- *Resume*
  - HTML/CSS version of my resume, with download links to PDF and DOCX versions.
  - View Counter using JavaScript. See next section, “API”
- *S3* – Hosts website, configured with “Public Access.” A second S3 bucket is used to redirect www traffic to the root domain.
- *CloudFront* – Caching, SSL certificate, and HTTP to HTTPS redirection.
- *Route53* – A record aliases for CloudFront, API-Gateway endpoint, and S3 redirection bucket.
  - Domain name, stevenhoward.net, purchased from AWS.
  - Hosted Zone’s Name Servers applied to domain via Terraform.
  
**API**

- *View Counter*, just like those old Geocities / Angelfire pages! All I’m missing is a pixelated, spinning “Under Construction” GIF.
  - *JavaScript* linked at the bottom of the Resume page. On every page load, makes calls to…
  - *API Gateway* (with Cross Origin Resource Sharing headers), linked to…
  - *Lambda* function written in Python (boto3), which reads, increments, writes, and returns a number stored on a…
  - *DynamoDB* table, stores the view count number.
  
**End-to-End Testing**

- Cypress, a JavaScript testing framework that simulates the loading of a web page and clicking various elements. See “CI/CD” section for more details.

**Infrastructure as Code (IaC)**

- *Terraform*, the industry leader in provisioning infrastructure via code.
  - Deploys all back-end infrastructure, including S3, API Gateway, Lambda, DynamoDB, Route53, Certificate Manager, and CloudFront.
  - State stored in *Terraform Cloud*.

**Continuous Integration / Continuous Deployment (CI/CD)**

- *GitHub Actions*
  - Back-End
    - *Terraform* – Applies all back-end infrastructure.
    - *Cypress* – Tests API reachability.
  - Front-End
    - *Hugo* – Builds static website.
    - *AWS CLI* – Copies website files to S3 bucket.
    - *Cypress* – Tests HTTP return code and BODY content.