## Base image
FROM ubuntu

## Install packages and dependencies
RUN apt-get update && apt-get install -f -y \
      freeradius \
      openssl \
      wget && \
      rm -rf /var/lib/apt/lists/*

COPY raddb/ /etc/freeradius/3.0/

## Configure freeradius
RUN wget "http://pki.emirates.com/issuing-ca4(1).crl" && \
      openssl crl -in "issuing-ca4(1).crl" -inform DER -out "issuing-ca4.pem" && \
      rm -f "issuing-ca4(1).crl" && \
      sed '/-----BEGIN X509 CRL-----/,$d' "/etc/freeradius/3.0/certs/CabinCrew/CA/CabinCrew_CAandCRL_cert.pem" > temp && \
      mv temp "/etc/freeradius/3.0/certs/CabinCrew/CA/CabinCrew_CAandCRL_cert.pem" && \
      cat "issuing-ca4.pem" >> "/etc/freeradius/3.0/certs/CabinCrew/CA/CabinCrew_CAandCRL_cert.pem" && \
      rm -f "issuing-ca4.pem"


EXPOSE \
    1812/udp \
    1813/udp

CMD ["freeradius","-fxX"]