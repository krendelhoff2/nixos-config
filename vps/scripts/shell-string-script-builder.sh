#!/bin/sh
set -e
unset PATH
for p in $buildInputs; do
  export PATH=$p/bin${PATH:+:}$PATH
done

mkdir -p $out/bin
echo "$src" &> $out/bin/$name
chmod a+xr $out/bin/$name
