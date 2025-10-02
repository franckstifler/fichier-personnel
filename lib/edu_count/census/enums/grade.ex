defmodule EduCount.Census.Enums.Grade do
  use Gettext, backend: EduCountWeb.Gettext

  use Ash.Type.Enum,
    values: [
      pceg: gettext("PCEG"),
      pcet: gettext("PCET"),
      pleg: gettext("PLEG"),
      plet: gettext("PLET")
    ]
end
