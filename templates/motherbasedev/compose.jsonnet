local kap = import "lib/kapitan.libjsonnet";
local inv = kap.inventory();
local compose_services = inv.parameters.compose.services;

{


  add_logging(service)::
  {
      "driver": inv.parameters.compose.logging.driver,
      "options": {
        "fluentd-address": inv.parameters.compose.logging.options.fluentd,
        "tag": "motherbase." + service,
      },
  },

  add_service()::
  {
      [service]: set {
          [if std.objectHas(compose_services, "logging") then "logging"]: if compose_services['services'][0].logging then $.add_logging(service),
          ["depends_on"]+: if "fluentd" == service then [] else if "elasticsearch" == service then [] else ["fluentd","elasticsearch"], 
      }
      for service in std.objectFields(compose_services)
      for set in compose_services[service]
  },
}


