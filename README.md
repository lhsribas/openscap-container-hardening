# OpenScap

## Scan Command

```bash 
oscap xccdf eval --profile xccdf_redhat_profile_standard_ubi9 --results results.xml /usr/share/xml/scap/ssg/content/xccdf-ubi9.xml
```

## Remediate Command

```bash 
oscap xccdf eval --remediate --profile xccdf_redhat_profile_standard_ubi9  /usr/share/xml/scap/ssg/content/ubi9-xccdf.xml
```

```bash
oscap xccdf eval --remediate --profile xccdf_redhat_profile_standard_ubi9  /usr/share/xml/scap/ssg/content/ubi9-xccdf.xml
```