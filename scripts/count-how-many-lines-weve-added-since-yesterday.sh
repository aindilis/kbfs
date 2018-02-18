#!/bin/sh

gith changes_since_yesterday_diff | grep '^\+' | wc -l
