ARG IMAGE_TAG=$IMAGE_TAG

FROM datadotworld/dwcc:$IMAGE_TAG

ARG CROSS_ACCOUNT_S3_ACCESS_KEY
ENV CROSS_ACCOUNT_S3_ACCESS_KEY=$CROSS_ACCOUNT_S3_ACCESS_KEY
ARG CROSS_ACCOUNT_S3_SECRET_KEY
ENV CROSS_ACCOUNT_S3_SECRET_KEY=$CROSS_ACCOUNT_S3_SECRET_KEY

# Update docker image for vulnerability packages
RUN apt-get update && apt-get upgrade -y
RUN apt-get install wget -y

# Download Redshift driver so the collector can run
RUN wget -P /usr/src/dwcc-config/lib https://s3.amazonaws.com/redshift-downloads/drivers/jdbc/2.1.0.18/redshift-jdbc42-2.1.0.18.jar

# Add credential file for S3 cross account access
RUN mkdir /root/.aws
RUN touch /root/.aws/credentials
RUN echo "[default]" >> /root/.aws/credentials
RUN echo "aws_access_key_id=$CROSS_ACCOUNT_S3_ACCESS_KEY" >> /root/.aws/credentials
RUN echo "aws_secret_access_key=$CROSS_ACCOUNT_S3_SECRET_KEY" >> /root/.aws/credentials

