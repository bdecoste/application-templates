#!/bin/bash

set -x

source /usr/local/s2i/install-common.sh

injected_dir=$1

configure_resource_adapters ${injected_dir}/install.properties

