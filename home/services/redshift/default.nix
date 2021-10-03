{
  services.redshift = {
    enable = true;
    provider = "manual";
    temperature.day = 6500;
    temperature.night = 2700;
    latitude = 41.00824;
    longitude = 28.978336;
  };
}
