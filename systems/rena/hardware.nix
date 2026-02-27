{
  boot = {
    kernelModules = [ "kvm-amd" ];
    initrd = {
      availableKernelModules = [
        "nvme"
        "ahci"
      ];
      kernelModules = [ "dm-snapshot" ];
    };

    loader.grub = {
      enable = true;
      efiSupport = false;
    };
  };

  hardware = {
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;
  };
}
