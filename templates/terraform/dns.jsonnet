local kap = import "lib/kapitan.libjsonnet";
local inv = kap.inventory();

{

  remove_dots(str)::
    assert std.type(str) == "string";
    std.join("", std.split(str, ".")),


  resource: {

    google_dns_record_set: {
      [$.remove_dots(zone + '_' + set.name + '_' + set.type + '_' + cluster)]: set {
        managed_zone: $.remove_dots(zone),
        name: set.name + "." + cluster + "." + "out3rheaven" + ".io.",
        rrdatas: [ "${" + set.rrdatas.name + "." + cluster + "." + set.rrdatas.endpoint  + "}" ],
      }
      for zone in std.objectFields(inv.parameters.resources.dns)
      for set in inv.parameters.resources.dns[zone]
      for cluster in std.objectFields(inv.parameters.resources.container)
      for ip in inv.parameters.resources.static_ip
    },
    google_compute_global_address: {
      [cluster]: set {
        name: $.remove_dots(cluster),
      }
      for set in inv.parameters.resources.static_ip
      for cluster in std.objectFields(inv.parameters.resources.container)
    },
  },



}
