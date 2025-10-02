defmodule EduCount.Census.Enums.Language do
  use Gettext, backend: EduCountWeb.Gettext

  use Ash.Type.Enum,
    values: [
      english: gettext("English"),
      french: gettext("French")
    ]
end
