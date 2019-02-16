#!/usr/bin/env bash
function wrap() {
  echo ""
}

function build-deb {
  case "$ot" in
    deb )
      name=${time}.deb
      dpkg-deb -b "../meterpreter/" "${name}" &>Buildlog.txt & pid=$!
      Check-run "$pid"
      Check-op "${name}"
      echo "Output file: `pwd`/${name}"
      ;;
  esac
}

function Check-op() {
  if [[ ! -f "$1" ]]; then
    echo "Meterpreter compilation failed, See buildlog to fix errors"
    exit 501
  fi
}

function Check-run() {
  spin[0]="-"
  spin[1]="\\"
  spin[2]="|"
  spin[3]="/$"
  echo -ne "[Please wait...] ${spin[0]}"
  while kill -0 $1 &>/dev/null
  do
    for i in "${spin[@]}"
    do
          echo -ne "\b$i"
          sleep 0.1
    done
  done
  echo ""
}

function Check-runtime() {
  if [[ ! -f "./README.md" ]]; then
    echo -e "[!]Error: file 'README.md' can't find. Please,run this script in folder 'Custom-tools'"
    exit 500
  fi
  if [[ ! -f "../meterpreter/usr/bin/meterpreter" ]]; then
    echo -e "[!]Error: file 'meterpreter' can't find. Please,run this script in folder 'Custom-tools'"
    exit 500
  fi
}

time=$(date "+%Y-%m-%d %H:%M:%S")

#Just check
echo -ne "===================Preparing==================="
echo -ne \
"""
[INFO]LICENSE: GNU General Public License v2.0
[INFO]Contributions: Nios34
[+]Checking runtime environment...
"""
Check-runtime
echo -e "=====================Done======================\n"

echo "[HINT]Output architecture(Arm64,Arm,Amd64,I386,All)"
read -p "Check architecture: " -a cka
wrap
echo "[HINT]Type list: deb,rpm,tar,bin"
read -p "Output type: " -a ot
wrap
echo "[HINT]Use meterpreter built-in config(If not filled in, it is the default configuration)"
read -p "Config file: "
wrap

case "$cka" in
  Arm64 )
    case "$ot" in
      deb )
        sed -i '6c Architecture: arch64' "../meterpreter/DEBIAN/control"
        build-deb
        ;;
    esac
    ;;
  Arm )
    case "$ot" in
      deb )
        sed -i '6c Architecture: arch' "../meterpreter/DEBIAN/control"
        build-deb
        ;;
    esac
    ;;
  Amd64 )
    case "$ot" in
      deb )
        sed -i '6c Architecture: amd64' "../meterpreter/DEBIAN/control"
        build-deb
        ;;
    esac
    ;;
  I386)
    case "$ot" in
      deb )
        sed -i '6c Architecture: i386' "../meterpreter/DEBIAN/control"
        build-deb
        ;;
    esac
    ;;
  All)
    case "$ot" in
      deb )
        sed -i '6c Architecture: all' "../meterpreter/DEBIAN/control"
        build-deb
        ;;
    esac
    ;;
esac
