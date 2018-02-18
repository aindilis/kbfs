#!/bin/bash

echo "Be sure to run 'sudo iotop' when bash starts"

sleep 5

ttyrec -e bash /var/lib/myfrdcsa/codebases/internal/kbfs/systems/track-leak/ttyrec.tty
