#!/bin/bash

device=${1:-wg0}

exec wireguard-go -f ${device}
