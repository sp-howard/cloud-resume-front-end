---
title: "The Cloud Resume Challenge: My First Step Into the Cloud"
date: 2023-09-15T15:20:15+09:00
draft: false
author: Steven Howard
image: /images/blog/cloud-resume/cloud-resume-diagram.png
tags:
  - "AWS"
  - "HTML/CSS"
  - "Hugo"
  - "Python"
  - "JavaScript"
  - "Terraform"
  - "Cypress"
  - "GitHub Actions"
---

## Introduction

The cloud. It’s the future of IT infrastructure, and the future is now. But as a guy who’s spent most of his career in on-prem networks, my understanding of the cloud was limited to “someone else’s computer,” or a stack of servers in a datacenter somewhere, managed by someone other than myself. I'd never considered a career in the cloud, until I met a colleague who introduced me to its concepts, and transformed his life through his DevOps studies (shout out [Elvin Rivera](https://www.linkedin.com/in/elvin-rivera-725066159/)!). I learned that there was more to the cloud than hosting VMs in a datacenter. There was an entire world of automation, scaling, monitoring, and using cutting edge technologies like containers and Infrastucture as Code. 

As an automation-first minded systems administrator, I saw a career pivot to Cloud Computing as a chance to realize my dream of making a living out of a code editor. To unite my extensive experience with IT infrastructure with my passion for coding.

