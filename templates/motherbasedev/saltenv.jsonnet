local kap = import "lib/kapitan.libjsonnet";
local inv = kap.inventory();


{


  add_logging(service)::
  {
      "driver": inv.parameters.compose.logging.driver,
      "options": {
        "fluentd-address": inv.parameters.compose.logging.options.fluentd,
        "tag": "motherbase." + service,
      },
  },



      version: inv.parameters.compose.version,
    services: {

      [service]: set {
          [if std.objectHas(inv.parameters.compose.services.saltenv[service][0], "logging") then "logging"]: if inv.parameters.compose.services.saltenv[service][0].logging then $.add_logging(service),
          ["depends_on"]+: if "fluentd" == service then [] else if "elasticsearch" == service then [] else ["fluentd","elasticsearch"], 
      }
      for service in std.objectFields(inv.parameters.compose.services.saltenv)
      for set in inv.parameters.compose.services.saltenv[service]
    },
  }


