FROM registry.access.redhat.com/ubi9/openjdk-21:1.20-2.1726695192

USER root

RUN microdnf -y update
RUN microdnf install -y wget
RUN microdnf install -y openscap-scanner

COPY ./ubi9-oval.xml /usr/share/xml/scap/ssg/content/.
COPY ./ubi9-xccdf.xml /usr/share/xml/scap/ssg/content/.
COPY ./ubi9-xccdf-ds.xml /usr/share/xml/scap/ssg/content/.

USER 185