First, I had to choose one of the three major cloud providers. AWS was the originator, and till this day remains the king of cloud computing. I find that I learn best by gaining a broad overview of a technology in a guided manner, which certification preparation provides. I chose the AWS Solutions Architect Assiociate certification, as it seemed to cover a breadth of AWS services. [Adrian Cantrill](https://learn.cantrill.io/) was my tutor of choice. If you're just starting on your Cloud journey, I can't recommend his courses enough!

Six weeks of late nights, and countless hours of studying and labbing led to my AWS SAA certification. I had garnered a comprehensive understanding of cloud computing and how AWS's myriad of services work together to deliver the six pillars of the [Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/?wa-lens-whitepapers.sort-by=item.additionalFields.sortDate&wa-lens-whitepapers.sort-order=desc&wa-guidance-whitepapers.sort-by=item.additionalFields.sortDate&wa-guidance-whitepapers.sort-order=desc). I realized just how powerful this technology is, and all the opportunities it enables. Now that I had the theory down, I was ready to put tires to pavement and get some real hands-on experience. I consulted [r/AWSCertifications](https://www.reddit.com/r/AWSCertifications/), and the consensus was that the best way for a burgeoning Cloud Engineer to practice their new skills was to complete The Cloud Resume Challenge.

<div style="text-align:center"><a href="https://cloudresumechallenge.dev/docs/the-challenge/aws/"><img src="/images/blog/cloud-resume/cloud-resume-logo.png" style="text-align: center; max-width:300px"></a></div>

[The Cloud Resume Challenge](https://cloudresumechallenge.dev/docs/the-challenge/aws/) is the brainchild of renowned internet-man [Forrest Brazeal](https://www.linkedin.com/in/forrestbrazeal/). His challenge tasks its participants with creating an HTML/CSS version of their resume and hosting it on AWS using a variety of cloud services, including a visitor counter powered by serverless technologies. The infrastructure that was initially constructed in the AWS console should then be converted to Infrastructure as Code, and deployed using a CI/CD pipeline, without forgoing the essential DevOps practice of end-to-end testing.

I was game. I hadn't taken on a project of this scale since I studied web development eight years prior. In my career as a network and systems administrator, I'd completed a multitude of network rollouts and server migrations, but I never felt a sense of accomplishment like I did when creating my first to-do app in JavaScript. It's the creative aspect of coding that drives me. I couldn't wait to have that feeling again. Let the challenge begin!

## Project Overview

Here's a high level overview of the project and all of its components.

**Front-End**

- Resume
  - HTML/CSS version of my resume, with download links to PDF and DOCX versions.
  - View Counter using Javascript.
- Portfolio Website
  - Created using Hugo, a popular static site generator.
  - Hugo Theme – Modified version of [Hugo Profile](https://themes.gohugo.io/themes/hugo-profile/)
- S3 – Hosts website, configured with “Public Access.” A second S3 bucket is used to redirect "www" subdomain traffic to the root domain.
- CloudFront – Caching, SSL certificate, and HTTP to HTTPS redirection.
- Route53 – "A" record aliases for CloudFront, API-Gateway endpoint, and S3 redirection bucket.
  - Domain name, stevenhoward.net, purchased from AWS.
  - Hosted zone’s name servers applied to domain via Terraform.

**API**

- View Counter
  - JavaScript linked at the top/bottom of the Resume page. On every page load, makes calls to…
  - API Gateway (with Cross Origin Resource Sharing headers), linked to…
  - Lambda function written in Python (boto3), which reads, increments, writes, and returns a value stored in a…
  - DynamoDB table, which stores the view count value.

**End-to-End Testing**

- Cypress, a JavaScript testing framework that simulates the loading of a web page and clicking various elements.

**Infrastructure as Code (IaC)**

- Terraform, the industry leader in provisioning infrastructure via code.
  - Deploys all back-end infrastructure, including S3, API Gateway, Lambda, DynamoDB, Route53, Certificate Manager, and CloudFront.
  - State stored in _Terraform Cloud_.

**Continuous Integration / Continuous Deployment (CI/CD)**

- GitHub Actions
  - Back-End
    - Terraform – Applies all back-end infrastructure.
    - Cypress – Tests API reachability.
  - Front-End
    - Hugo – Builds static website.
    - AWS CLI – Copies website files to S3 bucket.
    - Cypress – Tests HTTP return code and BODY content.

## The Resume

### Coding with HTML/CSS

I started with updating my resume and converting it into pure HTML and CSS. It was a great way to oil my rusty gears. I had a ton of fun, until I ran into my old nemesis: CSS display properties.

<div style="max-width:300px;margin: auto; margin-bottom: 1rem; margin-top: 1rem"><img src="/images/blog/cloud-resume/css.gif" style="text-align: center;"></div>

It only took a Google search or two to refresh my CSS knowledge and I quickly had a perfect rendition of my resume, page breaks aside.

<div style="text-align:center"><a href="https://stevenhoward.net/resume/"><img src="/images/blog/cloud-resume/resume-screenshot.png" style="text-align: center; max-width:500px"></a></div>

**Links**  
[**Resume**](https://stevenhoward.net/resume/) | [HTML Source on GitHub](https://github.com/sp-howard/cloud-resume-front-end/blob/main/stevenhoward.net/static/resume/index.html) | [CSS Source on GitHub](https://github.com/sp-howard/cloud-resume-front-end/blob/main/stevenhoward.net/static/resume/style.css)

### Hosting with S3 and Route 53

I uploaded my HMTL and CSS files to Amazon S3, making sure to turn on S3's Static Website hosting feature, and opening access to the public via a bucket policy.

My domain name, stevenhoward.net, was purchased directly from AWS. It was a bit more expensive than other options such as NameCheap, but I'm glad I stayed within the AWS ecosystem as it allowed me to apply my name servers to the domain using Terraform later on in the project.

An issue with my Route 53 configuration became apparent pretty quickly. I was excited to show off my work, so I asked a colleague to go to stevenhoward.net. The page didn't load. Talk about embarrassing. When he added the "www" subdomain, the page loaded just fine. My initial configuration had www.stevenhoward.net set as my "A" record. I learned that setting the root domain as a CNAME record isn't supported, so I had to swap those records around. Later on in the project, I ran into another subdomain routing issue, this time with CloudFront. I set up a second S3 bucket to redirect "www" subdomain traffic to the root, while maintaining an SSL connection. 

### Portfolio Website with Hugo

Having a background in web development, I wanted my new web presence to be a little more than simulating a piece of printer paper. Research led me to the popular static site generator, Hugo. It's built on Google's Go and is known for its high performance and ease of use. I found a theme that fit my design sensibilities and I filled in the YAML config file with my personal content. I had to make quite a few CSS tweaks of course. Thank you OCD. Now all I had to do was issue the "hugo" command, and 1700 files were instantly generated and packaged into a neat folder I could upload to Amazon S3. No webserver needed.

<div style="text-align:center"><a href="https://stevenhoward.net/"><img src="/images/blog/cloud-resume/website-screenshot.png" style="text-align: center; max-width:500px; box-shadow: 0px 0px 5px 0px #aaa; margin-bottom: 1rem;"></a></div>

**Link**  
[Front-End Repo on GitHub](https://github.com/sp-howard/cloud-resume-front-end)

## Visitor Counter API

The next step was creating a visitor counter. You know, like the ones on those old Geocities/Angelfire pages. I’m just missing a pixelated “Under Construction” GIF and hyperlinks to join my webring and sign my guestbook.

<div style="text-align:center"><img src="/images/blog/cloud-resume/under-construction.gif" style="text-align: center; max-width:175px"></div>

<p style="text-align:center;">*Papa Roach MIDI plays in the background*</p>

All jokes aside - this is where the challenge truly began. APIs. I'd heard of them. I'd even called a few and parsed though a litany of nested objects and arrays. But I'd never _created_ an API.

### Creating the API with Python

I started by creating a DynamoDB table with a single value. I created an HTTP API in API Gateway (more on that later), and coded a basic Python script in Lambda using the boto3 library. I'd used Python for a network automation project recently, and it was literally the first programming language I ever learned way back in high school, so I found my footing quickly. The script gets the current "viewcount" value from DynamoDB, increments it by one, saves the new value back to the table, and returns it as the body of the JSON response.

```python
import boto3
import os
import json

def lambda_handler(event: any, context: any):

    # Create a DynamoDB client
    dynamodb = boto3.resource("dynamodb")
    table_name = os.environ["TABLE_NAME"]
    table = dynamodb.Table(table_name)

    # Does 'viewed' table item exist? If not, initialize with viewcount value of 0
    def get_key():
        key = table.get_item(Key={'viewed': 'True'})
        if 'Item' in key:
            return key['Item']
        else:
            table.put_item(Item={'viewed': 'True', "viewcount": 0})
            return table.get_item(Key={'viewed': 'True'})['Item']

    key = get_key()

    # Get current viewcount value
    viewcount = key['viewcount']

    # Increment viewcount by 1
    updated_viewcount = viewcount + 1

    # Add new viewcount value to table
    table.put_item(Item={'viewed': 'True', "viewcount": updated_viewcount})

    # Return API response in JSON format
    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin' : '*'
        },
        'body': updated_viewcount
    }
```

### Calling the API with JavaScript

With the API fully formed, I needed to call it from my resume page. I dipped my toes back into the JavaScript waters for the first time in seven years and came up with this:

```js
api_url = "https://api.stevenhoward.net/viewcount";

fetch(api_url, { method: "GET" })
  .then((res) => res.json())
  .then((data) => {
    // Get all elements with the "view_count" class
    const viewcount_elements = document.getElementsByClassName("view_count");

    // Convert the HTMLCollection to an array using spread operator
    const elementsArray = [...viewcount_elements];

    // Iterate through each element and set the value
    elementsArray.forEach((element) => {
      element.innerHTML = `${data}`;
    });

    console.log(data);
  })
  .catch((err) => {
    console.log(err);
  });
```

Looks good right? …Right? Well, this project was about to take a turn.

### Troubleshooting CORS

<div style="text-align:center"><img src="/images/blog/cloud-resume/cors-wars.png" style="text-align: center;"></div>

<p style="text-align: center;">Cue orchestral score and giant wall of space text.</p>

Oh, it was a war alright. Everything was seemingly coded and configured correctly, but I kept getting "Cross-Origin Request Blocked" errors in my browser and the visit counter element wasn't being populated with the value from DynamoDB.

CORS or Cross Origin Resource Sharing, as Wikipedia puts it, is "a mechanism that allows restricted resources on a web page to be accessed from a domain outside the domain from which the first resource was served." If that sounds a bit confusing, well, I definitely was. Boiled down, it's a security feature, and anyone in IT will tell you that, although it's absolutely necessary, security is the enemy of convenience.

I found the problem to be with the API type I chose. I should have chosen a REST API, not HTTP. There were also some custom headers I needed to create in API Gateway. I'm not ashamed to admit it took a couple of days to figure all of this out, and in hindsight it was probably the most challenging/frustrating bit of the entire project. A crucial learning experience though.

<div style="text-align:center"><img src="/images/blog/cloud-resume/view-counter.png" style="text-align: center; box-shadow: 0px 0px 5px 0px #aaa; margin-bottom: 1rem;"></div>

<p style="text-align: center;">Finally! ...It's All the Small Things that count.</p>

With CORS conquered, I was ready to tackle the mind blowing magnificence that is Infrastructure as Code.

## Infrastructure as Code

The very notion of IaC was the spark that started my Cloud journey. An entire technology stack- all the stuff I'd spent years manually configuring: switches, routers, VMs, load balancers, DNS, the list goes on... An entire IT department's worth of infrastructure can be created and destroyed with a simple command. My mind was blown.

<div style="text-align:center"><img src="/images/blog/cloud-resume/mind-blown.gif" style="text-align: center; max-width:300px"></div>
<p style="text-align: center;">Terraform Destroy my preconceptions about provisioning infrastructure.</p>

I lived in the official Terraform documentation for a good couple of weeks, and by the end I wasn't necessarily an expert, but I had enough of a solid understanding of the technology to attain the HashiCorp Terraform Associate certification. Shout out to [Derek Morgan](https://www.linkedin.com/in/derekm1215/) and his course, [More Than Certified in Terraform](https://www.udemy.com/course/terraform-certified/) on Udemy. A great resource that lays everything out clearly and in a logical order. Definitely recommended to anyone wanting to start building with Terraform.

### Storing the Terraform State

I used Terraform Cloud due to its ease of use. I could have used Amazon S3 to store the state file, and DynamoDB for the state lock, but I figured my project was small enough to stay in the free tier (up to 500 resources) of Terraform Cloud.

### Troubleshooting MIME Types

By using Terraform to upload my HTML and CSS files, I ran into an issue regarding MIME (media) types. The files were successfully loaded into my S3 bucket, but the webpage wouldn't display. The MIME type was lost in translation, and had to be explicitly indicated based on file extension and a MIME type dictionary, mapped using a `for_each` loop in Terraform.

### Terraform Doesn't Need to Track Everything

With the MIME fiasco behind me, I was able to upload my static site files ( all __1700__ of them) to S3. But this time, hitting Terraform Apply meant a firm push out of the free tier of terraform Cloud. I was greeted with a warning indicating that while I had a grace period, the amount of resources tracked would cost me $170/month! At this point I had set up all my API Keys between AWS, Terraform Cloud, and GitHub Actions, and I really liked Terraform Cloud's online GUI, so I needed another solution. I simply opted to copy the files to S3 using AWS CLI, which I configured as part of my CI/CD pipeline.

> Lesson Learned: Just because a tool can _do_ a job, doesn't mean it's the _best_ tool for the job.

**Link**  
[Back-End Repo on GitHub](https://github.com/sp-howard/cloud-resume-back-end)

## CI/CD

Now for the final leg of the journey. The one I had been dreading, as the concept was foreign to me. And that acronym... CI/CD. It just sounds like something I'd need a Master's in Computer Science to comprehend. Turns out, it was one of the most straight forward and dare I say, _easy_, parts of the project. I used GitHub Actions, and that's probably what made the task so trivial. There are GitHub Actions repositories that you can hook into, and all you have to do is fill out a few parameters in a YAML file for it to work its magic. 

Pushing my code to GitHub, and seeing it live just a minute later is mesmerizing. I can't wait to see the type of pipelines I'll get to work with in production environments.

**Links**  
[Back-End GitHub Actions Job](https://github.com/sp-howard/cloud-resume-back-end/blob/main/.github/workflows/terraform-cypress.yml) | [Front-End GitHub Actions Job](https://github.com/sp-howard/cloud-resume-front-end/blob/main/.github/workflows/hugo-terraform-cypress.yml)

## Final Thoughts

<div style="text-align:center"><img src="/images/blog/cloud-resume/thanos.gif" style="text-align: center; max-width:400px"></div>
<p style="text-align: center;">My career in the cloud is… Inevitable.</p>


What a journey! Like good ol' Thanos here, upon completing this project I felt a great sense of satisfaction. This wasn't a step by step tutorial by any means. I was given a spec, and it was up to me to hit the mark. It's the best way to learn, and I've grown tremendously through the process. Attaining my AWS certification was rewarding, but the depth of understanding it provided pales in comparison to completing this challenge. 

I've found the confidence I needed to continue on my journey. I know I've only scratched the surface. There is still so much to learn, from containerization, to orchestration, observability, security, configuration management, and building increasingly complex scalable, performant, and resilient infrastructure. I want to do it all. But this was the first step, and I can proudly say that I completed The Cloud Resume Challenge. 