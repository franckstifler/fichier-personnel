defmodule EduCount.Census.Enums.MatrimonialStatus do
  use Gettext, backend: EduCountWeb.Gettext

  use Ash.Type.Enum,
    values: [
      single: gettext("Single"),
      married: gettext("Married"),
      divorced: gettext("Divorced"),
      widowed: gettext("Widowed")
    ]
end
