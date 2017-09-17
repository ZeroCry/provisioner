FROM quay.io/gravitational/debian-grande:0.0.1

# What TerraFOrm version to install
ARG TERRAFORM_VER

RUN ( \
        apt-get update && \
        apt-get install --yes --no-install-recommends \
            make curl unzip\
    )

RUN ( cd /usr/local/bin && \
     curl -O https://releases.hashicorp.com/terraform/${TERRAFORM_VER}/terraform_${TERRAFORM_VER}_linux_amd64.zip && \
     unzip terraform_${TERRAFORM_VER}_linux_amd64.zip && \
     rm -f terraform_${TERRAFORM_VER}_linux_amd64.zip )

# bundle Make and TerraForm
ADD scripts /usr/local/bin/provisioner

# Add the  binary of this repo
ADD build/provisioner /usr/local/bin/inspect

# By setting this entry point, we expose make target as command
ENTRYPOINT ["/usr/bin/dumb-init", "/usr/bin/make", "-C", "/usr/local/bin/provisioner"]
