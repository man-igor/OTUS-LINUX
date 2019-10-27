#!/usr/bin/env bash

if getent group admin | grep &>/dev/null $PAM_USER; then
   exit 0
fi

if [[ $(date +%u) -gt 5 ]]; then 
   exit 1 
else
   exit 0   
fi

