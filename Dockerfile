FROM python:3.6

# Creating Application Source Code Directory
RUN mkdir -p /usr/src/app

# Setting Home Directory for containers
WORKDIR /usr/src/app

# Copy src python files
COPY * /usr/src/app/

# Installing python dependencies
RUN mkdir -p /usr/src/app/models

# create directories for models and data
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

ENV APP_ENV development
ENV DATASET=mnist TYPE=ff
ENV DATASET=kmnist TYPE=cnn

# Preload the data
RUN python data_preload.py

# Pretrain the models
RUN python train.py --dataset mnist --type ff
RUN python train.py --dataset mnist --type cnn
RUN python train.py --dataset kmnist --type ff
RUN python train.py --dataset kmnist --type cnn

EXPOSE 5035
VOLUME ["/app-data"]


# Running Python Application
CMD ["python", "classify.py"]
