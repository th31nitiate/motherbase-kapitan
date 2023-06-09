local kap = import 'lib/kapitan.libjsonnet';
local inv = kap.inventory();

{

  remove_dots(str)::
    assert std.type(str) == 'string';
    std.join('', std.split(str, '.')),


  resource: {
    google_compute_instance: {
      [deployer]: set {
        name: deployer,
      }
      for deployer in std.objectFields(inv.parameters.resources.deployer)
      for set in inv.parameters.resources.deployer[deployer]
    },
  },


}
