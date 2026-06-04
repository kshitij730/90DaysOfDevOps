#!/bin/bash

show_local() {
    local name="Kshitij"
    echo "Inside Function: $name"
}

show_global() {
    city="Lucknow"
}

show_local

echo "Outside Function: ${name:-Not Accessible}"

show_global

echo "Global Variable: $city"
