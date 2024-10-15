FROM registry.access.redhat.com/ubi9/openjdk-21:1.20-2.1726695192

USER root

RUN microdnf -y update
RUN microdnf install -y openscap-scanner

COPY ./custom-ubi9-oval.xml /usr/share/xml/scap/ssg/content/.
COPY ./rhel-9.oval.xml /usr/share/xml/scap/ssg/content/.
COPY ./xccdf-ubi9.xml /usr/share/xml/scap/ssg/content/.

USER 185