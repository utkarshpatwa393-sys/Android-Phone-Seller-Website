# Project 1: Production-Grade Static Hosting on AWS (Private S3 + CloudFront OAC)

**Project Owner:** Utkarsh Patwa (@utkarshx96)  
**Target Program:** AWS Student Builder Group Leader — Hi-Tech Institute of Engineering & Technology (in collaboration with Mirai School of Technology), Ghaziabad  
**Cost:** \$0.00 (100% AWS Free Tier Compliant)

---

## 1. Why This Project Matters for Your Leadership Application

Many students simply enable "Static website hosting" on Amazon S3 and make their bucket 100% public to the internet. **In professional cloud engineering, this is considered a major security vulnerability.**

In this project, we implement the **AWS Well-Architected Framework (Security & Reliability Pillars)**:
1. **Zero Public Access on S3:** All 4 public access blocks are enabled on the S3 bucket (`BlockPublicAcls`, `IgnorePublicAcls`, `BlockPublicPolicy`, `RestrictPublicBuckets`).
2. **Amazon CloudFront CDN:** Delivers global edge caching, HTTP/2 & HTTP/3 acceleration, and free automatic SSL/HTTPS encryption.
3. **Origin Access Control (OAC):** Uses AWS SigV4 cryptographic signing so only our specific CloudFront distribution can read the private S3 bucket.

---

## 2. Architecture Diagram

```
[ User Browser (HTTPS) ]
         │
         ▼
[ Amazon CloudFront CDN ] (Global Edge Cache + TLS 1.2/1.3)
         │
    (SigV4 via OAC)
         │
         ▼
[ Private Amazon S3 Bucket ] (Zero Public Access, Encrypted with AES-256)
         │
    (index.html)
```

---

## 3. How to Deploy

### Option A: 1-Click via AWS CLI (When AWS CLI is configured)
Run inside `/Users/utkarshpatwa/Desktop/AmazonAWS/projects/Android-Phone-Seller-Website/`:
```bash
./deploy.sh
```

### Option B: Via AWS Management Console (Zero CLI Needed)
1. Go to **AWS CloudFormation Console** → **Create stack** (With new resources).
2. Upload the template file: `cloudformation.yaml`.
3. Stack name: `android-phone-seller-hosting`.
4. Click **Next** → **Next** → **Submit**.
5. Once the stack status is `CREATE_COMPLETE`:
   - Go to the **Outputs** tab.
   - Note the `S3BucketName` and `LiveWebsiteURL`.
6. Go to the **Amazon S3 Console** → Open the created bucket → Click **Upload** → Add `index.html` → Upload.
7. Open the `LiveWebsiteURL` in your browser. Your responsive Android Phone Seller website is now live worldwide over HTTPS!

---

## 4. Cost & Free Tier Guardrails
- **Amazon S3:** Free Tier includes 5 GB of standard storage and 20,000 GET requests per month. Our project uses ~28 KB.
- **Amazon CloudFront:** Free Tier includes 1 TB of data transfer out per month and 10,000,000 HTTP/HTTPS requests forever.
- **Cleanup (Whenever needed):** To delete the project completely, empty the S3 bucket and delete the CloudFormation stack in the console. Zero lingering costs!
