#!/bin/bash

quickec set backlight_control $(python -c "print(1-$(quickec get backlight_control))")