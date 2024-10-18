# build stage 1
# choose a base
FROM rocker/r-base:4.3.3 AS base

# install dependencies
RUN apt-get update
RUN apt-get -y install make zlib1g-dev pandoc libicu-dev libx11-dev libcurl4-openssl-dev libssl-dev

# install renv
RUN R -e "install.packages('renv')"


# build stage 2
FROM base

# copy the app to the image
RUN mkdir /app
COPY . /app

# install all necessary packages with renv
WORKDIR /app
ENV RENV_PATHS_LIBRARY=renv/library
RUN R -e "renv::restore()"

EXPOSE 3838
CMD ["R", "-e", "shiny::runApp('/app', port = 3838, host = '0.0.0.0')"]
