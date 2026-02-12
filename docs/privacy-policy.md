---
layout: page
title: Privacy Policy
permalink: /privacy-policy/
---

**Last Updated: February 12, 2026**

---

## 1. Introduction

DiveShopOS ("we," "us," "our") provides a web-based operations platform for dive shops, dive schools, and dive charter operations ("the Service"). This Privacy Policy explains how we collect, use, store, and protect information when you interact with DiveShopOS, whether as a dive shop operator, staff member, or customer of a dive shop using our platform.

DiveShopOS is operated by DiveShopOS, Inc. and hosted in the United States.

---

## 2. Roles and Responsibilities

DiveShopOS operates as a multi-tenant platform. Understanding who is responsible for your data depends on your relationship with the platform:

- **Dive shop operators** (Organizations) are the **data controllers**. They determine what customer data is collected and how it is used within their operations. When you interact with a dive shop through their custom domain or branded portal, that dive shop is responsible for their use of your data.
- **DiveShopOS** is the **data processor**. We provide the infrastructure, store the data on behalf of each Organization, and process it only as directed by the Organization and as described in this policy.

If you have questions about how a specific dive shop uses your data, please contact that dive shop directly. For questions about how DiveShopOS handles data as a platform, contact us at privacy@diveshopos.com.

---

## 3. Information We Collect

### 3.1 Organization and Account Information

When a dive shop registers with DiveShopOS, we collect:

- Business name, address, and contact information
- Custom domain and branding preferences
- Staff user accounts: names, email addresses, roles, and authentication credentials (passwords are stored as secure one-way hashes and are never stored in plain text)

### 3.2 Customer and Diver Information

Dive shops use DiveShopOS to manage their customer relationships. On behalf of each Organization, the platform may store:

- **Contact information**: Full name, email address, phone number, emergency contact details
- **Certification records**: Certification agency (e.g., PADI, SSI, NAUI, TDI, CMAS, BSAC, GUE, or others), certification level, certification number, issue and expiration dates
- **Medical records**: Responses to the RSTC (Recreational Scuba Training Council) medical questionnaire, physician clearance documents, and medical fitness status. See Section 8 for specific details on medical data handling.
- **Waiver and liability documents**: Signed liability releases, assumption of risk agreements, and related compliance documents
- **Dive activity data**: Excursion participation, trip manifests, dive logs, and dive site information
- **Course enrollment data**: Course registrations, progress records, skills completion, and certification issuance
- **Equipment records**: Rental assignments, equipment preferences, and sizing information
- **Booking and payment information**: Reservation details, deposit records, and payment transaction references. DiveShopOS does not store full credit card numbers; payment processing is handled by third-party payment processors (see Section 6).

### 3.3 Usage and Technical Data

We automatically collect limited technical information to operate and improve the Service:

- Browser type and version
- Device type
- IP address
- Pages accessed and features used within the platform
- Error logs and performance data

---

## 4. How We Use Information

All data processing serves the operational needs of dive shop management and diver safety:

- **Dive shop operations**: Scheduling excursions, managing bookings, generating manifests, tracking course enrollment and progress, and managing equipment inventory
- **Safety compliance**: Verifying diver certifications before activity participation, confirming medical clearance, ensuring waivers are current, tracking equipment service schedules for life-support gear, enforcing instructor-to-diver ratios and boat capacity limits
- **Communications**: Booking confirmations, schedule notifications, and operational reminders as configured by each Organization
- **Account administration**: Authenticating users, managing roles and permissions, and maintaining platform security
- **Service operation and improvement**: Monitoring platform performance, resolving technical issues, and improving the Service

We do not use customer or diver data for advertising. We do not build profiles of individual divers across Organizations. Each Organization's data is isolated and used solely for that Organization's operations.

---

## 5. Data Storage and Security

### 5.1 Hosting and Infrastructure

DiveShopOS is hosted in the United States. All data is stored on infrastructure located within the United States.

### 5.2 Encryption

- **In transit**: All data transmitted between your browser and DiveShopOS is encrypted using TLS (HTTPS).
- **At rest**: Stored data is encrypted at rest using industry-standard encryption.

### 5.3 Tenant Isolation

DiveShopOS enforces strict data isolation between Organizations. Every record containing business data is scoped to a specific Organization. One dive shop cannot access another dive shop's data. This isolation is enforced at the application level on every database query and is a foundational architectural principle of the platform.

### 5.4 Access Controls

- Staff access is controlled by role-based permissions managed by each Organization
- Authentication uses secure, hashed passwords
- All actions within the platform are authorized through policy-based access controls

### 5.5 Data Retention

We retain data for as long as an Organization maintains an active account. Upon account termination, Organization data is deleted in accordance with our data retention schedule, subject to the exceptions noted in Section 7.2 regarding safety records.

---

## 6. Third-Party Sharing

We do not sell, rent, or trade personal information to third parties. Data may be shared only in the following circumstances:

- **Payment processors**: When an Organization uses integrated payment features, transaction data is shared with their chosen payment processor to complete transactions. DiveShopOS does not store full payment card details.
- **Certification agency reporting**: When directed by an Organization, certification data may be transmitted to certification agencies (such as PADI, SSI, or others) for the purpose of issuing or verifying diver certifications. This sharing is initiated and controlled by the Organization.
- **Legal requirements**: We may disclose information if required by law, regulation, legal process, or enforceable governmental request.
- **Safety and emergency**: In a genuine emergency involving diver safety, relevant medical and certification information may be disclosed to emergency responders or medical personnel as necessary to protect life and safety.

We do not use third-party advertising networks or share data with data brokers.

---

## 7. Your Rights

### 7.1 Access and Correction

You have the right to:

