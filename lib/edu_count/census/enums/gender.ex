defmodule EduCount.Census.Enums.Gender do
  use Gettext, backend: EduCountWeb.Gettext

  use Ash.Type.Enum,
    values: [
      male: gettext("Male"),
      female: gettext("Female")
    ]
end
