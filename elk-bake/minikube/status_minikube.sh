#!/bin/bash

while [[ "$(systemctl show --property=SubState --value minikube.service)" != "dead" ]]; do
    sleep 5
done
