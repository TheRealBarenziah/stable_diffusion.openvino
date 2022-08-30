FROM python:3.8.13-buster

RUN apt-get update
RUN apt-get install -y python3-opencv

RUN /usr/local/bin/python -m pip install --upgrade pip

# https://stackoverflow.com/a/66473309
RUN python -m pip install opencv-python

RUN mkdir /app
WORKDIR /app
COPY ./ ./

# https://github.com/bes-dev/stable_diffusion.openvino/blob/master/README.md#install-requirements
RUN python -m pip install -r requirements.txt

RUN python stable_diffusion.py --prompt "Street-art painting of Emilia Clarke in style of Banksy, photorealism"

RUN echo "ls  : "
CMD ls