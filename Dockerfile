# ------------------------------------------------------------------------------
#               NOTE: THIS DOCKERFILE IS GENERATED VIA "update_multiarch.sh"
#
#                       PLEASE DO NOT EDIT IT DIRECTLY.
# ------------------------------------------------------------------------------
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

FROM alpine:3.14 as jre-build

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN apk add --no-cache tzdata musl-locales musl-locales-lang \
    && rm -rf /var/cache/apk/*

ENV JAVA_VERSION jdk-11.0.13+8

COPY OpenJDK-jdk.tar.gz /tmp/openjdk.tar.gz

RUN set -eux; \
    mkdir -p /opt/java/openjdk; \
    tar --extract \
       --file /tmp/openjdk.tar.gz \
       --directory /opt/java/openjdk \
       --strip-components 1 \
       --no-same-owner \
       ; \
    rm -rf /tmp/openjdk.tar.gz;

ENV PATH="/opt/java/openjdk/bin:$PATH"


RUN jlink \
      --add-modules java.base \
      --strip-debug \
      --no-man-pages \
      --no-header-files \
      --compress=2 \
      --output /javaruntime

FROM alpine:3.14

ENV JAVA_HOME=/opt/java/openjdk \
    PATH="/opt/java/openjdk/bin:$PATH"

COPY --from=jre-build /javaruntime $JAVA_HOME

RUN echo Verifying install ... \
    && echo java --version && java --version \
    && echo Complete.
