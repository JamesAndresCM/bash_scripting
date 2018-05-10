#!/bin/bash

#directorio vacio o contiene archivos
shopt -s nullglob dotglob
    files=(*)
       (( ${#files[*]} )) && echo "The current directory contains ${#files[@]} things." || echo "empty"
       shopt -u nullglob dotglob


