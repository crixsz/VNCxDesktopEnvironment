generate_pass(){
    # Define the VNC server auth directory:
    VNC_AUTH_DIR="/root/.vnc"

    # Define the VNC server auth file:
    VNC_AUTH_FILE="passwd"

    VNC_PASSWORD="zoxxenon"
    # Generate the VNC password with expect:
expect << EOF
            spawn vncpasswd
            expect "Password:"
            send "${VNC_PASSWORD}\r"
            expect "Verify:"
            send "${VNC_PASSWORD}\r"
            expect "Would you like to enter a view-only password (y/n)?"
            send "n\r"
            expect eof
EOF
    chmod 600 "${VNC_AUTH_DIR}/${VNC_AUTH_FILE}"
    sleep 3
    clear 
    sleep 3
    echo "Starting VNC server process...."
    vncserver
    echo "Killing any VNC server process..."
    vncserver -kill :1
    mv ~/.vnc/xstartup ~/.vnc/xstartup.bak
    echo "mv ~/.vnc/xstartup ~/.vnc/xstartup.bak" >> ~/.vnc/xstartup
    chmod +x ~/.vnc/xstartup
    clear
    vncserver 
}
install(){
  echo "Installing the desktop environment..."
  apt update -y
  apt install xfce4 xfce4-goodies -y
  apt install tightvncserver -y
  clear
  sleep 3
  echo "Generating password for the VNC server"
  generate_pass
}


    if [ "$(id -u)" -eq 0 ]; then
    clear
    echo "[ VNC + DESKTOP ENVIRONMENT INSTALLER ]"
    echo ""
    echo "1) Install"
    echo "2) Uninstall"
    echo ""
    read choice
    echo ""
    case $choice in
        1)
        install 
        ;;
        2)
        uninstall
        ;;
        *)
        echo "Invalid choice. Please enter 1 or 2"
        ;;
    esac
else
  echo "This script requires root privileges. Please run it as root."
  exit 1
fi
