#!/bin/bash
sleep 300

sudo systemctl start forwardkibana.service
sudo systemctl start forwardapm-server.service