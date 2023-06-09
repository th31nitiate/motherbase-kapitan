local kap = import "lib/kapitan.libjsonnet";
local inv = kap.inventory();


{
  provider: {
    google: {
      project: inv.parameters.name,
      version: inv.parameters.provider.google.version,
      region: inv.parameters.region,
      zone: inv.parameters.zone,
      credentials: "${file(\"~/.gcp/o3h-dev-cloud.json\")}",
    },
  },


  terraform: {
    backend: inv.parameters.terraform.backend,
  },

  assert
  std.startsWith(inv.parameters.zone, inv.parameters.region) :
    "zone and region don't match",

  assert
  std.objectHas(self, "provider") :
    "Provider is required. None defined",

  assert
  std.objectHas(self.provider.google, "version") :
    "Provider version is required",

  assert
  std.count(inv.parameters.valid_values.zones, self.provider.google.zone) == 1 :
    "zone " + self.provider.google.zone + " is invalid\n" +
    "valid zones are: " + inv.parameters.valid_values.zones,

}
