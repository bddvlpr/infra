{
  users.users.bddvlpr = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEgZVPZ2+cqT1seskNMDRtb8x+W6XkJBl9w8ZkqzkWP8 bddvlpr@kiwi"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBtNqtIZtEaty6EAPwKQj5s0AxUfaJaCrQYeEaWFtqM/ bddvlpr@strawberry"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKdRlPLeVFbEwSszVTzYsN08c+k+jBYAzHJPLsKPm6Jg bddvlpr@lychee"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDQD+D84uxNORR9bqVYRe5d9rvpyBG/3n7WWOUWLT/oP bddvlpr@pear"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFtwlvpvW1/A+c8sHsRG8WXOVIwZIsOPXXpAghR2qvs3 bddvlpr@peach"
    ];
  };
}
