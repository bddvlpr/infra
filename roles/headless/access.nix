{
  services.openssh = {
    enable = true;
    openFirewall = true;

    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
      UseDns = false;
      X11Forwarding = false;
    };
  };
}
