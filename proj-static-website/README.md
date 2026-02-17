# Host a Static Website on AWS S3

This guide explains how to host a simple static website (HTML/CSS) using an AWS S3 bucket.

---

## High-Level Key Points

- **Provider Configuration**: Specifies AWS and random providers.
- **Bucket Creation**: Creates an S3 bucket with a unique name.
- **Public Access**: Configures public access to the bucket.
- **Website Configuration**: Sets up the bucket for static website hosting.
- **File Uploads**: Uploads the `index.html` and `error.html` files to the bucket.
- **Website Endpoint**: Outputs the URL of the static website.

---

## Prerequisites

- AWS account
- Basic website files:
  - `index.html`
  - `styles.css`
  - (Optional) `error.html`

---

## Step 1: Create an S3 Bucket

1. Log in to the AWS Management Console.
2. Go to **S3**.
3. Click **Create bucket**.
4. Enter a unique **bucket name**.
5. Uncheck **Block all public access**.
6. Check the **I acknowledge** checkbox.
7. Click **Create bucket**.

---

## Step 2: Upload Website Files

1. Open the created bucket.
2. Upload:
   - `index.html`
   - `styles.css`
3. Click on `index.html`.
4. Open the **Properties** tab.
5. Copy the **Object URL**.

Example:
https://{your-bucket-name}.s3.{region}.amazonaws.com/index.html

Example:
https://first-host-static-website.s3.ap-south-1.amazonaws.com/index.html

6. Open the Object URL in a new browser tab.  
7. You will see **Access Denied** (this is expected).

---

## Step 3: Allow Public Access (Bucket Policy)

1. Open AWS documentation:
   https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteAccessPermissionsReqd.html#bucket-policy-static-site

2. Under **Step 2: Add a bucket policy**, copy the policy JSON.

3. Go back to your S3 bucket.

4. Open the **Permissions** tab.

5. Click **Bucket policy** → **Edit**.

6. Paste the policy.

7. Replace the bucket name in the `Resource` section with your bucket name.

Example policy:

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::your-bucket-name/*"
    }
  ]
}

8. Save the policy.

---

## Final Check

1. Refresh the Object URL in the browser.
2. Your website should now open without **Access Denied**.

---

## Notes

- Make sure your `index.html` file name is correct.
- Your bucket name must be globally unique.
- Do not use public buckets for sensitive data.

---

## Sample Folder Structure

project/
├── index.html
├── error.html
└── styles.css

---

## Done

Your static website is now live using AWS S3.

---

## Terraform Script Reference (Providers & Resources)

### Provider Documentation

- AWS Provider Docs  
  https://registry.terraform.io/providers/hashicorp/aws/latest/docs

### S3 Policy & Access Docs

- Example S3 Bucket Policies (AWS Docs)  
  https://docs.aws.amazon.com/AmazonS3/latest/userguide/example-bucket-policies.html?icmpid=docs_amazons3_console

- Terraform: S3 Bucket Policy  
  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy

- Terraform: Public Access Block  
  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block

- Terraform: Website Configuration  
  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration

### Providers and Resources Used in the Script

The following providers and resources are used in the Terraform script:

- `resource "aws_s3_bucket" "mywebapp-bucket"`  
- `resource "aws_s3_bucket_policy" "mywebapp"`  
- `resource "aws_s3_bucket_public_access_block" "example"`  
- `resource "aws_s3_bucket_website_configuration" "mywebapp"`  
- `resource "aws_s3_object" "index_html"`  
- `resource "aws_s3_object" "styles_css"`  
- `output "Print_URL"`

