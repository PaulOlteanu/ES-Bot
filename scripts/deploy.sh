#!/bin/bash

systemctl stop es_bot
MIX_ENV=prod mix release prod --overwrite
systemctl start es_bot
