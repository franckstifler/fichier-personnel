defmodule EduCount.Census.Enums.Fonction do
  use Gettext, backend: EduCountWeb.Gettext

  use Ash.Type.Enum,
    values: [
      hod: gettext("Head of department"),
      teacher: gettext("Teacher")
    ]
end