- **Access** the personal information held about you
- **Correct** inaccurate or incomplete information
- **Request a copy** of your data in a portable format

If you are a customer of a dive shop using DiveShopOS, please direct your request to the dive shop. They are the data controller and can fulfill your request through the platform. If you are unable to reach the dive shop, contact us at privacy@diveshopos.com and we will assist in routing your request.

### 7.2 Deletion

You may request deletion of your personal information. However, please be aware that certain dive safety records may be retained even after a deletion request, where required by:

- Regulatory requirements governing dive operations
- Insurance and liability record-keeping obligations
- Industry safety standards requiring maintenance of dive activity records, incident reports, and certification histories

When retention is necessary, we will inform you of the specific reason and retain only the minimum data required. Retained records will continue to be protected under the same security standards described in this policy.

### 7.3 Withdrawal of Consent

Where processing is based on consent, you may withdraw consent at any time. Withdrawal does not affect the lawfulness of processing that occurred before withdrawal.

---

## 8. Medical Data

DiveShopOS stores medical information specifically and exclusively for dive safety compliance purposes. This includes:

- **RSTC medical questionnaire responses**: Used to determine fitness to dive in accordance with industry-standard screening protocols
- **Physician clearance documents**: Stored when a diver's medical questionnaire indicates conditions requiring physician review
- **Medical fitness status**: A current cleared/not-cleared status used by safety gate checks before water activities

**Important distinctions about medical data in DiveShopOS:**

- This is **operational safety data**, not clinical healthcare data. DiveShopOS is not a healthcare provider, health plan, or healthcare clearinghouse.
- Medical data is collected and stored solely because dive industry safety standards require medical fitness verification before water activities.
- Medical records are accessible only to authorized staff within the Organization that collected them, consistent with their role-based permissions.
- Medical fitness status is used programmatically by the platform's safety compliance checks (e.g., preventing a diver with an expired or uncleared medical status from being added to a dive excursion manifest).
- Organizations are responsible for ensuring their collection and use of medical data complies with applicable laws in their jurisdiction.

We treat all medical data as sensitive information and apply the highest level of access control and encryption available within the platform.

---

## 9. Cookies and Tracking

DiveShopOS uses only **functional cookies** that are strictly necessary for the operation of the Service:

- **Session cookies**: Required to maintain your authenticated session
- **Security cookies**: Used for CSRF (cross-site request forgery) protection

We do not use:

- Third-party tracking cookies
- Advertising cookies or pixels
- Social media tracking widgets
- Cross-site analytics platforms that share data with third parties

If we introduce analytics in the future, we will update this policy and notify users before any change takes effect.

---

## 10. Whitelabel and Custom Domains

Many dive shops access DiveShopOS through their own custom domain (e.g., diveshopname.com) with their own branding. When you interact with the platform through a custom domain:

- The **dive shop** (Organization) is the data controller. They have configured their branding and domain, and they determine how customer data is collected and used.
- **DiveShopOS** is the data processor operating the underlying platform infrastructure.
- This Privacy Policy governs how DiveShopOS processes data on behalf of all Organizations. Individual dive shops may maintain their own privacy policies that provide additional detail on their specific data practices.
- The same security measures, tenant isolation, and data protection standards apply regardless of whether you access the platform through diveshopos.com or a shop's custom domain.

---

## 11. Children's Privacy

Dive courses and activities frequently involve participants under the age of 18. DiveShopOS addresses this as follows:

- **Parental or guardian consent is required** before any personal information is collected for a minor. Organizations are responsible for obtaining and documenting this consent, typically as part of their standard waiver and enrollment processes.
- Minor participants' data is subject to the same security and access controls as all other customer data.
- Parents or legal guardians may exercise data rights (access, correction, deletion) on behalf of minor participants by contacting the relevant dive shop.
- We do not knowingly collect personal information from children under 13 without verifiable parental consent. If we become aware that we have collected data from a child under 13 without appropriate consent, we will take steps to delete that information.

Organizations operating in jurisdictions with specific requirements regarding children's data (such as COPPA in the United States) are responsible for ensuring their use of the platform complies with those requirements.

---

## 12. International Considerations

DiveShopOS is hosted in the United States. If you are accessing the Service from outside the United States, please be aware that your data will be transferred to and stored in the United States.

Dive shops operating in jurisdictions subject to the EU General Data Protection Regulation (GDPR), UK GDPR, or similar data protection laws are responsible for ensuring appropriate legal bases and transfer mechanisms are in place for their customers' data. We will cooperate with Organizations to support their compliance obligations, including executing Data Processing Agreements upon request.

---

## 13. Data Breach Notification

In the event of a data breach that affects personal information, we will:

- Notify affected Organizations promptly and without undue delay
- Provide sufficient detail for Organizations to assess the impact and fulfill their own notification obligations to their customers and applicable authorities
- Cooperate fully with breach investigation and remediation efforts

---

## 14. Changes to This Policy

We may update this Privacy Policy from time to time to reflect changes in our practices, technology, or legal requirements. When we make changes:

- The "Last Updated" date at the top of this page will be revised
- For material changes, we will provide notice through the DiveShopOS platform (via in-app notification to Organization administrators)
- Continued use of the Service after changes take effect constitutes acceptance of the updated policy

We encourage you to review this policy periodically.

---

## 15. Contact Us

If you have questions about this Privacy Policy or our data practices, please contact us:

**Email**: privacy@diveshopos.com

If you are a customer of a dive shop using DiveShopOS and have questions about how your data is handled, we recommend contacting your dive shop directly, as they are the data controller for your information.

---

This policy is written to be clear and accessible. It is not a substitute for legal advice. Organizations using DiveShopOS should consult with legal counsel to ensure their data practices comply with applicable laws in their jurisdiction.
