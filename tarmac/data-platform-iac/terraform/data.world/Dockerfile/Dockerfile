ARG IMAGE_TAG=$IMAGE_TAG

FROM datadotworld/dwcc:$IMAGE_TAG

ARG CROSS_ACCOUNT_S3_IAM_ROLE
ENV CROSS_ACCOUNT_S3_IAM_ROLE=$CROSS_ACCOUNT_S3_IAM_ROLE

# Update docker image for vulnerability packages
RUN apt-get update && apt-get upgrade -y

# Download Redshift driver so the collector can run
RUN wget -P /usr/src/dwcc-config/lib https://s3.amazonaws.com/redshift-downloads/drivers/jdbc/2.1.0.18/redshift-jdbc42-2.1.0.18.jar

# Add credential file for S3 cross account access
ADD credentials.example /root/.aws/credentials
RUN echo $CROSS_ACCOUNT_S3_IAM_ROLE
RUN echo "role_arn = $CROSS_ACCOUNT_S3_IAM_ROLE" >> /root/.aws/credentials
